<?php

namespace App\Model;

use Nette;

/**
* Medicine management
*/
class CartManager
{
	private $table = "cart";
	/** @var Nette\Database\Context */
	private $database;
	function __construct(Nette\Database\Context $database)
	{
		$this->database = $database;
	}


	public function getUserCart($userID)
	{
		return $this->database->table($this->table)->where("user = ?", $userID); 
	}

	public function getContent($length, $offset, $userID)
	{
		return $this->database->table($this->table)->where("user = ?", $userID)->limit($length, $offset);
	}

	public function addToCart($sukl, $userID, $count)
	{
		try {
			$this->database->table($this->table)->insert([
					"user" => $userID,
					"medicine" => $sukl,
					"count" => $count
				]);
		} catch (Nette\Database\UniqueConstraintViolationException $e) {
			$cnt = $this->database->table($this->table)->where("user = ?", $userID)->where("medicine = ?", $sukl)->select("count");
			$this->database->table($this->table)->where("user = ?", $userID)->where("medicine = ?", $sukl)->update(array("count" => $cnt[0]->count + $count));
		}
	}
}