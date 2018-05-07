var NOT_MY_TURN = 0;
var MY_TURN = 1;
var DEBUG_MODE = 1;
var current_window;
var turn_state = NOT_MY_TURN; //state of client
var was_active = 0; //state of player
var shieldInterval;
var titleInterval;

var time_delay_from_server = 0;

var procedures_names = Array();
var procedures_params_codes = Array();
var players_by_num = Array();
var board = new Array();
//var cards_procedures_ids = Array();
var cardsSlider;
var graveSlider;
var allCardsSlider;
var cardsCarousel;
var graveCarousel;
var cardsCount = 5;

var timest = 0;
var mesId = 0;

var infoTips = new Array();
var showHint = true;

//cookies
var showColorCells = '1';
var chatHeight = '400';
var logHeight = '250';
var noSound = 0;
var noNextUnit = 0;
var noNpcTalk = 0;

var commandsRequest;
var chatCommandsRequest;
var noNewCommandsRequest = false;

var old_unit_coords = '';

var mouse_x = 0;
var mouse_y = 0;

var log_resize = 0;
var chat_resize = 0;

var logContainer;
var logCOntainerId;

var winTitle = '';

var x_path = new Array();
var y_path = new Array();
var path_actions = new Array();
var path_mode = false;
var path_moves = 0;

var no_backlight = false;
var multiple_action_unit_id = false;
var after_commands = '';
var after_commands_anims = '';
var after_commands_units = '';
var wasError = false;
var commands_executing = false;

var reCommandsTimer;
var refreshCommandsTimer;
var remindMoveTimer;
var remindTime = 20000;

var my_castle_id;
var movedUnits = false;
var playingCard = false;

var inisize;
var mySortables;

var noCloseWindow = false;
var chatFocused = false;

var time_restriction = 0;
var game_status = 0;
var my_player_num = 0;
var server_time = 0;
var site_domen = '';

var last_commands = new Array();
var last_chat_commands = new Array();
var last_commands_i = 0;
var last_chat_commands_i = 0;
var noRefresh = false;

function onRefresh() {
    stopShield();
}

function hideLoading() {
    clearInterval(changePhraseInterval);
    var loading = new Fx.Morph('loading', {
        duration: 1000
    });
    loading.start({
        'opacity': 0
    });
    setTimeout("$('loading').destroy();", 1000);
}

function initialization() {
    try {
        parent.WSClient.joinGame(game_info["game_id"]);
        //init some variables
        time_restriction = game_info["time_restriction"].toInt();
        game_status = game_info["status_id"].toInt();

        setLoadingText(i18n[USER_LANGUAGE]["loading"]["initialization"]);
        if (!Browser.ie) document.body.setStyle('overflow', 'visible');
        else document.body.style.overflow = "visible";
        var cur_client_time = Math.floor($time() / 1000);
        time_delay_from_server = cur_client_time - server_time;
        //console.log(Math.floor($time() / 1000) + '---'+ cur_client_time+'---'+server_time+'---'+time_delay_from_server);
        winTitle = document.title;
        loadCookies();

        //get some ini sizes
        inisize = window.getSize();
        /*if (inisize.y<$('container').getSize().y)
		showWindow('Рекомендация','Размер окна браузера слишком мал, нажмите F11 и закройте окно.',200,60,false);*/
        if (inisize.x < 1200) { //mode with board ro left
            var myCss1024 = new Element('link', {
                'rel': 'stylesheet',
                'type': 'text/css',
                'href': '../../design/css/stylesgame_1024.css',
                'id': 'game1024_css'
            });
            document.body.grab(myCss1024, 'bottom');
        }
        formSortables();
        //additional massives
        setLoadingText(i18n[USER_LANGUAGE]["loading"]["procedures_init"]);
        procedures_mode_1.each(function(item, index) {
            if (item) procedures_names[item["name"]] = item;
        });
        procedures_params.each(function(item, index) {
            if (item) procedures_params_codes[item["code"]] = item;
            procedures_params_codes[item["code"]]["description"] = procedure_param_description(item["id"]);
        });
        if (game_status == 3) { //finished
            eval(ws_exec_cmds);
            exec_commands_now = true;
            //hide loading
            hideLoading();
            $('cards_container').destroy();
            end_game();
            return 1;
        } else {
            var game_info_html = '<b>' + i18n[USER_LANGUAGE]["game"]["game_name"] + ': </b>' + game_info['title'] + '<br /><b>' + i18n[USER_LANGUAGE]["game"]["creation_date"] + ': </b>' + game_info['creation_date'] + '<br /><hr /><table><tr><th>' + i18n[USER_LANGUAGE]["game"]["player"] + ':</th><th>' + i18n[USER_LANGUAGE]["game"]["team"] + ':</th></tr>'
            //players
            setLoadingText(i18n[USER_LANGUAGE]["loading"]["players_init"]);
            players.each(function(item, index) {
                if (item) {
                    if (item['player_num'] == my_player_num && item['agree_draw'].toInt() == 1) $('chbDraw').setProperty('checked', true); // set Draw
                    if (item['owner'].toInt() == 0) //spectator
                        add_spectator_init(item['player_num'], item['name']);
                    else
                        add_player(item['player_num'], item['name'], item['gold'], item['owner'], item['team']);
                    var playerDisplayName = item['owner'] <= 1 ? item['name'] : npc_player_name(item['name']);
                    game_info_html += '<tr><td>' + playerDisplayName + '</td><td>' + item['team'] + '</td></tr>';
                }
            });
            //game info init
            game_info_html += '</table><hr />';
            $('game_info').set('html', game_info_html);
            //features initialization
            setLoadingText(i18n[USER_LANGUAGE]["loading"]["features_init"]);
            board_buildings_features.each(function(item, index) {
                if (item) {
                    if (item['param'] == '') fval = 1;
                    else fval = item['param'];
                    board_buildings[item['board_building_id']][building_features[item['feature_id']]['code']] = fval;
                }
            });
            board_units_features.each(function(item, index) {
                if (item) {
                    if (item['param'] == '') fval = 1;
                    else fval = item['param'];
                    board_units[item['board_unit_id']][unit_features[item['feature_id']]['code']] = fval;
                }
            });

            //board initialization
            setLoadingText(i18n[USER_LANGUAGE]["loading"]["board_init"]);
            init_board_buildings.each(function(item, index) {
                if (item) {
                    if (board_buildings[item['ref']]['player_num'] == my_player_num && item['type'] == 'castle') my_castle_id = item['ref']; //store my castle id
                    put_building(item['ref'], board_buildings[item['ref']]['player_num'], item['x'], item['y'], board_buildings[item['ref']]['rotation'], board_buildings[item['ref']]['flip'], board_buildings[item['ref']]['card_id'], board_buildings[item['ref']]['income']);
                }
            });
            init_board_units.each(function(item, index) {
                if (item)
                    if (board_units[item['ref']]['card_id'] != "") add_unit(item['ref'], board_units[item['ref']]['player_num'], item['x'], item['y'], board_units[item['ref']]['card_id']);
                    else add_unit_by_id(item['ref'], board_units[item['ref']]['player_num'], item['x'], item['y'], board_units[item['ref']]['unit_id']);
            });

            //cards
            setLoadingText(i18n[USER_LANGUAGE]["loading"]["deck_init"]);
            $('grave_bg').fade(0);
            cardsSlider = new Fx.Slide($('cards'), {}).slideOut('vertical');
            graveSlider = new Fx.Slide($('graveyard'), {
                onStart: function() {
                    if ($('graveyard').getStyle('margin-top') == '0px') $('grave_bg').fade(0);
                },
                onComplete: function() {
                    if ($('graveyard').getStyle('margin-top') == '0px') $('grave_bg').fade(0.5);
                }
            }).slideOut('vertical');
            var full_size = inisize.y - 38;
            if (full_size > 1020) full_size = 1020;
            $('fullsize').setStyle('height', full_size);
            $('fullsize_holder').setStyle('height', full_size.toInt() - 4);
            $('fullsize_grave_bg').setStyle('height', full_size);
            $('fullsize_grave_bg').fade(0);
            allCardsSlider = new Fx.Slide($('fullsize'), {
                onStart: function() {
                    if ($('fullsize').getStyle('margin-top') == '0px') $('fullsize_grave_bg').fade(0);
                },
                onComplete: function() {
                    if ($('fullsize').getStyle('margin-top') == '0px')
                        if ($('graveLink').hasClass('cementary')) $('fullsize_grave_bg').fade(0.5);
                }
            }).slideOut('vertical');

            player_deck.each(function(item, index) {
                if (item) add_card(item['id'], item['card_id'], true);
            });
            makeCardsCarousel();
            makeGraveCarousel();

            boardCoords = $('board').getCoordinates();
            $('cards_container').setStyle('left', boardCoords.left - 24);

            //game_log
            setLoadingText(i18n[USER_LANGUAGE]["loading"]["log_init"]);
            $('game_log').setStyle('display', 'none');
            vw_command_log.each(function(item, index) {
                if (item) eval(item['command']);
            });
            $('game_log').setStyle('display', 'block');

            //graveyard
            setLoadingText(i18n[USER_LANGUAGE]["loading"]["graveyard_init"]);
            vwGrave.each(function(item, index) {
                if (item) add_to_grave(item['grave_id'], item['card_id'], item['x'], item['y'], item['size']);
            });
            $('graveLink').addEvent('mouseenter', function() {
                show_all_graves();
            });
            $('graveLink').addEvent('mouseleave', function() {
                hide_all_graves();
            });

            //other
            setLoadingText(i18n[USER_LANGUAGE]["loading"]["other_init"]);
            active_players.each(function(item, index) {
                if (item) {
                    active_players = item;
                    set_active_player(active_players['player_num'], active_players['last_end_turn'], active_players['turn'], 0, active_players['units_moves_flag'], active_players["card_played_flag"], active_players["subsidy_flag"], 1);
                    // finish_command_procedure
                    if (active_players['player_num'] == my_player_num && active_players['command_procedure'] != '') {
                        execute_procedure(active_players['command_procedure']);
                    }
                }
            });
            //cards_procedures_1.each(function(item,index)	{
            //	cards_procedures_ids[item['card_id']] = item;
            //});
            //options
            $('color_cells').set('value', showColorCells);
            if (noSound == 1) $('noSound').set('checked', true);
            if (noNextUnit == 1) $('noNextUnit').set('checked', true);
            if (noNpcTalk == 1) $('noNpcTalk').set('checked', true);

            //set control sortables
            mySortables = new Sortables('#rightbar, #leftbar', {
                clone: true,
                revert: true,
                handle: 'div',
                onComplete: function(el) {
                    if ($('game_' + el.get('id'))) {
                        var scroll = $('game_' + el.get('id')).getScrollSize();
                        $('game_' + el.get('id')).scrollTo(0, scroll.y);
                    }
                    var ser = mySortables.serialize(2, function(element, index) {
                        if ($chk(element.getProperty('id'))) return element.getProperty('id');
                        else return '';
                    }).join('&');
                    Cookie.write('arena_Sortables', ser, {
                        duration: 365
                    });
                    updateBarsSizes();
                }
            });
            if (inisize.x < 1200) { //mode with board ro left
                var ser = mySortables.serialize(2, function(element, index) {
                    if ($chk(element.getProperty('id'))) return element.getProperty('id');
                    else return '';
                }).join('&');
                Cookie.write('arena_Sortables', ser, {
                    duration: 365
                });
            }

            //set resizes
            $('chat').makeResizable({
                modifiers: {
                    x: false,
                    y: 'height'
                },
                limit: {
                    y: [122, 650]
                },
                stopPropagation: true,
                onDrag: function(el, e) {
                    if (chat_resize == 1) {
                        var new_h = el.getStyle('height').toInt() - 122;
                        if (new_h < 0) new_h = 0;
                        $('game_chat').setStyle('height', new_h);
                        Cookie.write('arena_chatHeight', new_h, {
                            duration: 365
                        });
                        updateBarsSizes();
                    }
                },
                onStart: function() {
                    if (chat_resize != 1) this.stop();
                }
            });
            $('game_chat').setStyle('height', chatHeight.toInt());
            $('log').makeResizable({
                modifiers: {
                    x: false,
                    y: 'height'
                },
                limit: {
                    y: [53, 650]
                },
                stopPropagation: true,
                onDrag: function(el, e) {
                    if (log_resize == 1) {
                        var new_h = el.getStyle('height').toInt() - 53;
                        if (new_h < 0) new_h = 0;
                        $('game_log').setStyle('height', new_h);
                        Cookie.write('arena_logHeight', new_h, {
                            duration: 365
                        });
                        updateBarsSizes();
                    }
                },
                onStart: function() {
                    if (log_resize != 1) this.stop();
                }
            });
            $('game_log').setStyle('height', logHeight.toInt());
            updateBarsSizes();
            //fix for cards container for small monitors
            window.onscroll = function() {
                $('cards_container').setStyle('bottom', '-' + window.getScroll().y + 'px');
            }
            if (inisize.x < 1200) { //mode with board ro left
                $('game_chat').setStyle('height', 140);
                $('game_log').setStyle('height', 170);
            }
            //hide board dividers
            if (my_player_num.toInt() < 4) var boardClass = 'pl' + my_player_num;
            else var boardClass = 'newtrl';
            $('hor_line1').fade('toggle');
            $('hor_line1').addClass(boardClass);
            $('hor_line2').fade('toggle');
            $('hor_line2').addClass(boardClass);
            $('ver_line1').fade('toggle');
            $('ver_line1').addClass(boardClass);
            $('ver_line2').fade('toggle');
            $('ver_line2').addClass(boardClass);
            //board player class
            $('board').addClass(boardClass);

            var scroll = $('game_log').getScrollSize();
            $('game_log').scrollTo(0, scroll.y);
            scroll = $('game_chat').getScrollSize();
            $('game_chat').scrollTo(0, scroll.y);

            //init some vars
            for (i = 0; i < 40; i++) x_path[i] = -1;
            for (i = 0; i < 40; i++) y_path[i] = -1;

            //set buttons titles
            $('main_buttons').getChildren('.btn_buycard')[0].set('title', mode_config["card cost"] + ' золота');
            $('main_buttons').getChildren('.btn_subs')[0].set('title', mode_config["subsidy amount"] + ' золота за ' + mode_config["subsidy castle damage"] + 'ед. урона своему замку');

            //set hotkeys
            var myKeyboardEvents = new Keyboard({
                defaultEventType: 'keydown',
                active: true,
                events: {
                    'z': doCancel,
                    'e': doEndTurn,
                    'a': doAttack,
                    'b': doBuyCard,
                    's': doSubsidy
                }
            });

            //init events for overboard cells
            $('overboard').getChildren('.board_cell').each(function(elem, index) {
                if (elem) {
                    var idcoords = elem.get('id').split('_');
                    elem.addEvent('mouseenter', function() {
                        backlight(idcoords[1].toInt(), idcoords[2].toInt());
                    });
                    elem.addEvent('mouseleave', function() {
                        backlight_out(idcoords[1].toInt(), idcoords[2].toInt());
                    });
                }
            });

            //panorama
            var dt = new Date();
            var seasons = new Array('winter', 'spring', 'summer', 'autumn');
            var season = seasons[Math.floor((dt.getMonth() + 1) / 3) % 4];
            var hr = dt.getHours();
            var daytime = '';
            if ((hr >= 22 && hr <= 23) || (hr >= 0 && hr <= 5)) daytime = 'Night';
            else if (hr >= 6 && hr <= 9) daytime = 'Sunrise';
            else if (hr >= 10 && hr <= 17) daytime = 'Day';
            else if (hr >= 18 && hr <= 21) daytime = 'Sunset';
            var scr_size = 1200;
            screen_size = window.getSize();
            if (screen_size.y > 0 && screen_size.y <= 768) scr_size = 768;
            else if (screen_size.y > 768 && screen_size.y <= 1024) scr_size = 1024;
            document.body.setStyle('background-image', 'url("../../design/images/pregame/panorama/' + season + '/' + daytime + '_' + scr_size + '_Q8.jpg")');
            document.body.setStyle('background-position', Number.random(0, 10000) + "px 0px");
            setTimeout('movePanorama()', Number.random(60000, 180000));

            //init chat messages
            var saved_messages = localStorage.getItem("saved_messages_" + game_info["game_id"] + "_" + my_player_num);
            if ($chk(saved_messages)) {
                $('game_chat').set('html', saved_messages);
                chat_add_service_message($time() / 1000, i18n[USER_LANGUAGE]["game"]["chat_missing_messages"]);
            }
            setInterval("saveChatMessages();", 10000);

            eval(ws_exec_cmds);
            exec_commands_now = true;
            hideLoading();
        } // end if game finished
    } catch (e) {
        if (DEBUG_MODE) {
            displayLordsError(e, 'initialization();<br />Last executed_procedure:' + last_executed_procedure + '<br />Last API:' + last_executed_api);
        }
    }
}

function movePanorama() {
    var myMorph = new Fx.Morph(document.body, {
        'duration': 3000,
        'link': 'chain'
    });
    var bg_pos = document.body.getStyle('background-position-x').toInt();
    myMorph.start({
        'background-position': (bg_pos + 30) + 'px 0px'
    }).wait(100).start({
        'background-position': (bg_pos + 20) + 'px 0px'
    });
    setTimeout('movePanorama()', Number.random(60000, 180000));
}

function saveChatMessages() {
    var chat_str = "";
    saved_chat_messages.each(function(item, index) {
        if (item) {
            chat_str += item;
        }
    });
    if (chat_str != '') {
        localStorage.setItem("saved_messages_" + game_info["game_id"] + "_" + my_player_num, chat_str);
    }
}

function updateBarsSizes() {
    var height = 0;
    $('leftbar').getChildren().each(function(elem, index) {
        if (elem.get('id')) height += elem.getSize().y + 10;
    });
    $('leftbar').setStyle('height', height + 15);
    height = 0;
    $('rightbar').getChildren().each(function(elem, index) {
        if (elem.get('id')) height += elem.getSize().y + 10;
    });
    $('rightbar').setStyle('height', height + 15);
}

function doEndTurn() {
    if (!chatFocused) {
        cancel_execute();
        execute_procedure('player_end_turn');
    }
}

function doCancel() {
    if (!chatFocused) {
        cancel_execute();
    }
}

function doBuyCard() {
    if (!chatFocused) {
        cancel_execute();
        execute_procedure('buy_card');
    }
}

function doSubsidy() {
    if (!chatFocused) {
        cancel_execute();
        execute_procedure('take_subsidy');
        deactivate_button($('main_buttons').getChildren('.btn_subs')[0]);
    }
}

function doAttack() {
    if (!chatFocused) {
        was_active = 0;
        stopShield();
        var atBut = $('actions').getChildren('.act15')[0];
        if (atBut) {
            var click_events = atBut.get('onclick');
            eval(click_events.replace('return false;', ''));
        }
    }
}

function formSortables() {
    var sides = sortables.split('&');
    var leftelems = sides[0].split(',');
    leftelems.each(function(elem, index) {
        if ($(elem)) {
            var cloned = $(elem).clone(true, true);
            $(elem).destroy();
            if (inisize.x < 1200) { //mode with board ro left
                $('rightbar').grab(cloned, 'bottom');
            } else $('leftbar').grab(cloned, 'bottom')
        }
    });
    var rightelems = sides[1].split(',');
    rightelems.each(function(elem, index) {
        if ($(elem)) {
            var cloned = $(elem).clone(true, true);
            $(elem).destroy();
            $('rightbar').grab(cloned, 'bottom')
        }
    });
}

function loadCookies() {
    showColorCells = Cookie.read("arena_showColorCells");
    if (!$chk(showColorCells)) showColorCells = '1';
    Cookie.write('arena_showColorCells', showColorCells, {
        duration: 365
    });

    chatHeight = Cookie.read("arena_chatHeight");
    if (!$chk(chatHeight)) chatHeight = '400';
    Cookie.write('arena_chatHeight', chatHeight, {
        duration: 365
    });

    logHeight = Cookie.read("arena_logHeight");
    if (!$chk(logHeight)) logHeight = '250';
    Cookie.write('arena_logHeight', logHeight, {
        duration: 365
    });

    sortables = Cookie.read("arena_Sortables");
    if (!$chk(sortables)) sortables = 'chat&log,ctrl_block';
    Cookie.write('arena_Sortables', sortables, {
        duration: 365
    });

    noSound = Cookie.read("arena_noSound");
    if (!$chk(noSound)) noSound = 0;
    Cookie.write('arena_noSound', noSound, {
        duration: 365
    });

    noNextUnit = Cookie.read("arena_noNextUnit");
    if (!$chk(noNextUnit)) noNextUnit = 0;
    Cookie.write('arena_noNextUnit', noNextUnit, {
        duration: 365
    });

    noNpcTalk = Cookie.read("arena_noNpcTalk");
    if (!$chk(noNpcTalk)) noNpcTalk = 0;
    Cookie.write('arena_noNpcTalk', noNpcTalk, {
        duration: 365
    });
}

function sendChatMessage() {
    if ($('chat_text').get('value') != '\n' && $('chat_text').get('value') != '') {
        parent.WSClient.sendGameChatMessage(game_info["game_id"], convertChars($('chat_text').get('value')));
        $('chat_text').set('value', '');
        $('chat_cnt').set('html', '0');
    } else $('chat_text').set('value', '');
}
//change color of cells on mouseover, show info boxes
function backlight(x, y) {
    try {
        if (!no_backlight) {
            //coords x:0 / y:0
            var xt;
            var id;
            var p_num;
            if (x < 10) xt = ' &nbsp;' + x;
            else xt = x;
            $('board_coords').set('html', 'x:' + xt + ' / y:' + y);
            mouse_x = x;
            mouse_y = y;
            if (showColorCells == "m" && board[x] && board[x][y] && board[x][y]["ref"]) { //show color on mouseover
                id = board[x][y]["ref"];
                if (board[x][y]["type"] == "unit") p_num = board_units[id]['player_num'];
                else p_num = board_buildings[id]['player_num'];
                if (p_num >= 10) $('board_' + x + '_' + y).addClass('newtrl');
                else $('board_' + x + '_' + y).addClass('pl' + (p_num.toInt() + 1).toString());
            }
            //SETTING A BUILDING
            if ((executable_procedure == 'put_building' && game_state == 'SELECTING_EMPTY_COORD_MY_ZONE') || ((executable_procedure == 'cast_polza_move_building' || executable_procedure == 'cast_vred_move_building') && game_state == 'SELECTING_EMPTY_COORD')) {
                draw_building(x, y);
            } else
                //SUMMON VAMPIRE
                if (game_state == 'SELECTING_EMPTY_COORD_MY_ZONE') {
                    draw_empty_coord_my_zone(x, y);
                } else
                    //MOVING A UNIT
                    if (executable_procedure == 'player_move_unit' && game_state == 'SELECTING_EMPTY_COORD') {
                        draw_unit(x, y);
                    } else
                        //MAGIC TELEPORTING
                        if (executable_procedure == 'cast_teleport' && game_state == 'SELECTING_EMPTY_COORD') {
                            draw_teleport_unit(x, y);
                        } else
                            //UNIT ATTACK
                            if (executable_procedure == 'attack' && game_state == 'SELECTING_ATTACK_COORD') {
                                draw_unit_attack(x, y);
                            } else
                                //SELECTING A UNIT
                                if (game_state == 'SELECTING_UNIT' || game_state == 'SELECTING_TARGET_UNIT') {
                                    if (board[x] && board[x][y])
                                        if (board[x][y]['type'] == 'unit') {
                                            $('board_' + x + '_' + y).addClass('attackUnit');
                                        }
                                } else
                                    //SELECTING A SHOOT TARGET
                                    if (game_state == 'SELECTING_SHOOT_TARGET') {
                                        var coords = unit.toString().split(',');
                                        var ux = coords[0].toInt();
                                        var uy = coords[1].toInt();
                                        var shooting_unit_id = board_units[board[ux][uy]['ref']]['unit_id'];
                                        var shoot_params = get_shooting_params(shooting_unit_id);
                                        var distance = Math.max(Math.abs(ux - x.toInt()), Math.abs(uy - y.toInt()));
                                        if (distance >= shoot_params.range_min && distance <= shoot_params.range_max)
                                            if (board[x] && board[x][y])
                                                if (board[x][y]['type'] in shoot_params.aim_types) {
                                                    $('board_' + x + '_' + y).addClass('attackUnit');
                                                    $('overboard_' + x + '_' + y).addClass('cursor_attack');
                                                }
                                    } else
                                        //SELECTING MY UNIT
                                        if (game_state == 'SELECTING_MY_UNIT') {
                                            if (board[x] && board[x][y])
                                                if (board[x][y]['type'] == 'unit') {
                                                    if (board_units[board[x][y]['ref']]['player_num'].toInt() == my_player_num)
                                                        $('board_' + x + '_' + y).addClass('attackUnit');
                                                }
                                        } else
                                            //METEOR
                                            if (executable_procedure == 'cast_meteor_shower' && game_state == 'SELECTING_ANY_COORD') {
                                                draw_meteor_coords(x, y);
                                            } else
                                                //ZONE
                                                if (game_state == 'SELECTING_ZONE') {
                                                    draw_zone(x, y);
                                                } else
                                                    //BUILDING
                                                    if (game_state == 'SELECTING_BUILDING') {
                                                        draw_building_select(x, y);
                                                    } else if (game_state == 'WAITTING') {}
        }
    } catch (e) {
        if (DEBUG_MODE) {
            displayLordsError(e, 'backlight(' + x + ',' + y + ');<br />Last executed_procedure:' + last_executed_procedure + '<br />Last API:' + last_executed_api);
        }
    }
}
//change color of cells on mouseout
function backlight_out(x, y) {
    try {
        if (1) {
            var id;
            var p_num;
            if (showColorCells == "m" && board[x] && board[x][y] && board[x][y]["ref"]) {
                id = board[x][y]["ref"];
                if (board[x][y]["type"] == "unit") p_num = board_units[id]['player_num'];
                else p_num = board_buildings[id]['player_num'];
                if (p_num >= 10) $('board_' + x + '_' + y).removeClass('newtrl');
                else $('board_' + x + '_' + y).removeClass('pl' + (p_num.toInt() + 1).toString());
            }
            //SETTING A BUILDING
            if ((executable_procedure == 'put_building' && game_state == 'SELECTING_EMPTY_COORD_MY_ZONE') || ((executable_procedure == 'cast_polza_move_building' || executable_procedure == 'cast_vred_move_building') && game_state == 'SELECTING_EMPTY_COORD')) {
                clean_building(x, y);
            } else
                //SUMMON VAMPIRE
                if (game_state == 'SELECTING_EMPTY_COORD_MY_ZONE') {
                    clean_empty_coord_my_zone(x, y);
                } else
                    //MOVING A UNIT
                    if (executable_procedure == 'player_move_unit' && game_state == 'SELECTING_EMPTY_COORD') {
                        clean_unit(x, y);
                    } else
                        //MAGIC TELEPORTING
                        if (executable_procedure == 'cast_teleport' && game_state == 'SELECTING_EMPTY_COORD') {
                            clean_teleport_unit(x, y);
                        } else
                            //UNIT ATTACK
                            if (executable_procedure == 'attack' && game_state == 'SELECTING_ATTACK_COORD') {
                                clean_unit_attack(x, y);
                            } else
                                //METEOR
                                if (executable_procedure == 'cast_meteor_shower' && game_state == 'SELECTING_ANY_COORD') {
                                    clean_meteor_coords(x, y);
                                } else
                                    //ZONE
                                    if (game_state == 'SELECTING_ZONE') {
                                        clean_zone(x, y);
                                    } else
                                        //BUILDING
                                        if (game_state == 'SELECTING_BUILDING') {
                                            clean_building_select(x, y);
                                        } else
                                            //SHOOT TARGET
                                            if (game_state == 'SELECTING_SHOOT_TARGET') {
                                                if (board[x] && board[x][y]) {
                                                    $('board_' + x + '_' + y).removeClass('attackUnit');
                                                    $('overboard_' + x + '_' + y).removeClass('cursor_attack');
                                                }
                                            } else
                                                //SELECTING A UNIT
                                                if (game_state == 'SELECTING_UNIT' || game_state == 'SELECTING_TARGET_UNIT' || game_state == 'SELECTING_MY_UNIT') {
                                                    if (board[x] && board[x][y])
                                                        if (board[x][y]['type'] == 'unit') {
                                                            $('board_' + x + '_' + y).removeClass('attackUnit');
                                                            $('overboard_' + x + '_' + y).removeClass('cursor_attack');
                                                        }
                                                }
        }
    } catch (e) {
        if (DEBUG_MODE) {
            displayLordsError(e, 'backlight_out(' + x + ',' + y + ');<br />Last executed_procedure:' + last_executed_procedure + '<br />Last API:' + last_executed_api);
        }
    }
}
//enable/disable color cells for units/buildings.
function change_color_cells() {
    Cookie.write('arena_showColorCells', $('color_cells').get('value'), {
        duration: 365
    });
    window.location.reload();
}

function change_rotation() {
    rotation++;
    if (rotation == 4) rotation = 0;
}

function change_flip() {
    if (flip == 0) flip = 1;
    else flip = 0;
}

function my_quart(x, y) {
    var quart = 0;
    if ((x > 19) || (x < 0) || (y > 19) || (y < 0)) quart = 5; /*Error*/
    if ((x < 10) && (y < 10)) quart = 0;
    if ((x > 9) && (y < 10)) quart = 1;
    if ((x > 9) && (y > 9)) quart = 2;
    if ((x < 10) && (y > 9)) quart = 3;

    if (my_player_num.toInt() == quart) return true;
    else return false;
}

function turnNoSound() {
    if ($('noSound').getProperty('checked')) noSound = 1;
    else noSound = 0;
    Cookie.write('arena_noSound', noSound, {
        duration: 365
    });
}

function turnNoNextUnit() {
    if ($('noNextUnit').getProperty('checked')) noNextUnit = 1;
    else noNextUnit = 0;
    Cookie.write('arena_noNextUnit', noNextUnit, {
        duration: 365
    });
}

function turnNoNpcTalk() {
    if ($('noNpcTalk').getProperty('checked')) noNpcTalk = 1;
    else noNpcTalk = 0;
    Cookie.write('arena_noNpcTalk', noNpcTalk, {
        duration: 365
    });
}

function changeDraw() {
    cancel_execute();
    do_not_in_turn = 1;
    if ($('chbDraw').getProperty('checked')) execute_procedure('agree_draw');
    else execute_procedure('disagree_draw');
    do_not_in_turn = 0;
}

function draw_building(x, y) {
    var b = null;
    if (card != "") {
        b = buildings[cards[card]["ref"]];
    }
    if (building != "") {
        var coords = building.toString().split(',');
        var ux = coords[0].toInt();
        var uy = coords[1].toInt();
        if ($chk(board[ux]) && $chk(board[ux][uy]) && $chk(board[ux][uy]['ref'])) {
            b = buildings[board_buildings[board[ux][uy]['ref']]['building_id']];
        }
    }
    if (b == null) {
        return;
    }
    var rx;
    var ry;
    //radius
    for (rx = x.toInt() - b["radius"].toInt(); rx < x.toInt() + b["x_len"].toInt() + b["radius"].toInt(); rx++) {
        for (ry = y - b["radius"].toInt(); ry < y; ry++) {
            if ($('board_' + rx + '_' + ry))
                if (!my_quart(rx, ry)) $('board_' + rx + '_' + ry).addClass('yel');
            if ($('board_' + rx + '_' + (ry + b["radius"].toInt() + b["y_len"].toInt())))
                if (!my_quart(rx, ry + b["radius"].toInt() + b["y_len"].toInt())) $('board_' + rx + '_' + (ry + b["radius"].toInt() + b["y_len"].toInt())).addClass('yel');
        }
    }
    for (ry = y.toInt(); ry < y.toInt() + b["y_len"].toInt(); ry++) {
        for (rx = x.toInt() - b["radius"].toInt(); rx < x.toInt(); rx++) {
            if ($('board_' + rx + '_' + ry))
                if (!my_quart(rx, ry)) $('board_' + rx + '_' + ry).addClass('yel');
            if ($('board_' + (rx + b["radius"].toInt() + b["x_len"].toInt()) + '_' + ry))
                if (!my_quart(rx + b["radius"].toInt() + b["x_len"].toInt(), ry)) $('board_' + (rx + b["radius"].toInt() + b["x_len"].toInt()) + '_' + ry).addClass('yel');
        }
    }
    //building
    var mflip;
    var mx;
    var my;
    var x_0;
    var y_0;
    var i = 0;
    if (flip == 0) mflip = 1;
    else mflip = -1;
    if (rotation == 0) {
        i = 0;
        if (mflip == 1) x_0 = x;
        else x_0 = x + b["x_len"].toInt() - 1;
        y_0 = y;
        while (i < b["x_len"].toInt() * b["y_len"].toInt()) { /*цикл по строке shape в поисках единичек*/
            if (b['shape'].slice(i, i + 1) == '1') {
                mx = x_0 + mflip * (i % b["x_len"].toInt()); /*тут подставляются в @x,@y координаты этой "единички", если флип, х идет в обратную сторону*/
                my = y_0 + Math.floor(i / b["x_len"].toInt());
                if ($('board_' + mx + '_' + my)) {
                    $('board_' + mx + '_' + my).addClass('green');
                    if (!my_quart(mx, my) && executable_procedure != 'cast_polza_move_building' && executable_procedure != 'cast_vred_move_building') $('board_' + mx + '_' + my).addClass('red');
                    else if (board[mx])
                        if (board[mx][my])
                            if (board[mx][my]["ref"] != '' && $defined(board[mx][my]["ref"])) $('board_' + mx + '_' + my).addClass('red');
                }
            }
            i++;
        }
    } else if (rotation == 1) {
        i = 0;
        if (mflip == 1) x_0 = x + b["y_len"].toInt() - 1;
        else x_0 = x;
        y_0 = y;
        while (i < b["x_len"].toInt() * b["y_len"].toInt()) { /*цикл по строке shape в поисках единичек*/
            if (b['shape'].slice(i, i + 1) == '1') {
                mx = x_0 - mflip * Math.floor(i / b["x_len"].toInt()); /*тут подставляются в @x,@y координаты этой "единички", если флип, х идет в обратную сторону*/
                my = y_0 + (i % b["x_len"].toInt());
                if ($('board_' + mx + '_' + my)) {
                    $('board_' + mx + '_' + my).addClass('green');
                    if (!my_quart(mx, my) && executable_procedure != 'cast_polza_move_building' && executable_procedure != 'cast_vred_move_building') $('board_' + mx + '_' + my).addClass('red');
                    else if (board[mx])
                        if (board[mx][my])
                            if (board[mx][my]["ref"] != '' && $defined(board[mx][my]["ref"])) $('board_' + mx + '_' + my).addClass('red');
                }
            }
            i++;
        }
    } else if (rotation == 2) {
        i = 0;
        if (mflip == 1) x_0 = x + b["x_len"].toInt() - 1;
        else x_0 = x;
        y_0 = y + b["y_len"].toInt() - 1;
        while (i < b["x_len"].toInt() * b["y_len"].toInt()) { /*цикл по строке shape в поисках единичек*/
            if (b['shape'].slice(i, i + 1) == '1') {
                mx = x_0 - mflip * (i % b["x_len"].toInt()); /*тут подставляются в @x,@y координаты этой "единички", если флип, х идет в обратную сторону*/
                my = y_0 - Math.floor(i / b["x_len"].toInt());
                if ($('board_' + mx + '_' + my)) {
                    $('board_' + mx + '_' + my).addClass('green');
                    if (!my_quart(mx, my) && executable_procedure != 'cast_polza_move_building' && executable_procedure != 'cast_vred_move_building') $('board_' + mx + '_' + my).addClass('red');
                    else if (board[mx])
                        if (board[mx][my])
                            if (board[mx][my]["ref"] != '' && $defined(board[mx][my]["ref"])) $('board_' + mx + '_' + my).addClass('red');
                }
            }
            i++;
        }
    } else if (rotation == 3) {
        i = 0;
        if (mflip == 1) x_0 = x;
        else x_0 = x + b["y_len"].toInt() - 1;
        y_0 = y + b["x_len"].toInt() - 1;
        while (i < b["x_len"].toInt() * b["y_len"].toInt()) { /*цикл по строке shape в поисках единичек*/
            if (b['shape'].slice(i, i + 1) == '1') {
                mx = x_0 + mflip * Math.floor(i / b["x_len"].toInt()); /*тут подставляются в @x,@y координаты этой "единички", если флип, х идет в обратную сторону*/
                my = y_0 - (i % b["x_len"].toInt());
                if ($('board_' + mx + '_' + my)) {
                    $('board_' + mx + '_' + my).addClass('green');
                    if (!my_quart(mx, my) && executable_procedure != 'cast_polza_move_building' && executable_procedure != 'cast_vred_move_building') $('board_' + mx + '_' + my).addClass('red');
                    else if (board[mx])
                        if (board[mx][my])
                            if (board[mx][my]["ref"] != '' && $defined(board[mx][my]["ref"])) $('board_' + mx + '_' + my).addClass('red');
                }
            }
            i++;
        }
    }
}

function clean_building(x, y) {
    var b = null;
    if (card != "") {
        b = buildings[cards[card]["ref"]];
    }
    if (building != "") {
        var coords = building.toString().split(',');
        var ux = coords[0].toInt();
        var uy = coords[1].toInt();
        if ($chk(board[ux]) && $chk(board[ux][uy]) && $chk(board[ux][uy]['ref'])) {
            b = buildings[board_buildings[board[ux][uy]['ref']]['building_id']];
        }
    }
    if (b == null) {
        return;
    }
    var rx;
    var ry;
    //radius
    for (rx = x - b["radius"].toInt(); rx < x + b["x_len"].toInt() + b["radius"].toInt() * 2; rx++) {
        for (ry = y - b["radius"].toInt(); ry < y; ry++) {
            if ($('board_' + rx + '_' + ry))
                if (!my_quart(rx, ry)) $('board_' + rx + '_' + ry).removeClass('yel');
            if ($('board_' + rx + '_' + (ry + b["radius"].toInt() + b["y_len"].toInt())))
                if (!my_quart(rx, ry + b["radius"].toInt() + b["y_len"].toInt())) $('board_' + rx + '_' + (ry + b["radius"].toInt() + b["y_len"].toInt())).removeClass('yel');
        }
    }
    for (ry = y.toInt(); ry < y.toInt() + b["y_len"].toInt(); ry++) {
        for (rx = x.toInt() - b["radius"].toInt(); rx < x.toInt(); rx++) {
            if ($('board_' + rx + '_' + ry))
                if (!my_quart(rx, ry)) $('board_' + rx + '_' + ry).removeClass('yel');
            if ($('board_' + (rx + b["radius"].toInt() + b["x_len"].toInt()) + '_' + ry))
                if (!my_quart(rx + b["radius"].toInt() + b["x_len"].toInt(), ry)) $('board_' + (rx + b["radius"].toInt() + b["x_len"].toInt()) + '_' + ry).removeClass('yel');
        }
    }
    //building
    var mflip;
    var mx;
    var my;
    var x_0;
    var y_0;
    var i = 0;
    if (flip == 0) mflip = 1;
    else mflip = -1;
    if (rotation == 0) {
        i = 0;
        if (mflip == 1) x_0 = x;
        else x_0 = x + b["x_len"].toInt() - 1;
        y_0 = y;
        while (i < b["x_len"].toInt() * b["y_len"].toInt()) { /*цикл по строке shape в поисках единичек*/
            if (b['shape'].slice(i, i + 1) == '1') {
                mx = x_0 + mflip * (i % b["x_len"].toInt()); /*тут подставляются в @x,@y координаты этой "единички", если флип, х идет в обратную сторону*/
                my = y_0 + Math.floor(i / b["x_len"].toInt());
                if ($('board_' + mx + '_' + my)) {
                    $('board_' + mx + '_' + my).removeClass('red');
                    $('board_' + mx + '_' + my).removeClass('green');
                }
            }
            i++;
        }
    } else if (rotation == 1) {
        i = 0;
        if (mflip == 1) x_0 = x + b["y_len"].toInt() - 1;
        else x_0 = x;
        y_0 = y;
        while (i < b["x_len"].toInt() * b["y_len"].toInt()) { /*цикл по строке shape в поисках единичек*/
            if (b['shape'].slice(i, i + 1) == '1') {
                mx = x_0 - mflip * Math.floor(i / b["x_len"].toInt()); /*тут подставляются в @x,@y координаты этой "единички", если флип, х идет в обратную сторону*/
                my = y_0 + (i % b["x_len"].toInt());
                if ($('board_' + mx + '_' + my)) {
                    $('board_' + mx + '_' + my).removeClass('red');
                    $('board_' + mx + '_' + my).removeClass('green');
                }
            }
            i++;
        }
    } else if (rotation == 2) {
        i = 0;
        if (mflip == 1) x_0 = x + b["x_len"].toInt() - 1;
        else x_0 = x;
        y_0 = y + b["y_len"].toInt() - 1;
        while (i < b["x_len"].toInt() * b["y_len"].toInt()) { /*цикл по строке shape в поисках единичек*/
            if (b['shape'].slice(i, i + 1) == '1') {
                mx = x_0 - mflip * (i % b["x_len"].toInt()); /*тут подставляются в @x,@y координаты этой "единички", если флип, х идет в обратную сторону*/
                my = y_0 - Math.floor(i / b["x_len"].toInt());
                if ($('board_' + mx + '_' + my)) {
                    $('board_' + mx + '_' + my).removeClass('red');
                    $('board_' + mx + '_' + my).removeClass('green');
                }
            }
            i++;
        }
    } else if (rotation == 3) {
        i = 0;
        if (mflip == 1) x_0 = x;
        else x_0 = x + b["y_len"].toInt() - 1;
        y_0 = y + b["x_len"].toInt() - 1;
        while (i < b["x_len"].toInt() * b["y_len"].toInt()) { /*цикл по строке shape в поисках единичек*/
            if (b['shape'].slice(i, i + 1) == '1') {
                mx = x_0 + mflip * Math.floor(i / b["x_len"].toInt()); /*тут подставляются в @x,@y координаты этой "единички", если флип, х идет в обратную сторону*/
                my = y_0 - (i % b["x_len"].toInt());
                if ($('board_' + mx + '_' + my)) {
                    $('board_' + mx + '_' + my).removeClass('red');
                    $('board_' + mx + '_' + my).removeClass('green');
                }
            }
            i++;
        }
    }
}

function getUnitPath(ux, uy, x, y, knight, size) {
    var not_reached = true;
    var path_board = new Array();
    var i = 0;
    var k = 0;
    var l = 0;
    var m = 0;
    var symbols = new Array('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'c', 'd', 'e', 'f', 'g', 'h', 'k', 'l', 'm');
    var id = board[ux][uy]["ref"];
    //init path board
    for (i = 0; i < 20; i++) {
        path_board[i] = new Array();
        for (k = 0; k < 20; k++) {
            path_board[i][k] = '-';
        }
    }
    //fill path board
    board.each(function(items, index) {
        if (items) items.each(function(item, index) {
            if (item) {
                if (item['type'] == 'unit' && item['ref'].toInt() == id); //this unit 
                else if (item['type'] == 'obstacle') //cant attack obstacle
                    path_board[item['x'].toInt()][item['y'].toInt()] = 'x';
                else if (item['type'] == 'unit') { //attack unit
                    //fixing bug if we suddenly get not killed unit with not existing player (which already delted)
                    if (!$chk(players_by_num[board_units[item['ref']]['player_num']])) {
                        delete board[item['x'].toInt()][item['y'].toInt()];
                        if ($chk(board_units[item['ref']])) delete board_units[item['ref']];
                    } else if (board_units[id]['player_num'] == board_units[item['ref']]['player_num'] || players_by_num[board_units[id]['player_num']]['team'] == players_by_num[board_units[item['ref']]['player_num']]['team']) path_board[item['x'].toInt()][item['y'].toInt()] = 'x';
                    else path_board[item['x'].toInt()][item['y'].toInt()] = 'u';
                } else {
                    if ($chk(players_by_num[board_buildings[item['ref']]['player_num']])) { //player num 9 for trees,moat ... doesnt exists
                        if (board_units[id]['player_num'] == board_buildings[item['ref']]['player_num'] || players_by_num[board_units[id]['player_num']]['team'] == players_by_num[board_buildings[item['ref']]['player_num']]['team']) path_board[item['x'].toInt()][item['y'].toInt()] = 'x';
                        else path_board[item['x'].toInt()][item['y'].toInt()] = 'b';
                    } else
                    if (board_buildings[item['ref']]['health'] > 0) //can kill bridge
                        path_board[item['x'].toInt()][item['y'].toInt()] = 'b';
                    else
                        path_board[item['x'].toInt()][item['y'].toInt()] = 'x';
                }
            }
        });
    });
    var target_coord = path_board[x][y];
    if (path_board[x][y] != 't') path_board[x][y] = 't';
    path_board[ux][uy] = 'z';

    var cnear = false;
    var tnear = true;
    var step = 0;
    var cango = true;
    var t_in = false;
    var x_in = false;
    //start generating all avaible paths
    while (not_reached && tnear) {
        tnear = false;
        for (i = 0; i < 20; i++)
            for (k = 0; k < 20; k++) {
                cnear = false;
                if (path_board[i][k] == '-' || path_board[i][k] == 't') {
                    if (knight) {
                        for (l = i - 2; l < i + 3; l++)
                            for (m = k - 2; m < k + 3; m++) {
                                if (l >= 0 && l <= 19 && m >= 0 && m <= 19)
                                    if ((Math.abs(i - l) == 1 && Math.abs(k - m) == 2) || (Math.abs(i - l) == 2 && Math.abs(k - m) == 1))
                                        if ((step == 0 && path_board[l][m] == 'z') || (step != 0 && path_board[l][m] == symbols[step - 1]))
                                            if (size > 1) { //large unlts
                                                if (step == 0 && path_board[l][m] == 'z') {
                                                    if (l == ux && m == uy) cnear = 1;
                                                } else cnear = 1;
                                            } else cnear = 1;
                            }
                    } else { //usual moves
                        for (l = i - 1; l < i + 2; l++)
                            for (m = k - 1; m < k + 2; m++)
                                if (l >= 0 && l <= 19 && m >= 0 && m <= 19)
                                    if ((step == 0 && path_board[l][m] == 'z') || (step != 0 && path_board[l][m] == symbols[step - 1])) cnear = 1;
                    }
                    if (cnear) {
                        if (path_board[i][k] == 't') { //found target unit(s)
                            not_reached = false;
                        } else {
                            cango = true;
                            if (size > 1) { //large units
                                t_in = false;
                                x_in = false;
                                for (l = i; l < i + size; l++)
                                    for (m = k; m < k + size; m++) {
                                        if (l >= 0 && l <= 19 && m >= 0 && m <= 19) {
                                            if (path_board[l][m] == 'x') x_in = true;
                                            if (path_board[l][m] == 't') t_in = true;
                                            if (path_board[l][m] == 'x' || path_board[l][m] == 'u' || path_board[l][m] == 'b') cango = false;
                                        } else cango = false;
                                    }
                                //if can hit target unit by hitting also another b or u - and target not free cell
                                if (cango == false) {
                                    if ($chk(board[x]) && $chk(board[x][y]) && $chk(board[x][y]['ref']))
                                        if (t_in && !x_in) {
                                            cango = true;
                                        }
                                }
                            }
                            if (cango) {
                                path_board[i][k] = symbols[step];
                                tnear = true;
                            }
                        }
                    }
                } // =='-'
            }
        step++;
    }
    //show board
    // if (x==18 && y==17) for (i=0;i<20;i++)	{
    //	console.log(path_board[0][i],path_board[1][i],path_board[2][i],path_board[3][i],path_board[4][i],path_board[5][i],path_board[6][i],path_board[7][i],path_board[8][i],path_board[9][i],path_board[10][i],path_board[11][i],path_board[12][i],path_board[13][i],path_board[14][i],path_board[15][i],path_board[16][i],path_board[17][i],path_board[18][i],path_board[19][i]);
    //}
    //generate 1 path
    step--;
    path_moves = step + 1;
    x_path = new Array();
    y_path = new Array();
    var u_x = new Array();
    var u_y = new Array();
    for (i = 0; i < 40; i++) x_path[i] = -1;
    for (i = 0; i < 40; i++) y_path[i] = -1;
    if (target_coord == 'x') return 0; //no allias hit
    for (i = 0; i < 40; i++) path_actions[i] = 'm';
    var cur_x = x;
    var cur_y = y;
    x_path[step] = cur_x;
    y_path[step] = cur_y;
    cango = true;
    var doattack = false;
    if (size > 1 && target_coord == '-') { //large units
        for (l = x_path[step]; l < x_path[step] + size; l++)
            for (m = y_path[step]; m < y_path[step] + size; m++)
                if (l >= 0 && l <= 19 && m >= 0 && m <= 19) {
                    if (path_board[l][m] == 'u' || path_board[l][m] == 'b') doattack = true;
                    if (path_board[l][m] == 'x') cango = false;
                } else cango = false;
    } else if (size > 1 && target_coord == 'b' || target_coord == 'u') {
        doattack = true;
    }
    if ((!cango && !doattack) || step == 0) {
        x_path[0] = -1;
        y_path[0] = -1;
        return 0;
    }
    if (doattack) path_actions[step] = 'a';
    cnear = 0;
    var ufound = 0;
    var stop = 0;
    //generate random path to unit
    do {
        u_x = new Array();
        u_y = new Array();
        ufound = 0;
        var delta = 100;
        if (knight == 1) { //knight moves
            for (i = cur_x - 2; i < cur_x + 3; i++)
                for (j = cur_y - 2; j < cur_y + 3; j++) {
                    if (i >= 0 && i <= 19 && j >= 0 && j <= 19)
                        if ((Math.abs(cur_x - i) == 1 && Math.abs(cur_y - j) == 2) || (Math.abs(cur_x - i) == 2 && Math.abs(cur_y - j) == 1))
                            if ((step == 0 && path_board[i][j] == 'z') || (step != 0 && path_board[i][j] == symbols[step - 1])) {
                                u_x[ufound] = i;
                                u_y[ufound] = j;
                                ufound++;
                            }
                }
        } else //usual moves
            for (i = cur_x - 1; i < cur_x + 2; i++)
                for (j = cur_y - 1; j < cur_y + 2; j++) {
                    if (i >= 0 && i <= 19 && j >= 0 && j <= 19)
                        if ((step == 0 && path_board[i][j] == 'z') || (step != 0 && path_board[i][j] == symbols[step - 1])) {
                            u_x[ufound] = i;
                            u_y[ufound] = j;
                            ufound++;
                        }
                }
        //pick random way
        /*if (ufound!=1)	{
			ufound = Math.floor(Math.random() * ufound);
		} else ufound--;*/

        //angle path choice
        l = Math.sqrt(Math.pow((cur_x - ux), 2) + Math.pow((cur_y - uy), 2));
        var sina = Math.abs(cur_x - ux) / l;

        var angl = 0; // general direction
        if (ux > cur_x && uy > cur_y) angl = Math.PI / 2 - Math.asin(sina);
        else if (cur_x == ux && uy > cur_y) angl = Math.PI / 2;
        else if (ux < cur_x && uy > cur_y) angl = Math.PI / 2 + Math.asin(sina);
        else if (cur_y == uy && ux < cur_x) angl = Math.PI;
        else if (ux < cur_x && uy < cur_y) angl = Math.PI + Math.PI / 2 - Math.asin(sina);
        else if (cur_x == ux && uy < cur_y) angl = Math.PI + Math.PI / 2;
        else if (ux > cur_x && uy < cur_y) angl = Math.PI * 1.5 + Math.asin(sina);
        u_x.each(function(item, index) {
            if ($chk(item)) {
                l = Math.sqrt(Math.pow((u_x[index] - cur_x), 2) + Math.pow((u_y[index] - cur_y), 2));
                sina = Math.abs(u_x[index] - cur_x) / l;

                var angl2 = 0; //possible direction
                if (u_x[index] > cur_x && u_y[index] > cur_y) angl2 = Math.PI / 2 - Math.asin(sina);
                else if (cur_x == u_x[index] && u_y[index] > cur_y) angl2 = Math.PI / 2;
                else if (u_x[index] < cur_x && u_y[index] > cur_y) angl2 = Math.PI / 2 + Math.asin(sina);
                else if (cur_y == u_y[index] && u_x[index] < cur_x) angl2 = Math.PI;
                else if (u_x[index] < cur_x && u_y[index] < cur_y) angl2 = Math.PI + Math.PI / 2 - Math.asin(sina);
                else if (cur_x == u_x[index] && u_y[index] < cur_y) angl2 = Math.PI + Math.PI / 2;
                else if (u_x[index] > cur_x && u_y[index] < cur_y) angl2 = Math.PI * 1.5 + Math.asin(sina);
                if (Math.abs(angl - angl2) < delta) {
                    delta = Math.abs(angl - angl2);
                    ufound = index;
                }
                if (angl2 == 0) {
                    angl2 = Math.PI * 2;
                    if (Math.abs(angl - angl2) < delta) {
                        delta = Math.abs(angl - angl2);
                        ufound = index;
                    }
                }
            }
        });

        x_path[step - 1] = u_x[ufound];
        y_path[step - 1] = u_y[ufound];
        cur_x = u_x[ufound];
        cur_y = u_y[ufound];

        step--;
        if (step < 0) stop = 1;
    } while (stop == 0);
    if (size > 1 && (target_coord == 'b' || target_coord == 'u') && x_path[0] != -1 && y_path[0] != -1) {
        i = 0;
        var can_hit_earlier = false;
        while (x_path[i] != -1 && y_path[i] != -1 && !can_hit_earlier) {
            for (l = x_path[i]; l < x_path[i] + size; l++)
                for (m = y_path[i]; m < y_path[i] + size; m++)
                    if (l >= 0 && l <= 19 && m >= 0 && m <= 19) {
                        if (path_board[l][m] == 't') can_hit_earlier = true;
                    }
            i++;
        }
        if (can_hit_earlier) {
            path_actions[i - 1] = 'a';
            x_path[i] = -1;
            y_path[i] = -1;
        }
    }
}

function draw_unit(x, y) {
    var found_move = false;
    var move_kind = 'move';
    var coords = unit.toString().split(',');
    var ux = coords[0].toInt();
    var uy = coords[1].toInt();
    var id;
    var size;
    var teleport = 0;
    var tx = 0;
    var ty = 0;
    var tid;
    var makeGreen;
    if ($chk(board[ux]) && $chk(board[ux][uy]) && $chk(board[ux][uy]['ref'])) {
        id = board[ux][uy]["ref"];
        size = units[board_units[id]["unit_id"]]['size'].toInt();
        if (size > 1) {
            //get left up corner
            board.each(function(items, index) {
                if (items) items.each(function(item, index) {
                    if (item)
                        if (item["ref"] == id && item["type"] == "unit") {
                            if (item["x"].toInt() < ux) ux = item["x"].toInt();
                            if (item["y"].toInt() < uy) uy = item["y"].toInt();
                        }
                });
            });
        }
        //teleport
        board_buildings.each(function(item, index) {
            if (item)
                if ($chk(players_by_num[item['player_num']])) //player num 9 for trees,moat ... doesnt exists
                    if (board_units[id]['magic_immunity'] != 1 && buildings[item["building_id"]]['ui_code'] == 'teleport' && (item['player_num'] == my_player_num || players_by_num[item['player_num']]['team'] == players_by_num[my_player_num]['team'])) { //this is my Teleport or my ally and unit is not golem(magic_immunity==1)
                        tid = item["id"];
                        teleport = 1;
                        //get coords
                        board.each(function(items, index) {
                            if (items) items.each(function(item, index) {
                                if (item)
                                    if (item["ref"] == tid && item["type"] == "building") {
                                        tx = item["x"].toInt();
                                        ty = item["y"].toInt();
                                    }
                            });
                        });
                    }
        });
        var nearSelectedUnit = false;
        var cx;
        var cy;
        for (cx = x - 1; cx < x + 2; cx++)
            for (cy = y - 1; cy < y + 2; cy++) {
                if (board[cx])
                    if (board[cx][cy])
                        if (board[cx][cy]["ref"] == id && board[cx][cy]["type"] == 'unit') nearSelectedUnit = true;
            }
        var goToMultiMove = false;
        if (!nearSelectedUnit) {
            var dist = board_units[id]["moves_left"].toInt();
            if ($chk(board_units[id]["knight"])) dist = dist * 2;
            if (Math.abs(ux - x) <= dist || Math.abs(uy - y) <= dist)
                if ($chk(board[x]) && $chk(board[x][y]) && $chk(board[x][y]['ref'])) {
                    if (board[x][y]['type'] == 'building' || board[x][y]['type'] == 'castle' || board[x][y]['type'] == 'unit') {
                        if (board[x][y]['type'] == 'building' || board[x][y]['type'] == 'castle') pnum = board_buildings[board[x][y]['ref']]['player_num'];
                        if (board[x][y]['type'] == 'unit') pnum = board_units[board[x][y]['ref']]['player_num'];
                        if (board_units[id]['player_num'] != pnum) getUnitPath(ux, uy, x, y, $chk(board_units[id]["knight"]), size);
                    }
                } else {
                    getUnitPath(ux, uy, x, y, $chk(board_units[id]["knight"]), size);
                }
            if (x_path[0] != -1 && y_path[0] != -1 && $chk(x_path[0]) && $chk(y_path[0]) && path_moves <= board_units[id]["moves_left"].toInt()) {
                goToMultiMove = true;
            }
        }
        if (board_units[id]["moves_left"].toInt() > 0 && !$chk(board_units[id]['paralich'])) { //can move
            path_mode = false;
            if (!goToMultiMove) {
                if (size == 1) {
                    if (((x >= ux - 1 && x <= ux + 1) && (y >= uy - 1 && y <= uy + 1) && !$chk(board_units[id]["knight"])) || ($chk(board_units[id]["knight"]) && ((Math.abs(x - ux) == 1 && Math.abs(y - uy) == 2) || (Math.abs(x - ux) == 2 && Math.abs(y - uy) == 1))) || ((x >= tx - size && x <= tx + 1) && (y >= ty - size && y <= ty + 1) && teleport == 1)) { //near unit or knight or teleport
                        if (!board[x] || !board[x][y] || !board[x][y]['type']) {
                            $('board_' + x + '_' + y).addClass('green');
                            found_move = true;
                        } else {
                            if (((x >= ux - 1 && x <= ux + 1) && (y >= uy - 1 && y <= uy + 1) && !$chk(board_units[id]["knight"])) || ($chk(board_units[id]["knight"]) && ((Math.abs(x - ux) == 1 && Math.abs(y - uy) == 2) || (Math.abs(x - ux) == 2 && Math.abs(y - uy) == 1))))
                                if (ux != x || uy != y)
                                    if (board[x][y]['type'] == 'unit') {
                                        if (board_units[id]['player_num'] != board_units[board[x][y]['ref']]['player_num'] && players_by_num[board_units[id]['player_num']]['team'] != players_by_num[board_units[board[x][y]['ref']]['player_num']]['team']) {
                                            addAttackClass(x, y);
                                            move_kind = 'attack';
                                            found_move = true;
                                        }
                                    } else if (board[x][y]['type'] == 'building' || board[x][y]['type'] == 'castle') {
                                if (!players_by_num[board_buildings[board[x][y]['ref']]['player_num']] || (board_units[id]['player_num'] != board_buildings[board[x][y]['ref']]['player_num'] && players_by_num[board_units[id]['player_num']]['team'] != players_by_num[board_buildings[board[x][y]['ref']]['player_num']]['team'])) {
                                    addAttackClass(x, y);
                                    move_kind = 'attack';
                                    found_move = true;
                                }
                            }
                        }
                    }
                } else { //large units
                    if (($chk(board_units[id]["knight"]) && ((Math.abs(x - ux) == 1 && Math.abs(y - uy) == 2) || (Math.abs(x - ux) == 2 && Math.abs(y - uy) == 1))) || ((x >= tx - size && x <= tx + 1) && (y >= ty - size && y <= ty + 1) && teleport == 1 && (!board[x] || !board[x][y] || !board[x][y]['type']))) { //knight or teleport
                        makeGreen = 1;
                        for (mx = x; mx < x + size; mx++)
                            for (my = y; my < y + size; my++) {
                                if (board[mx])
                                    if (board[mx][my])
                                        if (board[mx][my]["ref"])
                                            if (board[mx][my]['type'] != 'unit' || board[mx][my]['ref'] != id) makeGreen = 0;
                                if (mx < 0 || mx > 19 || my < 0 || my > 19) makeGreen = 0;
                            }
                        if (makeGreen == 1) {
                            for (mx = x; mx < x + size; mx++)
                                for (my = y; my < y + size; my++) {
                                    $('board_' + mx + '_' + my).addClass('green');
                                    found_move = true;
                                }
                        } else {
                            if ($chk(board_units[id]["knight"]) && ((Math.abs(x - ux) == 1 && Math.abs(y - uy) == 2) || (Math.abs(x - ux) == 2 && Math.abs(y - uy) == 1)))
                                if (x + 1 <= 19 && y + 1 <= 19)
                                    for (mx = x; mx < x + size; mx++)
                                        for (my = y; my < y + size; my++)
                                            if (board[mx])
                                                if (board[mx][my])
                                                    if (board[mx][my]["ref"])
                                                        if (board[mx][my]['ref'] != id)
                                                            if (board[mx][my]['type'] == 'unit') {
                                                                if (board_units[id]['player_num'] != board_units[board[mx][my]['ref']]['player_num'] && players_by_num[board_units[id]['player_num']]['team'] != players_by_num[board_units[board[mx][my]['ref']]['player_num']]['team']) {
                                                                    addAttackClass(mx, my);
                                                                    move_kind = 'attack';
                                                                    found_move = true;
                                                                }
                                                            } else if (board[mx][my]['type'] == 'building' || board[mx][my]['type'] == 'castle') {
                                if (board_units[id]['player_num'] != board_buildings[board[mx][my]['ref']]['player_num'] && players_by_num[board_units[id]['player_num']]['team'] != players_by_num[board_buildings[board[mx][my]['ref']]['player_num']]['team']) {
                                    addAttackClass(mx, my);
                                    move_kind = 'attack';
                                    found_move = true;
                                }
                            }
                        }
                    } else if ((x >= ux - 1 && x <= ux + size) && (y >= uy - 1 && y <= uy + size) && !$chk(board_units[id]["knight"])) { //usual moves for large units
                        if (x < ux) newx = x;
                        else if (x > (ux + size - 1)) newx = x - size + 1;
                        else newx = ux;
                        if (y < uy) newy = y;
                        else if (y > (uy + size - 1)) newy = y - size + 1;
                        else newy = uy;
                        makeGreen = 1;
                        for (mx = newx; mx < newx + size; mx++)
                            for (my = newy; my < newy + size; my++) {
                                if (board[mx])
                                    if (board[mx][my])
                                        if (board[mx][my]["ref"])
                                            if (board[mx][my]['type'] != 'unit' || board[mx][my]['ref'] != id) makeGreen = 0;
                            }
                        if (makeGreen == 1) {
                            for (mx = newx; mx < newx + size; mx++)
                                for (my = newy; my < newy + size; my++) {
                                    $('board_' + mx + '_' + my).addClass('green');
                                    found_move = true;
                                }
                        } else {
                            if (newx + 1 <= 19 && newy + 1 <= 19)
                                for (mx = newx; mx < newx + size; mx++)
                                    for (my = newy; my < newy + size; my++)
                                        if (board[mx])
                                            if (board[mx][my])
                                                if (board[mx][my]["ref"])
                                                    if (board[mx][my]['ref'] != id)
                                                        if (board[mx][my]['type'] == 'unit') {
                                                            if (board_units[id]['player_num'] != board_units[board[mx][my]['ref']]['player_num'] && players_by_num[board_units[id]['player_num']]['team'] != players_by_num[board_units[board[mx][my]['ref']]['player_num']]['team']) {
                                                                addAttackClass(mx, my);
                                                                move_kind = 'attack';
                                                                found_move = true;
                                                            }
                                                        } else if (board[mx][my]['type'] == 'building' || board[mx][my]['type'] == 'castle') {
                                if (!players_by_num[board_buildings[board[mx][my]['ref']]['player_num']]
                                  ||(
                                      board_units[id]['player_num'] != board_buildings[board[mx][my]['ref']]['player_num']
                                      && players_by_num[board_units[id]['player_num']]['team'] != players_by_num[board_buildings[board[mx][my]['ref']]['player_num']]['team']
                                  )) {
                                    addAttackClass(mx, my);
                                    move_kind = 'attack';
                                    found_move = true;
                                }
                            }
                        }
                    }
                } //end large units
            } //end not multi move
            else { // MULTI MOVES
                path_mode = true;
                found_move = true;
                i = 0;
                while (x_path[i] != -1 && y_path[i] != -1 && board_units[id]["moves_left"].toInt() != i) {
                    //something on the path
                    if ($chk(board[x_path[i]]) && $chk(board[x_path[i]][y_path[i]]) && $chk(board[x_path[i]][y_path[i]]['ref'])) {
                        if (board[x_path[i]][y_path[i]]['type'] == 'unit' && board[x_path[i]][y_path[i]]['ref'] == id) {

                        } else if (size > 1 && path_actions[i] == 'a') { //if the dragon last move is attack
                            for (mx = x_path[i]; mx < x_path[i] + size; mx++)
                                for (my = y_path[i]; my < y_path[i] + size; my++) {
                                    if ($chk(board[mx]) && $chk(board[mx][my]) && $chk(board[mx][my]['ref'])) {
                                        $('board_' + mx + '_' + my).addClass('attackUnit');
                                        move_kind = 'attack';
                                    }
                                }
                        } else {
                            addAttackClass(x_path[i], y_path[i]);
                            move_kind = 'attack';
                        }
                    } else { //free cell
                        if (size > 1 && path_actions[i] == 'a') { //if the dragon last move is attack
                            for (mx = x_path[i]; mx < x_path[i] + size; mx++)
                                for (my = y_path[i]; my < y_path[i] + size; my++) {
                                    if ($chk(board[mx]) && $chk(board[mx][my]) && $chk(board[mx][my]['ref'])) {
                                        $('board_' + mx + '_' + my).addClass('attackUnit');
                                        move_kind = 'attack';
                                    }
                                }
                        } else if (size > 1 && path_actions[i + 1] == 'a') {
                            for (mx = x_path[i]; mx < x_path[i] + size; mx++)
                                for (my = y_path[i]; my < y_path[i] + size; my++)
                                    $('board_' + mx + '_' + my).addClass('green');
                        } else if (size > 1 && x_path[i + 1] == -1 && y_path[i + 1] == -1) {
                            for (mx = x_path[i]; mx < x_path[i] + size; mx++)
                                for (my = y_path[i]; my < y_path[i] + size; my++)
                                    $('board_' + mx + '_' + my).addClass('green');
                        } else $('board_' + x_path[i] + '_' + y_path[i]).addClass('green');
                    }
                    i++;
                }
            }
        } //end can move
        if (found_move) {
            if (move_kind == 'move') {
                $('overboard').addClass('cursor_move');
                $('overboard_' + x + '_' + y).addClass('cursor_move');
            } else {
                $('overboard').addClass('cursor_attack');
                $('overboard_' + x + '_' + y).addClass('cursor_attack');
            }
        }
    } //end $chk
}

function clean_unit(x, y) {

    $('overboard').removeClass('cursor_move');
    $('overboard_' + x + '_' + y).removeClass('cursor_move');
    $('overboard').removeClass('cursor_attack');
    $('overboard_' + x + '_' + y).removeClass('cursor_attack');

    var coords = unit.toString().split(',');
    var ux = coords[0].toInt();
    var uy = coords[1].toInt();
    var id;
    var size;
    var mx;
    var my;
    var i = 0;
    if ($chk(board[ux]) && $chk(board[ux][uy]) && $chk(board[ux][uy]['ref'])) {
        id = board[ux][uy]["ref"];
        size = units[board_units[id]["unit_id"]]['size'].toInt();
        if (!path_mode) {
            if (size == 1) {
                $('board_' + x + '_' + y).removeClass('green');
                removeAttackClass(x, y)
            } else { //large_units
                for (mx = x - size; mx < x + size; mx++)
                    for (my = y - size; my < y + size; my++)
                        if ($('board_' + mx + '_' + my)) {
                            $('board_' + mx + '_' + my).removeClass('green');
                            removeAttackClass(mx, my)
                        }
            }
        } else {
            i = 0;
            while (x_path[i] != -1 && y_path[i] != -1 && board_units[id]["moves_left"].toInt() != i) {
                if ($chk(board[x_path[i]]) && $chk(board[x_path[i]][y_path[i]]) && $chk(board[x_path[i]][y_path[i]]['ref']))
                    if (size > 1 && path_actions[i] == 'a') { //if the dragon last move is attack
                        for (mx = x_path[i]; mx < x_path[i] + size; mx++)
                            for (my = y_path[i]; my < y_path[i] + size; my++) {
                                if ($chk(board[mx]) && $chk(board[mx][my]) && $chk(board[mx][my]['ref'])) {
                                    $('board_' + mx + '_' + my).removeClass('attackUnit');
                                }
                            }
                    } else removeAttackClass(x_path[i], y_path[i]);
                else {
                    if (size > 1 && path_actions[i] == 'a') { //if the dragon last move is attack
                        for (mx = x_path[i]; mx < x_path[i] + size; mx++)
                            for (my = y_path[i]; my < y_path[i] + size; my++) {
                                if ($chk(board[mx]) && $chk(board[mx][my]) && $chk(board[mx][my]['ref'])) {
                                    $('board_' + mx + '_' + my).removeClass('attackUnit');
                                }
                            }
                    } else if (size > 1 && path_actions[i + 1] == 'a') {
                        for (mx = x_path[i]; mx < x_path[i] + size; mx++)
                            for (my = y_path[i]; my < y_path[i] + size; my++)
                                $('board_' + mx + '_' + my).removeClass('green');
                    } else if (size > 1 && x_path[i + 1] == -1 && y_path[i + 1] == -1) {
                        for (mx = x_path[i]; mx < x_path[i] + size; mx++)
                            for (my = y_path[i]; my < y_path[i] + size; my++)
                                $('board_' + mx + '_' + my).removeClass('green');
                    } else $('board_' + x_path[i] + '_' + y_path[i]).removeClass('green');
                }
                i++;
            }
            path_mode = false;
            x_path[0] = -1;
            y_path[0] = -1;
        }
    } // end $chk
}

function draw_unit_attack(x, y) {
    var found_attack = false;
    var coords = unit.toString().split(',');
    var ux = coords[0].toInt();
    var uy = coords[1].toInt();
    var id = board[ux][uy]["ref"];
    var size = units[board_units[id]["unit_id"]]['size'].toInt();
    var makeGreen;
    var newx;
    var newy;
    if (size > 1) {
        //get left up corner
        board.each(function(items, index) {
            if (items) items.each(function(item, index) {
                if (item)
                    if (item["ref"] == id && item["type"] == "unit") {
                        if (item["x"].toInt() < ux) ux = item["x"].toInt();
                        if (item["y"].toInt() < uy) uy = item["y"].toInt();
                    }
            });
        });
    }
    if (board_units[id]["moves_left"].toInt() > 0 && !$chk(board_units[id]['paralich'])) { //can move
        if (size == 1) {
            if (((x >= ux - 1 && x <= ux + 1) && (y >= uy - 1 && y <= uy + 1) && !$chk(board_units[id]["knight"])) || ($chk(board_units[id]["knight"]) && ((Math.abs(x - ux) == 1 && Math.abs(y - uy) == 2) || (Math.abs(x - ux) == 2 && Math.abs(y - uy) == 1)))) { //near unit or knight
                if (!board[x] || !board[x][y] || !board[x][y]['type']);
                else {
                    if (ux != x || uy != y) {
                        addAttackClass(x, y)
                        found_attack = true;
                    }
                }
            }
        } else { //large units
            if ($chk(board_units[id]["knight"]) && ((Math.abs(x - ux) == 1 && Math.abs(y - uy) == 2) || (Math.abs(x - ux) == 2 && Math.abs(y - uy) == 1))) {
                makeGreen = 1;
                for (mx = x; mx < x + size; mx++)
                    for (my = y; my < y + size; my++)
                        if (board[mx])
                            if (board[mx][my])
                                if (board[mx][my]["ref"])
                                    if (board[mx][my]['type'] != 'unit' || board[mx][my]['ref'] != id) makeGreen = 0;
                if (makeGreen == 1) {} else {
                    if (x + 1 <= 19 && y + 1 <= 19)
                        for (mx = x; mx < x + size; mx++)
                            for (my = y; my < y + size; my++)
                                if (board[mx])
                                    if (board[mx][my])
                                        if (board[mx][my]["ref"])
                                            if (board[mx][my]['ref'] != id) {
                                                addAttackClass(mx, my)
                                                found_attack = true;
                                            }
                }
            } else if ((x >= ux - 1 && x <= ux + size) && (y >= uy - 1 && y <= uy + size) && !$chk(board_units[id]["knight"])) { //usual moves for large
                if (x < ux) newx = x;
                else if (x > (ux + size - 1)) newx = x - size + 1;
                else newx = ux;
                if (y < uy) newy = y;
                else if (y > (uy + size - 1)) newy = y - size + 1;
                else newy = uy;

                makeGreen = 1;
                for (mx = newx; mx < newx + size; mx++)
                    for (my = newy; my < newy + size; my++)
                        if (board[mx])
                            if (board[mx][my])
                                if (board[mx][my]["ref"])
                                    if (board[mx][my]['type'] != 'unit' || board[mx][my]['ref'] != id) makeGreen = 0;
                if (makeGreen == 1) {} else {
                    if (newx + 1 <= 19 && newy + 1 <= 19)
                        for (mx = newx; mx < newx + size; mx++)
                            for (my = newy; my < newy + size; my++)
                                if (board[mx])
                                    if (board[mx][my])
                                        if (board[mx][my]["ref"])
                                            if (board[mx][my]['ref'] != id) {
                                                addAttackClass(mx, my)
                                                found_attack = true;
                                            }
                }
            }
        }
    } //end can move
    if (found_attack) {
        $('overboard').addClass('cursor_attack');
        $('overboard_' + x + '_' + y).addClass('cursor_attack');
    }
}

function addAttackClass(x, y) {
    if ($chk(board[x]) && $chk(board[x][y]) && $chk(board[x][y]['ref'])) {
        var id = board[x][y]["ref"];
        var ux = x;
        var uy = y;
        if (board[x][y]["type"] == 'u') {
            var size = units[board_units[id]["unit_id"]]['size'].toInt();
            if (size > 1) {
                //get left up corner
                board.each(function(items, index) {
                    if (items) items.each(function(item, index) {
                        if (item)
                            if (item["ref"] == id && item["type"] == "unit") {
                                if (item["x"].toInt() > ux) ux = item["x"].toInt();
                                if (item["y"].toInt() > uy) uy = item["y"].toInt();
                            }
                    });
                });
            }
        }
        $('board_' + ux + '_' + uy).addClass('attackUnit');
    }
}

function removeAttackClass(x, y) {
    if ($chk(board[x]) && $chk(board[x][y]) && $chk(board[x][y]['ref'])) {
        var id = board[x][y]["ref"];
        var ux = x;
        var uy = y;
        if (board[x][y]["type"] == 'u') {
            var size = units[board_units[id]["unit_id"]]['size'].toInt();
            if (size > 1) {
                //get left up corner
                board.each(function(items, index) {
                    if (items) items.each(function(item, index) {
                        if (item)
                            if (item["ref"] == id && item["type"] == "unit") {
                                if (item["x"].toInt() > ux) ux = item["x"].toInt();
                                if (item["y"].toInt() > uy) uy = item["y"].toInt();
                            }
                    });
                });
            }
        }
        $('board_' + ux + '_' + uy).removeClass('attackUnit');
    }
}

function clean_unit_attack(x, y) {
    $('overboard').removeClass('cursor_attack');
    $('overboard_' + x + '_' + y).removeClass('cursor_attack');
    var coords = unit.toString().split(',');
    var ux = coords[0].toInt();
    var uy = coords[1].toInt();
    var id = board[ux][uy]["ref"];
    var size = units[board_units[id]["unit_id"]]['size'].toInt();
    var mx;
    var my;
    if (size == 1) {
        removeAttackClass(x, y)
    } else { //large_units
        for (mx = x - size; mx < x + size; mx++)
            for (my = y - size; my < y + size; my++)
                if ($('board_' + mx + '_' + my)) {
                    removeAttackClass(mx, my)
                }
    }
}

function draw_meteor_coords(x, y) {
    var mx;
    var my;
    if (x < 19 && y < 19)
        for (mx = x; mx < x + 2; mx++)
            for (my = y; my < y + 2; my++)
                if ($('board_' + mx + '_' + my)) $('board_' + mx + '_' + my).addClass('attackUnit');
}

function clean_meteor_coords(x, y) {
    var mx;
    var my;
    if (x < 19 && y < 19)
        for (mx = x; mx < x + 2; mx++)
            for (my = y; my < y + 2; my++)
                if ($('board_' + mx + '_' + my)) $('board_' + mx + '_' + my).removeClass('attackUnit');
}

function draw_empty_coord_my_zone(x, y) {
    if (!$chk(board[x])) {
        if (my_quart(x, y)) $('board_' + x + '_' + y).addClass('green');
    } else if (!$chk(board[x][y]) && my_quart(x, y)) $('board_' + x + '_' + y).addClass('green');
}

function clean_empty_coord_my_zone(x, y) {
    $('board_' + x + '_' + y).removeClass('green');
}

function draw_teleport_unit(x, y) {
    var coords = unit.toString().split(',');
    var ux = coords[0].toInt();
    var uy = coords[1].toInt();
    var id = board[ux][uy]["ref"];
    var size = units[board_units[id]["unit_id"]]['size'].toInt();
    var cango = true;
    var mx;
    var my;
    for (mx = x; mx < x + size; mx++)
        for (my = y; my < y + size; my++)
            if (mx < 0 || mx > 19 || y < 0 || y > 19) cango = false;
            else if ($chk(board[mx]))
        if ($chk(board[mx][my])) cango = false;
    for (mx = x; mx < x + size; mx++)
        for (my = y; my < y + size; my++)
            if ($('board_' + mx + '_' + my))
                if (cango) $('board_' + mx + '_' + my).addClass('green');
                else $('board_' + mx + '_' + my).addClass('red');
}

function clean_teleport_unit(x, y) {
    var coords = unit.toString().split(',');
    var ux = coords[0].toInt();
    var uy = coords[1].toInt();
    var id = board[ux][uy]["ref"];
    var size = units[board_units[id]["unit_id"]]['size'].toInt();
    var mx;
    var my;
    for (mx = x; mx < x + size; mx++)
        for (my = y; my < y + size; my++)
            if ($('board_' + mx + '_' + my)) {
                $('board_' + mx + '_' + my).removeClass('green');
                $('board_' + mx + '_' + my).removeClass('red');
            }
}

function draw_zone(x, y) {
    var zone = 3;
    if (x < 10 && y < 10) zone = 0;
    else if (x >= 10 && y < 10) zone = 1;
    else if (x >= 10 && y >= 10) zone = 2;

    $$('#board .zone_' + zone).addClass('green');
}

function draw_building_select(x, y) {
    if (board[x] != undefined) {
        if (board[x][y] != undefined) {
            if (board[x][y]['type'] == 'building' || board[x][y]['type'] == 'obstacle') $('board_' + x + '_' + y).addClass('activeUnit');
        }
    }
}

function clean_building_select(x, y) {
    if (board[x] != undefined) {
        if (board[x][y] != undefined) {
            if (board[x][y]['type'] == 'building' || board[x][y]['type'] == 'obstacle') $('board_' + x + '_' + y).removeClass('activeUnit');
        }
    }
}

function clean_zone(x, y) {
    $$('#board .board_cell').removeClass('green');
}

function clean_attack() {
    //clear red outline
    var coords = unit.toString().split(',');
    var ux = coords[0].toInt();
    var uy = coords[1].toInt();
    $('board_' + ux + '_' + uy).removeClass('activeUnit');
    var id = board[ux][uy]["ref"];
    var mx;
    var my;
    if ($chk(board_units[id])) {
        var size = units[board_units[id]["unit_id"]]['size'].toInt();
        if (game_state != 'SELECTING_ATTACK_COORD') {
            var coords2 = attack_coord.toString().split(',');
            var x = coords2[0].toInt();
            var y = coords2[1].toInt();
            if (size == 1) {
                $('board_' + x + '_' + y).removeClass('attackUnit');
            } else { //large_units
                for (mx = x; mx < x + size; mx++)
                    for (my = y; my < y + size; my++)
                        if ($('board_' + mx + '_' + my)) {
                            $('board_' + mx + '_' + my).removeClass('attackUnit');
                        }
            }
        }
    }
}

function clean_player_move_unit() {
    //clear green class
    var ex;
    var ey;
    var coords = unit.toString().split(',');
    var ux = coords[0].toInt();
    var uy = coords[1].toInt();
    var id;
    var size;
    var mx;
    var my;
    $('board_' + ux + '_' + uy).removeClass('activeUnit');
    if (empty_coord != '') {
        coords = empty_coord.toString().split(',');
        ex = coords[0].toInt();
        ey = coords[1].toInt();
    }
    if ($chk(board[ex]) && $chk(board[ex][ey])) id = board[ex][ey]["ref"];
    else id = board[ux][uy]["ref"];
    if ($chk(board_units[id])) {
        size = units[board_units[id]["unit_id"]]['size'].toInt();
        if (game_state != 'SELECTING_EMPTY_COORD') {
            var coords2 = empty_coord.toString().split(',');
            var x = coords2[0].toInt();
            var y = coords2[1].toInt();
            if (size == 1) {
                $('board_' + x + '_' + y).removeClass('green');
            } else { //large_units
                for (mx = x; mx < x + size; mx++)
                    for (my = y; my < y + size; my++)
                        if ($('board_' + mx + '_' + my)) {
                            $('board_' + mx + '_' + my).removeClass('green');
                        }
            }
        }
    }
}

function hideCards() {
    cardsSlider.slideOut();
    $('cardsLink').removeClass('cards');
    $('cardsLink').addClass('cardsunactive');
}

function showCards() {
    cardsSlider.slideIn();
    $('cardsLink').addClass('cards');
    $('cardsLink').removeClass('cardsunactive');
}

function hideGrave() {
    graveSlider.slideOut();
    $('graveLink').removeClass('cementary');
    $('graveLink').addClass('cementaryunactive');
}

function showGrave() {
    graveSlider.slideIn();
    $('graveLink').addClass('cementary');
    $('graveLink').removeClass('cementaryunactive');
}

function hideAllCards() {
    allCardsSlider.slideOut();
    $('allcardstopLink').removeClass('allcardsbottom');
    $('allcardstopLink').addClass('allcardstopunactive');
}

function showAllCards() {
    allCardsSlider.slideIn();
    $('allcardstopLink').removeClass('allcardstopunactive');
    $('allcardstopLink').addClass('allcardsbottom');
}

function hideSliders() {
    hideCards();
    hideGrave();
    hideAllCards();
}

function openCards() {
    hideGrave();
    hideAllCards();
    if (cardsSlider.open) hideCards();
    else showCards();
}

function openGrave() {
    hideCards();
    hideAllCards();
    if (graveSlider.open) hideGrave();
    else showGrave();
}

function openAllcardstop() {
    var cont = '';
    if ($('cardsLink').hasClass('cards')) cont = 'cards_holder';
    if ($('graveLink').hasClass('cementary')) cont = 'grave_holder';
    if (cont == '') cont = 'cards_holder';

    $('fullsize_holder').set('html', '');

    $(cont).getChildren('div').each(function(item, index) {
        var newItem = item.clone().cloneEvents(item);
        newItem.setStyle('left', '');
        newItem.setStyle('position', 'relative');
        $('fullsize_holder').grab(newItem);
    });

    allCardsSlider.toggle();
    if (!allCardsSlider.open) {
        $('allcardstopLink').removeClass('allcardstopunactive');
        $('allcardstopLink').addClass('allcardsbottom');
        cardsSlider.slideOut('vertical');
        graveSlider.slideOut('vertical');
    } else {
        $('allcardstopLink').removeClass('allcardsbottom');
        $('allcardstopLink').addClass('allcardstopunactive');
        if ($('cardsLink').hasClass('cards')) cardsSlider.slideIn('vertical');
        if ($('graveLink').hasClass('cementary')) graveSlider.slideIn('vertical');
    }
}

function makeCardsCarousel() {
    cardsCarousel = new Carousel({
        container: 'cards_holder',
        prevb: 'left_roll',
        nextb: 'right_roll',
        quantity: 5,
        current: -1
    });
    $('cards_holder').addEvent('mousewheel', function(event) {
        event = new Event(event);
        if (event.wheel > 0) {
            cardsCarousel.quantity = 1;
            cardsCarousel.move(1);
            cardsCarousel.quantity = 5;
        } else if (event.wheel < 0) {
            cardsCarousel.quantity = 1;
            cardsCarousel.move(-1);
            cardsCarousel.quantity = 5;
        }
    });
}

function makeGraveCarousel() {
    graveCarousel = new Carousel({
        container: 'grave_holder',
        prevb: 'left_roll_grave',
        nextb: 'right_roll_grave',
        quantity: 5,
        current: -1
    });
    $('grave_holder').addEvent('mousewheel', function(event) {
        event = new Event(event);
        if (event.wheel > 0) {
            graveCarousel.quantity = 1;
            graveCarousel.move(1);
            graveCarousel.quantity = 5;
        } else if (event.wheel < 0) {
            graveCarousel.quantity = 1;
            graveCarousel.move(-1);
            graveCarousel.quantity = 5;
        }
    });
}

function showWindow(title, text, w, h, hideCloseButton) {
    $('window_h').set('text', title);
    $('window_c').set('html', text);
    $('window_c').setStyle('width', w);
    $('window_c').setStyle('height', h);
    $('window_m').setStyle('display', 'block');
    $('window_m').setStyle('height', document.getScrollSize().y);
    if (hideCloseButton) $('window_close').setStyle('display', 'none');
    else $('window_close').setStyle('display', 'block');
    $('window_w').position();
}

function appendWindow(title, text, w, h, hideCloseButton) {
    $('window_h').set('text', $('window_h').get('text') + title);
    $('window_c').set('html', $('window_c').get('html') + text);
    $('window_c').setStyle('width', w);
    $('window_c').setStyle('height', h);
    $('window_m').setStyle('display', 'block');
    $('window_m').setStyle('height', document.getScrollSize().y);
    if (hideCloseButton) $('window_close').setStyle('display', 'none');
    else $('window_close').setStyle('display', 'block');
    $('window_w').position();
}

function changeShield() {
    if ($('shield').hasClass('nobg')) {
        $('shield').removeClass('nobg');
        $('board').removeClass('red');
        if (movedUnits) {
            $$('#board .my-brd-unit').removeClass('remind');
        }
    } else {
        $('shield').addClass('nobg');
        $('board').addClass('red');
        if (movedUnits) {
            $$('#board .my-brd-unit').addClass('remind');
        }
    }
}

function changeTitle() {
    if (document.title != winTitle) {
        document.title = winTitle;
        if ($('site_icon')) $('site_icon').dispose();
        var favicon = new Element('link', {
            'href': '../../design/images/icon_lords.ico',
            'rel': 'icon',
            'id': 'site_icon',
            'type': 'image/x-icon'
        });
        document.getElement('head').grab(favicon, 'bottom');
    } else {
        document.title = 'Ваш ход - ' + winTitle;
        if ($('site_icon')) $('site_icon').dispose();
        var favicon = new Element('link', {
            'href': '../../design/images/icon_attention.ico',
            'rel': 'icon',
            'id': 'site_icon',
            'type': 'image/x-icon'
        });
        document.getElement('head').grab(favicon, 'bottom');
    }
}

function stopShield() {
    if (turn_state == MY_TURN) newRemindTimer();
    if (was_active == 0) {
        clearInterval(shieldInterval);
        clearInterval(titleInterval);
        $('shield').removeClass('nobg');
        $('board').removeClass('red');
        if (movedUnits) {
            $$('#board .my-brd-unit').removeClass('remind');
        }
        document.title = winTitle;
        was_active = 1;
        if ($('site_icon')) $('site_icon').dispose();
        var favicon = new Element('link', {
            'href': '../../design/images/icon_lords.ico',
            'rel': 'icon',
            'id': 'site_icon',
            'type': 'image/x-icon'
        });
        document.getElement('head').grab(favicon, 'bottom');
    }
}

function stopClick(e) {
    if (!e) var e = window.event;
    e.cancelBubble = true;
    if (e.stopPropagation) e.stopPropagation();
}

function markCoords(x, y) {
    if ($('board_' + x + '_' + y)) $('board_' + x + '_' + y).addClass('markCoords');
}

function demarkCoords(x, y) {
    if ($('board_' + x + '_' + y)) $('board_' + x + '_' + y).removeClass('markCoords');
}

function markCoords2(x, y) {
    if ($('board_' + x + '_' + y)) $('board_' + x + '_' + y).addClass('markCoords2');
}

function demarkCoords2(x, y) {
    if ($('board_' + x + '_' + y)) $('board_' + x + '_' + y).removeClass('markCoords2');
}

function drawArrow(x, y, x2, y2, color) {
    x = x + 8;
    y = y + 8;
    x2 = x2 + 8;
    y2 = y2 + 8;

    var w = 4;
    var l = Math.sqrt(Math.pow((x2 - x), 2) + Math.pow((y2 - y), 2));
    var sina = Math.abs(x2 - x) / l;

    var angl = 0;

    if (x2 > x && y2 > y) angl = Math.PI / 2 - Math.asin(sina);
    else if (x == x2 && y2 > y) angl = Math.PI / 2;
    else if (x2 < x && y2 > y) angl = Math.PI / 2 + Math.asin(sina);
    else if (y == y2 && x2 < x) angl = Math.PI;
    else if (x2 < x && y2 < y) angl = Math.PI + Math.PI / 2 - Math.asin(sina);
    else if (x == x2 && y2 < y) angl = Math.PI + Math.PI / 2;
    else if (x2 > x && y2 < y) angl = Math.PI * 1.5 + Math.asin(sina);

    var ctx = $('canvas').getContext('2d');
    ctx.clearRect(0, 0, 715, 715);
    ctx.beginPath();

    ctx.translate(x, y);
    ctx.rotate(angl);

    ctx.fillStyle = color;

    ctx.fillRect(0, -w / 2, l - 3 * w, w);

    ctx.moveTo(l, 0);
    ctx.lineTo(l - 3 * w, 1.5 * w);
    ctx.lineTo(l - 3 * w, -1.5 * w);
    ctx.lineTo(l, 0);
    ctx.fill();

    ctx.rotate(-angl);

    ctx.translate(-x, -y);
    //context.clearRect ( x , y , w , h );
}

function clearArrowRect(x, y, x2, y2) {
    x = x + 8;
    y = y + 8;
    x2 = x2 + 8;
    y2 = y2 + 8;
    var w = 4;
    var l = Math.sqrt(Math.pow((x2 - x), 2) + Math.pow((y2 - y), 2));
    var sina = Math.abs(x2 - x) / l;

    var angl = 0;

    if (x2 > x && y2 > y) angl = Math.PI / 2 - Math.asin(sina);
    else if (x == x2 && y2 > y) angl = Math.PI / 2;
    else if (x2 < x && y2 > y) angl = Math.PI / 2 + Math.asin(sina);
    else if (y == y2 && x2 < x) angl = Math.PI;
    else if (x2 < x && y2 < y) angl = Math.PI + Math.PI / 2 - Math.asin(sina);
    else if (x == x2 && y2 < y) angl = Math.PI + Math.PI / 2;
    else if (x2 > x && y2 < y) angl = Math.PI * 1.5 + Math.asin(sina);

    var ctx = $('canvas').getContext('2d');
    ctx.translate(x, y);
    ctx.rotate(angl);

    ctx.clearRect(-w, -2 * w, l + w, 4 * w);

    ctx.rotate(-angl);

    ctx.translate(-x, -y);
}

function displayLordsError(e, str) {
    var file_line = '';
    if (Browser.opera) file_line = '<br /><b>' + i18n[USER_LANGUAGE]["game"]["error_file"] + '+' + i18n[USER_LANGUAGE]["game"]["error_line"] + ':</b>' + e.stacktrace;
    else if (Browser.firefox || Browser.chrome) file_line = '<br /><b>' + i18n[USER_LANGUAGE]["game"]["error_file"] + '+' + i18n[USER_LANGUAGE]["game"]["error_line"] + ':</b>' + e.stack;
    else file_line = '<br /><b>' + i18n[USER_LANGUAGE]["game"]["error_file"] + ':</b>' + e.fileName + '<br /><b>' + i18n[USER_LANGUAGE]["game"]["error_line"] + ':</b>' + e.lineNumber;
    var error_html = '<b>' + i18n[USER_LANGUAGE]["game"]["js_error"] + ':</b> ' + e.name + '<br /><b>' + i18n[USER_LANGUAGE]["game"]["error_msg"] + ':</b>' + e.message + file_line + '<br /><b>' + i18n[USER_LANGUAGE]["game"]["error_commands"] + ':</b><br />' + str + '<br />';
    error_html += '<b>' + i18n[USER_LANGUAGE]["game"]["error_browser"] + ':</b> ' + Browser.name + '(v.' + Browser.version + ')' + ' Platform:' + Browser.Platform.name + '<br />';
    error_html += '<b>' + i18n[USER_LANGUAGE]["game"]["error_comment"] + ':</b> <br /><textarea id="error_comment" style="width:400px;height:80px;" onfocus="chatFocused = true;" onblur="chatFocused = false;"> </textarea><br /><input onclick="this.hide();sendError();return false;" id="send_error_button" type="submit" value="' + i18n[USER_LANGUAGE]["game"]["error_send"] + '"><input onclick="window.location.reload();return false;" type="submit" value="' + i18n[USER_LANGUAGE]["game"]["error_reload_game"] + '">'
    error_html += '<div id="send_answer" style="color:black;"></div><img src="../../design/images/ajax-loader.gif" id="error_send_indicator" style="display:none">';
    var errDiv = new Element('div', {
        'html': error_html,
        'class': 'error_window'
    });
    document.body.grab(errDiv, 'top');
}

function sendError() {
    $('error_send_indicator').show();
    $('send_answer').set('text', i18n[USER_LANGUAGE]["game"]["error_wait"]);

    //generate js vars and objects
    var exclude_objs = new Array('window', 'navigator', 'document', 'InstallTrigger', 'console', 'MooTools', 'Browser', 'Slick', 'Selectors', 'Asset', 'Locale', 'Form', 'sessionStorage', 'globalStorage', 'localStorage', 'parent', 'top', 'scrollbars', 'frames', 'applicationCache', 'self', 'screen', 'history', 'content', 'menubar', 'toolbar', 'locationbar', 'personalbar', 'statusbar', 'crypto', 'controllers', 'mozIndexedDB', 'URL', 'commandsRequest', 'chatCommandsRequest', '_firebug', 'mySortables');
    var ret = '\n';
    for (var i in window) {
        if (window[i] && window[i].valueOf && typeof(window[i]) != 'function' && i != 'init_eval' && !exclude_objs.contains(i)) {
            if (typeof(window[i]) == 'object') { //obj arr
                if (is_array(window[i])) { //array
                    var_str = arrToStrs(i, window[i]);
                } else //object
                    //var_str = objToStrs(i,window[i],true,0);
                    var_str = '';
            } else if (typeof(window[i]) == 'string') { //str
                var_str = i + '=\'' + addslashes(window[i]) + '\';\n';
            } else if (typeof(window[i]) == 'number' || typeof(window[i]) == 'boolean') { //num bool
                var_str = i + '=' + window[i].valueOf() + ';\n';
            }
            ret += var_str;
        }
    }
    //console.log(ret);
    ret += '\n';
    //send error data with page html
    var myRequest = new Request({
        method: 'post',
        url: 'ajax/post_error_message.php',
        onSuccess: function(answer) {
            $('error_send_indicator').hide();
            $('send_answer').set('html', answer);
        }
    }).send('head=' + encodeURIComponent(document.head.get('html')) + '&body=' + encodeURIComponent(document.body.get('html')) + '&comment=' + encodeURIComponent($('error_comment').get('value')) + '&add_script=' + encodeURIComponent(ret));
}

function addslashes(str) {
    str = str.replace(/\\/g, '\\\\');
    str = str.replace(/\'/g, '\\\'');
    str = str.replace(/\"/g, '\\"');
    str = str.replace(/\0/g, '\\0');
    return str;
}

function stripslashes(str) {
    str = str.replace(/\\'/g, '\'');
    str = str.replace(/\\"/g, '"');
    str = str.replace(/\\0/g, '\0');
    str = str.replace(/\\\\/g, '\\');
    return str;
}

function is_array(input) {
    return typeof(input) == 'object' && (input instanceof Array);
}

function arrToStrs(name, arr) {
    var arr_str = name + '=' + 'new Array();\n';
    var arr_keys = Object.keys(arr);
    var arr_values = Object.values(arr);
    arr_keys.each(function(item, index) {
        if (typeof(arr_values[index]) == 'object') {
            if (is_array(arr_values[index])) arr_str += arrToStrs(name + '["' + item + '"]', arr[item]);
            else {
                //arr_str += name+'["'+item+'"]='+objToStrs(item,arr[item],false,1)+';\n';
                arr_str += name + '["' + item + '"]="object_here";\n';
            }
        } else if (typeof(arr_values[index]) == 'string') arr_str += name + '["' + item + '"]=\'' + addslashes(arr_values[index]) + '\';\n';
        else arr_str += name + '["' + item + '"]=' + arr_values[index] + ';\n';
    });
    return arr_str;
}

function objToStrs(name, obj, addName, level) {
    var tabs = '';
    for (i = 0; i <= level; i++) {
        tabs += '\t';
    }
    var tabs_1 = '';
    for (i = 0; i <= level - 1; i++) {
        tabs_1 += '\t';
    }
    if (addName) var obj_str = '\n' + name + '=' + '{\n';
    else var obj_str = '{\n';
    var obj_keys = Object.keys(obj);
    var obj_values = Object.values(obj);
    for (var i in obj) {
        if (obj[i] && obj[i].valueOf && typeof(obj[i]) == 'function') {
            var temp_obj_str = tabs + i + ': ' + obj[i].valueOf() + ',\n';
            obj_str += temp_obj_str.replace('[native code]', '');
        }
    }
    obj_keys.each(function(item, index) {
        if (typeof(obj_values[index]) != 'object') {
            if (typeof(obj_values[index]) == 'string') obj_str += tabs + item + ': \'' + addslashes(obj_values[index]) + '\',\n';
            else obj_str += tabs + item + ': ' + obj_values[index] + ',\n';
        } else { //obj
            if (!$chk(obj[item]) || typeof(obj[item].get) != 'function') {
                if (!$chk(obj[item])) obj_str += tabs + item + ': null,\n';
                else obj_str += tabs + item + ': ' + objToStrs(item, obj[item], false, level + 1) + ',\n';
            } else { //element
                if ($chk(obj[item].get('id'))) obj_str += tabs + item + ': $(\'' + obj[item].get('id') + '\'),\n';
                else if ($chk(obj[item].getChildren()[0]) && $chk(obj[item].getChildren()[0].get('id'))) obj_str += tabs + item + ': $(\'' + obj[item].getChildren()[0].get('id') + '\').getParent(),\n';
                else obj_str += tabs + item + ': null,\n';
            }
        }
    });
    if (addName) obj_str += '};';
    else obj_str += tabs_1 + '}';
    return obj_str;
}
