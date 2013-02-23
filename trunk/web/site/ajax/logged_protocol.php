<?php
	include_once('init.php');
	
	//logout
	if ($_POST['action']=="logout"){
	  $_SESSION['user_id'] = '';
	  die( 
	    json_encode(
	      array(
		'header_result'=>array(
		  'success'=>1,
		  'error_code'=>0,
		  'error_params'=>0
		)
	      )
	    )
	  );
	}
	if ($_SESSION['user_id']==''){
		die( 
		  json_encode(
		    array(
		      'header_result'=>array(
			'success'=>0,
			'error_code'=>1003, //not authorized
			'error_params'=>'Not authorized - please refresh browser'
		      )
		    )
		  )
		);
	}
	if (!is_array($_POST['params'])) $_POST['params'] = array();
	array_unshift($_POST['params'],$_SESSION['user_id']);
	//print_r($_POST['params']);
	
	include_once('base_protocol.php');
?>