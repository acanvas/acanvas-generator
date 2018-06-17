<?php
class IndexController extends Zend_Controller_Action {
	public function init() {
		/* Initialize action controller here */
	}
	public function indexAction() {
		$config = Zend_Registry::get ( 'Application_Config' );
		$rckdt_registry = Acanvas_Registry::getInstance ();
		
		$fb_sig = $rckdt_registry->get ( 'fb_sig_data' );
		$app_data = $rckdt_registry->get ( 'app_data' );
		$request_ids = $this->getRequest ()->getQuery ( "request_ids" );
		
		if (! empty ( $request_ids )) {
			//echo $request_ids;
			$this->_redirect('/requests');
		} 		/* ### USER IS FAN ### */
		else if (($fb_sig && $fb_sig ["page"] ["liked"] == 1) || $this->getRequest ()->getQuery ( "gate" ) == "off") {
			// Like Gates are forbidden by 2014-11-05. We could still implement tracking, though.
		} 		/* ### USER IS NO FAN (FANGATE) ### */
		else {
			// Like Gates are forbidden by 2014-11-05. We could still implement tracking, though.
		}
	}
	public function requestsAction() {
		$configuration_locale = Zend_Registry::get ( 'Application_Config_Locale' );
		$config = Zend_Registry::get ( 'Application_Config' );
		
		// get request data and redirect
		$a_request_ids = explode ( ",", $this->getRequest ()->getQuery ( "request_ids" ) );
		
		$adapter = Zend_Registry::get ( 'db' );
		
		$select = $adapter->select ();
		$select->from ( $config->db->prefix . '_log_invites' );
		$select->where ( 'request_id = ?', $a_request_ids [sizeof ( $a_request_ids ) - 1] );
		$select->limit ( 1 );
		
		$rows = $adapter->fetchAll ( $select );
		
		$this->view->invite_app_data = $rows [0] ["data"];
		$this->view->invite_redirect = $configuration_locale->page_url;
		
		echo $this->view->partial ( 'partials/requestsRedirect.phtml' );
	}
}

