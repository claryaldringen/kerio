<?php

namespace App\Presenters;

use Nette, App\Model;


class AjaxPresenter extends BasePresenter
{
	
	public function renderLoadStories() {
		$this->template->foo = $this->context->backlog->getData();
  }
}
