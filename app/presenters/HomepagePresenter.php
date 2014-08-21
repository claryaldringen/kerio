<?php

namespace App\Presenters;
use Nette\Application\UI\Form;

/**
 * Homepage presenter.
 */
class HomepagePresenter extends BasePresenter
{
	public function actionDefault($user, $product) {
		if(!empty($user)) {
			$session = $this->getSession('bugzilla');
			$session->userId = $this->context->general->getUserId($user);
			$session->productId = $this->context->general->getProductId($product);
			$this->redirect('this', array('user' => '', 'product' => ''));
		}
	}

	public function createComponentSprintForm() {
		$form = new Form($this, 'sprintForm');
		$form->addText('name', 'List name:')->addRule(Form::FILLED, 'Fill name of lis, please.');
		$form->addSelect('type', 'Type:', array('backlog' => 'Backlog', 'sprint' => 'Sprint'));
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
