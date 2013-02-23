<?php
	include_once('init.php');
	if ($_SESSION['game_id']!='' && $_SESSION['player_num']!='')	{
		$query = 'call '.$DB_conf['name'].'.multiple_actions('.$_SESSION['game_id'].','.$_SESSION['player_num'].',';
		if ($_POST['params']!='') { 
			$_POST['params'] = rawurldecode($_POST['params']);
			$_POST['params'] = strip_tags($_POST['params']);
			$_POST['params'] = str_replace(array(chr(10),chr(13),"'"),array('','',"\\'"),$_POST['params']);
			$_POST['params'] = str_replace('player_move_unit(','player_move_unit('.$_SESSION['game_id'].','.$_SESSION['player_num'].',',$_POST['params']);
			$_POST['params'] = str_replace('attack(','attack('.$_SESSION['game_id'].','.$_SESSION['player_num'].',',$_POST['params']);
			$query .= $_POST['params'];
		}
		$query .= ');';
		//echo $query;
		$res = $dataBase->query($query);
		$row = mysqli_fetch_assoc($res);
		echo $row['answer'];
	} else echo 'Нужна авторизация';
?>