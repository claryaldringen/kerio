<?php

namespace App\Presenters;

use Nette, App\Model;


class AjaxPresenter extends BasePresenter
{

	public function renderLoadStories() {
		$this->template->data = json_encode(array('issues' => $this->context->backlog->getData()));
  }

	public function renderSaveStories() {
		$post = $this->getRequest()->getPost();
		$this->context->backlog->setData(json_decode($post['data']));
	}

	public function renderLoadScrumboard() {
		$this->template->data = json_encode(array(
			'statuses' => $this->context->scrumBoard->getStatuses(),
			'stories' => $this->context->scrumBoard->getStories()
		));
	}

	public function renderSaveScrumboard() {
		$post = $this->getRequest()->getPost();
		$data = json_decode($post['data']);
		$this->context->scrumBoard->setStatus($data->ticketId, $data->statusId);
	}
}
