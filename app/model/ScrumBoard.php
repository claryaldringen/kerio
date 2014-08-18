<?php
/**
 * Created by PhpStorm.
 * User: clary
 * Date: 16.8.14
 * Time: 14:45
 */

namespace App\Model;


class ScrumBoard extends Model{

	public function getStatuses() {
		return $this->getStatusesObject()->fetchAll();
	}

	public function getStories($listId) {
		$sqlStories = "SELECT
			b.bug_id AS id,
			b.short_desc AS name,
			bf.comments AS description,
			bs.id AS status_id
			FROM bugs b
			JOIN bug_list bl ON bl.bug_id=b.bug_id AND bl.list_id=%i
			LEFT JOIN dependencies d ON b.bug_id=d.dependson
			LEFT JOIN bugs_fulltext bf ON bf.bug_id=b.bug_id
			JOIN bug_status bs ON bs.value=b.bug_status
			WHERE d.dependson IS NULL";

		$sqlTickets = "SELECT
			b.bug_id AS id,
			b.short_desc AS name,
			d.blocked,
			bs.id AS status_id
			FROM bugs b
			JOIN dependencies d ON b.bug_id=d.dependson
			JOIN bug_status bs ON bs.value=b.bug_status";

		$tickets = $this->db->query($sqlTickets)->fetchAssoc('blocked,#');

		$stories = $this->db->query($sqlStories, $listId)->fetchAll();
		foreach($stories as $key => $story) {
			if(!empty($tickets[$story->id])) $stories[$key]->tickets = $tickets[$story->id];
			else $stories[$key]->tickets = array($story->toArray());
		}
		return $stories;
	}

	public function setStatus($bugId, $statusId) {
		$statuses = $this->getStatusesObject()->fetchPairs();
		$this->db->query("UPDATE bugs SET bug_status=%s WHERE bug_id=%i", $statuses[$statusId], $bugId);
		return $this;
	}

	protected function getStatusesObject() {
		return $this->db->query("SELECT id,[value] AS name FROM bug_status WHERE isactive=1 ORDER BY is_open, sortkey");
	}
}