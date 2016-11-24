<?php

namespace App\Presenters;

use Nette;
use App\Model;


class AdminPresenter extends BasePresenter
{
	/** @var Nette\Database\Context */
    private $database;

    /** @var Model\CartManager */
    private $cartManager;
    /** @var Model\UserManager */
    private $userManager;

    public function __construct(Nette\Database\Context $database, Model\CartManager $cartManager, Model\UserManager $userManager)
    {
        $this->database = $database;
        $this->cartManager = $cartManager;
        $this->userManager = $userManager;
    }


	public function renderDefault($page = 1)
	{
		$this->template->text = "Toto je administratorska stránka";
        if (!$this->getUser()->isInRole("admin"))
            $this->redirect("Admin:error");

        $perPage = 10;
        $paginator = new Nette\Utils\Paginator;

        $paginator->setItemCount($this->userManager->getUsersCount());
        $paginator->setItemsPerPage($perPage);
        $paginator->setPage($page);

        $this->template->paginator = $paginator;

        $this->template->users = $this->userManager->getUsers($paginator->getLength(), $paginator->getOffset());
	}

    public function renderError()
    {
        if (!$this->getUser()->isLoggedIn())
            $this->template->message = "Niesi prihlásený";
        else if (!$this->getUser()->isInRole("admin"))
            $this->template->message = "Toto je administrátorksa stránka, kam ty nemáš prístup";
        else
            $this->redirect("Admin:default");
    }
}