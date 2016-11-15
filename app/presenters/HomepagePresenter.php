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

	public function renderDefault()
	{
		$this->template->medicine = $this->medicineManager->getFirstTen();
	}
}
