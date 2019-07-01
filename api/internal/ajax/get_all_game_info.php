<?php
include_once('init.php');
include_once('../../general_classes/game_info.class.php');
  
$game_id = (int) $_GET['game_id'];
$player_num = (int) $_GET['player_num'];

$tables = GameInfo::getGameConfig();
if (isset($_GET['format']) && $_GET['format'] == 'json') {
	$result = json_encode(GameInfo::generateArray($tables, $game_id, $player_num));
	//Logger::info($result);
} else {
	$result = GameInfo::generateJS($tables, $game_id, $player_num);
}

echo $result;
?>