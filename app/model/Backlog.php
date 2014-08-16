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
}