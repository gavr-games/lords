<?php
	set_time_limit(0);
	include_once('init.php');
	session_commit();
	$res = $dataBase->query('call '.$DB_conf['name'].'.get_games_info();');
	$games = array();
	if($res) {
		while($row = mysqli_fetch_assoc($res))	{
			$games[] = $row;
		}
	}
  echo json_encode($games);
?>