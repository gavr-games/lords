var color_move = 'yellow';
var color_miss = 'brown';
var color_attack = 'red';
var color_critical = 'orange';
var unactive_unit = 0.5;
var unactive_card = 0.5;

var last_executed_api = '';

var move_anims = new Array();
var kill_anims = new Array();
var post_move_anims = '';
var add_unit_after_anim = new Array();
var kill_unit_after_anim = new Array();
var anim_is_running = false;

var last_moved_unit = 0;

var saved_chat_messages = [];
var level_menu_id = 0;

function publish_api_call() {
  var callerName = publish_api_call.caller.name;
  var arguments = Array.prototype.slice.call(publish_api_call.caller.arguments);
  last_executed_api = callerName + '(' + arguments.join(',') + ')'; // set global variable
  EventBus.publish(callerName, arguments); // publish api call event
}

function player_set_gold(p_num, amount) {
    publish_api_call();
    players_by_num[p_num]["gold"] = amount;
    update_game_info_window();
    if (p_num == my_player_num && (turn_state == MY_TURN || realtime_cards) && amount >= mode_config["card cost"]) //activate buy card
        activate_button($('main_buttons').getChildren('.btn_buycard')[0]);
    if (p_num == my_player_num && amount < mode_config["card cost"]) {
        deactivate_button($('main_buttons').getChildren('.btn_buycard')[0]);
    }
    if (p_num < 10) { //not neutral
        if ($('money' + p_num))
            $('money' + p_num).set('html', amount);
        $('pl_td' + p_num).addClass('blink');
        setTimeout('$("pl_td' + p_num + '").removeClass("blink")', 2000);
        //tip
        board.each(function(items, index) {
            if (items)
                items.each(function(item, index) {
                    if (item)
                        if (item["type"] == 'castle' && board_buildings[item["ref"]]['player_num'] == p_num) {
                            //tip
                            var id = item['ref'];
                            addCastleTip('overboard_' + item['x'] + '_' + item['y'], id);
                        }
                });
        });
    } else {
        //tip
        board.each(function(items, index) {
            if (items)
                items.each(function(item, index) {
                    if (item)
                        if (item["type"] == 'unit' && board_units[item["ref"]]['player_num'] == p_num) {
                            //tip
                            var id = item['ref'];
                            addUnitTip('overboard_' + item['x'] + '_' + item['y'], id);
                        }
                });
        });
    }
}

function add_player(p_num, name, gold, owner, team) {
    publish_api_call();
    players_by_num[p_num] = new Array();
    players_by_num[p_num]['player_num'] = p_num;
    players_by_num[p_num]['name'] = name;
    players_by_num[p_num]['gold'] = gold;
    players_by_num[p_num]['owner'] = owner;
    players_by_num[p_num]['team'] = team;
    if (p_num < 10) { //not neutral
        var myP = new Element('p', {
            'html': name + ":",
            'class': 'player pl' + (p_num.toInt() + 1).toString() + ((p_num == my_player_num) ? ' user' : ''),
            'id': 'player' + p_num
        }); //create p with player
        myP.addEvent('click', function() {
            param_clicked($('player' + p_num))
        });
        var myP1 = new Element('p', {
            'html': name.substr(0, 1).toUpperCase(),
            'class': 'flag pl' + p_num,
            'id': 'flag' + p_num
        });
        var myP2 = new Element('p', {
            'html': gold,
            'class': 'money' + ((p_num == my_player_num) ? ' user' : ''),
            'id': 'money' + p_num
        });
        var myP3 = new Element('p', {
            'html': '',
            'class': 'coin',
            'id': 'pl_td' + p_num
        });
        $('players').grab(myP1, 'bottom');
        $('players').grab(myP, 'bottom');
        $('players').grab(myP2, 'bottom');
        $('players').grab(myP3, 'bottom');
    }
    update_game_info_window();
}

function delete_player(p_num) {
    publish_api_call();
    delete players_by_num[p_num];
    if (p_num < 10) { //not neutral
        if ($('player' + p_num)) {
            $('player' + p_num).destroy();
            $('money' + p_num).destroy();
            $('flag' + p_num).destroy();
            $('pl_td' + p_num).destroy();
        }
    }
    update_game_info_window();
}

function unit_set_health(x, y, health) {
    publish_api_call();
    var id = board[x][y]["ref"];

    //highlight
    if (board_units[id]["health"].toInt() >= health)
        highlight_action(x, y, 'hred');
    else
        highlight_action(x, y, 'hgreen');

    board_units[id]["health"] = health;
    var size = units[board_units[id]['unit_id']]["size"].toInt();
    var maxx = x.toInt() + size;
    var maxy = y.toInt() + size;
    var mx = 0;
    var my = 0;
    for (mx = x; mx < maxx; mx++)
        for (my = y; my < maxy; my++) {
            //tip
            addUnitTip('overboard_' + mx + '_' + my, id);
        }
}

function unit_set_max_health(x, y, health) {
    publish_api_call();
    var id = board[x][y]["ref"];
    board_units[id]["max_health"] = health;
    board.each(function(items, index) {
        if (items)
            items.each(function(item, index) {
                if (item)
                    if (item["ref"] == board[x][y]["ref"] && item["type"] == 'unit') {
                        //tip
                        addUnitTip('overboard_' + item['x'] + '_' + item['y'], id);
                    }
            });
    });
}

function unit_set_shield(x, y, shield) {
    publish_api_call();
    var id = board[x][y]["ref"];

    //highlight
    if (board_units[id]["shield"].toInt() >= shield)
        highlight_action(x, y, 'hred');
    else
        highlight_action(x, y, 'hgreen');

    board_units[id]["shield"] = shield;
    board.each(function(items, index) {
        if (items)
            items.each(function(item, index) {
                if (item)
                    if (item["ref"] == board[x][y]["ref"] && item["type"] == 'unit') {
                        //tip
                        addUnitTip('overboard_' + item['x'] + '_' + item['y'], id);
                    }
            });
    });
}

function unit_set_moves_left(x, y, moves_left) {
    publish_api_call();
    /*if (!$('board_'+x+'_'+y).getChildren('.unitdiv')[0])	{ //unit haven't appeared after move animation
			setTimeout('unit_set_moves_left('+x+','+y+','+moves_left+');',2100);
			return 0;
    }*/
    if (!$chk(board[x]) || !$chk(board[x][y]) || !$chk(board[x][y]['ref'])) {
        return;
    }
    var id = board[x][y]["ref"];
    board_units[id]["moves_left"] = moves_left;
    var size = units[board_units[id]['unit_id']]["size"].toInt();
    if (multiple_action_unit_id != 0 && multiple_action_unit_id == id && moves_left == 0) {
        after_commands = 'no_backlight = false; multiple_action_unit_id = 0;';
    }
    if (board_units[id]['player_num'].toInt() == my_player_num && turn_state == MY_TURN) {
        if (anim_is_running)
            after_commands_units = 'check_execute_unit(' + (x + size - 1) + ',' + (y + size - 1) + ');';
        else
            check_execute_unit(x + size - 1, y + size - 1);
    }
    //
    board.each(function(items, index) {
        if (items)
            items.each(function(item, index) {
                if (item)
                    if (item["ref"] == board[x][y]["ref"] && item["type"] == 'unit') {
                        //tip
                        addUnitTip('overboard_' + item['x'] + '_' + item['y'], id);
                        //unactive
                        if ($('board_' + item['x'] + '_' + item['y']).getChildren('.unitdiv')[0])
                            if (moves_left == 0) {
                                $('board_' + item['x'] + '_' + item['y']).getChildren('.unitdiv')[0].fade(unactive_unit);
                                $('board_' + item['x'] + '_' + item['y']).removeClass('my-brd-unit');
                            } else if (!($chk(board_units[id]["paralich"]) && board_units[id]["paralich"] == 1)) {
                              $('board_' + item['x'] + '_' + item['y']).getChildren('.unitdiv')[0].fade(1);
                            }
                    }
            });
    });
}

function unit_set_attack(x, y, attack) {
    publish_api_call();
    var id = board[x][y]["ref"];
    board_units[id]["attack"] = attack;
    board.each(function(items, index) {
        if (items)
            items.each(function(item, index) {
                if (item)
                    if (item["ref"] == board[x][y]["ref"] && item["type"] == 'unit') {
                        //tip
                        addUnitTip('overboard_' + item['x'] + '_' + item['y'], id);
                    }
            });
    });
}

function unit_set_moves(x, y, moves) {
    publish_api_call();
    var id = board[x][y]["ref"];
    board_units[id]["moves"] = moves;
    board.each(function(items, index) {
        if (items)
            items.each(function(item, index) {
                if (item)
                    if (item["ref"] == board[x][y]["ref"] && item["type"] == 'unit') {
                        //tip
                        addUnitTip('overboard_' + item['x'] + '_' + item['y'], id);
                    }
            });
    });
}

function unit_add_effect(x, y, effect, param) {
    publish_api_call();
    var id = board[x][y]["ref"];
    var fval;
    if (param == '') fval = 1;
    else fval = param;
    board_units[id][effect] = fval;
    board.each(function(items, index) {
        if (items)
            items.each(function(item, index) {
                if (item)
                    if (item["ref"] == board[x][y]["ref"] && item["type"] == 'unit') {
                        //tip
                        addUnitTip('overboard_' + item['x'] + '_' + item['y'], id);
                        //unactive
                        if (effect == 'paralich') {
                          var cmd = "$('board_" + item['x'] + "_" + item['y'] + "').getChildren('.unitdiv')[0].fade("+ unactive_unit + ");";
                          if ($('board_' + item['x'] + '_' + item['y']).getChildren('.unitdiv')[0] != undefined) {
                            eval(cmd);
                          } else {
                            setTimeout(cmd, 500);
                          }
                        }
                    }
            });
    });
}

function unit_remove_effect(x, y, effect) {
    publish_api_call();
    var id = board[x][y]["ref"];
    delete board_units[id][effect];
    board.each(function(items, index) {
        if (items)
            items.each(function(item, index) {
                if (item)
                    if (item["ref"] == board[x][y]["ref"] && item["type"] == 'unit') {
                        //tip
                        addUnitTip('overboard_' + item['x'] + '_' + item['y'], id);
                        //unactive
                        if (effect == 'paralich') $('board_' + item['x'] + '_' + item['y']).getChildren('.unitdiv')[0].fade(1);
                    }
            });
    });
}

function unit_set_owner(x, y, p_num) {
    publish_api_call();
    var id = board[x][y]["ref"];
    var card_id = '';
    var unit_id = '';
    card_id = board_units[id]['card_id'];
    unit_id = board_units[id]['unit_id'];
    visual_kill_unit(x, y);

    board_units[id]["player_num"] = p_num;

    if (card_id != '') add_unit(id, p_num, x, y, card_id);
    else
        add_unit_by_id(id, p_num, x, y, unit_id);
}

function unit_level_up_attack(x, y) {
    publish_api_call();
    var id = board[x][y]["ref"];
    board_units[id]["level"] = board_units[id]["level"].toInt() + 1;
    unit_set_attack(x, y, board_units[id]["attack"].toInt() + 1);
    //hide star
    $('star_' + id).destroy();
    unit_add_exp(x, y, 0);
    $('lvl_choose').setStyle('display', 'none');
}

function unit_level_up_moves(x, y) {
    publish_api_call();
    var id = board[x][y]["ref"];
    board_units[id]["level"] = board_units[id]["level"].toInt() + 1;
    unit_set_moves(x, y, board_units[id]["moves"].toInt() + 1);
    //hide star
    $('star_' + id).destroy();
    unit_add_exp(x, y, 0);
    $('lvl_choose').setStyle('display', 'none');
}

function unit_level_up_health(x, y) {
    publish_api_call();
    var id = board[x][y]["ref"];
    board_units[id]["level"] = board_units[id]["level"].toInt() + 1;
    unit_set_max_health(x, y, board_units[id]["max_health"].toInt() + 1);
    unit_set_health(x, y, board_units[id]["health"].toInt() + 1);
    //hide star
    $('star_' + id).destroy();
    unit_add_exp(x, y, 0);
    $('lvl_choose').setStyle('display', 'none');
}

function unit_add_exp(x, y, exps) {
    publish_api_call();
    var id = board[x][y]["ref"];
    board_units[id]["experience"] = board_units[id]["experience"].toInt() + exps;
    //show star
    size = units[board_units[id]['unit_id']]["size"].toInt();
    maxx = x.toInt() + size;
    maxy = y.toInt() + size;
    oldy = y;
    oldx = x;
    for (; x < maxx; x++)
        for (y = oldy; y < maxy; y++) {
            if (board_units[id]['experience'] >= units_levels[board_units[id]['unit_id'].toInt()][board_units[id]['level'].toInt() + 1] && x == maxx - 1 && y == oldy) {
                if ($('overboard_' + x + '_' + y).getChildren('.level-star').length == 0) {
                   EventBus.publish('show_levelup_star', [x, y, exps]);
                    var star = new Element('a', {
                        'html': '',
                        'class': 'level-star',
                        'id': 'star_' + id,
                        'onclick': 'show_levelup(' + id + ');'
                    });
                    $('overboard_' + x + '_' + y).grab(star, 'bottom');
                }
            }
        }
    x = oldx;
    y = oldy;
    //hint
    board.each(function(items, index) {
        if (items)
            items.each(function(item, index) {
                if (item)
                    if (item["ref"] == board[x][y]["ref"] && item["type"] == 'unit') {
                        //tip
                        addUnitTip('overboard_' + item['x'] + '_' + item['y'], id);
                    }
            });
    });
}

function show_levelup(id) {
    if (board_units[id]["player_num"] == my_player_num && turn_state == MY_TURN) {
        if ($('lvl_choose').getStyle('display') == 'none' || level_menu_id != id) {
            $('lvl_choose').setStyle('display', 'block');
            $('lvl_choose').position({
                relativeTo: $('star_' + id),
                position: 'centerRight',
                edge: 'centerLeft'
            });
            level_menu_id = id;
            $('lvl_a').removeEvents('click');
            $('lvl_a').addEvent('click', function() {
                var x = 0;
                var y = 0;
                board.each(function(items, index) {
                    if (items)
                        items.each(function(item, index) {
                            if (item)
                                if (item["ref"] == id && item["type"] == 'unit') {
                                    x = item['x'];
                                    y = item['y'];
                                }
                        });
                });
                unit = x + ',' + y;
                pre_defined_param = 'unit';
                execute_procedure('unit_level_up_attack');
                //console.log(unit);
            });
            $('lvl_m').removeEvents('click');
            $('lvl_m').addEvent('click', function() {
                var x = 0;
                var y = 0;
                board.each(function(items, index) {
                    if (items)
                        items.each(function(item, index) {
                            if (item)
                                if (item["ref"] == id && item["type"] == 'unit') {
                                    x = item['x'];
                                    y = item['y'];
                                }
                        });
                });
                unit = x + ',' + y;
                pre_defined_param = 'unit';
                execute_procedure('unit_level_up_moves');
                //console.log(unit);
            });
            $('lvl_h').removeEvents('click');
            $('lvl_h').addEvent('click', function() {
                var x = 0;
                var y = 0;
                board.each(function(items, index) {
                    if (items)
                        items.each(function(item, index) {
                            if (item)
                                if (item["ref"] == id && item["type"] == 'unit') {
                                    x = item['x'];
                                    y = item['y'];
                                }
                        });
                });
                unit = x + ',' + y;
                pre_defined_param = 'unit';
                execute_procedure('unit_level_up_health');
                //console.log(unit);
            });
        } else {
            $('lvl_choose').setStyle('display', 'none');
        }
    }
}

function highlight_action(x, y, hclass) {
    var hDiv = new Element('div', {});
    $('overboard_' + x + '_' + y).grab(hDiv, 'top');
    hDiv.addClass(hclass);
    var myFx = new Fx.Tween(hDiv, {
        property: 'opacity'
    });
    myFx.start(0, 0.8).chain(
        //Notice that "this" refers to the calling object (in this case, the myFx object).
        function() {
            this.start(0.8, 0);
        },
        function() {
            if (this.element) this.element.destroy()
        }
    );
}

function log_add_independent_message(p_num, message_code, message_parameters) {
    publish_api_call();

    //log statistics of time
    logTimeStats(p_num);

    var message = parse_log_message(message_code, message_parameters);
    var clName = '';
    if (p_num < 10) clName = 'p' + p_num;
    else clName = 'newtrl';
    var mid = 'log' + p_num + $time();

    var mesDiv = new Element('div', {
        'class': 'mes ' + clName
    });
    if ($('game_log').getStyle('display') == 'none') { //by f5
        var mainDiv = new Element('div', {
            'class': 'main old',
            'html': message,
            'id': mid
        });
    } else {
        var mainDiv = new Element('div', {
            'class': 'main new1',
            'html': message,
            'id': mid
        });
    }
    mesDiv.grab(mainDiv, 'bottom');
    $('game_log').grab(mesDiv, 'bottom');
    log_message_add_card_tooltips(mainDiv);

    if ($('game_log').getStyle('display') != 'none') {
        $(mid).set('morph', {
            duration: 1500,
            transition: Fx.Transitions.Sine.easeOut,
            onComplete: function(el) {
                el.setStyle('background-color', 'transparent');
            }
        });
        $(mid).morph({
            'color': '#fff',
            'background-color': '#322a1a'
        });
    }
    var scroll = $('game_log').getScrollSize();
    $('game_log').scrollTo(0, scroll.y);
}

function log_add_container(p_num, message_code, message_parameters) {
    publish_api_call();
    //log statistics of time
    logTimeStats(p_num);
    var message = parse_log_message(message_code, message_parameters);
    var clName = '';
    if (p_num < 10) clName = 'p' + p_num;
    else clName = 'newtrl';
    var mid = 'log' + p_num + $time();
    logContainerId = 'logsub' + p_num + $time();

    var mesDiv = new Element('div', {
        'class': 'mes ' + clName
    });
    if ($('game_log').getStyle('display') == 'none') //by f5
        var mainDiv = new Element('div', {
            'class': 'main cont old',
            'html': message,
            'id': mid
        });
    else
        var mainDiv = new Element('div', {
            'class': 'main cont new1',
            'html': message,
            'id': mid
        });
    logContainer = new Element('div', {
        'class': 'sub',
        'id': logContainerId
    });
    mainDiv.addEvent('click', function() {
        var contChild;
        if (this.getNext('div.sub'))
            contChild = this.getNext('div.sub');
        else
            contChild = this.getNext('div').getChildren('div.sub')[0];
        contChild.slide();
        if (contChild == logContainer) {
            setTimeout(function() {
                var scroll = $('game_log').getScrollSize();
                $('game_log').scrollTo(0, scroll.y);
            }, 1000);
        }
    });

    mesDiv.grab(mainDiv, 'bottom');

    mesDiv.grab(logContainer, 'bottom');
    $('game_log').grab(mesDiv, 'bottom');
    log_message_add_card_tooltips(mainDiv);
    $(mid).set('morph', {
        duration: 2000,
        transition: Fx.Transitions.Sine.easeOut,
        onComplete: function(el) {
            el.setStyle('background-color', 'transparent');
        }
    });
    if ($('game_log').getStyle('display') != 'none') { //not f5
        $(mid).morph({
            'color': '#fff',
            'background-color': '#322a1a'
        });
    }
    var scroll = $('game_log').getScrollSize();
    $('game_log').scrollTo(0, scroll.y);
}

function log_close_container() {
    publish_api_call();
    if ($('game_log').getStyle('display') == 'none') logContainer.slide("hide"); //by f5
    else
        setTimeout('$("' + logContainerId + '").slide("in");$("' + logContainerId + '").slide("out");', 2500);
}

function log_add_message(message_code, message_parameters) {
    publish_api_call();
    //log statistics of time
    if (turn_state == MY_TURN)
        logTimeStats(my_player_num);
    var message = parse_log_message(message_code, message_parameters);
    var mySpan = new Element('span', {
        'html': message
    }); //create span with message
    logContainer.grab(mySpan, 'bottom'); //insert span to div
    log_message_add_card_tooltips(mySpan);

    if ($('game_log').getStyle('display') != 'none') { //not f5
        var container;
        if (!logContainer.getPrevious('div'))
            container = logContainer.getParent('div').getPrevious('div');
        else
            container = logContainer.getPrevious('div');
        container.setStyles({
            'background-color': '#B3B2B2',
            'color': 'black'
        });
        container.morph({
            'color': '#fff',
            'background-color': '#322a1a'
        });
    }

    var scroll = $('game_log').getScrollSize();
    $('game_log').scrollTo(0, scroll.y);
}

function log_message_add_card_tooltips(elem) {
    elem.getChildren('.logCard').each(function(item, index) {
        if (item) {
            var dom_id = item.get('id');
            var card_id = item.get('data-card-id');
            addCardTip(dom_id, card_id);
        }
    });
}

function parse_log_message(message_code, message_parameters) {
    var messageText = log_message_text(message_code);
    var placeholders = messageText.match(/\{[^}]+\}/g);
    if (placeholders && message_parameters != '') {
        var params = message_parameters.split(';');
        placeholders.forEach(function(placeholder) {
            var paramCode = placeholder.match(/[a-z]+/);
            var paramIndex = placeholder.match(/[0-9]+/);
            var substitutionText = parse_log_param(paramCode, params[paramIndex]);
            messageText = messageText.replace(placeholder, substitutionText);
        });
    }
    return messageText;
}

function parse_log_param(paramCode, param) {
    if (paramCode == 'attack') return log_param_amount_with_image(param, 'pic_attk.gif');
    if (paramCode == 'health') return log_param_amount_with_image(param, 'pic_health.gif');
    if (paramCode == 'moves') return log_param_amount_with_image(param, 'pic_move.gif');
    if (paramCode == 'gold') return log_param_amount_with_image(param, 'coin.png');
    if (paramCode == 'damage') return log_param_damage(param);
    if (paramCode == 'card') return log_param_card(param);
    if (paramCode == 'cell') return log_param_cell(param);
    if (paramCode == 'player') return log_param_player(param);
    if (paramCode == 'building') return log_param_building(param);
    if (paramCode == 'unit') return log_param_unit(param);
    if (paramCode == 'unitakk') return log_param_unit(param, 'akk');
    if (paramCode == 'unitname') return log_param_unit(param, false, 'just name');
}

function log_param_amount_with_image(amount, image) {
    return "<b>" + amount + "</b><img src='../../design/images/" + image + "'>";
}

function log_param_card(card_id) {
    var dom_id = Math.random().toString(36).substr(2, 9) + card_id;
    return "<b class='logCard' id='log-card-" + dom_id + "' data-card-id='" + card_id + "'>" + card_name(card_id) + "</b>";
}

function log_param_damage(amount) {
    return "<b class='damage' title='" + i18n[USER_LANGUAGE]['game']['log_damage'] + "'>" + amount + "</b>";
}

function log_param_player(playerJson) {
    var player = JSON.parse(playerJson);
    if (player.unit) {
        return log_param_decoded_unit(player.unit);
    } else {
        return "<b class='" + log_player_class(player.player_num) + "'>" + player.name + "</b>";
    }
}

function log_param_cell(cellJson) {
    var cell = JSON.parse(cellJson);
    var x = cell.x;
    var y = cell.y;
    return "<b onmouseenter='highlight_cell(" + x + "," + y + ")' onmouseleave='unhighlight_cell(" + x + "," + y + ")'>(" + x + "," + y + ")</b>";
}

function log_param_building(buildingJson) {
    var building = JSON.parse(buildingJson);
    var board_id = building.board_id;
    var object_type = building.type;
    var x = building.x;
    var y = building.y;
    var object_name = building_log_name(building.building_id);
    var p_num = building.player_num;
    return log_param_board_object_html(board_id, object_type, x, y, object_name, p_num);
}

function log_param_unit(unitJson, akk = false, justName = false) {
    var unit = JSON.parse(unitJson);
    if (justName) {
        delete unit.npc_player_name;
    }
    return log_param_decoded_unit(unit, akk);
}

function log_param_decoded_unit(unit, akk = false) {
    var board_id = unit.board_id;
    var object_type = unit.type;
    var x = unit.x;
    var y = unit.y;
    var object_name;
    if (unit.npc_player_name) {
        object_name = npc_player_name_log(unit.npc_player_name, akk);
    } else {
        object_name = unit_log_name(unit.unit_id, akk);
    }
    var p_num = unit.player_num;
    return log_param_board_object_html(board_id, object_type, x, y, object_name, p_num);
}

function log_param_board_object_html(board_id, object_type, x, y, object_name, p_num) {
    return "<b class='" + log_player_class(p_num) + "'" +
        " onmouseenter='highlight_board_object_if_exists(" + board_id + ",\"" + object_type + "\"," + x + "," + y + ")'" +
        " onmouseleave='unhighlight_board_object_if_exists(" + board_id + ",\"" + object_type + "\"," + x + "," + y + ")'>" +
        object_name + "</b>";
}

function highlight_board_object_if_exists(board_id, object_type, x, y) {
    if (object_type == 'unit' && board_units[board_id]) {
        highlight_unit(board_id);
    } else if (object_type != 'unit' && board_buildings[board_id]) {
        highlight_building(board_id);
    } else {
        highlight_cell(x, y);
    }
}

function unhighlight_board_object_if_exists(board_id, object_type, x, y) {
    if (object_type == 'unit' && board_units[board_id]) {
        unhighlight_unit(board_id);
    } else if (object_type != 'unit' && board_buildings[board_id]) {
        unhighlight_building(board_id);
    } else {
        unhighlight_cell(x, y);
    }
}

function log_player_class(p_num) {
    return playerClass = p_num < 10 ? 'p' + p_num.toString() : 'newtrl';
}

function log_add_move_message(x, y, x2, y2, p_num, unit_id, npc_name) {
    publish_api_call();
    //log statistics of time
    logTimeStats(p_num);
    var short_name = npc_name ? npc_player_name_log(npc_name) : unit_log_name(unit_id);
    var myclass = '';
    if (p_num < 10) myclass = 'color p' + p_num.toString();
    else
        myclass = 'color newtrl';
    var mySpan = new Element('span', {
        'html': '<p class="icon move" title="' + i18n[USER_LANGUAGE]['game']['log_move'] + '"></p>'
    }); //create span with message
    var myP = new Element('p', {
        'html': short_name,
        'class': myclass,
        'title': '(' + x + ',' + y + ') -> (' + x2 + ',' + y2 + ')'
    });
    myP.addEvent('mouseenter', function() {
        markCoords(x, y);
        markCoords2(x2, y2);
        drawArrow(x * 35 + 17.5, y * 35 + 17.5, x2 * 35 + 17.5, y2 * 35 + 17.5, color_move);
    });
    myP.addEvent('mouseleave', function() {
        demarkCoords(x, y);
        demarkCoords2(x2, y2);
        clearArrowRect(x * 35 + 17.5, y * 35 + 17.5, x2 * 35 + 17.5, y2 * 35 + 17.5);
    });
    mySpan.grab(myP, 'top');
    logContainer.grab(mySpan, 'bottom'); //insert span to div

    if ($('game_log').getStyle('display') != 'none') { //not f5
        var container;
        if (!logContainer.getPrevious('div'))
            container = logContainer.getParent('div').getPrevious('div');
        else
            container = logContainer.getPrevious('div');
        container.setStyles({
            'background-color': '#B3B2B2',
            'color': 'black'
        });
        container.morph({
            'color': '#fff',
            'background-color': '#322a1a'
        });
    }

    var scroll = $('game_log').getScrollSize();
    $('game_log').scrollTo(0, scroll.y);
}

function log_add_attack_unit_message(x, y, x2, y2, p_num, unit_id, p_num2, aim_unit_id, attack_success, critical, damage, npc_name, npc2_name) {
    var unit_name = npc_name ? npc_player_name_log(npc_name) : unit_log_name(unit_id);
    var aim_name = npc2_name ? npc_player_name_log(npc2_name, 'akk') : unit_log_name(aim_unit_id, 'akk');
    log_add_attack_message(x, y, x2, y2, p_num, unit_name, p_num2, aim_name, attack_success, critical, damage)
}

function log_add_attack_building_message(x, y, x2, y2, p_num, unit_id, p_num2, aim_building_id, attack_success, critical, damage, npc_name) {
    var unit_name = npc_name ? npc_player_name_log(npc_name) : unit_log_name(unit_id);
    log_add_attack_message(x, y, x2, y2, p_num, unit_name, p_num2, building_log_name(aim_building_id), attack_success, critical, damage)
}

function log_add_attack_message(x, y, x2, y2, p_num, short_name, p_num2, short_name2, attack_success, critical, damage) {
    publish_api_call();
    //log statistics of time
    logTimeStats(p_num);
    var arrow_colr;
    var myclass = '';
    var myclass2 = '';
    var icon_class = '';
    var icon_descr = '';
    if (p_num < 10)
        myclass = 'color p' + p_num.toString();
    else
        myclass = 'color newtrl';
    if (p_num2 < 10)
        myclass2 = 'color p' + p_num2.toString();
    else
        myclass2 = 'color newtrl';
    if (attack_success == 0) {
        icon_class = 'miss';
        icon_descr = i18n[USER_LANGUAGE]['game']['log_miss'];
        arrow_colr = color_miss;
    } else {
        if (critical == 1) {
            icon_class = 'crit';
            icon_descr = i18n[USER_LANGUAGE]['game']['log_crit'];
            arrow_colr = color_critical;
        } else {
            icon_class = 'attack';
            icon_descr = i18n[USER_LANGUAGE]['game']['log_attack'];
            arrow_colr = color_attack;
        }
    }
    var mySpan = new Element('span', {
        'html': '<p class="icon ' + icon_class + '" title="' + icon_descr + '"></p>'
    }); //create span with message
    var myP = new Element('p', {
        'html': short_name,
        'class': myclass,
        'title': '(' + x + ',' + y + ')'
    });
    myP.addEvent('mouseenter', function() {
        markCoords(x, y);
        drawArrow(x * 35 + 17.5, y * 35 + 17.5, x2 * 35 + 17.5, y2 * 35 + 17.5, arrow_colr);
    });
    myP.addEvent('mouseleave', function() {
        demarkCoords(x, y);
        clearArrowRect(x * 35 + 17.5, y * 35 + 17.5, x2 * 35 + 17.5, y2 * 35 + 17.5);
    });
    var myP2 = new Element('p', {
        'html': short_name2,
        'class': myclass2,
        'title': '(' + x2 + ',' + y2 + ')'
    });
    myP2.addEvent('mouseenter', function() {
        markCoords2(x2, y2);
        drawArrow(x * 35 + 17.5, y * 35 + 17.5, x2 * 35 + 17.5, y2 * 35 + 17.5, arrow_colr);
    });
    myP2.addEvent('mouseleave', function() {
        demarkCoords2(x2, y2);
        clearArrowRect(x * 35 + 17.5, y * 35 + 17.5, x2 * 35 + 17.5, y2 * 35 + 17.5);
    });
    mySpan.grab(myP, 'top');
    mySpan.grab(myP2, 'bottom');
    if (damage > 0) {
        var myP3 = new Element('p', {
            'html': damage,
            'class': "icon damage",
            'title': i18n[USER_LANGUAGE]['game']['log_damage']
        });
        mySpan.grab(myP3, 'bottom');
    }
    var myBr = new Element('br');
    logContainer.grab(mySpan, 'bottom'); //insert span to div
    logContainer.grab(myBr, 'bottom');

    if ($('game_log').getStyle('display') != 'none') { //not f5
        var container;
        if (!logContainer.getPrevious('div'))
            container = logContainer.getParent('div').getPrevious('div');
        else
            container = logContainer.getPrevious('div');
        container.setStyles({
            'background-color': '#B3B2B2',
            'color': 'black'
        });
        container.morph({
            'color': '#fff',
            'background-color': '#322a1a'
        });
        animateAction(x, y, x2, y2, 'attack');
    }

    var scroll = $('game_log').getScrollSize();
    $('game_log').scrollTo(0, scroll.y);
}

function logTimeStats(p_num) {
    if (need_answer && p_num == my_player_num) {
        answer_time = $time() / 1000 - start_proc_time / 1000;
        need_answer = false;
    }
}

function animateAction(x, y, x2, y2, actionKind) {
  if (anim_is_running) {
    setTimeout(function() {animateAction(x, y, x2, y2, actionKind)}, 300);
  } else {
    var animationDiv = jQuery("<div class=\"animate-" + actionKind + "-action\"></div>");
    var p  = jQuery("#board_" + x + "_" + y).position();
    var p2  = jQuery("#board_" + x2 + "_" + y2).position();
    animationDiv.css({top: p.top + 5, left: p.left + 5});
    jQuery(document.body).append(animationDiv);
    animationDiv.animate({
      left: p2.left + 5,
      top: p2.top + 5
    }, 300 * Math.max(Math.abs(x2-x), Math.abs(y2-y)), function() {
      animationDiv.remove();
    });
  }
}

function add_card(pd_id, card_id, no_anim) {
    publish_api_call();
    no_anim = no_anim || false;
    var myDiv = new Element('div', {
        'class': 'card',
        'id': 'card_' + pd_id
    }); //create div with card
    var myImg = new Element('img', {
        'src': '../../design/images/cards/' + cards[card_id]['image'],
        'alt': card_name(card_id)
    });
    myDiv.addEvent('click', function() {
        execute_card(pd_id, card_id)
    });
    myDiv.grab(cardTitleDiv(card_id), 'bottom');
    myDiv.grab(cardPriceDiv(cards[card_id]['cost']), 'bottom');
    myDiv.grab(myImg, 'bottom');
    $('cards_holder').grab(myDiv, 'bottom');
    addCardTip('card_' + pd_id, card_id);
    if (cardsCarousel)
        cardsCarousel.toLast();
    //all cards view is opened and not grave
    if (allCardsSlider.open && !$('graveLink').hasClass('cementary')) {
        var newItem = myDiv.clone().cloneEvents(myDiv);
        newItem.setStyle('left', '');
        newItem.setStyle('position', 'relative');
        $('fullsize_holder').grab(newItem);
        if (movedUnits || players_by_num[my_player_num]['gold'].toInt() < mode_config["card cost"]) newItem.fade(unactive_card);
    }
    //anim of new card
    if (!no_anim) {
        var my2Img = new Element('img', {
            'src': '../../design/images/cards/' + cards[card_id]['image'],
            'alt': card_name(card_id)
        });
        var my2Div = new Element('div', {
            'class': 'card_anim'
        });
        // create div with title
        var title2Div = new Element('div', {
            'class': 'card_title',
            html: card_names[USER_LANGUAGE][card_id]['name'],
            'styles': {
                'top': 15,
                'left': 15
            }
        });
        my2Div.grab(title2Div, 'bottom');
        my2Div.grab(my2Img, 'bottom');
        my2Div.grab(cardPriceDiv(cards[card_id]['cost']), 'bottom');
        document.body.grab(my2Div, 'bottom');
        my2Div.position();
        var myFx = new Fx.Tween(my2Div, {
            property: 'opacity',
            duration: 1000
        });
        myFx.start(0, 1).chain(
            //Notice that "this" refers to the calling object (in this case, the myFx object).
            function() {
                this.start(1, 0);
            },
            function() {
                if (this.element) this.element.destroy()
            }
        );
    }
}

function cardPriceDiv(price) {
    price = price.toString();
    var priceDiv = new Element('div', {
        'class': 'card_price'
    });
    var number;
    for (j = 0; j < price.length; j++) {
        number = new Element('img', {
            'src': '../../design/images/numbers/sm_' + price.charAt(j) + '.png',
            'alt': price.charAt(j)
        });
        priceDiv.grab(number, 'bottom');
    }
    return priceDiv;
}

function cardTitleDiv(card_id) {
    var titleDiv = new Element('div', {
        'class': 'card_title',
        html: card_names[USER_LANGUAGE][card_id]['name']
    });
    return titleDiv;
}

function remove_card(card_id) {
    publish_api_call();
    removeBoardTip('card_' + card_id);
    $('card_' + card_id).destroy();
    hideSliders();
    cardsCarousel.toFirst();
}

function add_spectator(p_num, name) {
    publish_api_call();
    var myDiv = new Element('div', {
        'html': name,
        'class': 'spectator',
        'id': 'spec_' + p_num
    }); //create div with spec
    $('spectators').grab(myDiv, 'bottom');
    //spectator
    if (p_num == my_player_num) {
        $('agree_draw').destroy();
    }
    var dt = new Date();
    dt = dt.getTime();
    dt = parseInt(dt / 1000);
    chat_add_service_message(dt, i18n[USER_LANGUAGE]["game"]["observer_joined"] + name);
}

function add_spectator_init(p_num, name) {
    publish_api_call();
    var myDiv = new Element('div', {
        'html': name,
        'class': 'spectator',
        'id': 'spec_' + p_num
    }); //create div with spec
    $('spectators').grab(myDiv, 'bottom');
    //spectator
    if (p_num == my_player_num) {
        $('agree_draw').destroy();
    }
}

function remove_spectator(p_num) {
    publish_api_call();
    var dt = new Date();
    dt = dt.getTime();
    dt = parseInt(dt / 1000);
    chat_add_service_message(dt, i18n[USER_LANGUAGE]["game"]["observer_left"] + $('spec_' + p_num).get('text'));
    if ($('spec_' + p_num))
        $('spec_' + p_num).destroy();
}

function add_unit(id, p_num, x, y, card_id) {
    if (!players_by_num[p_num]) return 0;
    publish_api_call();
    if (card_id != 0) {
        var check1 = typeof(board_units[id]);
        if (check1 != "undefined") var check2 = typeof(board_units[id]["id"]);
        if (check1 == "undefined" || check2 == "undefined") {
            board_units[id] = new Array();
            board_units[id]["id"] = id;
            board_units[id]["player_num"] = p_num;
            board_units[id]["unit_id"] = cards[card_id]["ref"];
            board_units[id]["card_id"] = card_id;
            board_units[id]["health"] = units[cards[card_id]["ref"]]["health"];
            board_units[id]["max_health"] = units[cards[card_id]["ref"]]["health"];
            board_units[id]["attack"] = units[cards[card_id]["ref"]]["attack"];
            board_units[id]["moves_left"] = units[cards[card_id]["ref"]]["moves"];
            board_units[id]["moves"] = units[cards[card_id]["ref"]]["moves"];
            board_units[id]["shield"] = units[cards[card_id]["ref"]]["shield"];
            board_units[id]["level"] = 0;
            board_units[id]["experience"] = 0;
            unit_features_usage.each(function(item, index) {
                if (item) {
                    if (board_units[id]["unit_id"] == item["unit_id"]) {
                        var fval;
                        if (item['param'] == '') fval = 1;
                        else fval = item['param'];
                        board_units[id][unit_features[item['feature_id']]['code']] = fval;
                    }
                }
            });
        }
        var size = units[board_units[id]['unit_id']]["size"].toInt();
        var maxx = x.toInt() + size;
        var maxy = y.toInt() + size;
        var oldy = y;
        var oldx = x;
        for (; x < maxx; x++)
            for (y = oldy; y < maxy; y++) {
                if (!board[x]) board[x] = new Array();
                board[x][y] = new Array();
                board[x][y]["x"] = x;
                board[x][y]["y"] = y;
                board[x][y]["type"] = "unit";
                board[x][y]["ref"] = id;
            }
        x = oldx;
        y = oldy;
    }
    //show
    size = units[board_units[id]['unit_id']]["size"].toInt();
    maxx = x.toInt() + size;
    maxy = y.toInt() + size;
    oldy = y;
    for (; x < maxx; x++)
        for (y = oldy; y < maxy; y++) {
            var sizeClass = '';
            if ((size > 1 && x == (maxx - 1) && y == (maxy - 1)) || size == 1) sizeClass = 'unit_' + units[cards[card_id]["ref"]]["ui_code"];
            var myDiv = new Element('div', {
                'html': '',
                'class': 'z_4 unitdiv ' + sizeClass
            });
            var myDivOver = new Element('div');
            myDivOver.addEvent('click', function() {
                execute_unit(x - 1, y - 1);
            });
            $('board_' + x + '_' + y).grab(myDiv, 'bottom');
            $('overboard_' + x + '_' + y).grab(myDivOver, 'bottom');
            if (showColorCells.toInt() == 1) { //enabled option to show color cells
                if (p_num >= 10) $('board_' + x + '_' + y).addClass('newtrl');
                else
                    $('board_' + x + '_' + y).addClass('pl' + (p_num.toInt() + 1).toString());
            }
            if (p_num == my_player_num && board_units[id]["moves_left"].toInt() > 0) $('board_' + x + '_' + y).addClass('my-brd-unit');
            //show level star
            if (board_units[id]['experience'] >= units_levels[board_units[id]['unit_id'].toInt()][board_units[id]['level'].toInt() + 1] && x == maxx - 1 && y == oldy) {
                var star = new Element('a', {
                    'html': '',
                    'class': 'level-star',
                    'id': 'star_' + id,
                    'onclick': 'show_levelup(' + id + ');'
                });
                $('overboard_' + x + '_' + y).grab(star, 'bottom');
            }
            //tip
            var myHints = $$('div.unittip' + id);
            myHints.each(function(hint, index) {
                hint.destroy();
            });
            addUnitTip('overboard_' + x + '_' + y, id);
            //unactive
            if (board_units[id]["moves_left"].toInt() == 0 || $chk(board_units[id]["paralich"])) $('board_' + x + '_' + y).getChildren('.unitdiv')[0].fade(unactive_unit);
            else $('board_' + x + '_' + y).getChildren('.unitdiv')[0].fade(1);
        }
}

function add_unit_by_id(id, p_num, x, y, unit_id) {
    if (!players_by_num[p_num]) return 0;
    publish_api_call();
    var check1 = typeof(board_units[id]);
    if (check1 != "undefined") var check2 = typeof(board_units[id]["id"]);
    if (check1 == "undefined" || check2 == "undefined") {
        board_units[id] = new Array();
        board_units[id]["id"] = id;
        board_units[id]["player_num"] = p_num;
        board_units[id]["unit_id"] = unit_id;
        board_units[id]["card_id"] = "";
        board_units[id]["health"] = units[unit_id]["health"];
        board_units[id]["max_health"] = units[unit_id]["health"];
        board_units[id]["attack"] = units[unit_id]["attack"];
        board_units[id]["moves_left"] = units[unit_id]["moves"];
        board_units[id]["moves"] = units[unit_id]["moves"];
        board_units[id]["shield"] = units[unit_id]["shield"];
        board_units[id]["level"] = 0;
        board_units[id]["experience"] = 0;
    }
    var size = units[board_units[id]['unit_id']]["size"].toInt();
    var maxx = x.toInt() + size;
    var maxy = y.toInt() + size;
    var oldy = y;
    var oldx = x;
    for (; x < maxx; x++)
        for (y = oldy; y < maxy; y++) {
            if (!board[x]) board[x] = new Array();
            board[x][y] = new Array();
            board[x][y]["x"] = x;
            board[x][y]["y"] = y;
            board[x][y]["type"] = "unit";
            board[x][y]["ref"] = id;
        }
    x = oldx;
    y = oldy;
    //show
    maxx = x.toInt() + size;
    maxy = y.toInt() + size;
    oldy = y;
    for (; x < maxx; x++)
        for (y = oldy; y < maxy; y++) {
            var sizeClass = '';
            if ((size > 1 && x == (maxx - 1) && y == (maxy - 1)) || size == 1) sizeClass = 'unit_' + units[unit_id]["ui_code"];
            var myDiv = new Element('div', {
                'html': '',
                'class': 'z_4 unitdiv ' + sizeClass
            });
            var myDivOver = new Element('div');
            myDivOver.addEvent('click', function() {
                execute_unit(x - 1, y - 1);
            });
            $('overboard_' + x + '_' + y).grab(myDivOver, 'bottom');
            $('board_' + x + '_' + y).grab(myDiv, 'bottom');
            if (showColorCells.toInt() == 1) { //enabled option to show color cells
                if (p_num >= 10) $('board_' + x + '_' + y).addClass('newtrl');
                else
                    $('board_' + x + '_' + y).addClass('pl' + (p_num.toInt() + 1).toString());
            }
            if (p_num == my_player_num && board_units[id]["moves_left"].toInt() > 0) $('board_' + x + '_' + y).addClass('my-brd-unit');
            //show level star
            if (board_units[id]['experience'] >= units_levels[board_units[id]['unit_id'].toInt()][board_units[id]['level'].toInt() + 1] && x == maxx - 1 && y == oldy) {
                var star = new Element('a', {
                    'html': '',
                    'class': 'level-star',
                    'id': 'star_' + id,
                    'onclick': 'show_levelup(' + id + ');'
                });
                $('overboard_' + x + '_' + y).grab(star, 'bottom');
            }
            //tip
            var myHints = $$('div.unittip' + id);
            myHints.each(function(hint, index) {
                hint.destroy();
            });
            addUnitTip('overboard_' + x + '_' + y, id);
            //unactive
            if (board_units[id]["moves_left"].toInt() == 0 || $chk(board_units[id]["paralich"])) $('board_' + x + '_' + y).getChildren('.unitdiv')[0].fade(unactive_unit);
            else $('board_' + x + '_' + y).getChildren('.unitdiv')[0].fade(1);
        }
}

function kill_unit(x, y, noanim) {
    publish_api_call();
    noanim = noanim || 0;
    var id = board[x][y]["ref"];
    var p_num = board_units[id]['player_num'];
    var el_class = '';
    if (p_num.toInt() >= 10) el_class = 'newtrl';
    else el_class = 'pl' + (p_num.toInt() + 1);
    var size = units[board_units[id]['unit_id']]["size"].toInt();
    clean_shoot_radius(x, y); //in case unit was killed when someone hovered it
    if (!noanim) {
        if (!$('board_' + (x + size - 1) + '_' + (y + size - 1)).getChildren('.unitdiv')[0]) { //unit haven't appeared after move animation
            setTimeout('kill_unit(' + x + ',' + y + ',' + noanim + ');', 2000);
            return 0;
        }
        kill_anims[id] = $('board_' + (x + size - 1) + '_' + (y + size - 1)).getChildren('.unitdiv')[0].clone();
        var pos = $('board_' + (x + size - 1) + '_' + (y + size - 1)).getChildren('.unitdiv')[0].getPosition();
        kill_anims[id].setStyles({
            position: 'absolute',
            left: pos.x,
            top: pos.y
        });
        kill_anims[id].set('morph', {
            duration: 500,
            transition: 'linear',
            link: 'chain',
            onStart: function() {
                no_backlight = true;
            },
            onChainComplete: function() {
                this.element.destroy();
            }
        });
        $('board').grab(kill_anims[id], 'top');
        if (last_moved_unit == 0) {
            kill_anims[id].morph({
                "height": 0,
                "width": 0
            });
            if (move_anims[id])
                move_anims[id].destroy();
        } else
            kill_unit_after_anim[last_moved_unit] = 'kill_anims[' + id + '].morph({"height":0,"width":0});move_anims[' + id + '].destroy();';
    }
    last_moved_unit = 0;
    if (size > 1) { // dragon etc
        board.each(function(items, index) {
            if (items)
                items.each(function(item, index) {
                    if (item)
                        if (item["ref"] == id && item["type"] == 'unit') {
                            removeUnitBoardTip('overboard_' + item['x'] + '_' + item['y'], id);
                            $('board_' + item['x'] + '_' + item['y']).removeClass(el_class);
                            $('board_' + item['x'] + '_' + item['y']).removeClass('my-brd-unit');
                            var unitdiv = $('board_' + item['x'] + '_' + item['y']).getChildren('.unitdiv');
                            unitdiv.each(function(item, index) {
                                if (item) item.destroy();
                            });
                            $('overboard_' + item['x'] + '_' + item['y']).empty();
                            delete board[item['x']][item['y']];
                            for (i = 0; i < units[board_units[id]['unit_id']]["size"].toInt() * units[board_units[id]['unit_id']]["size"].toInt(); i++)
                                $('board_' + item['x'] + '_' + item['y']).removeClass('unit' + board_units[id]['unit_id'] + '_' + i);
                        }
                });
        });
    } else {
        removeUnitBoardTip('overboard_' + x + '_' + y, id);
        $('board_' + x + '_' + y).removeClass(el_class);
        $('board_' + x + '_' + y).removeClass('my-brd-unit');
        var unitdiv = $('board_' + x + '_' + y).getChildren('.unitdiv');
        unitdiv.each(function(item, index) {
            if (item) item.destroy();
        });
        $('overboard_' + x + '_' + y).empty();
        delete board[x][y];
    }
    delete board_units[id];
}

function visual_kill_unit(x, y) {
    publish_api_call();
    var id = board[x][y]["ref"];
    var temp_unit = new Array();
    temp_unit = board_units[id];
    kill_unit(x, y, true);
    board_units[id] = temp_unit;
}

function move_unit(x, y, x2, y2) {
    if (!$chk(board[x]) || !$chk(board[x][y]) || !$chk(board[x][y]['ref'])) {
        return;
    }
    publish_api_call();
    var card_id = '';
    var unit_id = '';
    var id = board[x][y]["ref"];
    last_moved_unit = id;
    var p_num = board_units[id]['player_num'];
    card_id = board_units[id]['card_id'];
    unit_id = board_units[id]['unit_id'];
    var size = units[unit_id]['size'].toInt();
    move_anim(x, y, x2, y2, size);
    visual_kill_unit(x, y);
    if (card_id != '') add_unit_after_anim[id] = "add_unit(" + id + "," + p_num + "," + x2 + "," + y2 + "," + card_id + ");";
    else
        add_unit_after_anim[id] = "add_unit_by_id(" + id + "," + p_num + "," + x2 + "," + y2 + "," + unit_id + ");";

    var maxx = x2.toInt() + size;
    var maxy = y2.toInt() + size;
    for (mx = x2; mx < maxx; mx++)
        for (my = y2; my < maxy; my++) {
            if (!board[mx]) board[mx] = new Array();
            board[mx][my] = new Array();
            board[mx][my]["x"] = mx;
            board[mx][my]["y"] = my;
            board[mx][my]["type"] = "unit";
            board[mx][my]["ref"] = id;
        }
    if (board_units[id]["moves_left"] - 1 > 0 && p_num == my_player_num) {
        if (multiple_action_unit_id != 0 && multiple_action_unit_id == id) {
            path_moves--;
            if (path_moves > 0) {
                after_commands = 'no_backlight = true;';
            } else after_commands = 'no_backlight = false; multiple_action_unit_id = 0;';
        }
    } else
        after_commands = 'no_backlight = false; multiple_action_unit_id = 0;';
}

function move_anim(x, y, x2, y2, size) {
    anim_is_running = true;
    var uid = board[x][y]["ref"];
    if (size > 1) {
        x = x + size - 1;
        y = y + size - 1;
        x2 = x2 + size - 1;
        y2 = y2 + size - 1;
    }
    post_move_anims += "move_anims[" + uid + "].setStyle('opacity',0);";
    if (!$chk(move_anims[uid])) {
        move_anims[uid] = $('board_' + x + '_' + y).getChildren('.unitdiv')[0].clone();
        var pos = $('board_' + x + '_' + y).getChildren('.unitdiv')[0].getPosition();
        move_anims[uid].setStyles({
            position: 'absolute',
            left: pos.x,
            top: pos.y
        });
        move_anims[uid].set('rel', uid);
        move_anims[uid].set('move', {
            duration: 400,
            transition: 'linear',
            link: 'chain',
            onStart: function() {
                no_backlight = true;
            },
            onChainComplete: function() {
                add_unit_after_anim.each(function(item, index) {
                    if (item) {
                        eval(item);
                        //if (players_by_num[my_player_num]['name']=='skoba') console.log(item);
                        delete add_unit_after_anim[index];
                    }
                });
                eval(post_move_anims + after_commands_units);
                var my_id = this.element.get('rel').toInt();
                if (kill_unit_after_anim[my_id]) {
                    eval(kill_unit_after_anim[my_id]);
                    delete kill_unit_after_anim[my_id];
                }
                post_move_anims = '';
                after_commands_units = '';
                last_moved_unit = 0;
                anim_is_running = false;
                no_backlight = false;
            }
        });
        $('board').grab(move_anims[uid], 'top');
    }
    move_anims[uid].setStyle('opacity', 1);
    after_commands_anims += "move_anims[" + uid + "].move({relativeTo: $('board_" + x2 + "_" + y2 + "'),position: 'bottomRight',edge:'bottomRight',offset:{x:1,y:1}});";
}

function deactivate_buy_ressurect_play_card(force) {
    force = force || false;
    if (force || !realtime_cards) {
      deactivate_button($('main_buttons').getChildren('.btn_buycard')[0]);
      $('cards_holder').getChildren().each(function(item, index) {
          if (item) {
              item.fade(unactive_card);
          }
      });
    }
    $('grave_holder').getChildren().each(function(item, index) {
        if (item) {
            item.fade(unactive_card);
        }
    });
}

function building_set_health(x, y, health) {
    publish_api_call();
    var id = board[x][y]["ref"];
    board_buildings[id]["health"] = health;
    //tip
    board.each(function(items, index) {
        if (items)
            items.each(function(item, index) {
                if (item)
                    if (item["ref"] == board[x][y]["ref"] && item["type"] != 'unit') {
                        //tip
                        if (item["type"] == 'castle')
                            addCastleTip('overboard_' + item['x'] + '_' + item['y'], id);
                        else
                            addBuildingTip('overboard_' + item['x'] + '_' + item['y'], id);
                    }
            });
    });
}

function building_set_owner(x, y, p_num, new_income) {
    publish_api_call();
    var id = board[x][y]["ref"];
    var b = board_buildings[id];

    var card_id = '';
    var building_id = '';
    card_id = board_buildings[id]['card_id'];
    building_id = board_buildings[id]['building_id'];
    //get left up corner
    var bx = x;
    var by = y;
    board.each(function(items, index) {
        if (items)
            items.each(function(item, index) {
                if (item)
                    if (item["ref"] == id && item["type"] != "unit") {
                        if (item["x"].toInt() < bx) bx = item["x"].toInt();
                        if (item["y"].toInt() < by) by = item["y"].toInt();
                    }
            });
    });
    visual_destroy_building(x, y);

    board_buildings[id]["player_num"] = p_num;
    board_buildings[id]["income"] = new_income;
    b = board_buildings[id];

    put_building(id, p_num, bx, by, b['rotation'], b['flip'], card_id, b['income']);
}

function move_building(old_x, old_y, new_x, new_y, new_rotation, new_flip, new_income) {
    publish_api_call();
    var id = board[old_x][old_y]["ref"];
    var bl = board_buildings[id];

    var card_id = '';
    var building_id = '';
    card_id = board_buildings[id]['card_id'];
    building_id = board_buildings[id]['building_id'];
    visual_destroy_building(old_x, old_y);

    board_buildings[id]["rotation"] = new_rotation;
    board_buildings[id]["flip"] = new_flip;
    board_buildings[id]["income"] = new_income;
    put_building(id, bl['player_num'], new_x, new_y, new_rotation, new_flip, card_id, new_income);
}

function visual_destroy_building(x, y) {
    publish_api_call();
    var id = board[x][y]["ref"];
    var temp_building = new Array();
    temp_building = board_buildings[id];
    destroy_building(x, y);
    board_buildings[id] = temp_building;
}

function destroy_building(x, y) {
    publish_api_call();
    var id = board[x][y]["ref"];

    var p_num = board_buildings[id]['player_num'];
    var b = buildings[board_buildings[id]["building_id"]];

    clean_radius(x, y, b["radius"], b["x_len"], b["y_len"]);
    var el_class = '';
    if (p_num.toInt() >= 10) el_class = 'newtrl';
    else el_class = 'pl' + (p_num.toInt() + 1);
    if (buildings[board_buildings[id]['building_id']]["shape"].toInt() != 1) { // lake etc.
        board.each(function(items, index) {
            if (items)
                items.each(function(item, index) {
                    if (item)
                        if (item["ref"] == id && item["type"] != 'unit') {
                            $('board_' + item['x'] + '_' + item['y']).removeClass(el_class);
                            $('board_' + item['x'] + '_' + item['y']).removeClass('brd-building');
                            var buildingdiv = $('board_' + item['x'] + '_' + item['y']).getChildren('.buildingdiv');
                            buildingdiv.each(function(item, index) {
                                buildingdiv.destroy();
                            });
                            $('overboard_' + item['x'] + '_' + item['y']).empty();
                            delete board[item['x']][item['y']];
                            removeBuildingTip('overboard_' + item['x'] + '_' + item['y'], id);
                        }
                });
        });
    } else {
        $('board_' + x + '_' + y).removeClass(el_class);
        $('board_' + x + '_' + y).removeClass('brd-building');
        var buildingdiv = $('board_' + x + '_' + y).getChildren('.buildingdiv');
        buildingdiv.each(function(item, index) {
            buildingdiv.destroy();
        });
        $('overboard_' + x + '_' + y).empty();
        delete board[x][y];
        removeBuildingTip('overboard_' + x + '_' + y, id);
    }
    delete board_buildings[id];
}

function put_building(id, p_num, x, y, nrotation, nflip, card_id, income) {
    publish_api_call();
    var check1 = typeof(board_buildings[id]);
    if (check1 != "undefined") var check2 = typeof(board_buildings[id]["id"]);
    if (check1 == "undefined" || check2 == "undefined") {
        board_buildings[id] = new Array();
        board_buildings[id]["id"] = id;
        board_buildings[id]["building_id"] = cards[card_id]["ref"];
        board_buildings[id]["player_num"] = p_num;
        board_buildings[id]["health"] = buildings[cards[card_id]["ref"]]["health"];
        board_buildings[id]["max_health"] = buildings[cards[card_id]["ref"]]["health"];
        board_buildings[id]["radius"] = buildings[cards[card_id]["ref"]]["radius"];
        board_buildings[id]["vamp"] = "0";
        board_buildings[id]["card_id"] = card_id;
        board_buildings[id]["income"] = income;
        board_buildings[id]["rotation"] = nrotation;
        board_buildings[id]["flip"] = nflip;
    }
    var b = buildings[board_buildings[id]["building_id"]];
    put_radius(x, y, b["radius"], b["x_len"], b["y_len"]);

    var i = 0;
    var mflip = 0;
    var x_0 = 0;
    var y_0 = 0;
    var mx = 0;
    var my = 0;
    if (nflip.toInt() == 0) mflip = 1;
    else mflip = -1;
    if (nrotation.toInt() == 0) {
        i = 0;
        if (mflip == 1) x_0 = x.toInt();
        else x_0 = x.toInt() + b["x_len"].toInt() - 1;
        y_0 = y.toInt();
        while (i < b["x_len"].toInt() * b["y_len"].toInt()) { /*цикл по строке shape в поисках единичек*/
            if (b['shape'].slice(i, i + 1) == '1') {
                mx = x_0.toInt() + mflip * (i % b["x_len"].toInt()); /*тут подставляются в @x,@y координаты этой "единички", если флип, х идет в обратную сторону*/
                my = y_0.toInt() + Math.floor(i / b["x_len"].toInt());
                add_building_cell(id, p_num, mx, my, b, card_id, nrotation, nflip, i);
            }
            i++;
        }
    } else
    if (nrotation.toInt() == 1) {
        i = 0;
        if (mflip.toInt() == 1) x_0 = x.toInt() + b["y_len"].toInt() - 1;
        else x_0 = x.toInt();
        y_0 = y.toInt();
        while (i < b["x_len"].toInt() * b["y_len"].toInt()) { /*цикл по строке shape в поисках единичек*/
            if (b['shape'].slice(i, i + 1) == '1') {
                mx = x_0.toInt() - mflip * Math.floor(i / b["x_len"].toInt()); /*тут подставляются в @x,@y координаты этой "единички", если флип, х идет в обратную сторону*/
                my = y_0.toInt() + (i % b["x_len"].toInt());
                add_building_cell(id, p_num, mx, my, b, card_id, nrotation, nflip, i);
            }
            i++;
        }
    } else
    if (nrotation.toInt() == 2) {
        i = 0;
        if (mflip.toInt() == 1) x_0 = x.toInt() + b["x_len"].toInt() - 1;
        else x_0 = x.toInt();
        y_0 = y.toInt() + b["y_len"].toInt() - 1;
        while (i < b["x_len"].toInt() * b["y_len"].toInt()) { /*цикл по строке shape в поисках единичек*/
            if (b['shape'].slice(i, i + 1) == '1') {
                mx = x_0.toInt() - mflip * (i % b["x_len"].toInt()); /*тут подставляются в @x,@y координаты этой "единички", если флип, х идет в обратную сторону*/
                my = y_0.toInt() - Math.floor(i / b["x_len"].toInt());
                add_building_cell(id, p_num, mx, my, b, card_id, nrotation, nflip, i);
            }
            i++;
        }
    } else
    if (nrotation.toInt() == 3) {
        i = 0;
        if (mflip.toInt() == 1) x_0 = x.toInt();
        else x_0 = x.toInt() + b["y_len"].toInt() - 1;
        y_0 = y.toInt() + b["x_len"].toInt() - 1;
        while (i < b["x_len"].toInt() * b["y_len"].toInt()) { /*цикл по строке shape в поисках единичек*/
            if (b['shape'].slice(i, i + 1) == '1') {
                mx = x_0.toInt() + mflip * Math.floor(i / b["x_len"].toInt()); /*тут подставляются в @x,@y координаты этой "единички", если флип, х идет в обратную сторону*/
                my = y_0.toInt() - (i % b["x_len"].toInt());
                add_building_cell(id, p_num, mx, my, b, card_id, nrotation, nflip, i);
            }
            i++;
        }
    }
}

function put_building_by_id(id, p_num, x, y, nrotation, nflip, card_id, income) {
    publish_api_call();
    var check1 = typeof(board_buildings[id]);
    if (check1 != "undefined") var check2 = typeof(board_buildings[id]["id"]);
    if (check1 == "undefined" || check2 == "undefined") {
        board_buildings[id] = new Array();
        board_buildings[id]["id"] = id;
        board_buildings[id]["building_id"] = card_id;
        board_buildings[id]["player_num"] = p_num;
        board_buildings[id]["health"] = buildings[card_id]["health"];
        board_buildings[id]["max_health"] = buildings[card_id]["health"];
        board_buildings[id]["radius"] = buildings[card_id]["radius"];
        board_buildings[id]["vamp"] = "0";
        board_buildings[id]["card_id"] = "";
        board_buildings[id]["income"] = income;
        board_buildings[id]["rotation"] = nrotation;
        board_buildings[id]["flip"] = nflip;
    }
    var b = buildings[board_buildings[id]["building_id"]];
    put_radius(x, y, b["radius"], b["x_len"], b["y_len"]);

    var i = 0;
    var mflip = 0;
    var x_0 = 0;
    var y_0 = 0;
    var mx = 0;
    var my = 0;
    if (nflip.toInt() == 0) mflip = 1;
    else mflip = -1;
    if (nrotation.toInt() == 0) {
        i = 0;
        if (mflip == 1) x_0 = x.toInt();
        else x_0 = x.toInt() + b["x_len"].toInt() - 1;
        y_0 = y.toInt();
        while (i < b["x_len"].toInt() * b["y_len"].toInt()) { /*цикл по строке shape в поисках единичек*/
            if (b['shape'].slice(i, i + 1) == '1') {
                mx = x_0.toInt() + mflip * (i % b["x_len"].toInt()); /*тут подставляются в @x,@y координаты этой "единички", если флип, х идет в обратную сторону*/
                my = y_0.toInt() + Math.floor(i / b["x_len"].toInt());
                add_building_cell(id, p_num, mx, my, b, card_id, nrotation, nflip, i);
            }
            i++;
        }
    } else
    if (nrotation.toInt() == 1) {
        i = 0;
        if (mflip.toInt() == 1) x_0 = x.toInt() + b["y_len"].toInt() - 1;
        else x_0 = x.toInt();
        y_0 = y.toInt();
        while (i < b["x_len"].toInt() * b["y_len"].toInt()) { /*цикл по строке shape в поисках единичек*/
            if (b['shape'].slice(i, i + 1) == '1') {
                mx = x_0.toInt() - mflip * Math.floor(i / b["x_len"].toInt()); /*тут подставляются в @x,@y координаты этой "единички", если флип, х идет в обратную сторону*/
                my = y_0.toInt() + (i % b["x_len"].toInt());
                add_building_cell(id, p_num, mx, my, b, card_id, nrotation, nflip, i);
            }
            i++;
        }
    } else
    if (nrotation.toInt() == 2) {
        i = 0;
        if (mflip.toInt() == 1) x_0 = x.toInt() + b["x_len"].toInt() - 1;
        else x_0 = x.toInt();
        y_0 = y.toInt() + b["y_len"].toInt() - 1;
        while (i < b["x_len"].toInt() * b["y_len"].toInt()) { /*цикл по строке shape в поисках единичек*/
            if (b['shape'].slice(i, i + 1) == '1') {
                mx = x_0.toInt() - mflip * (i % b["x_len"].toInt()); /*тут подставляются в @x,@y координаты этой "единички", если флип, х идет в обратную сторону*/
                my = y_0.toInt() - Math.floor(i / b["x_len"].toInt());
                add_building_cell(id, p_num, mx, my, b, card_id, nrotation, nflip, i);
            }
            i++;
        }
    } else
    if (nrotation.toInt() == 3) {
        i = 0;
        if (mflip.toInt() == 1) x_0 = x.toInt();
        else x_0 = x.toInt() + b["y_len"].toInt() - 1;
        y_0 = y.toInt() + b["x_len"].toInt() - 1;
        while (i < b["x_len"].toInt() * b["y_len"].toInt()) { /*цикл по строке shape в поисках единичек*/
            if (b['shape'].slice(i, i + 1) == '1') {
                mx = x_0.toInt() + mflip * Math.floor(i / b["x_len"].toInt()); /*тут подставляются в @x,@y координаты этой "единички", если флип, х идет в обратную сторону*/
                my = y_0.toInt() - (i % b["x_len"].toInt());
                add_building_cell(id, p_num, mx, my, b, card_id, nrotation, nflip, i);
            }
            i++;
        }
    }
}

function put_radius(x, y, radius, x_len, y_len) {
    publish_api_call();
    var mx = 0;
    var my = 0;
    if (radius > 0) {
        for (mx = x.toInt() - radius.toInt(); mx < x.toInt() + radius.toInt() + x_len.toInt(); mx++)
            for (my = y.toInt() - radius.toInt(); my < y.toInt() + radius.toInt() + y_len.toInt(); my++) {
                myDiv = new Element('div', {
                    'html': '',
                    'class': 'z_1 glow'
                });
                if ($('board_' + mx + '_' + my))
                    $('board_' + mx + '_' + my).grab(myDiv, 'bottom');
            }
    }
}

function clean_radius(x, y, radius, x_len, y_len) {
    publish_api_call();
    var mx = 0;
    var my = 0;
    if (radius > 0) {
        for (mx = x.toInt() - radius.toInt(); mx < x.toInt() + radius.toInt() + x_len.toInt(); mx++)
            for (my = y.toInt() - radius.toInt(); my < y.toInt() + radius.toInt() + y_len.toInt(); my++) {
                if ($('board_' + mx + '_' + my)) {
                    var glowdiv = $('board_' + mx + '_' + my).getChildren('.glow');
                    if (glowdiv[0]) glowdiv[0].destroy();
                }
            }
    }
}

function add_building_cell(id, p_num, mx, my, b, card_id, nrotation, nflip, i) {
    publish_api_call();
    if (!board[mx]) board[mx] = new Array();
    board[mx][my] = new Array();
    board[mx][my]["x"] = mx;
    board[mx][my]["y"] = my;
    board[mx][my]["type"] = b["type"];
    board[mx][my]["ref"] = id;
    var tree_class = "";
    if (b["ui_code"] == 'tree') tree_class = "tree_" + (mx % 3) + "_" + (my % 3);
    var myDiv = new Element('div', {
        'html': '',
        'class': 'building z_4 buildingdiv ' + tree_class + ' building_' + buildings[board_buildings[id]['building_id']]['ui_code'] + ' building_' + buildings[board_buildings[id]['building_id']]['ui_code'] + '_' + nrotation + '_' + nflip + '_' + i,
        styles: {
            opacity: 0
        }
    });
    var myDivOver = new Element('div');
    myDivOver.addEvent('click', function() {
        execute_building(mx, my);
    });
    if (b["type"] == 'castle') myDiv.addClass('castle_' + mx + '_' + my);
    if (b["ui_code"] == 'ruins') myDiv.addClass('ruins_' + mx + '_' + my);
    //else
    //$('board_'+mx+'_'+my).set('html','');
    $('board_' + mx + '_' + my).grab(myDiv, 'bottom');
    $('overboard_' + mx + '_' + my).grab(myDivOver, 'bottom');
    if (showColorCells.toInt() == 1 && b["type"] != 'obstacle') { //enabled option to show color cells
        $('board_' + mx + '_' + my).addClass('pl' + (p_num.toInt() + 1).toString());
    }
    $('board_' + mx + '_' + my).addClass('brd-building');
    //tip
    var myHints = $$('div.buildtip' + id);
    myHints.each(function(hint, index) {
        hint.destroy();
    });
    if (b["type"] == 'castle')
        addCastleTip('overboard_' + mx + '_' + my, id);
    else if (b["ui_code"]== 'ruins')
        addRuinsTip('overboard_' + mx + '_' + my, id);
    else
        addBuildingTip('overboard_' + mx + '_' + my, id);
    myDiv.fade('in');
}

function add_to_grave(grave_id, card_id, x, y, size, turn_when_killed) {
    publish_api_call();
    turn_when_killed = turn_when_killed || active_players['turn'];
    var myDiv = new Element('div', {
        'html': '',
        'class': 'dead_unit',
        'id': 'dead_unit' + grave_id,
        styles: {
            opacity: (turn_when_killed.toInt() == active_players['turn'].toInt()) ? '0.5' : '1.0'
        },
        'onclick': 'if (game_state=="WAITTING") execute_resurrect(' + grave_id + '); else param_clicked(this); hide_grave(' + grave_id + ',' + x + ',' + y + ',' + size + ');return false;'
    }); //create div with dead_unit
    var myImg = new Element('img', {
        'src': '../../design/images/cards/' + cards[card_id]['image'],
        'alt': card_name(card_id)
    });
    myDiv.grab(cardTitleDiv(card_id), 'bottom');
    myDiv.grab(cardPriceDiv(cards[card_id]['cost'].toInt() * 2), 'bottom');
    myDiv.grab(myImg, 'bottom');
    //myDiv.addEvent('click', function(){param_clicked($('dead_unit'+card_id));});
    myDiv.addEvent('mouseenter', function() {
        show_grave(grave_id, x, y, size);
    });
    myDiv.addEvent('mouseleave', function() {
        hide_grave(grave_id, x, y, size);
    });
    myDiv.addEvent('click', function() {
        if (game_state == "WAITTING") execute_resurrect(grave_id);
        else param_clicked(myDiv);
        hide_grave(grave_id, x, y, size);
        return false;
    });
    $('grave_holder').grab(myDiv, 'bottom');
    addCardTip('dead_unit' + grave_id, card_id);
    var graveDiv = new Element('div', {
        'class': 'grave z_3 grave_' + units[cards[card_id]['ref']]['ui_code'],
        'id': 'grave' + grave_id + '_' + x + '_' + y,
        styles: {
            display: 'none'
        }
    });
    $('board_' + x + '_' + y).grab(graveDiv, 'bottom');
    vwGrave[grave_id] = new Array();
    vwGrave[grave_id]["card_id"] = card_id;
    vwGrave[grave_id]["x"] = x;
    vwGrave[grave_id]["y"] = y;
    vwGrave[grave_id]["size"] = size;
    if (graveCarousel)
        graveCarousel.toLast();
    if (turn_state == NOT_MY_TURN) myDiv.fade(unactive_card);
    //all cards view is opened and grave
    if (allCardsSlider.open && $('graveLink').hasClass('cementary')) {
        var newItem = myImg.clone().cloneEvents(myDiv);
        $('fullsize_holder').grab(newItem);
        if (turn_state == NOT_MY_TURN) newItem.fade(unactive_card);
    }
}

function show_grave(grave_id, x, y, size) {
    publish_api_call();
    $('grave' + grave_id + '_' + x + '_' + y).setStyle('display', 'block');
}

function hide_grave(grave_id, x, y, size) {
    publish_api_call();
    $('grave' + grave_id + '_' + x + '_' + y).setStyle('display', 'none');
}

function show_all_graves() {
    publish_api_call();
    vwGrave.each(function(item, index) {
        if (item) {
            show_grave(index, item['x'], item['y'], item['size']);
        }
    });
}

function hide_all_graves() {
    publish_api_call();
    vwGrave.each(function(item, index) {
        if (item) {
            hide_grave(index, item['x'], item['y'], item['size']);
        }
    });
}

function remove_from_grave(grave_id) {
    publish_api_call();
    removeBoardTip('dead_unit' + grave_id);
    $('dead_unit' + grave_id).destroy();
    $('grave' + grave_id + '_' + vwGrave[grave_id]['x'] + '_' + vwGrave[grave_id]['y']).destroy();
    delete vwGrave[grave_id];
    hideSliders();
    graveCarousel.toFirst();
}

function addUnitTip(dom_id, id) {
    var effects = '';
    var moves = '';
    var p_num = board_units[id]['player_num'];
    var unit_id = board_units[id]['unit_id'];
    var shield = '';
    var gold = '';
    var player_class = '';
    var next_level_exp = units_levels[unit_id][1];
    var cur_exp_level = board_units[id]["experience"].toInt();
    if (board_units[id]["level"].toInt() > 0 && board_units[id]["level"].toInt() < mode_config["max_unit_level"]) {
        next_level_exp = units_levels[unit_id][board_units[id]["level"].toInt() + 1] - units_levels[unit_id][board_units[id]["level"].toInt()];
        cur_exp_level = board_units[id]["experience"].toInt() - units_levels[unit_id][board_units[id]["level"].toInt()];
    }

    var exp_width = exp_width = Math.round(70 * cur_exp_level / next_level_exp);
    if (board_units[id]["level"].toInt() >= mode_config["max_unit_level"])
        exp_width = 0;
    if (exp_width > 70) exp_width = 70;
    if (p_num.toInt() >= 10) {
        gold = '<li class="income"><font color="white">-&nbsp;&nbsp;' + players_by_num[p_num]["gold"] + '</font></li>';
        player_class = 'newtrl';
    } else {
        gold = '';
        player_class = 'pl' + (p_num.toInt() + 1).toString();
    }
    if (board_units[id]["shield"].toInt() > 0) {
        shield = '<li class="shield"><font color="white">-&nbsp;&nbsp;' + board_units[id]["shield"] + '</font></li>';
    } else {
        shield = '';
    }
    //check for features
    unit_features.each(function(item, index) {
        if (item) {
            if ($chk(board_units[id][item['code']]))
                if (unit_feature_description(item['id']))
                    effects += unit_feature_description(item['id']) + '<br />'
        }
    });
    var unitDisplayName;
    var playerDisplayName;
    if (p_num.toInt() >= 10) {
        unitDisplayName = npc_player_name(players_by_num[p_num]["name"]);
        playerDisplayName = 'NPC';
    } else {
        unitDisplayName = unit_name(unit_id);
        playerDisplayName = players_by_num[p_num]["name"];
    }

    moves = board_units[id]["moves_left"] + '/' + board_units[id]["moves"];
    addBoardTip(dom_id, '<table><tr><td><p class="con_img"><span><img src="../../design/images/units/' + units[unit_id]['ui_code'] + '.png"></span></p></td>' +
        '<td><ul>' +
        '<li class="name">' + unitDisplayName + ' (<font color="white" face="Arial">' + playerDisplayName + '</font>)</li>' +
        '<li class="level"><span class="lvl">' + board_units[id]["level"] + '</span> <span class="full_exp"><span class="cur_exp" style="width:' + exp_width + 'px;"></span></span></li>' +
        '<li class="attk">-&nbsp;&nbsp;' + board_units[id]["attack"] + '</li>' +
        '<li class="health">-&nbsp;&nbsp;' + board_units[id]["health"] + '/' + board_units[id]["max_health"] + '</li>' +
        '<li class="move">-&nbsp;&nbsp;' + moves + '</li>' + gold + shield + '</ul></td></tr></table>',
        effects + '<p class="' + player_class + '"></p><p style="padding:4px 7px 5px 7px;">' + unit_description(unit_id) + '</p>', 'hintTip unittip' + id);
}

function addBuildingTip(dom_id, id) {
    var building_id = board_buildings[id]['building_id'];
    var image = buildings[building_id]['ui_code'] + '.png';
    addBaseBuildingTip(dom_id, id, image);
}

function addRuinsTip(dom_id, id) {
    var p_num = board_buildings[id]['player_num'];
    var image = 'ruins_' + p_num + '.png';
    addBaseBuildingTip(dom_id, id, image);
}

function addBaseBuildingTip(dom_id, id, image) {
    var effects = '';
    var building_id = board_buildings[id]['building_id'];
    var p_num = board_buildings[id]['player_num'];
    var playerInfo = '';
    if ($chk(players_by_num[p_num])) {
        playerInfo = ' (<font color="white" face="Arial">' + players_by_num[p_num]['name'] + '</font>)';
    }
    var b_name = building_name(building_id) + playerInfo;
    var b_health = board_buildings[id]["health"];
    var b_max_health = board_buildings[id]["max_health"];
    var b_income =  board_buildings[id]["income"];
    addBoardTip(dom_id, '<table><tr><td><p class="con_img"><span><img src="../../design/images/buildings/' +
        image + '"></span></p></td><td><ul>' +
        '<li class="name">' + b_name + '</li>' +
        (b_health.toInt() != 0 && b_max_health.toInt() != 0 ? '<li class="health">-&nbsp;&nbsp;' + b_health + '/' + b_max_health + '</li>' : '') +
        (b_income.toInt() > 0 ? '<li class="income"><font color="white">-&nbsp;&nbsp;' + b_income + '</font></li>' : '') +
        '</ul></td></tr></table>', '<p class="pl' + (p_num.toInt() + 1).toString() + '"></p>' +
        '<p style="padding:4px 7px 5px 7px;">' + effects + building_description(building_id) + '</p>', 'hintTip buildtip' + id);
}

function addCastleTip(dom_id, id) {
    var building_id = board_buildings[id]['building_id'];
    var p_num = board_buildings[id]['player_num'];
    addBoardTip(dom_id, '<table><tr><td><p class="con_img"><span><img src="../../design/images/buildings/castle_' + p_num + '.png"></span></p></td><td><ul>' +
        '<li class="name">' + building_name(building_id) + ' (<font color="white" face="Arial">' + players_by_num[p_num]["name"] + '</font>)</li>' +
        '<li class="health">-&nbsp;&nbsp;' + board_buildings[id]["health"] + '/' + board_buildings[id]["max_health"] + '</li>' +
        '<li class="income"><font color="white">-&nbsp;&nbsp;' + players_by_num[p_num]["gold"] + '</font></li>' +
        '</ul></td></tr></table>', '<p class="pl' + (p_num.toInt() + 1).toString() + '"></p>' +
        '<p style="padding:4px 7px 5px 7px;">' + building_description(building_id) + '</p>', 'hintTip castletip' + id);
}

function addCardTip(dom_id, card_id) {
    var id = cards[card_id]['ref'];
    var p_num = my_player_num;
    switch (cards[card_id]['type']) {
        case 'b':
            addBoardTip(dom_id, '<table><tr><td><p class="con_img"><span><img src="../../design/images/buildings/' + buildings[id]['ui_code'] + '.png"></span></p></td><td><ul><li class="name">' + card_name(card_id) + '</li><li class="health">-&nbsp;&nbsp;' + buildings[id]["health"] + '</li><li class="radius"><font color="white">-&nbsp;&nbsp;' + buildings[id]["radius"] + '</font></li></ul></td></tr></table>', '<p class="pl' + (p_num.toInt() + 1).toString() + '"></p><p style="padding:4px 7px 5px 7px;">' + card_description(card_id) + building_description(id) + '</p>', 'hintTip');
            break;
        case 'u':
            var shield = '';
            if (units[id]["shield"].toInt() > 0) {
                shield = '<li class="shield"><font color="white">-&nbsp;&nbsp;' + units[id]["shield"] + '</font></li>';
            } else {
                shield = '';
            }
            addBoardTip(dom_id, '<table><tr><td><p class="con_img"><span><img src="../../design/images/units/' + units[id]['ui_code'] + '.png"></span></p></td><td><ul><li class="name">' + card_name(card_id) + '</li><li class="attk">-&nbsp;&nbsp;' + units[id]["attack"] + '</li><li class="health">-&nbsp;&nbsp;' + units[id]["health"] + '</li><li class="move">-&nbsp;&nbsp;' + units[id]["moves"] + '</li>' + shield + '</ul></td></tr></table>', '<p class="pl' + (p_num.toInt() + 1).toString() + '"></p><p style="padding:4px 7px 5px 7px;">' + card_description(card_id) + unit_description(id) + '</p>', 'hintTip');
            break;
        case 'm':
        case 'e':
            addBoardTip(dom_id, '<table><tr><td><p class="con_img"><span><img src="../../design/images/cards/' + cards[card_id]['image'] + '" height="50"></span></p></td><td><ul><li class="name">' + card_name(card_id) + '</li></ul></td></tr></table>', '<p class="pl' + (p_num.toInt() + 1).toString() + '"></p><p style="padding:4px 7px 5px 7px;">' + card_description(card_id) + '</p>', 'hintTip');
            break;
    }
}

function addBoardTip(id, title, text, classN) {
    $(id).store('tip:title', title);
    $(id).store('tip:text', text);
    infoTips[id] = new Tips($$('#' + id), {
        className: classN,
        onShow: function(tip, el) {
            if (!anim_is_running && typeof tip.setStyle == 'function') {
                if (showHint && !no_backlight) {
                    if (tip)
                        tip.setStyle('display', 'block');
                } else if (tip) tip.setStyle('display', 'none');;
                if (tip) {
                    tip.getChildren('div table tr td .con_img img')[0].addEvent('load', function() {
                        this.getParent().getParent().getParent().getParent().getParent().getParent().getParent().getParent().setStyle('width', this.getParent().getParent().getStyle('width').toInt() + 100);
                    });
                    tip.getChildren('div')[1].setStyle('width', tip.getChildren('div table tr td .con_img')[0].getStyle('width').toInt() + 100);
                }
            }
        }
    });
}

function removeBoardTip(id) {
    $(id).store('tip:title', '');
    $(id).store('tip:text', '');
    if ($chk(infoTips[id])) {
        infoTips[id].hide();
        infoTips[id].detach($$('#' + id));
    }
}

function removeUnitBoardTip(id, unit_id) {
    $(id).store('tip:title', '');
    $(id).store('tip:text', '');
    if ($chk(infoTips[id])) {
        if (typeof infoTips[id].detach == 'function') {
            infoTips[id].hide();
            infoTips[id].detach($(id));
        }
    }
    var myHints = $$('div.unittip' + unit_id);
    myHints.each(function(hint, index) {
        if (hint) hint.destroy();
    });
    // very stupid fix, but I cannot spend anymore time on this bug. it makes me crazy
    setTimeout(function() {
        var myHints = $$('div.unittip' + unit_id);
        myHints.each(function(hint, index) {
            if (hint) hint.destroy();
        });
    },1000);
}

function removeBuildingTip(id, b_id) {
    $(id).store('tip:title', '');
    $(id).store('tip:text', '');
    if ($chk(infoTips[id])) {
        infoTips[id].hide();
        infoTips[id].detach($$('#' + id));
    }
    var myHints = $$('div.buildtip' + b_id);
    myHints.each(function(hint, index) {
        hint.destroy();
    });
    myHints = $$('div.castletip' + b_id);
    myHints.each(function(hint, index) {
        hint.destroy();
    });
}

function play_video(code, file_name, loop) {
    publish_api_call();
    var obj = new Element('video', {
        'src': '../../design/video/' + file_name,
        'width': 480,
        'height': 270,
        'autoplay': true
    });
    if (loop) {
        obj.loop = 'loop';
    } else {
        obj.onended = doCancel;
    }
    $('window_c').grab(obj, 'bottom');
    $('window_h').set('text', video_title(code));
    $('window_c').setStyle('width', 500);
    $('window_c').setStyle('height', 310);
    $('window_m').setStyle('display', 'block');
    $('window_w').position();
}

function play_sound(file_name) {
    var snd = new Audio('../../design/sounds/' + file_name);
    snd.play();
}

function end_game() {
    publish_api_call();
    cancel_execute();
    localStorage.removeItem("saved_messages_" + game_info["game_id"] + "_" + my_player_num);
    clearTimeout(remindMoveTimer);
    clearInterval(shieldInterval);
    clearInterval(titleInterval);
    turn_state = NOT_MY_TURN;
    deactivate_controls(true);
    var text = '<a href="#" onclick="get_stats();return false;">' + i18n[USER_LANGUAGE]['game']['show_statistic'] + '</a><br><a href="#" onclick="execute_exit();return false;">' + i18n[USER_LANGUAGE]['game']['exit'] + '</a>';
    noCloseWindow = true;
    if ($('window_m').getStyle('display') == 'block')
        appendWindow(i18n[USER_LANGUAGE]['game']['game_end'], text, 500, 310, true);
    else
        showWindow(i18n[USER_LANGUAGE]['game']['game_end'], text, 200, 200, true);
}

function get_stats() {
    publish_api_call();
    parent.WSClient.getGameStatistic();
}

function show_stats(data) {
    publish_api_call();
    try {
        eval(data);
        myDiv = $('window_c');
        $('window_c').set('html', '');
        var myUl = new Element('ul', {
            'class': 'tabs_title'
        });
        myDiv.grab(myUl, 'top');
        statistic.each(function(item, index) {
            if (item) {
                var myLi = new Element('li', {
                    'title': 'tab' + index,
                    'html': statistics_names[[USER_LANGUAGE]][item['tab_name']]['text']
                });
                myUl.grab(myLi, 'bottom');
                var myPanel = new Element('div', {
                    'id': 'tab' + index,
                    'class': 'tabs_panel'
                });
                myDiv.grab(myPanel, 'bottom');
                item['charts'].each(function(chart_item, chart_index) {
                    if (chart_item) {
                        var myGraph = new Element('div', {
                            'id': 'chart-cont-' + chart_index,
                            'styles': {
                                'width': 300,
                                'height': 180
                            }
                        });
                        myPanel.grab(myGraph, 'bottom');
                        if (chart_item['chart_type'] != 'cardlist') {
                            var myChart = new Element('canvas', {
                                'id': 'chart-' + chart_index,
                            });
                            myGraph.grab(myChart, 'bottom');
                        }
                    }
                });
            }
        });
        var statTabs = new Tabs('statistics');
        var myA2 = new Element('a', {
            'html': i18n[USER_LANGUAGE]['game']['exit'],
            'href': '#',
            'onclick': 'execute_exit();return false;'
        });
        myDiv.grab(myA2, 'bottom');
        $('window_h').set('text', i18n[USER_LANGUAGE]['game']['statistics']);
        $('window_c').setStyle('width', 630);
        $('window_c').setStyle('height', 450);
        $('window_m').setStyle('display', 'block');
        $('window_w').position();

        statistic.each(function(item, index) {
            if (item) {
                item['charts'].each(function(chart_item, chart_index) {
                    if (chart_item) {
                        drawChart(chart_index, chart_item);
                    }
                });
            }
        });
    } catch (e) {
        wasError = true;
        if (DEBUG_MODE) {
            displayLordsError(e, data + '<br />Last executed_procedure:' + last_executed_procedure + '<br />Last API:' + last_executed_api);
        }
    }
}

function drawChart(chart_id, chart) {
    var title = statistics_names[[USER_LANGUAGE]][chart['chart_name']]['text'].replace('{player_name}', chart['player_name']);
    if (chart['chart_type'] == 'cardlist') {
        var title = new Element('h5', {
            'text': title
        });
        $('chart-cont-' + chart_id).grab(title, 'bottom');
        var cards = '';
        chart['values'].each(function(item, index) {
            if (item) {
                cards += '<li id="cardlist-' + chart_id + '-' + item['value'] + '" style="color:' + dic_colors[item['color']]['color'] + ';">' + card_names[USER_LANGUAGE][item['value']]['name'] + '</li>';
            }
        });
        var list = new Element('ul', {
            'html': cards
        });
        $('chart-cont-' + chart_id).grab(list, 'bottom');
        // add tips
        chart['values'].each(function(item, index) {
            if (item) {
                addCardTip('cardlist-' + chart_id + '-' + item['value'], item['value'])
            }
        });
    } else {
        var data = new Array();
        var labels = new Array();
        var colors = new Array();
        var yAxesScale = [{
            ticks: {
                beginAtZero: true
            }
        }]
        if (chart['chart_type'] == 'pie') {
            yAxesScale = [];
        }
        chart['values'].each(function(item, index) {
            if (item) {
                data.push(parseFloat(item['value']));
                label = item['value_name'];
                if (label.startsWith('{')) {
                    label = label.replace(label, statistics_names[[USER_LANGUAGE]][label]['text'])
                }
                labels.push(label);
                colors.push(dic_colors[item['color']]['color']);
            }
        });
        var ctx = document.getElementById("chart-" + chart_id).getContext('2d');
        var myChart = new Chart(ctx, {
            type: chart['chart_type'],
            data: {
                labels: labels,
                datasets: [{
                    data: data,
                    backgroundColor: colors
                }]
            },
            options: {
                title: {
                    display: true,
                    text: title
                },
                legend: {
                    display: false,
                },
                scales: {
                    yAxes: yAxesScale
                }
            }
        });
    }
}

function linkify(inputText) {
    var replacedText, replacePattern1, replacePattern2, replacePattern3;

    //URLs starting with http://, https://, or ftp://
    replacePattern1 = /(\b(https?|ftp):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/gim;
    replacedText = inputText.replace(replacePattern1, '<a target="_blank" href="$1" target="_blank">$1</a>');

    //URLs starting with "www." (without // before it, or it'd re-link the ones done above).
    replacePattern2 = /(^|[^\/])(www\.[\S]+(\b|$))/gim;
    replacedText = replacedText.replace(replacePattern2, '$1<a target="_blank" href="http://$2" target="_blank">$2</a>');

    //Change email addresses to mailto:: links.
    replacePattern3 = /(\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,6})/gim;
    replacedText = replacedText.replace(replacePattern3, '<a target="_blank" href="mailto:$1">$1</a>');

    return replacedText;
}

function chat_add_user_message(p_num, message) {
    publish_api_call();
    if ($chk(players_by_num[p_num])) {
        var nick = players_by_num[p_num]['name'];
    } else {
        var nick = $('spec_' + p_num).get('html');
    }
    var color = "#ffffff";
    if (p_num < 4) color = dic_colors['chat_p' + p_num]['color'];
    else
        color = dic_colors['chat_spectator']['color'];
    var time = new Date();
    time = time.format('db');

    message = message.replace(/\*([^\s\*]+)\*/g, "<img src=\"../../design/images/pregame/smiles/Animated22/$1.gif\" />").replace(/\n/g, "<br>");
    message = linkify(message);
    var message_str = '<span><span class="mes"><p style="color:' + color + '">' + nick + '[' + time + ']</p><span>' + message + '</span></span></span>';
    var els = Elements.from(message_str);
    $('game_chat').adopt(els);

    var scroll = $('game_chat').getScrollSize();
    $('game_chat').scrollTo(0, scroll.y);

    var len = saved_chat_messages.push(message_str);
    if (len > 10) {
        saved_chat_messages.shift();
    }
}

function chat_add_service_message(mtime, message) {
    publish_api_call();
    var time = new Date();
    time.setTime(mtime * 1000);
    time = time.format('db');

    message = message.replace(/\*([^\s\*]+)\*/g, "<img src=\"../../design/images/pregame/smiles/Animated22/$1.gif\" />");
    message = linkify(message);
    var message_str = '<span><span class="mes"><p>[' + time + ']</p><span>' + message + '</span></span></span>';
    var els = Elements.from(message_str);
    $('game_chat').adopt(els);

    var scroll = $('game_chat').getScrollSize();
    $('game_chat').scrollTo(0, scroll.y);

    /*var len = saved_chat_messages.push(message_str);
    if (len>10){
      saved_chat_messages.shift();
    }*/
}

// From server we receive set_active_player($p_num,$last_turn,$turn_num,$npc_flag), other flags are set in initialization.js after refresh
function set_active_player(player_num, last_end_turn, turn, npc_flag, units_moves_flag, card_played_flag, subsidy_flag, from_init) {
    publish_api_call();
    units_moves_flag = units_moves_flag || 0;
    card_played_flag = card_played_flag || 0;
    subsidy_flag = subsidy_flag || 0;
    from_init = from_init || 0;
    //clean green cells after my move
    if (turn_state == MY_TURN) {
        $$('#board .green').removeClass('green');
        $$('#board .activeUnit').removeClass('activeUnit');
    }
    if (player_num == my_player_num) {
        turn_state = MY_TURN;
        card_action_done_in_this_turn = card_played_flag;
        subsidy_taken_in_this_turn = subsidy_flag;
        movedUnits = units_moves_flag.toInt();
        activate_controls();
        if (players_by_num[my_player_num]['gold'].toInt() < mode_config["card cost"]) { //deactivate buy card if units moved or money<cost
            deactivate_button($('main_buttons').getChildren('.btn_buycard')[0]);
        }
        if ((subsidy_flag.toInt() == 1 && !realtime_cards) || board_buildings[my_castle_id]['health'].toInt() < 2) { //deac subsidy if castle health<2
            deactivate_button($('main_buttons').getChildren('.btn_subs')[0]);
        }
        if (card_played_flag.toInt() == 1) { //disable cards, grave and buy card button
            if (!realtime_cards) {
                deactivate_button($('main_buttons').getChildren('.btn_buycard')[0]);
                $('cards_holder').getChildren().each(function(item, index) {
                    if (item) {
                        item.fade(unactive_card);
                    }
                });
            }
            $('grave_holder').getChildren().each(function(item, index) {
                if (item) {
                    item.fade(unactive_card);
                }
            });
        }
        activateMyMove();
        was_active = 0;
        remindMoveTimer = setTimeout('was_active=0;activateMyMove();newRemindTimer();', remindTime);
    } else {
        movedUnits = false;
        clearTimeout(remindMoveTimer);
        turn_state = NOT_MY_TURN;
        deactivate_controls();
        clean_everything();
        stopShield();
        $('cards_holder').getChildren().each(function(item, index) {
            if (item) {
                item.fade(1);
            }
        });
        $('grave_holder').getChildren().each(function(item, index) {
            if (item) {
                item.fade(1);
            }
        });
        if (game_state != 'WAITTING') cancel_execute(); //for interrupting of polza choosing params
    }
    players_by_num.each(function(item, index) {
        if (item) {
            if (item['player_num'].toInt() < 10) { //not neutral
                if (item['player_num'].toInt() != my_player_num) {
                    $('player' + item['player_num']).morph({
                        'color': '#807E5A'
                    });
                    $('money' + item['player_num']).morph({
                        'color': '#807E5A'
                    });
                } else {
                    $('player' + item['player_num']).morph({
                        'color': '#F3F2E6'
                    });
                    $('money' + item['player_num']).morph({
                        'color': '#F3F2E6'
                    });
                }
                $('shield').removeClass('pl' + (item['player_num'].toInt() + 1));
            }
        }
    });
    if (player_num.toInt() < 10) { //not neutral
        $('player' + player_num).set('morph', {
            duration: 'long',
            transition: 'bounce:out'
        });
        $('player' + player_num).morph({
            'color': '#13DD0B'
        });
        $('money' + player_num).set('morph', {
            duration: 'long',
            transition: 'bounce:out'
        });
        $('money' + player_num).morph({
            'color': '#13DD0B'
        });
        $('shield').addClass('pl' + (player_num.toInt() + 1));
        $('activep_name').set('text', players_by_num[player_num]['name']);
    }
    active_players['player_num'] = player_num;
    active_players['last_end_turn'] = last_end_turn;
    active_players['turn'] = turn;
    $('game_turn').set('html', i18n[USER_LANGUAGE]['game']['turn'] + ': ' + turn);
}

function newRemindTimer() {
    clearTimeout(remindMoveTimer);
    remindMoveTimer = setTimeout('was_active=0;activateMyMove();newRemindTimer();', remindTime);
}

function activateMyMove() {
    clearInterval(shieldInterval);
    shieldInterval = setInterval(changeShield, 1000);
    clearInterval(titleInterval);
    titleInterval = setInterval(changeTitle, 2000);
    if (noSound == 0) play_sound('your_move.wav');
}

function update_next_turn_timer(left_seconds) {
    //game_time
    if (time_restriction != 0) {
        var minutes = Math.floor(left_seconds / 60);
        var seconds = left_seconds - minutes * 60;
        if (minutes >= 0 && seconds >= 0) {
            if (seconds < 10) $('game_time').set('html', minutes + ':0' + seconds);
            else
                $('game_time').set('html', minutes + ':' + seconds);
        }
    }
}

function deactivate_controls(force) {
    force = force || false;
    var buttons = $('main_buttons').getChildren('a');
    buttons.each(function(item, index) {
        var itemClass =  item.get('class');
        var deactivateBuyCard = itemClass.includes('btn_buycard') && players_by_num[my_player_num]["gold"] < mode_config["card cost"]
        var deactivateSubsidy = itemClass.includes('btn_subs') && board_buildings[my_castle_id]['health'].toInt() < 2
        console.log(itemClass)
        if (!realtime_cards || force || itemClass.includes('btn_end_turn') || deactivateBuyCard || deactivateSubsidy) {
          console.log(itemClass)
          item.addClass('unactive');
        }
    });
}

function activate_controls() {
    var buttons = $('main_buttons').getChildren('a');
    buttons.each(function(item, index) {
        item.removeClass('unactive');
    });
}

function deactivate_button(but) {
    if (!but.hasClass('unactive')) but.addClass('unactive');
}

function activate_button(but) {
    if (but.hasClass('unactive')) but.removeClass('unactive');
}

function refresh() {
    publish_api_call();
}

function clean_everything() {
    /*var nx = 0;
    var ny = 0;*/
    $('overboard').removeClass('cursor_move');
    $('overboard').removeClass('cursor_attack');
    $('overboard').removeClass('cursor_shoot');
    backlight_out(mouse_x, mouse_y);
    if (building != "") {
        var coords = building.toString().split(',');
        var ux = coords[0].toInt();
        var uy = coords[1].toInt();
        if ($('board_' + ux + '_' + uy)) $('board_' + ux + '_' + uy + '').removeClass('activeUnit');
    }
    /*for (nx=0;nx<20;nx++)
    	for (ny=0;ny<20;ny++)	{
    		$('board_'+nx+'_'+ny).removeClass('activeUnit');
    		$('board_'+nx+'_'+ny).removeClass('attackUnit');
    		$('board_'+nx+'_'+ny).removeClass('green');
    		
    		$('overboard_'+nx+'_'+ny).removeClass('cursor_move');
    		
    		$('overboard_'+nx+'_'+ny).removeClass('cursor_attack');
    }*/
}

function highlight_cell(x, y) {
    if ($('board_' + x + '_' + y))
        $('board_' + x + '_' + y).addClass('markCoords');
}

function unhighlight_cell(x, y) {
    if ($('board_' + x + '_' + y))
        $('board_' + x + '_' + y).removeClass('markCoords');
}

function draw_arrow(x, y, x2, y2, color) {
    drawArrow(x * 35 + 17.5, y * 35 + 17.5, x2 * 35 + 17.5, y2 * 35 + 17.5, color);
}

function hide_arrow(x, y, x2, y2) {
    clearArrowRect(x * 35 + 17.5, y * 35 + 17.5, x2 * 35 + 17.5, y2 * 35 + 17.5);
}

function highlight_unit(id) {
    var ux = 0;
    var uy = 0;
    //get left up corner
    board.each(function(items, index) {
        if (items)
            items.each(function(item, index) {
                if (item)
                    if (item["ref"] == id && item["type"] == "unit") {
                        if (item["x"].toInt() > ux) ux = item["x"].toInt();
                        if (item["y"].toInt() > uy) uy = item["y"].toInt();
                    }
            });
    });
    if (board[ux])
        if (board[ux][uy])
            if (board[ux][uy]['type'] == 'unit' && board[ux][uy]['ref'] == id)
                if ($('board_' + ux + '_' + uy))
                    $('board_' + ux + '_' + uy).addClass('markCoords2');
}

function unhighlight_unit(id) {
    var ux = 0;
    var uy = 0;
    //get left up corner
    board.each(function(items, index) {
        if (items)
            items.each(function(item, index) {
                if (item)
                    if (item["ref"] == id && item["type"] == "unit") {
                        if (item["x"].toInt() > ux) ux = item["x"].toInt();
                        if (item["y"].toInt() > uy) uy = item["y"].toInt();
                    }
            });
    });
    if (board[ux])
        if (board[ux][uy])
            if (board[ux][uy]['type'] == 'unit' && board[ux][uy]['ref'] == id)
                if ($('board_' + ux + '_' + uy))
                    $('board_' + ux + '_' + uy).removeClass('markCoords2');
}

function highlight_building(id) {
    var ux = 19;
    var uy = 19;
    //get left up corner
    board.each(function(items, index) {
        if (items)
            items.each(function(item, index) {
                if (item)
                    if (item["ref"] == id && item["type"] != "unit") {
                        if (item["x"].toInt() < ux) ux = item["x"].toInt();
                        if (item["y"].toInt() < uy) uy = item["y"].toInt();
                    }
            });
    });
    if (board[ux])
        if (board[ux][uy])
            if (board[ux][uy]['type'] != 'unit' && board[ux][uy]['ref'] == id)
                if ($('board_' + ux + '_' + uy))
                    $('board_' + ux + '_' + uy).addClass('markCoords2');
}

function unhighlight_building(id) {
    var ux = 19;
    var uy = 19;
    //get left up corner
    board.each(function(items, index) {
        if (items)
            items.each(function(item, index) {
                if (item)
                    if (item["ref"] == id && item["type"] != "unit") {
                        if (item["x"].toInt() < ux) ux = item["x"].toInt();
                        if (item["y"].toInt() < uy) uy = item["y"].toInt();
                    }
            });
    });
    if (board[ux])
        if (board[ux][uy])
            if (board[ux][uy]['type'] != 'unit' && board[ux][uy]['ref'] == id)
                if ($('board_' + ux + '_' + uy))
                    $('board_' + ux + '_' + uy).removeClass('markCoords2');
}

function show_unit_message(b_unit_id, mes_id) {
    publish_api_call();
    if (noNpcTalk != 1) {
        var mes = dic_unit_phrases[mes_id]["phrase"];
        var x = 0;
        var y = 0;
        board.each(function(items, index) {
            if (items)
                items.each(function(item, index) {
                    if (item)
                        if (item["type"] == 'unit' && b_unit_id == item["ref"]) {
                            x = item["x"];
                            y = item["y"];
                        }
                });
        });
        $('unitmes_c').set('text', mes);
        //set position to be done and show
        $('unitmes_w').position({
            relativeTo: $('board_' + x + '_' + y),
            position: 'center',
            edge: 'bottomRight'
        });
        var newMes = $('unitmes_w').clone();
        var mesId = Math.random().toString(36).substr(2, 9) + b_unit_id + mes_id;
        newMes.set('id', mesId);
        $(document.body).grab(newMes, 'bottom');
        newMes.setStyle('display', 'block');
        setTimeout('hide_unit_message("' + mesId + '");', 6000);
    }
}

function hide_unit_message(domId) {
    $(domId).setStyle('display', 'none');
}

function NPC(p_num) {
    //here we can do something on NPC move
}
