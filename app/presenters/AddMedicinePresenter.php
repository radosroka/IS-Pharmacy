<?php

namespace App\Presenters;

use Nette;
use App\Forms;


class AddMedicinePresenter extends BasePresenter
{
	/** @var Forms\AddMedicineFormFactory @inject */
	public $addMedicineFactory;

	public function renderDefault() {
		if (!$this->getUser()->isInRole("employee") && !$this->getUser()->isInRole("mainAdmin"))
            $this->redirect("Admin:error");
	}

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