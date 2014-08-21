<?php

namespace App\Model;

use Nette;


/**
 * Users management.
 */
class Backlog extends Model{

	public function getData($productId) {

		$sql = "SELECT
			b.bug_id AS id,
			b.short_desc AS name,
			l.id AS list_id,
			l.type AS list_type,
			l.name AS list_name,
			bs.id AS status_id,
			bl.sort_key AS priority
			FROM bugs b
			JOIN bug_status ON bs.value=b.bug_status
			LEFT JOIN dependencies d ON dependson = b.bug_id
			JOIN bug_list bl ON bl.bug_id=b.bug_id
			RIGHT JOIN list l ON l.id=bl.list_id AND l.product_id=%i
			WHERE d.dependson IS NULL
			ORDER BY l.id DESC";

		 return $this->db->query($sql, $productId)->fetchAll();
	}

	public function setData(array $issues) {
		foreach($issues as $issue) {
			if($issue->id) {
				$this->db->query("DELETE FROM [bug_list] WHERE bug_id=%i", $issue->id);
				$this->db->query("INSERT INTO [bug_list]", array('bug_id' => $issue->id, 'list_id' => $issue->list_id, 'sort_key' => $issue->priority));
			}
		}
		return $this;
	}

	public function createList(Nette\Utils\ArrayHash $values, $productId) {
		$values['product_id'] = $productId;
		$this->db->query("INSERT INTO list", $values);

		//Prijde jinam - bude se provadet po nacteni stranky
		if($values['type'] == 'backlog') {
			$this->db->query("SELECT id FROM bugs WHERE target_milestone != '---' AND product_id=%i", $productId);
		}

		return $this;
	}

	public function setName($id, $name) {
		$this->db->query('UPDATE list SET name=%s WHERE id=%i', $name, $id);
		return $this;
	}

	public function switchType($id) {
		$type = $this->db->query('SELECT [type] FROM list WHERE id=%i', $id)->fetchSingle();
		if($type == 'sprint') $type = 'backlog';
		else $type = 'sprint';
		$this->db->query('UPDATE list SET type=%s WHERE id=%i', $type, $id);
		return $this;
	}

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
}