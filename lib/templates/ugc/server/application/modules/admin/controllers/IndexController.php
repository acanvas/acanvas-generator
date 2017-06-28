<?php
/*
 +---------------------------------------------------------------------------------------+
| Copyright (c) 2012, Nils Döhring													|
| All rights reserved.																	|
| Author: Nils Döhring <nils.doehring@gmail.com>									|
+---------------------------------------------------------------------------------------+
*
* @desc IndexController / Homepage
*
* @author_________nils.doehring
* @version________1.0
* @lastmodified___$Date: $
* @revision_______$Revision: $
* @copyright______Copyright (c) Block Forest
*
* @dependencies (autoloding enabled)
* @import: Zend_Controller_Action
*/

class Admin_IndexController extends Zend_Controller_Action{
	/*	+-----------------------------------------------------------------------------------+
	 | 	member vars
	+-----------------------------------------------------------------------------------+  */

	/**
	 * _prefix for DB Tables
	 * @var  :string
	 */
	private $_prefix = "";

	/**
	 * _sortby configuration indexed ('profile')
	 * @var  :array
	 */
	private $_sortby = array();

	/**
	 * flash-messenger-flags (namespaces)
	 * @var  :array
	*/
	const FLASH_MSG_SUCCESS = 'admin_index_success';//row success
	const FLASH_MSG_ERROR = 'admin_index_error'; //db-errors
	const FLASH_MSG_ID = 'admin_index_id'; //affected row-id
	/*	+-----------------------------------------------------------------------------------+
	| 	functions
	+-----------------------------------------------------------------------------------+  */
	/**
	 * @desc
	 * initial method (before action) called from parents construct
	 *
	 * @return :none
	 *
	 * @access public
	 */
	public function init(){
		try{
			Rockdot_Debug::dump( $this->_request->getParams(), 'REQUEST_INIT' );
			//----------------------------------------------------------------------
			//switch layout
			$this->_helper->layout->setLayout('admin');
			$layoutView = $this->_helper->layout->getView();
			//----------------------------------------------------------------------
			//add css
			$layoutView->getHelper('headlink')->appendStylesheet('/assets_admin/bootstrap/css/bootstrap.min.css');
			$layoutView->getHelper('headlink')->appendStylesheet('/assets_admin/bootstrap/css/datepicker.css');
			//----------------------------------------------------------------------
			//add scripts
			$layoutView->getHelper('headScript')->appendFile('//ajax.googleapis.com/ajax/libs/jquery/1.10.0/jquery.min.js');
			$layoutView->getHelper('headScript')->appendFile('/assets_admin/bootstrap/js/bootstrap.min.js');
			$layoutView->getHelper('headScript')->appendFile('/assets_admin/bootstrap/js/bootstrap-datepicker.js');
			//----------------------------------------------------------------------
			//handle error an success-messaging
			$layoutView->messages = array(
					'success' => $this->_helper->FlashMessenger->getMessages(self::FLASH_MSG_SUCCESS),
					'error' => $this->_helper->FlashMessenger->getMessages(self::FLASH_MSG_ERROR)
			);
			//affected id
			$_info = $this->_helper->FlashMessenger->getMessages(self::FLASH_MSG_ID);
			if(isset($_info[0])){
				$layoutView->affectedId	= $_info[0];
			}
			//----------------------------------------------------------------------
			//add action name to view (nav awareness)
			$layoutView->action = $this->_request->getActionName();

			//----------------------------------------------------------------------
			//create sort array
			$this->_prefix = Zend_Registry::get('Application_Config')->db->prefix;
			$this->_sortBy = array(
					'items' => array(
							'id' => $this->_prefix . '_items.id',
							'username' => $this->_prefix . '_users.name',
							'date' => $this->_prefix . '_items.timestamp'
					)
			);
		}
		catch(Exception $e){
			Rockdot_Debug::dump($e->getMessage(), 'EXCEPTION@init()');
		}
	}

	/**
	 * @desc
	 * postDispatch (called after action)
	 *
	 * @return :none
	 *
	 * @access public
	 */
	public function postDispatch(){
		//----------------------------------------------------------------------
		//clear used error-messages
		$this->_helper->flashMessenger->clearMessages(self::FLASH_MSG_SUCCESS);
		$this->_helper->flashMessenger->clearMessages(self::FLASH_MSG_ERROR);
		$this->_helper->flashMessenger->clearMessages(self::FLASH_MSG_ID);
		//----------------------------------------------------------------------
	}

	/**
	 * @desc: init authentification
	 *
	 * @return :none
	 *
	 * @access public
	 */
	public function preDispatch(){
		try{
			//----------------------------------------------------------------------
			//basic ip-protection
			if(!in_array(Rockdot_Http_Request::getIp(), Zend_Registry::get('Application_Config')->page->admin_ips->toArray())){
				//XXX no ip restriction for now
				//$this->_redirect('/');
			}
			//----------------------------------------------------------------------
			//auth digest
			$auth = Zend_Auth::getInstance();
			//test for identity
			if(!$auth->hasIdentity()){
				$adapter = new Zend_Auth_Adapter_Http(
						array(
								'accept_schemes' => 'digest',
								'realm'          => 'Private',
								'digest_domains' => '/admin',
								'nonce_timeout'  => 60
						)
				);
				$adapter->setRequest($this->_request);
				$adapter->setResponse($this->_response);
				$adapter->setDigestResolver(
						new Zend_Auth_Adapter_Http_Resolver_File(APPLICATION_PATH.'/configs/adminlogin.txt')
				);
				//test credentials
				$result = $auth->authenticate($adapter);
				if(!$result->isValid()){
					//show errorpage
					$adapter->getResponse()->sendResponse();
					$this->displayErrorPage();
				}
			}
			//get identity
			if($auth->hasIdentity()){
				$this->view->identity = $auth->getIdentity();
			}
		}
		catch(Exception $e){
			echo $e;
			exit;
			//$this->displayErrorPage();
		}
	}

	/**
	 * @desc: init authentification
	 *
	 * @return :none
	 *
	 * @access private
	 */
	private function displayErrorPage(){
		$this->_helper->layout->disableLayout();
		echo $this->view->render('error/error_adminlogin.phtml');
		exit;
	}

	/**
	 * @desc: logout user
	 *
	 * @return :none
	 *
	 * @access public
	 */
	public function logoutAction(){
		//-----------------------------------------------
		//no view rendering
		Zend_Controller_Front::getInstance()->setParam('noViewRenderer', true);
		//clearIdentity
		Zend_Auth::getInstance()->clearIdentity();
		//expire session
		Zend_Session::expireSessionCookie();
		//return to overview
		$this->_redirect('/');
	}

	/**
	 * @desc: toggles active state of a profile an its depending couples
	 *
	 * @return :none
	 *
	 * @access public
	 */
	public function toggleactiveAction(){
		//-----------------------------------------------
		//no view rendering
		Zend_Controller_Front::getInstance()->setParam('noViewRenderer', true);
		//-----------------------------------------------
		//set sortby
		if(isset($this->_request->id) && preg_match('/[A-Za-z0-9]/', $this->_request->id)){
			//-----------------------------------------------
			//init profile model
			$model = new Rockdot_Model_Admin(
					array( 'metadataCache' => Zend_Registry::get('Cache') )
			);
			$_entry = $model->read('items',
					array('id' => $this->_request->id),
					array(),
					0, 0
			);
			//-------------------------------------------
			//test if user exists
			if(!empty($_entry)){
				//-------------------------------------------
				//set toogling parameter
				$_update = array('flag' => 1);
				$text = 'flagged';
				if($_entry[0]['flag'] == 1){
					$_update = array('flag' => 0);
					$text = 'unflagged';
				}
				//toggle user.active
				$model->getAdapter()->update($this->_prefix . '_items', $_update, "id = " . $this->_request->id);
				//-------------------------------------------
				//add helper message
				$this->_helper->FlashMessenger->addMessage(
						'Profile #('.$this->_request->id.') successfully "'.$text.'"!',
						self::FLASH_MSG_SUCCESS
				);
				//add helper affectedid
				$this->_helper->FlashMessenger->addMessage(
						$_entry[0]['id'],
						self::FLASH_MSG_ID
				);
				//-------------------------------------------
			}
		}
		//return to overview
		$this->_redirect('/admin');
	}
	

	/**
	 * @desc: view overview-table
	 * all http-control-requests have session defaults
	 *
	 * @return :none
	 *
	 * @access public
	 */
	public function indexAction(){
		try{
			//init index_session
			$session = new Zend_Session_Namespace('Rockdot_Admin_Controller_Index_Toplist');
			//-----------------------------------------------
			//init profile model
			$profile = new Rockdot_Model_Admin(
					array( 'metadataCache' => Zend_Registry::get('Cache') )
			);
			//-----------------------------------------------
			// sortby
			$sortBy = $this->_prefix . '_items.timestamp';
			//-----------------------------------------------
			// sortorder
			$sortOrder = 'DESC';
			//-----------------------------------------------
			//process perpage
			if(isset($this->_request->perpage) && is_numeric($this->_request->perpage)){
				$session->perpage = (int) $this->_request->perpage;
			}
			elseif(!isset($session->perpage)){
				$session->perpage = 10;
			}
			//-----------------------------------------------
			//reset dates
			$session->date_start = false;
			$session->date_end = false;
			//-----------------------------------------------
			//process date_start
			if(isset($this->_request->date_start) && strtotime($this->_request->date_start)){
				//false if invalid
				$session->date_start = ($this->_request->date_start);
			}
			//-----------------------------------------------
			//process date_end
			if(isset($this->_request->date_end) && strtotime($this->_request->date_end)){
				//false if invalid
				$session->date_end = ($this->_request->date_end);
			}
			//-----------------------------------------------
			//Model Requests
			//-----------------------------------------------
			//view profiles
			$this->view->items = new Rockdot_Data(
					$profile->setLimit($session->perpage)
					->setSortOrder($sortOrder)
					->getItems(0, $sortBy, $session->date_start, $session->date_end)
			);
			//-----------------------------------------------
			//set count
			$count = $profile->getRowCount();
			$this->view->count = $count;
			//------------------------------
	
			//-----------------------------------------------
			//further view vars
			$this->view->limit = $session->perpage;
			$this->view->date_start = $this->_request->date_start;
			$this->view->date_end = $this->_request->date_end;
		}
		catch(Exception $e){
			Rockdot_Debug::dump($e, 'Exception');
		}
		$this->_helper->flashMessenger->clearCurrentMessages();
	}

	/**
	 * @desc: view overview-table
	 * all http-control-requests have session defaults
	 *
	 * @return :none
	 *
	 * @access public
	 */
	public function userlistAction(){
		try{
			//init index_session
			$session = new Zend_Session_Namespace('Rockdot_Admin_Controller_Index');
			//-----------------------------------------------
			//init profile model
			$profile = new Rockdot_Model_Admin(
					array( 'metadataCache' => Zend_Registry::get('Cache') )
			);
			//-----------------------------------------------
			//process sortby
			if(isset($this->_sortby['items'][$this->_request->sortby])){
				$session->sortBy = $this->_sortby['items'][$this->_request->sortby];
			}
			elseif(!isset($session->sortBy)){
				$session->sortBy = $this->_prefix . '_items.timestamp';
			}
			//-----------------------------------------------
			//process sortorder
			if(isset($this->_request->sortorder)){
				$session->sortOrder = $this->_request->sortorder;
			}
			elseif(!isset($session->sortOrder)){
				$session->sortOrder = 'ASC';
			}
			//-----------------------------------------------
			//process pagenum
			if(isset($this->_request->page) &&  is_numeric($this->_request->page) &&  $this->_request->page >= 1){
				$session->page = (int) $this->_request->page;
				if($session->page < 0){
					$session->page = 1;
				}
			}
			elseif(!isset($session->page)){
				$session->page = 1;
			}
			//-----------------------------------------------
			//process perpage
			if(isset($this->_request->perpage) && is_numeric($this->_request->perpage)){
				$session->perpage = (int) $this->_request->perpage;
				//reset current page to first
				$session->page = 1;
			}
			elseif(!isset($session->perpage)){
				$session->perpage = $profile->getLimit();
			}
			//-----------------------------------------------
			//Model Requests
			//-----------------------------------------------
			//view profiles
			$this->view->items = new Rockdot_Data(
					$profile->setLimit($session->perpage)
					->setSortOrder($session->sortOrder)
					->getItems(($session->page-1), $session->sortBy)
			);
			//-----------------------------------------------
			//set count
			$count = $profile->getRowCount();
			$this->view->count = $count;
			//-----------------------------------------------

			//-----------------------------------------------
			//Create paginator with null adapter. (Notice cannot take a Zero (0))
			//-----------------------------------------------
			if($count > 0){
				$paginator = new Zend_Paginator(
						new Zend_Paginator_Adapter_Null($count)
				);
				$paginator->setDefaultScrollingStyle('Elastic');
				$paginator->setDefaultPageRange(2);
				$paginator->setCurrentPageNumber($session->page);
				$paginator->setItemCountPerPage($profile->getLimit());
				Zend_View_Helper_PaginationControl::setDefaultViewPartial('partials/pager.phtml');
				//add to view
				$this->view->paginator = $paginator;
				$this->view->showPerPage = new Rockdot_Form_PerPage(
						array(
								'config' =>	array(
										'perpage' => array(
												'options' => array(
														'1' => '1',
														'10' => '10',
														'25' => '25',
														'50' => '50',
														'100' => '100',
														'150' => '150',
												),
												'class' => 'input-mini'
										)
								)
						)
				);
				//populate perpage dropdown
				$this->view->showPerPage->populate( array(
						'perpage' => $session->perpage
				)
				);
			}
			//-----------------------------------------------
		}
		catch(Exception $e){
			Rockdot_Debug::dump($e, 'Exception');
		}
		$this->_helper->flashMessenger->clearCurrentMessages();
	}
	
	public function bugsAction(){}
}