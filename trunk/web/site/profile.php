<?php
	include_once('init.php');
	//get user $_SESSION['user_id']
	$user['id'] = $_SESSION['user_id'];
	$user['image'] = '';
	//check for current profile image
	if($user['image']=='')
	  $prof_img = 'design/images/pregame/no_profile.png';
	  else
	  $prof_img = 'design/images/profile/'.$user['image'];
	if ($_GET['back']=='map') $back_url='site/map.php';
	if ($_GET['back']=='arena') $back_url='arena/arena.php';
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
			<span class="title"> - Великий Лорд <p class="nick">Skoba</p></span>
			<br clear="all" />
			<div class="profile_cont">
			  <div class="profile_image">
			    <img src="<?php echo $SITE_conf['domen'].$prof_img;?>" alt="Герб" />
			  </div>
			  <div class="profile_stats">
			  </div>
			</div>
		</div>
		<span class="topbutton back"><a href="#" id="back_b" onclick="if (!parent.window_loading) {doLoading($('back_b'));parent.load_window('<?php echo $back_url; ?>','right');} return false;">Назад</a></span>
		<span class="topbutton exitbtn"><a href="#" id="logout_b" onclick="doLogout($('logout_b'));return false;">Выход</a></span>
	</div>
		<div id="footer"> 
	    	© 2013 "THE LORDS"
	    </div>
</body>