<?php

namespace App\Presenters;

use Nette;
use App\Model;


class OrderContentPresenter extends BasePresenter
{
	/** @var Nette\Database\Context */
    private $database;

    /** @var Model\CartManager */
    private $cartManager;
    /** @var Model\UserManager */
    private $userManager;
    /** @var Model\OrderManager */
    private $orderManager;

    public function __construct(Nette\Database\Context $database, Model\CartManager $cartManager, Model\UserManager $userManager, Model\OrderManager $orderManager)
    {
        $this->database = $database;
        $this->cartManager = $cartManager;
        $this->userManager = $userManager;
        $this->orderManager = $orderManager;
    }

	public function renderDefault($orderID)
	{
		$this->template->text = "Toto je administratorska stránka";
        if (!$this->getUser()->isInRole("admin") && !$this->getUser()->isInRole("mainAdmin"))
            $this->redirect("Admin:error");

        $this->template->orderID = $orderID;

        $this->template->goods = $this->orderManager->getOrderContent($orderID);
	}

    public function renderError()
    {
        if (!$this->getUser()->isLoggedIn())
            $this->template->message = "Nie si prihlásený";
        else if (!$this->getUser()->isInRole("admin") && !$this->getUser()->isInRole("mainAdmin"))
            $this->template->message = "Toto je administrátorksa stránka, kam ty nemáš prístup";
        else
            $this->redirect("Admin:default");
    }
}