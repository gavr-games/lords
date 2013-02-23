<?php
	include_once('init.php');
	//get where to redirect user
	$query = 'call '.$DB_conf['site'].'.get_my_location('.$_SESSION['user_id'].');'; //check where to redirect user
	$res = $dataBase->multi_query($query);
	$res = $mysqli->store_result();
	$row = mysqli_fetch_assoc($res);
			if ($row['game_type_id']!=''){//go to general location
				if ($row['game_type_id']==0) header('location:'.$SITE_conf['domen']);
				if ($row['game_type_id']==1) { //arena game list
					if ($row['player_num']!='')	{ //go to started game
						$_SESSION['game_id'] 	= $row['game_id'];
						$_SESSION['player_num'] = $row['player_num'];
					} else
					header('location:'.$SITE_conf['domen']);
				}
			}
	$res->free();
	$mysqli->next_result();
	
        $markers['###REVISION###'] = $SITE_conf['revision'];
	//print template of html page
	$replace = $values = array();
	foreach ($markers as $key=>$value)	{
		$replace[] = $key;
		$values[]  = $value;
	}
	echo str_replace($replace,$values,file_get_contents('template.html'));
?>