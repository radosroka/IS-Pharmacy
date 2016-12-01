<?php

namespace App\Forms;

use Nette;
use Nette\Application\UI\Form;
use Nette\Security\User;


class SignInFormFactory
{
	use Nette\SmartObject;

	/** @var FormFactory */
	private $factory;

	/** @var User */
	private $user;


	public function __construct(FormFactory $factory, User $user)
	{
		$this->factory = $factory;
		$this->user = $user;
	}


	/**
	 * @return Form
	 */
	public function create(callable $onSuccess)
	{
		$form = $this->factory->create();
		$form->addText('username', 'Prihlasovacie meno:')
			->setRequired('Prosím, vyplňte prihlasovacie meno.')
			->setAttribute('class', 'form-control');

		$form->addPassword('password', 'Heslo:')
			->setRequired('Prosím zadajte prihlasovacie heslo.')
			->setAttribute('class', 'form-control');

		$form->addCheckbox('remember', '	Prihásiť natrvalo?');

		$form->addSubmit('submit', 'Prihlásiť')
			 ->setAttribute('class', 'btn btn-default');

		$form->onSuccess[] = function (Form $form, $values) use ($onSuccess) {
			try {
				$this->user->setExpiration($values->remember ? '14 days' : '2 minutes');
				$this->user->login($values->username, $values->password);
			} catch (Nette\Security\AuthenticationException $e) {
				$form->addError('Meno alebo heslo je nesprávne');
				return;
			}
			$onSuccess();
		};
		return $form;
	}

}
