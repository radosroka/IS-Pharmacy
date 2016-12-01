<?php

namespace App\Forms;

use Nette;
use Nette\Application\UI\Form;
use App\Model;
use Nette\Security\User;


class OrderFormFactory
{
	use Nette\SmartObject;

	/** @var FormFactory */
	private $factory;

	/** @var Model\OrderManager */
	private $orderManager;

	/** @var Model\CartManager */
	private $cartManager;

	/** @var \Nette\Security\User */
	private $user;


	public function __construct(User $user, FormFactory $factory, Model\OrderManager $orderManager, Model\CartManager $cartManager)
	{
		$this->factory = $factory;
		$this->orderManager = $orderManager;
		$this->cartManager = $cartManager;
		$this->user = $user;
	}


	/**
	 * @return Form
	 */
	public function create(callable $onSuccess)
	{
		$form = $this->factory->create();

		$form->addText('name', 'Meno príjemcu:')
			->setRequired('Prosím, vyplňte príjemcu.')
			->setAttribute('class', 'form-control');

		$form->addText('city', 'Mesto:')
			->setRequired('Prosím vyplňte mesto.')
			->setAttribute('class', 'form-control');

		$form->addText('street', 'Ulica:')
			->setRequired('Prosím, vyplňte ulicu.')
			->setAttribute('class', 'form-control');

		$form->addText('code', 'Poštový kód:')
			->setRequired('Prosím, vyplňte poštový kód.')
			->setAttribute('class', 'form-control');

		$form->addSubmit('submit', 'Ododslať objednávku')
			 ->setAttribute('class', 'btn btn-default');

		$form->onSuccess[] = function (Form $form, $values) use ($onSuccess) {
			try {
				$userID = $this->user->id;
				$cartIDs = $this->cartManager->getCartIdOfUser($userID);

				$this->orderManager->lockAddOrder();
				foreach ($cartIDs as $cartID) {
					$this->orderManager->addOrder($cartID->id, $values->name, $values->city, $values->street, $values->code);
				}
				$this->orderManager->unlockAddOrder();

			} catch (Model\DuplicateNameException $e) {
				$form->addError('Chyba vytvorenia objednávky.');
				return;
			}
			$onSuccess();
		};
		return $form;
	}

}
