<?php
include_once('init.php');
set_time_limit(0);

$game_id    = (int) $_GET['game_id'];
$player_num = (int) $_GET['player_num'];

if ($game_id > 0 && $player_num >= 0) {
    $query = 'call ' . $DB_conf['name'] . '.player_end_turn_by_timeout(' . $game_id . ',' . $player_num . ');';
    $res   = $dataBase->query($query);
    $rows  = array();
    while ($row = mysqli_fetch_assoc($res)) {
        $row['command'] = str_replace("'", "\u0027", $row['command']);
        $rows[]         = $row;
    }
    
    //check for errors in query
    $error = mysqli_error($dataBase->dbLink);
    if ($error != '') {
        echo $query;
        die(json_encode(array(
            'header_result' => array(
                'success' => 0,
                'error_code' => 1002, //mysql error
                'error_params' => str_replace("'", "\u0027", $error)
            )
        )));
    }
    
    //in case of game logic error
    if (count($rows) == 1 && $rows[0]['answer'] != '')
        die(json_encode(array(
            'header_result' => array(
                'success' => 0,
                'error_code' => 1005, //game error
                'error_params' => str_replace("'", "\u0027", $rows[0]['answer'])
            )
        )));
    
    //send commands when ok
    die(json_encode(array(
        'header_result' => array(
            'success' => 1,
            'error_code' => 0,
            'error_params' => ''
        ),
        'data_result' => $rows
    )));
} else
    die(json_encode(array(
        'header_result' => array(
            'success' => 0,
            'error_code' => 1003, //not authorized
            'error_params' => 'Not authorized - please refresh browser'
        )
    )));
?>