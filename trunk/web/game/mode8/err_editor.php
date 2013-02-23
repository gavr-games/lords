<?php
	//proccess templates
	$handle=opendir("."); // open templates dir
	$error_files = array();
	while (($file = readdir($handle))!==false) {
		if (strlen($file)>3)	{//no "." or ".."
			$name = explode(' ',$file);
			if ($name[0]=='error')	{//no readme.txt or smth else
				$error_files[] = $file;
			}
		}
	}
	closedir($handle);
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
	<meta content="text/html; charset=UTF-8" http-equiv="Content-Type">
	<title>THE LORDS - Error Editor</title>
	<link rel="stylesheet" type="text/css" href="css/err_editor.css" />
	<script type="text/javascript" src="../../general_js/mootools.js"></script>
	<script type="text/javascript" src="../../general_js/mootools-more.js"></script>
	<script type="text/javascript" src="js_libs/err_editor.js"></script>
</head>
<body onload="initialization();">
	<div id="editor">
		<div id="editor_controls">
			<div class="errl" onclick="errListSlider.toggle();">
			</div>
			<div class="dbg" onclick="debugSlider.toggle();">
			</div>
			<div class="tlbx" onclick="toolboxSlider.toggle();">
			</div>
			<div class="kill" onclick="hideAll();">
			</div>
		</div> <br clear="all" />
		<div id="error_files_list">
			<h3>Errors list</h3>
			<table id="errors_table">
			<tr><th>ID</th><th>Date</th><th>Time</th></tr>
			<?php
				$i = 0;
				foreach($error_files as $err_file){
					$file_info = explode(' ',$err_file);
					$id = explode('.',$file_info[3]);
					echo '<tr id="err_'.$id[0].'" class="'.($i%2==0?'':'grey').'" onclick="setActiveErr(\''.$id[0].'\');$(\'i_frame\').set(\'src\',\''.$err_file.'\')">';
					echo '<td>'.$id[0].'</td>';
					echo '<td>'.$file_info[1].'</td>';
					echo '<td>'.$file_info[2].'</td>';
					echo '</tr>';
					$i++;
				}
			?>
			</table>
				<small>Total: <span id="err_count"><?php echo count($error_files); ?></span> Errors</small>
		</div>
		<div id="debug">
			<h3>Debug</h3>
			<div id="debug_cont">
			</div>
		</div>
		<div id="toolbox">
		<h3>Toolbox</h3>
			<div id="toolbox_list">
                            <ul>
				<li><a href="#" onclick="killErrWinds();return false;">Kill all red errors</a>
                                <li><a href="#" onclick="reloadIframe();return false;">Reload error window</a>
                                <li><a href="#" onclick="loadDebug();return false;">Load info to Debug</a>
                                <li><a href="#" onclick="turnOffSound();return false;">Turn off that crazy sound</a>
                                <li><a href="#" onclick="evalSlider.toggle();return false;">Eval in game window</a>
                                <li id="eval_li">
                                    <textarea class="eval_area" id="eval_area"></textarea>
                                    <a href="#" onclick="evalInWindow();return false;">Eval</a>
                                </li>
                                <li><a href="#" onclick="enableBacklight();return false;">Enable backlight</a>
                                <li><a href="../../cron/">Back to Admin menu</a>
                            </ul>
			</div>
		</div>
	</div>
			<iframe src="" id="i_frame" allowtransparency="true" onload=""></iframe>
</body>
</html>