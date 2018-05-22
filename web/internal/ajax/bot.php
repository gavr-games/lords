<?php
$start_time = microtime(true);
include_once('../../general_config/config.php');
include_once('../../general_classes/sql.class.php');
$mysqli = new mysqli($DB_conf['server'], $DB_conf['user'], $DB_conf['pass']);
if (mysqli_connect_errno()) {
    printf("Connect failed: %s\n", mysqli_connect_error());
    die();
}
$dataBase = new cDataBase($mysqli);
$dataBase->query("SET NAMES 'UTF8'");

$inputJSON = file_get_contents('php://input');
$input = json_decode($inputJSON, TRUE);
$cmd = $input['cmd'];

$query = 'call ' . $DB_conf['name'] . '.' . $cmd;
Logger::info('bot exec query -> ' . $query);

$result = $dataBase->multi_query($query);
do {
    /* store first result set */
    if ($result = $mysqli->store_result()) {
        while ($row = $result->fetch_assoc()) {
            Logger::info('bot exec query row -> ' . json_encode($row));
            if (!isset($row['error_code'])) {
                $row['command'] = str_replace("'", "\u0027", $row['command']);
                $game_commands[] = $row;
            } else { //in case of game logic error
                Logger::info('bot row returned error');
                $error = true;
            }
        }
        $result->free();
        $i++;
    }
    /* print divider */
    if ($mysqli->more_results()) {
    }
} while ($mysqli->more_results() && $mysqli->next_result());


//check for errors in query
$error_msg = mysqli_error($dataBase->dbLink);
if ($error_msg != '') {
    Logger::error("bot query error $error_msg");
    //send error
    die(json_encode(array(
        'header_result' => array(
            'success' => "0",
            'error_code' => 1002,
            'error_params' => $error_msg
        )
    )));
}

//send commands
die(json_encode(array(
    'header_result' => array(
        'success' => "1",
        'error_code' => 0,
        'error_params' => ''
    ),
    'data_result' => $game_commands,
    'phptime' => (microtime(true) - $start_time)
)));