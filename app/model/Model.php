<?php

namespace App\Model;

use Nette;

/**
 * Description of Model
 *
 * @author clary
 */
abstract class Model {
	
	/** @var DibiCOnnection */
	protected $db;
	
	public function __construct(\DibiConnection $db) {
		$this->db = $db;
	}
}
