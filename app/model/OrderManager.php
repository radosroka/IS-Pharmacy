<?php

namespace App\Model;

use Nette;

/**
 * Order formular management
 */
class OrderManager
{
	use Nette\SmartObject;

	const
		TABLE_NAME = 'orders',
		COLUMN_ID_ORDER = 'id_order',
		COLUMN_ID_USER = 'id_user';

	/** @var Nette\Database\Context */
	private $database;

	public function __construct(Nette\Database\Context $database)
	{
		$this->database = $database;
	}

	public function lockAddOrder()
	{
		$this->database->query("LOCK TABLES orders_auto_increment WRITE, orders WRITE, prescription WRITE");
		$this->database->table('orders_auto_increment')->insert([
			"value" => 1
			]);
	}

	public function unlockAddOrder()
	{
		$this->database->query("UNLOCK TABLES");
	}

	/**
	 * Create new order.
	 * @param  string
	 * @param  string
	 * @param  string
	 * @param  integer
	 * @return void
	 */
	public function addOrder($cartID, $name, $city, $street, $code, $img)
	{
		//$id = $this->database->query("SELECT MAX(id) FROM orders_auto_increment");
		$id = $this->database->table('orders_auto_increment')->max('id');
		//date_default_timezone_set('Europe/Bratislava');
		$date = date("Y-m-d H:i:s");
		$this->database->table(self::TABLE_NAME)->insert([
			"id" => $id,
			"cart_id" => $cartID,
			"name" => $name,
			"city"  => $city,
			"street" => $street,
			"code" => $code,
			"handeled" => 0,
			"disallowed" => 0,
			"date" => date("Y-m-d H:i:s")
		]);

		$this->database->table("prescription")->insert([
			"id" => $id,
			"image" => $img
		]);
	}

	public function getImg($id)
	{
		return $this->database->table('prescription')->where('id = ?', $id)[0]->image;
	}

	public function isHandeled($id)
	{
		$data = $this->database->query("SELECT handeled FROM orders WHERE id = ?", $id);
		return $data[0]->handeled;
		//return 1;
	}

	public function getOrdersOfUser($userID)
	{
		return $this->database->query("SELECT o.* FROM orders o left join cart c on (o.cart_id = c.id) WHERE c.user = ? GROUP BY o.id ORDER BY o.handeled", $userID);
		//return $this->database->query("SELECT * FROM orders");
	}

	public function getAllOrders()
	{
		return $this->database->query("SELECT * FROM orders GROUP BY id ORDER BY handeled");
	}

	public function handleOrder($id)
	{
		$this->database->query("UPDATE orders SET handeled=1 WHERE id = ?", $id);
		return 1;
	}

	public function disallowOrder($id)
	{
		$this->database->query("UPDATE orders SET handeled=1, disallowed=1 WHERE id = ?", $id);
		return 1;
	}

	public function getOrderContent($orderID)
	{
		return $this->database->query("SELECT m.*, count(m.name) as count FROM orders o left join cart c on(o.cart_id = c.id) left join medicine m on(c.medicine = m.id_sukl) WHERE o.id = ? GROUP BY m.name", $orderID);
	}

	public function getUserOfOrder($orderID)
	{
		$data = $this->database->query("SELECT c.user FROM orders o left join cart c on(o.cart_id = c.id) WHERE o.id = ?", $orderID);

		foreach ($data as $d) {
			return $d->user;
		}
	}
}