<?php
	include ('../general_config/config.php');
	include ('../general_classes/sql.class.php');
	include ('../general_classes/static_libs.class.php');
	
	error_reporting(E_ALL);
	$mysqli = new mysqli($DB_conf['server'], 'lords_reader', $_ENV['MYSQL_READER_PASSWORD'], $DB_conf['name']);
	if (mysqli_connect_errno()) {
		    printf("Connect failed: %s\n", mysqli_connect_error());
		    die();
	}
	$dataBase = new cDataBase($mysqli);
	$dataBase->query("SET NAMES utf8");
	
  $mode_id = 9;

  $tables = StaticLibs::getCommonGameConfig();
  $static_info = StaticLibs::generateArray($dataBase, $tables);

  $mode_tables = StaticLibs::getModeGameConfig();
  $mode_static_info = StaticLibs::generateArray($dataBase, $mode_tables, 'mode_id='.$mode_id);
	
  $cards_list = $mode_static_info["vw_mode_cards"];

  function cardTypeName($type) {
    switch($type) {
      case "b": 
        return "Здание";
        break;
      case "u": 
        return "Юнит";
        break;
      case "m": 
        return "Магия";
        break;
    }
  }

  function cardInfo($id) {
    global $static_info;
    foreach($static_info["cards_i18n"] as $card) {
      if ($card["card_id"] == $id && $card["language_id"] == 2) {
        return $card;
      }
    }
  }

  function buildingInfo($id) {
    global $static_info;
    foreach($static_info["buildings_i18n"] as $b) {
      if ($b["building_id"] == $id && $b["language_id"] == 2) {
        return $b;
      }
    }
  }

  function unitInfo($id) {
    global $static_info;
    foreach($static_info["units_i18n"] as $u) {
      if ($u["unit_id"] == $id && $u["language_id"] == 2) {
        return $u;
      }
    }
  }

  function cardDescription($card_info, $card) {
    switch($card['type']) {
      case "b": 
        $building_info = buildingInfo($card['ref']);
        return $building_info['description'];
        break;
      case "u": 
        $unit_info = unitInfo($card['ref']);
        return $unit_info['description'];
        break;
      case "m": 
        return $card_info["description"];
        break;
    }
  }
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
	<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
	<link id="site_icon" rel="icon" href="../design/images/icon_lords.ico" type="image/x-icon" />
	<title>Карты</title>
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
    td{color:white;border-right: 1px solid white;padding-right:10px;padding-left:10px;}
	</style>
</head>
<body>
  <h1>Список карт</h1>
  <a href="index.html"> Назад в меню </a>
	<div id="cards">
  <table>
    <? foreach($cards_list as $card) { 
      $card_info = cardInfo($card["id"])
      ?>
      
        <tr>
          <td><?= $card["id"] ?></td>
          <td>
            <img src="<?= '../design/images/cards/'.$card['image'] ?>">
          </td>
          <td><?= cardTypeName($card['type']) ?></td>
          <td><?= $card_info["name"] ?></td>
          <td><?= cardDescription($card_info, $card) ?></td>
        </tr>
    <? } ?>
    </table>
	</div>
</body>
</html>