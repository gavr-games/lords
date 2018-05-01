<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
	<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
	<title>THE LORDS</title>
	<link id="site_icon" rel="icon" href="../../design/images/icon_lords.ico" type="image/x-icon" />
	<script type="text/javascript" src="../../general_js/mootools.js?<?= $SITE_conf['revision'] ?>"></script>
	<script type="text/javascript" src="../../general_js/mootools-more.js?<?= $SITE_conf['revision'] ?>"></script>
	<script type="text/javascript" src="../../general_js/jquery-3.2.1.min.js?<?= $SITE_conf['revision']; ?>"></script>
	<script>
		jQuery.noConflict();
	</script>
	<script type="text/javascript" src="../../general_js/Chart.min.js?<?= $SITE_conf['revision']; ?>"></script>
	<script type="text/javascript" src="../../site/js_libs/cmd_helper.js?<?= $SITE_conf['revision'] ?>"></script>
	<script type="text/javascript" src="js_libs/static_libs.js?<?= $SITE_conf['revision'] ?>"></script>
	<script type="text/javascript" src="js_libs/loading.js?<?= $SITE_conf['revision'] ?>"></script>
	<link rel="stylesheet" type="text/css" href="../../design/css/reset.css?<?= $SITE_conf['revision'] ?>" />
	<link rel="stylesheet" type="text/css" href="css/mode9.css?<?= $SITE_conf['revision'] ?>" />
	<!--[if  IE]>
	<script type="text/javascript" src="../../general_js/excanvas.js"></script>
	<![endif]-->
	<script type="text/javascript">
	  game_mode = 1;
	  var USER_LANGUAGE = <?= $LANG ?>;
	</script>
</head>
<body onload="onPageLoad('<?= $SITE_conf['revision'] ?>')" onclick="stopShield();">
<div id="loading">
	<div class="phrase">
		<div><span id="phrase"></span></div>
		<div><span id="phrase_a"></span></div>
	</div>
	<div class="status">
		<p id="load_text"><?= L::game_page_structure_load ?></p>
		<div style="margin-top:10px;"><img src="../../design/images/loading_bar.gif"></div>
		<div id="load_list"> </div>
	</div>
</div>
<div onclick="" id="unitmes_w" class="unitmes" style="display:none">
           <table cellspacing="0" cellpadding="0">
          		<tbody><tr><td class="top"></td></tr>
          		<tr><td class="rep">
               		<div id="unitmes_c" class="content"></div>
           		</td></tr>
           		<tr><td class="bottom"> &nbsp;</td></tr>
           </tbody></table>
</div>
<div class="levelup_choose" style="display:none" id="lvl_choose">
  <a href="#" class="lvl_attack" id="lvl_a"> </a>
  <a href="#" class="lvl_moves"  id="lvl_m"> </a>
  <a href="#" class="lvl_health" id="lvl_h"> </a>
</div>
<div class="windowcont" id="windowsettings" style="display:none" onclick="$('windowsettings').setStyle('display','none');return false;">
      <div class="window" onclick="stopClick(event)">
           <table cellpadding="0" cellspacing="0"><tr><td class="topleft"></td><td class="toprep"> <?= L::game_settings ?></td><td class="topright"><a href="#" class="window_close" onclick="$('windowsettings').setStyle('display','none');return false;"></a></td></tr></table>
           <table cellpadding="0" cellspacing="0"><tr><td class="leftrep"></td><td class="midrep">
               <div class="content">
               	<?= L::game_highlight_board_cells ?>:<br />
						<select name="showColorCells" onchange="change_color_cells();" id="color_cells">
							<option value="1"><?= L::game_highlight_on ?></option>
							<option value="0"><?= L::game_highlight_off ?></option>
							<option value="m"><?= L::game_highlight_hover ?></option>
						</select>
						<br />
						<input type="checkbox" id="noSound" onclick="turnNoSound();"> <?= L::game_turn_off_sound ?><br />
						<input type="checkbox" id="noNextUnit" onclick="turnNoNextUnit();"> <?= L::game_turn_off_next_unit ?><br />
						<input type="checkbox" id="noNpcTalk" onclick="turnNoNpcTalk();"> <?= L::game_turn_off_unit_phrases ?>
               </div>
           </td><td class="rightrep"></td></tr></table>
           <table cellpadding="0" cellspacing="0"><tr><td class="leftbottom"></td><td class="bottomrep"> &nbsp;</td><td class="rightbottom"></td></tr></table>
      </div>
</div>

<div class="windowcont" id="windowspecs" style="display:none" onclick="$('windowspecs').setStyle('display','none');return false;">
      <div class="window" onclick="stopClick(event)">
           <table cellpadding="0" cellspacing="0"><tr><td class="topleft"></td><td class="toprep"> <?= L::game_info ?></td><td class="topright"><a href="#" class="window_close" onclick="$('windowspecs').setStyle('display','none');return false;"></a></td></tr></table>
           <table cellpadding="0" cellspacing="0"><tr><td class="leftrep"></td><td class="midrep">
               <div class="content">
               		<div id="game_info"></div>
               		<div id="spectators">
						<b><?= L::game_observers ?>:</b><br />
					</div>
               </div>
           </td><td class="rightrep"></td></tr></table>
           <table cellpadding="0" cellspacing="0"><tr><td class="leftbottom"></td><td class="bottomrep"> &nbsp;</td><td class="rightbottom"></td></tr></table>
      </div>
</div>

<div class="windowcont" id="windowmoney" style="display:none" onclick="$('windowmoney').setStyle('display','none');cancel_execute();return false;">
      <div class="window" onclick="stopClick(event)">
           <table cellpadding="0" cellspacing="0"><tr><td class="topleft"></td><td class="toprep"> <?= L::game_send_money ?></td><td class="topright"><a href="#" class="window_close" onclick="$('windowmoney').setStyle('display','none');cancel_execute();return false;"></a></td></tr></table>
           <table cellpadding="0" cellspacing="0"><tr><td class="leftrep"></td><td class="midrep">
               <div class="content">
               		<div id="send_money2">
						<input type="text" id="money_amount" value="" onfocus="chatFocused = true;" onblur="chatFocused = false;">
						<a href="#" onclick="money_amount_param();return false;"><?= L::game_send_money_btn ?></a>
					 </div>
               </div>
           </td><td class="rightrep"></td></tr></table>
           <table cellpadding="0" cellspacing="0"><tr><td class="leftbottom"></td><td class="bottomrep"> &nbsp;</td><td class="rightbottom"></td></tr></table>
      </div>
</div>

<div class="windowcont" id="window_m" style="display:none" onclick="if (!noCloseWindow) {$('window_m').setStyle('display','none');$('window_c').set('html','');}return false;">
      <div class="window" id="window_w" onclick="stopClick(event)">
           <table cellpadding="0" cellspacing="0"><tr><td class="topleft"></td><td class="toprep" id="window_h"> </td><td class="topright"><a href="#" id="window_close" class="window_close" onclick="$('window_m').setStyle('display','none');$('window_c').set('html','');return false;"></a></td></tr></table>
           <table cellpadding="0" cellspacing="0"><tr><td class="leftrep"></td><td class="midrep">
               <div class="content" id="window_c">
               </div>
           </td><td class="rightrep"></td></tr></table>
           <table cellpadding="0" cellspacing="0"><tr><td class="leftbottom"></td><td class="bottomrep"> &nbsp;</td><td class="rightbottom"></td></tr></table>
      </div>
</div>
<div id="cancel_action" onclick="cancel_execute();"> </div>
<div id="cards_container">
		<a href="#" id="cardsLink" class="cardsunactive" onclick="openCards();return false;"><?= L::game_cards ?></a>
		<a href="#" id="graveLink" class="cementaryunactive" onclick="openGrave();return false;"><?= L::game_graveyard ?></a>
		<a href="#" id="allcardstopLink" class="allcardstopunactive" onclick="openAllcardstop();return false;"></a>
		<a href="#" id="allcardsCloseLink" class="allcardsclose" onclick="hideSliders();return false;"></a>
	<div class="concards">
		<div class="cards" id="cards">
		   <a id="left_roll" class="unactive" href="#"></a>
		   <div id="cards_holder">
		   </div>
		   <a id="right_roll" class="unactive" href="#"></a>
		</div>
		<div id="graveyard">
		   <a id="left_roll_grave" class="unactive" href="#"></a>
		   <div id="grave_bg"> </div>
		   <div id="grave_holder">
		   </div>
		   <a id="right_roll_grave" class="unactive" href="#"></a>
		</div>
		<div id="fullsize">
			<div id="fullsize_grave_bg"> </div>
			<div id="fullsize_holder"></div>
		</div>
	</div>
</div>

<!--<div class="left_wirt">  </div>
<div class="right_wirt"> </div>-->
<div id="topbg"> </div>
<div id="wrap">

	<div class="abscont">
        <div class="pl_info">
        	<span id="players">
             </span>
              <p class="time" id="game_time">0:00</p>
              <p class="turn" id="game_turn"></p>
        </div>
        
        <ul id="menulist">
           <li class="menu">
		   	<div class="label"><?= L::game_menu ?></div>
               <table>
                  <tr><td><nobr><a href="#" onclick="$('windowsettings').setStyle('display','block');$('windowsettings').setStyle('height',document.getScrollSize().y);return false;"><?= L::game_settings ?></a></nobr></td></tr>
                  <tr><td><nobr><a href="#" onclick="$('windowspecs').setStyle('display','block');$('windowspecs').setStyle('height',document.getScrollSize().y);return false;"><?= L::game_info ?></a></nobr></td></tr>
                  <tr><td><nobr><a href="#" onclick="execute_exit();return false;"><?= L::game_exit ?></a></nobr></td></tr>
                  <tr><td><nobr><a href="#" onclick="execute_changeUser();return false;"><?= L::game_login_as_another_player ?></a></nobr></td></tr>
				  <tr><td>
				  	<div id="agree_draw">
						<input type="checkbox" id="chbDraw" onclick="changeDraw();"><?= L::game_agree_draw ?>
					</div></td></tr>
				  <tr><td><nobr><a href="#" onclick="displayLordsError(new Error('<?= L::game_error_fill_form ?>'),'');return false;" style="color:#9f0909;"><?= L::game_report_error ?></a></nobr></td></tr>
               </table>
           </li>
        </ul>
        
        <div id="leftbar">
          <div id="chat" class="chat">
              <div class="header"><?= L::game_chat ?></div>
              <div class="chat_cont">
                 <div id="game_chat" class="game_chat" style="height:600px;">
                 </div>
              </div>
              <div class="chat_toolbar">
                 <span id="chat_cnt" class="chat_cnt">0</span>
              </div>
              <div class="chat_mes">
                  <textarea onmousedown="this.focus();" name="chat_text" id="chat_text" onkeypress="if ((event.which && event.which == 13) || (event.keyCode && event.keyCode == 13)) {sendChatMessage(); return false;} else $('chat_cnt').set('html',this.value.length);" onfocus="chatFocused = true;" onblur="chatFocused = false;"></textarea>
              </div>
              <div class="chat_bottom" onmousedown="chat_resize = 1;" onmouseup="chat_resize = 0;"></div>
           </div>
        </div>
           
        <div id="rightbar">
          <div id="log" class="log">
              <div class="header"><?= L::game_log ?></div>
              <div class="log_cont" >
                 <div id="game_log" class="game_log" style="height:600px;"> </div>
              </div>
              <div class="log_bottom" onmousedown="log_resize = 1;" onmouseup="log_resize = 0;"></div>
           </div>
           
           <div id="ctrl_block" class="ctrl_block">
	          <div class="block">
	              <div class="buttons" id="main_buttons">
	                 <a href="#" class="btn_buycard" onclick="cancel_execute();execute_procedure('buy_card');return false;"><?= L::game_buy_card ?></a>
	                 <a href="#" class="btn_sendm" onclick="cancel_execute();execute_procedure('send_money');return false;" id="send_money1"><?= L::game_send_money ?></a>
			         <a href="#" class="btn_subs"  onclick="cancel_execute();execute_procedure('take_subsidy');deactivate_button(this);return false;"><?= L::game_take_subsidy ?></a>
			         <a href="#" class="btn_end_turn" onclick="cancel_execute();execute_procedure('player_end_turn');return false;"><?= L::game_end_turn ?></a>
	              </div>
	              <div class="main_cont" >
	                 <div class="inner">
	                     <div id="shield" class="shield"><span></span></div>
	                     <div class="whos_turn">
	           				<p><?= L::game_player ?>: </p><span id="activep_name"> </span><br/>
	           			 	<p><?= L::game_coordinates ?>: </p><span id="board_coords" class="board_coords"> 0 / 0</span>
	                        <p class="noanim" id="anim"></p>
	           			 </div>
	                     <div class="acts" id="actions">
	                     </div>
	                     <div class="ctrl_bottom">
	                     </div>
	                 </div>
	              </div>
	              <div class="hint" id="tip">
	              </div>
	              <div class="hint_bottom"></div>
	           </div>
	        </div>
        
        </div>
        
        
    </div>
    
    <div id="container">
    <canvas  id="canvas" height="715" width="715"></canvas>
    <div id="hor_line1" class="lines"></div>
    <div id="hor_line2" class="lines"></div>
    <div id="ver_line1" class="lines"></div>
    <div id="ver_line2" class="lines"></div>
    <div id="posl" class="barrow" onclick="$('hor_line1').fade('toggle');$('hor_line2').fade('toggle');"></div>
    <div id="posr" class="barrow" onclick="$('hor_line1').fade('toggle');$('hor_line2').fade('toggle');"></div>
    <div id="post" class="barrow" onclick="$('ver_line1').fade('toggle');$('ver_line2').fade('toggle');"></div>
    <div id="posb" class="barrow" onclick="$('ver_line1').fade('toggle');$('ver_line2').fade('toggle');"></div>
	<div class="board overboard" id="overboard">
	<?php
		for($y = 0; $y < 20; $y++) {
			for($x = 0; $x < 20; $x++) {
				echo '<div class="board_cell" onclick="board_clicked('.$x.','.$y.')" id="overboard_'.$x.'_'.$y.'"> </div>';
			}
			echo '<br clear="all" />';
		}
	?>
		<br clear="all" />
	</div><!--/.overboard-->
	<div class="board" id="board">
	<?php
		for($y = 0; $y < 20; $y++) {
			for($x = 0; $x < 20; $x++) {
				if ($x < 10 && $y < 10) $zone = 0;
				else if ($x >= 10 && $y < 10) $zone = 1;
				else if ($x >= 10 && $y >= 10) $zone = 2;
				else $zone = 3;
				echo '<div class="board_cell zone_'.$zone.'" id="board_'.$x.'_'.$y.'"> </div>';
			}
			echo '<br clear="all" />';
		}
	?>
	</div><!--/#board-->
			 <div id="footer"> 
			 <?php
			   $copyYear = 2010;
			   $curYear = date('Y');
			   $copy = '© ' . $copyYear . (($copyYear != $curYear) ? '-' . $curYear : '') . ' "THE LORDS"';
			 ?>
                <img id="get_commands_indicator" src="../../design/images/ajax-loader.gif" style="display:none;"><?= $copy ?><!----><!----><!----><!---->
             </div><!-- /#footer -->
             
        </div><!-- /#conteiner -->
	</div><!-- /#wrap -->
	<script type="module">
		import {WSClient} from "../../general_js/ws/wsclient.js?<?php echo $SITE_conf['revision']; ?>";
		window.WSClient = new WSClient();
	</script>
</body>
</html>