
function makePlayerDraggable(player_id) {
    $('gameplayer_' + player_id).addEvent('mousedown', function(event) {
        event.stop();
        // `this` refers to the element with the .arena_player class
        var shirt = this;
        var shirt_styles = shirt.getCoordinates();
        delete shirt_styles.height;
        delete shirt_styles.width;
        var clone = shirt.clone().setStyles(shirt_styles).setStyles({
            opacity: 0.7,
            position: 'absolute',
            display: 'none'
        }).inject(document.body);
        var e_user_id = shirt.get('id').replace('gameplayer_', '')
        var is_bot = shirt.get('data-is-bot') == "1";

        var drag = new Drag.Move(clone, {
            droppables: $$('#teams .game_team, #trash, #spectators'),
            snap: 25,
            onSnap: function(draggable, droppable) {
                draggable.show();
            },
            onDrop: function(dragging, team) {
                if (team) {
                    var team_id = team.get('id').replace('team_', '');
                    if (team_id == 'trash') { //delete user
                        var action_name = 'arena_game_player_remove';
                        if (is_bot) {
                            action_name = 'arena_game_bot_remove';
                        }
                        parent.parent.WSClient.sendLoggedProtocolCmd({
                            action: action_name,
                            params: {
                                'game_id': cur_game_id,
                                'user_id': e_user_id
                            }
                        });
                    } else
                    if (team_id == 'spectators') { //move to spectator
                        parent.parent.WSClient.sendLoggedProtocolCmd({
                            action: 'arena_game_player_spectator_move',
                            params: {
                                'game_id': cur_game_id,
                                'user_id': e_user_id
                            }
                        });
                        team.removeClass('add_user');
                    } else { //change team
                        parent.parent.WSClient.sendLoggedProtocolCmd({
                            action: 'arena_game_player_team_set',
                            params: {
                                'game_id': cur_game_id,
                                'user_id': e_user_id,
                                'team_id': team_id
                            }
                        });
                        team.removeClass('add_user');
                    }
                }
                dragging.destroy();
            },
            onEnter: function(draggable, droppable) {
                droppable.addClass('add_user');
            },
            onLeave: function(draggable, droppable) {
                droppable.removeClass('add_user');
            },
            onCancel: function(dragging) {
                dragging.destroy();
            }
        });
        drag.start(event);
    });
}

function game_initialization() {
    $$('.player_in_game').each(function(item, index) {
        if (item) {
            shirt = item;
            var e_user_id = shirt.get('id').replace('gameplayer_', '')
            makePlayerDraggable(e_user_id);
        }
    });
    var myTips = new Tips('.help');
    //makeScrollbar($('ingame_content'),false,false);
}

function changeFeature(feature_id, game_id) {
    var f_val = 0;
    if ($('feature_' + feature_id).getProperty('checked'))
        f_val = 1;
    parent.parent.WSClient.sendLoggedProtocolCmd({
        action: 'arena_game_feature_set',
        params: {
            'game_id': game_id,
            'feature_id': feature_id,
            'value': f_val
        }
    });
}

function addFeature(feature_id, game_id) {
    parent.parent.WSClient.sendLoggedProtocolCmd({
        action: 'arena_game_feature_set',
        params: {
            'game_id': game_id,
            'feature_id': feature_id,
            'value': $('feature_' + feature_id).get('value')
        }
    });
}

function exitGame() {
    parent.parent.WSClient.sendLoggedProtocolCmd({
        action: 'arena_game_player_remove',
        params: {
            'game_id': cur_game_id,
            'user_id': parent.my_user_id
        }
    });
}

function startGame() {
    $('start_game').addClass('loading');
    parent.parent.WSClient.sendLoggedProtocolCmd({
        action: 'arena_game_start',
        params: {
            'game_id': cur_game_id
        }
    });
}

function addBot() {
    parent.parent.WSClient.sendLoggedProtocolCmd({
        action: 'arena_game_bot_add',
        params: {
            'game_id': cur_game_id
        }
    });
}