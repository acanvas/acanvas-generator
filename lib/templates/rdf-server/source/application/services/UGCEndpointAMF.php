<?
class UGCEndpointAMF  {
protected $table;
protected $sql_table_prefix;
	
	function __construct() {
		//normally, we would extend Acanvas_DBTable, but then this class wouldn't work as an AMF Endpoint
		$this->table = new Acanvas_DBTable();
		
		$this->sql_table_prefix = "acanvasdemo";//Zend_Registry::get('Application_Config')->db->prefix;
	}
	/* ########################################################
		Read Item
	######################################################## */

	public function readItem($id) {

		// ITEM METADATA
		$rows = $this->table->read(
				'items',
				array('id' => $id),
				array(),
				1, 0
		);

		$rows = $rows[0];

		//return $rows;
		// ITEM'S LIKERS
		$rows["likers"] = $this->table->read(
				'users_like_items',
				array('item_id' => $rows["id"]),
				array('users', 'uid', 'uid'),
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
	 * @param object $req
	 * @return array
	 */
	public function filterItems($req) {
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
				$req->limit, $req->limitindex,
				$req->order
		);

		return $rows;
	}

	/* ########################################################
		Read Item Container(s) (e.g. an Album)
	######################################################## */

	/**
	 * @param int $id
	 * @return array
	 */
	public function readItemContainer($id) {

		//GET CONTAINER
		$rows = $this->table->adapter->fetchAll(
				$this->table->adapter->find($id)
				->from($this->sql_table_prefix . "_itemcontainers")
		);

		if(!empty($rows))
		{
			//read items into ->items
			$rows[0]->items = $rows[0]->type_dao = $this->read(
					'items',
					array('container_id' => $rows[0]->id),
					array(),
					0, 0
			);
				
			//read roles into ->roles
			$rows[0]->roles = $rows[0]->type_dao = $this->read(
					'itemcontainer_roles',
					array('container_id' => $rows[0]->id),
					array(),
					0, 0
			);

			//read tasks into ->tasks
			$rows[0]->task = $this->table->adapter->fetchAll(
					$this->table->adapter->select(Zend_Db_Table::SELECT_WITH_FROM_PART)
					->setIntegrityCheck(false)
					->from($this->sql_table_prefix . '_itemcontainers_tasks')
					->where("container_id = ?", $rows[0]->id)
					->join($this->sql_table_prefix . '_tasks', $this->sql_table_prefix . '_itemcontainers_tasks.task_id = ' . $this->sql_table_prefix . '_tasks.id')
					->join($this->sql_table_prefix . '_task_categories', $this->sql_table_prefix . '_itemcontainers_tasks.category_id = ' . $this->sql_table_prefix . '_task_categories.id')

			);
		}
		return $rows;
	}

	/* ########################################################
		Read Item Containers by UID and Role
	######################################################## */

	/**
	 * @param string $uid
	 * @return array
	 */
	public function readItemContainersByUID($uid) {
		$res = new stdClass ( );

		$res->ownContainers = $this->readItemContainersByUIDAndRole( $uid, 0);
		$res->participantContainers = $this->readItemContainersByUIDAndRole( $uid, 1);
		$res->followContainers = $this->readItemContainersByUIDAndRole( $uid, 2);

		return $res;
	}

	private function readItemContainersByUIDAndRole($uid, $role) {
		return $this->table->adapter->fetchAll(
				$this->table->adapter->select(Zend_Db_Table::SELECT_WITH_FROM_PART)
				->setIntegrityCheck(false)
				->from($this->sql_table_prefix . '_itemcontainers')
				->where("container_id = ?", $rows[0]->id)
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
	 * @param object $req
	 * @return string
	 */
	public function createItem($req) {
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
	 * @param object $req
	 * @return string
	 */
	public function createItemContainer($req) {
		$itemcontainerId = $this->table->create("itemcontainers", $req );
		return $itemcontainerId;
	}

	/* ########################################################
		Register
	######################################################## */

	/**
	 * @param object $req
	 * @return string
	 */
	public function login($req) {
		$userInsertId = $this->table->create("users", $req );
		//return $userInsertId;
		//already exists
		if($userInsertId == 0){
			$data = array(
					'login_count'     		 => new Zend_Db_Expr('login_count + 1'),
					'timestamp_lastlogin'    => new Zend_Db_Expr('NOW()'),
					'pic' => $req->pic
			);
				
			$where[] = "uid = '$req->uid'";
				
			$this->table->_update("users", $data, $where);
		}

		return $this->table->read("users", array("uid" => $req->uid), array(), 1, 0);
	}

	/* ########################################################
		EMail: send
	######################################################## */

	/**
	 * @param object $req
	 * @return string
	 */
	public function sendMail($runObj) {
		$subject = mysql_real_escape_string($runObj->subject);
		$subject='=?UTF-8?B?'.base64_encode($subject).'?=';

		$sender = mysql_real_escape_string($runObj->sender);
		$body = mysql_real_escape_string($runObj->body);
		$body = str_replace("<br>", "\n", $body);
		$body = str_replace("<br/>", "\n", $body);

		$hash = mysql_real_escape_string($runObj->hash);
		$email = mysql_real_escape_string($runObj->email);

		$link = "http://backend.local.com:8888/confirm.php?e=". $email ."&h=" . $hash;
		$header = 'Content-Type: text/plain; charset=UTF-8; format=flowed\r\n MIME-Version 1.0\r\n Content-Transfer-Encoding: 8bit' . "\r\n" .
				'From: ' . $sender . "\r\n" .
				'Reply-To: nilsdoehring@gmail.com' . "\r\n" .
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
	 * @param object $req
	 * @return string
	 */
	public function createUserExtended($req) {
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
	 * @param string $uid
	 * @return boolean
	 */
	public function hasUserExtended($uid) {

		$rows = $this->table->read(
				'users_extended',
				array('uid' => $uid),
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
	 * @param string $uid
	 * @return boolean
	 */
	public function hasUserExtendedToday($uid) {
		$rows = $this->table->read(
				'users_extended',
				array('uid' => $uid),
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
	 * @param object $runObj
	 * @return string
	 */
	public function trackInvite($runObj) {

		$req = new stdClass();

		$req->from_id = mysql_real_escape_string($runObj->uid);
		$req->request_id = mysql_real_escape_string($runObj->request);
		$req->data = mysql_real_escape_string($runObj->data);
		$req->to_ids = mysql_real_escape_string($runObj->to_ids);
		$req->error_code = "";
		$req->error_msg = "";

		$res = $this->table->create("users_invites", $req );


		return "ok";
	}

	/* ########################################################
		UGC items: like, unlike
	######################################################## */

	/**
	 * @param object $runObj
	 * @return string
	 */
	public function likeItem($req) {
		$uid = $req->uid;
		$id = $req->id;

		$this->table->adapter->delete(array("uid" => $uid, "item_id" => $id))
		->from($this->sql_table_prefix . "_users_like_items")
		->where("uid", $uid);

		if($this->table->adapter->getAffectedRows() == 0){
			$data = array(
					'like_count'      => 'like_count+1'
			);
				
			$where[] = "id = '$id'";
				
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
	 * @param object $runObj
	 * @return string
	 */
	public function unlikeItem($runObj) {
		$uid = $runObj->uid;
		$id = $runObj->id;

		$this->table->adapter->delete(array("uid" => $uid, "item_id" => $id))
		->from($this->sql_table_prefix . "_users_like_items")
		->where("uid", $uid)
		->where("item_id", $id);

		if($this->table->adapter->getAffectedRows() == 0){
			$data = array(
					'like_count'      => 'like_count+1'
			);
				
			$where[] = "id = '$id'";
				
			$this->table->_update("items", $data, $where);
		}
		return "ok";
	}


	/* ########################################################
		UGC items: rate (e.g. with stars)
	######################################################## */

	/**
	 * @param object $req
	 * @return string
	 */
	public function rateItem($req) {

		$uid = $req->uid;
		$id = $req->id;
		$rating = $req->rating;


		$this->table->adapter->delete(array("uid" => $uid, "item_id" => $id))
		->from($this->sql_table_prefix . "_users_like_items");

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
					'like_count'      => $row[0]["sum"],
					'liker_count'      => $row[0]["count"]
			);
				
			$where[] = "id = '$id'";
				
			$this->table->_update("items", $data, $where);
		}

		return "ok";
	}


	/* ########################################################
		UGC items: complain (= flag as complained), delete (= flag as deleted)
	######################################################## */

	/**
	 * @param object $runObj
	 * @return string
	 */
	public function complainItem($runObj) {
		$uid = $req->uid;
		$id = $req->id;

		$this->table->adapter->delete(array("uid" => $uid, "item_id" => $id))
		->from($this->sql_table_prefix . "_users_complain_items");


		if($this->table->adapter->getAffectedRows() == 0){
			$data = array(
					'complain_count'      => 'complain_count+1'
			);
				
			$where[] = "id = '$id'";
				
			$this->table->adapter->update("items", $data, $where);
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
	 * @param string $id
	 * @return string
	 */
	public function deleteItem($id) {
		$data = array(
				'blocked_status'      => 2
		);
			
		$where[] = "id = '$id'";
			
		$this->table->adapter->update("items", $data, $where);

		return "ok";
	}




	/* ########################################################
		UGC items: read List of Friends that submitted something
	######################################################## */

	/**
	 * @param array $readObj
	 * @return array
	 */
	public function getFriendsWithItems( $readObj ) {

		$str = "'" . implode("','", $readObj) . "'";

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
	 * @param int $id
	 * @return array
	 */
	public function getTasksOfCategory( $id ) {
		return $this->table->read(
				'tasks',
				array('category_id' => $id),
				array(),
				0, 0
		);
	}


	/* ########################################################
		Create new Task
	######################################################## */

	/**
	 * @param object $obj
	 * @return array
	 */
	public function createTask( $obj ) {
		//$obj->item_container
		//$obj->task_id
		//$obj->owner_id
		//$obj->participant_id


		//$obj->item_container is UGCItemContainerDAO:
		//$obj->item_container->id
		//$obj->item_container->creator_uid
		//$obj->item_container->title
		//$obj->item_container->description

		//1. create item container for current task (parent_id = null)
		$container_id = $this->createItemContainer($obj->item_container);

		$data = array(
				'container_id'      => $container_id,
				'task_id' => $obj->task_id
		);
			
		//2. create ic-to-task relation (ic_id = CHILD_id)
		$res = $this->table->create("itemcontainers_tasks", $data );

		//3. create OWNER and PARTICIPANT roles
		$role = new stdClass();
		$role->container_id = $container_id;

		//owner role
		$role->role = 0;
		$role->uid = $obj->owner_id;
		$this->addRole($role);

		//participant role
		$role->role = 1;
		$role->uid = $obj->participant_id;
		$this->addRole($role);

		return $res;
	}


	/* ########################################################
		Add Role to Itemcontainer
	######################################################## */

	/**
	 * @param object $obj
	 * @return array
	 */
	public function addRole( $obj ) {
		//$obj->container_id
		//$obj->role
		//$obj->uid

		$data = array(
				'container_id'      => $obj->container_id,
				'role' => $obj->role,
				'uid' => $obj->uid
		);
			
		//2. create ic-to-task relation (ic_id = CHILD_id)
		$res = $this->table->create("itemcontainer_roles" , $data);

		return $res;
	}




}
?>