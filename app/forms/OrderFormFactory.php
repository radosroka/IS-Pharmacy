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

		$form->addUpload('prescription', 'Predpis:')
    		->setRequired(FALSE) // optional
    		->addRule(Form::IMAGE, 'Thubnail must be JPEG, PNG or GIF')
    		->addRule(Form::MAX_FILE_SIZE, 'Maximum file size is 64 kB.', 64 * 1024 * 1000 /* v bytech */);

		$form->addSubmit('submit', 'Odoslať objednávku')
			 ->setAttribute('class', 'btn btn-default');

		$form->onSuccess[] = function (Form $form, $values) use ($onSuccess) {
			try {
				$userID = $this->user->id;
				$cartIDs = $this->cartManager->getCartIdOfUser($userID);


				$file = $values->prescription;
  				// kontrola jestli se jedná o obrázek a jestli se nahrál dobře
  				if($file->isImage() and $file->isOk()) {
	   				// oddělení přípony pro účel změnit název souboru na co chceš se zachováním přípony
	    			$file_ext=strtolower(mb_substr($file->getSanitizedName(), strrpos($file->getSanitizedName(), ".")));
	    			// vygenerování náhodného řetězce znaků, můžeš použít i \Nette\Strings::random()
	    			$file_name = uniqid(rand(0,20), TRUE).$file_ext;
	    			// přesunutí souboru z temp složky někam, kam nahráváš soubory
	    			$file->move("images/uploads/" . $file_name);
	    			$file_name = "images/uploads/" . $file_name;
    			}
    			else {
    				$file_name = "";
    			}

				$this->orderManager->lockAddOrder();
				foreach ($cartIDs as $cartID) {
					$this->orderManager->addOrder($cartID->id, $values->name, $values->city, $values->street, $values->code, $file_name);
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
