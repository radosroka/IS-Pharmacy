<?php

namespace App\Presenters;

use Nette;
use App\Forms;


class OrderPresenter extends BasePresenter
{
	/** @var Forms\OrderFormFactory @inject */
	public $orderFactory;


	/**
	 * Order form factory.
	 * @return Nette\Application\UI\Form
	 */
	protected function createComponentOrderForm()
	{
		if (!$this->getUser()->isLoggedIn())
            $this->redirect("Admin:error");
        
		return $this->orderFactory->create(function () {
			$this->redirect('Homepage:default');
		});
	}

	public function actionOut()
	{
		$this->getUser()->logout();
	}

}