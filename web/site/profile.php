<?php
	include_once('init.php');
	include_once('../general_classes/image.class.php');
	
	//get user info
	$user_info = array('user_info','stats');
	$query = 'call '.$DB_conf['site'].'.get_user_profile('.$_GET['user_id'].');';
	$res = $dataBase->multi_query($query);
	foreach($user_info as $info) {
			$result = $mysqli->store_result();
			while ($row = mysqli_fetch_assoc($result))	{
				switch($info){
					case 'user_info':
						$user=$row;
					break;
					case 'stats':
						$stats[]=$row;
					break;
				}
			}
			$result->free();
			$mysqli->next_result();
	}
	$user['id'] = $_GET['user_id'];
	
	//avatar path
	if($user['avatar_filename']=='')
	  $prof_img = 'design/images/pregame/no_profile.png';
	  else
	  $prof_img = 'design/images/profile/'.$user['avatar_filename'];
	//came from
	if ($_GET['back']=='map') $back_url='site/map.php';
	if ($_GET['back']=='arena') $back_url='arena/arena.php';
	//print_r($user);
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
	<?= GoogleAnalytics::globalSiteTag() ?>
	<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
	<title>THE LORDS</title>
	<link id="site_icon" rel="icon" href="design/images/icon_lords.ico" type="image/x-icon" />
	<script type="text/javascript" src="../general_js/mootools.js?<?php echo $SITE_conf['revision']; ?>"></script>
	<script type="text/javascript" src="../general_js/mootools-more.js?<?php echo $SITE_conf['revision']; ?>"></script>
	<script type="text/javascript" src="js_libs/site.js?<?php echo $SITE_conf['revision']; ?>"></script>
	<script type="text/javascript" src="js_libs/static_libs.js?<?php echo $SITE_conf['revision']; ?>"></script>
        <link rel="stylesheet" type="text/css" href="../design/css/pregame/reset.css?<?php echo $SITE_conf['revision']; ?>" />
	<link rel="stylesheet" type="text/css" href="../design/css/pregame/main.css?<?php echo $SITE_conf['revision']; ?>" />
	<link rel="stylesheet" type="text/css" href="../design/css/pregame/profile.css?<?php echo $SITE_conf['revision']; ?>" />
	<style>
		.mask {
			opacity:0.5;
			background-color:black;
		}
	</style>
	<script>
		parent.USER_LANGUAGE = <?= LangUtils::getCurrentLangNumber($_SESSION['lang']) ?>;
	</script>
</head>
<body>
	<a href="<?= $SITE_conf['feedback_url'] ?>" id="feedback" target="_blank"><?= L::feedback ?></a>
	<div id="wrap" class="profile">
		<div id="profile">
			<h3 class="arena_header"><?= L::profile_profile ?></h3>
		  <form action="" method="post" enctype="multipart/form-data">
			  <span class="title"> - <?= L::profile_great_lord ?> <p class="nick"><?php echo $user['login']; ?></p></span>
			  <br clear="all" />
			  <div class="profile_cont">
			    <div class="profile_image">
			      <h3 style="margin-left:14px;"><?= L::profile_coat_of_arms ?></h3>
			      <img src="<?php echo $SITE_conf['domen'].$prof_img;?>?cache=<?php echo time(); ?>" alt="Герб" />
			    </div>
			    <div class="profile_stats">
			    <table>
			    <tr>
			      <td><h5><?= L::profile_last_game_date ?>:</h5></td><td> <?php echo $user['last_played_game']; ?></td>
			    </tr>
			    </table>
			    <br />
			    <h3><?= L::profile_statistics ?></h3>
			    <table class="stats">
			    <tr>
						<td><h5><?= L::profile_mode ?></h5></td>
			      <td><h5><?= L::profile_total_games ?></h5></td>
			      <td><h5><?= L::profile_victories ?></h5></td>
			      <td><h5><?= L::profile_defeats ?></h5></td>
			      <td><h5><?= L::profile_draws ?></h5></td>
			      <td><h5><?= L::profile_left_the_game ?></h5></td>
			    </tr>
			    <tr>
			      <?php
			      if (isset($stats))
				foreach($stats as $stat){
				  echo '
				  <tr>
				  <td>'.$stat['mode_name'].'</td>
				  <td>'.$stat['games_played'].'</td>
				  <td>'.$stat['win'].'</td>
				  <td>'.$stat['lose'].'</td>
				  <td>'.$stat['draw'].'</td>
				  <td>'.$stat['exit'].'</td>
				  </tr>
				  ';
				}
			      ?>
			    </tr>
			    </table>
			    </div>
			  </div>
		  </form>
		</div>

	</div>
</body>