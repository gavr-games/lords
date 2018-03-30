<?php
	/*
	23.07.2010
	This script is started by cron or manually.
	It generates js files with static info for game clients (units,buildings etc...).
	*/
	//Initialization part
	session_start();
	include ('../general_config/config.php');
	include ('../general_classes/sql.class.php');
		error_reporting(E_ALL);
	$mysqli = new mysqli($DB_conf['server'], 'lords_reader', $_ENV['MYSQL_READER_PASSWORD'], $DB_conf['name']);
	if (mysqli_connect_errno()) {
		    printf("Connect failed: %s\n", mysqli_connect_error());
		    die();
	}
	$dataBase = new cDataBase($mysqli);
	$dataBase->query("SET NAMES 'UTF8'");
	$message = '';
	
	//get each mode data
	// 'keys' control hierarchical structure of the js array.
	// For example, 'keys'=>'language_id,code' means that
	// first index of js aray should be language_id, second - code,
	// and then all other fields:
	// log_message_texts[1]['resurrect']['message'] = '{player0} resurrects {unit1}'
	//
	// if omitted, defaults to 'id'
	$tables = Array(
		Array('name'=>'procedures_params'),
		Array('name'=>'procedures_params_i18n', 'js_name'=>'procedures_params_descriptions', 'keys'=>'language_id,param_id'),
		Array('name'=>'unit_features'),
		Array('name'=>'building_features'),
		Array('name'=>'error_dictionary'),
		Array('name'=>'error_dictionary_i18n', 'js_name'=>'error_dictionary_messages', 'keys'=>'language_id,error_id'),
		Array('name'=>'dic_colors', 'keys'=>'code'),
		Array('name'=>'units_i18n', 'js_name'=>'unit_names', 'keys'=>'language_id,unit_id'),
		Array('name'=>'unit_features_i18n', 'js_name'=>'unit_feature_names', 'keys'=>'language_id,feature_id'),
		Array('name'=>'cards_i18n', 'js_name'=>'card_names', 'keys'=>'language_id,card_id'),
		Array('name'=>'buildings_i18n', 'js_name'=>'building_names', 'keys'=>'language_id,building_id'),
		Array('name'=>'buildings_features_i18n', 'js_name'=>'buildings_feature_names', 'keys'=>'language_id,feature_id'),
		Array('name'=>'npc_player_name_modificators_i18n', 'js_name'=>'npc_player_name_modificators', 'keys'=>'language_id,code'),
		Array('name'=>'videos_i18n', 'js_name'=>'videos_titles', 'keys'=>'language_id,code'),
		Array('name'=>'log_message_text_i18n', 'js_name'=>'log_message_texts', 'keys'=>'language_id,code')
	);
	$each_mode_js_arrays = $params = '';
	foreach($tables as $table)	{
		$first = true;
		$where = '';
		if (array_key_exists('keys', $table)) {
			$keys = $table['keys'];
		} else {
			$keys = 'id';
		}
		if (array_key_exists('js_name', $table)) {
			$js_name = $table['js_name'];
		} else {
			$js_name = $table['name'];
		}
		
		$res = $dataBase->select('*', $table['name'], $where, $keys);
		if ($res) {
			$key_column_names = explode(',', $keys);
			$previous_keys = array_fill(0, sizeof($key_column_names), '');
			
			$each_mode_js_arrays .= chr(13).'var '.$js_name.' = new Array();'.PHP_EOL;
			while ($row = mysqli_fetch_assoc($res))	{
				$current_keys = Array();
				foreach($key_column_names as $i=>$key_col) {
					array_push($current_keys, $row[$key_col]);
					if ($row[$key_col] != $previous_keys[$i]) {
						$each_mode_js_arrays .= $js_name.'["'.implode('"]["', $current_keys).'"] = new Array();'.PHP_EOL;
					}
				}
				
				foreach($row as $field=>$value)	{
					$each_mode_js_arrays .= $js_name.'["'.implode('"]["', $current_keys).'"]["'.$field.'"] = "'.str_replace('"',"'",$value).'";'.PHP_EOL;
					if ($table['name']=='procedures_params' && $field=='code') $params .= 'var '.$value.'="";'.PHP_EOL;
				}
				$previous_keys = $current_keys;
			}
		}
	}
	
	//mode specific data
	$mode_tables = array(
	  Array('db_name'=>'vw_mode_cards','js_name'=>'cards'),
	  Array('db_name'=>'vw_mode_units','js_name'=>'units'),
	  Array('db_name'=>'vw_mode_buildings','js_name'=>'buildings'),
	  Array('db_name'=>'vw_mode_all_procedures','js_name'=>'procedures_mode_1'),
	  Array('db_name'=>'vw_mode_cards_procedures','js_name'=>'cards_procedures_1'),
	  Array('db_name'=>'vw_mode_units_procedures','js_name'=>'units_procedures_1'),
	  Array('db_name'=>'vw_mode_buildings_procedures','js_name'=>'buildings_procedures_1'),
	  Array('db_name'=>'mode_config','js_name'=>'mode_config'),
	  Array('db_name'=>'vw_mode_unit_default_features','js_name'=>'unit_features_usage'),
	  Array('db_name'=>'vw_mode_building_default_features','js_name'=>'building_default_features'),
	  Array('db_name'=>'vw_mode_unit_phrases','js_name'=>'dic_unit_phrases'),
	  Array('db_name'=>'vw_mode_unit_level_up_experience','js_name'=>'units_levels')
	);
	//get modes
	$res = $dataBase->select('id','modes');
	if ($res)	{
		while ($mode = mysqli_fetch_assoc($res))	{
			$js_arrays = '';
			if (file_exists('../game/mode'.$mode['id']))	{
					foreach($mode_tables as $table)	{ //get tables for mode
						$old_unit_id = 0;
						$first = true;
						$res_table = $dataBase->select('*',$table['db_name'],'mode_id='.$mode['id']);
						if ($res_table)	{
						  $i = 1;
							while ($row = mysqli_fetch_assoc($res_table))	{
							if (! isset($row['id'])) $row['id'] = $i;
								if ($first) {
									$js_arrays .= chr(13).'var '.$table['js_name'].' = new Array();'.PHP_EOL;
									$first = false;
								}
								if ($table['db_name']=='vw_mode_unit_level_up_experience'){
								  if ($row['unit_id']!=$old_unit_id)
								  $js_arrays .= $table['js_name'].'['.$row['unit_id'].'] = new Array();'.PHP_EOL;
								  $old_unit_id = $row['unit_id'];
								}
								if ($table['db_name']=='mode_config'){
								  $js_arrays .= $table['js_name'].'["'.$row['param'].'"] = '.$row['value'].';'.PHP_EOL;
								} else 
								if ($table['db_name']=='vw_mode_unit_level_up_experience'){
								  $js_arrays .= $table['js_name'].'['.$row['unit_id'].']['.$row['level'].'] = '.$row['experience'].';'.PHP_EOL;
								} else {
								  $js_arrays .= $table['js_name'].'['.$row['id'].'] = new Array();'.PHP_EOL;
								  foreach($row as $field=>$value)	{
									  $js_arrays .= $table['js_name'].'['.$row['id'].']["'.$field.'"] = "'.addslashes($value).'";'.PHP_EOL;
								  }
								}
								$i++;
							}// while res table
						}
					}
				$f = fopen('../game/mode'.$mode['id'].'/js_libs/static_libs.js','w');
				if ($f)	{
					fwrite($f,$js_arrays.$each_mode_js_arrays.$params);
					fclose($f);
					$message .= '"../game/mode'.$mode['id'].'/js_libs/static_libs.js" is successfully generated.<br />';
				} else $message .=  'Can\'t open file ../game/mode'.$mode['id'].'/js_libs/static_libs.js<br />';
			}//file exists
		}//while res mode
	}
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
	<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
	<link id="site_icon" rel="icon" href="../design/images/icon_lords.ico" type="image/x-icon" />
	<title>Генерация статических библиотек для игры</title>
	<script type="text/javascript" src="../general_js/mootools.js"></script>
	<script type="text/javascript" src="../general_js/mootools-more.js"></script>
	<style>
		a{text-decoration:none; color:#ccc;border-left:3px solid #cbb06e;padding-left:5px;outline:none;}
		a:hover{color:white;border-left:3px solid white;}
		body {background-color:#312a1a;}
		h1{color:white;}
	</style>
</head>
<body onload="initialization();">
	<h1><?php echo $message; ?></h1><br />
	<a href="index.html"> Назад в меню </a>
</body>
</html>
