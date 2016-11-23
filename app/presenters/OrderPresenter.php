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
		return $this->orderFactory->create(function () {
			$this->redirect('Homepage:');
		});
	}

	public function actionOut()
	{
		$this->getUser()->logout();
	}

}