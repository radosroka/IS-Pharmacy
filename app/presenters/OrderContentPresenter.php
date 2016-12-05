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

	public function renderDefault($orderID, $printOrder)
	{
        $userID = $this->orderManager->getUserOfOrder($orderID);
        if (!$this->getUser()->isLoggedIn() && !$this->getUser()->isInRole("employee") && !$this->getUser()->isInRole("mainAdmin"))
            $this->redirect("Admin:error");
        elseif ($this->getUser()->id != $userID && !$this->getUser()->isInRole("employee") && !$this->getUser()->isInRole("mainAdmin")) {
            $this->redirect("OrderContent:error");
        }

        $this->template->orderID = $orderID;
        $this->template->img = $this->orderManager->getImg($orderID);
        $this->template->sum = $this->orderManager->getSum($orderID);

        $this->template->goods = $this->orderManager->getOrderContent($orderID);
	}

    public function renderError()
    {
        if (!$this->getUser()->isLoggedIn())
            $this->template->message = "Nie si prihlásený";
        else if (!$this->getUser()->isInRole("employee") && !$this->getUser()->isInRole("mainAdmin"))
            $this->template->message = "Tu nemáš prístup";
        else
            $this->redirect("Homepage:default");
    }
}