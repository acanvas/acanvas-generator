<?php
/*	
+---------------------------------------------------------------------------------------+
| Copyright (c) 2012, Nils Döhring													|
| All rights reserved.																	|
| Author: Nils Döhring <nils.doehring@gmail.com>									|
+---------------------------------------------------------------------------------------+ 
 *
 * @desc Acanvas_Form_PerPage (pagination helper)
 * 
 * @author_________nils.doehring
 * @version________1.0        
 * @lastmodified___$Date: $ 
 * @revision_______$Revision: $ 
 * @copyright______Copyright (c) Block Forest
 *
 * @dependencies (autoloding enabled)
 * @import: Zend_Form
 */
require_once 'Acanvas/Zend/Form.php';

class Acanvas_Form_PerPage extends Acanvas_Zend_Form{
/*	+-----------------------------------------------------------------------------------+
	| 	class constructor /init- set init-parameters
	+-----------------------------------------------------------------------------------+  */	
	/**
	* @description
	* if you use __construct instead of init __toString rendering fails 
	* (solved: call parents construct explizitly)  ie. parent::__construct(); vs init()
	*	
	* @void
	*
	* @return none
	*
	* @access public
	*/
	public function init(){
		try{
			//------------------------------------------------------------------
			//create the formobject
			$this->setMethod(Zend_Form::METHOD_POST)
				 ->setDisableLoadDefaultDecorators(true)
				 ->setDecorators(
				 	array(
						'FormElements',
						'Form'
					)
             	 )
				 ->setAttrib('id', 'form_perpage');
			//------------------------------------------------------------------
			//create element
			$element = new Zend_Form_Element_Select(
				'perpage', 
				array(
					'disableLoadDefaultDecorators' => true,
					'class' => (isset($this->FormConfig->perpage->class) ? $this->FormConfig->perpage->class : ''),
					'label' => (isset($this->FormConfig->perpage->label) ? $this->FormConfig->perpage->label : ''),
					'onchange' => 'submit();'
				)
			);
			$element->addValidator( new Zend_Validate_InArray( $this->FormConfig->perpage->options->toArray() ) )
					->setRequired(false)
					->setDecorators(array('ViewHelper')) 
					->setMultiOptions( $this->FormConfig->perpage->options->toArray() );
			//add label-decorator if label configurated
			if(isset($this->FormConfig->perpage->label)){
				$element->addDecorator('Label');
			}
			$this->addElement($element);
			//------------------------------------------------------------------
		}
		catch(Exception $e){
			Acanvas_Debug::dump($e, $e->getMessage());
		}
	}
}