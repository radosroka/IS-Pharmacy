<?php

namespace App\Presenters;

use Nette;
use App\Forms;


class SignPresenter extends BasePresenter
{
	/** @var Forms\SignInFormFactory @inject */
	public $signInFactory;

	/** @var Forms\SignUpFormFactory @inject */
	public $signUpFactory;


	/**
	 * Sign-in form factory.
	 * @return Nette\Application\UI\Form
	 */
	protected function createComponentSignInForm()
	{
		if ($this->getUser()->isInRole("employee") || $this->getUser()->isInRole("mainAdmin")) {
			return $this->signInFactory->create(function () {
				$this->redirect('Homepage:admin');
			});
		} else {
			return $this->signInFactory->create(function () {
				$this->redirect('Homepage:');
			});
		}
	}


	/**
	 * Sign-up form factory.
	 * @return Nette\Application\UI\Form
	 */
	protected function createComponentSignUpForm()
	{
		return $this->signUpFactory->create(function () {
			$this->redirect('Homepage:');
		});
	}


	public function actionOut()
	{
		$this->getUser()->logout();
	}

}
