<?php
	set_time_limit(0);
	include_once('init.php');
	session_commit();
	$procedure = "get_all_arena_bots();";
	if (isset($_GET['game_id']) && $_GET['game_id'] != '') {
		$game_id = (int) $_GET['game_id'];
		$procedure = "get_bots_for_game($game_id);";
	}
	$query = 'call '.$DB_conf['site'].'.'.$procedure;
	Logger::info('internal exec query -> ' . $query);
	$res = $dataBase->query($query);
	$bots = array();
	if($res) {
		while($row = mysqli_fetch_assoc($res))	{
			$bots[] = $row;
		}
	}
  echo json_encode($bots);
?>