function arena_player_add(user_id, nick, avatar_filename, status_id) {
    last_executed_api = 'arena_player_add(' + user_id + ',' + nick + ',' + status_id + ')';
    //eval("$('players_list').set('html',$('players_list').get('html')+"+player_in_playerslist+");");
    var players_str = '';
    eval('players_str = ' + player_in_playerslist);
    var els = Elements.from(players_str);
    $('players_list').adopt(els);
    $('pstatus_' + user_id).set('title', player_status(status_id));

    $('player_' + user_id).addEvent('mousedown', function (event) {
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
    modifyScrollBar('players_list', false);
    users[user_id] = new Array();
    users[user_id]['user_id'] = user_id;
    users[user_id]['nick'] = nick;
    users[user_id]['avatar_filename'] = avatar_filename;
    users[user_id]['status_id'] = status_id;
    var dt = new Date();
    dt = dt.getTime();
    dt = parseInt(dt/1000);
    chat_add_service_message(0,dt,nick+' вошел в Арену.');
}

function arena_player_remove(user_id) {
    last_executed_api = 'arena_player_remove(' + user_id + ')';
    $('player_' + user_id).destroy();
    delete users[user_id];
}

function arena_player_set_status(user_id, status_id) {
    last_executed_api = 'arena_player_set_status(' + user_id + ',' + status_id + ')';
    if ($('pstatus_' + user_id)) {
      $('pstatus_' + user_id).set('class', 'status_' + status_id);
      $('pstatus_' + user_id).set('title', player_status(status_id));
      users[user_id]['status_id'] = status_id;
      //redirect to game if I am playing
      //console.log(window.location.toString().replace('arena/','')+'game/mode'+$('i_frame').contentWindow.cur_game_mode_id);
      if (user_id == my_user_id && status_id == 3) {
	  //new URI(window.location.toString().replace('arena/','')+'game/mode'+$('i_frame').contentWindow.cur_game_mode_id).go();
	  parent.window.location.reload();
      }
    }
}
