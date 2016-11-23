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

	/**
	 * Create new order.
	 * @param  string
	 * @param  string
	 * @param  string
	 * @param  integer
	 * @return void
	 */
	public function addOrder($cartID, $name, $city, $street, $code)
	{
		$this->database->table(self::TABLE_NAME)->insert([
			"cart_id" => $cartID,
			"name" => $name,
			"city"  => $city,
			"street" => $street,
			"code" => $code
		]);
	}
}