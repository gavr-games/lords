<?php
class GameInfo {
    public static function getGameConfig() {
        return Array(
            Array(
                'name' =>'game_info',
            ),
            Array(
                'name' =>'init_board_buildings',
            ),
            Array(
                'name' =>'init_board_units',
            ),
            Array(
                'name'=>'active_players',
            ),
            Array(
                'name'=>'players',
            ),
            Array(
                'name'=>'board_buildings',
            ),
            Array(
                'name' =>'board_buildings_features',
            ),
            Array(
                'name'=>'board_units',
            ),
            Array(
                'name' =>'board_units_features',
            ),
            Array(
                'name' =>'vwGrave',
            ),
            Array(
                'name'=>'player_deck',
            ),
            Array(
                'name'=>'vw_command_log',
            )
        );
    }
    
    public static function generateJS($tables, $game_id, $player_num) {
        global $dataBase, $DB_conf, $mysqli, $SITE_conf;

        $js_arrays = '';
        $players_list = '<hr /><table><tr><th>Игрок:</th><th>Команда:</th></tr>';
        Logger::info('GameInfo JS class query -> '.'call '.$DB_conf['name'].'.get_all_game_info('.$game_id.','.$player_num.');');
        $query = 'call '.$DB_conf['name'].'.get_all_game_info('.$game_id.','.$player_num.');';
        $res = $dataBase->multi_query($query);
        foreach($tables as $table) {
                $result = $mysqli->store_result();
                $idd = 0;
                $js_arrays .= 'window.'.$table['name'].' = new Array();';
                while ($row = mysqli_fetch_assoc($result))	{
                switch ($table['name'])	{
                    case 'game_info':
                        foreach($row as $field=>$value)	{
                            $js_arrays .= $table['name'].'["'.$field.'"] = "'.$value.'";';
                        }
                        $js_arrays .= $table['name'].'["game_id"] = '.$game_id.';';
                    break;
                    default:
                    if ($row['id']=='') $row['id'] = $idd;
                    if ($table['name']=='vwGrave') $row['id'] = $row['grave_id'];
                    if ($table['name']=='players') {
                        $js_arrays .= $table['name'].'['.$row['player_num'].'] = new Array();';
                    }
                        else
                        $js_arrays .= $table['name'].'['.$row['id'].'] = new Array();';
                    foreach($row as $field=>$value)	{
                        //if ($table['name']=='active_players' && $field=='last_end_turn') $value = strtotime($value);
                        if ($table['name']=='vw_command_log' || $table['name']=='vw_command_chat') $js_arrays .= $table['name'].'['.$row['id'].']["'.$field.'"] = \''.addslashes($value).'\';'; 
                            else
                        if ($table['name']=='players') {
                                $js_arrays .= $table['name'].'['.$row['player_num'].']["'.$field.'"] = "'.$value.'";';
                                if ($field=='name' && $row['player_num']<4) $players_list .= '<tr><td>'.$row['name'].'</td><td>'.$row['team'].'</td></tr>';
                            }
                            else
                        $js_arrays .= $table['name'].'['.$row['id'].']["'.$field.'"] = "'.$value.'";';
                    }
                    break;
                }
                $idd++;
                }
                $result->free();
                $mysqli->next_result();
        }
        $players_list .= '</table><hr />';
        $markers['###GAME_INFO###'] .= $players_list;
        
        $js_arrays .= 'my_player_num = "'.$player_num.'";';
        $js_arrays .= 'server_time = '.time().';';
        $js_arrays .= 'site_domen = "'.$SITE_conf['domen'].'";';
        return $js_arrays;
    }

    public static function generateArray($tables, $game_id, $player_num) {
        global $dataBase, $DB_conf, $mysqli, $SITE_conf;

        $info = [];
        Logger::info('GameInfo Array class query -> '.'call '.$DB_conf['name'].'.get_all_game_info('.$game_id.','.$player_num.');');
        $query = 'call '.$DB_conf['name'].'.get_all_game_info('.$game_id.','.$player_num.');';
        $res = $dataBase->multi_query($query);
        foreach($tables as $table) {
                $result = $mysqli->store_result();
                while ($row = mysqli_fetch_assoc($result))	{
                    $info[$table['name']][] = $row;
                }
                $result->free();
                $mysqli->next_result();
        }
        return $info;
    }
}
