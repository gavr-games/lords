<?php
	set_time_limit(0);
	include_once('init.php');
	session_commit();
	$game_id = (int) $_GET['game_id'];
	$query = 'call '.$DB_conf['name'].'.get_game_info('.$game_id.');';
	Logger::info('internal exec query -> ' . $query);
	$res = $dataBase->query($query);
	$game = array();
	if($res) {
	  $game = mysqli_fetch_assoc($res);
	}
  echo json_encode($game);
?>