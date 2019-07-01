<?php
	/*
	18.05.2011
	This script is started by cron or manually.
	It generates js files with static info for site clients (game_types,user_statuses etc...).
	*/
	//Initialization part
	session_start();
	include ('../general_config/config.php');
	include ('../general_classes/sql.class.php');
	include ('../general_classes/static_libs.class.php');
	error_reporting(E_ALL);
	$mysqli = new mysqli($DB_conf['server'], 'lords_reader', $_ENV['MYSQL_READER_PASSWORD'], $DB_conf['site']);
	if (mysqli_connect_errno()) {
		printf("Connect failed: %s\n", mysqli_connect_error());
		die();
	}
	$message = '';
	$dataBase = new cDataBase($mysqli);
	$dataBase->query("SET NAMES 'UTF8'");

	$tables = Array(
		Array('name'=>'dic_game_types'),
		Array('name'=>'dic_player_status_i18n', 'js_name'=>'dic_player_status', 'keys'=>'language_id,player_status_id'),
		Array('name'=>'error_dictionary_i18n', 'js_name'=>'error_dictionary_messages', 'keys'=>'language_id,error_id'),
		Array('name'=>'lords.games_features', 'js_name'=>'games_features'),
		Array('name'=>'lords.games_features_i18n', 'js_name'=>'games_feature_names', 'keys'=>'language_id,feature_id'),
		Array('name'=>'lords.modes', 'js_name'=>'modes')
	);
	
	$js_arrays = StaticLibs::generate($dataBase, $tables);

	// Static libs for lang
  $js_arrays .= PHP_EOL.'var i18n = new Array();'.PHP_EOL;
	foreach(LangUtils::getAllLangs() as $code => $id) {
		$js_arrays .= StaticLibs::generateI18n("../lang/lang_$code.ini", $id);
  }
  $js_arrays .= PHP_EOL."export {i18n}";

	$f = fopen('../static_js/static_libs_portal.js','w');
	if ($f)	{
		fwrite($f,$js_arrays);
		fclose($f);
		$message .= '"../static_js/static_libs_portal.js" is successfully generated.<br />';
	} else $message .= 'Can\'t open file "../static_js/static_libs_portal.js"';
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
	<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
	<link id="site_icon" rel="icon" href="../design/images/icon_lords.ico" type="image/x-icon" />
	<title>Генерация статических библиотек для доигровой</title>
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
