<?php
/*
 +---------------------------------------------------------------------------------------+
| Copyright (c) 2013, Nils Döhring													|
| All rights reserved.																	|
| Author: Nils Döhring <nils.doehring@gmail.com>									|
+---------------------------------------------------------------------------------------+
*
* @desc Bootstrap initializes Application
* i.e. loads runtime resources, configuration, session setup, routing, caching, intrusion detection
*
* @author _________nils.doehring
* @version:________1.0
* @lastmodified:___$Date: $
* @revision:_______$Revision: $
* @copyright:______Copyright (c) Block Forest
*
* @avaliable constants when bootstrap initializing finished (dispatching started)
* APPLICATION_PATH			//application path
* APPLICATION_PATH_TEMP    //application path temp
* APPLICATION_PATH_ROOT	//application path to first accessible node on server
* APPLICATION_PATH_HTDOCS  //application path to hddocs | www (webroot)
* APPLICATION_PATH_LIBRARY //application path to libraries (Zend | Acanvas | Tools)
* APPLICATION_URI			//application url
* APPLICATION_ENV	 		//application envrionment
* APPLICATION_ENC	 		//application encoding
* APPLICATION_LANG	 		//application language
*
* @available Zend_Registry entries
* Application_Config		//general setup
* Zend_Locale				//internationalization, localisation  (L10n, I18n)
* Zend_Navigation			//site naviagtion
* Cache					//caching object
* CacheStatic				//caching fallback
*
* @security:
* PHP_IDS (for errorlogging uncomment: error_log | monitor_custom_event)
*
*/

class Bootstrap extends Zend_Application_Bootstrap_Bootstrap{
	/*	+-----------------------------------------------------------------------------------+
	 | 	member vars
	+-----------------------------------------------------------------------------------+  */
	/**
	 * request for use within bootstrap (routed params not available)
	 * @var  :Zend_Controller_Request_Http
	 */
	private $request = NULL;

	/**
	 * request for use within bootstrap (routed params not available)
	 * @var  :Zend_Controller_Response_Http
	 */
	private $response = NULL;

	/**
	 * session for use within bootstrap
	 * @var  :Zend_Session_Namespace
	 */
	private $sessionNamespace = NULL;

	/**
	 * is application configurated as multilang
	 * @var  :boolean
	 */
	private $isMultilang = true;

	/**
	 * internal currently used language
	 * @var  :string
	 */
	private $language = 'de';

	/**
	 * default: locale
	 * @var  :string
	 */
	private $defaultLocale = 'de_DE';

	/**
	 * default: timezone
	 * @var  :string
	 */
	private $defaultTimezone = 'Europe/Berlin';

	/**
	 * predefined indexes will be saved to session (ie. admin requests '_')
	 * @var :array
	 */
	private $_sessionSystemParams = array(
			'system_debug',
			'system_iplc'
	);
	/*	+-----------------------------------------------------------------------------------+
	 | 	initializes application resources (called via Zend Reflection)
	+-----------------------------------------------------------------------------------+  */
	//(called by Reflection)
	protected function _initApplication(){
		//----------------------------------------------------
		//avoid direct echo failures in callstack before rendereing
		ob_start();
		//----------------------------------------------------
		//set default timezone
		//Since PHP 5.1.0 calls to a date/time function generate E_NOTICE if timezone not valid,
		date_default_timezone_set($this->defaultTimezone);
		//----------------------------------------------------
		//set standard bootstrap request
		$this->request = new Zend_Controller_Request_Http();
		//----------------------------------------------------
		//set standard bootstrap response
		$this->response = new Zend_Controller_Response_Http();
		//----------------------------------------------------
		//configure debugging-output
		Acanvas_Debug::setOptions(
		array(
		'enableEcho' 	=> false,
		'enableBuffer' 	=> (APPLICATION_ENV !== 'production') ? true : false,
		'enableDebug' 	=> (APPLICATION_ENV !== 'production') ? true : false,
		)
		);

		//Zend_Controller_Front::getInstance()->setParam('noErrorHandler', true);
		//----------------------------------------------------
		//Notice! keep callstack order (regard dependencies)
		//comment if not using (initPluginsAndHelpers() must be handled manually)
		//----------------------------------------------------
		//initializes application configuration:
		$this->initConfig();
		//build namespaces for autoloader
		$this->initAutoload();
		//initializes session management (global) (depends on config)
		$this->initSession();
		//initialize MCV Layout
		$this->initLayout();
		//init system-request params
		$this->initSystemRequests();
		//inits language (in case lang comes via path)
		$this->initLanguage();
		//init locale/language (global) (depends on config) locale-based classes using it automatically
		$this->initLocale();
		//initialize routing/routes (depends on config, language)
		$this->initRoute();
		//initialize default db adapter (depends on config, language)
		$this->initDatabase();
		//initialize global plugins an helper (depends on layout)
		$this->initPluginsAndHelpers();
		//initialize Navigation  (depends on routes)
		//XXX we're skipping this for now
		//$this->initNavigation();
		//initialize cache (global) (depends on config, language)
		$this->initCache();
		//init intrusion detection system (depends on external lib)
		$this->initPHPIDS();
		//init response (default caching header)
		$this->initResponse();
	}

	/**
	 * @desc
	 * Initialize application configuration (application.ini)
	 *
	 * @Zend_Registry -> Application_Config
	 *
	 * sets global constant(s)
	 * APPLICATION_URI, APPLICATION_ENC
	 *
	 * @params void()
	 *
	 * @access private
	 */
	private function initConfig(){
		try{

			// REGISTRY - setup the application registry
			// An application registry allows the application to store application
			// necessary objects into a safe and consistent (non global) place for future
			// retrieval.  This allows the application to ensure that regardless of what
			// happends in the global scope, the registry will contain the objects it
			// needs.

			// CONFIGURATION - Setup the configuration object
			// The Zend_Config_Ini component will parse the ini file, and resolve all of
			// the values for the given section.  Here we will be using the section name
			// that corresponds to the APP's Environment
			Zend_Registry::set(
			'Application_Config',
			new Zend_Config_Ini(APPLICATION_PATH . '/configs/application.ini', APPLICATION_ENV)
			);

			defined('APPLICATION_URI') || define('APPLICATION_URI', Zend_Registry::get('Application_Config')->page->domain);
			defined('APPLICATION_ENC') || define('APPLICATION_ENC', Zend_Registry::get('Application_Config')->page->charset);

			Zend_Controller_Front::getInstance()->throwExceptions(true);
		}
		catch(Exception $e){
			throw new Zend_Application_Exception('Bootstrap->initConfig() failed with message('.$e->getMessage().')', 2000);
		}
	}

	/**
	 * @desc
	 * Initializes Autoloader Paths/Routes
	 *
	 * @params void()
	 *
	 * @access private
	 */
	private function initAutoload(){
		try{
			//--------------------------------------------
			//plugincache-optimizer - improve the performance of production server(s)
			require_once(APPLICATION_PATH.'/cache/plugincache.php');
			//don't use this - it kills AMF:
			//Zend_Loader_PluginLoader::setIncludeFileCache(APPLICATION_PATH.'/cache/plugincache.php');
			//--------------------------------------------
			//init models
			$resourceLoader = new Zend_Loader_Autoloader_Resource(array(
					'basePath'      => APPLICATION_PATH,
					'namespace'     => 'Acanvas',
					'resourceTypes' => array(
							'model' => array(
									'path'      => 'models/',
									'namespace' => 'Model',
							),
					),
			));
			//--------------------------------------------
			//init forms
			$resourceLoader = new Zend_Loader_Autoloader_Resource(array(
					'basePath'      => APPLICATION_PATH,
					'namespace'     => 'Acanvas',
					'resourceTypes' => array(
							'model' => array(
									'path'      => 'forms/',
									'namespace' => 'Form',
							),
					),
			));
			//--------------------------------------------
			//init autoload
			$autoloader = Zend_Loader_Autoloader::getInstance();
			$autoloader->suppressNotFoundWarnings((APPLICATION_ENV === 'production') ? true : false);
			$autoloader->registerNamespace('Acanvas');
		}
		catch(Exception $e){
			throw new Zend_Application_Exception('Bootstrap->initAutoload() failed with message('.$e->getMessage().')', 2000);
		}
	}

	/**
	 * @desc
	 * Initialize application session
	 * @see http://www.php.net/manual/de/session.configuration.php
	 *
	 * @params void()
	 *
	 * @access private
	 */
	private function initSession(){
		try{
			if(isset(Zend_Registry::get('Application_Config')->session)){
				Zend_Session::setOptions(
				Zend_Registry::get('Application_Config')->session->toArray()
				);
			}
			//deny session restore
			//Zend_Session::forgetMe();
			//start session
			Zend_Session::start();
			//avoid session fixiation
			$this->sessionNamespace = new Zend_Session_Namespace('Acanvas_System');
			if(!isset($this->sessionNamespace->initialized)){
				Zend_Session::regenerateId();
				$this->sessionNamespace->initialized = true;
			}
		}
		catch(Exception $e){
			throw new Zend_Application_Exception('Bootstrap->initSession() failed with message('.$e->getMessage().')', 2000);
		}
	}

	/**
	 * @desc
	 * Initialize layout (basic template)
	 * (can be overwritten in each controller if required)
	 *
	 * @params void()
	 *
	 * @access private
	 */
	private function initLayout(){
		try{
			//TODO layout path
			Zend_Layout::startMvc(
			array(
			'layoutPath' => APPLICATION_PATH.'/layouts',
			'layout'     => 'default',
			'viewSuffix' => 'phtml'
					)
			);
			//add "shared_views" module to scriptpath (only shared scripts in here)
			//Zend_Layout::getMvcInstance()->getView()->addScriptPath(APPLICATION_PATH.'/modules/shared_views/scripts/');
			//------------------------------------------------
			//adding global view params
			//not nice but functional permanent view-id facebookid
			//Zend_Layout::getMvcInstance()->getView()->appId = Zend_Registry::get('Application_Config')->facebook->appid;
			//------------------------------------------------
		}
		catch(Exception $e){
			throw new Zend_Application_Exception('Bootstrap->initLayout() failed with message('.$e->getMessage().')', 2000);
		}
	}

	/**
	 * @desc
	 * Initialize application admin request
	 *
	 * @params void()
	 *
	 * @access private
	 */
	private function initSystemRequests(){
		try{
			//init view
			$view = Zend_Layout::getMvcInstance()->getView();
			//check if requestin ip in configuration
			if(
			//XXX admin IP limitation commented out
			$this->request->isGet() /* &&
			in_array(Acanvas_Http_Request::getIp(), Zend_Registry::get('Application_Config')->page->admin_ips->toArray()) */
			){
				$_params = 	$this->request->getParams();
				foreach($_params as $name => $value){
					if($name[0] === '_'){
						//build internal name
						$name = 'system'.$name;
						//add to view and internal
						$this->$name = $value;
						$view->$name = $value;
						if(in_array($name, $this->_sessionSystemParams)){
							$this->sessionNamespace->$name = $value;
						}
					}
				}
			}
			if(!empty($this->sessionNamespace)){
				foreach($this->sessionNamespace as $name => $value){
					//add to view
					$view->$name = $value;
					//keep in request
					$this->request->setParam((string) $name, (string) $value);
				}
			}
		}
		catch(Exception $e){
			throw new Zend_Application_Exception('Bootstrap->initAdminRequests() failed with message('.$e->getMessage().')', 2000);
		}
	}

	/**
	 * @desc
	 * finds pathed language parameter and sets it as requestparam to init locale
	 *
	 * @params void()
	 *
	 * @access private
	 */
	private function initLanguage(){
		try{
			if($this->isMultiLanguage()){
				//try to find language in path if not set via getvar
				$_path = preg_split('/\//', $this->request->getPathInfo(), -1, PREG_SPLIT_NO_EMPTY);
				//fetch configurated languages
				$_languages = Zend_Registry::get('Application_Config')->page->languages->toArray();
				//path matches lang
				if(isset($_path[0]) && isset($_languages[$_path[0]])){
					$this->request->setParam('lang', $_path[0]);
				}


				$data = "";
				$app_data = "";

				/* ===== Facebook Request ===== */
				if($this->request->getParam('signed_request')){
					$secret = Zend_Registry::get('Application_Config')->facebook->secret;
					$data = $this->_parse_signed_request($this->request->getParam('signed_request'), $secret);

					// Optional: app_data (coming either from an invite link, or a share link, both of which are generated inside the app)
					$app_data = $data["app_data"];
				}

				//if app_data was not included in FB's signed request, try to parse it from get
				if(empty($app_data)){
					$app_data = $this->request->getParam('app_data');
				}

				$is_https = $this->request->getServer("HTTPS");
				$protocol = strtolower($is_https) == 'on' ? 'https' : 'http';


				/* ===== LANGUAGE/COUNTRY/MARKET ===== */
				/*
				 language defaults are set in project.properties.
				override 1: GET: by setting GET parameters.
				override 2: WHITELIST: if in an FB iframe, and if several page IDs are set in www.properties, the locale is defined there.
				override 3: LOCALE: if in an FB iFrame, the user's locale is read.
				if the language is in the whitelist: wohoo!
				*/

				$properties = Zend_Registry::get('Application_Config');
					
				//whitelists (see properties.ini)
				$languageWhitelist 		= $properties->page->languages->toArray();
				$pageWhitelist 			= $properties->facebook->page_ids->toArray();

				//language default or GET
				$language = $properties->page->language->default;
				if ($this->request->getQuery("language")) {
					$language = $this->request->getQuery("language");
				}

				//locale by country/language; used to load correct facebook sdk
				$locale = $properties->page->locales->toArray();
				$locale = $locale[$language];

				//in a Facebook iFrame, the page's id is provided by Facebook.
				if ( isset($data["page"] ) && isset($data["page"]["id"] ) && !empty($pageWhitelist)){
					if(in_array($data["page"]["id"], $pageWhitelist)){
						$lkey = array_search($data["page"]["id"], $pageWhitelist);
						$language = $languageWhitelist[$lkey];
						$locale = $data["user"]["locale"];
					}
				}
				//alternatively, take the user's locale provided by Facebook
				else if ( isset($data["user"] ) && isset($data["user"]["locale"] ) ){
					if(in_array(substr($data["user"]["locale"], 0, 2), $languageWhitelist)){
						//if language not given by GET, use that of facebook
						if (! $this->request->getQuery("language")) $language = substr($data["user"]["locale"], 0, 2);
						$locale = $data["user"]["locale"];
					}
				}

				$this->language = $language;

				//set language cookie
				Acanvas_Http_Cookie::setCookie(
				array(
				'name'  	=> 'lang',
				'value' 	=> $this->language,
				'time'  	=> 0,
				'path' 		=> '/',
				'domain' 	=> APPLICATION_URI
				)
				);

				$rckdt_registry = Acanvas_Registry::getInstance();

				//add values to configuration
				$rckdt_registry->set('fb_sig_data', $data);
				$rckdt_registry->set('country', substr($locale, 3, 2));
				$rckdt_registry->set('language', $language);
				$rckdt_registry->set('locale', $locale);
				$rckdt_registry->set('protocol', $protocol);
				$rckdt_registry->set('app_data', $app_data);


				/* ===== Include config according to LANGUAGE ===== */
				$configuration_locale = new Zend_Config_Ini(APPLICATION_PATH . '/configs/' . $language . '.ini');

				// add locale stuff to REGISTRY
				$registry = Zend_Registry::set('Application_Config_Locale', $configuration_locale);
			}
		}
		catch(Exception $e){
			throw new Zend_Application_Exception('Bootstrap->initLanguage() failed with message('.$e->getMessage().')', 2000);
		}
	}

	/* STEP 1 - PARSE FACEBOOK SIGNED REQUEST */
	private function _parse_signed_request($signed_request, $secret) {
		list($encoded_sig, $payload) = explode('.', $signed_request, 2);
		$sig = $this->_base64_url_decode($encoded_sig);
		$data = json_decode(base64_url_decode($payload), true);

		if (strtoupper($data['algorithm']) !== 'HMAC-SHA256') {
			// return null;
		}

		$expected_sig = hash_hmac('sha256', $payload, $secret, $raw = true);

		if ($sig !== $expected_sig) {
			// return null;
		}
		return $data;
	}
	private function _base64_url_decode($input) {
		return base64_decode(strtr($input, '-_', '+/'));
	}

	/**
	 * @desc
	 * Initialize locale settings used application wide
	 * binds Zend_Locale to registry (key must be 'Zend_Locale') to use it as application-wide locale.
	 *
	 * @Zend_Registry -> Zend_Locale
	 *
	 * @params void()
	 *
	 * @access private
	 */
	private function initLocale(){
		try{
			$rckdt_registry = Acanvas_Registry::getInstance();

			//create locale object with the passed configuration
			$locale = new Zend_Locale($rckdt_registry->get('locale') );
			//set instance of Zend_Locale to registry (key must be 'Zend_Locale') to use application wide locale.
			Zend_Registry::set('Zend_Locale', $locale);
			//set language as global viewparameter (frontend)
			Zend_Layout::getMvcInstance()->getView()->language = $locale->getLanguage();
			//set languages as global viewparameter (frontend)
			if($this->isMultiLanguage()){
				Zend_Layout::getMvcInstance()->getView()->languages = Zend_Registry::get('Application_Config')->page->languages->toArray();
			}
			//add as gloabl constant (backend)
			defined('APPLICATION_LANG') || define('APPLICATION_LANG', $locale->getLanguage());
		}
		catch(Exception $e){
			throw new Zend_Application_Exception('Bootstrap->initLocale() failed with message('.$e->getMessage().')', 2000);
		}
	}

	/**
	 * @desc
	 * routing specified in routes.ini (notice! no sections used cause routes stay the same each env)
	 *
	 * @params void()
	 *
	 * @access private
	 */
	private function initRoute(){
		try{
			//---------------------
			$controller = Zend_Controller_Front::getInstance();
			$controller->setControllerDirectory(
					array(
							'default' => APPLICATION_PATH.'/modules/default/controllers',
							'admin' => APPLICATION_PATH.'/modules/admin/controllers'
					)
			);

			$router = $controller->getRouter();
			$router->addDefaultRoutes();

			$router->addConfig(
					new Zend_Config_Ini(APPLICATION_PATH. '/configs/routes.ini'),
					'routes'
			);

			//XXX disable complex routing for now
			return;

			//add language parameter
			//$router->setGlobalParam('lang', Zend_Registry::get('Zend_Locale')->getLanguage());
			//setup controller-directories
			//---------------------
			//setup language routing if app is multilang
			if($this->isMultiLanguage()){
				//setup the language route for chaining
				$langRoute = new Zend_Controller_Router_Route(
						':lang/',
						array(
								'lang' => $this->language,
								'controller' => 'index',
								'action' => 'index'
						),
						array( //allows configurated languages only
								'lang' => '('.implode('|', array_keys(Zend_Registry::get('Application_Config')->page->languages->toArray())).')'
						)
				);
				//loop routes and chain each route to language
				foreach($router->getRoutes() as $name => $route) {
					$chain = new Zend_Controller_Router_Route_Chain();
					$router->addRoute(
							$name . '_lang',
							$chain->chain($langRoute)->chain($route) //chain
					);
				}
				$router->addRoute('_lang', $langRoute);
			}
			//---------------------
			//if set to true 404 pages will forward to "/index/index" ->  "/"
			//$controller->setParam('useDefaultControllerAlways', true);
			//set router in front controller
			$controller->setRouter($router);
		}
		catch(Exception $e){
			throw new Zend_Application_Exception('Bootstrap->initRoute() failed with message('.$e->getMessage().')', 2000);
		}
	}

	/**
	 * @desc
	 * Initialize database and profiler configuration
	 *
	 * @params void()
	 *
	 * @access private
	 */
	private function initDatabase(){
		try{
			// DATABASE ADAPTER - Setup the database adapter
			// Zend_Db implements a factory interface that allows developers to pass in an
			// adapter name and some parameters that will create an appropriate database
			// adapter object.  In this instance, we will be using the values found in the
			// "database" section of the configuration obj.
			$db = Zend_Db::factory(Zend_Registry::get('Application_Config')->db);
			$db->setFetchMode(Zend_Db::FETCH_ASSOC);

			//Profiling via Firebug in devmode
			if(APPLICATION_ENV !== 'production'){
				$profiler = new Zend_Db_Profiler_Firebug('All_DB_Queries');
				$profiler->setEnabled(true);
				$db->setProfiler($profiler);
			}

			// DATABASE TABLE SETUP - Setup the Database Table Adapter
			// Since our application will be utilizing the Zend_Db_Table component, we need
			// to give it a default adapter that all table objects will be able to utilize
			// when sending queries to the db.
			Zend_Db_Table::setDefaultAdapter($db);

			// add to REGISTRY
			Zend_Registry::set('dbAdapter', $db);
		}
		catch(Exception $e){
			throw new Zend_Application_Exception('Bootstrap->initDatabase() failed with message('.$e->getMessage().')', 2000);
		}
	}

	/**
	 * @desc
	 * Initialize global view helpers and Plugins
	 * (can be removed or enhanced in Action_Controller if required)
	 *
	 * @params void()
	 *
	 * @access private
	 */
	private function initPluginsAndHelpers(){
		try{
			//---------------------
			//register Loginstate
			Zend_Controller_Front::getInstance()->registerPlugin(
			new Acanvas_Zend_Plugin_LoginStatus()
			);
			//---------------------
			//register Rewrite/Mock Current IP Adress
			Zend_Controller_Front::getInstance()->registerPlugin(
			new Acanvas_Zend_Plugin_RewriteIp()
			);
			//---------------------
			//register Permanent-SSL-Switch
			Zend_Controller_Front::getInstance()->registerPlugin(
			new Acanvas_Zend_Plugin_SslSwitch(Zend_Registry::get('Application_Config')->page->sslenvironments)
			);
			//---------------------
			//register MobileDetection-Plugin
			Zend_Controller_Front::getInstance()->registerPlugin(
			new Acanvas_Zend_Plugin_DetectMobile()
			);
			//---------------------
			//register Interim-Plugin (maintenance)
			if(isset(Zend_Registry::get('Application_Config')->page->maintenance) && Zend_Registry::get('Application_Config')->page->maintenance === 'on'){
				Zend_Controller_Front::getInstance()->registerPlugin(new Acanvas_Zend_Plugin_Maintenance());
			}
			//---------------------
			//global available ViewHelper
			$navigationHelper = new Acanvas_Zend_View_Helper_Page(
					array(
							'doctype' => Zend_Registry::get('Application_Config')->page->doctype, //change global doctype here - default is 'XHTML5'
							'charset' => Zend_Registry::get('Application_Config')->page->charset,
							'defaults' => Zend_Registry::get('Application_Config_Locale')->toArray(),
							'htmlify' => false,
							'addLanguage' => true
					)
			);
			//---------------------
			//meta-, naviagtion- and activepath-helper (dynamically builds page title and metas
			Zend_Controller_Front::getInstance()->registerPlugin(
			$navigationHelper
			);
			//---------------------
			Zend_Layout::getMvcInstance()->getView()->registerHelper($navigationHelper, 'link');//(linkhandler)
			Zend_Layout::getMvcInstance()->getView()->registerHelper($navigationHelper, 'page');//(get currentpagevalues)
			Zend_Layout::getMvcInstance()->getView()->registerHelper(new Acanvas_Zend_View_Helper_FormText(), 'FormText');//(renders html5 form elements) //if doctype XHTML5
			Zend_Layout::getMvcInstance()->getView()->registerHelper(new Acanvas_Zend_View_Helper_Script(), 'script');	//footerscript parent of headscript
		}
		catch(Exception $e){
			throw new Zend_Application_Exception('Bootstrap->initPluginsAndHelpers() failed with message('.$e->getMessage().')', 2000);
		}
	}

	/**
	 * @desc
	 * Initialize site Navigation
	 * Plugin "Plugin_Navigation_Active" handles html-header (title, meta)
	 *
	 * @params void()
	 *
	 * @access private
	 */
	private function initNavigation(){
		try{
			if(!is_dir(APPLICATION_PATH.'/configs/'.Zend_Registry::get('Zend_Locale')->getLanguage())){
				throw new Zend_Application_Exception('chosen language not available', 1000);
			}
			$navigation = new Zend_Navigation(
					Acanvas_Loader::import(
							APPLICATION_PATH.'/configs/'.Zend_Registry::get('Zend_Locale')->getLanguage().'/navigation.php'
					)
			);
			Zend_Layout::getMvcInstance()->getView()->navigation($navigation);
			Zend_Registry::set('Zend_Navigation', $navigation);
		}
		catch(Exception $e){
			throw new Zend_Application_Exception('Bootstrap->initPluginsAndHelpers() failed with message('.$e->getMessage().')', 2000);
		}
	}

	/**
	 * @desc
	 * Initialize standard-cache and static-cache objects and assign them to registry
	 * @see application.ini for configuration
	 *
	 * @params void()
	 *
	 * @access private
	 */
	private function initCache(){
		try{
			//load application config
			$config = Zend_Registry::get('Application_Config');
			//gc flag
			$cleanMode = false;
			//---------------------------------------------------------
			//create cachedir if not exists
			if(!is_dir($config->cache->backend->options->cache_dir)){
				@chmod(dirname($config->cache->backend->options->cache_dir), 0777);
				@mkdir($config->cache->backend->options->cache_dir);
				$_errors = error_get_last();
				if(isset($_errors['message']) && strstr($_errors['message'], 'mkdir')){
					throw new Zend_Application_Exception('could not create cache directory. please ensure permissions for directory: '.$config->cache->backend->options->cache_dir, 2000);
				}
			}
			//---------------------------------------------------------
			//overwrite caching (false) parameter via get (if ips within admin-state)
			$_frontendOptions = $config->cache->frontend->options->toArray();
			if(isset($this->system_refresh)){
				if($this->system_refresh != 1){
					$cleanMode = 'CLEAR_BY_TAG';
				}
				else{
					$cleanMode = 'CLEAR_ALL';
				}
			}
			//---------------------------------------------------------
			//common cache
			Zend_Registry::set(
			'Cache',
			Zend_Cache::factory(
			$config->cache->frontend->adapter, 	//i.e 'Core'
			$config->cache->backend->adapter,	//i.e 'File'
			$_frontendOptions,
			$config->cache->backend->options->toArray()
			)
			);
			//---------------------------------------------------------
			//fallback/static cache (never cleared)
			Zend_Registry::set(
			'CacheStatic',
			Zend_Cache::factory(
			$config->cache->frontend->adapter,
			$config->cache->backend->adapter,
			array_merge(
			$config->cache->frontend->options->toArray(),
			array('lifetime' => NULL)
			),
			$config->cache->backend->options->toArray()
			)
			);
			//---------------------------------------------------------
			//cleanup with passed tags
			if($cleanMode === 'CLEAR_BY_TAG'){
				Zend_Registry::get('Cache')->clean(
				Zend_Cache::CLEANING_MODE_MATCHING_TAG,
				preg_split('/,/', $this->system_refresh, -1, PREG_SPLIT_NO_EMPTY)
				);
			}
			//clean all except static
			elseif($cleanMode === 'CLEAR_ALL'){
				Zend_Registry::get('Cache')->clean(
				Zend_Cache::CLEANING_MODE_NOT_MATCHING_TAG,
				array('static')
				);
			}
			//---------------------------------------------------------
		}
		catch(Exception $e){
			throw new Zend_Application_Exception('Bootstrap->initCache() failed with message('.$e->getMessage().')', 2000);
		}
	}

	/**
	 * @desc
	 * Initilize Intrusion Detection System
	 * detects attacks (XSS, SQL-Injection ...) log 'em an redirects attacker to systemerror-page
	 *
	 * @params void()
	 *
	 * @access private
	 */
	private function initPHPIDS(){
		//libpath
		defined('PHP_IDS_PATH') || define('PHP_IDS_PATH', APPLICATION_PATH_LIBRARY.'/phpids-0.7/lib/');
		//--------------------------------------------------------------------------------------------
		//ensure tmp is writable
		if(!is_writable(PHP_IDS_PATH.'IDS/tmp/')){
			throw new Zend_Application_Exception('cannot write to directory. please ensure permissions for directory: '.PHP_IDS_PATH.'IDS/tmp/', 2000);
		}
		//--------------------------------------------------------------------------------------------
		//add to inlcude Path an load Library
		$includePath = get_include_path();
		set_include_path(
		PHP_IDS_PATH . PATH_SEPARATOR . $includePath
		);
		require_once( 'IDS/Init.php');
		//--------------------------------------------------------------------------------------------
		//parse path to values and assign it to get (detects corrupted paths too)
		$_params = $this->request->getParams();
		$_custom = array();
		if($this->request->isGet() && empty($_params)){
			$_custom = preg_split('/\//', $this->request->getPathInfo(), -1, PREG_SPLIT_NO_EMPTY);
		}
		//--------------------------------------------------------------------------------------------
		try{
			$_request = array(
					'CUSTOM' 	=> $_custom,
					'GET' 		=> $_GET,
					'POST' 		=> $_POST
					//'COOKIE' 	=> $_COOKIE
			);
			//--------------------------------------------------------------------------------------------
			$init = IDS_Init::init(PHP_IDS_PATH.'IDS/Config/Config.ini.php');
			//overwrite configuration
			$init->config['Caching']['caching'] 		= 'none';
			$init->config['General']['base_path']   	= PHP_IDS_PATH;
			$init->config['General']['filter_path'] 	= PHP_IDS_PATH.'IDS/default_filter.xml';
			$init->config['General']['tmp_path']   		= PHP_IDS_PATH.'IDS/tmp';
			$init->config['General']['use_base_path']	= false;
			//crate object
			$ids = new IDS_Monitor($_request, $init);
			$result = $ids->run();
			//PHPIDS detects Attacks
			if (!$result->isEmpty()){
				//define allowed items
				$_allowed_items = array();
				//---------------------------------------------------------------------------------------
				//cleanup remove allowed items from testing
				$_iterator 	= $result->getIterator();
				$impact 	= $result->getImpact();
				if($_iterator instanceof IteratorAggregate){
					if(!empty($_allowed_items)){
						foreach($_allowed_items as $item){
							if(isset($_iterator[$item])){
								unset($_iterator[$item]);
							}
						}
					}
					$impact = 0;
					//counting the "real" impact
					foreach($_iterator as $name => $item){
						$_filters = $result->getEvent($name)->getFilters();
						foreach($_filters as $filter){
							$impact += $filter->getImpact();
						}
					}
				}
				//there are errors in iterator after cleanup
				if(count($_iterator) > 0 && $impact > 10){
					if(APPLICATION_ENV !== 'production'){
						Acanvas_Debug::dump($result, 'IMPACT:'. $impact);
					}
					//preparing the errorlog
					$logstring = '';
					foreach($result->getIterator() as $name => $item){
						$logstring .= ' name: '.$name.'  '.PHP_EOL;
						$logstring .= ' value: '.addslashes($result->getEvent($name)->getValue()).'  '.PHP_EOL;
						$logstring .= '	averageimpact: '.$impact.'  '.PHP_EOL;
						//get the filter
						$_filters = $result->getEvent($name)->getFilters();
						if(is_array($_filters) && !empty($_filters)){
							foreach($_filters as $filter){
								$logstring .= ' description('.$filter->getDescription().') impact('.$filter->getImpact().') '.PHP_EOL;
							}
						}
					}
					//log the error in zend_plattform
					$type = 'PHP_IDS:Log';
					if($impact > 10){
						$type = 'PHP_IDS:Attack';
					}
					//error logging
					/*if(isset(Zend_Registry::get('Application_Config')->page->phpids->logtype)){
					//available on zend server
					if(Zend_Registry::get('Application_Config')->page->phpids->logtype === 'monitor_custom_event' && function_exists('monitor_custom_event')){
					monitor_custom_event($type, 'XSS_Attack: '.$logstring, true);
					}
					//error_log
					elseif(Zend_Registry::get('Application_Config')->page->phpids->logtype === 'error_log'){
					error_log($type.': '.$logstring);
					}
					}*/
					//set default to 10 if not set in config
					$maxImpact = isset(Zend_Registry::get('Application_Config')->page->phpids->maximpact) ? Zend_Registry::get('Application_Config')->page->phpids->maximpact : 10;
					//----------------------------------------------------------------
					//forward the attacker system error
					if($impact > $maxImpact){
						//force system error and orward to errorcontroller
						$this->response->clearBody();
						$this->response->clearHeaders();
						$this->response->setHttpResponseCode(500);
						$this->response->renderExceptions(false);
						$this->response->setException(
								new Zend_Application_Exception($type.': '.$logstring, 2000)
						);
						Zend_Controller_Front::getInstance()->setResponse($this->response);
					}
					//----------------------------------------------------------------
				}
			}
		}
		catch(Exception $e){
			throw new Zend_Application_Exception('Bootstrap->initPHPIDS() failed with message('.$e->getMessage().')', 2000);
		}
		//reset includepath
		set_include_path($includePath);
	}

	/**
	 * @desc
	 * Initilize Response Object
	 * set default caching headers
	 *
	 * @params void()
	 *
	 * @access private
	 */
	private function initResponse(){
		try{
			//----------------------------------------------------------------
			//assign current Request-Object to frontController
			Zend_Controller_Front::getInstance()->setRequest($this->request);
			//----------------------------------------------------------------
			//Set default Content-Type
			if($this->response->canSendHeaders()){
				$this->response->setHeader('Content-Type', 'text/html; charset='.APPLICATION_ENC, true);
				$this->response->setHeader('Expires', 'Mon, 26 Jul 1997 05:00:00 GMT', true);
				$this->response->setHeader('Last-Modified', gmdate('D, d M Y H:i:s').' GMT', true);
				$this->response->setHeader('Cache-Control', 'private, no-store, no-cache, must-revalidate, post-check=0, pre-check=0', true);
				$this->response->setHeader('Pragma', 'no-cache', true);
				$this->response->setHeader('P3P', 'CP="ALL DSP COR PSAa PSDa OUR NOR ONL UNI COM NAV"', true);
				Zend_Controller_Front::getInstance()->setResponse($this->response);
			}
		}
		catch(Exception $e){
			throw new Zend_Application_Exception('Bootstrap->initResponse() failed with message('.$e->getMessage().')', 2000);
		}
	}

	/**
	 * @desc
	 * check config for assigned languages
	 *
	 * @void
	 *
	 * @return :boolean
	 *
	 * @access private
	 */
	private function isMultiLanguage(){
		//check configurated languages (isMultilang Application)
		if( $this->isMultilang === true ||
		(
				isset(Zend_Registry::get('Application_Config')->page->languages) &&
				isset(Zend_Registry::get('Application_Config')->page->language->default) &&
				count(Zend_Registry::get('Application_Config')->page->languages->toArray()) >= 1
		)
		){
			$this->isMultilang = true;
			return true;
		}
		return false;
	}

	/**
	 * @desc
	 * delivers bootstrapped language (callable in controller)
	 * $this->getInvokeArg('bootstrap')
	 *
	 * @void
	 *
	 * @return :string
	 *
	 * @access private
	 */
	public function getLanguage(){
		return $this->language;
	}
}