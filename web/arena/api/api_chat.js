function chat_add_user_message(chat_id, user_id, mtime, message) {
    last_executed_api = 'chat_add_user_message(' + chat_id + ',' + user_id + ',' + mtime + ',' + message + ')';
    //console.log(last_executed_api);
    if ($('chat_messages_' + chat_id)) {
        var nick = users[user_id]['nick'];
        var color = users[user_id]['color'];
        var time = new Date();
        time.setTime(mtime * 1000);
        time = time.format('%T');
        message = message.replace(/\*([^\s\*]+)\*/g, "<img src=\"../design/images/pregame/smiles/Animated22/$1.gif\" />");
        message = linkify(message);
        var message_str = '';
        eval('message_str = ' + chat_message);
        var els = Elements.from(message_str);
        $('chat_messages_' + chat_id).adopt(els);
        var scroll = $('chat_messages_' + chat_id).getScrollSize();
        $('chat_messages_' + chat_id).scrollTo(0, scroll.y);
        modifyScrollBar('chat_messages_' + chat_id, false);
    }
}

function chat_add_service_message(chat_id, mtime, message) {
    last_executed_api = 'chat_add_service_message(' + chat_id + ',' + mtime + ',' + message + ')';
    if ($('chat_messages_' + chat_id)) {
        var time = new Date();
        time.setTime(mtime * 1000);
        time = time.format('%T');
        message = message.replace(/\*([^\s\*]+)\*/g, "<img src=\"../design/images/pregame/smiles/Animated22/$1.gif\" />");
        message = linkify(message);
        var message_str = '';
        eval('message_str = ' + chat_service_message);
        var els = Elements.from(message_str);
        $('chat_messages_' + chat_id).adopt(els);

        var scroll = $('chat_messages_' + chat_id).getScrollSize();
        $('chat_messages_' + chat_id).scrollTo(0, scroll.y);
        modifyScrollBar('chat_messages_' + chat_id, false);
    }
}

function chat_player_set_color(chat_id, user_id, color) {
    last_executed_api = 'chat_player_set_color(' + chat_id + ',' + user_id + ',' + color + ')';
    users[user_id]['color'] = color;
}

function chat_create(chat_id, topic) {
    last_executed_api = 'chat_create(' + chat_id + ',' + topic + ')';
    topic = convertFromChars(topic);
    var messages = '';
    var users = '';
    var chat_topic_str = '';
    var chat_messages_str = '';
    var chat_users_str = '';
	var els;
	
	parent.WSClient.joinChat(chat_id);

    eval('chat_topic_str = ' + chat_topic);
    els = Elements.from(chat_topic_str);
    $('chats_ticks').adopt(els);
    eval('chat_messages_str = ' + chat_messages);
    els = Elements.from(chat_messages_str);
    $('chats_messages').adopt(els);
    makeScrollbar($('chat_messages_' + chat_id), false, false);
    eval('chat_users_str = ' + chat_users);
    els = Elements.from(chat_users_str);
    $('chats_users').adopt(els);
    //getChatPlayers(chat_id);
    chats[chat_id] = new Array();
    chats[chat_id]['chat_id'] = chat_id;
    chats[chat_id]['topic'] = topic;
    chats[chat_id]['users'] = new Array();
    if ($('chats_ticks').getChildren().length < 6) {
        $('l_arrow').addClass('unactive');
        $('r_arrow').addClass('unactive');
    } else {
        $('l_arrow').removeClass('unactive');
        $('r_arrow').removeClass('unactive');
    }
}

function chat_add_player(chat_id, user_id) {
    last_executed_api = 'chat_add_player(' + chat_id + ',' + user_id + ')';
    if ($('chat_users_' + chat_id) && $chk(chats[chat_id]) && !chats[chat_id]['users'].contains(user_id)) {
        var user_str = '';
        var nick = users[user_id]['nick'];
        eval('user_str = ' + chat_user);
        var els = Elements.from(user_str);
        $('chat_users_' + chat_id).adopt(els);
        chats[chat_id]['users'][user_id] = user_id;
        users[user_id]['color'] = 'black';
        var dt = new Date();
        dt = dt.getTime();
        dt = parseInt(dt / 1000);
        chat_add_service_message(chat_id, dt, nick + i18n[parent.USER_LANGUAGE]['arena_chat']['entered_chat']);
        if (chats[chat_id]['topic'] == '') {
            if ($('topic_val_' + chat_id)) {
                $('topic_val_' + chat_id).set('value', $('topic_val_' + chat_id).get('value') + convertFromChars(nick) + ' ');
            }
        }
    }
}

function chat_remove_player(chat_id, user_id) {
    last_executed_api = 'chat_remove_player(' + chat_id + ',' + user_id + ')';
    if ($('chat_users_' + chat_id)) {
        //delete player
        $('chat_' + chat_id + '_user_' + user_id).destroy();
        delete chats[chat_id]['users'][user_id];
        var nick = users[user_id]['nick'];
        var dt = new Date();
        dt = dt.getTime();
        dt = parseInt(dt / 1000);
        chat_add_service_message(chat_id, dt, nick + i18n[parent.USER_LANGUAGE]['arena_chat']['left_chat']);
    }
    if (user_id == my_user_id) {
        chat_destroy(chat_id);
    }
}

function chat_set_topic(chat_id, topic) {
    last_executed_api = 'chat_set_topic(' + chat_id + ',' + topic + ')';
    if ($('topic_val_' + chat_id)) {
        $('topic_val_' + chat_id).set('value', convertFromChars(topic));
        chats[chat_id]['topic'] = topic;
    }
}

function chat_destroy(chat_id) {
    if (active_chat == chat_id) makeChatActive(0);
    if ($('topic_' + chat_id)) {
        $('topic_' + chat_id).destroy();
        $('chat_messages_' + chat_id).destroy();
        $('chat_users_' + chat_id).destroy();
        $('scroll_chat_messages_' + chat_id).destroy();
        delete scrolls['chat_messages_' + chat_id];
        delete chats[chat_id];
        if ($('chats_ticks').getChildren().length < 6) {
            $('l_arrow').addClass('unactive');
            $('r_arrow').addClass('unactive');
        } else {
            $('l_arrow').removeClass('unactive');
            $('r_arrow').removeClass('unactive');
        }
        parent.WSClient.leaveChannel("chat:" + chat_id)
    }
}

function linkify(inputText) {
    var replacedText, replacePattern1, replacePattern2, replacePattern3;

    //URLs starting with http://, https://, or ftp://
    replacePattern1 = /(\b(https?|ftp):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/gim;
    replacedText = inputText.replace(replacePattern1, '<a target="_blank" href="$1" target="_blank">$1</a>');

    //URLs starting with "www." (without // before it, or it'd re-link the ones done above).
    replacePattern2 = /(^|[^\/])(www\.[\S]+(\b|$))/gim;
    replacedText = replacedText.replace(replacePattern2, '$1<a target="_blank" href="http://$2" target="_blank">$2</a>');

    //Change email addresses to mailto:: links.
    replacePattern3 = /(\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,6})/gim;
    replacedText = replacedText.replace(replacePattern3, '<a target="_blank" href="mailto:$1">$1</a>');

    return replacedText;
}