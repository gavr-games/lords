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
	//$mysqli = new mysqli($DB_conf['server'], 'lord', 'D^Dhf88Y_]', $DB_conf['name']);
	$mysqli = new mysqli($DB_conf['server'], 'lords_reader', 'D^Dhf88Y_]', $DB_conf['name']);
// 	$mysqli = new mysqli($DB_conf['server'], 'root', 'mypass', $DB_conf['name']);
	if (mysqli_connect_errno()) {
		    printf("Connect failed: %s\n", mysqli_connect_error());
		    die();
	}
	$dataBase = new cDataBase($mysqli);
	$dataBase->query("SET NAMES 'UTF8'");
	$message = '';
	
	//get each mode data
	$tables = Array(
		Array('name'=>'procedures_params','rule'=>''),
		Array('name'=>'unit_features','rule'=>''),
		Array('name'=>'building_features','rule'=>''),
		Array('name'=>'error_dictionary','rule'=>''),
		Array('name'=>'dic_colors','rule'=>'')
	);
	$each_mode_js_arrays = $params = '';
	foreach($tables as $table)	{
		$first = true;
		$res = $dataBase->select('*',$table['name'],$table['rule']);
		if ($res)	{
			while ($row = mysqli_fetch_assoc($res))	{
				if ($first) {
					$each_mode_js_arrays .= chr(13).'var '.$table['name'].' = new Array();'.chr(13);
					$first = false;
				}
				if ($table['name']=='dic_colors')
				$each_mode_js_arrays .= $table['name'].'["'.$row['code'].'"] = new Array();'.chr(13);
				else
				$each_mode_js_arrays .= $table['name'].'['.$row['id'].'] = new Array();'.chr(13);
				foreach($row as $field=>$value)	{
					if ($table['name']=='dic_colors')
					$each_mode_js_arrays .= $table['name'].'["'.$row['code'].'"]["'.$field.'"] = "'.$value.'";'.chr(13);
					else
					$each_mode_js_arrays .= $table['name'].'['.$row['id'].']["'.$field.'"] = "'.str_replace('"',"'",$value).'";'.chr(13);
					if ($table['name']=='procedures_params' && $field=='code') $params .= 'var '.$value.'="";'.chr(13);
				}
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
									$js_arrays .= chr(13).'var '.$table['js_name'].' = new Array();'.chr(13);
									$first = false;
								}
								if ($table['db_name']=='vw_mode_unit_level_up_experience'){
								  if ($row['unit_id']!=$old_unit_id)
								  $js_arrays .= $table['js_name'].'['.$row['unit_id'].'] = new Array();'.chr(13);
								  $old_unit_id = $row['unit_id'];
								}
								if ($table['db_name']=='mode_config'){
								  $js_arrays .= $table['js_name'].'["'.$row['param'].'"] = '.$row['value'].';'.chr(13);
								} else 
								if ($table['db_name']=='vw_mode_unit_level_up_experience'){
								  $js_arrays .= $table['js_name'].'['.$row['unit_id'].']['.$row['level'].'] = '.$row['experience'].';'.chr(13);
								} else {
								  $js_arrays .= $table['js_name'].'['.$row['id'].'] = new Array();'.chr(13);
								  foreach($row as $field=>$value)	{
									  $js_arrays .= $table['js_name'].'['.$row['id'].']["'.$field.'"] = "'.addslashes($value).'";'.chr(13);
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