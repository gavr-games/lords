<?php
	//init classes and db connection
	if (isset($_GET['phpsessid'])) if ($_GET['phpsessid']!="") session_id($_GET['phpsessid']);//this is passed from ape
	session_start();
	include_once('../../../general_config/config.php');
	include_once('../../../general_classes/sql.class.php');
	$mysqli = new mysqli($DB_conf['server'], $DB_conf['user'], $DB_conf['pass']);
	if (mysqli_connect_errno()) {
		    printf("Connect failed: %s\n", mysqli_connect_error());
		    die();
	}
	
	$dataBase = new cDataBase($mysqli);
	$dataBase->query("SET NAMES 'UTF8'");
	
?>