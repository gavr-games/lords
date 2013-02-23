<?php
	set_time_limit(0);
	include_once('init.php');
	session_commit();
	$res = $dataBase->query('call '.$DB_conf['name'].'.get_game_info('.$_POST['game_id'].');');
	$game = array();
	if($res) {
	  $game = mysqli_fetch_assoc($res);
	}
  echo json_encode($game);
?>