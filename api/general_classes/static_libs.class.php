<?php
class StaticLibs {
    public static function getCommonGameConfig() {
        return Array(
            Array('name'=>'games_features'),
            Array('name'=>'procedures_params', 'type'=>'vars', 'field'=>'code'),
            Array('name'=>'procedures_params_i18n', 'js_name'=>'procedures_params_descriptions', 'keys'=>'language_id,param_id'),
            Array('name'=>'unit_features'),
            Array('name'=>'building_features'),
            Array('name'=>'error_dictionary'),
            Array('name'=>'error_dictionary_i18n', 'js_name'=>'error_dictionary_messages', 'keys'=>'language_id,error_id'),
            Array('name'=>'dic_colors', 'keys'=>'code'),
            Array('name'=>'units_i18n', 'js_name'=>'unit_names', 'keys'=>'language_id,unit_id'),
            Array('name'=>'unit_features_i18n', 'js_name'=>'unit_feature_names', 'keys'=>'language_id,feature_id'),
            Array('name'=>'cards_i18n', 'js_name'=>'card_names', 'keys'=>'language_id,card_id'),
            Array('name'=>'buildings_i18n', 'js_name'=>'building_names', 'keys'=>'language_id,building_id'),
            Array('name'=>'buildings_features_i18n', 'js_name'=>'buildings_feature_names', 'keys'=>'language_id,feature_id'),
            Array('name'=>'npc_player_name_modificators_i18n', 'js_name'=>'npc_player_name_modificators', 'keys'=>'language_id,code'),
            Array('name'=>'videos_i18n', 'js_name'=>'videos_titles', 'keys'=>'language_id,code'),
            Array('name'=>'shooting_params', 'js_name'=>'shooting_params', 'keys'=>'unit_id,distance,aim_type'),
            Array('name'=>'statistics_i18n', 'js_name'=>'statistics_names', 'keys'=>'language_id,code'),
            Array('name'=>'log_message_text_i18n', 'js_name'=>'log_message_texts', 'keys'=>'language_id,code')
        );
    }
    public static function getModeGameConfig() {
        return Array(
            Array('name'=>'vw_mode_cards', 'js_name'=>'cards', 'numeric_keys'=>true),
            Array('name'=>'vw_mode_units', 'js_name'=>'units', 'numeric_keys'=>true),
            Array('name'=>'vw_mode_buildings', 'js_name'=>'buildings', 'numeric_keys'=>true),
            Array('name'=>'vw_mode_all_procedures', 'js_name'=>'procedures_mode_1', 'numeric_keys'=>true),
            Array('name'=>'vw_mode_cards_procedures', 'js_name'=>'cards_procedures_1', 'keys'=>'', 'numeric_keys'=>true),
            Array('name'=>'vw_mode_units_procedures','js_name'=>'units_procedures_1', 'keys'=>'', 'numeric_keys'=>true),
            Array('name'=>'vw_mode_buildings_procedures','js_name'=>'buildings_procedures_1', 'keys'=>'', 'numeric_keys'=>true),
            Array('name'=>'mode_config','js_name'=>'mode_config', 'type'=>'one_value', 'field'=>'value', 'keys'=>'param'),
            Array('name'=>'vw_mode_unit_default_features', 'js_name'=>'unit_features_usage', 'numeric_keys'=>true),
            Array('name'=>'vw_mode_building_default_features', 'js_name'=>'building_default_features', 'numeric_keys'=>true),
            Array('name'=>'vw_mode_unit_phrases', 'js_name'=>'dic_unit_phrases', 'numeric_keys'=>true),
            Array('name'=>'vw_mode_unit_level_up_experience', 'js_name'=>'units_levels', 'type'=>'one_value', 'field'=>'experience', 'keys'=>'unit_id,level', 'numeric_keys'=>true)
        );
    }
    // $config
    //
    // 'keys' control hierarchical structure of the js array.
	// For example, 'keys'=>'language_id,code' means that
	// first index of js array should be language_id, second - code,
	// and then all other fields:
	// log_message_texts[1]['resurrect']['message'] = '{player0} resurrects {unit1}'
	// if omitted, defaults to 'id'
	//
	// 'type':
	// 'array' - default 
	// 'vars'  - set of js variables, value for varible will be taken from field provided by 'field'
    // 'one_value' - instead of $row field/values array assign the value of one 'field'
    //
    // 'numeric_keys' - boolean
    public static function generate($database, $config, $where = '') {
        $js_string = $vars = '';
        $exports = [];
        foreach($config as $table)	{
            if (!array_key_exists('type', $table)) {
                $table['type'] = 'array';
            }
            if (!array_key_exists('numeric_keys', $table)) {
                $table['numeric_keys'] = false;
            }
            if (array_key_exists('keys', $table)) {
                $keys = $table['keys'];
            } else {
                $keys = 'id';
            }
            if (array_key_exists('js_name', $table)) {
                $js_name = $table['js_name'];
            } else {
                $js_name = $table['name'];
            }
            $exports[] = $js_name;
            
            $res = $database->select('*', $table['name'], $where, $keys);
            if ($res) {
                $key_column_names = explode(',', $keys);
                $previous_keys = array_fill(0, sizeof($key_column_names), '');
                
                $js_string .= PHP_EOL.'var '.$js_name.' = new Array();'.PHP_EOL;
                $artificial_id = 1;
                while ($row = mysqli_fetch_assoc($res)) {
                    $current_keys = Array();
                    if (!isset($row['id']) && $keys == '') {
                        $row['id'] = $artificial_id;
                        $key_column_names = ['id'];
                    }
                    $key_value_differs = FALSE;
                    foreach($key_column_names as $i=>$key_col) {
                        array_push($current_keys, $row[$key_col]);
                        if (($row[$key_col] != $previous_keys[$i]) || $key_value_differs) {
                            $key_value_differs = TRUE;
                            if ($table['numeric_keys']) {
                                $keys_js_string = '['.implode('][', $current_keys).']';
                            } else {
                                $keys_js_string = '["'.implode('"]["', $current_keys).'"]';
                            }
                            
                            if ($table['type'] == 'one_value' && $i == count($key_column_names) - 1) {
                                $js_string .= $js_name.$keys_js_string.' = '.$row[$table['field']].';'.PHP_EOL;
                            } else {
                                $js_string .= $js_name.$keys_js_string.' = new Array();'.PHP_EOL;
                            }
                        }
                    }
                    
                    if ($table['type'] != 'one_value') {
                        foreach($row as $field=>$value) {
                            $js_string .= $js_name.$keys_js_string.'["'.$field.'"] = "'.str_replace('"',"'",$value).'";'.PHP_EOL;
                            
                            if ($table['type'] == 'vars' && $field == $table['field']) {
                                $vars .= 'var '.$value.'="";'.PHP_EOL;
                            }
                        }
                    }
                    $previous_keys = $current_keys;
                    $artificial_id++;
                }
            }
        }
        $exports_str = PHP_EOL."export {".PHP_EOL.implode(",".PHP_EOL, $exports).PHP_EOL."}";
        return $js_string.$vars.$exports_str;
    }

    public static function generateArray($database, $config, $where = '') {
        $static_info = [];
        foreach($config as $table)	{
            $res = $database->select('*', $table['name'], $where);
            if ($res) {
                while ($row = mysqli_fetch_assoc($res)) {
                    $static_info[$table['name']][] = $row;
                }
            }
        }
        return $static_info;
    }

    public static function generateI18n($langFilePath, $langId) {
        $js_string = "i18n[$langId] = new Array();".PHP_EOL;
        $config = parse_ini_file($langFilePath, true);
        foreach($config as $key => $value) {
            if (is_array($value)) {
                $js_string .= "i18n[$langId]['$key'] = new Array();".PHP_EOL;
                foreach($value as $k => $v) {
                    $v = addslashes($v);
                    $js_string .= "i18n[$langId]['$key']['$k'] = '$v';".PHP_EOL;
                }
            } else {
                $value = addslashes($value);
                $js_string .= "i18n[$langId]['$key'] = '$value';".PHP_EOL;
            }
        }
        return $js_string;
    }
}
