<?php

namespace App\Presenters;

use Nette;
use App\Model;


class HomepagePresenter extends BasePresenter
{
    /** @var Model\MedicineManager */
    private $medicineManager;
    private $cartManager;

    public function __construct(Model\MedicineManager $medicineManager, Model\CartManager $cartManager)
    {
        $this->medicineManager = $medicineManager;
        $this->cartManager = $cartManager;
    }

	public function renderDefault($page = 1, $sukl = "", $deleteMedicine = 0)
	{
        $perPage = 5;

        $itemsCount = $this->medicineManager->getItemsCount();
	
        $paginator = new Nette\Utils\Paginator;
        $paginator->setItemCount($itemsCount); // the total number of records (e.g., a number of products)
        $paginator->setItemsPerPage($perPage); // the number of records on page

        if ($page < 1 || $page > $paginator->getLastPage())
            $page = 1;
        
        $paginator->setPage($page); // the number of the current page (numbered from one)

        if ($deleteMedicine)
            $this->medicineManager->deleteMedicine($deleteMedicine);

        if (!$this->getUser()->isInRole("employee") && !$this->getUser()->isInRole("mainAdmin") && $sukl != "" && $this->getUser()->isLoggedIn()) {
            $this->cartManager->addToCart($sukl, $this->getUser()->id, 1);
        }

        if ($this->getUser()->isInRole("employee") || $this->getUser()->isInRole("mainAdmin"))
            $this->template->isCustomer = 0;
        else
            $this->template->isCustomer = 1;
        
        $this->template->paginator = $paginator;
	    $this->template->medicine = $this->medicineManager->getContent($paginator->getLength(), $paginator->getOffset());
    }

    public function renderAdmin($page = 1, $sukl = "", $deleteMedicine = 0)
    {
        if (!$this->getUser()->isInRole("employee") && !$this->getUser()->isInRole("mainAdmin"))
            $this->redirect("Admin:error");
        else 
            $this->renderDefault($page, $sukl, $deleteMedicine);
    }
}
