<?php

namespace App\Forms;

use Nette;
use Nette\Application\UI\Form;
use App\Model;
use Nette\Security\User;


class AddMedicineFormFactory
{
	use Nette\SmartObject;

	/** @var FormFactory */
	private $factory;

	/** @var Model\MedicineManager */
	private $medicineManager;


	public function __construct(User $user, FormFactory $factory, Model\MedicineManager $medicineManager)
	{
		$this->factory = $factory;
		$this->medicineManager = $medicineManager;
	}


	/**
	 * @return Form
	 */
	public function create(callable $onSuccess)
	{
		$form = $this->factory->create();

		$form->addText('name', 'Medicine name:')
			->setRequired('Please fill name.')
			->setAttribute('class', 'form-control');

		$form->addText('producer', 'Producer:')
			->setRequired('Please fill producer.')
			->setAttribute('class', 'form-control');

		$form->addText('distributor', 'Distributor:')
			->setRequired('Please fill distributor.')
			->setAttribute('class', 'form-control');

		$form->addText('price', 'Price:')
			->setRequired('Please fill price.')
			->setAttribute('class', 'form-control');

		$form->addCheckbox('prescription', 'Prescription needed?');

		$form->addSubmit('submit', 'Add medicine')
			 ->setAttribute('class', 'btn btn-default');

		$form->onSuccess[] = function (Form $form, $values) use ($onSuccess) {
		try {
				$this->medicineManager->addMedicine($values->name, $values->producer, $values->distributor, $values->price, $values->prescription);
			} catch (Model\DuplicateNameException $e) {
				$form->addError('Error creating order.');
				return;
			}
			$onSuccess();
		};
		return $form;
	}

}
