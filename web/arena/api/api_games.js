function arena_game_add(game_id, owner_user_id, title, pass_flag, mode_id) {
    last_executed_api = 'arena_game_add(' + game_id + ',' + owner_user_id + ',' + title + ',' + pass_flag + ',' + mode_id + ')';
    if ($('i_frame').contentWindow.$)
        if ($('i_frame').contentWindow.$('game_list')) { //client in game_list_mode
            var game_str = '';
            var player_count = 0;
            var spectator_count = 0;
            var owner_name = users[owner_user_id]['nick'];
            var mode_name = modes[mode_id]['name'];
            var display_none = '';
            var pass_class = 'closed';
            if (!pass_flag) {
                display_none = 'display:none;';
                pass_class = 'free';
            }
            eval('game_str = ' + game_in_list);
            var els = $('i_frame').contentWindow.Elements.from(game_str);
            $('i_frame').contentWindow.$('game_list').adopt(els);
            $('i_frame').contentWindow.modifyScrollBar('game_list', false);
        }
}

function arena_game_set_player_spectator_count(game_id, player_count, spectator_count) {
    last_executed_api = 'arena_game_set_player_spectator_count(' + game_id + ',' + player_count + ',' + spectator_count + ')';
    if ($('i_frame').contentWindow.$)
        if ($('i_frame').contentWindow.$ && $('i_frame').contentWindow.$('game_list')) { //client in game_list_mode
            $('i_frame').contentWindow.$('game_players_' + game_id).set('text', player_count);
            $('i_frame').contentWindow.$('game_specs_' + game_id).set('text', spectator_count);
        }
}

function arena_game_inc_spectator_count(game_id) {
    last_executed_api = 'arena_game_inc_spectator_count(' + game_id + ')';
    if ($('i_frame').contentWindow.$)
        if ($('i_frame').contentWindow.$ && $('i_frame').contentWindow.$('game_list')) { //client in game_list_mode
            $('i_frame').contentWindow.$('game_specs_' + game_id).set('text', $('i_frame').contentWindow.$('game_specs_' + game_id).get('text').toInt() + 1);
        }
}

function arena_game_dec_spectator_count(game_id) {
    last_executed_api = 'arena_game_dec_spectator_count(' + game_id + ')';
    if ($('i_frame').contentWindow.$)
        if ($('i_frame').contentWindow.$ && $('i_frame').contentWindow.$('game_list')) { //client in game_list_mode
            $('i_frame').contentWindow.$('game_specs_' + game_id).set('text', $('i_frame').contentWindow.$('game_specs_' + game_id).get('text').toInt() - 1);
        }
}

function arena_game_inc_player_count(game_id) {
    last_executed_api = 'arena_game_inc_player_count(' + game_id + ')';
    if ($('i_frame').contentWindow.$)
        if ($('i_frame').contentWindow.$ && $('i_frame').contentWindow.$('game_list')) { //client in game_list_mode
            $('i_frame').contentWindow.$('game_players_' + game_id).set('text', $('i_frame').contentWindow.$('game_players_' + game_id).get('text').toInt() + 1);
        }
}

function arena_game_dec_player_count(game_id) {
    last_executed_api = 'arena_game_dec_player_count(' + game_id + ')';
    if ($('i_frame').contentWindow.$)
        if ($('i_frame').contentWindow.$ && $('i_frame').contentWindow.$('game_list')) { //client in game_list_mode
            $('i_frame').contentWindow.$('game_players_' + game_id).set('text', $('i_frame').contentWindow.$('game_players_' + game_id).get('text').toInt() - 1);
        }
}

function arena_game_set_status(game_id, status_id) {
    last_executed_api = 'arena_game_set_status(' + game_id + ',' + status_id + ')';
    if ($('i_frame').contentWindow.$)
        if ($('i_frame').contentWindow.$('game_list')) { //client in game_list_mode
            var game = $('i_frame').contentWindow.$('game_' + game_id).dispose();
            if (status_id == 1) {
                $('i_frame').contentWindow.$('game_list').grab(game);
                $('i_frame').contentWindow.modifyScrollBar('game_list', false);
            } else
            if (status_id == 2) {
                $('i_frame').contentWindow.$('started_game_list').grab(game);
                $('i_frame').contentWindow.modifyScrollBar('started_game_list', false);
            }
        }
}

function arena_game_delete(game_id) {
    last_executed_api = 'arena_game_delete(' + game_id + ')';
    if ($('i_frame').contentWindow.$)
        if ($('i_frame').contentWindow.$('game_list')) { //client in game_list_mode
            if ($('i_frame').contentWindow.$('game_' + game_id))
                $('i_frame').contentWindow.$('game_' + game_id).destroy();
        } else
    if ($('i_frame').contentWindow.$('game_features')) { //client in game mode
		if (game_id == $('i_frame').contentWindow.cur_game_id) { //go out of the game
			parent.WSClient.leaveChannel("game:" + game_id);
            $('i_frame').set('src', 'arena_gamelist.php');
        }
    }
}

function arena_game_add_player(game_id, user_id) {
    last_executed_api = 'arena_game_add_player(' + game_id + ',' + user_id + ')';
    if (user_id != my_user_id) {
        if ($('i_frame').contentWindow.$)
            if ($('i_frame').contentWindow.$('game_features')) { //client in game mode
                //add player
                var player_cont = 'spectators';
                var player_str = '';
                var name = users[user_id]['nick'];
                var avatar_filename = users[user_id]['avatar_filename'];
                var display = "none";
                if (avatar_filename != "") {
                    avatar_filename = parent.site_domen + "design/images/profile/" + users[user_id]['avatar_filename'];
                    display = "block";
                }
                eval('player_str = ' + player_in_game);
                var els = $('i_frame').contentWindow.Elements.from(player_str);
                $('i_frame').contentWindow.$(player_cont).adopt(els);
                $('i_frame').contentWindow.makePlayerDraggable(user_id);
            }
    } else { // go to game window
        parent.WSClient.joinGame(game_id);
        $('i_frame').set('src', 'arena_game.php?game_id=' + game_id);
    }
}

function arena_game_remove_player(game_id, user_id) {
    last_executed_api = 'arena_game_remove_player(' + game_id + ',' + user_id + ')';
	if (user_id == my_user_id && game_id == $('i_frame').contentWindow.cur_game_id) { //go out of the game
		parent.WSClient.leaveChannel("game:" + game_id)
        $('i_frame').set('src', 'arena_gamelist.php');
    } else {
        if ($('i_frame').contentWindow.$)
            if ($('i_frame').contentWindow.$('game_features')) { //client in game mode
                $('i_frame').contentWindow.$('gameplayer_' + user_id).destroy();
            }
    }
}

function arena_game_player_move_to_team(user_id, game_id, team) {
    last_executed_api = 'arena_game_player_set_team(' + user_id + ',' + game_id + ',' + team + ')';
    if ($('i_frame').contentWindow.$)
        if ($('i_frame').contentWindow.$('game_features')) { //client in game mode
            var player = $('i_frame').contentWindow.$('gameplayer_' + user_id).dispose();
            var team_id = 'team_players_' + team;
            $('i_frame').contentWindow.$(team_id).grab(player);
        }
}

function arena_game_player_move_to_spectators(user_id, game_id) {
    last_executed_api = 'arena_game_player_set_team(' + user_id + ',' + game_id + ')';
    if ($('i_frame').contentWindow.$)
        if ($('i_frame').contentWindow.$('game_features')) { //client in game mode
            var player = $('i_frame').contentWindow.$('gameplayer_' + user_id).dispose();
            $('i_frame').contentWindow.$('spectators').grab(player);
        }
}

function arena_game_set_feature(game_id, feature_id, param) {
    last_executed_api = 'arena_game_add_feature(' + game_id + ',' + feature_id + ',' + param + ')';

    //remove f-re
    if (games_features[feature_id]["feature_type"] == "bool") {
        if (param == 0) {
            arena_game_remove_feature(game_id, feature_id);
            return 1;
        } else param = "";
    }
    //add f-re
    if ($('i_frame').contentWindow.$) {
        if ($('i_frame').contentWindow.$('game_features')) { //client in game mode
            var feature_str = '';
            var name = parent.game_feature_description(feature_id);
            if (param == 'null') param = '';
            eval('feature_str = ' + feature_in_game);
            var els = $('i_frame').contentWindow.Elements.from(feature_str);
            //dont dublicate features
            if ($('i_frame').contentWindow.$('gamefeature_' + feature_id)) $('i_frame').contentWindow.$('gamefeature_' + feature_id).destroy();
            $('i_frame').contentWindow.$('game_features').adopt(els);
            //if feature is teams count
            if (feature_id == 3) {
                var team_count = param.toInt();
                var i = -1;
                $('i_frame').contentWindow.$('teams').getChildren().each(function(item, index) {
                    if (item) {
                        i = index;
                        if (index < team_count) { //do nothing it's ok
                        } else { //remove teams and copy players to no_team
                            var team_players = item.getChildren();
                            //$('i_frame').contentWindow.$('no_team').adopt(team_players);
                            item.destroy();
                        }
                    }
                });
                //add new teams
                if (i < team_count - 1) {
                    for (i++; i < team_count; i++) {
                        var team_str = '';
                        var id = i;
                        var players = '';
                        eval('team_str = ' + team_in_game);
                        var els = $('i_frame').contentWindow.Elements.from(team_str);
                        $('i_frame').contentWindow.$('teams').adopt(els);
                    }
                }
            }
        }
    }
}

function arena_game_remove_feature(game_id, feature_id) {
    last_executed_api = 'arena_game_remove_feature(' + game_id + ',' + feature_id + ')';
    if ($('i_frame').contentWindow.$)
        if ($('i_frame').contentWindow.$('game_features')) { //client in game mode
            $('i_frame').contentWindow.$('gamefeature_' + feature_id).destroy();
        }
}