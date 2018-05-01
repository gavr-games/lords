<?php
class StaticLibs {
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
        return $js_string.$vars;
    }

    public static function generateI18n($langFilePath, $langId) {
        $js_string = "i18n[$langId] = new Array();".PHP_EOL;
        $config = parse_ini_file($langFilePath, true);
        foreach($config as $key => $value) {
            if (is_array($value)) {
                $js_string .= "i18n[$langId]['$key'] = new Array();".PHP_EOL;
                foreach($value as $k => $v) {
                    $js_string .= "i18n[$langId]['$key']['$k'] = '$v';".PHP_EOL;
                }
            } else {
                $js_string .= "i18n[$langId]['$key'] = '$value';".PHP_EOL;
            }
        }
        return $js_string;
    }
}
