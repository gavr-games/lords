var recieve_cmds = false;
var exec_commands_now = false;
var ws_exec_cmds = "";
var game_mode = 0;

function getErrorMsg(code, params) {
    params = decodeURIComponent(params);
    if ($chk(error_dictionary_messages[USER_LANGUAGE][code])) {
        var msg = error_message(code);
        var p_arr = params.split(',');
        if (p_arr.length>0)
        for(var i=0;i<p_arr.length;i++){
            msg = msg.replace('{'+i+'}',p_arr[i]);
        }
        return msg;
    } else {
        return params;
    }
}

function showError(code, params) {
    alert(getErrorMsg(code, params));
    if (current_window.contentWindow.$ && current_window.contentWindow.$('i_frame') && current_window.contentWindow.$('i_frame').contentWindow.$) {
        current_window.contentWindow.$('i_frame').contentWindow.$$('.loading').removeClass('loading')
    }
    if (code == '004' || code == '1003') window.location.reload();
}

function displayLordsError(e, str) {
    var errDiv = new Element('div', {
        'html': i18n[USER_LANGUAGE]["game"]["js_error"] + e.name + '<br />' + i18n[USER_LANGUAGE]["game"]["error_msg"] + ':' + e.message + '<br />' + i18n[USER_LANGUAGE]["game"]["error_file"] + ':' + e.fileName + '<br />' + i18n[USER_LANGUAGE]["game"]["error_line"] + ':' + e.lineNumber + '<br />' + i18n[USER_LANGUAGE]["game"]["error_commands"] + ':<br />' + str + '<br /> ' + i18n[USER_LANGUAGE]["game"]["error_send_admin"],
        'styles': {
            'position': 'absolute',
            'z-index': '20000',
            'background-color': 'red',
            'color': 'white',
            'top': 0,
            'left': 0,
            'padding': '10px',
            'border': '3px solid black',
            'width': 520
        }
    });
    document.body.grab(errDiv, 'top');
}

function convertChars(s) {
    var xml_special_to_escaped_one_map = {
        '&': '&amp;',
        '"': '&quot;',
        '<': '&lt;',
        '>': '&gt;',
        '\\': '&#92;',
        '\'': '&apos;',
        '%': '&#37;'
    };
    return s.replace(/([\%\&"<>\\\'])/g, function (str, item) {
        return xml_special_to_escaped_one_map[item];
    });
}


