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

	public function renderDefault()
	{
        if (!$this->getUser()->isLoggedIn())
            $this->redirect("Cart:error");
	   $this->template->items = $this->cartManager->getUserCart($this->getUser()->id);
            
    }

    public function renderError()
    {
       
        $this->template->message = "Error";
    }
}
