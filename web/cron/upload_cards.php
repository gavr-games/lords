<?php
	//27.07.2011 WEB interface for uploading cards pictures

//This function reads the extension of the file. It is used to determine if the file  is an image by checking the extension.
 function getExtension($str) {
         $i = strrpos($str,".");
         if (!$i) { return ""; }
         $l = strlen($str) - $i;
         $ext = substr($str,$i+1,$l);
         return $ext;
 }
 
	//proccess cards images
	$path='../design/images/cards';
	$handle=opendir($path); // open templates dir
	
	$cards_list = $message = '';
	$cards = array();
	while (($file = readdir($handle))!==false) {
		if (strlen($file)>3)	{//no "." or ".."
			$cards[] = $file;
		}
	}
	sort($cards,SORT_NUMERIC);
	foreach($cards as $file){
		$name = explode('.',$file);
		if ($name[1]=='png')	{//no readme.txt or smth else
			$cards_list .= '<div class="card"><div class="file_name">'.$file.'</div><div class="card_pic"><img src="'.$path.'/'.$file.'"></div></div>';
		}
	}
	closedir($handle);
	$errors = 0;
	//checks if the form has been submitted
	if(isset($_POST['Submit'])) 
	{
 		//reads the name of the file the user submitted for uploading
 		$image=$_FILES['image']['name'];
 	//if it is not empty
 	if ($image) 
 	{
 		//get the original name of the file from the clients machine
 		$filename = stripslashes($_FILES['image']['name']);
 		//get the extension of the file in a lower case format
  		$extension = getExtension($filename);
 		$extension = strtolower($extension);
 		//if it is not a known extension, we will suppose it is an error and will not  upload the file,  
		//otherwise we will do more tests
 		if (($extension != "jpg") && ($extension != "jpeg") && ($extension != "png") && ($extension != "gif")) 
 		{
		//print error message
 			$message = '<h1>Неверное расширение.</h1>';
 			$errors=1;
 		}
 		else
 		{
			//the new name will be containing the full path where will be stored (images folder)
			$newname="../design/images/cards/".$filename;
			//we verify if the image has been uploaded, and print error instead
			$copied = copy($_FILES['image']['tmp_name'], $newname);
			if (!$copied) 
			{
				$message = '<h1>Невозможно скопировать карту в папку.</h1>';
				$errors=1;
			}
		}
	}
	}

	//If no errors registred, print the success message
	 if(isset($_POST['Submit']) && !$errors) 
	 {
	 	$message = "<h1>Карта успешно загружена. Если список не обновился - перегрузитесь с очисткой кэша.</h1>";
	 }
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
	<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
	<link id="site_icon" rel="icon" href="../design/images/icon_lords.ico" type="image/x-icon" />
	<title>Загрузка карт</title>
	<script type="text/javascript" src="../general_js/mootools.js"></script>
	<script type="text/javascript" src="../general_js/mootools-more.js"></script>
	<style>
		a{text-decoration:none; color:#ccc;border-left:3px solid #cbb06e;padding-left:5px;outline:none;}
		a:hover{color:white;border-left:3px solid white;}
		body {background-color:#312a1a;}
		#cards .card{float:left;margin:5px;padding:2px;}
		#cards .file_name{text-align:center;color:white;}
		#upload_card{padding:20px;background-color:#cbb06e;width:500px;}
		h1{color:white;}
	</style>
	<script>
	function initialization()	{
		$('upload_card').slide('out');
	}
	</script>
</head>
<body onload="initialization();">
	<?php echo $message; ?>
	<a href="#" onclick="$('upload_card').slide('toggle');return false;"> Загрузить карту </a>
	<a href="index.html"> Назад в меню </a>
	<div id="upload_card">
		<small>Расширение карт только png. Размер 130 x 186 пикселей. Также важно, что карт одного типа может быть несколько, для кжадой надо загрузить рисунок.</small>
		 <form name="newad" method="post" enctype="multipart/form-data"  action="">
		 <table>
		 	<tr><td><input type="file" name="image"></td></tr>
		 	<tr><td><input name="Submit" type="submit" value="Загрузить карту"></td></tr>
		 </table>	
		 </form>
		<small>Браузер иногда кеширует рисунки. Если список не обновился после загрузки - попробуй перегрузиться с очисткой кэша.</small>
	</div>
	<div id="cards">
		<?php echo $cards_list; ?>
	</div>
</body>
</html>