<?php
	set_time_limit(0);
	include_once('init.php');
	session_commit();

	$inputJSON = file_get_contents('php://input');
	$params = json_decode($inputJSON, TRUE);

	if ($_SESSION['user_id']!='' && $params['chat_id']!='')	{
		$res = $dataBase->query('call '.$DB_conf['site'].'.get_chat_users('.$_SESSION['user_id'].','.$params['chat_id'].');');
		$execute_str = '';
		$last_id = 0;
		if($res) {
			while($row = mysqli_fetch_assoc($res))	{
				//$execute_str .= $row['command'].';';
				echo('chat_add_player('.$params['chat_id'].','.$row['user_id'].');');
			}
		}
	}
?>