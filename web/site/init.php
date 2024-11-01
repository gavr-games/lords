<?php

// determine current season

function getSeason()
{
	$seasons = array(
		0 => 'winter',
		1 => 'spring',
		2 => 'summer',
		3 => 'autumn'
	);
	return $seasons[floor(date('n') / 3) % 4];
}

// init classes and db connection

session_start();
include_once('../general_config/config.php');
include_once('../general_classes/sql.class.php');
include_once('../general_classes/google_analytics.class.php');

$mysqli = new mysqli($DB_conf['server'], $DB_conf['user'], $DB_conf['pass']);

if (mysqli_connect_errno()) {
	printf("Connect failed: %s\n", mysqli_connect_error());
	die();
}

$dataBase = new cDataBase($mysqli);
$dataBase->query("SET NAMES utf8");
$load_frame = '';

if (isset($clear_user) && $clear_user==1) $_SESSION['user_id']='';

if ($_SESSION['user_id'] != '' && !isset($no_redirect) ) {
	$query = 'call ' . $DB_conf['site'] . '.get_my_location(' . $_SESSION['user_id'] . ');'; //check where to redirect user
	 $result = $dataBase->multi_query($query);
	 do {
		/* store first result set */
		if ($result = $mysqli->store_result()) {
			while ($r = $result->fetch_assoc()) {
			$row = $r;
			}
			$result->free();
			$i++;
		}
		/* print divider */
		if ($mysqli->more_results()) {
		}
	} while ($mysqli->more_results() && $mysqli->next_result());

	if ($row['player_num'] != '') { //go to started game
		header('location:' . $SITE_conf['domen'] . 'game/mode' . $row['mode_id']);
	}
	else
	if ($row['game_type_id'] != '') { //go to general location
		if ($row['game_type_id'] == '1') $load_frame = 'arena/arena.php';
	}

	if ($load_frame == '') $load_frame = 'site/map.php';
}
else $load_frame = 'site/login.php';
?>
