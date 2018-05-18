<?php

class BaseProtocol {
    const WRONG_LOGIN_OR_PASSWORD_ERROR_CODE = 3;

	public static function execCmd($action, $params) {
        Logger::info('base_protocol execCmd -> '.$action.' '.json_encode($params));
		if (self::isCustomLogic($action)) {
			return self::customLogic($action, $params);
		} else {
			$query = self::prepareQuery($action, $params);
			return self::execQuery($query);
		}
	}

	private static function isCustomLogic($action) {
		return $action == 'user_authorize';
	}

	private static function customLogic($action, $params) {
		$results = array();
		$success = true;
		$error   = null;

		switch ($action) {
            case 'user_authorize':
                $res = self::execCmd('user_get_pass_hash', [$params['login']]);
                if ($res['success'] != true || $res['results']['header_result']['success']!='1') {
                    return $res;
                }
                $hash = $res['results']['data_result']['pass_hash'];
                if (password_verify(trim(self::sanitizeParam($params['pass']), '"'), $hash)) {
                    $res = self::execCmd('user_get_info', [$params['login']]);
                    if ($res['results']['header_result']['success']=='1'){
                        $_SESSION['user_id'] = $res['results']['data_result']['user_id'];
						$_SESSION['lang'] = $res['results']['data_result']['user_language_code'] == 'RU' ? 'ru' : 'en';
                    }
                    return $res;
                } else {
                    $results["header_result"] = array(
						'success' => 0,
						'error_code' => self::WRONG_LOGIN_OR_PASSWORD_ERROR_CODE,
						'error_params' => null
					);
                }

			break;
		}

		return ["success" => $success, "results" => $results, "error" => $error];
	}

	private static function prepareQuery($action, $params) {
		global $DB_conf;
		$query = 'call '.$DB_conf['site'].'.'.$action.'(';
	
		$index = 0;
		foreach($params as $param)	{
		    $param = self::sanitizeParam($param);
			$param = self::modifyParam($action, $index, $param);
			$query .= $param.',';
			$index++;
		}
		$query = trim($query,",");
		$query = self::addParams($action, $query);
		$query .= ');';
		return $query;
    }
    
    private static function sanitizeParam($param) {
        $param = urldecode($param);
        $param = strip_tags($param);
        $param = str_replace(array(chr(10),chr(13)),array('',''),$param);
        return $param;
    }

	private static function execQuery($query) {
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
                            Logger::info('base_protocol row -> '.json_encode($row));
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
		} else {
            Logger::info('base_protocol results -> '.json_encode($results));
        }
		return ["success" => $success, "results" => $results, "error" => $error];
	}

	private static function modifyParam($action, $index, $value) {
		switch ($action) {
			case 'user_add': 
				if ($index == 1) { //this is password and we want to hash it
					$value = '"'.password_hash(trim($value, '"'), PASSWORD_BCRYPT).'"';
				}
			break;
		}
		return $value;
	}

	private static function addParams($action, $query) {
		global $i18n;

		switch ($action) {
			case 'user_add':  //add language
				$query .= ",'".$i18n->getAppliedLang()."'";
			break;
		}
		return $query;
	}

	public static function dieNoAction($action) {
		if ($action=='') {
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
		}
	}

	public static function dieMysqlError($res) {
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
	}

}