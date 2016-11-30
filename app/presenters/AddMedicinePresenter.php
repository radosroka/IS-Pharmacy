<?php

namespace App\Presenters;

use Nette;
use App\Forms;


class AddMedicinePresenter extends BasePresenter
{
	/** @var Forms\AddMedicineFormFactory @inject */
	public $addMedicineFactory;


	/**
	 * AddMedicine form factory.
	 * @return Nette\Application\UI\Form
	 */
	protected function createComponentAddMedicineForm()
	{
		return $this->addMedicineFactory->create(function () {
			$this->redirect('Homepage:admin');
		});
	}

	public function actionOut()
	{
		$this->getUser()->logout();
	}

}