<?php
	set_time_limit(0);
	include_once('init.php');
	session_commit();
	if ($_SESSION['user_id']!='')	{
		$res = $dataBase->query('call '.$DB_conf['site'].'.chat_get_new_commands('.$_SESSION['user_id'].','.$_POST['chat_last_command'].');');
		$execute_str = '';
		$last_id = 0;
		if($res) {
			while($row = mysqli_fetch_assoc($res))	{
				$execute_str .= $row['command'].';';
				$last_id = $row['id'];
			}
				if ($last_id!=0) $execute_str .= 'chat_last_command_id="'.$last_id.'";';
				echo $execute_str;
		}
	} else echo 'Нужна авторизация';
?>