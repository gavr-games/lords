<?php
	include_once('init.php');
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
	<a href="<?= $SITE_conf['feedback_url'] ?>" id="feedback" target="_blank"><?= L::feedback ?></a>
	<div id="wrap" class="map">
		<div id="map">
			<div id="opened_map">
				<div class="col">
					<h3><?= L::about_about ?></h3>
					<?= L::about_short_description ?>
					<br />
					<br />
					<h3><?= L::about_gameplay ?></h3>
					<video width="320" height="240" controls>
						<source src="../design/video/gameplay.mp4" type="video/mp4">
					</video>
				</div>
				<div class="col">
					<h3><?= L::about_features ?></h3>
					<ul>
						<li>
						<?= str_replace(' | ', '</li><li>', L::about_features_list) ?>
						</li>
					</ul>
					<br />
					<br />
					<a href="arena/" onclick="enterArena();return false;" class="login-arena-btn">
						<?= L::about_login_arena ?>
					</a>
				</div>
			</div>
		</div>
		<span class="topbutton prof"><a href="#" id="profile_b" onclick="if (!parent.window_loading) {doLoading($('profile_b'), '<?= L::loading_text ?>');parent.load_window('site/myprofile.php?back=map','left');} return false;"><?= L::profile_profile ?></a></span>
		<span class="topbutton en"><a href="/site/lang.php?lang=en">EN</a></span>
		<span class="topbutton ru"><a href="/site/lang.php?lang=ru">RU</a></span>
		<span class="topbutton exitbtn"><a href="#" id="logout_b" onclick="doLogout($('logout_b'), '<?= L::loading_text ?>');return false;"><?= L::do_exit ?></a></span>
	</div>
</body>