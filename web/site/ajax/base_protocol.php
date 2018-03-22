<?php

//error_code
//1001 - no action supplied
//1002 - mysql error
//1003 - not connected to ape
//1004 - connected in another browser or pc
//1005 - game error

	include_once('init.php');
	include_once('base_protocol.class.php');
	set_time_limit(0);
	
	//check action and form a query
	$action = $_POST['action'];
	$params = $_POST['params'];
	//$action = 'authorize_user';
	//$params = array('"skoba"','"12345"');
	if ($action=='')
	die( 
	  json_encode(
	    array(
	      'header_result'=>array(
					'success'=>0,
					'error_code'=>1001, //no action supplied
					'error_params'=>0
	      )
	    )
	  )
	);
	
	$res = BaseProtocol::execCmd($action, $params);
	
	if ($res["success"] != true) {
		die( 
			json_encode(
				array(
					'header_result'=>array(
						'success'=>0,
						'error_code'=>1002, //mysql error
						'error_params'=>urlencode($res["error"])
					)
				)
			)
		);
	}
	
	//send results
	$results_json = json_encode($res["results"]);
	echo $results_json;
?>