<?php

namespace App\Presenters;

use Nette;
use App\Model;


class AdminOrdersPresenter extends BasePresenter
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

	public function renderDefault($userID = 0, $userName)
	{
		$this->template->text = "Toto je administratorska stránka";
        if (!$this->getUser()->isInRole("admin"))
            $this->redirect("Admin:error");

        if ($userID != 0) {
            $this->template->orders = $this->orderManager->getOrdersOfUser($userID);
            $this->template->userName = $userName;
            $this->template->userID = $userID;
        } else {
            $this->template->orders = $this->orderManager->getAllOrders();
            $this->template->userName = "Vsetci";
            $this->template->userID = "***";
        }

        $this->template->orderManager = $this->orderManager;
	}

    public function handleOrder($id)
    {
        $this->orderManager->handleOrder($id);
    }

    public function renderError()
    {
        if (!$this->getUser()->isLoggedIn())
            $this->template->message = "Nie si prihlásený";
        else if (!$this->getUser()->isInRole("admin"))
            $this->template->message = "Toto je administrátorksa stránka, kam ty nemáš prístup";
        else
            $this->redirect("Admin:default");
    }
}