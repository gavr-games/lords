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
	
	$inputJSON = file_get_contents('php://input');
	$input = json_decode($inputJSON, TRUE);
	$action = $input['action'];
	$params = $input['params'];
	
	BaseProtocol::dieNoAction($action);
	$res = BaseProtocol::execCmd($action, $params);
	BaseProtocol::dieMysqlError($res);
	
	//send results
	$results_json = json_encode($res["results"]);
	echo $results_json;
?>