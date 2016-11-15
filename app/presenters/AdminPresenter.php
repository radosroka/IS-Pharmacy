<?php

namespace App\Presenters;

use Nette;
use App\Model;


class AdminPresenter extends BasePresenter
{
	/** @var Nette\Database\Context */
    private $database;
    public function __construct(Nette\Database\Context $database)
    {
        $this->database = $database;
    }


	public function renderDefault()
	{
		$this->template->text = "Toto je administratorska stránka";
        if (!$this->getUser()->isInRole("admin"))
            $this->redirect("Admin:error");
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