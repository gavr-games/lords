<?php
include_once('init.php');
set_time_limit(0);

$inputJSON = file_get_contents('php://input');
$input     = json_decode($inputJSON, TRUE);

if ($input['game_id'] != '' && $input['name'] != '') {
    $query = 'call ' . $DB_conf['site'] . '.performance_statistics_add("' . $input['name'] . '",' . round($input['js_time'], 3) . ',' . round($input['ape_time'], 3) . ',' . round($input['php_time'], 3) . ',' . $input['game_id'] . ');';
    Logger::info('save performance query -> '.$query);
    $res   = $dataBase->query($query);
}
?>