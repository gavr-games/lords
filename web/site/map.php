<?php
	include_once('init.php');
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
	<style>
		.mask {
			opacity:0.5;
			background-color:black;
		}
	</style>
</head>
<body>
	<div id="wrap" class="map">
		<div id="map">
			<div id="opened_map">
				<a href="arena/" onclick="enterArena();return false;">
					<img src="/design/images/pregame/arena.png" alt="Арена">
				</a><br />
				<a target="_blank" href="https://docs.google.com/document/pub?id=1Hrs05cfYbibReAGZbKd3UG17zpmZfeZM15XDDr-qtK8">
					<img src="/design/images/pregame/library.png" alt="Библиотека">
				</a><br />
				<a target="_blank" href="<?php echo $SITE_conf['domen']; ?>gallery">
					<img src="/design/images/pregame/gallery.png" alt="Галерея">
				</a>
			</div>
		</div>
		<span class="topbutton prof"><a href="#" id="profile_b" onclick="if (!parent.window_loading) {doLoading($('profile_b'), '<?= L::loading ?>');parent.load_window('site/myprofile.php?back=map','left');} return false;"><?= L::profile_profile ?></a></span>
		<span class="topbutton en"><a href="/site/lang.php?lang=en">EN</a></span>
		<span class="topbutton ru"><a href="/site/lang.php?lang=ru">RU</a></span>
		<span class="topbutton exitbtn"><a href="#" id="logout_b" onclick="doLogout($('logout_b'), '<?= L::loading ?>');return false;"><?= L::do_exit ?></a></span>
	</div>
		<div id="footer"> 
	    	© <?php 
		$copyYear = 2010; 
		$curYear = date('Y'); 
		echo $copyYear . (($copyYear != $curYear) ? '-' . $curYear : '');
		?> "THE LORDS"
	    </div>
</body>