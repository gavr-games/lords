<?php
	include_once('init.php');
	set_time_limit(0);
	if ($_SESSION['game_id']!='' && $_SESSION['player_num']!='')	{
		$query = 'call '.$DB_conf['name'].'.multiple_actions2('.$_SESSION['game_id'].','.$_SESSION['player_num'].',';
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
		$result = $dataBase->multi_query($query);
		$i = 0;
		do {
	        /* store first result set */
	        if ($result = $mysqli->store_result()) {
	            while ($row = $result->fetch_row()) {
	            	$answer = $row[0];
	            }
	            $result->free();
	            $i++;
	        }
	        /* print divider */
	        if ($mysqli->more_results()) {
	        }
    	} while ($mysqli->more_results() && $mysqli->next_result());
		echo $answer;
	} else echo 'Нужна авторизация';
?>