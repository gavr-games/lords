<?php
$start_time = microtime(true);
include_once('init.php');
set_time_limit(0);

$inputJSON   = file_get_contents('php://input');
$input       = json_decode($inputJSON, TRUE);
$proc_name   = $input['proc_name'];
$proc_params = $input['proc_params'];

if ($_SESSION['game_id'] != '' && $_SESSION['player_num'] != '' && $proc_name != '') {
    $query = 'call ' . $DB_conf['name'] . '.' . $proc_name . '(' . $_SESSION['game_id'] . ',' . $_SESSION['player_num'];
    if ($proc_params != '') {
        $proc_params = rawurldecode($proc_params);
        $proc_params = strip_tags($proc_params);
        $proc_params = str_replace(array(
            chr(10),
            chr(13),
            "'"
        ), array(
            '',
            '',
            "\\'"
        ), $proc_params);
        $query .= proc_params;
    }
    $query .= ');';
    $res  = $dataBase->query($query);
    $rows = array();
    while ($row = mysqli_fetch_assoc($res)) {
        $row['command'] = str_replace("'", "\u0027", $row['command']);
        $rows[]         = $row;
    }
    
    //check for errors in query
    $error = mysqli_error($dataBase->dbLink);
    if ($error != '')
        die(json_encode(array(
            'header_result' => array(
                'success' => "0",
                'error_code' => 1002, //mysql error
                'error_params' => str_replace("'", "\u0027", $error)
            )
        )));
    
    //in case of game logic error
    if (count($rows) == 1 && isset($rows[0]['error_code']))
        die(json_encode(array(
            'header_result' => array(
                'success' => "0",
                'error_code' => $rows[0]['error_code'], //game error
                'error_params' => str_replace("'", "\u0027", $rows[0]['error_params'])
            )
        )));
    
    //send commands when ok
    die(json_encode(array(
        'header_result' => array(
            'success' => "1",
            'error_code' => 0,
            'error_params' => ''
        ),
        'data_result' => $rows,
        'phptime' => (microtime(true) - $start_time)
    )));
} else
    die(json_encode(array(
        'header_result' => array(
            'success' => "0",
            'error_code' => 1003, //not authorized
            'error_params' => 'Not authorized - please refresh browser'
        )
    )));
?>