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
        elseif ($this->getUser()->id != $userID) {
            $this->redirect("OrderContent:error");
        }

        $this->template->orderID = $orderID;
        $this->template->img = $this->orderManager->getImg($orderID);

        if ($printOrder) {
            require('fpdf.php');
            $p = PDF_new();
            /*  open new PDF file; insert a file name to create the PDF on disk */
            if (PDF_begin_document($p, "", "") == 0) {
                die("Error: " . PDF_get_errmsg($p));
            }

            PDF_set_info($p, "Creator", "hello.php");
            PDF_set_info($p, "Author", "Rainer Schaaf");
            PDF_set_info($p, "Title", "Hello world (PHP)!");

            PDF_begin_page_ext($p, 595, 842, "");

            $font = PDF_load_font($p, "Helvetica-Bold", "winansi", "");

            PDF_setfont($p, $font, 24.0);
            PDF_set_text_pos($p, 50, 700);
            PDF_show($p, "Hello world!");
            PDF_continue_text($p, "(says PHP)");
            PDF_end_page_ext($p, "");

            PDF_end_document($p, "");

            $buf = PDF_get_buffer($p);
            $len = strlen($buf);

            header("Content-type: application/pdf");
            header("Content-Length: $len");
            header("Content-Disposition: inline; filename=hello.pdf");
            print $buf;

            PDF_delete($p);
        }

        $this->template->goods = $this->orderManager->getOrderContent($orderID);
	}

    public function renderError()
    {
        if (!$this->getUser()->isLoggedIn())
            $this->template->message = "Nie si prihlásený";
        else if (!$this->getUser()->isInRole("employee") && !$this->getUser()->isInRole("mainAdmin"))
            $this->template->message = "Tu nemáš prístup";
        else
            $this->redirect("Hompage:default");
    }
}