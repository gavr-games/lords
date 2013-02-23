<?php
	include_once('init.php');
	set_time_limit(0);
	if ($_POST['game_id']!='' && $_POST['name']!='')	{
		$query = 'call '.$DB_conf['site'].'.performance_statistics_add("'.$_POST['name'].'",'.round($_POST['js_time'],3).','.round($_POST['ape_time'],3).','.round($_POST['php_time'],3).','.$_POST['game_id'].');';
		$res = $dataBase->query($query);
	}
?>