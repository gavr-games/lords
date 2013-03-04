<?php
	include_once('init.php');
	include_once('../general_classes/image.class.php');
	
	//get user info
	  $query = 'call ' . $DB_conf['site'] . '.get_my_profile(' . $_SESSION['user_id'] . ');'; //get my data
	  $result = $dataBase->multi_query($query);
	  do {
		/* store first result set */
		if ($result = $mysqli->store_result()) {
			while ($r = $result->fetch_assoc()) {
			$user = $r;
			}
			$result->free();
			$i++;
		}
		/* print divider */
		if ($mysqli->more_results()) {
		}
	  } while ($mysqli->next_result());
	$user['id'] = $_SESSION['user_id'];
	$avatar_error = '';
	
	//here process new avatar if needed (delete old, check new, save unique new, resize new)

	if ($_FILES["pic"]["error"] > 0){
	  $avatar_error = 'Не удалось загрузить герб';
	}else
	if ($_FILES["pic"]["tmp_name"]!="")
	{
	    move_uploaded_file($_FILES["pic"]["tmp_name"], "../design/images/profile/" . $_FILES["pic"]["name"]);
	    $avatar = new cImage("../design/images/profile/" . $_FILES["pic"]["name"]);
	    if ($avatar->type){
	      //del old avatar
	      if ($user['avatar_filename']!="" && file_exists("../design/images/profile/".$user['avatar_filename']))
		unlink("../design/images/profile/".$user['avatar_filename']);
	      if($avatar->resize("../design/images/profile/".$_SESSION['user_id'],75,55)){
		$user['avatar_filename'] = basename($avatar->filenew);
		
		//save user new profile
		$query = 'call ' . $DB_conf['site'] . '.user_profile_update(' . $_SESSION['user_id'] . ',"'.$user['avatar_filename'].'");'; //get my data
		$result = $dataBase->multi_query($query);
		do {
		      /* store first result set */
		      if ($result = $mysqli->store_result()) {
			      while ($r = $result->fetch_assoc()) {
			      }
			      $result->free();
			      $i++;
		      }
		      /* print divider */
		      if ($mysqli->more_results()) {
		      }
		} while ($mysqli->next_result());
		
	      } else
	      $avatar_error = 'Не удалось изменить размер герба';
	    } else {
	      $avatar_error = 'Неверное расширение файла герба';
	    }
	    unlink("../design/images/profile/" . $_FILES["pic"]["name"]);
	}
	//print_r($user);
	//avatar path
	if($user['avatar_filename']=='')
	  $prof_img = 'design/images/pregame/no_profile.png';
	  else
	  $prof_img = 'design/images/profile/'.$user['avatar_filename'];
	//came from
	if ($_GET['back']=='map') $back_url='site/map.php';
	if ($_GET['back']=='arena') $back_url='arena/arena.php';
	//print_r($user);
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
	<link rel="stylesheet" type="text/css" href="../design/css/pregame/profile.css?<?php echo $SITE_conf['revision']; ?>" />
	<style>
		.mask {
			opacity:0.5;
			background-color:black;
		}
	</style>
</head>
<body>
	<div id="wrap" class="profile">
		<div id="profile">
		  <form action="" method="post" enctype="multipart/form-data">
			  <span class="title"> - Великий Лорд <p class="nick"><?php echo $user['login']; ?></p></span>
			  <br clear="all" />
			  <div class="profile_cont">
			    <div class="profile_image">
			      <h3 style="margin-left:14px;">Герб лорда</h3>
			      <img src="<?php echo $SITE_conf['domen'].$prof_img;?>?cache=<?php echo time(); ?>" alt="Герб" />
			      <h5>Выбрать новый герб (75x55)</h5>
			      <p><input type="file" name="pic"></p>
			    </div>
			    <div class="profile_stats">
			    <h5 style="float:left">E-mail:</h5> <?php echo $user['email']; ?>
			    </div>
			  </div>
			  <br /><br /><br /><br /><br />
			  <input style="float:right;" type="submit" value="Подать прошение" /> <br />
			  <span class="error"><?php echo $avatar_error; ?></span>
		  </form>
		</div>
		<span class="topbutton back"><a href="#" id="back_b" onclick="if (!parent.window_loading) {doLoading($('back_b'));parent.load_window('<?php echo $back_url; ?>','right');} return false;">Назад</a></span>
		<span class="topbutton exitbtn"><a href="#" id="logout_b" onclick="doLogout($('logout_b'));return false;">Выход</a></span>
	</div>
		<div id="footer"> 
	    	© 2013 "THE LORDS"
	    </div>
</body>