<?php

namespace App\Presenters;

use Nette;
use App\Model;


class FindItemsPresenter extends BasePresenter
{
    /** @var Model\MedicineManager */
    private $medicineManager;

    public function __construct(Model\MedicineManager $medicineManager)
    {
        $this->medicineManager = $medicineManager;
    }

	public function renderDefault($page = 1, $searchedText)
	{
        $textToFind = $searchedText;

        $perPage = 10;
	
        $paginator = new Nette\Utils\Paginator;
        
        $paginator->setItemCount($this->medicineManager->getSeekedItemsCount($textToFind)); // the total number of records (e.g., a number of products)
        $paginator->setItemsPerPage($perPage); // the number of records on page
        
        $paginator->setPage($page); // the number of the current page (numbered from one)

        $this->template->paginator = $paginator;
        $this->template->medicine = $this->medicineManager->getSeekedItems($textToFind, $paginator->getLength(), $paginator->getOffset());
    }
}
