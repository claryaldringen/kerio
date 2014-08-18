<?php

namespace App\Presenters;
use Nette\Application\UI\Form;

/**
 * Homepage presenter.
 */
class HomepagePresenter extends BasePresenter
{
	public function createComponentSprintForm() {
		$form = new Form($this, 'sprintForm');
		$form->addText('name', 'List name:')->addRule(Form::FILLED, 'Fill name of lis, please.');
		$form->addSelect('type', 'Position:', array('left' => 'Left', 'right' => 'Right'));
		$form->addSubmit('create', 'Create List');
		$form->onSuccess[] = array($this, 'sprintFormSubmitted');
		return $form;
	}

	public function sprintFormSubmitted(Form $form) {
		$this->context->backlog->createList($form->getValues());
		$this->redirect('this');
	}

	public function renderScrumboard($id) {
		$this->template->id = $id;
	}
}
