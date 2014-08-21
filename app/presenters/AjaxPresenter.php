<?php

namespace App\Presenters;

use Nette, App\Model;


class AjaxPresenter extends BasePresenter
{

	public function renderLoadStories() {
		$this->template->data = json_encode(array('issues' => $this->context->backlog->getData($this->getSession('bugzilla')->productId)));
  }

	public function renderSaveStories() {
		$post = $this->getRequest()->getPost();
		$this->context->backlog->setData(json_decode($post['data']));
	}

	public function renderLoadScrumboard() {
		$data = $this->getData();
		$this->template->data = json_encode(array(
			'statuses' => $this->context->scrumBoard->getStatuses(),
			'users' => $this->context->scrumBoard->getUsers(),
			'stories' => $this->context->scrumBoard->getStories($data->id)
		));
	}

	public function renderSaveScrumboard() {
		$data = $this->getData();
		$this->context->scrumBoard->setStatus($data->ticketId, $data->statusId);
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

	private function getData() {
		$post = $this->getRequest()->getPost();
		return json_decode($post['data']);
	}
}
