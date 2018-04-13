<?php
	include_once('init.php');
	
	//print features inputs and boxes
	function echoFeatures($features)	{
		global $templates,$cur_game_row;
		if ($features)
		foreach($features as $feature)	{
				$search = $replace = array();
				foreach($feature as $key=>$value)	{
							$search[]  = '###'.$key.'###';
							$replace[] = $value;
				}
			//checkbox feature
			if($feature['feature_type']=='bool')	{
				if ($feature['in_game']==1) $checked = 'checked="checked"';
				else $checked = '';
				$search[]  = "###checked###";
				$replace[] = $checked;
				echo str_replace($search,$replace,$templates['feature_checkbox']);
			}//input feature
			else {
				echo str_replace($search,$replace,$templates['feature_input']);
			}
		}
	}

//get game all features info
	$features = array();
	$query = 'call '.$DB_conf['site'].'.get_create_game_features('.$_SESSION['user_id'].');';
	$res = $dataBase->multi_query($query);
	$result = $mysqli->store_result();
	while ($row = mysqli_fetch_assoc($result))	{
		$features[$row['id']] = $row;
	}
	$result->free();
	$mysqli->next_result();
	
//arena current game f5 info
	$game_info = array('game','features','players');
	$cur_game  = '';
	$cur_game_row = array();
	/*$markers['###JS_ARRAYS###'] .= 'var users = new Array();'.chr(13);
	$markers['###JS_ARRAYS###'] .= 'var chats = new Array();'.chr(13);*/
	$teams = array();
	$teams_count = 0;
	$spectators = $no_team = '';
	$query = 'call '.$DB_conf['site'].'.get_current_game_info('.$_SESSION['user_id'].');';
	$res = $dataBase->multi_query($query);
	foreach($game_info as $info) {
			$result = $mysqli->store_result();
			while ($row = mysqli_fetch_assoc($result))	{
				switch($info){
					case 'game':
						$search = $replace = array();
						foreach($row as $key=>$value)	{
							$search[]  = '###'.$key.'###';
							$replace[] = $value;
						}
						$cur_game_row = $row;
						$cur_game .= str_replace($search,$replace,$templates['current_game']);
					break;
					case 'players':
						$search = $replace = array();
						foreach($row as $key=>$value)	{
							$search[]  = '###'.$key.'###';
							if ($key=="avatar_filename") $value = $SITE_conf['domen']."design/images/profile/".$value;
							$replace[] = $value;
						}
						$search[] = "###display###";
						if ($row['avatar_filename']=="") $replace[] = "none"; else $replace[] = "block";
						
						if ($row['spectator_flag']==1) //spectator
							$spectators.= str_replace($search,$replace,$templates['player_in_game']);
						else
							if ($row['team']>=0 && $row['team']<$features[3]['param'] && $row['team']!='') //have valid team
								$teams[$row['team']] .= str_replace($search,$replace,$templates['player_in_game']);
							else
								$no_team .= str_replace($search,$replace,$templates['player_in_game']);
					break;
					case 'features':
						if ($row['value']!=0) {
						$features[$row['feature_id']]['in_game'] = 1;
						$features[$row['feature_id']]['param']   = $row['value'];
						//generate teams
						if ($row['feature_id']==3)	{
							for($i=0;$i<$row['value'];$i++)	{
								$teams[$i] = '';
							}
						}
					}
					break;
				}
			}
			$result->free();
			$mysqli->next_result();
	}
	//generate selected features
	foreach($features as $fkey=>$feature)	{
		//add some params
		$features[$fkey]['game_id'] = $cur_game_row['game_id'];
		if (!$features[$fkey]['param']) $features[$fkey]['param'] = '';
		if ($feature['in_game'] == 1)	{
		  	if ($feature['feature_type']=='bool') {
				$feature['param'] = '';
		  	}
			$selected_features .= 'parent.arena_game_set_feature('.$cur_game_row['game_id'].', '.$feature['id'].', '.$feature['param'].');';
		}
	}
	//generate teams
	$teams_str = '';
	foreach($teams as $key=>$team)	{
		$search = $replace = array();
		$search[]  = '###id###';
		$replace[] = $key;
		$search[]  = '###players###';
		$replace[] = $team;
		$teams_str .= str_replace($search,$replace,$templates['team_in_game']);
	}
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
	<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
	<title>THE LORDS</title>
	<script type="text/javascript" src="../general_js/mootools.js?<?php echo $SITE_conf['revision']; ?>"></script>
	<script type="text/javascript" src="../general_js/mootools-more.js?<?php echo $SITE_conf['revision']; ?>"></script>
        <script type="text/javascript" src="js_libs/custom_scroll.js?<?php echo $SITE_conf['revision']; ?>"></script>
	<script type="text/javascript" src="js_libs/game.js?<?php echo $SITE_conf['revision']; ?>"></script>
	<link rel="stylesheet" type="text/css" href="../design/css/pregame/reset.css?<?php echo $SITE_conf['revision']; ?>" />
	<link rel="stylesheet" type="text/css" href="../design/css/pregame/arena_game.css?<?php echo $SITE_conf['revision']; ?>" />
	<link rel="stylesheet" type="text/css" href="../design/css/pregame/scrollstl.css?<?php echo $SITE_conf['revision']; ?>" />
	<link rel="stylesheet" type="text/css" href="../design/css/pregame/helpstl.css?<?php echo $SITE_conf['revision']; ?>" />
	<style>
		#no_team{
			border:4px outset blue;
			height:20px;
			overflow:visible;
		}
		#game_features span{
			display:block;
		}
	</style>
</head>
<body onload="game_initialization();">
<script type="text/javascript">
	var cur_game_id = <?php echo $cur_game_row['game_id']; ?>;
	var cur_game_mode_id = <?php echo $cur_game_row['mode_id']; ?>;
	parent.parent.apeJoinChanels(['arenagame_'+cur_game_id]);
</script>
<div class="current_game">
	<a class="help" title="<?= L::arena_game_help ?>" href="" onclick="return false;"></a>
        <?php  echo $cur_game; ?>
		<div id="trash" onclick="exitGame();return false;"></div>
		<div class="content" id="ingame_content">
				<div id="spectators">
					<?php echo $spectators; ?>
				</div>
			<br clear="all" />
				<div id="teams">
					<?php echo $teams_str; ?>
				</div>
				<div class="features_cont">
					<?php if ($cur_game_row['owner_id']==$_SESSION['user_id']) { //I'm owner?>
					<div class="select_game_features">
						<b><?= L::arena_game_features ?>:</b><br />
						<?php echoFeatures($features); ?>
					</div>
					<a href="#" onclick="startGame();return false;"><?= L::arena_game_start ?></a>
					
					<?php } ?>
					<br/>
					<b><?= L::arena_game_selected_features ?>:</b><br />
					<div id="game_features">
					</div>
				</div>
		</div><!--.content-->
</div>
<script>
<?php echo $selected_features; ?>
</script>
</body>
</html>