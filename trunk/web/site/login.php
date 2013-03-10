<?php
  $clear_user = 1;
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
		
		<div id="log_cont">
			<div id="log_form" class="<?php  echo getSeason(); ?>">
				<form action="ajax/authorize_user.php" method="post" id="login_form" onsubmit="return false;">
					<p class="error_msg" id="login_error"> </p>
					<div style="float:left; width:220px;">
		               <span class="logfields">Логин:<p class="txtfield"><input class="log" type="text" name="login" id="login_i"></p></span>
		               <span class="logfields">Пароль:<p class="txtfield"><input class="pas" type="password" name="pass" id="pass_i"></p></span>
		    		</div>	
		    			<div class="button"><span class="in_b_1"><p class="in_b_2"><a id="login_b" href="#" class="" onclick="doLogin($('login_b'));return false;">Войти</a></p></span></div>
		    		
		        </form>
		        <a class="link reg" href="#" onclick="if (!parent.window_loading) parent.load_window('site/register.php','right'); return false;">Желаете зарегистрироваться?</a>
			</div>
		</div>
		<div id="footer"> 
	    	© <?php 
		$copyYear = 2010; 
		$curYear = date('Y'); 
		echo $copyYear . (($copyYear != $curYear) ? '-' . $curYear : '');
		?> "THE LORDS"
	    </div>
</body>