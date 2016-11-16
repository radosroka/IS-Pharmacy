<?php

namespace App\Presenters;

use Nette;
use App\Model;


class HomepagePresenter extends BasePresenter
{
    /** @var Model\MedicineManager */
    private $medicineManager;

    public function __construct(Model\MedicineManager $medicineManager)
    {
        $this->medicineManager = $medicineManager;
    }

	public function renderDefault($page = 1)
	{
        $perPage = 10;

        $itemsCount = $this->medicineManager->getItemsCount();
	
        $paginator = new Nette\Utils\Paginator;
        $paginator->setItemCount($itemsCount); // the total number of records (e.g., a number of products)
        $paginator->setItemsPerPage($perPage); // the number of records on page

        if ($page < 1 || $page > $paginator->getLastPage())
            $page = 1;
        
        $paginator->setPage($page); // the number of the current page (numbered from one)

        $this->template->paginator = $paginator;
	    $this->template->medicine = $this->medicineManager->getContent($paginator->getLength(), $paginator->getOffset());
    }
}
