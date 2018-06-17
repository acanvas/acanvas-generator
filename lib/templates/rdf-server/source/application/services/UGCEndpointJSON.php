<?
class UGCEndpointJSON  {
protected $table;
protected $sql_table_prefix;
	
	function __construct() {
		//normally, we would extend Acanvas_DBTable, but then this class wouldn't work as an AMF Endpoint
		$this->table = new Acanvas_DBTable();
		
		$this->sql_table_prefix = Zend_Registry::get('Application_Config')->db->prefix;
	}
	/* ########################################################
		Read Item
	######################################################## */

	/**
	 * @param string $json
	 * @return array
	 */
	public function readItem($json) {
		$req = $this->_parseDTO($json);

		// ITEM METADATA
		$rows = $this->table->read(
				'items',
				array('id' => $req->id),
				array(),
				1, 0
		);

		$rows = $rows[0];

		// ITEM'S LIKERS
		$rows["likers"] = $this->table->read(
				'users_like_items',
				array('item_id' => $rows["id"]),
				array(/*'users', 'uid', 'uid'*/),
				50, 0
		);

		//ITEM DATA
		$type = "";

		switch($rows["type"]){
			case 0:
				$type = "text";
				break;
			case 1:
				$type = "image";
				break;
			case 2:
				$type = "video";
				break;
			case 3:
				$type = "audio";
				break;
			case 4:
				$type = "link";
				break;
		}

		$fetch = $this->table->read(
				'items_type_' . $type,
				array('id' => $rows["type_id"]),
				array(),
				1, 0
		);


		$rows["type_dao"] = $fetch[0];


		return $rows;
	}

	/* ########################################################
		Filter Items
	######################################################## */

	/**
	 * @param string $json
	 * @return array
	 */
	public function filterItems($json) {
		$req = $this->_parseDTO($json);
		
		$vo = new stdClass();
		$vo->flag = 0;
		
		switch($req->condition) {
			case "CONDITION_FRIENDS":
				$vo->creator_uid = $req->creator_uids;
				break;
			case "CONDITION_ME":
				$vo->creator_uid = $req->creator_uid;
				break;
			case "CONDITION_UGC_ID":
				$vo->id = $req->item_id;
				break;
			case "CONDITION_UID":
				$vo->creator_uid = $req->creator_uid;
				break;
			case "CONDITION_ALL":
				break;
		}

		
		// ITEM FILTER
		$rows = $this->table->read(
				'items',
				$vo,
				array('items_type_image', 'type_id', 'id'),
				$req->limit, $req->nextToken,
				$req->order
		);

		return $rows;
	}

	/* ########################################################
		Read Item Container(s) (e.g. an Album)
	######################################################## */

	/**
	 * @param string $json
	 * @return array
	 */
	public function readItemContainer($json) {
		$req = $this->_parseDTO($json);

		/*
		//GET CONTAINER
		$rows = $this->table->adapter->fetchAll(
				$this->table->find($req->id)
				->from($this->sql_table_prefix . "_itemcontainers")
		);
		*/

		$rows = $this->table->read(
        					'itemcontainers',
        					array('id' => $req->id),
        					array(),
        					0, 0
        			);

		if(!empty($rows))
		{
			//read items into ->items
			$rows[0]["items"] = $this->table->read(
					'items',
					array('container_id' => $rows[0]["id"]),
					array(),
					0, 0
			);
				
			//read roles into ->roles
			$rows[0]["roles"] = $this->table->read(
					'itemcontainer_roles',
					array('container_id' => $rows[0]["id"]),
					array(),
					0, 0
			);

			//read tasks into ->tasks
			$rows[0]["task"] = $this->table->adapter->fetchAll(
					$this->table->adapter->select(Zend_Db_Table::SELECT_WITH_FROM_PART)
					//->setIntegrityCheck(false)
					->from($this->sql_table_prefix . '_itemcontainers_tasks')
					->where("container_id = ?", $rows[0]["id"])
					->join($this->sql_table_prefix . '_tasks', $this->sql_table_prefix . '_itemcontainers_tasks.task_id = ' . $this->sql_table_prefix . '_tasks.id')
					->join($this->sql_table_prefix . '_task_categories', $this->sql_table_prefix . '_tasks.category_id = ' . $this->sql_table_prefix . '_task_categories.id')

			);
		}
		return $rows;
	}

	/* ########################################################
		Read Item Containers by UID and Role
	######################################################## */

	/**
	 * @param string $json
	 * @return array
	 */
	public function readItemContainersByUID($json) {
		$req = $this->_parseDTO($json);
		$res = new stdClass ( );

		$res->ownContainers = $this->readItemContainersByUIDAndRole( $req->uid, 0);
		$res->participantContainers = $this->readItemContainersByUIDAndRole( $req->uid, 1);
		$res->followContainers = $this->readItemContainersByUIDAndRole( $req->uid, 2);

		return $res;
	}

	private function readItemContainersByUIDAndRole($uid, $role) {
		return $this->table->adapter->fetchAll(
				$this->table->adapter->select(Zend_Db_Table::SELECT_WITH_FROM_PART)
				//->setIntegrityCheck(false)
				->from($this->sql_table_prefix . '_itemcontainers')
			//	->where("container_id = ?", $rows[0]->id)
				->join($this->sql_table_prefix . '_itemcontainer_roles', $this->sql_table_prefix . '_itemcontainers.id = ' . $this->sql_table_prefix . '_itemcontainer_roles.container_id')
				->where($this->sql_table_prefix . "_itemcontainer_roles.uid = ?", $uid)
				->where($this->sql_table_prefix . "_itemcontainer_roles.role = ?", $role)
				->limit(100)
		);
	}

	/* ########################################################
		Create Item
	######################################################## */

	/**
	 * @param string $json
	 * @return string
	 */
	public function createItem($json) {
		$req = $this->_parseDTO($json);
		//create item type dao
		$type = "";

		switch($req->type){
			case 0:
				$type = "text";
				break;
			case 1:
				$type = "image";
				break;
			case 2:
				$type = "video";
				break;
			case 3:
				$type = "audio";
				break;
			case 4:
				$type = "link";
				break;
		}


		$this->table->create("items_type_" . $type, $req->type_dao);
		$itemTypeId = $this->table->adapter->lastInsertId();

		$req->type_id = $itemTypeId;
		$req->type_dao = null;
		$this->table->create("items", $req );
		return $this->table->adapter->lastInsertId();
	}


	/* ########################################################
		Create Item Container (e.g. an Album)
	######################################################## */

	/**
	 * @param string $req
	 * @return string
	 */
	public function createItemContainer($json) {
		$req = $this->_parseDTO($json);
		$itemcontainerId = $this->table->create("itemcontainers", $req );
		return $itemcontainerId;
	}

	/* ########################################################
		Register
	######################################################## */

	/**
	 * @param string $json
	 * @return string
	 */
	public function login($json) {
		$req = $this->_parseDTO($json);
		
		$userInsertId = $this->table->create("users", $req );
		//return $userInsertId;
		//already exists
		if($userInsertId == 0){
			$data = array(
					'login_count'     		 => new Zend_Db_Expr('login_count + 1'),
					'timestamp_lastlogin'    => new Zend_Db_Expr('NOW()'),
					'pic' => $req->pic
			);
				
			$where = array(
                            'uid'      => '$req->uid'
                        );
				
			$this->table->_update("users", $data, $where);
		}

		return $userInsertId; //$this->table->read("users", array("uid" => $req->uid), array(), 1, 0);
	}
	
	private function _parseDTO($json) {
		$req = json_decode($json);
		
		$ret = new stdClass();
		foreach($req as $key => $value){
			if(!is_null($value)){
				$ret->{$key} = $value;
			}
		}
		
		return $ret;
	}

	/* ########################################################
		EMail: send
	######################################################## */

	/**
	 * @param string $json
	 * @return string
	 */
	public function sendMail($json) {
		$req = $this->_parseDTO($json);
		
		$subject = /* mysql_real_escape_string */($req->subject);
		$subject='=?UTF-8?B?'.base64_encode($subject).'?=';

		$sender = /* mysql_real_escape_string */($req->sender);
		$body = /* mysql_real_escape_string */($req->body);
		$body = str_replace("<br>", "\n", $body);
		$body = str_replace("<br/>", "\n", $body);

		$hash = /* mysql_real_escape_string */($req->hash);
		$email = /* mysql_real_escape_string */($req->email);

		$link = "http://backend.local.com:8888/confirm.php?e=". $email ."&h=" . $hash;
		$header = 'Content-Type: text/plain; charset=UTF-8; format=flowed\r\n MIME-Version 1.0\r\n Content-Transfer-Encoding: 8bit' . "\r\n" .
				'From: ' . $sender . "\r\n" .
				'Reply-To: ' . Zend_Registry::get('Application_Config')->email->replyto . "\r\n" .
				'X-Mailer: PHP/' . phpversion();

		$res = ("Message delivery failed...");


		if (mail($email, $subject, $body, $header)) {
			$res = ("Message successfully sent!");
		}


		return $res;

	}

	/* ########################################################
		Create Extended User
	######################################################## */

	/**
	 * @param string $json
	 * @return string
	 */
	public function createUserExtended($json) {
		$req = $this->_parseDTO($json);

		$res = $this->table->create("users_extended", $req );

		/*
		 // uncomment for double-opt-in:
		$this->sendMail($req->name, $req->hash, $req->email);
		*/

		return $res;
	}

	/* ########################################################
		Read Extended User
	######################################################## */

	/**
	 * @param string $json
	 * @return boolean
	 */
	public function hasUserExtended($json) {
		$req = $this->_parseDTO($json);

		$rows = $this->table->read(
				'users_extended',
				array('uid' => $req->uid),
				array(),
				1, 0
		);

		if(sizeof($rows)>0){
			return true;
		}
		else{
			return false;
		}
	}

	/* ########################################################
		Read Extended User (today)
	######################################################## */

	/**
	 * @param string $json
	 * @return boolean
	 */
	public function hasUserExtendedToday($json) {
		$req = $this->_parseDTO($json);

		$rows = $this->table->read(
				'users_extended',
				array('uid' => $req->uid),
				array("DATE(timestamp)" => "CURDATE()"),
				1, 0
		);


		if(sizeof($rows)>0){
			return true;
		}
		else{
			return false;
		}
	}

	/* ########################################################
		FB Invite Management
	######################################################## */

	/**
	 * @param string $json
	 * @return string
	 */
	public function trackInvite($json) {
		$req = $this->_parseDTO($json);

		$tbl = new stdClass();

		$tbl->from_id = /* mysql_real_escape_string */($req->uid);
		$tbl->request_id = /* mysql_real_escape_string */($req->request);
		$tbl->data = /* mysql_real_escape_string */($req->data);
		$tbl->to_ids = /* mysql_real_escape_string */($req->to_ids);
		$tbl->error_code = "";
		$tbl->error_msg = "";

		$res = $this->table->create("users_invites", $req );


		return "ok";
	}

	/* ########################################################
		UGC items: like, unlike
	######################################################## */

	/**
	 * @param string $json
	 * @return string
	 */
	public function likeItem($json) {
		$req = $this->_parseDTO($json);
		
		$uid = $req->uid;
		$id = $req->id;

		$affectedRows = $this->table->_delete("users_like_items", array("uid" => $uid, "item_id" => $id));

		if($affectedRows == 0){
			$data = array(
                'like_count'      => 'like_count+1'
			);
				
			$where = array(
                'id'      => '$id'
            );
				
			$this->table->_update("items", $data, $where);
		}

		$data = array(
				'uid'      => $uid,
				'item_id' => $id
		);
			
		$res = $this->table->create("users_like_items", $data );

		return "ok";
	}

	/**
	 * @param string $json
	 * @return string
	 */
	public function unlikeItem($json) {
		$req = $this->_parseDTO($json);
		
		$uid = $req->uid;
		$id = $req->id;

		$affectedRows = $this->table->_delete("users_like_items", array("uid" => $uid, "item_id" => $id));

        if($affectedRows == 0){
			$data = array(
					'like_count'      => 'like_count+1'
			);
				
			$where = array(
                'id'      => '$id'
            );

			$this->table->_update("items", $data, $where);
		}
		return "ok";
	}


	/* ########################################################
		UGC items: rate (e.g. with stars)
	######################################################## */

	/**
	 * @param string $json
	 * @return string
	 */
	public function rateItem($json) {
		$req = $this->_parseDTO($json);

		$uid = $req->uid;
		$id = $req->id;
		$rating = $req->rating;


        $this->table->_delete("users_like_items", array("uid" => $uid, "item_id" => $id));

		$data = array(
				'uid'      => $uid,
				'rating' => $rating,
				'item_id' => $id
		);
		$res = $this->table->create("users_like_items", $data );

		$rows = $this->table->adapter->fetchAll(
				$this->table->adapter->select()
				->from($this->sql_table_prefix . '_users_like_items', array('SUM(rating) as sum', 'COUNT(rating) as count'))
				->where('item_id = ?', $id)
		);

		if(sizeof($rows) > 0){
			$row = $rows[0];
				
			$data = array(
					'rating'      => $row["sum"] / $row["count"],
					'like_count'      => $row["count"]
			);
				
			$where = array(
                            'id'      => '$id'
                        );
				
			$this->table->_update("items", $data, $where);
		}

		return "ok";
	}


	/* ########################################################
		UGC items: complain (= flag as complained), delete (= flag as deleted)
	######################################################## */

	/**
	 * @param string $json
	 * @return string
	 */
	public function complainItem($json) {
		$req = $this->_parseDTO($json);
		
		$uid = $req->uid;
		$id = $req->id;

        $affectedRows = $this->table->_delete("users_complain_items", array("uid" => $uid, "item_id" => $id));

		if($affectedRows == 0){
			$data = array(
					'complain_count'      => 'complain_count+1'
			);
				
			$where = array(
                            'id'      => '$id'
                        );
				
			$this->table->_update("items", $data, $where);
		}

		$data = array(
				'uid'      => $uid,
				'item_id' => $id,
				'reason' => ''
		);
			
		$res = $this->table->create("users_complain_items", $data );

		return "ok";
	}

	/**
	 * @param string $json
	 * @return string
	 */
	public function deleteItem($json) {
		$req = $this->_parseDTO($json);
		
		$data = array(
				'blocked_status'      => 2
		);
			
		$where = array(
                        'id'      => '$req->id'
                    );
			
		$this->table->_update("items", $data, $where);

		return "ok";
	}




	/* ########################################################
		UGC items: read List of Friends that submitted something
	######################################################## */

	/**
	 * @param string $json
	 * @return array
	 */
	public function getFriendsWithItems($json) {
		$req = $this->_parseDTO($json);

		$str = "'" . implode("','", $req) . "'";

		return $this->table->adapter->fetchAll(
				$this->adapter->select()
				->from($this->sql_table_prefix . '_items', array('creator_id'))
				->where('ur.creator_id IN ($str)')
				->group('creator_id')
		);
	}



	/* ########################################################
		TASKS: Get Task Categories
	######################################################## */

	/**
	 * @return array
	 */
	public function getTaskCategories( ) {
		return  $this->table->read(
				'task_categories',
				array(),
				array(),
				0, 0
		);
	}

	/* ########################################################
		TASKS: Get Tasks of Category
	######################################################## */

	/**
	 * @param string $json
	 * @return array
	 */
	public function getTasksOfCategory( $json) {
		$req = $this->_parseDTO($json);
		
		return $this->table->read(
				'tasks',
				array('category_id' => $req->id),
				array(),
				0, 0
		);
	}


	/* ########################################################
		Create new Task
	######################################################## */

	/**
	 * @param string $json
	 * @return array
	 */
	public function createTask($json) {
		$req = $this->_parseDTO($json);
		
		//$req->item_container
		//$req->task_id
		//$req->owner_id
		//$req->participant_id


		//$req->item_container is UGCItemContainerDAO:
		//$req->item_container->id
		//$req->item_container->creator_uid
		//$req->item_container->title
		//$req->item_container->description

		//1. create item container for current task (parent_id = null)
		$container_id = $this->createItemContainer($req->item_container);

		$data = array(
				'container_id'      => $container_id,
				'task_id' => $req->task_id
		);
			
		//2. create ic-to-task relation (ic_id = CHILD_id)
		$res = $this->table->create("itemcontainers_tasks", $data );

		//3. create OWNER and PARTICIPANT roles
		$role = new stdClass();
		$role->container_id = $container_id;

		//owner role
		$role->role = 0;
		$role->uid = $req->owner_id;
		$this->addRole($role);

		//participant role
		$role->role = 1;
		$role->uid = $req->participant_id;
		$this->addRole($role);

		return $res;
	}


	/* ########################################################
		Add Role to Itemcontainer
	######################################################## */

	/**
	 * @param string $json
	 * @return array
	 */
	public function addRole($json) {
		$req = $this->_parseDTO($json);
		
		//$req->container_id
		//$req->role
		//$req->uid
			
		//2. create ic-to-task relation (ic_id = CHILD_id)
		$res = $this->table->create("itemcontainer_roles" , $req);

		return $res;
	}




}
?>