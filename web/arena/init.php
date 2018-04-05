<?php
	//init classes and db connection
	session_start();
	if ($_SESSION['user_id']=='') header('location:../');
	else { 
		include_once('../general_config/config.php');
		include_once('../general_classes/sql.class.php');
		$mysqli = new mysqli($DB_conf['server'], $DB_conf['user'], $DB_conf['pass']);
		if (mysqli_connect_errno()) {
			    printf("Connect failed: %s\n", mysqli_connect_error());
			    die();
		}
		$dataBase = new cDataBase($mysqli);
		$dataBase->query("SET NAMES 'UTF8'");
	}
	
		$js_arrays = '';
	//proccess templates
	$path='templates/';
	$handle=opendir($path); // open templates dir
	
	while (($file = readdir($handle))!==false) {
		if (strlen($file)>3)	{//no "." or ".."
			$name = explode('.',$file);
			if ($name[1]=='html')	{//no readme.txt or smth else
				$template_contents = LangUtils::replaceTemplateMarkers(file_get_contents($path.$file));
				$templates[$name[0]] = str_replace(array('\\'), array(''), $template_contents); //for php templating
				$template = str_replace(array(chr(13),chr(10),chr(9),'"'), array('','','','\\"'), $template_contents); //delete new lines, tab, add bslash
				$template = "'".preg_replace("/###([^#]*)###/","'+\\1+'",$template)."'";
				$js_arrays .= 'var '.$name[0].' = "'.$template.'";'; //for js templating
			}
		}
	}
	closedir($handle);
?>