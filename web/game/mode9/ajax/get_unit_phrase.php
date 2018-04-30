<?php
	set_time_limit(0);
	include_once('init.php');
	session_commit();
	if ($_GET['game_id'] != '') {
		$game_id = (int) $_GET['game_id'];
		$query = 'call '.$DB_conf['name'].'.get_unit_phrase('.$game_id.');';
		$res = $dataBase->query($query);
		if ($res)
		$row = mysqli_fetch_assoc($res);
		echo json_encode($row);
	}
?>