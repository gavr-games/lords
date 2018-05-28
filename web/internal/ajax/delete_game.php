<?php
	include_once('init.php');
	set_time_limit(0);
	$game_id = (int) $_GET['game_id'];
	if ($game_id != 0)	{
		$query = 'call '.$DB_conf['name'].'.delete_game_data('.$game_id.');';
		Logger::info('internal exec query -> ' . $query);
		$res = $dataBase->query($query);
	}
?>