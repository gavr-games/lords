var scrolls = new Array();

function initialization() {
    var myTips = new Tips('.help');
    makeScrollbar($('game_list'), false, false);
    makeScrollbar($('started_game_list'), false, false);
}

function enterGame(game_id, pass_flag) {
    if (pass_flag == 1) {
        $('pass_' + game_id).show();
    } else {
        subEnterGame(game_id);
    }
}

function subEnterGame(game_id) {
    var pass = '"' + $('gamepass_' + game_id).get('value') + '"';
    if (pass == '""') pass = 'null';
    //check game status end enter or spectate
    var parent_id = $('game_' + game_id).getParent().get('id');
    if (parent_id == 'game_list')
        parent.parent.WSClient.sendLoggedProtocolCmd({
            action: 'arena_game_enter',
            params: {
                'game_id': game_id,
                'pass': pass
            }
        });
    else
        parent.parent.WSClient.sendLoggedProtocolCmd({
            action: 'arena_game_spectator_enter',
            params: {
                'game_id': game_id,
                'pass': pass
            }
        });
}