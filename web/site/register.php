<?php
	include_once('init.php');
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
	<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
	<title>Регистрация | THE LORDS</title>
	<link id="site_icon" rel="icon" href="../design/images/icon_lords.ico" type="image/x-icon" />
	<script type="text/javascript" src="../general_js/mootools.js?<?php echo $SITE_conf['revision']; ?>"></script>
	<script type="text/javascript" src="../general_js/mootools-more.js?<?php echo $SITE_conf['revision']; ?>"></script>
	<script type="text/javascript" src="js_libs/reg.js?<?php echo $SITE_conf['revision']; ?>"></script>
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
	<div id="reg_cont">
		<div id="regout_form">
		<span class="header_line">Регистрация</span>
		<form action="" method="post" id="reg_form" onsubmit="return false;">
			<p class="error_msg" id="reg_error"> </p>
			
			<div style="float:left; width:220px;">
	        <span class="logfields">Логин*:<p class="txtfield"><input class="log" type="text" name="login" id="login_i"></p></span>
	        <span class="logfields">Пароль*:<p class="txtfield"><input class="pas" type="password" name="pass" id="pass_i"></p></span>
	    	<span class="logfields">Повтор пароля*:<p class="txtfield"><input class="pas" type="password" name="pass2" id="pass2_i"></p></span>
	    	<span class="logfields">E-mail:<p class="txtfield"><input class="pas" type="text" name="email" id="email" title="для восстановления пароля" /></p></span>
	    	</div>
	    	<div class="button register"><span class="in_b_1"><p class="in_b_2"><a href="#" id="do_reg" onclick="doReg($('do_reg'));return false;">Зарегистрироваться</a></p></span></div>
	    </form>
	    <div class="button back" style="margin-right:30px;margin-top:10px;"><span class="in_b_1"><p class="in_b_2"><a id="to_main" href="#" onclick="if (!parent.window_loading){ parent.load_window('site/login.php','left'); doLoading($('to_main'));}return false;">На главную</a></p></span></div>
	    <p id="reg_ok" style="display:none;">Поздравляем с успешной регистрацией </p>
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