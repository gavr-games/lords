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
	include ('../general_classes/static_libs.class.php');
		error_reporting(E_ALL);
	$mysqli = new mysqli($DB_conf['server'], 'lords_reader', $_ENV['MYSQL_READER_PASSWORD'], $DB_conf['name']);
	if (mysqli_connect_errno()) {
		    printf("Connect failed: %s\n", mysqli_connect_error());
		    die();
	}
	$dataBase = new cDataBase($mysqli);
	$dataBase->query("SET NAMES 'UTF8'");
	$message = '';
	
	$tables = Array(
		Array('name'=>'procedures_params', 'type'=>'vars', 'field'=>'code'),
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

	$common_js_arrays = StaticLibs::generate($dataBase, $tables);
	
	//mode specific data
	$mode_tables = array(
	  Array('name'=>'vw_mode_cards', 'js_name'=>'cards', 'numeric_keys'=>true),
	  Array('name'=>'vw_mode_units', 'js_name'=>'units', 'numeric_keys'=>true),
	  Array('name'=>'vw_mode_buildings', 'js_name'=>'buildings', 'numeric_keys'=>true),
	  Array('name'=>'vw_mode_all_procedures', 'js_name'=>'procedures_mode_1', 'numeric_keys'=>true),
	  Array('name'=>'vw_mode_cards_procedures', 'js_name'=>'cards_procedures_1', 'keys'=>'', 'numeric_keys'=>true),
	  Array('name'=>'vw_mode_units_procedures','js_name'=>'units_procedures_1', 'keys'=>'', 'numeric_keys'=>true),
	  Array('name'=>'vw_mode_buildings_procedures','js_name'=>'buildings_procedures_1', 'keys'=>'', 'numeric_keys'=>true),
	  Array('name'=>'mode_config','js_name'=>'mode_config', 'type'=>'one_value', 'field'=>'value', 'keys'=>'param'),
	  Array('name'=>'vw_mode_unit_default_features', 'js_name'=>'unit_features_usage', 'numeric_keys'=>true),
	  Array('name'=>'vw_mode_building_default_features', 'js_name'=>'building_default_features', 'numeric_keys'=>true),
	  Array('name'=>'vw_mode_unit_phrases', 'js_name'=>'dic_unit_phrases', 'numeric_keys'=>true),
	  Array('name'=>'vw_mode_unit_level_up_experience', 'js_name'=>'units_levels', 'type'=>'one_value', 'field'=>'experience', 'keys'=>'unit_id,level', 'numeric_keys'=>true)
	);
	//get modes
	$res = $dataBase->select('id','modes');
	if ($res) {
		while ($mode = mysqli_fetch_assoc($res)) {
			$mode_specific_js_arrays = '';
			if (file_exists('../game/mode'.$mode['id'])) {
				$mode_specific_js_arrays = StaticLibs::generate($dataBase, $mode_tables, 'mode_id='.$mode['id']);
				
				$f = fopen('../game/mode'.$mode['id'].'/js_libs/static_libs.js','w');
				if ($f)	{
					fwrite($f,$mode_specific_js_arrays.$common_js_arrays);
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
