<?php
	/*
		For testing purposes.
	*/
	//Initialization part
	session_start();
	include ('../general_config/config.php');
	include ('../general_classes/sql.class.php');
	$mysqli = new mysqli($DB_conf['server'], 'root', 'mypass');
	if (mysqli_connect_errno()) {
		    printf("Connect failed: %s\n", mysqli_connect_error());
		    die();
	}
	$dataBase = new cDataBase($mysqli);
	$dataBase->query("SET NAMES utf8");
	
	$message = $games = '';
	if ($_POST['call_reset'])	{
		$query = 'call '.$DB_conf['name'].'.reset();';
		$res = $dataBase->multi_query($query);
		$message = 'Lords game info should be reseted =)';
	}
	if ($_POST['call_site_reset'])	{
		$query = 'call '.$DB_conf['site'].'.reset();';
		$res = $dataBase->multi_query($query);
		$message = 'Доигровая очищена =)';
	}
	if ($_POST['delete_game'])	{
		$query = 'call '.$DB_conf['name'].'.delete_game_data('.$_POST['game_id'].');';
		$res = $dataBase->multi_query($query);
		$message = 'Игра id='.$_POST['game_id'].' удалена.';
	}
	$res = $dataBase->select('*',$DB_conf['name'].'.games');
	if ($res)
	while ($game = mysqli_fetch_assoc($res))	{
		$games .= '<li> ['.$game['id'].'] <b>Название:</b>'.$game['title'].'| <b>статус:</b>'.$game['status_id'].'<br />';
		$games .= ' <form action="" method="post">
    <input type="hidden" name="game_id" value="'.$game['id'].'">
    <input type="submit" name="delete_game" value="Жахнуть все в игре '.$game['title'].' ;)">
 </form>';
	}
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
	<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
	<link id="site_icon" rel="icon" href="../design/images/icon_lords.ico" type="image/x-icon" />
	<title>Опасные штуки</title>
	<script type="text/javascript" src="../general_js/mootools.js"></script>
	<script type="text/javascript" src="../general_js/mootools-more.js"></script>
	<style>
		a{text-decoration:none; color:#ccc;border-left:3px solid #cbb06e;padding-left:5px;outline:none;}
		a:hover{color:white;border-left:3px solid white;}
		body {background-color:#312a1a;color:white;}
		h1{color:white;}
	</style>
</head>
<body>
		<a href="index.html"> Назад в меню </a><br />
<p style="color:red"><?php echo $message; ?></p>
	Games:
	<ul>
		<?php echo $games; ?>
	</ul>
 <form action="" method="post">
    <input type="submit" name="call_reset" value="Жахнуть все игры нафиг ;)">
    <input type="submit" name="call_site_reset" value="Жахнуть все в доигровой нафиг ;)">
 </form>
</body>
</html>
