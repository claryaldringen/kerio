<?php

namespace App\Presenters;

use Nette, App\Model;


class AjaxPresenter extends BasePresenter
{

	const STATUS_NEW = 2;

	public function renderLoadStories() {
		$this->template->data = json_encode(array('issues' => $this->context->backlog->getData($this->getSession('bugzilla')->productId)));
  }

	public function renderSaveStories() {
		$post = $this->getRequest()->getPost();
		$issuesToNew = $this->context->backlog->setData(json_decode($post['data']));
		foreach($issuesToNew as $bugId) {
			$this->context->scrumBoard->setStatus($bugId, self::STATUS_NEW, $this->getSession('bugzilla')->userId);
		}
		$this->context->scrumBoard->setEpicDone($this->getSession('bugzilla')->userId);
	}

	public function renderLoadScrumboard() {
		$this->getScrumboardData($this->getData()->id);
	}

	public function renderSaveScrumboard() {
		$data = $this->getData();
		$this->context->scrumBoard
			->setScrumStatus($data->ticketId, $data->statusId, $this->getSession('bugzilla')->userId)
			->setEpicDone($this->getSession('bugzilla')->userId);
		$this->getScrumboardData($data->id);
	}

	public function renderRenameList() {
		$data = $this->getData();
		$this->context->backlog->setName($data->id, $data->name);
	}

	public function renderSwitchType() {
		$data = $this->getData();
		$this->context->backlog->switchType($data->id);
	}

	public function renderDeleteList() {
		$data = $this->getData();
		$this->context->backlog->delete($data->id);
	}

	public function renderSaveAssign() {
		$data = $this->getData();
		$this->context->scrumBoard->assignTicket($data->ticketId, $data->userId);
	}

	public function renderLoadGeneral() {
		$session = $this->getSession('bugzilla');
		$this->template->userId = $session->userId;
		$this->template->productId = $session->productId;
	}

	public function renderToggle() {
		$data = $this->getData();
		$this->context->backlog->setOpened($data->id, $data->opened);
	}

	public function renderSavePoints() {
		$data = $this->getData();
		$this->context->backlog->setPoints($data->id, $data->points, $data->remains);
	}

	private function getData() {
		$post = $this->getRequest()->getPost();
		return json_decode($post['data']);
	}

	private function getScrumboardData($id) {
		$this->template->data = json_encode(array(
			'statuses' => $this->context->scrumBoard->getStatuses(),
			'users' => $this->context->scrumBoard->getUsers(),
			'stories' => $this->context->scrumBoard->getStories($id)
		));
	}
}
