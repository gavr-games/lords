<?php
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
  $dataBase->query("SET NAMES 'UTF8'");
  $_GET['user_id'] = preg_replace("/[^0-9]/", "", $_GET['user_id']);
  $load_frame = 'profile.php?user_id='.$_GET['user_id'];

?>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
	<?= GoogleAnalytics::globalSiteTag() ?>
	<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
	<title>THE LORDS</title>
	<link id="site_icon" rel="icon" href="../design/images/icon_lords.ico" type="image/x-icon" />
	<script type="text/javascript" src="../general_js/mootools.js?<?php echo $SITE_conf['revision']; ?>"></script>
	<script type="text/javascript" src="../general_js/mootools-more.js?<?php echo $SITE_conf['revision']; ?>"></script>
	<script type="text/javascript" src="js_libs/winds.js?<?php echo $SITE_conf['revision']; ?>"></script>
    <link rel="stylesheet" type="text/css" href="../design/css/pregame/reset.css?<?php echo $SITE_conf['revision']; ?>" />
	<link rel="stylesheet" type="text/css" href="../design/css/pregame/main.css?<?php echo $SITE_conf['revision']; ?>" />
	<script>
		var load_frame = '<?php echo $load_frame; ?>';
		var site_domen = '<?php echo $SITE_conf['domen']; ?>';
		var my_user_id = '<?php echo $_SESSION['user_id']; ?>';
		parent.USER_LANGUAGE = <?= LangUtils::getCurrentLangNumber($_SESSION['lang']) ?>;
	</script>
	<style>
		#map {
			border:6px outset black;
			padding:50px;
			margin:20px;
		}
		#log_form,#logged_form {
			border:6px outset black;
			padding:50px;
			margin:20px;
		}
		#login_error{
			color:red;
			display:none;
		}
		.mask {
			opacity:0.5;
			background-color:black;
		}
	</style>
</head>
<body onload="current_window.fade(1);current_window.contentWindow.document.body.style.overflow = 'visible';">
	<a href="<?= $SITE_conf['feedback_url'] ?>" id="feedback" target="_blank"><?= L::feedback ?></a>
	<div id="wind">
		<div id="panor"> 
				<div class="rel" id="rel">
				
    			</div><!--.rel-->
    	</div><!--#panor-->
    </div><!--#wind-->
</body>