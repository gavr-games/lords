var game_state = 'WAITTING';
var executable_procedure = '';
var executable_params = '';
var selected_params = 0;
var pre_defined_param = '';
var do_not_in_turn = 0;
var error_msg = '';
var error_procedure = '';
var no_new_execute = false;
var player_deck_id = 0;

var last_executed_procedure = '';
var start_proc_time = 0;
var need_answer = false;

var proc_uid = 0; //need to mark answer
//ask params
function execute_procedure(name) {
    try {
        if (!no_new_execute) if (turn_state == MY_TURN || do_not_in_turn == 1) {
            if (procedures_names[name]) {
                var exec_procedure = procedures_names[name];
                last_executed_procedure = name;
                if (exec_procedure['params'] == "") { //send procedure without params
                    executable_procedure = name;
                    if (eval("typeof pre_" + name + " == 'function'")) eval('pre_' + name + '();'); //call pre-function if it exists
		            executable_params = '';
                    send_procedure(name, '');
                    return 1;
                } else { //begin of proccess
                    //first call of procedure
                    if (game_state == 'WAITTING') {
                        executable_procedure = name;
                        selected_params = 0;
                        if (eval("typeof pre_" + name + " == 'function'")) eval('pre_' + name + '();'); //call prefunction if it exists
                    }
                    var params_arr = exec_procedure['params'].toString().split(','); //get params array
                    //look if param is predefined
                    if (params_arr[selected_params]) if (params_arr[selected_params].toString() == pre_defined_param) {
                        selected_params++;
                        pre_defined_param = '';
                        if (eval("typeof on_" + params_arr[selected_params - 1] + "_select == 'function'")) eval('on_' + params_arr[selected_params - 1] + '_select();'); //call on_param_select function if exists
                    }
                    //card is predefined param
                    if (params_arr[selected_params]) if (params_arr[selected_params].toString() == 'card') {
                        selected_params++;
                        if (eval("typeof on_" + params_arr[selected_params - 1] + "_select == 'function'")) eval('on_' + params_arr[selected_params - 1] + '_select();'); //call on_param_select function if exists
                    }
                    //rotation is predefined param
                    if (params_arr[selected_params]) if (params_arr[selected_params].toString() == 'rotation') {
                        selected_params++;
                        if (eval("typeof on_" + params_arr[selected_params - 1] + "_select == 'function'")) eval('on_' + params_arr[selected_params - 1] + '_select();'); //call on_param_select function if exists
                    }
                    //flip is predefined param
                    if (params_arr[selected_params]) if (params_arr[selected_params].toString() == 'flip') {
                        selected_params++;
                        if (eval("typeof on_" + params_arr[selected_params - 1] + "_select == 'function'")) eval('on_' + params_arr[selected_params - 1] + '_select();'); //call on_param_select function if exists
                    }
                    //send if ready
                    if (params_arr.length == selected_params) {
                        var params_str = "";
                        params_arr.each(function (item, index) {
			                if (item == 'card') item = 'player_deck_id';
                            if (item) eval('params_str+=","+' + item + ';');
                        });
			            executable_params = params_str;
                        send_procedure(name, params_str);
                        game_state = 'WAITTING';
                    } else {
                        //ask more parametrs
                        game_state = 'SELECTING_' + params_arr[selected_params].toString().toUpperCase();
                        eval(params_arr[selected_params] + '="";');
                        $('tip').set('text', procedures_params_codes[params_arr[selected_params]]['description']);
                    }
                } // end of process
            } else showWindow(i18n[USER_LANGUAGE]['game']['sorry'], i18n[USER_LANGUAGE]['game']['wrong_action'] + ': ' + name, 200, 40, false);
        } else showWindow(i18n[USER_LANGUAGE]['game']['sorry'], error_message("1"), 200, 20, false); // Not your turn
    } catch (e) {
        if (DEBUG_MODE) {
            displayLordsError(e, 'execute_procedure(' + name + ');selected_params=' + selected_params + ';');
        }
    }
}

//send name and proc params to server
function send_procedure(name, params) {
    need_answer = true;
    pre_send_procedure();
    proc_uid = $time();
    start_proc_time = proc_uid;
    parent.WSClient.sendGameProtocolCmd({
        proc_name: name,
        proc_params: params,
        'proc_uid': proc_uid
    });
}

function proc_answer(pr_uid, suc, error_code, error_params, ape_time, php_time) {
    ape_time = ape_time || 0;
    php_time = php_time || 0;
    if (pr_uid == proc_uid) {
        proc_uid = 0;
	    var temp_name = executable_procedure;
	    var temp_params = executable_params;
        if (suc == 0) {
	        if ($chk(error_dictionary[error_code])) {
	            error_txt = error_message(error_code);
	            showWindow(i18n[USER_LANGUAGE]['game']['sorry'], error_txt, 200, 100, false);
                error_msg = error_txt;
                error_procedure = executable_procedure;
	        } else {
	            parent.showError(error_code,error_params);
                //error_txt = decodeURIComponent(error_txt);
            }
        } else {
            error_msg = '';
            error_procedure = '';
            start_proc_time = $time()-start_proc_time;
            parent.WSClient.sendPerformance({
                'name':executable_procedure,
                'js_time':start_proc_time/1000,
                'ape_time':ape_time/1000,
                'php_time':php_time
            });
            if (playingCard) {
                deactivate_buy_ressurect_play_card();
            }
        }

        try {
            playingCard = false;
            cancel_execute();
            post_send_procedure();
        } catch (e) {
            if (DEBUG_MODE) {
                displayLordsError(e, 'send_procedure(' + temp_name + ',' + temp_params + ');');
            }
        }
    }
}

function send_multiple_actions(params) {
    no_backlight = true;
    pre_send_procedure();
    
    need_answer = true;
    proc_uid = $time();
    start_proc_time = proc_uid;
    
    parent.WSClient.sendGameProtocolCmd({
	    proc_name: 'multi',
	    proc_params: params,
	    'proc_uid': proc_uid
    });
}

//function selects the parametr for executable procedure
function param_clicked(element) {
    var el_class = element.get('class').toString().split(' ');
    el_class = el_class[0].toString();
    if (game_state == 'SELECTING_' + el_class.toUpperCase()) {
        eval(el_class + '=' + element.get('id').toString().replace(el_class, "") + ';');
        game_state = 'SELECTED_' + el_class.toUpperCase();
        selected_params++;
        if (eval("typeof on_" + el_class + "_select == 'function'")) eval('on_' + el_class + '_select();'); //call on_param_select function if exists
        execute_procedure(executable_procedure);
    }
}
//function when user clicks on board
function board_clicked(x, y) {
    try {
        var id;
        var p_num;
        var ux;
        var uy;
        var size;
        var i;
        var do_Attack;
        var newx;
        var newy;
        if (game_state == 'SELECTING_ANY_COORD') {
            game_state = 'SELECTED_ANY_COORD';
            selected_params++;
            any_coord = x.toString() + ',' + y.toString();
            if (eval("typeof on_any_coord_select == 'function'")) eval('on_any_coord_select();'); //call on_param_select function if exists
            execute_procedure(executable_procedure);
        } else if (executable_procedure == 'put_building' && game_state == 'SELECTING_EMPTY_COORD_MY_ZONE') {
            game_state = 'SELECTED_EMPTY_COORD_MY_ZONE';
            selected_params++;
            empty_coord_my_zone = x.toString() + ',' + y.toString();
            if (eval("typeof on_empty_coord_my_zone_select == 'function'")) eval('on_empty_coord_my_zone_select();'); //call on_param_select function if exists
            execute_procedure(executable_procedure);
            clean_building(x, y);
        } else if (game_state == 'SELECTING_EMPTY_COORD_MY_ZONE') {
            game_state = 'SELECTED_EMPTY_COORD_MY_ZONE';
            selected_params++;
            empty_coord_my_zone = x.toString() + ',' + y.toString();
            if (eval("typeof on_empty_coord_my_zone_select == 'function'")) eval('on_empty_coord_my_zone_select();'); //call on_param_select function if exists
            execute_procedure(executable_procedure);
            clean_empty_coord_my_zone(x, y);
        } else if (game_state == 'SELECTING_UNIT') {
            if (board[x] && board[x][y]) if (board[x][y]['type'] == 'unit') {
                game_state = 'SELECTED_UNIT';
                selected_params++;
                unit = x.toString() + ',' + y.toString();
                if (eval("typeof on_unit_select == 'function'")) eval('on_unit_select();'); //call on_param_select function if exists
                $('board_' + x + '_' + y).removeClass('attackUnit');
                execute_procedure(executable_procedure);
            }
        } else if (game_state == 'SELECTING_TARGET_UNIT') {
            if (board[x] && board[x][y]) if (board[x][y]['type'] == 'unit') {
                game_state = 'SELECTED_TARGET_UNIT';
                selected_params++;
                target_unit = x.toString() + ',' + y.toString();
                if (eval("typeof on_target_unit_select == 'function'")) eval('on_target_unit_select();'); //call on_param_select function if exists
                $('board_' + x + '_' + y).removeClass('attackUnit');
                execute_procedure(executable_procedure);
            }
        } else if (game_state == 'SELECTING_SHOOT_TARGET') {
            if (board[x] && board[x][y] && (board[x][y]['type'] in current_shoot_aim_types)) {
                game_state = 'SELECTED_SHOOT_TARGET';
                selected_params++;
                shoot_target = x.toString() + ',' + y.toString();
                if (eval("typeof on_shoot_target_select == 'function'")) eval('on_shoot_target_select();'); //call on_param_select function if exists
                $('board_' + x + '_' + y).removeClass('attackUnit');
                execute_procedure(executable_procedure);
            }
        } else if (game_state == 'SELECTING_MY_UNIT') {
            if (board[x] && board[x][y]) if (board[x][y]['type'] == 'unit' && board_units[board[x][y]['ref']]['player_num'].toInt()==my_player_num) {
                game_state = 'SELECTED_MY_UNIT';
                selected_params++;
                my_unit = x.toString() + ',' + y.toString();
                if (eval("typeof on_my_unit_select == 'function'")) eval('on_my_unit_select();'); //call on_param_select function if exists
                $('board_' + x + '_' + y).removeClass('attackUnit');
                execute_procedure(executable_procedure);
            }
        } else if (game_state == 'SELECTING_PLAYER') {
            if (board[x] && board[x][y]) if (board[x][y]['ref']) {
                id = board[x][y]['ref'];
                if (board[x][y]["type"] == "unit") p_num = board_units[id]['player_num'];
                else p_num = board_buildings[id]['player_num'];
                game_state = 'SELECTED_PLAYER';
                selected_params++;
                player = p_num;
                if (eval("typeof on_player_select == 'function'")) eval('on_player_select();'); //call on_param_select function if exists
                execute_procedure(executable_procedure);
            }
        } else if (game_state == 'SELECTING_EMPTY_COORD') {
            $('overboard').removeClass('cursor_move');
            $('overboard_' + x + '_' + y).removeClass('cursor_move');
            $('overboard').removeClass('cursor_attack');
            $('overboard_' + x + '_' + y).removeClass('cursor_attack');
            if (executable_procedure == 'player_move_unit') {
                var coords = unit.toString().split(',');
                ux = coords[0].toInt();
                uy = coords[1].toInt();
                id = board[ux][uy]["ref"];
                var save_id = id;
                size = units[board_units[id]["unit_id"]]['size'].toInt();
                if (size > 1) {
                    //get left up corner
                    board.each(function (items, index) {
                        if (items) items.each(function (item, index) {
                            if (item) if (item["ref"] == id && item["type"] == "unit") {
                                if (item["x"].toInt() < ux) ux = item["x"].toInt();
                                if (item["y"].toInt() < uy) uy = item["y"].toInt();
                            }
                        });
                    });
                    unit = ux + ',' + uy;
                }
                if (path_mode) { //make several actions
                    if (x_path[0] == -1 || y_path[0] == -1) return 1;
                    var path_params = '';
                    i = 0;
                    var oldx = ux;
                    var oldy = uy;
                    while (x_path[i] != -1 && y_path[i] != -1 && board_units[id]["moves_left"].toInt() != i) {
                        if ($chk(board[x_path[i]]) && $chk(board[x_path[i]][y_path[i]]) && $chk(board[x_path[i]][y_path[i]]['ref'])) {
                            if (board[x_path[i]][y_path[i]]['type'] == 'unit' && board[x_path[i]][y_path[i]]['ref'] == id) path_params += 'player_move_unit|' + oldx + ',' + oldy + ',' + x_path[i] + ',' + y_path[i] + ';';
                            else path_params += 'attack|' + oldx + ',' + oldy + ',' + x_path[i] + ',' + y_path[i] + ';';
                        } else if (size > 1 && path_actions[i] == 'a') {
                            path_params += 'attack|' + oldx + ',' + oldy + ',' + x_path[i] + ',' + y_path[i] + ';';
                        } else path_params += 'player_move_unit|' + oldx + ',' + oldy + ',' + x_path[i] + ',' + y_path[i] + ';';
                        oldx = x_path[i];
                        oldy = y_path[i];
                        i++;
                        path_moves = i;
                    }
                    clean_unit(x, y);
                    cancel_execute();
                    path_params += '';
                    multiple_action_unit_id = save_id;
                    send_multiple_actions(path_params);
                    return 1;
                } else {
                    do_Attack = 0;
                    board.each(function (items, index) {
                        if (items) items.each(function (item, index) {
                            if (item) if ($('board_' + item['x'] + '_' + item['y'])) if ($('board_' + item['x'] + '_' + item['y']).hasClass('attackUnit')) do_Attack = 1;
                        });
                    });
                    if (do_Attack == 1) {
                        executable_procedure = 'attack';
                        game_state = 'SELECTED_ATTACK_COORD';
                        selected_params++;
                        newx = x;
                        newy = y;
                        if (size > 1 && !$chk(board_units[id]["knight"])) {
                            if (x < ux) newx = x;
                            else if (x > (ux + size - 1)) newx = x - size + 1;
                            else newx = ux;
                            if (y < uy) newy = y;
                            else if (y > (uy + size - 1)) newy = y - size + 1;
                            else newy = uy;
                        }
                        attack_coord = newx.toString() + ',' + newy.toString();
                        if (eval("typeof on_attack_coord_select == 'function'")) eval('on_attack_coord_select();'); //call on_param_select function if exists
                        clean_attack();
                        execute_procedure(executable_procedure);
                        return 1;
                    } else if (!$('board_' + x + '_' + y).hasClass('green')) return 1;
                }
            }
            if (executable_procedure == 'cast_polza_move_building' || executable_procedure == 'cast_vred_move_building') {
                clean_building(x, y);
            }
            game_state = 'SELECTED_EMPTY_COORD';
            selected_params++;
            newx = x;
            newy = y;
            if (size > 1 && (x >= ux - 1 && x <= ux + size) && (y >= uy - 1 && y <= uy + size) && !$chk(board_units[id]["knight"])) {
                if (x < ux) newx = x;
                else if (x > (ux + size - 1)) newx = x - size + 1;
                else newx = ux;
                if (y < uy) newy = y;
                else if (y > (uy + size - 1)) newy = y - size + 1;
                else newy = uy;
            }
            empty_coord = newx.toString() + ',' + newy.toString();
            if (eval("typeof on_empty_coord_select == 'function'")) eval('on_empty_coord_select();'); //call on_param_select function if exists
            if (executable_procedure != 'cast_polza_move_building' && executable_procedure != 'cast_vred_move_building') clean_player_move_unit();
            execute_procedure(executable_procedure);
        } else if (game_state == 'SELECTING_ATTACK_COORD') {
            $('overboard').removeClass('cursor_attack');
            $('overboard_' + x + '_' + y).removeClass('cursor_attack');
            do_Attack = 0;
            board.each(function (items, index) {
                if (items) items.each(function (item, index) {
                    if (item) if ($('board_' + item['x'] + '_' + item['y'])) if ($('board_' + item['x'] + '_' + item['y']).hasClass('attackUnit')) do_Attack = 1;
                });
            });
            if (do_Attack == 1) {
                game_state = 'SELECTED_ATTACK_COORD';
                selected_params++;
                attack_coord = x.toString() + ',' + y.toString();
                if (eval("typeof on_attack_coord_select == 'function'")) eval('on_attack_coord_select();'); //call on_param_select function if exists
                clean_attack();
                execute_procedure(executable_procedure);
            }
        } else if (game_state == 'SELECTING_ZONE') {
            if (x < 10 && y < 10) zone = 0;
            else if (x >= 10 && y < 10) zone = 1;
            else if (x >= 10 && y >= 10) zone = 2;
            else zone = 3;
            clean_zone(x, y);
            game_state = 'SELECTED_ZONE';
            selected_params++;
            if (eval("typeof on_zone_select == 'function'")) eval('on_zone_select();'); //call on_param_select function if exists
            execute_procedure(executable_procedure);
        } else if (game_state == 'SELECTING_BUILDING') {
            if (board[x] != undefined) if (board[x][y] != undefined) {
                if (board[x][y]['type'] == 'building' || board[x][y]['type'] == 'obstacle') {
                    $('board_' + x + '_' + y).removeClass('activeUnit');
                    building = x.toString() + ',' + y.toString();
                    game_state = 'SELECTED_BUILDING';
                    selected_params++;
                    if (eval("typeof on_building_select == 'function'")) eval('on_building_select();'); //call on_param_select function if exists
                    execute_procedure(executable_procedure);
                }
            }
        }
    } catch (e) {
        if (DEBUG_MODE) {
            displayLordsError(e, 'board_clicked(' + x + ',' + y + ');<br />Last executed_procedure:' + last_executed_procedure + '<br />Last API:' + last_executed_api);
        }
    }
}
//function to prosecc money amount
function money_amount_param() {
    if (game_state == 'SELECTING_AMOUNT') {
        amount = '"' + $('money_amount').get('value').replace(/"/g, '\\"') + '"';
        if (amount != '') {
            game_state = 'SELECTED_AMOUNT';
            selected_params++;
            if (eval("typeof on_amount_select == 'function'")) eval('on_amount_select();'); //call on_param_select function if exists
            execute_procedure('send_money');
        } else showWindow('Пожалуйста', procedures_params_codes['amount']['description'], 200, 40, false);
    } else showWindow('Пожалуйста', procedures_params_codes['player']['description'], 200, 40, false);
}

//execute card click
function execute_card(pd_id,id) {
    var i = 0;
    if (turn_state == MY_TURN) {
        if (players_by_num[my_player_num]["gold"].toInt() >= cards[id]['cost'].toInt()) {
            cancel_execute()
            pre_defined_param = '';
            card = id;
            player_deck_id = pd_id;
            playingCard = true;
            i = 0;
            hideSliders();
            procedures = Array();
            cards_procedures_1.each(function (item, index) {
                if (item) if (item['card_id'] == id) {
                    procedures[i] = procedures_mode_1[item['procedure_id']];
                    i++;
                }
            });
            if (i != 0) if (i == 1) {
                execute_procedure(procedures[0]['name']);
                addCancelAction();
            } else //1 procedure for card
            //many procedures for card
            {
                clearActions();
                procedures.each(function (item, index) {
                    if (item) {
                        add_action_btn(item['ui_action_name'], 'execute_procedure(\'' + item['name'] + '\');');
                    }
                });
                addCancelAction();
            }
        } else showWindow(i18n[USER_LANGUAGE]['game']['sorry'], error_message("2"), 200, 20, false); // Not enough gold
    } else showWindow(i18n[USER_LANGUAGE]['game']['sorry'], error_message("1"), 200, 20, false); // Not your turn
}

function check_next_available_unit() {
    var found = false;
    if (turn_state == MY_TURN && !noNextUnit == 0) {
        var nx = 0;
        var ny = 0;
        board.each(function (items, index) {
            if (items) items.each(function (item, index) {
                if (item) if (item["type"] == 'unit' && !found) {
                    if (board_units[item["ref"]]['player_num'] == my_player_num && board_units[item["ref"]]['moves_left'] > 0 && !$chk(board_units[item["ref"]]["paralich"])) {
                        nx = item["x"].toInt();
                        ny = item["y"].toInt();
                        found = true;
                    }
                }
            });
        });
        if (found) {
            //console.log('check next av nx,ny=',nx,ny);
            check_execute_unit(nx, ny);
        }
    }
}

function check_execute_unit(x, y) {
    if (board[x] && board[x][y]) if (board[x][y]['ref'] && turn_state == MY_TURN) {
        var id = board[x][y]["ref"];
        if (board_units[id]["moves_left"] > 0) {
            if (multiple_action_unit_id == 0 && multiple_action_unit_id != id) {
                execute_unit(x, y);
                backlight(mouse_x, mouse_y);
            }
        } else check_next_available_unit();
    }
}
//execute unit click
function execute_unit(x, y) {
    var id = board[x][y]["ref"];
    var i = 0;
    if ($chk(board_units[id])) if (board_units[id]['player_num'].toInt() == my_player_num && turn_state == MY_TURN && board_units[id]['moves_left'].toInt() > 0 && (game_state == 'WAITTING' || game_state == 'SELECTING_EMPTY_COORD') && !$chk(board_units[id]['paralich'])) {
        cancel_execute();
        if (units[board_units[id]["unit_id"]]['size'].toInt() > 1) $$('#board_' + x + '_' + y + ' .unitdiv').addClass('activeUnit');
        else $('board_' + x + '_' + y).addClass('activeUnit');
        unit = x + ',' + y;
        pre_defined_param = 'unit';
        i = 0;
        var default_proc = '';
        procedures = Array();
        //if (players_by_num[my_player_num]['name']=='skoba') console.log('unit_id=',board_units[id]['unit_id']);
        units_procedures_1.each(function (item, index) {
            if (item) if (item['unit_id'] == board_units[id]['unit_id']) {
                procedures[i] = procedures_mode_1[item['procedure_id']];
                procedures[i]['default'] = item['default'];
                i++;
            }
        });
        //if (players_by_num[my_player_num]['name']=='skoba') console.log('procedures=',procedures);
        //if (players_by_num[my_player_num]['name']=='skoba') console.log('i=',i);
        if (i != 0) if (i == 1) execute_procedure(procedures[0]['name']);
        else //1 procedure for unit
        //many procedures for unit
        {
            clearActions();
            procedures.each(function (item, index) {
                if (item) {
                    if (item['default'].toInt() == 1) {
                        default_proc = item['name'];
                    }
                    add_action_btn(item['ui_action_name'], 'setPreDefinedParam(\'unit\');setGameState(\'WAITTING\');execute_procedure(\'' + item['name'] + '\');');
                }
            });
            addCancelAction();
            if (default_proc != '') execute_procedure(default_proc);
        }
    }
}

function execute_resurrect(card_id) {
    dead_unit = card_id;
    pre_defined_param = 'dead_unit';
    execute_procedure('player_resurrect');
}

function execute_building(x,y) {
  var id = board[x][y]["ref"];
    var i = 0;

    if ($chk(board_buildings[id])) if (board_buildings[id]['player_num'].toInt() == my_player_num && turn_state == MY_TURN && game_state == 'WAITTING') {
        cancel_execute();
        $('board_' + x + '_' + y).addClass('activeUnit');
        building = x + ',' + y;
        pre_defined_param = 'building';
        i = 0;
        var default_proc = '';
        procedures = Array();
        buildings_procedures_1.each(function (item, index) {
            if (item) if (item['building_id'] == board_buildings[id]['building_id']) {
                procedures[i] = procedures_mode_1[item['procedure_id']];
                i++;
            }
        });
	//console.log(buildings_procedures_1,id,procedures);
        //if (i != 0) if (i == 1) execute_procedure(procedures[0]['name']);
        //else //1 procedure for unit
        //many procedures for unit
       // {
            clearActions();
            procedures.each(function (item, index) {
                if (item) {
                    add_action_btn(item['ui_action_name'], 'setPreDefinedParam(\'building\');setGameState(\'WAITTING\');execute_procedure(\'' + item['name'] + '\');');
                }
            });
            addCancelAction();
        //}
    }
}

function execute_exit() {
    cancel_execute();
    do_not_in_turn = 1;
    execute_procedure('player_exit');
    do_not_in_turn = 0;
}

function execute_changeUser() {
    onRefresh();
    noRefresh = true;
    var myRequest = new Request({
        method: 'post',
        url: 'ajax/clear_session.php',
        onSuccess: function (html) {
            window.location.href = site_domen;
        }
    }).send('');
}
//clear from links Actions
function clearActions() {
    $('actions').set('html', '');
}

//cancel execution
function cancel_execute() {
    was_active = 0;
    stopShield();
    if (eval("typeof post_" + executable_procedure + " == 'function'")) eval('post_' + executable_procedure + '();'); //call post-function if it exists
    clean_everything();
    game_state = 'WAITTING';
    executable_procedure = '';
    executable_params = '';
    selected_params = 0;
    $('tip').set('text', '');
    clearActions();
    pre_defined_param = '';
    do_not_in_turn = 0;
    path_mode = false;
    playingCard = false;
}

function addCancelAction() {
    add_action_btn('esc', 'cancel_execute();');
}
//set game_state
function setGameState(nstate) {
    game_state = nstate;
}
// set pre_defined_param
function setPreDefinedParam(npre_defined_param) {
    pre_defined_param = npre_defined_param;
}
//PRE functions
function pre_send_procedure() {
    $('anim').addClass('anim');
    $('anim').removeClass('noanim');
    was_active = 0;
    stopShield();
    no_new_execute = true;
}

function pre_send_money() {
    addCancelAction();
}

function pre_put_building() {
    flip = 0;
    rotation = 0;
    add_action_btn('turn', 'change_rotation();');
    add_action_btn('refl', 'change_flip();');
}

function pre_unit_shoot(){
    var coords = unit.toString().split(',');
    var ux = coords[0].toInt();
    var uy = coords[1].toInt();
    var shooting_unit_id = board_units[board[ux][uy]['ref']]['unit_id'];
    var shoot_params = get_shooting_params(shooting_unit_id);
    show_shoot_radius(ux,uy,shoot_params);
    current_shoot_aim_types = shoot_params.aim_types;
}

function show_shoot_radius(ux,uy,shoot_params){
    var range_min = shoot_params.range_min;
    var range_max = shoot_params.range_max;
    for (x = ux - range_max; x <= ux + range_max; x++){
        for (y = uy - range_max; y <= uy + range_max; y++){
            var distance = Math.max(Math.abs(ux - x), Math.abs(uy - y));
            if (x<0 || x>19 || y<0 || y>19 || distance < range_min
                || (board[x] && board[x][y] && !(board[x][y]['type'] in shoot_params.aim_types))) {
                continue;
            }
            var classNumber = distance - range_min;
            $('board_' + x + '_' + y).addClass('aim' + classNumber);
        }
    }
}

//POST functions
function post_send_procedure() {
    $('anim').removeClass('anim');
    $('anim').addClass('noanim');
    no_new_execute = false;
}

function post_send_money() {
    $('windowmoney').setStyle('display', 'none');
}

function post_put_building() {
    $('actions').set('html', '');
}

function post_buy_card() {
    if (error_procedure == '') {
        setTimeout("deactivate_buy_ressurect_play_card();", 1000);
    }
}

function post_player_resurrect() {
    if (error_procedure == '') {
        setTimeout("deactivate_buy_ressurect_play_card();", 1000);
    }
}

function post_player_exit() {
   setTimeout("window.location.href = site_domen;", 1000);
}

function post_add_chat_message() {
    $('chat_text').set('value', '');
}

function post_cast_meteor_shower() {
    if (any_coord != '') {
        var coords = any_coord.toString().split(',');
        var ux = coords[0].toInt();
        var uy = coords[1].toInt();
        var mx;
        var my;
        for (mx = ux; mx < ux + 2; mx++)
        for (my = uy; my < uy + 2; my++)
        if ($('board_' + mx + '_' + my)) {
            $('board_' + mx + '_' + my).removeClass('attackUnit');
        }
    }
}

function post_cast_polza_move_building() {
    if (error_procedure == 'cast_polza_move_building') {
        error_procedure = '';
        error_msg = '';
        setTimeout("execute_procedure('cast_polza_move_building')", 2000);
    }
}

function post_cast_vred_move_building() {
    if (error_procedure == 'cast_vred_move_building') {
        error_procedure = '';
        error_msg = '';
        setTimeout("execute_procedure('cast_vred_move_building')", 2000);
    }
}

function post_cast_polza_resurrect() {
    if (error_procedure == 'cast_polza_resurrect') {
        error_procedure = '';
        error_msg = '';
        setTimeout("execute_procedure('cast_polza_resurrect')", 2000);
    }
}

function post_wizard_heal() {
    //clear green class
    var coords = unit.toString().split(',');
    var ux = coords[0].toInt();
    var uy = coords[1].toInt();
    $('board_' + ux + '_' + uy).removeClass('activeUnit');
}

function post_wizard_fireball() {
    //clear green class
    var coords = unit.toString().split(',');
    var ux = coords[0].toInt();
    var uy = coords[1].toInt();
    $('board_' + ux + '_' + uy).removeClass('activeUnit');
}

function post_taran_bind() {
    //clear green class
    var coords = unit.toString().split(',');
    var ux = coords[0].toInt();
    var uy = coords[1].toInt();
    $('board_' + ux + '_' + uy).removeClass('activeUnit');
}

function post_cast_teleport() {
    //clear green class
    if (unit != '') {
        var coords = unit.toString().split(',');
        var ux = coords[0].toInt();
        var uy = coords[1].toInt();
        $('board_' + ux + '_' + uy).removeClass('activeUnit');
    }
}

function post_player_move_unit() {
    var coords = unit.toString().split(',');
    var ux = coords[0].toInt();
    var uy = coords[1].toInt();
    if ($('board_' + ux + '_' + uy)) $('board_' + ux + '_' + uy + '').removeClass('activeUnit');
    if ($('board_' + (ux + 1) + '_' + (uy + 1))) $$('#board_' + (ux + 1) + '_' + (uy + 1) + ' .unitdiv').removeClass('activeUnit');
}
function post_wall_open(){
  if (building!="") {
	var coords = building.toString().split(',');
	var ux = coords[0].toInt();
	var uy = coords[1].toInt();
	if ($('board_' + ux + '_' + uy)) $('board_' + ux + '_' + uy + '').removeClass('activeUnit');
	}
}
function post_wall_close(){
  if (building!="") {
	var coords = building.toString().split(',');
	var ux = coords[0].toInt();
	var uy = coords[1].toInt();
	if ($('board_' + ux + '_' + uy)) $('board_' + ux + '_' + uy + '').removeClass('activeUnit');
	}
}

function post_unit_shoot(){
    var coords = unit.toString().split(',');
    var ux = coords[0].toInt();
    var uy = coords[1].toInt();
    var shooting_unit_id = board_units[board[ux][uy]['ref']]['unit_id'];
    var shoot_params = get_shooting_params(shooting_unit_id);
    hide_shoot_radius(ux,uy,shoot_params);
    if ($('board_' + ux + '_' + uy)) $('board_' + ux + '_' + uy + '').removeClass('activeUnit');
    if ($('board_' + (ux + 1) + '_' + (uy + 1))) $$('#board_' + (ux + 1) + '_' + (uy + 1) + ' .unitdiv').removeClass('activeUnit');
    if (shoot_target!=''){
        var coords = shoot_target.toString().split(',');
        var tx = coords[0].toInt();
        var ty = coords[1].toInt();
        $('overboard_' + tx + '_' + ty).removeClass('cursor_attack');
    }
}

function hide_shoot_radius(ux,uy,shoot_params){
    var range_min = shoot_params.range_min;
    var range_max = shoot_params.range_max;
    for (x = ux - range_max; x <= ux + range_max; x++){
        for (y = uy - range_max; y <= uy + range_max; y++){
            var distance = Math.max(Math.abs(ux - x), Math.abs(uy - y));
            if (x<0 || x>19 || y<0 || y>19 || distance < range_min) {
                continue;
            }
            var classNumber = distance - range_min;
            $('board_' + x + '_' + y).removeClass('aim'+classNumber);
        }
    }
}


function get_shooting_params(shooter_unit_id) {
    var unit_shooting_params = shooting_params[shooter_unit_id];
    var range_min = 99999;
    var range_max = -1;
    var aim_types = {};
    for (i = 0; i < unit_shooting_params.length; ++i) {
        if (unit_shooting_params[i]) {
            if (i < range_min) {
                range_min = i;
            }
            if (i > range_max) {
                range_max = i;
            }
            for (aim_type in unit_shooting_params[i]) {
                if (unit_shooting_params[i].hasOwnProperty(aim_type)) {
                    aim_types[aim_type] = true;
                }
            }
        }
    }
    return {'range_min':range_min, 'range_max':range_max, 'aim_types':aim_types};
}

//ON functions
function on_player_select() {
    if (player.toString() != '' && executable_procedure == 'send_money') {
        $('windowmoney').setStyle('display', 'block');
        $('windowmoney').setStyle('height', document.getScrollSize().y);
    }
}

function on_building_select() {
    if (executable_procedure == 'cast_polza_move_building' || executable_procedure == 'cast_vred_move_building') {
        var coords = building.toString().split(',');
        var bx = coords[0].toInt();
        var by = coords[1].toInt();
        card = board_buildings[board[bx][by]['ref']]['card_id'];
        pre_put_building();
    }
}

function on_unit_select() {
    if (executable_procedure == 'cast_teleport') {
        var coords = unit.toString().split(',');
        var ux = coords[0].toInt();
        var uy = coords[1].toInt();
        $('board_' + ux + '_' + uy).addClass('activeUnit');
    }
}

function add_action_btn(ui_action_name, onclick) {
    var myA = new Element('a', {
        'href': '#',
        'class': 'act act_' + ui_action_name,
        'html': i18n[USER_LANGUAGE]['game']['act_' + ui_action_name],
        'onclick': onclick + 'return false;'
    });
    $('actions').grab(myA, 'bottom');
}
