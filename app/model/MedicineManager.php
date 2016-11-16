<?php

namespace App\Model;

use Nette;

/**
* Medicine management
*/
class MedicineManager
{
	/** @var Nette\Database\Context */
	private $database;
	function __construct(Nette\Database\Context $database)
	{
		$this->database = $database;
	}


	public function getItemsCount()
	{
		return $this->database->table('liek')->count(); 
	}

	public function getContent($length, $offset)
	{
		return $this->database->table('liek')->limit($length, $offset);
	}

	public function getFirstTen()
	{
		return $this->database->table('liek')->limit(10);
	}
}