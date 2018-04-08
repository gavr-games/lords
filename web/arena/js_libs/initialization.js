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
var scrolls = new Array();

function initialization() {

    //drag players to chat
    $$('#players_list .arena_player').addEvent('mousedown', function (event) {
        event.stop();
        // `this` refers to the element with the .arena_player class
        var shirt = this;
        var clone = shirt.clone().setStyles(shirt.getCoordinates()).setStyles({
            opacity: 0.7,
            position: 'absolute',
            display: 'none'
        }).inject(document.body);
        var e_user_id = shirt.get('id').replace('player_', '')
        clone.set('class', 'arena_player_drag');
        var drag = new Drag.Move(clone, {
            droppables: $$('#chats_ticks .tick,#chats_messages .chat_field'),
            snap: 25,
            onSnap: function (draggable, droppable) {
                draggable.show();
            },
            onDrop: function (dragging, chat) {
                if (chat) {
		  var chat_id;
		  if (chat.hasClass('tick')) chat_id = chat.get('id').replace('topic_', '');
				 else chat_id = chat.get('id').replace('chat_messages_', '');
                  parent.sendLoggedProtocolCmd({action:'chat_user_add',params:{'user_id':e_user_id, 'chat_id':chat_id},help_params:{'topic':chats[chat_id]['topic']}});
                    chat.removeClass('add_user');
		    makeChatActive(chat_id);
                }
                dragging.destroy();
            },
            onEnter: function (draggable, droppable) {
                droppable.addClass('add_user');
            },
            onLeave: function (draggable, droppable) {
                droppable.removeClass('add_user');
            },
            onCancel: function (dragging) {
                dragging.destroy();
            }
        });
        drag.start(event);
    });

    var myTips = new Tips('.help');

    ticksScroll = new Fx.Scroll('con_ticks');
    $('r_arrow').addEvent('click', function (event) {
        ticks_pos += 154;
        if (ticks_pos > ($('chats_ticks').getChildren.length * 154 + 1) + 103) ticks_pos = ($('chats_ticks').getChildren.length + 1) * 154;
        ticksScroll.start(ticks_pos, 0);
    });
    $('l_arrow').addEvent('click', function (event) {
        ticks_pos -= 154;
        if (ticks_pos < 0) ticks_pos = 0;
        ticksScroll.start(ticks_pos, 0);
    });

    if ($('chats_ticks').getChildren().length < 6) {
        $('l_arrow').addClass('unactive');
        $('r_arrow').addClass('unactive');
    } else {
        $('l_arrow').removeClass('unactive');
        $('r_arrow').removeClass('unactive');
    }

    makeScrollbar($('players_list'), false, false);

    var chats_messages = $('chats_messages').getChildren();
    chats_messages.each(function (item, index) {
        makeScrollbar(item, false, false);
        item.addClass('hidden');
    });

    //set players statuses
    users.each(function (item, index) {
        if (item) {
            $('pstatus_' + index).set('title', player_status(item['status_id']));
        }
    });
    //connect ape to chat chanels
    var ape_chats = new Array();
    chats.each(function (item, index) {
        if (item) {
            ape_chats.push("arenachat_"+index);
        }
    });
    parent.apeJoinChanels(ape_chats);
    $$('#topic_0 .tick_cross').hide();
    makeChatActive(active_chat, true);
}

function exitArena() {
    if (!parent.window_loading) { //another window is not loading
	parent.sendLoggedProtocolCmd({action:'arena_exit',params:{}});
    }
}

function execute_procedure(name, params) {
    /*var myRequest = new Request({
        url: 'ajax/call_procedure.php',
        onSuccess: function (answer) {
            if (answer != "Ok") { //login error
                alert(answer);
            }
        }
    }).post('name=' + name + '&params=' + encodeURIComponent(params));*/
    console.log(name,params);
}

function makeChatActive(chat_id, init) {
    init = init || false;
    if (chat_id != active_chat || init) {
        if ($('topic_' + active_chat)) {
            $('topic_' + active_chat).removeClass('main_tick');
            $('topic_' + active_chat).addClass('back_tick');
            $('topic_val_' + active_chat).removeClass('active');
            $('chat_messages_' + active_chat).addClass('hidden');
            $('scroll_chat_messages_' + active_chat).hide();
            $('chat_users_' + active_chat).addClass('hidden');
        }
        active_chat = chat_id;
        $('topic_' + active_chat).addClass('main_tick');
        $('topic_' + active_chat).removeClass('back_tick');
        $('chat_messages_' + active_chat).removeClass('hidden');
        $('scroll_chat_messages_' + active_chat).show();
        $('chat_users_' + active_chat).removeClass('hidden');
        setposScrollBar('chat_messages_' + active_chat, false);
        modifyScrollBar('chat_messages_' + active_chat, false);
    }
}
function convertChars(s){
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
function convertFromChars(s){
  var escaped_one_to_xml_special_map = {
            '&amp;': '&',
	    '&quot;': '"',
	    '&lt;': '<',
	    '&gt;': '>',
            '&#92;':'\\',
	    '&apos;':'\''
        };
        return s.replace(/(&quot;|&lt;|&gt;|&amp;|&#92;|&apos;)/g,
	function(str, item) {
	  return escaped_one_to_xml_special_map[item];
	});
}
function sendChatMessage() {
    if ($('chat_text').get('value') != '\n') {
	parent.apeSendMsgToChanel('arenachat_' + active_chat,'ARENA_CHAT_MSG',{
            msg: convertChars($('chat_text').get('value')),
            from_user_id: my_user_id,
            from_chat_id: active_chat
        });
        $('chat_text').set('value', '');
    } else $('chat_text').set('value', '');
}

function changeChatTopic(chat_id) {
    if ($('topic_val_' + chat_id).get('value') != '\n') {
	parent.sendLoggedProtocolCmd({action:'chat_topic_change',params:{'chat_id':chat_id, newtopic:'"'+convertChars($('topic_val_' + chat_id).get('value'))+'"'}});
        $('topic_val_' + chat_id).removeClass('active');
    }
}

function getChatPlayers(chat_id) {
    var myRequest = new Request({
        url: 'ajax/get_chat_users.php',
        onSuccess: function (users) {
            eval(users);
        }
    }).send('chat_id=' + chat_id);
}
