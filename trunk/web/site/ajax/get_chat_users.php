<?php
	set_time_limit(0);
	include_once('init.php');
	session_commit();
	if ($_SESSION['user_id']!='' && $_POST['chat_id']!='')	{
		$res = $dataBase->query('call '.$DB_conf['site'].'.get_chat_users('.$_SESSION['user_id'].','.$_POST['chat_id'].');');
		$execute_str = '';
		$last_id = 0;
		if($res) {
			while($row = mysqli_fetch_assoc($res))	{
				//$execute_str .= $row['command'].';';
				echo('chat_add_player('.$_POST['chat_id'].','.$row['user_id'].');');
			}
		}
	}
?>