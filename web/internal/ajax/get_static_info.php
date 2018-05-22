<?php
	session_start();
	include ('../../general_config/config.php');
	include ('../../general_classes/sql.class.php');
	include ('../../general_classes/static_libs.class.php');
	
	error_reporting(E_ALL);
	$mysqli = new mysqli($DB_conf['server'], 'lords_reader', $_ENV['MYSQL_READER_PASSWORD'], $DB_conf['name']);
	if (mysqli_connect_errno()) {
		    printf("Connect failed: %s\n", mysqli_connect_error());
		    die();
	}
	$dataBase = new cDataBase($mysqli);
	$dataBase->query("SET NAMES 'UTF8'");
	
    $mode_id = (int) $_GET['mode_id'];

    $tables = StaticLibs::getCommonGameConfig();
    $static_info = StaticLibs::generateArray($dataBase, $tables);

    $mode_tables = StaticLibs::getModeGameConfig();
    $mode_static_info = StaticLibs::generateArray($dataBase, $mode_tables, 'mode_id='.$mode_id);
	
    echo json_encode(array_merge($static_info, $mode_static_info));