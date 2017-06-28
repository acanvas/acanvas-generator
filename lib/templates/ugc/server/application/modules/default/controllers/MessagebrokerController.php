<?php
class MessagebrokerController extends Zend_Controller_Action 
{ 
	public function init()
	{
 		$this->_helper->layout()->disableLayout();
	}
 
	public function amfAction()
	{
		require_once APPLICATION_PATH . '/services/UGCEndpointAMF.php';
		require_once APPLICATION_PATH . '/services/ZendAmfServiceBrowser.php';
		
		$server = new Zend_Amf_Server();
		$server->setProduction(false);
		
		$server->setClass('UGCEndpointAMF');
		$server->setClass('ZendAmfServiceBrowser');

		ZendAmfServiceBrowser::$ZEND_AMF_SERVER = $server;
		echo($server->handle());
	}

	public function jsonAction()
	{
		require_once APPLICATION_PATH . '/services/UGCEndpointJSON.php';
		
		$server = new Zend_Json_Server();
		$server->setClass('UGCEndpointJSON');

		header("Access-Control-Allow-Headers: Content-Type");
		
		if ("GET" == $_SERVER["REQUEST_METHOD"]) {
			// Indicate the URL endpoint, and the JSON-RPC version used:
			$server->setTarget("/messagebroker/json");
			$server->setEnvelope(Zend_Json_Server_Smd::ENV_JSONRPC_2);
		
			// Grab the SMD
			$smd = $server->getServiceMap();
		
			// Return the SMD to the client
			header("Content-Type: application/json");
			echo $smd;
			return;
		}
		
		echo($server->handle());
	}
	
	public function testamfAction()
	{
		
	}

	public function testjsonAction()
	{
		
	}
}