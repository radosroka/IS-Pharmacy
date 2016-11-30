<?php

namespace App\Presenters;

use Nette;
use App\Model;


class CartPresenter extends BasePresenter
{
    /** @var Model\MedicineManager */
    private $cartManager;

    public function __construct(Model\CartManager $cartManager)
    {
        $this->cartManager = $cartManager;
    }

	public function renderDefault($deleteItem = " ")
	{
        if (!$this->getUser()->isLoggedIn())
            $this->redirect("Cart:error");

        $userID = $this->getUser()->id;

        if ($deleteItem != " ")
            $this->cartManager->deleteItem($deleteItem, $userID);

        $this->template->items = $this->cartManager->getUserCart($userID);
            
    }

    public function renderError()
    {
       
        $this->template->message = "Error";
    }
}
