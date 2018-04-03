<?php
	include_once('init.php');
	function echoModes($modes)	{
		echo '<select class="gmsel input_com_style" name="mode" id="mode">';
			foreach ($modes as $mode)	{
				echo '<option value="'.$mode['id'].'">'.$mode['name'].'</option>';
			}
		echo '</select>';
	}
	//get create game info
	$modes = array();
	$query = 'call '.$DB_conf['site'].'.get_create_game_modes('.$_SESSION['user_id'].');';
	$res = $dataBase->multi_query($query);
	$result = $mysqli->store_result();
	while ($row = mysqli_fetch_assoc($result))	{
		$modes[] = $row;
	}
	$result->free();
	$mysqli->next_result();
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
	<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
	<title>THE LORDS</title>
	<script type="text/javascript" src="../general_js/mootools.js?<?php echo $SITE_conf['revision']; ?>"></script>
	<script type="text/javascript" src="../general_js/mootools-more.js?<?php echo $SITE_conf['revision']; ?>"></script>
	<script type="text/javascript" src="js_libs/create_game.js?<?php echo $SITE_conf['revision']; ?>"></script>
	<link rel="stylesheet" type="text/css" href="../design/css/pregame/reset.css?<?php echo $SITE_conf['revision']; ?>" />
	<link rel="stylesheet" type="text/css" href="../design/css/pregame/arena_creategame.css?<?php echo $SITE_conf['revision']; ?>" />
	<style>
		#game_error{color:red;}
	</style>
</head>
<body>
<div class="create_game">
<span class="gmsheader gmstopheader"> - <?= L::arena_creategame_create_game ?></span><br /><br />
	<form action="" method="post" id="create_form">
	<div id="game_error"><?php echo $error_text; ?></div>
   <table>
     <tr><td class="t_a_r"><?= L::arena_creategame_game_name ?> * :</td><td><input class="gmed input_com_style" type="text" name="title" value="" id="game_title"></td></tr>
     <tr><td class="t_a_r"><?= L::arena_creategame_mode ?> :</td><td><?php echoModes($modes); ?></td></tr>

     <tr><td class="t_a_r"><?= L::arena_creategame_turn_time ?> :</td><td><select class="gmsel input_com_style" name="time_restriction" id="time_restriction"><option value="0"><?= L::arena_creategame_no_limit ?></option><option value="60">1 <?= L::arena_creategame_minute ?>.</option><option value="120">2 <?= L::arena_creategame_minute ?>.</option><option value="180">3 <?= L::arena_creategame_minute ?>.</option><option value="240">4 <?= L::arena_creategame_minute ?>.</option><option value="300">5 <?= L::arena_creategame_minute ?>.</option></select></td></tr>
     <tr><td class="t_a_r"><?= L::arena_creategame_password ?> * :</td><td><input class="gmed input_com_style" type="password" name="pass" value="" id="pass_i"></td></tr>
     <tr><td class="t_a_r"><?= L::arena_creategame_repeat_password ?> * :</td><td><input class="gmed input_com_style" type="password" name="pass2" value="" id="pass2_i"></td></tr>
   </table>
     <a href="#" id="crgame_button" onclick="validateForm($('crgame_button'));return false;" class="crtgm textlink"><?= L::arena_creategame_create ?></a>
     	<input type="hidden" class="textlink" name="create_game" value="<?= L::arena_creategame_create_game ?>">
</form>
		 <a href="arena_gamelist.php" class="textlink"><?= L::arena_creategame_back_to_list ?></a>
</div><!--/create_game-->
</body>
</html>