<?php
/*	
+---------------------------------------------------------------------------------------+
| Copyright (c) 2013, Nils Döhring													|
| All rights reserved.																	|
| Author: Nils Döhring <nils.doehring@gmail.com>									|
+---------------------------------------------------------------------------------------+ 
 *
 * @desc DB-Table Model
 * 
 * @author_________nils.doehring
 * @version________1.0        
 * @lastmodified___$Date: $ 
 * @revision_______$Revision: $ 
 * @copyright______Copyright (c) Block Forest
 * @package________Rockdot_Model
 *
 * @dependencies
 * @import: Rockdot_Zend_Db_Table	 
 */
require_once('Rockdot/DBTable.php');

class Rockdot_Model_Admin extends Rockdot_DBTable{
/*	+-----------------------------------------------------------------------------------+
	| 	member vars
	+-----------------------------------------------------------------------------------+  */
	/**
	* primary key
	* @var  :string
	*/
    protected $_primary = 'id';
	
/*	+-----------------------------------------------------------------------------------+
	| 	methods
	+-----------------------------------------------------------------------------------+  */
	
		
	/**
	* @desc
	* delivers profiles (admin-controller)
	*
	* @notice $_user is not validated 
	* (user is loggedin, data fetched with Zend_Auth::getInstance()->getStorage())
	*
	* @input-optional
	* @param $offset :int
	* @param $orderBy :string
	* @param $sortOrder :string (ASC,DESC)	
	*
	* @return :array
	*
	* @access public
	*/
	public function getItems($offset = 0, $orderBy = 'timestamp', $date_start = false, $date_end = false){
		//---------------------------
		//validate input
		if(!is_numeric($offset)){
			throw new Zend_Db_Table_Exception('offset must be typeof integer', 1001 );			
		}
		if(!is_string($orderBy)){
			throw new Zend_Db_Table_Exception('orderBy must be a valid string', 1001 );			
		}
		//---------------------------
		try{
			//---------------------------
			
			//------------------------------
			$where = "1=1";
			if($date_start != false){
				$where = ($this->sql_table_prefix . '_' . 'items.timestamp <= "' . $date_start . ' 00:00:00"');
				if($date_end != false){
					$where .= (' AND ' . $this->sql_table_prefix . '_' . 'items.timestamp >= "' . $date_end . ' 23:59:59"');
				}
			}
			
			//joins must use the default adapter istead of table-select
			$adapter = $this->adapter;
			//build select
			$select = $adapter->select()
					//------------------------------
					//table definitions
					->from($this->sql_table_prefix . '_' . 'items', array(new Zend_Db_Expr('SQL_CALC_FOUND_ROWS ' . $this->sql_table_prefix . '_' . 'items.id'), '*'))
					//------------------------------
					//item type for always image
					->joinLeft(
						$this->sql_table_prefix . '_' . 'items_type_image', 
						$this->sql_table_prefix . '_' . 'items_type_image.id = ' . $this->sql_table_prefix . '_' . 'items.type_id', 
						array(
							'url_big', 
							'url_thumb',
							'w',
							'h'
						)
					)
					//------------------------------
					//user must be active and confirmed
					->joinLeft(
						$this->sql_table_prefix . '_' . 'users', 
						$this->sql_table_prefix . '_' . 'users.uid = ' . $this->sql_table_prefix . '_' . 'items.creator_uid', 
						array(
							'name', 
							'locale',
							'network',
							'uid', 
							'pic', 
							'register_date_formatted' => "DATE_FORMAT(`" . $this->sql_table_prefix . "_" . "users`.`timestamp_registered`, '%d.%m.%y')"
						)
					)
					//->where('user.id IS NOT NULL')
					->where($where)
					//------------------------------
					//group by profile.id
					//->group('profile.id')
					//------------------------------
					//orderby(default: score DESC)
					->order('UPPER('.$orderBy.') '.$this->sortOrder)
					//------------------------------
					//set limit (paged)
					->limit($this->limit, ((int) $offset) * $this->limit);
			
			//---------------------------				  		
			//fetch profile
			echo $select;
			return $this->restructure(
				$adapter->fetchAll(
					$select
				)
			);
		}
		catch(Exception $e){
			echo $e->getMessage();
			//return empty array in case of error
			return array();	
		}
	}
	
	/**
	* @desc
	* restructure input data (cleanup returned data)
	*	
	* @input-required
	* @param $_data :array (query-result)
	*
	* @input-optional
	* @param $singleRow :boolean
	*
	* @return :array
	*
	* @access public
	*/
	private function restructure($_data, $singleRow = false){
		//return unstructured empty
		if(!empty($_data) && is_array($_data)){
			foreach($_data as $idx => $_row){
				foreach($_row as $name => $value){
					//add formatted values
					if($name === 'uid' && $_row['network'] === 'facebook'){
						$_data[$idx]['picture'] = self::getFacebookProfilePic($value);	
					}
				}				
			}
		}
		if($singleRow === true && isset($_data[0]['id']) && count($_data) == 1){
			return $_data[0];		
		}
	return $_data;	
	}
		
}