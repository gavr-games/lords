// BUTTON LOADING PART BEGIN
var loadingButton;
var oldText = '';

function doLoading(link) {
    stopLoading();
    if (link) {
        loadingButton = link;
        oldText = link.get('text');
        link.set('text', 'Загрузка');
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
window.addEvent('domready', function () {
    $('reg_form').addEvent('keydown:keys(enter)', function () {
        doReg($('do_reg'));
        return false;
    });
    //$('login_i').focus();
});

function regAnswer(answer) {
    stopLoading();
    if (answer.header_result.success != "1") { //reg error
        $('reg_error').set('text', parent.getErrorMsg(answer.header_result.error_code,answer.header_result.error_params));
        $('reg_error').show();
    } else { //reg OK
        $('reg_ok').show();
	doLogin();
    }
}

function doReg(link) {
    if ($('pass_i').get('value') != $('pass2_i').get('value')) {
        $('reg_error').set('text', 'Пароли не совпадают');
        $('reg_error').show();
        $('pass_i').highlight('#A11D15');
        $('pass2_i').highlight('#A11D15');
    } else if ($('pass_i').get('value') == '' || $('login_i').get('value') == '') {
        $('reg_error').set('text', 'Не все поля заполнены.');
        $('reg_error').show();
        if ($('pass_i').get('value') == '') $('pass_i').highlight('#A11D15');
        if ($('login_i').get('value') == '') $('login_i').highlight('#A11D15');
    } else {
        $('reg_error').hide();
        parent.sendBaseProtocolCmd({action:'user_add',params:{
		login: '"'+parent.convertChars($('login_i').get('value'))+'"',
                pass:  '"'+$('pass_i').get('value').replace(new RegExp('"','g'),'\\"')+'"'
	}});
        doLoading(link);
    }
}

function loginAnswer(answer) {
    if (answer.header_result.success != "1") { //login error
        $('reg_error').set('text', parent.getErrorMsg(answer.header_result.error_code,answer.header_result.error_params));
        $('reg_error').show();
    } else { //login OK
	//console.log(answer);
        if (answer.data_result.game_type_id == 0) { //stay on top site
            parent.load_window('site/map.php', 'right');
        } else { //go to arena, etc.
            goToLocation(answer.data_result);
        }
    }
}

function doLogin() {
        if (!parent.window_loading) { //another window is not loading
	    parent.sendBaseProtocolCmd({action:'user_authorize',params:{
		login: '"'+parent.convertChars($('login_i').get('value'))+'"',
                pass:  '"'+$('pass_i').get('value').replace(new RegExp('"','g'),'\\"')+'"'
	    }});
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