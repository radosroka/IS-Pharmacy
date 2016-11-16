<?php

namespace App\Presenters;

use Nette;
use App\Model;


class CartPresenter extends BasePresenter
{
    /** @var Model\MedicineManager */


    public function __construct()
    {
    }

	public function renderDefault()
	{
        if (!$this->getUser()->isLoggedIn())
            $this->redirect("Cart:error");
	   $this->template->message = "Cart";
            
    }

    public function renderError()
    {
       
        $this->template->message = "Error";
    }
}
