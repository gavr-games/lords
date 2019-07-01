<?php
	$no_redirect = true;
	include_once('init.php');
	include_once('../general_classes/rules.class.php');
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
		var load_frame = '<?= Rules::getEmbedUrl(LangUtils::getCurrentLangCode($_SESSION['lang'])) ?>';
		var site_domen = '<?= $SITE_conf['domen']; ?>';
		var my_user_id = '<?= $_SESSION['user_id']; ?>';
		parent.USER_LANGUAGE = <?= LangUtils::getCurrentLangNumber($_SESSION['lang']) ?>;
		width_correction = -100;
		height_correction = -150;
	</script>
</head>
<body class="rules" onload="current_window.fade(1);current_window.contentWindow.document.body.style.overflow = 'visible';">
	<a href="<?= $SITE_conf['feedback_url'] ?>" id="feedback" target="_blank"><?= L::feedback ?></a>
	<span class="topbutton en"><a href="/site/lang.php?lang=en">EN</a></span>
	<span class="topbutton ru"><a href="/site/lang.php?lang=ru">RU</a></span>
	<div id="wind">
		<div id="panor"> 
				<div class="rel" id="rel">
				
				</div><!--.rel-->
    	</div><!--#panor-->
	</div><!--#wind-->
</body>
</html>