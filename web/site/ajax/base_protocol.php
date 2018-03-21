<?php

//error_code
//1001 - no action supplied
//1002 - mysql error
//1003 - not connected to ape
//1004 - connected in another browser or pc
//1005 - game error

class BaseProtocol {
	public static function execCmd($action, $params) {
		$query = self::prepareQuery($action, $params);
		return self::execQuery($query);
	}

	public static function prepareQuery($action, $params) {
		global $DB_conf;
		$query = 'call '.$DB_conf['site'].'.'.$action.'(';
	
		$index = 0;
		foreach($params as $param)	{
		  $param = urldecode($param);
		  $param = strip_tags($param);
			$param = str_replace(array(chr(10),chr(13)),array('',''),$param);
			$param = self::modifyParam($action, $index, $param);
			$query .= $param.',';
			$index++;
		}
		$query = trim($query,",");
		$query = self::addParams($action, $query);
		$query .= ');';
		return $query;
	}

	public static function execQuery($query) {
		global $dataBase, $mysqli;

		//execute query
		Logger::info('base_protocol -> '.$query);
		$results = array();
		$success = true;
		$i = 0;
		if (mysqli_multi_query($dataBase->dbLink,$query)) {
			do {
					if ($result = $mysqli->store_result()) {
						while ($row = mysqli_fetch_assoc($result)) {
								if ($i==0) {
									$results['header_result'] = $row;
								} else if ($i==1) {
									if ($row['name']!=''){
										$row['value'] = htmlspecialchars($row['value']);
										$results['data_result'][$row['name']] = $row['value'];
									}
								}
						}
						$result->free();
						$i++;
					}
					if ($mysqli->more_results()) {
					}
			} while ($mysqli->more_results() && $mysqli->next_result());
		}
		
		//check for errors in query
		$error = mysqli_error($dataBase->dbLink);
		if ($error!='') {
			$success = false;
			Logger::info('base_protocol error -> '.$error);
		}
		return ["success" => $success, "results" => $results, "error" => $error];
	}

	public static function modifyParam($action, $index, $value) {
		switch ($action) {
			case 'user_add': 
				if ($index == 1) { //this is password and we want to hash it
					$value = '"'.trim(password_hash($value, PASSWORD_BCRYPT), '"').'"';
				}
			break;
		}
		return $value;
	}

	public static function addParams($action, $query) {
		global $i18n;

		switch ($action) {
			case 'user_add':  //add language
				$query .= ",'".$i18n->getAppliedLang()."'";
			break;
		}
		return $query;
	}
}

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
	Logger::info('base_protocol results -> '.$results_json);
	echo $results_json;
	
	//post actions
	if ($action=='user_authorize')	{
	  if ($results['header_result']['success']=='1'){
	    $_SESSION['user_id'] = $results['data_result']['user_id'];
	  }
	}
?>