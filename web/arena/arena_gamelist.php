<?php
	include_once('init.php');
	//get list of existing games
	$games = $started_games = '';
	$query = 'call '.$DB_conf['site'].'.get_arena_games_info('.$_SESSION['user_id'].');';
	$res = $dataBase->multi_query($query);
	$result = $mysqli->store_result();
			while ($row = mysqli_fetch_assoc($result))	{
				$search = $replace = array();
				foreach($row as $key=>$value)	{
							$search[]  = '###'.$key.'###';
							$replace[] = $value;
				}
				$search[] = '###display_none###';
				$search[] = '###pass_class###';
				if ($row['pass_flag']) {
					$replace[] = '';
					$replace[] = 'closed';
				}else{
					$replace[] = 'display:none;';
					$replace[] = 'free';
				}
				if ($row['status_id']==1) //new and started games
				$games .= str_replace($search,$replace,$templates['game_in_list']);
				else
				$started_games .= str_replace($search,$replace,$templates['game_in_list']);
			}
	$result->free();
	$mysqli->next_result();
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
	<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
	<title>THE LORDS</title>
	
	<link rel="stylesheet" type="text/css" href="../design/css/pregame/reset.css?<?php echo $SITE_conf['revision']; ?>" />
	<link rel="stylesheet" type="text/css" href="../design/css/pregame/arenamain.css?<?php echo $SITE_conf['revision']; ?>" />
	<link rel="stylesheet" type="text/css" href="../design/css/pregame/scrollstl.css?<?php echo $SITE_conf['revision']; ?>" />
	<link rel="stylesheet" type="text/css" href="../design/css/pregame/helpstl.css?<?php echo $SITE_conf['revision']; ?>" />
	<script type="text/javascript" src="../general_js/mootools.js?<?php echo $SITE_conf['revision']; ?>"></script>
	<script type="text/javascript" src="../general_js/mootools-more.js?<?php echo $SITE_conf['revision']; ?>"></script>
        <script type="text/javascript" src="js_libs/custom_scroll.js?<?php echo $SITE_conf['revision']; ?>"></script>
	<script type="text/javascript" src="js_libs/list.js?<?php echo $SITE_conf['revision']; ?>"></script>
</head>
<body onload="initialization();">
<a class="help" title="<?= L::arena_gamelist_help ?>" href="" onclick="return false;"></a>
<span class="gmsheader gmstopheader"> - <?= L::arena_gamelist_game_list ?></span><br /><br />
<span class="gmsheader gmsunderlined"><?= L::arena_gamelist_new_games ?>:</span><br />
	<div id="game_list">
	<?php echo $games; ?>
	</div>
		
	<span class="gmsheader gmsunderlined"><?= L::arena_gamelist_started_games ?>:</span>
	<div id="started_game_list">
	<?php echo $started_games; ?>
	</div>
<a href="arena_creategame.php" class="textlink"><?= L::arena_gamelist_create_game ?></a>
</body>
</html>