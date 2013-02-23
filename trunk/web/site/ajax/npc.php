<?php 
$start_time = microtime(true);
set_time_limit(0);

//init classes and db connection
	include_once('../../general_config/config.php');
	include_once('../../general_classes/sql.class.php');
	$mysqli = new mysqli($DB_conf['server'], $DB_conf['user'], $DB_conf['pass']);
	if (mysqli_connect_errno()) {
		    printf("Connect failed: %s\n", mysqli_connect_error());
		    die();
	}
	
	$dataBase = new cDataBase($mysqli);
	$dataBase->query("SET NAMES 'UTF8'");
	
$client = new SoapClient($SITE_conf['ai_service']);

$game_commands = Array();
$error = true;
$error_com_num = 0;

//repeat until all commands from ai successful or there is error on the first move
while($error && $error_com_num!=1 /*&& $error_com_num!=0*/) {
$error = false;
$error_com_num = 0;

  $ai_commands = json_decode($client->makeMove((int)$_POST['g_id'],(int)$_POST['p_num']));
  foreach($ai_commands as $procedure) {
    $error_com_num++;
    $query = 'call '.$DB_conf['name'].'.'.$procedure;
			  //print_r($query);
		$result = $dataBase->multi_query($query);
		do {
		  /* store first result set */
		  if ($result = $mysqli->store_result()) {
		      while ($row = $result->fetch_assoc()) {
		      //print_r($row);
			if (!isset($row['error_code'])){ 
			  $row['command'] = str_replace("'","\u0027",$row['command']);
			  $game_commands[] = $row;
			} else {//in case of game logic error
			  //do some error logging
			  $error = true;
			  break 3;
			}
		      }
		      $result->free();
		      $i++;
		  }
		  /* print divider */
		  if ($mysqli->more_results()) {
		  }
		} while ($mysqli->next_result());
		
		//check for errors in query
		$error_msg = mysqli_error($dataBase->dbLink);
		if ($error_msg!='') {
		  //do some error logging
		  //print_r($error_msg);
		  $error = true;
		  break;
		}
  }
  //send end turn if ai's first command has error
  if (($error && $error_com_num==1) /*|| $error_com_num==0*/){
    $query = 'call '.$DB_conf['name'].'.player_end_turn('.$_POST['g_id'].','.$_POST['p_num'].');';
			  //print_r($query);
		$result = $dataBase->multi_query($query);
		do {
		  /* store first result set */
		  if ($result = $mysqli->store_result()) {
		      while ($row = $result->fetch_assoc()) {
			if (!isset($row['error_code'])){
			  $row['command'] = str_replace("'","\u0027",$row['command']);
			  $game_commands[] = $row;
			} else {//in case of game logic error
			  //do some error logging
			}
		      }
		      $result->free();
		      $i++;
		  }
		  /* print divider */
		  if ($mysqli->more_results()) {
		  }
		} while ($mysqli->next_result());
		
		//check for errors in query
		$error_msg = mysqli_error($dataBase->dbLink);
		if ($error_msg!='') {
		  //do some error logging
		}
  }
//end while
}
		//send commands
		die( 
		  json_encode(
		    array(
		      'header_result'=>array(
			'success'=>1,
			'error_code'=>0,
			'error_params'=>''
		      ),
		      'data_result'=>$game_commands,
		      'phptime'=>(microtime(true)-$start_time)
		    )
		  )
		);
?>