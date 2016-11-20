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
		return $this->database->table('medicine')->count(); 
	}

	public function getContent($length, $offset)
	{
		return $this->database->table('medicine')->limit($length, $offset);
	}

	public function getFirstTen()
	{
		return $this->database->table('medicine')->limit(10);
	}

	public function getSeekedItems($ref, $length, $offset)
	{
		return $this->database->query("SELECT * FROM medicine WHERE INSTR(name, ?) > ? LIMIT ? OFFSET ?", $ref, 0, $length, $offset);
	}

	public function getSeekedItemsCount($ref)
	{
		$data = $this->database->query("SELECT * FROM medicine WHERE INSTR(name, ?) > ?", $ref, 0);
		return $data->getRowCount();
	}
}