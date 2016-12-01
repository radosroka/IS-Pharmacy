<?php

namespace App\Forms;

use Nette;
use Nette\Application\UI\Form;
use App\Model;


class SignUpFormFactory
{
	use Nette\SmartObject;

	const PASSWORD_MIN_LENGTH = 7;

	/** @var FormFactory */
	private $factory;

	/** @var Model\UserManager */
	private $userManager;


	public function __construct(FormFactory $factory, Model\UserManager $userManager)
	{
		$this->factory = $factory;
		$this->userManager = $userManager;
	}


	/**
	 * @return Form
	 */
	public function create(callable $onSuccess)
	{
		$form = $this->factory->create();
		$form->addText('username', 'Užívateské meno:')
			->setRequired('Prosím, vyberte si užívateľské meno.')
			->setAttribute('class', 'form-control');

		$form->addText('email', 'Email:')
			->setRequired('Prosím, vyberte si email.')
			->addRule($form::EMAIL)
			->setAttribute('class', 'form-control');

		$form->addPassword('password', 'Nové heslo:')
			->setOption('description', sprintf('at least %d characters', self::PASSWORD_MIN_LENGTH))
			->setRequired('Please create a password.')
			->addRule($form::MIN_LENGTH, NULL, self::PASSWORD_MIN_LENGTH)
			->setAttribute('class', 'form-control');

		$form->addSubmit('send', 'Registrovať')
			 ->setAttribute('class', 'btn btn-default');

		$form->onSuccess[] = function (Form $form, $values) use ($onSuccess) {
			try {
				$this->userManager->add($values->username, $values->email, $values->password);
			} catch (Model\DuplicateNameException $e) {
				$form->addError('Toto meno je už obsadené.');
				return;
			}
			$onSuccess();
		};
		return $form;
	}

}
