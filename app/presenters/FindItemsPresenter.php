<?php

namespace App\Presenters;

use Nette;
use App\Model;


class FindItemsPresenter extends BasePresenter
{
    /** @var Model\MedicineManager */
    private $medicineManager;
    private $cartManager;

    public function __construct(Model\MedicineManager $medicineManager, Model\CartManager $cartManager)
    {
        $this->medicineManager = $medicineManager;
        $this->cartManager = $cartManager;
    }

	public function renderDefault($page = 1, $searchedText, $sukl = "", $deleteMedicine = 0)
	{
        $textToFind = $searchedText;

        $perPage = 5;
	
        $paginator = new Nette\Utils\Paginator;
        
        $paginator->setItemCount($this->medicineManager->getSeekedItemsCount($textToFind)); // the total number of records (e.g., a number of products)
        $paginator->setItemsPerPage($perPage); // the number of records on page
        
        $paginator->setPage($page); // the number of the current page (numbered from one)

        if ($deleteMedicine)
            $this->medicineManager->deleteMedicine($deleteMedicine);

        if (!$this->getUser()->isInRole("employee") && !$this->getUser()->isInRole("mainAdmin") && $sukl != "" && $this->getUser()->isLoggedIn()) {
            $this->cartManager->addToCart($sukl, $this->getUser()->id, 1);
        }

        $this->template->paginator = $paginator;
        $this->template->medicine = $this->medicineManager->getSeekedItems($textToFind, $paginator->getLength(), $paginator->getOffset());
    }

    public function renderAdmin($page = 1, $sukl = "", $deleteMedicine = 0)
    {
        if (!$this->getUser()->isInRole("employee") && !$this->getUser()->isInRole("mainAdmin"))
            $this->redirect("Admin:error");
        else 
            $this->renderDefault($page, $sukl, $deleteMedicine);
    }
}
