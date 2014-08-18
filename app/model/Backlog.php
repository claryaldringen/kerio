<?php

namespace App\Model;

use Nette;


/**
 * Users management.
 */
class Backlog extends Model{

	public function getData() {

		$sql = "SELECT
			b.bug_id AS id,
			b.short_desc AS name,
			l.id AS list_id,
			l.type AS list_type,
			l.name AS list_name,
			bl.sort_key AS priority
			FROM bugs b
			LEFT JOIN dependencies d ON dependson = b.bug_id
			JOIN bug_list bl ON bl.bug_id=b.bug_id
			RIGHT JOIN list l ON l.id=bl.list_id
			WHERE d.dependson IS NULL
			ORDER BY l.id DESC";

		 return $this->db->query($sql)->fetchAll();
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

	public function createList(Nette\Utils\ArrayHash $values) {
		$this->db->query("INSERT INTO list", $values);
		return $this;
	}

	public function setName($id, $name) {
		$this->db->query('UPDATE list SET name=%s WHERE id=%i', $name, $id);
		return $this;
	}

	public function switchType($id) {
		$type = $this->db->query('SELECT [type] FROM list WHERE id=%i', $id)->fetchSingle();
		if($type == 'left') $type = 'right';
		else $type = 'left';
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