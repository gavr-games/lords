<?php
	include_once('init.php');
	include_once('../general_classes/rules.class.php');
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
	<div id="wrap" class="map">
		<div id="map">
			<div id="opened_map">
				<?= Rules::getHtml(LangUtils::getCurrentLangCode($_SESSION['lang'])) ?>
			</div>
		</div>
        <span class="topbutton back"><a href="#" id="back_b" onclick="if (!parent.window_loading) {doLoading($('back_b'), '<?= L::loading_text ?>');parent.load_window('site/login.php','right');} return false;"><?= L::back ?></a></span>
		<span class="topbutton en_about"><a href="/site/lang.php?lang=en">EN</a></span>
		<span class="topbutton ru_about"><a href="/site/lang.php?lang=ru">RU</a></span>
	</div>
		<div id="footer"> 
	    	© <?php 
		$copyYear = 2010; 
		$curYear = date('Y'); 
		echo $copyYear . (($copyYear != $curYear) ? '-' . $curYear : '');
		?> "THE LORDS"
	    </div>
</body>