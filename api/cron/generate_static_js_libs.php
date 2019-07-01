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
	
	$tables = StaticLibs::getCommonGameConfig();
	$common_js_arrays = StaticLibs::generate($dataBase, $tables);

	// Static libs for lang
	$common_js_arrays .= PHP_EOL.'var i18n = new Array();'.PHP_EOL;
	foreach(LangUtils::getAllLangs() as $code => $id) {
		$common_js_arrays .= StaticLibs::generateI18n("../lang/lang_$code.ini", $id);
	}
	
	//mode specific data
	$mode_tables = StaticLibs::getModeGameConfig();
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
