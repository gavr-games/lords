<?php

//error_code
//1001 - no action supplied
//1002 - mysql error
//1003 - not connected to ape
//1004 - connected in another browser or pc
//1005 - game error

	include_once('init.php');
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
	$query = 'call '.$DB_conf['site'].'.'.$action.'(';
	
	foreach($params as $param)	{
	  $param = urldecode($param);
	  $param = strip_tags($param);
	  $param = str_replace(array(chr(10),chr(13)),array('',''),$param);
	  $query .= $param.',';
	}
	$query=trim($query,",");
	$query .= ');';
	
	//execute query
	//print_r($query);
	$results = array();
	$i = 0;
	if (mysqli_multi_query($dataBase->dbLink,$query))
	 do {
	    if ($result = $mysqli->store_result()) {
		while ($row = mysqli_fetch_assoc($result)) {
		    if ($i==0) $results['header_result'] = $row;
		    else if ($i==1) {
		      if ($row['name']!=''){
			$row['value'] = htmlspecialchars($row['value']);
			$results['data_result'][$row['name']] = $row['value'];
		      }
		    }
		}
		$result->free();
		$i++;
	    }
	    /* print divider */
		  if ($mysqli->more_results()) {
		  }
	} while ($mysqli->next_result());
	//check for errors in query
	$error = mysqli_error($dataBase->dbLink);
	if ($error!='')
	die( 
	  json_encode(
	    array(
	      'header_result'=>array(
		'success'=>0,
		'error_code'=>1002, //mysql error
		'error_params'=>urlencode($error)
	      )
	    )
	  )
	);
	
	//send results
	echo json_encode($results);
	
	//post actions
	if ($action=='user_authorize')	{
	  if ($results['header_result']['success']=='1'){
	    $_SESSION['user_id'] = $results['data_result']['user_id'];
	  }
	}
?>