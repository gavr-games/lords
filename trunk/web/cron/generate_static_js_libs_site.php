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
		error_reporting(E_ALL);
	//$mysqli = new mysqli($DB_conf['server'], 'lord', 'D^Dhf88Y_]', $DB_conf['site']);
	$mysqli = new mysqli($DB_conf['server'], 'lords_reader', 'D^Dhf88Y_]', $DB_conf['site']);
	if (mysqli_connect_errno()) {
		    printf("Connect failed: %s\n", mysqli_connect_error());
		    die();
	}
	$message = '';
	$dataBase = new cDataBase($mysqli);
	$dataBase->query("SET NAMES 'UTF8'");
	//get each mode arrays
	$tables = Array(
		Array(
			'name'=>'dic_game_types',
			'rule'=>'',
			'js_name'=>'dic_game_types'),
		Array(
			'name'=>'dic_player_status',
			'rule'=>'',
			'js_name'=>'dic_player_status'),
		Array(
			'name'=>'error_dictionary',
			'rule'=>'',
			'js_name'=>'error_dictionary'),
		Array(
			'name'=>'lords.games_features',
			'rule'=>'',
			'js_name'=>'games_features'),
		Array(
			'name'=>'lords.modes',
			'rule'=>'',
			'js_name'=>'modes'),
		Array(
			'name'=>'lords.dic_game_status',
			'rule'=>'',
			'js_name'=>'dic_game_status'),
	);
	$each_mode_js_arrays = '';
	foreach($tables as $table)	{
		$first = true;
		$res = $dataBase->select('*',$table['name'],$table['rule']);
		if ($res)	{
			while ($row = mysqli_fetch_assoc($res))	{
				if ($first) {
					$each_mode_js_arrays .= chr(13).'var '.$table['js_name'].' = new Array();'.chr(13);
					$first = false;
				}
				$each_mode_js_arrays .= $table['js_name'].'['.$row['id'].'] = new Array();'.chr(13);
				foreach($row as $field=>$value)	{
					$each_mode_js_arrays .= $table['js_name'].'['.$row['id'].']["'.$field.'"] = "'.$value.'";'.chr(13);
				}
			}
		}
	}
	$f = fopen('../site/js_libs/static_libs.js','w');
	if ($f)	{
		fwrite($f,$each_mode_js_arrays);
		fclose($f);
		$message .= '"../site/js_libs/static_libs.js" is successfully generated.<br />';
	} else $message .= 'Can\'t open file "../site/js_libs/static_libs.js"';
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