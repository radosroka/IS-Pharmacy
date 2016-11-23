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

		$form->addText('name', 'Receivent name:')
			->setRequired('Please fill receivent.')
			->setAttribute('class', 'form-control');

		$form->addText('city', 'City:')
			->setRequired('Please fill City.')
			->setAttribute('class', 'form-control');

		$form->addText('street', 'Street:')
			->setRequired('Please fill street.')
			->setAttribute('class', 'form-control');

		$form->addText('code', 'Postal code:')
			->setRequired('Please fill postal code.')
			->setAttribute('class', 'form-control');

		$form->addSubmit('submit', 'Submit Order')
			 ->setAttribute('class', 'btn btn-default');

		$form->onSuccess[] = function (Form $form, $values) use ($onSuccess) {
			try {
				$userID = $this->user->id;
				$cartID = $this->cartManager->getCartIdOfUser($userID);

				$this->orderManager->addOrder($cartID, $values->name, $values->city, $values->street, $values->code);
			} catch (Model\DuplicateNameException $e) {
				$form->addError('Error creating order.');
				return;
			}
			$onSuccess();
		};
		return $form;
	}

}
