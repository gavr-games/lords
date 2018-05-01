// BUTTON LOADING PART BEGIN
var loadingButton;
var oldText = '';

function doLoading(link, text) {
    stopLoading();
    if (link) {
        loadingButton = link;
        oldText = link.get('text');
        link.set('text', text);
        link.getParent().addClass('loading');
    }
}

function stopLoading() {
    if (loadingButton) {
        loadingButton.set('text', oldText);
        loadingButton.getParent().removeClass('loading');
    }
}
// BUTTON LOADING PART END
window.addEvent('domready', function() {
    if ($('login_form')) {
        $('login_form').addEvent('keydown:keys(enter)', function() {
            doLogin($('login_b'));
            return false;
        });
    }
    //$('login_i').focus();
});

function loginAnswer(answer) {
    if (answer.header_result.success != "1") { //login error
        stopLoading();
        $('login_error').set('text', parent.getErrorMsg(answer.header_result.error_code, answer.header_result.error_params));
        $('login_error').show();
    } else { //login OK
        //console.log(answer);
        parent.WSClient.disconnect(); //we want user to reconnect to socket as an authorized user
        if (answer.data_result.game_type_id == 0) { //stay on top site
            //parent.load_window('site/map.php', 'right');
            // #63 Temporarily login everyone to arena by default
            parent.WSClient.sendLoggedProtocolCmd({
                action: 'arena_enter',
                params: {}
            });
        } else { //go to arena, etc.
            goToLocation(answer.data_result);
        }
    }
}

function doLogin(link, validation_msg, loading_msg) {
    if ($('pass_i').get('value') == '' || $('login_i').get('value') == '') {
        $('login_error').set('text', validation_msg);
        $('login_error').show();
        if ($('pass_i').get('value') == '') $('pass_i').highlight('#A11D15');
        if ($('login_i').get('value') == '') $('login_i').highlight('#A11D15');
    } else {
        if (!parent.window_loading) { //another window is not loading
            $('login_error').hide();
            parent.WSClient.sendBaseProtocolCmd({
                action: 'user_authorize',
                params: {
                    login: '"' + parent.convertChars($('login_i').get('value')) + '"',
                    pass: '"' + $('pass_i').get('value').replace(new RegExp('"', 'g'), '\\"') + '"'
                }
            });
            doLoading(link, loading_msg);
        }
    }
}

function doLogout(link, loading_msg) {
    if (!parent.window_loading) { //another window is not loading
        parent.WSClient.sendLoggedProtocolCmd({
            action: 'logout',
            params: {}
        });
        doLoading(link, loading_msg);
    }
}

function enterArena() {
    if (!parent.window_loading) { //another window is not loading
        parent.WSClient.sendLoggedProtocolCmd({
            action: 'arena_enter',
            params: {}
        });
    }
}

function goToLocation(loc) {
    if (loc.player_num && loc.player_num != '') { //go to started game
        new parent.URI(parent.site_domen + 'game/mode' + loc.mode_id).go();
    } else if (loc.game_id && loc.game_id != '') { //go to not started game
        if (!parent.window_loading) //another window is not loading 
            parent.load_window(dic_game_types[loc.game_type_id]['description'] + '/' + dic_game_types[loc.game_type_id]['description'] + '.php', 'right');
    } else if (loc.game_type_id != '') { //go to general location
        if (!parent.window_loading) //another window is not loading
            parent.load_window(dic_game_types[loc.game_type_id]['description'] + '/' + dic_game_types[loc.game_type_id]['description'] + '.php', 'right');
    }
}