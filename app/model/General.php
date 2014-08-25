<?php
/**
 * Created by PhpStorm.
 * User: clary
 * Date: 19.8.14
 * Time: 20:25
 */

namespace App\Model;


class General extends Model{

	public function getUserId($username) {
		return $this->db->query("SELECT userid FROM profiles WHERE login_name=%s", $username)->fetchSingle();
	}

	public function getProductId($name) {
		return $this->db->query("SELECT id FROM products WHERE name=%s", $name)->fetchSingle();
	}
}