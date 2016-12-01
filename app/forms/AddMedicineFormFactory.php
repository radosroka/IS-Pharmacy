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

		$form->addText('name', 'Názov lieku:')
			->setRequired('Prosím, vyplňte meno.')
			->setAttribute('class', 'form-control');

		$form->addText('producer', 'Dodávateľ:')
			->setRequired('Prosím, vyplňte dodávateľa.')
			->setAttribute('class', 'form-control');

		$form->addText('distributor', 'Distribútor:')
			->setRequired('Prosím, vyplňte distribútora.')
			->setAttribute('class', 'form-control');

		$form->addText('price', 'Cena:')
			->setRequired('Prosím, vyplňte cenu.')
			->setAttribute('class', 'form-control');

		$form->addCheckbox('prescription', 'Na predpis?');

		$form->addSubmit('submit', 'Pridať Liek.')
			 ->setAttribute('class', 'btn btn-default');

		$form->onSuccess[] = function (Form $form, $values) use ($onSuccess) {
		try {
				$this->medicineManager->addMedicine($values->name, $values->producer, $values->distributor, $values->price, $values->prescription);
			} catch (Model\DuplicateNameException $e) {
				$form->addError('Chyba nieje možné pridať liek.');
				return;
			}
			$onSuccess();
		};
		return $form;
	}

}
