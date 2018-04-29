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
    if (code == '004' || code == '1003') window.location.reload();
}

function displayLordsError(e, str) {
    var errDiv = new Element('div', {
        'html': 'Ошибка Javacript:' + e.name + '<br />Сообщение:' + e.message + '<br />Файл:' + e.fileName + '<br />Строка:' + e.lineNumber + '<br />Команды:<br />' + str + '<br /> Скопируйте текст ошибки и отправьте администратору. Затем нажмите F5.',
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
        '\'': '&apos;'
    };
    return s.replace(/([\&"<>\\\'])/g, function (str, item) {
        return xml_special_to_escaped_one_map[item];
    });
}


