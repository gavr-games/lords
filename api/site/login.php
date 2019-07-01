<?php
  $clear_user = 1;
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
		<div id="log_cont">
			<div id="log_form" class="<?php  echo getSeason(); ?>">
				<form action="ajax/authorize_user.php" method="post" id="login_form" onsubmit="return false;">
					<p class="error_msg" id="login_error"> </p>
					<div style="float:left; width:220px;">
		               <span class="logfields"><?= L::login_login ?>:<p class="txtfield"><input class="log" type="text" name="login" id="login_i"></p></span>
		               <span class="logfields"><?= L::login_password ?>:<p class="txtfield"><input class="pas" type="password" name="pass" id="pass_i"></p></span>
		    		</div>
		    		<div class="button">
						<span class="in_b_1"><p class="in_b_2"><a id="login_b" href="#" class="" onclick="doLogin($('login_b'), '<?= L::login_fields_blank ?>', '<?= L::loading_text ?>');return false;"><?= L::login_enter ?></a></p></span>
					</div>
		        </form>
				<hr>
				<form action="ajax/authorize_user.php" method="post" id="guest_login_form" onsubmit="return false;">
					<div style="float:left; width:220px;">
		               <span class="logfields"><?= L::login_name ?>:<p class="txtfield"><input class="log" type="text" name="name" id="guest_name_i"></p></span>
		    		</div>
					<div class="button">
						<a class="help" title="<?= L::login_guest_help ?>" href="" onclick="return false;"></a>
						<span class="in_b_1"><p class="in_b_2"><a id="guest_login_b" href="#" class="" onclick="doGuestLogin($('guest_login_b'), '<?= L::login_fields_blank ?>', '<?= L::loading_text ?>');return false;"><?= L::login_guest_enter ?></a></p></span>
					</div>
		        </form>
		        <a class="link reg" href="#" onclick="if (!parent.window_loading) parent.load_window('site/register.php','right'); return false;"><?= L::login_want_signup ?></a>
			</div>
			<span class="topbutton about"><a id="about_b" href="/site/rules.php" target="_blank"><?= L::rules_rules ?></a></span>
			<span class="topbutton en"><a href="/site/lang.php?lang=en">EN</a></span>
			<span class="topbutton ru"><a href="/site/lang.php?lang=ru">RU</a></span>
		</div>
		<script>
			var myTips = new Tips('.help');
		</script>
</body>