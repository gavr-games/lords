defmodule LordsWs.UserChannel do
  use Phoenix.Channel
  require Logger

  def join("user:" <> user_id, _params, socket) do
    Logger.info "User " <> socket.assigns.user_id <> " joined personal user channel user:" <> user_id
    {:ok, socket}
  end

  def join("arena", _params, socket) do
    Logger.info "User " <> socket.assigns.user_id <> " joined channel arena"
    {:ok, socket}
  end

  def handle_in("logged_protocol_cmd", %{"json_params" => json_params}, socket) do
    url = "http://web/site/ajax/logged_protocol.php?phpsessid=#{socket.assigns.token}"
    eval_cmds = ""
    params = Jason.decode!(json_params)
    case HTTPoison.post(url, json_params, [{"Content-Type", "application/json"}]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Logger.info "Received logged_protocol_cmd answer " <> body
        req = Jason.decode!(body)
        case params["action"] do
          "logout" -> 
            if req["header_result"]["success"] == "1" do
                eval_cmds = eval_cmds <> URI.encode("parent.load_window(\"site/login.php\", \"left\"); parent.WSClient.disconnect();");
            end
          "arena_enter" -> 
            if req["header_result"]["success"] == "1" do
                LordsWs.Endpoint.broadcast "arena", "protocol_raw", %{commands: "arena_player_add(" <> socket.assigns.user_id <> ", \"" <> URI.decode(req["data_result"]["nick"]) <> "\", \"" <> URI.decode(req["data_result"]["avatar_filename"]) <> "\", 1);"}
                eval_cmds = eval_cmds <> URI.encode("parent.load_window(\"arena/arena.php\", \"right\");")
            end
          "chat_create_private" ->
            if req["header_result"]["success"] == "1" do
                chat_id = req["data_result"]["chat_id"]
                user1 = socket.assigns.user_id
                user2 = params["params"]["user_id"]
                eval_cmds = eval_cmds <> URI.encode("chat_create(#{chat_id},\"\"); chat_add_player('#{chat_id}','#{user1}'); chat_add_player('#{chat_id}','#{user2}');")
                LordsWs.Endpoint.broadcast "user:#{user2}", "protocol_raw", %{commands: eval_cmds}
            end
          "chat_exit" ->
            if req["header_result"]["success"] == "1" do
                chat_id = params["params"]["chat_id"]
                eval_cmds = eval_cmds <> URI.encode("chat_destroy(#{chat_id});")
                LordsWs.Endpoint.broadcast "chat:#{chat_id}", "protocol_raw", %{commands: "chat_remove_player(#{chat_id},#{socket.assigns.user_id})"}
            end
          "chat_topic_change" ->
            if req["header_result"]["success"] == "1" do
                chat_id = params["params"]["chat_id"]
                topic = params["params"]["newtopic"]
                LordsWs.Endpoint.broadcast "chat:#{chat_id}", "protocol_raw", %{commands: "chat_set_topic(#{chat_id},#{URI.encode(topic)})"}
            end
          "chat_user_add" ->
            if req["header_result"]["success"] == "1" do
                chat_id = params["params"]["chat_id"]
                user_id = params["params"]["user_id"]
                LordsWs.Endpoint.broadcast "chat:#{chat_id}", "protocol_raw", %{commands: "chat_add_player(#{chat_id},#{user_id});"}
                url = "http://web/site/ajax/get_chat_users.php?phpsessid=#{socket.assigns.token}"
                user_cmds = URI.encode("chat_create(#{chat_id},\"#{URI.decode(params["help_params"]["topic"])}\");")
                case HTTPoison.post(url, Jason.encode!(params["params"]), [{"Content-Type", "application/json"}]) do
                {:ok, %HTTPoison.Response{status_code: 200, body: chat_users_body}} ->
                    Logger.info "Received get_chat_users answer " <> chat_users_body
                    LordsWs.Endpoint.broadcast "user:#{user_id}", "protocol_raw", %{commands: user_cmds <> URI.encode(chat_users_body)}
                end
            end
          _ ->
            eval_cmds = ""
        end
        # Send error
        if req["header_result"]["success"] != "1" do
            push socket, "err", %{
                code: req["header_result"]["error_code"],
                value: req["header_result"]["error_params"]
            }
        end
    end
    if eval_cmds != "" do
        Logger.info "CMDS: " <> eval_cmds
        push socket, "protocol_raw", %{commands: eval_cmds}
    end
    {:noreply, socket}
  end
end

"""

            switch (params.action) {
                case 'arena_exit':
                    if (ans.header_result.success == "1") {
                        var arena_cmds = "";
                        eval_cmds += encodeURIComponent('parent.load_window("site/map.php", "left");');

                        if ($chk(ans.data_result))
                            if ($chk(ans.data_result.game_id))
                                if ($chk(ans.data_result.was_owner)) {
                                    var chan = Ape.getChannelByName('arenagame_' + ans.data_result.game_id);
                                    chan.userslist.each(function(user) {
                                        if ($chk(user.user_id)) {
                                            arena_cmds += encodeURIComponent('arena_player_set_status(' + user.user_id + ', 1);');
                                        }
                                    });
                                    Ape.rmChan('arenagame_' + ans.data_result.game_id);
                                    arena_cmds += 'arena_game_delete(' + ans.data_result.game_id + ');';
                                } else {
                                    var game_channel = Ape.getChannelByName('arenagame_' + ans.data_result.game_id);
                                    if (game_channel) game_channel.pipe.sendRaw('protocol_raw', {
                                        commands: encodeURIComponent('arena_game_remove_player(' + ans.data_result.game_id + ',' + infos.user.user_id + ');')
                                    });
                                    infos.user.left('arenagame_' + ans.data_result.game_id);
                                    if (ans.data_result.was_spectator.toInt() == 1) arena_cmds += encodeURIComponent('arena_game_dec_spectator_count(' + ans.data_result.game_id + ');');
                                    else arena_cmds += encodeURIComponent('arena_game_dec_player_count(' + ans.data_result.game_id + ');');
                                }
                        arena_cmds += encodeURIComponent('arena_player_remove(' + infos.user.user_id + ');');
                        if ($chk(ans.data_result))
                            if ($chk(ans.data_result.chats_ids)) {
                                var chats = ans.data_result.chats_ids.split(',');
                                chats.each(function(chat_id) {
                                    if (logging) Ape.log("chat_id:" + chat_id);
                                    infos.user.left('arenachat_' + chat_id);
                                    var chatchannel = Ape.getChannelByName('arenachat_' + chat_id);
                                    if (chatchannel) chatchannel.pipe.sendRaw('protocol_raw', {
                                        commands: encodeURIComponent('chat_remove_player(' + chat_id + ',' + infos.user.user_id + ')')
                                    });
                                });
                            }
                        var channel = Ape.getChannelByName('arenachat_0');
                        channel.pipe.sendRaw('protocol_raw', {
                            commands: arena_cmds
                        });
                        infos.user.left('arenachat_0');
                    }
                    break;
                case 'arena_game_player_remove':
                    if (ans.header_result.success == "1") {
                        var arena_cmds = "";
                        if ($chk(ans.data_result.owner) && ans.data_result.owner.toInt() == 1) {
                            var chan = Ape.getChannelByName('arenagame_' + params.params.game_id);
                            chan.userslist.each(function(user) {
                                if ($chk(user.user_id)) {
                                    arena_cmds += encodeURIComponent('arena_player_set_status(' + user.user_id + ', 1);');
                                }
                            });
                            Ape.rmChan('arenagame_' + params.params.game_id);
                            arena_cmds += 'arena_game_delete(' + params.params.game_id + ')';
                        } else {
                            var game_channel = Ape.getChannelByName('arenagame_' + params.params.game_id);
                            if (game_channel) game_channel.pipe.sendRaw('protocol_raw', {
                                commands: encodeURIComponent('arena_game_remove_player(' + params.params.game_id + ',' + params.params.user_id + ');')
                            });
                            var user = Ape.getUserByPubid(users_by_id[params.params.user_id.toInt()]);
                            if (user) {
                                user.left('arenagame_' + params.params.game_id);
                                arena_cmds += encodeURIComponent('arena_player_set_status(' + user.user_id + ', 1);');
                            }
                            if (ans.data_result.was_spectator.toInt() == 1) arena_cmds += encodeURIComponent('arena_game_dec_spectator_count(' + params.params.game_id + ');');
                            else arena_cmds += encodeURIComponent('arena_game_dec_player_count(' + params.params.game_id + ');');
                        }
                        var channel = Ape.getChannelByName('arenachat_0');
                        channel.pipe.sendRaw('protocol_raw', {
                            commands: arena_cmds
                        });
                    }
                    break;
                case 'arena_game_start':
                    if (ans.header_result.success == "1") {
                        var arena_cmds = "";
                        var channel = Ape.getChannelByName('arenagame_' + params.params.game_id);
                        channel.userslist.each(function(user) {
                            if ($chk(user.user_id)) {
                                arena_cmds += encodeURIComponent('arena_player_set_status(' + user.user_id + ', 3);')
                                user.left("arenachat_0");
                            }
                        });
                        arena_cmds += encodeURIComponent('arena_game_set_status(' + params.params.game_id + ', 2);');
                        channel.pipe.sendRaw('protocol_raw', {
                            commands: arena_cmds
                        });
                        var gamerequest = new Http(lords_domain + '/site/ajax/get_game_info.php');
                        gamerequest.set('method', 'POST');
                        gamerequest.writeObject({
                            game_id: params.params.game_id
                        });
                        gamerequest.getContent(function(gameresult) {
                            if (logging) {
                                Ape.log('--F5 game--');
                                Ape.log('F5 for game:' + gameresult);
                            }
                            var game = JSON.parse(gameresult);
                            if ($chk(game.game_id)) {
                                allgames.set(game.game_id, game);
                                if (game.status_id == 2) {
                                    sendPhrase(game.game_id);
                                    if (game.time_restriction != 0) setNextTurnTimeout(game.game_id, game.time_restriction.toInt() * 1000, game.active_player_num);
                                }
                            }
                        });
                    }
                    break;
                case 'arena_game_enter':
                    if (ans.header_result.success == "1") {
                        var new_status = 2;
                        var game_channel = Ape.getChannelByName('arenagame_' + params.params.game_id);
                        if (!game_channel) game_channel = Ape.mkChan('arenagame_' + params.params.game_id);
                        infos.user.join('arenagame_' + params.params.game_id);
                        game_channel.pipe.sendRaw('protocol_raw', {
                            commands: encodeURIComponent('arena_game_add_player(' + params.params.game_id + ',' + infos.user.user_id + ')')
                        });
                        var channel = Ape.getChannelByName('arenachat_0');
                        channel.pipe.sendRaw('protocol_raw', {
                            commands: encodeURIComponent('arena_player_set_status(' + infos.user.user_id + ', ' + new_status + ');arena_game_inc_spectator_count(' + params.params.game_id + ');')
                        });
                    }
                    break;
                case 'arena_game_spectator_enter':
                    if (ans.header_result.success == "1") {
                        var new_status = 3;
                        var game_channel = Ape.getChannelByName('arenagame_' + params.params.game_id);
                        if (!game_channel) game_channel = Ape.mkChan('arenagame_' + params.params.game_id);
                        infos.user.join('arenagame_' + params.params.game_id);
                        game_channel.pipe.sendRaw('game_raw', {
                            commands: encodeURIComponent('add_spectator(' + ans.data_result.player_num + ', "' + ans.data_result.player_name + '");')
                        });
                        var channel = Ape.getChannelByName('arenachat_0');
                        channel.pipe.sendRaw('protocol_raw', {
                            commands: encodeURIComponent('arena_player_set_status(' + infos.user.user_id + ', ' + new_status + ');arena_game_inc_spectator_count(' + params.params.game_id + ');')
                        });
                    }
                    break;
                case 'arena_game_feature_set':
                    if (ans.header_result.success == "1") {
                        var game_channel = Ape.getChannelByName('arenagame_' + params.params.game_id);
                        if (game_channel) game_channel.pipe.sendRaw('protocol_raw', {
                            commands: encodeURIComponent('arena_game_set_feature(' + params.params.game_id + ',' + params.params.feature_id + ',' + params.params.value + ')')
                        });
                    }
                    break;
                case 'arena_game_player_team_set':
                    if (ans.header_result.success == "1") {
                        var game_channel = Ape.getChannelByName('arenagame_' + params.params.game_id);
                        if (game_channel) game_channel.pipe.sendRaw('protocol_raw', {
                            commands: encodeURIComponent('arena_game_player_move_to_team(' + params.params.user_id + ',' + params.params.game_id + ',' + params.params.team_id + ');')
                        });
                        if (ans.data_result.was_spectator.toInt() == 1) {
                            var channel = Ape.getChannelByName('arenachat_0');
                            channel.pipe.sendRaw('protocol_raw', {
                                commands: encodeURIComponent('arena_game_dec_spectator_count(' + params.params.game_id + '); arena_game_inc_player_count(' + params.params.game_id + ');')
                            });
                        }
                    }
                    break;
                case 'arena_game_player_spectator_move':
                    if (ans.header_result.success == "1") {
                        var game_channel = Ape.getChannelByName('arenagame_' + params.params.game_id);
                        if (game_channel) game_channel.pipe.sendRaw('protocol_raw', {
                            commands: encodeURIComponent('arena_game_player_move_to_spectators(' + params.params.user_id + ',' + params.params.game_id + ');')
                        });

                        var channel = Ape.getChannelByName('arenachat_0');
                        channel.pipe.sendRaw('protocol_raw', {
                            commands: encodeURIComponent('arena_game_inc_spectator_count(' + params.params.game_id + '); arena_game_dec_player_count(' + params.params.game_id + ');')
                        });
                    }
                    break;
                case 'arena_game_create':
                    if (ans.header_result.success == "1") {
                        var enterrequest = new Http(lords_domain + '/site/ajax/logged_protocol.php?phpsessid=' + phpsessid);
                        enterrequest.set('method', 'POST');
                        enterrequest.writeObject({
                            action: 'arena_game_enter',
                            params: {
                                game_id: ans.data_result.game_id,
                                pass: params.params.pass
                            }
                        });
                        enterrequest.getContent(function(enteresult) {
                            if (logging) Ape.log('enterresult:' + enteresult);
                            var enterans = JSON.parse(enteresult);
                            if (enterans.header_result.success == "1") {
                                var channel = Ape.getChannelByName('arenachat_0');
                                if (params.params.pass == 'null') params.params.pass = 0;
                                else params.params.pass = 1;
                                channel.pipe.sendRaw('protocol_raw', {
                                    commands: encodeURIComponent('arena_game_add(' + ans.data_result.game_id + ',' + infos.user.user_id + ',' + decodeURIComponent(params.params.title) + ',' + params.params.pass + ',' + params.params.mode + '); arena_player_set_status(' + infos.user.user_id + ', 2);arena_game_inc_spectator_count(' + ans.data_result.game_id + ');')
                                });
                                var game_channel = Ape.getChannelByName('arenagame_' + ans.data_result.game_id);
                                if (!game_channel) game_channel = Ape.mkChan('arenagame_' + ans.data_result.game_id);
                                infos.user.join('arenagame_' + ans.data_result.game_id);
                                game_channel.pipe.sendRaw('protocol_raw', {
                                    commands: encodeURIComponent('arena_game_add_player(' + ans.data_result.game_id + ',' + infos.user.user_id + ')')
                                });
                            } else infos.sendResponse('err', {
                                code: enterans.header_result.error_code,
                                value: enterans.header_result.error_params
                            });
                        });
                    }
                    //eval_cmds+=encodeURIComponent('parent.load_window("site/login.php", "left");');
                    break;
                
                
            }

        });
        return -1;
    });
"""