<?php
/**
 * Created by PhpStorm.
 * User: clary
 * Date: 19.8.14
 * Time: 20:25
 */

namespace App\Model;


class General extends Model{

	/**
	 * Returns ID of user by his name.
	 *
	 * @param string $username
	 * @return mixed
	 */
	public function getUserId($username) {
		return $this->db->query("SELECT userid FROM profiles WHERE login_name=%s", $username)->fetchSingle();
	}

	/**
	 * Returns product ID by its name.
	 *
	 * @param string $name
	 * @return mixed
	 */
	public function getProductId($name) {
		return $this->db->query("SELECT id FROM products WHERE name=%s", $name)->fetchSingle();
	}

	/**
	 * Returns product name and description in associated array.
	 *
	 * @return array
	 */
	public function getProducts() {
		return $this->db->query("SELECT name, description FROM products")->fetchPairs();
	}

	/**
	 * Return product name by its ID.
	 *
	 * @param int $id
	 * @return mixed
	 */
	public function getProduct($id) {
		return $this->db->query("SELECT name FROM products WHERE id=%i", $id)->fetchSingle();
	}
}