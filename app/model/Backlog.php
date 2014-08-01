<?php

namespace App\Model;

use Nette;


/**
 * Users management.
 */
class Backlog extends Model{
    
    public function getData() {
        return $this->db->query('SELECT * FROM [bugs]');
    }
}