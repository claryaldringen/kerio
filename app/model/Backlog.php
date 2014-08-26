<?php

namespace App\Model;

use Nette;


/**
 * Users management.
 */
class Backlog extends Model{

	/**
	 * Returns issues and other data for all lists (backlogs, sprints, etc.)
	 *
	 * @param $productId
	 * @return \DibiRow[]
	 */
	public function getData($productId) {

		$sql = "SELECT
				b.bug_id AS id,
				b.short_desc AS name,
				b.estimated_time AS points,
				b.remaining_time AS remains,
				l.id AS list_id,
				l.type AS list_type,
				l.name AS list_name,
				l.opened AS list_opened,
				l.target_milestone AS list_milestone,
				bs.id AS status_id,
				bl.sort_key AS priority,
				GROUP_CONCAT(d2.dependson) AS subtickets
			FROM bugs b
				JOIN bug_status bs ON bs.value=b.bug_status
				LEFT JOIN dependencies d ON dependson = b.bug_id
				LEFT JOIN dependencies d2 ON d2.blocked=b.bug_id
				JOIN bug_list bl ON bl.bug_id=b.bug_id
				RIGHT JOIN list l ON l.id=bl.list_id AND l.product_id=%i
			WHERE d.dependson IS NULL
			GROUP BY b.bug_id
			ORDER BY l.id DESC";

		$sql2 = "SELECT
				b.bug_id AS id,
				b.short_desc AS name,
				b.estimated_time AS points,
				b.remaining_time AS remains,
				bs.id AS status_id
			FROM bugs b
				JOIN bug_status bs ON bs.value=b.bug_status
			WHERE b.bug_id IN (%sql)";

		$rows = $this->db->query($sql, $productId)->fetchAll();
		foreach($rows as $key => $row) {
			if($row->subtickets) {
				$rows[$key]->subtickets = $this->db->query($sql2, $row->subtickets)->fetchAll();
			}
			$rows[$key]->list_sort_key = 1000 - $row->list_id;
		}
		return $rows;
	}

	/**
	 * Save issue list and priority into DB.
	 *
	 * @param array $issues
	 * @return array
	 */
	public function setData(array $issues) {
		$issuesToNew = array();
		foreach($issues as $issue) {
			if($issue->id) {
				$this->db->query("DELETE FROM [bug_list] WHERE bug_id=%i", $issue->id);
				$this->db->query("INSERT INTO [bug_list]", array('bug_id' => $issue->id, 'list_id' => $issue->list_id, 'sort_key' => $issue->priority));
				$type = $this->db->query("SELECT type FROM list WHERE id=%i", $issue->list_id)->fetchSingle();
				if($type == 'backlog') {
					$issuesToNew[] = $issue->id;
				}
			}
		}
		return $issuesToNew;
	}

	/**
	 * Creates new list (backlog, sprint, etc.).
	 *
	 * @param Nette\Utils\ArrayHash $values
	 * @param $productId
	 * @return $this
	 */
	public function createList(Nette\Utils\ArrayHash $values, $productId) {
		$values['product_id'] = $productId;
		$this->db->query("INSERT INTO list", $values);
		return $this;
	}

	/**
	 * Sets name of list.
	 *
	 * @param int $id ID of list
	 * @param string $name New name
	 * @return $this
	 */
	public function setName($id, $name) {
		$this->db->query('UPDATE list SET name=%s WHERE id=%i', $name, $id);
		return $this;
	}

	/**
	 * Switches type of list (sprint -> backlog, backlog -> sprint)
	 *
	 * @param int $id ID of list
	 * @return $this
	 */
	public function switchType($id) {
		$type = $this->db->query('SELECT [type] FROM list WHERE id=%i', $id)->fetchSingle();
		if($type == 'sprint') $type = 'backlog';
		else $type = 'sprint';
		$this->db->query('UPDATE list SET type=%s WHERE id=%i', $type, $id);
		return $this;
	}

	/**
	 * Deletes list.
	 *
	 * @param int $id ID of list
	 * @return $this
	 */
	public function delete($id) {
		$this->db->query('DELETE FROM list WHERE id=%i', $id);

		$sql = "SELECT b.bug_id FROM bugs b
			LEFT JOIN bug_list bl ON bl.bug_id=b.bug_id
			LEFT JOIN dependencies d ON d.dependson=b.bug_id
			WHERE bl.bug_id IS NULL AND d.dependson IS NULL";

		$unassigned = $this->db->query($sql)->fetchPairs(null, 'bug_id');
		if(!empty($unassigned)) {
			$insert = array();
			foreach($unassigned as $bugId) {
				$insert[] = '(1,' . $bugId .')';
			}
			$sql = "INSERT INTO bug_list (list_id,bug_id) VALUES " . implode(',', $insert);
			$this->db->query($sql);
		}

		return $this;
	}

	/**
	 * Moves user stories without list into list by defined by target milestone.
	 *
	 * @param $productId
	 * @return $this
	 */
	public function balanceStories($productId) {
		$sql = "SELECT b.bug_id,b.target_milestone FROM bugs b
				LEFT JOIN bug_list bl ON b.bug_id=bl.bug_id
				LEFT JOIN list l ON bl.list_id=l.id
				LEFT JOIN dependencies d ON dependson = b.bug_id
				WHERE l.id IS NULL AND d.dependson IS NULL";

		$stories = $this->db->query($sql)->fetchPairs();

		$lists = $this->db->query("SELECT id,target_milestone FROM list WHERE target_milestone IN %in AND product_id=%i", $stories, $productId)->fetchPairs();

		foreach($stories as $bugId => $bugMilestone) {
				foreach($lists as $listId => $listMilestone) {
					if($bugMilestone == $listMilestone) {
						$this->db->query("INSERT INTO [bug_list] ", array('bug_id' => $bugId, 'list_id' => $listId));
						break;
					}
				}
		}
		return $this;
	}

	/**
	 * Return all target milestones of all bugs from product.
	 *
	 * @param $productId
	 * @return array
	 */
	public function getMilestones($productId) {
		$sql = "SELECT target_milestone FROM bugs WHERE product_id=%i AND target_milestone != '---' GROUP BY target_milestone";
		return $this->db->query($sql, $productId)->fetchPairs('target_milestone', 'target_milestone');
	}

	/**
	 * Sets if list is open.
	 *
	 * @param int $listId
	 * @param bool $opened
	 * @return $this
	 */
	public function setOpened($listId, $opened) {
		$this->db->query("UPDATE list SET opened=%i WHERE id=%i", (int)$opened, $listId);
		return $this;
	}

	/**
	 * Set points (estimated time) to ticket (bug).
	 *
	 * @param int $id Ticket id
	 * @param float $points Count of estimated scrum points
	 * @param float $remains Count of remaining scrum points
	 * @return $this
	 */
	public function setPoints($id, $points, $remains) {
		$this->db->query("UPDATE bugs SET estimated_time=%f,remaining_time=%f WHERE bug_id=%i", $points, $remains, $id);
		return $this;
	}
}