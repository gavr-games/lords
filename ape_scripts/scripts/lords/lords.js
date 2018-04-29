var logging = true;
var delete_game_timeout = 900000;
var phrase_min_timeout = 120000;
var phrase_interval_timeout = 120000;
var users_by_id = new Array();
var phrases_timers = new $H;
var endturn_timers = new $H;
var allgames = new $H;
Ape.addEvent("init", function() {

    function sendNextTurn(gm_id, tm_rs, pl_num) {
        if (logging) Ape.log('end turn by timeout start');
        var ntrequest = new Http(lords_domain + '/game/mode' + allgames.get(gm_id).mode_id + '/ajax/end_turn_timeout.php');
        if (logging) Ape.log('end turn by timeout before post');
        ntrequest.set('method', 'POST');
        if (logging) Ape.log('end turn by timeout params: ' + gm_id + '/' + pl_num);
        ntrequest.writeObject({
            'game_id': gm_id,
            'player_num': pl_num
        });
        if (logging) Ape.log('end turn by timeout before send');
        ntrequest.getContent(function(ntresult) {
            if (logging) Ape.log('end_turn_by_timeout[' + gm_id + '/' + tm_rs + '/' + pl_num + ']:' + ntresult);
            var ntans = JSON.parse(ntresult);

            var game = Ape.getChannelByName('arenagame_' + gm_id);
            var game_cmds = '';
            var hidden_cmds = new $H;

            if (ntans.header_result.success == "1") {
                ntans.data_result.each(function(cmd) {
                    if (cmd.command.indexOf("set_active_player(") != -1) {
                        var next_p_num = cmd.command.split(',');
                        next_p_num = next_p_num[0].split('(');
                        if (next_p_num[1] < 4) {
                            var next_pl_num = next_p_num[1];
                            setNextTurnTimeout(gm_id, tm_rs, next_pl_num.toInt());
                        }
                    }
                    if (cmd.command.indexOf("NPC(") != -1) { //load npc service
                        var npc_p_num = cmd.command.split('(');
                        npc_p_num = npc_p_num[1].split(')');
                        var npc_pl_num = npc_p_num[0];
                        callNPC(gm_id, npc_pl_num);
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
            hidden_cmds.each(function(v, k) {
                var huser = Ape.getUserByPubid(users_by_id[k.toInt()]);
                if (huser) huser.pipe.sendRaw('game_raw', {
                    commands: v
                });
            });
        });
        if (logging) Ape.log('end turn by timeout after send');
    }

    function setNextTurnTimeout(gm_id, tm_rs, pl_num) {
        if (logging) Ape.log('set next turn timeout:' + gm_id + '/' + pl_num);
        endturn_timers.set(gm_id, Ape.setTimeout(function(g_id, t_rs, p_num) {
            if (logging) Ape.log('set next turn timeout executed:' + g_id + '/' + p_num);
            sendNextTurn(g_id, t_rs, p_num);
        }, tm_rs, gm_id, tm_rs, pl_num));
    }

    var gamesrequest = new Http(lords_domain + '/site/ajax/get_games_info.php');
    gamesrequest.set('method', 'POST');
    gamesrequest.getContent(function(gamesresult) {
        if (logging) {
            Ape.log('--F5 games--');
            Ape.log('F5 for games:' + gamesresult);
        }
        var games = JSON.parse(gamesresult);
        games.each(function(game) {
            allgames.set(game.game_id, game);
            if (game.status_id == 2) {
                sendPhrase(game.game_id);
                if (game.time_restriction != 0) setNextTurnTimeout(game.game_id, game.time_restriction.toInt() * 1000, game.active_player_num);
                //TODO: check if ai is needed to call
            } else
            if (game.status_id == 3) {
                var timeoutID = Ape.setTimeout(function(g_id) {
                    //send delete game request
                    var delrequest = new Http(lords_domain + '/game/mode' + allgames.get(g_id).mode_id + '/ajax/delete_game.php');
                    delrequest.set('method', 'POST');
                    delrequest.writeObject({
                        'game_id': g_id
                    });
                    delrequest.getContent(function(delresult) {
                        if (logging) Ape.log('del_game:' + delresult);
                        var channel = Ape.getChannelByName('arenachat_0');
                        if (channel)
                            channel.pipe.sendRaw('protocol_raw', {
                                commands: 'arena_game_delete(' + g_id + ');'
                            });
                    });
                }, delete_game_timeout, game.game_id);
            }
        });
    });

    function callNPC(g_id, p_num) {
        var npcrequest = new Http(lords_domain + '/site/ajax/npc.php');
        npcrequest.set('method', 'POST');
        npcrequest.writeData('g_id', g_id);
        npcrequest.writeData('p_num', p_num);
        npcrequest.getContent(function(npcresult) {
            if (logging) {
                Ape.log('--call_npc_ai--');
                Ape.log("game_id:" + g_id + ", p_num:" + p_num);
                Ape.log("result:" + npcresult);
            }
            var ans = JSON.parse(npcresult);

            var game = Ape.getChannelByName('arenagame_' + g_id);
            var game_cmds = '';
            var hidden_cmds = new $H;

            if ($chk(ans.data_result))
                ans.data_result.each(function(cmd) {
                    if (cmd.command == "end_game()") { //shedule delete timer
                        var timeoutID = Ape.setTimeout(function(gm_id) {
                            //send delete game request
                            var delrequest = new Http(lords_domain + '/game/mode' + allgames.get(gm_id).mode_id + '/ajax/delete_game.php');
                            delrequest.set('method', 'POST');
                            delrequest.writeObject({
                                'game_id': gm_id
                            });
                            delrequest.getContent(function(delresult) {
                                if (logging) Ape.log('del_game:' + delresult);
                                var channel = Ape.getChannelByName('arenachat_0');
                                if (channel)
                                    channel.pipe.sendRaw('protocol_raw', {
                                        commands: 'arena_game_delete(' + gm_id + ');'
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
                            if (next_p_num[1] < 4) {
                                var next_pl_num = next_p_num[1];
                                setNextTurnTimeout(g_id, allgames.get(g_id).time_restriction * 1000, next_pl_num.toInt());
                            }
                        }
                    }
                    if (cmd.command.indexOf("NPC(") != -1) { //load npc service
                        var npc_p_num = cmd.command.split('(');
                        npc_p_num = npc_p_num[1].split(')');
                        var npc_pl_num = npc_p_num[0];
                        callNPC(g_id, npc_pl_num);
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
            hidden_cmds.each(function(v, k) {
                var huser = Ape.getUserByPubid(users_by_id[k.toInt()]);
                if (huser)
                    huser.pipe.sendRaw('game_raw', {
                        commands: v
                    });
            });
        });
    }
    Ape.registerCmd('game_protocol_cmd', false, function(params, infos) {
        if (!$chk(infos.user) || !$chk(infos.user.user_id) || !$chk(infos.user.game_id)) {
            return ["1003", "Not authorized - please refresh browser"];
        }
        var start_time = $time();
        var phpsessid = params.phpsessid;
        if (params.proc_name == 'multi') {
            var request = new Http(lords_domain + '/site/ajax/multi_game_protocol.php?phpsessid=' + params.phpsessid);
        } else {
            var request = new Http(lords_domain + '/site/ajax/game_protocol.php?phpsessid=' + params.phpsessid);
        }
        request.set('method', 'POST');
        delete params.phpsessid;
        request.writeObject(params);
        request.getContent(function(result) {
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
                ans.data_result.each(function(cmd) {
                    if (cmd.command == "end_game()") { //shedule delete timer
                        var timeoutID = Ape.setTimeout(function(g_id) {
                            //send delete game request
                            var delrequest = new Http(lords_domain + '/game/mode' + allgames.get(g_id).mode_id + '/ajax/delete_game.php');
                            delrequest.set('method', 'POST');
                            delrequest.writeObject({
                                'game_id': g_id
                            });
                            delrequest.getContent(function(delresult) {
                                if (logging) Ape.log('del_game:' + delresult);
                                var channel = Ape.getChannelByName('arenachat_0');
                                if (channel)
                                    channel.pipe.sendRaw('protocol_raw', {
                                        commands: 'arena_game_delete(' + g_id + ');'
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
                            if (next_p_num[1] < 4) {
                                var next_pl_num = next_p_num[1];
                                setNextTurnTimeout(infos.user.game_id, allgames.get(infos.user.game_id).time_restriction * 1000, next_pl_num.toInt());
                            }
                        }
                    }
                    if (cmd.command.indexOf("NPC(") != -1) { //load npc service
                        var npc_p_num = cmd.command.split('(');
                        npc_p_num = npc_p_num[1].split(')');
                        var npc_pl_num = npc_p_num[0];
                        callNPC(infos.user.game_id, npc_pl_num);
                    }
                    //set spec -players count on delete spec or player command
                    if (cmd.hidden_flag == 0) game_cmds += encodeURIComponent(cmd.command) + ";";
                    else if (hidden_cmds.get(cmd.user_id) == null) hidden_cmds.set(cmd.user_id, encodeURIComponent(cmd.command) + ";");
                    else hidden_cmds.set(cmd.user_id, hidden_cmds.get(cmd.user_id) + encodeURIComponent(cmd.command) + ";");
                });

            if (ans.header_result.success == "0") {
                user_cmds += encodeURIComponent('proc_answer(' + params.proc_uid + ',0,' + ans.header_result.error_code + ',"' + ans.header_result.error_params + '");');
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
            hidden_cmds.each(function(v, k) {
                var huser = Ape.getUserByPubid(users_by_id[k.toInt()]);
                if (huser)
                    huser.pipe.sendRaw('game_raw', {
                        commands: v
                    });
            });
        });
    });

    

});

/* Listen on port 6970 (multicast) and high performences server */
/* Check ./framework/proxy.js for client API */

var socket = new Ape.sockServer(6970, "0.0.0.0", {
    flushlf: true /* onRead event is fired only when a \n is received (and splitted around it) e.g. foo\nbar\n  will call onRead two times with "foo" and "bar" */
});
