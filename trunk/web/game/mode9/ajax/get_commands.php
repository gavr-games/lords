<?php
	set_time_limit(0);
	include_once('init.php');
	$g_id  = $_SESSION['game_id'];
	$p_num = $_SESSION['player_num'];
	session_commit();
	if ($g_id!='' && $p_num!='')	{
		$res = $dataBase->query('call '.$DB_conf['name'].'.get_new_commands('.$g_id.','.$p_num.','.$_POST['last_command'].');');
		$execute_str = '';
		$last_id = 0;
		if($res) {
			while($row = mysqli_fetch_assoc($res))	{
				$execute_str .= $row['command'].';';
				$last_id = $row['id'];
			}
				if ($last_id!=0) $execute_str .= 'last_command_id="'.$last_id.'";';
				echo $execute_str;
		}
	} else echo 'Нужна авторизация';
?>