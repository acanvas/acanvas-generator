<?php

class UploadController extends Zend_Controller_Action
{

	public function init()
	{
		$this->_helper->layout()->disableLayout();
	}

	public function indexAction()
	{
header("Access-Control-Allow-Origin: *");		
if ($this->_request->isPost()) {
			// default path for the image to be stored //
			$default_path = APPLICATION_PATH . '/../public/uploads/';

			// check to see if a path was sent in from flash //
			$target_path = ($_POST['dir']) ? $_POST['dir'] : $default_path;
			if (!file_exists($target_path)) mkdir($target_path, 0777, true);

			//echo var_dump($_FILES);
//return;

			// full path to the saved image including filename //
			$destination = $target_path . basename( $_FILES[ 'Filedata' ][ 'name' ] );

			// move the image into the specified directory //
			if (move_uploaded_file($_FILES[ 'Filedata' ][ 'tmp_name' ], $destination)) {
				echo "The file " . basename( $_FILES[ 'Filedata' ][ 'name' ] ) . " has been uploaded;";
			} else {
				echo "FILE UPLOAD FAILED";
			}
		}else {
			echo "NO POST DATA";
		}

	}
}