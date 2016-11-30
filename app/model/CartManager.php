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
		return $this->database->table($this->table)->where("user = ?", $userID)->where("ordered = 0"); 
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
					"count" => $count,
					"ordered" => 0
				]);
		} catch (Nette\Database\UniqueConstraintViolationException $e) {
			$cnt = $this->database->table($this->table)->where("user = ?", $userID)->where("medicine = ?", $sukl)->select("count");
			$this->database->table($this->table)->where("user = ?", $userID)->where("medicine = ?", $sukl)->update(array("count" => $cnt[0]->count + $count));
		}
	}

	public function getCartIdOfUser($userID)
	{
		$data = $this->database->query("SELECT id FROM cart WHERE user = ?  AND ordered = 0", $userID);
		$this->database->query("UPDATE cart SET ordered=1 WHERE user = ?  AND ordered = 0", $userID);
		return $data;
	}

	public function deleteItem($item, $userID)
	{
		$cartID = $this->database->table('cart')->where('user = ?', $userID)->where('ordered = 0')->where('medicine = ?', $item)->max('id');
		$this->database->query("DELETE FROM cart WHERE user = ? AND ordered = 0 AND medicine = ? AND id = ?", $userID, $item, $cartID);
	}
}