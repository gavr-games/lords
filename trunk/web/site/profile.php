<?php
	include_once('init.php');
	include_once('../general_classes/image.class.php');
	
	//get user info
	  $query = 'call ' . $DB_conf['site'] . '.get_user_profile(' . $_GET['user_id'] . ');'; //get  data
	  $result = $dataBase->multi_query($query);
	  do {
		/* store first result set */
		if ($result = $mysqli->store_result()) {
			while ($r = $result->fetch_assoc()) {
			$user = $r;
			}
			$result->free();
			$i++;
		}
		/* print divider */
		if ($mysqli->more_results()) {
		}
	  } while ($mysqli->next_result());
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
</head>
<body>
	<div id="wrap" class="profile">
		<div id="profile">
		  <form action="" method="post" enctype="multipart/form-data">
			  <span class="title"> - Великий Лорд <p class="nick"><?php echo $user['login']; ?></p></span>
			  <br clear="all" />
			  <div class="profile_cont">
			    <div class="profile_image">
			      <h3 style="margin-left:14px;">Герб лорда</h3>
			      <img src="<?php echo $SITE_conf['domen'].$prof_img;?>?cache=<?php echo time(); ?>" alt="Герб" />
			    </div>
			    <div class="profile_stats">
			    
			    </div>
			  </div>
		  </form>
		</div>

	</div>
		<div id="footer"> 
	    	© 2013 "THE LORDS"
	    </div>
</body>