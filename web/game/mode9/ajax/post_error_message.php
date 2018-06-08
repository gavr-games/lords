<?php
	include_once('init.php');
	set_time_limit(0);
	$_POST['head'] = rawurldecode($_POST['head']);
	$_POST['body'] = rawurldecode($_POST['body']);
	$_POST['add_script'] = rawurldecode($_POST['add_script']);
	$_POST['comment'] = rawurldecode($_POST['comment']);
	$_POST['comment'] = strip_tags($_POST['comment']);
	$_POST['comment'] = str_replace(array(chr(10),chr(13),"'"),array('','',"\\'"),$_POST['comment']);
	$add_script = '<script type="text/javascript" id="add_script">';
	$add_script .= '$("error_comment").set("value","'.$_POST['comment'].'");';
	$add_script .= $_POST['add_script'];
	//some scripts for more easy debug
	$add_script .= "
		//init events for overboard cells
		$('overboard').getChildren('.board_cell').each(function(elem,index)	{
			if (elem)	{
				var idcoords = elem.get('id').split('_');
				elem.addEvent('mouseenter', function(){
					backlight(idcoords[1].toInt(),idcoords[2].toInt());
				});
				elem.addEvent('mouseleave', function(){
					backlight_out(idcoords[1].toInt(),idcoords[2].toInt());
				});
			}
		});
		//init log containers sliders
		$('game_log').getChildren().each(function(item,index)	{
			oldDiv = item.getChildren();
			if (oldDiv[1])	{
				okDiv = oldDiv[1].getChildren()[0].dispose();
				okDiv.setStyle('margin-top',0);
				item.grab(okDiv,'bottom');
				oldDiv[1].destroy();
				okDiv.slide();
				oldDiv[0].addEvent('click', function(){
					if (this.getNext('div.sub'))
						contChild = this.getNext('div.sub');
					else
						contChild = this.getNext('div').getChildren('div.sub')[0];
						contChild.slide();
					
				});
			}
		});
		//init sliders
		$('cards_container').getChildren('.concards')[0].getChildren().each(function(item,index)	{
			oldDiv = item.getChildren();
			if (oldDiv[0])	{
				okDiv = oldDiv[0].dispose();
				okDiv.setStyle('margin-top',0);
				item.getParent().grab(okDiv,'bottom');
				item.destroy();
			}
		});
		cardsSlider = new Fx.Slide($('cards'), {}).slideOut('vertical');
		graveSlider = new Fx.Slide($('graveyard'), {}).slideOut('vertical');
		allCardsSlider = new Fx.Slide($('fullsize'), {}).slideOut('vertical');

		makeCardsCarousel();
		makeGraveCarousel();
		document.body.setStyle('overflow','visible');
	";
	$add_script .= '</script>';
//form html code of page with error
$html_code = '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
';
$html_code .= $_POST['head'];
$html_code .= '
</head>
<body onclick="stopShield();">
';
$html_code .= $_POST['body'];
$html_code .= $add_script;
$html_code .= '
</body>
</html>';
	$myFile = "error ".date('Y_m_d H_i s').rand(0,10000).".html";
	$fh = fopen('../'.$myFile, 'w') or die(L::game_error_fail);
	fwrite($fh, $html_code);
	fclose($fh);
	echo '<b>'.L::game_error_success.'.</b><br />
	<b>'.L::game_error_link.':</b> <a target="_blank" href="'.$SITE_conf['domen'].'game/mode9/'.$myFile.'">'.$SITE_conf['domen'].'game/mode9/'.$myFile.'</a>';
?>