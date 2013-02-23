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
				<a href="arena/" onclick="enterArena();return false;">Арена</a> <br />
				<a target="_blank" href="https://docs.google.com/document/pub?id=1Hrs05cfYbibReAGZbKd3UG17zpmZfeZM15XDDr-qtK8">Библиотека</a><br />
                                <a target="_blank" href="<?php echo $SITE_conf['domen']; ?>gallery">Галерея</a><br />
			</div>
		</div>
				<span class="topbutton prof"><a href="profile/" onclick="alert('Извините профиль временно недоступен.');return false;">Профиль</a></span>
				<span class="topbutton exitbtn"><a href="#" id="logout_b" onclick="doLogout($('logout_b'));return false;">Выход</a></span>
	</div>
		<div id="footer"> 
	    	© 2011 "THE LORDS"
	    </div>
</body>