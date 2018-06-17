<?php
/*	
+---------------------------------------------------------------------------------------+
| Copyright (c) 2013, Nils Döhring													|
| All rights reserved.																	|
| Author: Nils Döhring <nils.doehring@gmail.com>									|
+---------------------------------------------------------------------------------------+ 
 *
 * @desc ErrorController based on Zend_Controller_Action
 * handles NotFoundExceptions (ie. NO_CONTROLLER, NO_ACTION, NO_ROUTE) and ApplicationExceptions (ie. EXCEPTION_OTHER, systemerror)
 * logs error-messages (setup via application config)
 * 
 * @author_________nils.doehring
 * @version________1.0        
 * @lastmodified___$Date: $ 
 * @revision_______$Revision: $ 
 * @copyright______Copyright (c) Block Forest
 *
 * @dependencies (autoloding enabled)		 
 */
class ErrorController extends Zend_Controller_Action{
/*	+-----------------------------------------------------------------------------------+
	| 	member vars
	+-----------------------------------------------------------------------------------+  */
	/**
	* exception/error-container
	* @var  :ArrayObject
	*/
	private $_errors = array();
	
	/**
	* status code (default: 404)
	* @var  :string
	*/
	private $statusCode = 404;
	
	/**
	* exception-type
	* @var  :string
	*/
	private $exceptionType = 'EXCEPTION_UNKNOWN';
	
	/**
	* handle XmlHttpRequest custom (send JSON-Response)
	* @var  :boolean
	*/
	private $sendJsonOnXmlHttpRequest = false;
	
	/**
	* turn on/off logging
	* @var  :boolean
	*/
	private $logCustomEvent = true;
		
	/**
	* logtype (none,monitor_custom_event,error_log,mail) (false|NULL,'none')
	* @var  :string
	*/
	private $logType = 'error_log';
	
	/**
	* if logType mail these adresses are used
	* @var  :string
	*/
	private $_mailReceiver = array(
		'nilsdoehring@gmail.com'
	);
		
	/**
	* excluded exception ids (they mostly write to own log)
	* (i.e. attacks are logged in bootstrap (initPHPIDS()))
	* 7 	= custom system errors
	* 71 	= bootstrap
	* 7101  = triggered system-error by initPHPIDS
	* 71**  = exclude all ranges from 7100-7199
	*
	* @var  :boolean
	*/
	private $_excludeFromLogging = array(
		7101
	);
/*	+-----------------------------------------------------------------------------------+
	| init
	+-----------------------------------------------------------------------------------+  */	
	/**
	* @desc
	* initialize error-controller
	*
	* @void
	*	
	* @return none
	*
	* @access public
	*/
	public function init(){  
    	try{
			//---------------------------------------------------------------------------------------------
			//setup (with config vars)
			if(class_exists('Zend_Registry') && isset(Zend_Registry::get('Application_Config')->controller->error)){
				$this->setOptions(Zend_Registry::get('Application_Config')->controller->error->toArray());				
			}
			//---------------------------------------------------------------------------------------------
			//get error/exception stack
			$this->_errors = $this->_getParam('error_handler');
			//---------------------------------------------------------------------------------------------
			//detect exception type
			if(is_object($this->_errors) && isset($this->_errors->type)){
				$this->exceptionType = $this->_errors->type;
				//-----------------------------------------------------------------------------------------
				//handle all kinds of error-types
				switch($this->exceptionType){ 
					//404:  action, controller, route not found
					case Zend_Controller_Plugin_ErrorHandler::EXCEPTION_NO_CONTROLLER:
					case Zend_Controller_Plugin_ErrorHandler::EXCEPTION_NO_ACTION:
					case Zend_Controller_Plugin_ErrorHandler::EXCEPTION_NO_ROUTE:
						$this->statusCode = 404;
					break;
					//500: system error / view script not found / custom (Zend_Controller_Plugin_ErrorHandler::EXCEPTION_OTHER | self::EXCEPTION_UNKNOWN)
					default:
						$this->statusCode = 500;
						$this->logError(); //log errors
					break;
				}
			}
			//----------------------------------------------------------------------------------------------
			//dump errors (APPLICATION_ENV != 'production')
			$this->dumpError();
			//----------------------------------------------------------------------------------------------
			//handle json request errors
			if($this->sendJsonOnXmlHttpRequest === true && $this->getRequest()->isXmlHttpRequest()){
				$this->_helper->json->sendJson(
					array(
						'success' => false, 
						'status' => $this->statusCode,
						'errors' => array(
							'process' => array(
								'input' => 'Invalid request'
							) 
						)
						//'message' => $this->exceptionType
					)
				);
			}
		}
		catch(Exception $e){
			//do nothing	
		}
		//---------------------------------------------------------------------------------------------------
		//handle bootstrap errors (maybe no view or some other dependecies not loaded)
		if(APPLICATION_ENV !== 'production'){
			if($this->view == NULL || ($this->getInvokeArg('bootstrap') === NULL && isset($this->_errors->exception))){
				exit('<h1>Coder-Notice! Bootstrap not loaded completely, chain broken! Application Exception!</h1><p>'.$this->_errors->exception->getMessage().'</p>');
			}
		}
		elseif($this->view == NULL || ($this->getInvokeArg('bootstrap') === NULL)){
			//handling bootstrap errors (they should never occure)
			Zend_Layout::startMvc(
				array(
					'layoutPath' => APPLICATION_PATH.'/modules/shared_views/layouts', 
					'layout'     => 'main',
					'viewSuffix' => 'php'
				)
			);
			//add "shared_views" module to scriptpath (only shared scripts in here)
			$view = Zend_Layout::getMvcInstance()->getView();
			$view->addScriptPath(APPLICATION_PATH.'/modules/shared_views/scripts/');
		}
		//---------------------------------------------------------------------------------------------------
	}
	
	/**
	* @desc
	* handles application errors (ie. no controller found, action does not exist)
	*
	* @void
	*	
	* @return none
	*
	* @access public
	*/	
    public function errorAction(){
		//----------------------------------------------------------------------------------------------
		//prepare response and clear the response body / headers
		$this->getResponse()->clearBody();
		$this->getResponse()->clearHeaders();
 		$this->getResponse()->setHttpResponseCode($this->statusCode);
		//----------------------------------------------------------------------------------------------
		//navigation helper re-set title 
		try{
			//-----------------------------------------------------------------------------------------
			//switch off autorenderer
			Zend_Controller_Front::getInstance()->setParam('noViewRenderer', true);
			//-----------------------------------------------------------------------------------------
			//navigation
			$navigation = Zend_Controller_Front::getInstance()->getPlugin('Acanvas_Zend_View_Helper_Page');
			if(!$navigation instanceof Acanvas_Zend_View_Helper_Page){
				throw new Exception('rendering default error, plugins not found', 6001);	
			}
			//-----------------------------------------------------------------------------------------
			//node
			$node = $navigation->getNodeById('error_'.$this->statusCode);
			if(!$node instanceof Zend_Navigation_Page_Mvc){
				throw new Exception('rendering default error, node not found', 6002);		
			}
			$node->setActive();
			$this->view->headTitle($node->title, 'SET');
			//-----------------------------------------------------------------------------------------
			//re-load naviagtion properties
			$navigation->preDispatch($this->getRequest());
			//-----------------------------------------------------------------------------------------
			//render view
			echo $this->view->render('error/error_'.$this->statusCode.'.phtml');
		}
		catch(Exception $e){
			//render default tpl
			$this->view->headTitle('Server-Error'.$e->getMessage(), 'SET');
			echo $this->view->render('error/error_default.phtml');
		}
    }
	
	/**
	* @desc
	* dumps error-stack (uncomment manually)
	* notice! "full" error object can lead to bufferoverflow (Allowed memory size)
	* _debug (full,exception,request)
	*
	* @void
	*	
	* @return none
	*
	* @access public
	*/
	private function dumpError(){
		//-----------------------------------------------------------------------------------------
		//dump errors in non productionmode 
		if(APPLICATION_ENV !== 'production'){
			//dumpstack
			$dump = strtolower($this->getRequest()->_dump);
			//full error object can lead to bufferoverflow (Allowed memory size)
			if(isset($this->_errors->request) && strstr($dump, 'full')){ 
				Acanvas_Debug::dump($this->_errors, 'ERROR_OBJECT::FULL');
			}
			else{
				if(isset($this->_errors->exception)){
					Acanvas_Debug::dump(
						array(
							'type' => $this->exceptionType.' ('.$this->statusCode.')',
							'message' => $this->_errors->exception->getMessage(),
							'info' => 'use _dump to view details', 
							'filename' => $this->_errors->exception->getFile(), 
							'line' => $this->_errors->exception->getLine()
						), 
						'ERROR_OBJECT::'.$this->exceptionType
					);
					if(strstr($dump, 'exception')){
						Acanvas_Debug::dump($this->_errors->exception, 'ERROR_OBJECT::EXCEPTION');
					}
				}
				if(isset($this->_errors->request) && strstr($dump, 'request')){
					Acanvas_Debug::dump($this->_errors->request, 'ERROR_OBJECT::REQUEST');
				}
			}
		}
		//-----------------------------------------------------------------------------------------	
	}
	
	/**
	* @desc
	* logs/mails error-infos (uncomment manually)
	*
	* @void
	*	
	* @return none
	*
	* @access public
	*/
	private function logError(){
		if(isset($this->_errors->exception) && is_object($this->_errors->exception)){
			//-----------------------------------------------------------------------------------------
			//exclude specific exception-codes from logging
			if(in_array($this->_errors->exception->getCode(), $this->_excludeFromLogging)){
				$this->logCustomEvent = false;
			}
			else{
				foreach($this->_excludeFromLogging as $excludeCode){
					if(strstr($excludeCode, '*')){
						$subExcludeCode = str_replace('*', '', $excludeCode);
						$subCode = substr($this->_errors->exception->getCode(), 0, strlen($subExcludeCode));
						//if code in range do not log
						if((string) $subCode === (string) $subExcludeCode){
							$this->logCustomEvent = false;	
						}
					}
				}
			}
			//-----------------------------------------------------------------------------------------
			//log error-message
			if($this->logCustomEvent === true){
				$logstring  =  $this->exceptionType.': ' . $this->_errors->exception->getMessage() . PHP_EOL;
				$logstring .= '[code: ' . $this->_errors->exception->getCode() . ']' . PHP_EOL;
				$logstring .= '[referer: '. $this->getRequest()->getRequestUri() . ']' . PHP_EOL;
				$logstring .= '[file: ' . $this->_errors->exception->getFile() . ']' . PHP_EOL;
				$logstring .= '[line: ' . $this->_errors->exception->getLine() . ']' . PHP_EOL;
				//-----------------------------------------------------------------------------------------
				//switch logtype (depends on configuration)
				switch($this->logType){ 
					//write into zend_server monitoring (if exists)
					case('monitor_custom_event'): 
						if(function_exists('monitor_custom_event')){
							monitor_custom_event($this->exceptionType, 'SYSTEM_ERROR: '.$logstring, true);	
						}
					break;
					//write into common error_log
					case('error_log'):
						error_log(str_replace(PHP_EOL, ' ', $logstring));		
					break;
					//write as mail
					case('mail'):
						if(is_array($this->_mailReceiver) && !empty($this->_mailReceiver)){
							foreach($this->_mailReceiver as $email){
								mail($email , $this->getRequest()->getServer('HTTP_HOST').': '.$this->exceptionType , $logstring);	
							}
						}
					break;
				}
			}
			//-----------------------------------------------------------------------------------------
		}
	}
	
	/**
	* @description
	* sets flag if ajax request should be handled differently
	*
	* @input-required:
	* @param -> $flag	:boolean
	*
	* @return :this
	*
	* @access public
	*/
	public function setSendJsonOnXmlHttpRequest($flag){
		if(!is_bool($flag) && (!$flag === 1 && !$flag === 0)){
			throw new Exception('sendJsonOnXmlHttpRequest must be type of boolean', 1001)	;
		}
		$this->sendJsonOnXmlHttpRequest = (bool) $flag;
	return $this;
	}
	
	/**
	* @description
	* sets flag if custom events should be logged or not
	*
	* @input-required:
	* @param -> $flag	:boolean
	*
	* @return :this
	*
	* @access public
	*/
	public function setLogCustomEvent($flag){
		if(!is_bool($flag) && (!$flag === 1 && !$flag === 0)){
			throw new Exception('logCustomEvent must be type of boolean', 1001)	;
		}
		$this->logCustomEvent = (bool) $flag;
	return $this;
	}
	
	/**
	* @description
	* sets logtype ('none', 'monitor_custom_event' , 'error_log', 'mail')
	*
	* @input-required:
	* @param -> $logType	:string
	*
	* @return :this
	*
	* @access public
	*/
	public function setLogType($logType){
		if(!in_array($logType, array('none', 'monitor_custom_event', 'error_log', 'mail'))){
			throw new Exception('logType must be type of string an can take the following values: "none, monitor_custom_event, error_log, mail"', 1001)	;
		}
		$this->logType = $logType;
	return $this;
	}
	
	/**
	* @description
	* sets mailreceiver (if logtype=mail)
	*
	* @input-required:
	* @param -> $_mailReceiver	:array
	*
	* @return :this
	*
	* @access public
	*/
	public function setMailReceiver($_mailReceiver){
		if(!is_array($_mailReceiver) || empty($_mailReceiver)){
			throw new Exception('_mailReceiver must be type of array', 1001)	;
		}
		$this->_mailReceiver = $_mailReceiver;
	return $this;
	}
	
	/**
	* @description
	* sets excluded exception-codes
	*
	* @input-required:
	* @param -> $_excludeFromLogging	:array
	*
	* @return :this
	*
	* @access public
	*/
	public function setExcludeFromLogging($_excludeFromLogging){
		if(!is_array($_excludeFromLogging) || empty($_excludeFromLogging)){
			throw new Exception('_excludeFromLogging must be type of array', 1001)	;
		}
		$this->_excludeFromLogging = $_excludeFromLogging;
	return $this;
	}
	
	/**
	* @description
	* setOptions (exceptions are ignored)
	*
	* @input-required:
	* @param -> $_options	:array 
	*
	* @return :none
	*
	* @access public
	*/
	public function setOptions(array $_options = array()){
		//set-options
		if(!empty($_options)){
			foreach($_options as $name => $_args){
				$func = (string) 'set'.ucwords(strtolower($name));
				if(method_exists($this, $func)){
					$_args = array($_args);	
					if(!empty($_args)){
						try{
							call_user_func_array(array($this, $func), $_args);	
						}
						catch(Exception $e){
							if(APPLICATION_ENV !== 'production'){
								echo $e->getMessage();	
							}
						}
					}
				}
			}
		}
	}
		
}