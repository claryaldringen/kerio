<?php

namespace App\Presenters;
use Nette\Application\UI\Form;

/**
 * Homepage presenter.
 */
class HomepagePresenter extends BasePresenter
{
	public function actionDefault($user, $product) {
		$session = $this->getSession('bugzilla');
		if(!empty($user)) {
			$session->userId = $this->context->general->getUserId($user);
			$session->productId = $this->context->general->getProductId($product);
			$this->redirect('this', array('user' => '', 'product' => ''));
		}
		$this->context->backlog->balanceStories($session->productId);
	}

	public function createComponentSprintForm() {

		$milestones = $this->context->backlog->getMilestones($this->getSession('bugzilla')->productId);

		$form = new Form($this, 'sprintForm');
		$form->addText('name', 'List name:')->addRule(Form::FILLED, 'Fill name of lis, please.');
		$form->addSelect('type', 'Type:', array('backlog' => 'Backlog', 'sprint' => 'Sprint'));
		$form->addSelect('target_milestone', 'Milestone:', array('' => '') + $milestones);
		$form->addSubmit('create', 'Create List');
		$form->onSuccess[] = array($this, 'sprintFormSubmitted');
		return $form;
	}

	public function sprintFormSubmitted(Form $form) {
		$this->context->backlog->createList($form->getValues(), $this->getSession('bugzilla')->productId);
		$this->redirect('this');
	}

	public function renderScrumboard($id) {
		$this->template->id = $id;
	}
}
