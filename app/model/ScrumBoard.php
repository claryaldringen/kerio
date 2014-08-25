<?php
/**
 * Created by PhpStorm.
 * User: clary
 * Date: 16.8.14
 * Time: 14:45
 */

namespace App\Model;


class ScrumBoard extends Model{

	const STATUS_NEW = 2;
	const STATUS_ASSIGNED = 3;
	const STATUS_RESOLVED = 4;

	public function getStatuses() {
		return $this->db->query("SELECT id,name FROM scrum_status")->fetchAll();
	}

	public function getStories($listId) {
		$sqlStories = "SELECT
			b.bug_id AS id,
			b.short_desc AS name,
			b.assigned_to AS owner,
			l.thetext AS description,
			scrum_status AS status_id
			FROM bugs b
			JOIN bug_list bl ON bl.bug_id=b.bug_id AND bl.list_id=%i
			LEFT JOIN dependencies d ON b.bug_id=d.dependson
			LEFT JOIN longdescs l ON l.bug_id=b.bug_id
			JOIN bug_status bs ON bs.value=b.bug_status
			JOIN bug_status_has_scrum_status bshss ON bshss.bug_status=bs.id
			WHERE d.dependson IS NULL
			ORDER BY bl.sort_key";

		$sqlTickets = "SELECT
			b.bug_id AS id,
			b.short_desc AS name,
			d.blocked,
			b.assigned_to AS owner,
			scrum_status AS status_id
			FROM bugs b
			JOIN dependencies d ON b.bug_id=d.dependson
			JOIN bug_status bs ON bs.value=b.bug_status
			JOIN bug_status_has_scrum_status bshss ON bshss.bug_status=bs.id";

		$tickets = $this->db->query($sqlTickets)->fetchAssoc('blocked,#');

		$stories = $this->db->query($sqlStories, $listId)->fetchAll();
		foreach($stories as $key => $story) {
			if(!empty($tickets[$story->id])) $stories[$key]->tickets = $tickets[$story->id];
			else $stories[$key]->tickets = array($story->toArray());
		}
		return $stories;
	}

	public function getUsers() {
		$rows = $this->db->query('SELECT userid AS id, realname AS name FROM profiles')->fetchAll();
		foreach($rows as $i => $row) {
			$rows[$i]->color = '#' . substr(md5($row->name), 0, 6);
		}
		return $rows;
	}

	public function setStatus($bugId, $statusId, $userId) {
		$sql = "assigned_to=assigned_to";
		if($statusId == self::STATUS_ASSIGNED) {
			$sql = "assigned_to=" . $userId;
		}
		$statuses = $this->getStatusesObject()->fetchPairs();
		$this->db->query("UPDATE bugs SET bug_status=%s,%sql WHERE bug_id=%i", $statuses[$statusId], $sql, $bugId);
		return $this;
	}

	public function setEpicDone($userId) {
		$epics = array();
		$rows = $this->db->query("SELECT blocked AS id,bug_status FROM dependencies d JOIN bugs b ON d.dependson=b.bug_id")->fetchAll();
		foreach($rows as $row) {
			if(!isset($epics[$row->id])) $epics[$row->id] = self::STATUS_RESOLVED;
			if(!in_array($row->bug_status, array('RESOLVED','VERIFIED'))) $epics[$row->id] = self::STATUS_NEW;
		}

		foreach($epics as $bugId => $statusId) {
			$this->setStatus($bugId, $statusId, $userId);
		}
		return $this;
	}

	public function setScrumStatus($bugId, $statusId, $userId) {
		$statusId = $this->db->query("SELECT bug_status FROM bug_status_has_scrum_status WHERE scrum_status=%i LIMIT 1", $statusId)->fetchSingle();
		return $this->setStatus($bugId, $statusId, $userId);
	}

	public function assignTicket($ticketId, $userId) {
		$this->db->query("UPDATE bugs SET assigned_to=%i,bug_status='ASSIGNED' WHERE bug_id=%i", $userId, $ticketId);
		return $this;
	}

	protected function getStatusesObject() {
		return $this->db->query("SELECT id,[value] AS name FROM bug_status WHERE isactive=1 ORDER BY is_open, sortkey");
	}
}