<?php
$start_time = microtime(true);
	include_once('init.php');
	set_time_limit(0);
	if ($_SESSION['game_id']!='' && $_SESSION['player_num']!='' && $_POST['name']!='')	{
		$query = 'call '.$DB_conf['name'].'.'.$_POST['name'].'('.$_SESSION['game_id'].','.$_SESSION['player_num'];
		if ($_POST['params']!='') { 
			$_POST['params'] = rawurldecode($_POST['params']);
			$_POST['params'] = strip_tags($_POST['params']);
			$_POST['params'] = str_replace(array(chr(10),chr(13),"'"),array('','',"\\'"),$_POST['params']);
			$query .= $_POST['params'];
		}
		$query .= ');';
		$res = $dataBase->query($query);
		$row = mysqli_fetch_assoc($res);
		echo json_encode(
                        array(
                            'answer'=>$row['answer'],
                            'phptime'=>(microtime(true)-$start_time)
                        )
                );
	} else echo json_encode(array('answer'=>'Нужна авторизация'));
?>