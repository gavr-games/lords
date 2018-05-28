<?php
	set_time_limit(0);
	include_once('init.php');
	session_commit();
	$query = 'call '.$DB_conf['site'].'.get_all_arena_bots();';
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