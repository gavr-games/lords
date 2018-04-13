var client; //ape client
var chats_pipes = new Array();
var users_pipes = new Array();
var ape_init_chanels = "";
var recieve_cmds = false;
var exec_commands_now = false;
var ape_exec_cmds = "";
var game_mode = 0;

function sendBaseProtocolCmd(params) {
    params.phpsessid = Cookie.read("PHPSESSID");
    client.core.request.send('base_protocol_cmd', params);
}

function sendLoggedProtocolCmd(params) {
    params.phpsessid = Cookie.read("PHPSESSID");
    client.core.request.send('logged_protocol_cmd', params);
}

function sendGameProtocolCmd(params) {
    params.phpsessid = Cookie.read("PHPSESSID");
    client.core.request.send('game_protocol_cmd', params);
}

function addGameProtocolStackCmd(params) {
    params.phpsessid = Cookie.read("PHPSESSID");
    client.core.request.cycledStack.add('game_protocol_cmd', params);
}

function sendGameProtocolStackCmd() {
    client.core.request.cycledStack.send();
}

function sendSimpleApeCmd(cmd, params) {
    client.core.request.send(cmd, params);
}

function apeJoinChanels(chanels) {
    if (client) client.core.join(chanels);
    else if (ape_init_chanels == "") ape_init_chanels = chanels;
    else ape_init_chanels.push.apply(ape_init_chanels, chanels);
}

function apeSendMsgToChanel(chl_name, cmd, params) {
    var chatPipe = client.core.getPipe(client.core.pipes_names[chl_name])
    chatPipe.request.send(cmd, params);
}

function apeGetGameInfo(){
    client.core.request.send('get_game_info_cmd', {phpsessid:Cookie.read("PHPSESSID")});
}

function myApeInit() {
    // Add Session.js to APE JSF to handle multitab and page refresh
    //APE.Config.scripts.push(APE.Config.baseUrl + '/Source/Core/Session.js');
     APE.Config.transport = 2;

    client = new APE.Client();
    client.load();

    client.addEvent('load', function () {
        //Call the core start function to connect to APE Server
        client.core.start({
            'phpsessid': Cookie.read("PHPSESSID")
        });
    });

    //Listen for the ready event to know when client is connected
    client.addEvent('ready', function () {
        if (ape_init_chanels != "") {
            apeJoinChanels(ape_init_chanels);
            ape_init_chanels = "";
        }
        client.core.pipes_names = new Array();
	
	//get game data
	if ($chk(game_mode) && game_mode==1){
	  removeLoadingItem('ape_script');
	}

    client.addEvent('multiPipeCreate', function (pipe, options) {
        //chats_pipes[pipe.pipe.properties.name.toString()] = pipe.pipe.pubid;
        client.core.pipes_names[pipe.pipe.properties.name] = pipe.pipe.pubid;
        //console.log(pipe.pipe.properties.name);
    });

    //-----SERVER'S ANSWERS-----
    //Protocol answer
    client.onRaw('protocol_raw', function (raw, pipe) {
        if (current_window.contentWindow.$) {
            //console.log(decodeURIComponent(raw.data.commands));
            try {
                current_window.contentWindow.eval(decodeURIComponent(raw.data.commands));
            } catch (e) {
                displayLordsError(e, decodeURIComponent(raw.data.commands) + '<br />Commands:' + current_window.contentWindow.last_executed_procedure + '<br />Last API:' + current_window.contentWindow.last_executed_api);
            }
        }
    });
	//game info answer
	client.onRaw('game_info_raw', function (raw) {
	  raw.data.commands = convertFromChars(raw.data.commands);
            try {
		    eval(raw.data.commands);
		    recieve_cmds = true;
		    initialization();
		} catch (e) {
		    wasError = true;
		    if (DEBUG_MODE) {
			displayLordsError(e, raw.data.commands + after_commands + '<br />Last executed_procedure:' + last_executed_procedure + '<br />Last API:' + last_executed_api);
		    }
		}
    });
	//Game answer
    client.onRaw('game_raw', function (raw, pipe) {
		if (!recieve_cmds) 
		  return -1;
		if (!exec_commands_now){
		  ape_exec_cmds += decodeURIComponent(raw.data.commands);
		 return -1;
		}
		raw.data.commands = decodeURIComponent(raw.data.commands);
		//handling ' (apostrophe) symmetric to game_protocol.php
		raw.data.commands = raw.data.commands.replace(/\\u0027/g, "'");
		//console.log(raw.data.commands);
		showHint = false;
		wasError = false;
		try {
		    if (DEBUG_MODE) {
                last_commands[last_commands_i] = raw.data.commands;
                last_commands_i++;
                if (last_commands_i > 9) last_commands_i = 0;
		    }
		    no_backlight = true;
		    commands_executing = true;
		    eval(raw.data.commands);
		    commands_executing = false;
		    no_backlight = false;
            after_commands += 'last_moved_unit = 0; showHint = true;';
		    if (anim_is_running) {
                post_move_anims += after_commands;
            } else  { 
                eval(after_commands);
            }
		    eval(after_commands_anims);
		    after_commands = '';
		    after_commands_anims = '';
		} catch (e) {
		    wasError = true;
		    if (DEBUG_MODE) {
			displayLordsError(e, raw.data.commands + after_commands + '<br />Last executed_procedure:' + last_executed_procedure + '<br />Last API:' + last_executed_api);
		    }
		}
    });
    //Chat message 
    client.onRaw('chat_msg', function (raw) {
        if (current_window.contentWindow.$) {
            current_window.contentWindow.chat_add_user_message(raw.data.params.from_chat_id, raw.data.params.from_user_id, raw.time, decodeURIComponent(raw.data.params.msg))
        }
    });
    //Intercept receipt of the new message.
    client.onRaw('ERR', function (raw, pipe) {
        switch (raw.data.code.toInt()) {
            case 100:
            break;
            case 1010:
            setTimeout("apeGetGameInfo();",1000);
            break;
            case 1004:
            load_window("site/login.php", "left"); //authorized in another browser
            default:
            showError(raw.data.code, raw.data.value);
        }
        //console.log('error:' + raw.data.code.toInt());
    });



    client.addEvent('userJoin', function (user, pipe) {
        //user joined main channel
        //if (pipe.name == "arena_1")	{
        //  users[user.properties.name.replace('arenauser_','')]['pubid'] = user.pubid;
        //}
    });
    client.addEvent('onCmd', function (cmd, args) {});
        if (typeOf(current_window) != 'null') current_window.fade(1);
    });
}

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

function convertFromChars(s) {
    var escaped_one_to_xml_special_map = {
        '&amp;': '&',
        '&quot;': '"',
        '&lt;': '<',
        '&gt;': '>',
        '&#92;': '\\',
        '&apos;': '\''
    };
    return s.replace(/(&quot;|&lt;|&gt;|&amp;|&#92;|&apos;)/g, function (str, item) {
        return escaped_one_to_xml_special_map[item];
    });
}
