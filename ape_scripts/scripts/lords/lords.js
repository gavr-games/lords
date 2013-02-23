var logging = true;
var delete_game_timeout = 900000;
var phrase_min_timeout = 120000;
var phrase_interval_timeout = 120000;
var users_by_id = new Array();
var phrases_timers = new $H;
var endturn_timers = new $H;
var allgames = new $H;
Ape.addEvent("init", function () {

    function sendPhrase(gm_id) {
        var phrequest = new Http(lords_domain + '/game/mode'+allgames.get(gm_id).mode_id+'/ajax/get_unit_phrase.php');
        phrequest.set('method', 'POST');
        phrequest.writeObject({
            'game_id': gm_id
        });
        phrequest.getContent(function (phresult) {
            if (logging) Ape.log('phrase[' + gm_id + ']:' + phresult);
            var phans = games = JSON.parse(phresult);
            var game_channel = Ape.getChannelByName('arenagame_' + gm_id);
            if (game_channel) game_channel.pipe.sendRaw('game_raw', {
                commands: encodeURIComponent('show_unit_message(' + phans.board_unit_id + ',' + phans.phrase_id + ');')
            });
        });
        phrases_timers.set(gm_id, Ape.setTimeout(function (g_id) {
            sendPhrase(g_id);
            //send delete game request
        }, Math.floor(phrase_min_timeout + Math.random() * phrase_interval_timeout), gm_id));
    }

    function sendNextTurn(gm_id, tm_rs, pl_num) {
      if (logging) Ape.log('end turn by timeout start');
        var ntrequest = new Http(lords_domain + '/game/mode'+allgames.get(gm_id).mode_id+'/ajax/end_turn_timeout.php');
      if (logging) Ape.log('end turn by timeout before post');
        ntrequest.set('method', 'POST');
      if (logging) Ape.log('end turn by timeout params: '+gm_id+'/'+pl_num);
        ntrequest.writeObject({
            'game_id': gm_id,
            'player_num': pl_num
        });
      if (logging) Ape.log('end turn by timeout before send');
        ntrequest.getContent(function (ntresult) {
            if (logging) Ape.log('end_turn_by_timeout[' + gm_id + '/' + tm_rs + '/'+pl_num+']:' + ntresult);
            var ntans = JSON.parse(ntresult);

            var game = Ape.getChannelByName('arenagame_' + gm_id);
            var game_cmds = '';
            var hidden_cmds = new $H;

            if (ntans.header_result.success == "1") {
                ntans.data_result.each(function (cmd) {
                    if (cmd.command.indexOf("set_active_player(") != -1) {
                        var next_p_num = cmd.command.split(',');
                        next_p_num = next_p_num[0].split('(');
			if (next_p_num[1]<4){
			  var next_pl_num = next_p_num[1];
			  setNextTurnTimeout(gm_id, tm_rs, next_pl_num.toInt());
			}
                    }
                    if (cmd.command.indexOf("NPC(") != -1) {//load npc service
                        var npc_p_num = cmd.command.split('(');
                        npc_p_num = npc_p_num[1].split(')');
			var npc_pl_num = npc_p_num[0];
			callNPC(gm_id,npc_pl_num);
                    }
                    if (cmd.hidden_flag == 0) game_cmds += encodeURIComponent(cmd.command) + ";";
                    else if (hidden_cmds.get(cmd.user_id) == null) hidden_cmds.set(cmd.user_id, encodeURIComponent(cmd.command) + ";");
                    else hidden_cmds.set(cmd.user_id, hidden_cmds.get(cmd.user_id) + encodeURIComponent(cmd.command) + ";");
                });
            }

            if (game_cmds != '' && game) {
                game.pipe.sendRaw('game_raw', {
                    commands: game_cmds
                });
            }
            hidden_cmds.each(function (v, k) {
                var huser = Ape.getUserByPubid(users_by_id[k.toInt()]);
                if (huser) huser.pipe.sendRaw('game_raw', {
                    commands: v
                });
            });
        });
	if (logging) Ape.log('end turn by timeout after send');
    }

    function setNextTurnTimeout(gm_id, tm_rs, pl_num) {
      if (logging) Ape.log('set next turn timeout:'+gm_id+'/'+pl_num);
        endturn_timers.set(gm_id, Ape.setTimeout(function (g_id, t_rs, p_num) {
	  if (logging) Ape.log('set next turn timeout executed:'+g_id+'/'+p_num);
            sendNextTurn(g_id, t_rs, p_num);
        }, tm_rs, gm_id, tm_rs, pl_num));
    }

    var gamesrequest = new Http(lords_domain + '/site/ajax/get_games_info.php');
    gamesrequest.set('method', 'POST');
    gamesrequest.getContent(function (gamesresult) {
        if (logging) {
            Ape.log('--F5 games--');
            Ape.log('F5 for games:' + gamesresult);
        }
        var games = JSON.parse(gamesresult);
        games.each(function (game) {
            allgames.set(game.game_id, game);
            if (game.status_id == 2) {
                sendPhrase(game.game_id);
                if (game.time_restriction != 0) setNextTurnTimeout(game.game_id, game.time_restriction.toInt() * 1000, game.active_player_num);
		   //TODO: check if ai is needed to call
            } else
	    if (game.status_id == 3) {
	      var timeoutID = Ape.setTimeout(function (g_id) {
                            //send delete game request
                            var delrequest = new Http(lords_domain + '/game/mode'+allgames.get(g_id).mode_id+'/ajax/delete_game.php');
                            delrequest.set('method', 'POST');
                            delrequest.writeObject({
                                'game_id': g_id
                            });
                            delrequest.getContent(function (delresult) {
                                if (logging) Ape.log('del_game:' + delresult);
				var channel = Ape.getChannelByName('arenachat_0');
				if (channel)
				channel.pipe.sendRaw('protocol_raw', {
				    commands: 'arena_game_delete('+g_id+');'
				});
                            });
                        }, delete_game_timeout, game.game_id);
	    }
        });
    });

    Ape.addEvent("afterJoin", function (user, channel) {
        if (logging) {
            Ape.log('--join chanel--');
            Ape.log("JOIN ! user " + user.user_id + " -> " + channel.getProperty('name'));
        }
        //make online status
        if ($chk(user.user_id) && channel.getProperty('name') == 'arenachat_0') {
            var enterrequest = new Http(lords_domain + '/site/ajax/base_protocol.php');
            enterrequest.set('method', 'POST');
            enterrequest.writeObject({
                action: 'player_online_offline',
                params: {
                    user_id: user.user_id,
                    flag: 1
                }
            });
            enterrequest.getContent(function (enteresult) {
                if (logging) Ape.log('make online[' + user.user_id + ']:' + enteresult);
                var enterans = JSON.parse(enteresult);
                if (enterans.header_result.success == "1") {
                    var channel = Ape.getChannelByName('arenachat_0');
                    channel.pipe.sendRaw('protocol_raw', {
                        commands: encodeURIComponent('arena_player_set_status(' + user.user_id + ', ' + enterans.data_result.player_status_id + ');')
                    });
                }
            });
        }
    });
    /* Fired when a new user is connecting */
    Ape.addEvent("adduser", function (user) {
        if (logging) Ape.log("Add user (" + user.user_id + ")");
    });

    /* Fired when a user is disconnecting */
    Ape.addEvent("deluser", function (user) {
        if (logging) Ape.log("Del user (" + user.user_id + ")");
        if ($chk(user.user_id)) if ($chk(users_by_id[user.user_id])) if (user.getProperty('pubid') == users_by_id[user.user_id]) { //make offline
            var temp_user_id = user.user_id;
            var enterrequest = new Http(lords_domain + '/site/ajax/base_protocol.php');
            enterrequest.set('method', 'POST');
            enterrequest.writeObject({
                action: 'player_online_offline',
                params: {
                    user_id: temp_user_id,
                    flag: 0
                }
            });
            enterrequest.getContent(function (enteresult) {
                if (logging) Ape.log('make offline[' + temp_user_id + ']:' + enteresult);
                var enterans = JSON.parse(enteresult);
                if (enterans.header_result.success == "1") {
                    var channel = Ape.getChannelByName('arenachat_0');
		    if (channel)
                    channel.pipe.sendRaw('protocol_raw', {
                        commands: encodeURIComponent('arena_player_set_status(' + temp_user_id + ', ' + enterans.data_result.player_status_id + ');')
                    });
                }
                delete users_by_id[temp_user_id];
            });
        }
        delete user.user_id;
    });

    /* Fired when a channel is created */
    Ape.addEvent("mkchan", function (channel) {
        if (logging) Ape.log("new channel " + channel.getProperty('name'));
    });
    Ape.registerHookCmd("connect", function (params, cmd) {
        var request = new Http(lords_domain + '/site/ajax/get_user_session.php?phpsessid=' + params.phpsessid);
        request.set('method', 'POST');
        request.getContent(function (result) {
            if (logging) {
                Ape.log('--connect--');
                Ape.log("pubid:" + cmd.user.getProperty('pubid'));
                Ape.log("user phpsessid:" + params.phpsessid);
                Ape.log("user_session:" + result);
            }
            var ans = JSON.parse(result);
            if ($chk(ans.user_id) && ans.user_id != "") if ($chk(users_by_id[ans.user_id.toInt()])) { //another pubid in array
                var user = Ape.getUserByPubid(users_by_id[ans.user_id.toInt()]);
                if (user) user.pipe.sendRaw('err', {
                    code: 1004,
                    value: 'You are logged in another browser or computer.'
                });
            }
            cmd.user.user_id = ans.user_id;
            users_by_id[ans.user_id.toInt()] = cmd.user.getProperty('pubid');
            if ($chk(ans.game_id) && ans.game_id != "") {
                var channel = Ape.getChannelByName('arenagame_' + ans.game_id);
                if (!channel) channel = Ape.mkChan('arenagame_' + ans.game_id);
                cmd.user.join('arenagame_' + ans.game_id);
                cmd.user.game_id = ans.game_id;
                cmd.user.player_num = ans.player_num;
            }
        });
        return 1;
    });
    Ape.registerCmd('base_protocol_cmd', false, function (params, infos) {
        var request = new Http(lords_domain + '/site/ajax/base_protocol.php?phpsessid=' + params.phpsessid);
        request.set('method', 'POST');
        delete params.phpsessid;
        request.writeObject(params);
        request.getContent(function (result) {
            if (logging) {
                Ape.log('--base_protocol_cmd--');
                Ape.log("action[" + params.action + "]:");
                Ape.log("result:" + result);
            }
            var ans = JSON.parse(result);
            var eval_cmds = "";
            //if (ans.header_result.success=="1")
            switch (params.action) {
            case 'user_authorize':
                if (ans.header_result.success == "1") {
                    if ($chk(users_by_id[ans.data_result.user_id.toInt()])) { //another pubid in array
                        var user = Ape.getUserByPubid(users_by_id[ans.data_result.user_id.toInt()]);
                        if (user) user.pipe.sendRaw('err', {
                            code: 1004,
                            value: 'You are logged in another browser or computer.'
                        });
                    }
                    infos.user.user_id = ans.data_result.user_id;
                    users_by_id[ans.data_result.user_id.toInt()] = infos.user.getProperty('pubid');
                }
                eval_cmds += encodeURIComponent('loginAnswer(' + result + ')');
                break;
            case 'user_add':
                eval_cmds += encodeURIComponent('regAnswer(' + result + ')');
                break;
            }
            if (eval_cmds != '') infos.sendResponse('protocol_raw', {
                commands: eval_cmds
            });
        });
        return -1;
    });
    Ape.registerCmd('logged_protocol_cmd', false, function (params, infos) {
        if (!$chk(infos.user) || !$chk(infos.user.user_id)) {
            return ["1003", "Not authorized - please refresh browser"];
        }
        var phpsessid = params.phpsessid;
        var request = new Http(lords_domain + '/site/ajax/logged_protocol.php?phpsessid=' + params.phpsessid);
        request.set('method', 'POST');
        delete params.phpsessid;
        request.writeObject(params);
        request.getContent(function (result) {
            if (logging) {
                Ape.log('--logged_protocol_cmd--');
                Ape.log("action[" + params.action + "]:" + infos.user.user_id);
                Ape.log("result:" + result);
            }
            var ans = JSON.parse(result);
            var eval_cmds = "";
            //if (ans.header_result.success=="1")
            switch (params.action) {
            case 'logout':
                if (ans.header_result.success == "1") {
                    delete users_by_id[infos.user.user_id.toInt()]
                    delete infos.user.user_id;
                }
                eval_cmds += encodeURIComponent('parent.load_window("site/login.php", "left");');
                break;
            case 'arena_exit':
                if (ans.header_result.success == "1") {
                    var arena_cmds = "";
                    eval_cmds += encodeURIComponent('parent.load_window("site/map.php", "left");');

                    if ($chk(ans.data_result)) if ($chk(ans.data_result.game_id)) if ($chk(ans.data_result.was_owner)) {
                        var chan = Ape.getChannelByName('arenagame_' + ans.data_result.game_id);
                        chan.userslist.each(function (user) {
                            if ($chk(user.user_id)) {
                                arena_cmds += encodeURIComponent('arena_player_set_status(' + user.user_id + ', 1);');
                            }
                        });
                        Ape.rmChan('arenagame_' + ans.data_result.game_id);
                        arena_cmds += 'arena_game_delete(' + ans.data_result.game_id + ');';
                    } else {
                        var game_channel = Ape.getChannelByName('arenagame_' + ans.data_result.game_id);
                        if (game_channel) game_channel.pipe.sendRaw('protocol_raw', {
                            commands: encodeURIComponent('arena_game_remove_player(' + ans.data_result.game_id + ',' + infos.user.user_id + ');')
                        });
                        infos.user.left('arenagame_' + ans.data_result.game_id);
                        if (ans.data_result.was_spectator.toInt() == 1) arena_cmds += encodeURIComponent('arena_game_dec_spectator_count(' + ans.data_result.game_id + ');');
                        else arena_cmds += encodeURIComponent('arena_game_dec_player_count(' + ans.data_result.game_id + ');');
                    }
                    arena_cmds += encodeURIComponent('arena_player_remove(' + infos.user.user_id + ');');
                    if ($chk(ans.data_result))
		    if ($chk(ans.data_result.chats_ids)) {
                        var chats = ans.data_result.chats_ids.split(',');
                        chats.each(function (chat_id) {
			  if (logging) Ape.log("chat_id:"+chat_id);
                            infos.user.left('arenachat_' + chat_id);
                            var chatchannel = Ape.getChannelByName('arenachat_' + chat_id);
                            if (chatchannel) chatchannel.pipe.sendRaw('protocol_raw', {
                                commands: encodeURIComponent('chat_remove_player(' + chat_id + ',' + infos.user.user_id + ')')
                            });
                        });
                    }
                    var channel = Ape.getChannelByName('arenachat_0');
                    channel.pipe.sendRaw('protocol_raw', {
                        commands: arena_cmds
                    });
                    infos.user.left('arenachat_0');
                }
                break;
            case 'arena_game_player_remove':
                if (ans.header_result.success == "1") {
                    var arena_cmds = "";
                    if ($chk(ans.data_result.owner) && ans.data_result.owner.toInt() == 1) {
                        var chan = Ape.getChannelByName('arenagame_' + params.params.game_id);
                        chan.userslist.each(function (user) {
                            if ($chk(user.user_id)) {
                                arena_cmds += encodeURIComponent('arena_player_set_status(' + user.user_id + ', 1);');
                            }
                        });
                        Ape.rmChan('arenagame_' + params.params.game_id);
                        arena_cmds += 'arena_game_delete(' + params.params.game_id + ')';
                    } else {
                        var game_channel = Ape.getChannelByName('arenagame_' + params.params.game_id);
                        if (game_channel) game_channel.pipe.sendRaw('protocol_raw', {
                            commands: encodeURIComponent('arena_game_remove_player(' + params.params.game_id + ',' + params.params.user_id + ');')
                        });
                        var user = Ape.getUserByPubid(users_by_id[params.params.user_id.toInt()]);
                        if (user) {
                            user.left('arenagame_' + params.params.game_id);
                            arena_cmds += encodeURIComponent('arena_player_set_status(' + user.user_id + ', 1);');
                        }
                        if (ans.data_result.was_spectator.toInt() == 1) arena_cmds += encodeURIComponent('arena_game_dec_spectator_count(' + params.params.game_id + ');');
                        else arena_cmds += encodeURIComponent('arena_game_dec_player_count(' + params.params.game_id + ');');
                    }
                    var channel = Ape.getChannelByName('arenachat_0');
                    channel.pipe.sendRaw('protocol_raw', {
                        commands: arena_cmds
                    });
                }
                break;
            case 'arena_game_start':
                if (ans.header_result.success == "1") {
                    var arena_cmds = "";
                    var channel = Ape.getChannelByName('arenagame_' + params.params.game_id);
                    channel.userslist.each(function (user) {
                        if ($chk(user.user_id)) {
                            arena_cmds += encodeURIComponent('arena_player_set_status(' + user.user_id + ', 3);')
                            user.left("arenachat_0");
                        }
                    });
                    arena_cmds += encodeURIComponent('arena_game_set_status(' + params.params.game_id + ', 2);');
                    channel.pipe.sendRaw('protocol_raw', {
                        commands: arena_cmds
                    });
		    var gamerequest = new Http(lords_domain + '/site/ajax/get_game_info.php');
		    gamerequest.set('method', 'POST');
		    gamerequest.writeObject({
			game_id: params.params.game_id
		    });
		    gamerequest.getContent(function (gameresult) {
			if (logging) {
			    Ape.log('--F5 game--');
			    Ape.log('F5 for game:' + gameresult);
			}
			var game = JSON.parse(gameresult);
			if ($chk(game.game_id)){
			    allgames.set(game.game_id, game);
			    if (game.status_id == 2) {
				sendPhrase(game.game_id);
				if (game.time_restriction != 0) setNextTurnTimeout(game.game_id, game.time_restriction.toInt() * 1000, game.active_player_num);
			    }
			}
		    });
                }
                break;
            case 'arena_game_enter':
                if (ans.header_result.success == "1") {
                    var new_status = 2;
			var game_channel = Ape.getChannelByName('arenagame_' + params.params.game_id);
			if (!game_channel) game_channel = Ape.mkChan('arenagame_' + params.params.game_id);
                        infos.user.join('arenagame_' + params.params.game_id);
                        game_channel.pipe.sendRaw('protocol_raw', {
                            commands: encodeURIComponent('arena_game_add_player(' + params.params.game_id + ',' + infos.user.user_id + ')')
                        });
                    var channel = Ape.getChannelByName('arenachat_0');
                    channel.pipe.sendRaw('protocol_raw', {
                        commands: encodeURIComponent('arena_player_set_status(' + infos.user.user_id + ', ' + new_status + ');arena_game_inc_spectator_count(' + params.params.game_id + ');')
                    });
                }
                break;
	    case 'arena_game_spectator_enter':
                if (ans.header_result.success == "1") {
                    var new_status = 3;
			var game_channel = Ape.getChannelByName('arenagame_' + params.params.game_id);
			if (!game_channel) game_channel = Ape.mkChan('arenagame_' + params.params.game_id);
                        infos.user.join('arenagame_' + params.params.game_id);
                        game_channel.pipe.sendRaw('game_raw', {
                            commands: encodeURIComponent('add_spectator('+ans.data_result.player_num + ', "' + ans.data_result.player_name +  '");')
                        });
                    var channel = Ape.getChannelByName('arenachat_0');
                    channel.pipe.sendRaw('protocol_raw', {
                        commands: encodeURIComponent('arena_player_set_status(' + infos.user.user_id + ', ' + new_status + ');arena_game_inc_spectator_count(' + params.params.game_id + ');')
                    });
                }
                break;
            case 'arena_game_feature_set':
                if (ans.header_result.success == "1") {
                    var game_channel = Ape.getChannelByName('arenagame_' + params.params.game_id);
                    if (game_channel) game_channel.pipe.sendRaw('protocol_raw', {
                        commands: encodeURIComponent('arena_game_set_feature(' + params.params.game_id + ',' + params.params.feature_id + ',' + params.params.value + ')')
                    });
                }
                break;
            case 'arena_game_player_team_set':
                if (ans.header_result.success == "1") {
                    var game_channel = Ape.getChannelByName('arenagame_' + params.params.game_id);
                    if (game_channel) game_channel.pipe.sendRaw('protocol_raw', {
                        commands: encodeURIComponent('arena_game_player_move_to_team(' + params.params.user_id + ',' + params.params.game_id + ',' + params.params.team_id + ');')
                    });
                    if (ans.data_result.was_spectator.toInt() == 1) {
                        var channel = Ape.getChannelByName('arenachat_0');
                        channel.pipe.sendRaw('protocol_raw', {
                            commands: encodeURIComponent('arena_game_dec_spectator_count(' + params.params.game_id + '); arena_game_inc_player_count(' + params.params.game_id + ');')
                        });
                    }
                }
                break;
            case 'arena_game_player_spectator_move':
                if (ans.header_result.success == "1") {
                    var game_channel = Ape.getChannelByName('arenagame_' + params.params.game_id);
                    if (game_channel) game_channel.pipe.sendRaw('protocol_raw', {
                        commands: encodeURIComponent('arena_game_player_move_to_spectators(' + params.params.user_id + ',' + params.params.game_id + ');')
                    });

                    var channel = Ape.getChannelByName('arenachat_0');
                    channel.pipe.sendRaw('protocol_raw', {
                        commands: encodeURIComponent('arena_game_inc_spectator_count(' + params.params.game_id + '); arena_game_dec_player_count(' + params.params.game_id + ');')
                    });
                }
                break;
            case 'arena_game_create':
                if (ans.header_result.success == "1") {
                    var enterrequest = new Http(lords_domain + '/site/ajax/logged_protocol.php?phpsessid=' + phpsessid);
                    enterrequest.set('method', 'POST');
                    enterrequest.writeObject({
                        action: 'arena_game_enter',
                        params: {
                            game_id: ans.data_result.game_id,
                            pass: params.params.pass
                        }
                    });
                    enterrequest.getContent(function (enteresult) {
                        if (logging) Ape.log('enterresult:' + enteresult);
                        var enterans = JSON.parse(enteresult);
                        if (enterans.header_result.success == "1") {
                            var channel = Ape.getChannelByName('arenachat_0');
                            if (params.params.pass == 'null') params.params.pass = 0;
                            else params.params.pass = 1;
                            channel.pipe.sendRaw('protocol_raw', {
                                commands: encodeURIComponent('arena_game_add(' + ans.data_result.game_id + ',' + infos.user.user_id + ',' + decodeURIComponent(params.params.title) + ',' + params.params.pass + ',' + params.params.mode + '); arena_player_set_status(' + infos.user.user_id + ', 2);arena_game_inc_spectator_count(' + ans.data_result.game_id + ');')
                            });
                            var game_channel = Ape.getChannelByName('arenagame_' + ans.data_result.game_id);
                            if (!game_channel) game_channel = Ape.mkChan('arenagame_' + ans.data_result.game_id);
                            infos.user.join('arenagame_' + ans.data_result.game_id);
                            game_channel.pipe.sendRaw('protocol_raw', {
                                commands: encodeURIComponent('arena_game_add_player(' + ans.data_result.game_id + ',' + infos.user.user_id + ')')
                            });
                        } else infos.sendResponse('err', {
                            code: enterans.header_result.error_code,
                            value: enterans.header_result.error_params
                        });
                    });
                }
                //eval_cmds+=encodeURIComponent('parent.load_window("site/login.php", "left");');
                break;
            case 'chat_topic_change':
                if (ans.header_result.success == "1") {
                    var channel = Ape.getChannelByName('arenachat_' + params.params.chat_id);
                    if (logging) Ape.log(params.params.newtopic);
                    channel.pipe.sendRaw('protocol_raw', {
                        commands: encodeURIComponent('chat_set_topic(' + params.params.chat_id + ',' + decodeURIComponent(params.params.newtopic) + ')')
                    });
                }
                break;
            case 'chat_create_private':
                if (ans.header_result.success == "1") {
                    var channel = Ape.getChannelByName('arenachat_' + ans.data_result.chat_id);
                    if (!channel) channel = Ape.mkChan('arenachat_' + ans.data_result.chat_id);
                    var user = Ape.getUserByPubid(users_by_id[params.params.user_id.toInt()]);
                    if (user) user.join('arenachat_' + ans.data_result.chat_id);
                    infos.user.join('arenachat_' + ans.data_result.chat_id);
                    channel.pipe.sendRaw('protocol_raw', {
                        commands: encodeURIComponent('chat_create(' + ans.data_result.chat_id + ',""); chat_add_player(' + ans.data_result.chat_id + ',' + infos.user.user_id + '); chat_add_player(' + ans.data_result.chat_id + ',' + params.params.user_id + ');')
                    });
                }
                break;
            case 'chat_exit':
                if (ans.header_result.success == "1") {
                    infos.user.left('arenachat_' + params.params.chat_id);
                    eval_cmds += encodeURIComponent('chat_destroy(' + params.params.chat_id + ');');
                    var channel = Ape.getChannelByName('arenachat_' + params.params.chat_id);
                    if (!channel) channel = Ape.mkChan('arenachat_' + params.params.chat_id);
                    channel.pipe.sendRaw('protocol_raw', {
                        commands: encodeURIComponent('chat_remove_player(' + params.params.chat_id + ',' + infos.user.user_id + ')')
                    });
                }
                break;
            case 'chat_user_add':
                if (ans.header_result.success == "1") {
                    var channel = Ape.getChannelByName('arenachat_' + params.params.chat_id);
                    if (!channel) channel = Ape.mkChan('arenachat_' + params.params.chat_id);
                    channel.pipe.sendRaw('protocol_raw', {
                        commands: encodeURIComponent('chat_add_player(' + params.params.chat_id + ',' + params.params.user_id + ');')
                    });
                    var user_cmds = '';
                    var user = Ape.getUserByPubid(users_by_id[params.params.user_id.toInt()]);
                    if (user) {
                        var chatrequest = new Http(lords_domain + '/site/ajax/get_chat_users.php?phpsessid=' + phpsessid);
                        chatrequest.set('method', 'POST');
                        chatrequest.writeObject(params.params);
                        chatrequest.getContent(function (chatresult) {
                            if (logging) Ape.log('chatresult:' + chatresult);
                            user.join('arenachat_' + params.params.chat_id);
                            user_cmds += encodeURIComponent('chat_create(' + params.params.chat_id + ',"' + decodeURIComponent(params.help_params.topic) + '");');
                            user_cmds += encodeURIComponent(chatresult);
                            user.pipe.sendRaw('protocol_raw', {
                                commands: user_cmds
                            });
                        });
                    }
                }
                //eval_cmds+=encodeURIComponent('parent.load_window("site/login.php", "left");');
                break;
            case 'arena_enter':
                if (ans.header_result.success == "1") {
                    var channel = Ape.getChannelByName('arenachat_0');
                    if (!channel) channel = Ape.mkChan('arenachat_0');
                    if ($chk(ans.data_result)) {
                        channel.pipe.sendRaw('protocol_raw', {
                            commands: encodeURIComponent('arena_player_add(' + infos.user.user_id + ', "' + decodeURIComponent(ans.data_result.nick) + '", 1);')
                        });
                    }
                    eval_cmds += encodeURIComponent('parent.load_window("arena/arena.php", "right");');
                }
                break;
            }
            if (eval_cmds != '') infos.sendResponse('protocol_raw', {
                commands: eval_cmds
            });
            if (ans.header_result.success != "1") {
                infos.sendResponse('err', {
                    code: ans.header_result.error_code,
                    value: ans.header_result.error_params
                });
            }
        });
        return -1;
    });
    function callNPC(g_id,p_num){
      var npcrequest = new Http(lords_domain + '/site/ajax/npc.php');
      npcrequest.set('method', 'POST');
      npcrequest.writeData('g_id', g_id);
      npcrequest.writeData('p_num', p_num);
      npcrequest.getContent(function (npcresult) {
	if (logging) {
                Ape.log('--call_npc_ai--');
                Ape.log("game_id:"+g_id+", p_num:"+p_num);
                Ape.log("result:" + npcresult);
            }
            var ans = JSON.parse(npcresult);

            var game = Ape.getChannelByName('arenagame_' + g_id);
            var game_cmds = '';
            var hidden_cmds = new $H;

	      if ($chk(ans.data_result))
                ans.data_result.each(function (cmd) {
                    if (cmd.command == "end_game()") { //shedule delete timer
                        var timeoutID = Ape.setTimeout(function (gm_id) {
                            //send delete game request
                            var delrequest = new Http(lords_domain + '/game/mode'+allgames.get(gm_id).mode_id+'/ajax/delete_game.php');
                            delrequest.set('method', 'POST');
                            delrequest.writeObject({
                                'game_id': gm_id
                            });
                            delrequest.getContent(function (delresult) {
                                if (logging) Ape.log('del_game:' + delresult);
				var channel = Ape.getChannelByName('arenachat_0');
				if (channel)
				channel.pipe.sendRaw('protocol_raw', {
				    commands: 'arena_game_delete('+gm_id+');'
				});
                            });
                        }, delete_game_timeout, g_id);
			Ape.clearTimeout(phrases_timers.get(g_id));
			Ape.clearTimeout(endturn_timers.get(g_id));
                    }
                    if (cmd.command.indexOf("set_active_player(") != -1) {
                        if (allgames.get(g_id).time_restriction != 0) {
                            var next_p_num = cmd.command.split(',');
                            next_p_num = next_p_num[0].split('(');
			    Ape.clearTimeout(endturn_timers.get(g_id));
			    if (next_p_num[1]<4){
			      var next_pl_num = next_p_num[1];
			      setNextTurnTimeout(g_id, allgames.get(g_id).time_restriction * 1000, next_pl_num.toInt());
			    }
                        }
                    }
                    if (cmd.command.indexOf("NPC(") != -1) {//load npc service
                        var npc_p_num = cmd.command.split('(');
                        npc_p_num = npc_p_num[1].split(')');
			var npc_pl_num = npc_p_num[0];
			callNPC(g_id,npc_pl_num);
                    }
                    //set spec -players count on delete spec or player command
                    if (cmd.hidden_flag == 0) game_cmds += encodeURIComponent(cmd.command) + ";";
                    else if (hidden_cmds.get(cmd.user_id) == null) hidden_cmds.set(cmd.user_id, encodeURIComponent(cmd.command) + ";");
                    else hidden_cmds.set(cmd.user_id, hidden_cmds.get(cmd.user_id) + encodeURIComponent(cmd.command) + ";");
                });

            if (game_cmds != '') {
                game.pipe.sendRaw('game_raw', {
                    commands: game_cmds
                });
            }
            hidden_cmds.each(function (v, k) {
                var huser = Ape.getUserByPubid(users_by_id[k.toInt()]);
                if (huser)
		huser.pipe.sendRaw('game_raw', {
                    commands: v
                });
            });
      });
    }
    Ape.registerCmd('game_protocol_cmd', false, function (params, infos) {
        if (!$chk(infos.user) || !$chk(infos.user.user_id) || !$chk(infos.user.game_id)) {
            return ["1003", "Not authorized - please refresh browser"];
        }
        var start_time = $time();
        var phpsessid = params.phpsessid;
	if (params.proc_name=='multi'){
	  var request = new Http(lords_domain + '/site/ajax/multi_game_protocol.php?phpsessid=' + params.phpsessid);
	} else {
	  var request = new Http(lords_domain + '/site/ajax/game_protocol.php?phpsessid=' + params.phpsessid);
	}
        request.set('method', 'POST');
        delete params.phpsessid;
        request.writeObject(params);
        request.getContent(function (result) {
            if (logging) {
                Ape.log('--game_protocol_cmd--');
                Ape.log("proc[" + params.proc_name + "]:[" + params.proc_params + "]: user " + infos.user.user_id);
                Ape.log("result:" + result);
            }
            var ans = JSON.parse(result);

            var user = Ape.getUserByPubid(users_by_id[infos.user.user_id.toInt()]);
            var user_cmds = '';
            var game = Ape.getChannelByName('arenagame_' + infos.user.game_id);
            var game_cmds = '';
            var hidden_cmds = new $H;

	      if ($chk(ans.data_result))
                ans.data_result.each(function (cmd) {
                    if (cmd.command == "end_game()") { //shedule delete timer
                        var timeoutID = Ape.setTimeout(function (g_id) {
                            //send delete game request
                            var delrequest = new Http(lords_domain + '/game/mode'+allgames.get(g_id).mode_id+'/ajax/delete_game.php');
                            delrequest.set('method', 'POST');
                            delrequest.writeObject({
                                'game_id': g_id
                            });
                            delrequest.getContent(function (delresult) {
                                if (logging) Ape.log('del_game:' + delresult);
				var channel = Ape.getChannelByName('arenachat_0');
				if (channel)
				channel.pipe.sendRaw('protocol_raw', {
				    commands: 'arena_game_delete('+g_id+');'
				});
                            });
                        }, delete_game_timeout, infos.user.game_id);
			Ape.clearTimeout(phrases_timers.get(infos.user.game_id));
			Ape.clearTimeout(endturn_timers.get(infos.user.game_id));
                    }
                    if (cmd.command.indexOf("set_active_player(") != -1) {
                        if (allgames.get(infos.user.game_id).time_restriction != 0) {
                            var next_p_num = cmd.command.split(',');
                            next_p_num = next_p_num[0].split('(');
			    Ape.clearTimeout(endturn_timers.get(infos.user.game_id));
			    if (next_p_num[1]<4){
			      var next_pl_num = next_p_num[1];
			      setNextTurnTimeout(infos.user.game_id, allgames.get(infos.user.game_id).time_restriction * 1000, next_pl_num.toInt());
			    }
                        }
                    }
                    if (cmd.command.indexOf("NPC(") != -1) {//load npc service
                        var npc_p_num = cmd.command.split('(');
                        npc_p_num = npc_p_num[1].split(')');
			var npc_pl_num = npc_p_num[0];
			callNPC(infos.user.game_id,npc_pl_num);
                    }
                    //set spec -players count on delete spec or player command
                    if (cmd.hidden_flag == 0) game_cmds += encodeURIComponent(cmd.command) + ";";
                    else if (hidden_cmds.get(cmd.user_id) == null) hidden_cmds.set(cmd.user_id, encodeURIComponent(cmd.command) + ";");
                    else hidden_cmds.set(cmd.user_id, hidden_cmds.get(cmd.user_id) + encodeURIComponent(cmd.command) + ";");
                });
		
	    if (ans.header_result.success == "0") {
                user_cmds += encodeURIComponent('proc_answer(' + params.proc_uid + ',0,'+ans.header_result.error_code+',"' + ans.header_result.error_params + '");');
            }
	    
	    if (ans.header_result.success == "1") game_cmds = encodeURIComponent('proc_answer(' + params.proc_uid + ',1,0,"",' + ($time() - start_time) + ',' + ans.phptime + ');') + game_cmds;			
            
	    if (game_cmds != '') {
                game.pipe.sendRaw('game_raw', {
                    commands: game_cmds
                });
            }
            if (user_cmds != '') user.pipe.sendRaw('game_raw', {
                commands: user_cmds
            });
            hidden_cmds.each(function (v, k) {
                var huser = Ape.getUserByPubid(users_by_id[k.toInt()]);
                if (huser)
		huser.pipe.sendRaw('game_raw', {
                    commands: v
                });
            });
        });
    });

    function convertChars(s) {
        var xml_special_to_escaped_one_map = {
            '&': '&amp;',
            '"': '&quot;',
            '<': '&lt;',
            '>': '&gt;',
            '\\': '&#92;',
            '\'': '&apos;'
        };
        return s.replace(/([\&"<>\\\'])/g, function (str, item) {
            return xml_special_to_escaped_one_map[item];
        });
    }
    Ape.registerCmd('get_game_info_cmd', false, function (params, infos) {
        if (!$chk(infos.user) || !$chk(infos.user.user_id) || !$chk(infos.user.game_id)) {
            return ["1010", "User is not correctly connected yet - please wait."];
        }
        var phpsessid = params.phpsessid;
        var request = new Http(lords_domain + '/game/mode'+allgames.get(infos.user.game_id).mode_id+'/ajax/get_all_game_info.php?phpsessid=' + params.phpsessid);
        request.set('method', 'POST');
        delete params.phpsessid;
        request.writeObject(params);
        request.getContent(function (result) {
            infos.sendResponse('game_info_raw', {
                commands: convertChars(result)
            });
        });
    });

    Ape.registerCmd('arena_chat_msg', false, function (params, infos) {
        if (!$defined(params.msg) || !$defined(params.from_user_id) || !$defined(params.from_chat_id)) return 0;

        var chan = Ape.getChannelByPubid(params.pipe);

        if (chan) {
            chan.pipe.sendRaw('chat_msg', {
                'params': params
            });
        } else {
            return ['109', 'UNKNOWN_PIPE'];
        }
        if (logging) {
            Ape.log('--arena_chat_msg--');
            Ape.log(params.msg);
        }
        return 1;
    });

    Ape.registerCmd('gamechat_message', false, function (params, infos) {
        if (!$defined(params.msg) || !$defined(infos.user.game_id)) return 0;

        var chan = Ape.getChannelByName('arenagame_' + infos.user.game_id);

        if (chan) {
            chan.pipe.sendRaw('game_raw', {
                commands: encodeURIComponent('chat_add_user_message(' + infos.user.player_num + ',"' + decodeURIComponent(params.msg) + '");')
            });
        } else {
            return ['109', 'UNKNOWN_PIPE'];
        }
        if (logging) {
            Ape.log('--gamechat_msg--');
            Ape.log(params.msg);
        }
        return 1;
    });

    Ape.registerCmd('perfomance', false, function (params, infos) {
        if (!$chk(infos.user) || !$chk(infos.user.user_id) || !$chk(infos.user.game_id)) {
            return ["1003", "Not authorized - please refresh browser"];
        }

        var request = new Http(lords_domain + '/game/mode'+allgames.get(infos.user.game_id).mode_id+'/ajax/call_save_perfomance.php');
        params.game_id = infos.user.game_id;
        request.set('method', 'POST');
        request.writeObject(params);
        request.getContent(function (result) {
            if (logging) {
                Ape.log('--statistics--');
                Ape.log("proc[" + params.name + "]:js[" + params.js_time + "]: user " + infos.user.user_id);
                Ape.log(result);
            }
        });
    });

});

/* Listen on port 6970 (multicast) and high performences server */
/* Check ./framework/proxy.js for client API */

var socket = new Ape.sockServer(6970, "0.0.0.0", {
	flushlf: true /* onRead event is fired only when a \n is received (and splitted around it) e.g. foo\nbar\n  will call onRead two times with "foo" and "bar" */
});

/* fired when a client is connecting */
socket.onAccept = function(client) {
	if (logging) Ape.log("New client");
	//client.write("Hello world\n");
	//client.foo = "bar"; // Properties are persistants
	//client.close();
	var i =0;
	for (i=0;i<2;i++) {
	 var phrequest = new Http(lords_domain + '/game/mode1/ajax/get_unit_phrase.php');
        phrequest.set('method', 'POST');
        phrequest.writeObject({
            'game_id': 3
        });
        phrequest.getContent(function (phresult) {
            if (logging) Ape.log('phrase[' + 3 + ']:' + phresult);
            var phans = games = JSON.parse(phresult);
	    client.write(encodeURIComponent('show_unit_message(' + phans.board_unit_id + ',' + phans.phrase_id + ');'));
        });
	}
	return -1
}

/* fired when a client send data */
socket.onRead = function(client, data) {
	if (logging) Ape.log("Data from client : " + data);
}

/* fired when a client has disconnected */
socket.onDisconnect = function(client) {
	if (logging) Ape.log("A client has disconnected");

}
	
