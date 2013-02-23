<?php
	include_once('init.php');
	set_time_limit(0);
	if ($_POST['game_id']!='')	{
		$query = 'call '.$DB_conf['name'].'.delete_game_data('.$_POST['game_id'].');';
		$res = $dataBase->query($query);
	}
?>