defmodule LordsWs.Arena.ProcessCmd do
    require Logger
    require HTTPoison
    
    def run(%{answer: req, socket: socket, params: params}) do
        eval_cmds = ""
        arena_cmds = ""
        case params["action"] do
          "logout" -> 
            if req["header_result"]["success"] == "1" do
                eval_cmds = "#{eval_cmds}#{URI.encode("parent.load_window(\"site/login.php\", \"left\"); parent.WSClient.disconnect();")}";
            end
          "arena_enter" -> 
            if req["header_result"]["success"] == "1" do
                LordsWs.Endpoint.broadcast "arena", "protocol_raw", %{commands: "arena_player_add(#{socket.assigns.user_id}, \"#{URI.decode(req["data_result"]["nick"])}\", \"#{URI.decode(req["data_result"]["avatar_filename"])}\", 1);"}
                eval_cmds = "#{eval_cmds}#{URI.encode("parent.load_window(\"arena/arena.php\", \"right\");")}"
            end
          "chat_create_private" ->
            if req["header_result"]["success"] == "1" do
                chat_id = req["data_result"]["chat_id"]
                user1 = socket.assigns.user_id
                user2 = params["params"]["user_id"]
                eval_cmds = "#{eval_cmds}#{URI.encode("chat_create(#{chat_id},\"\"); chat_add_player('#{chat_id}','#{user1}'); chat_add_player('#{chat_id}','#{user2}');")}"
                LordsWs.Endpoint.broadcast "user:#{user2}", "protocol_raw", %{commands: eval_cmds}
            end
          "chat_exit" ->
            if req["header_result"]["success"] == "1" do
                chat_id = params["params"]["chat_id"]
                eval_cmds = "#{eval_cmds}#{URI.encode("chat_destroy(#{chat_id});")}"
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
                    Logger.info "Received get_chat_users answer #{chat_users_body}"
                    LordsWs.Endpoint.broadcast "user:#{user_id}", "protocol_raw", %{commands: "#{user_cmds}#{URI.encode(chat_users_body)}"}
                end
            end
          "arena_game_create" ->
            if req["header_result"]["success"] == "1" do
                game_id = req["data_result"]["game_id"]
                owner_id = socket.assigns.user_id
                url = "http://web/site/ajax/logged_protocol.php?phpsessid=#{socket.assigns.token}"
                case HTTPoison.post(url, Jason.encode!(%{action: "arena_game_enter", params: %{game_id: game_id, pass: params["params"]["pass"]}}), [{"Content-Type", "application/json"}]) do
                    {:ok, %HTTPoison.Response{status_code: 200, body: enter_body}} ->
                        Logger.info "Received arena_game_enter answer #{enter_body}"
                        enter_req = Jason.decode!(enter_body)
                        if enter_req["header_result"]["success"] == "1" do
                            LordsWs.Endpoint.broadcast "arena", "protocol_raw", %{commands: URI.encode("arena_game_add(#{game_id},#{owner_id},#{URI.decode(params["params"]["title"])},#{URI.decode(params["params"]["pass"])},#{params["params"]["mode"]}); arena_player_set_status(#{owner_id}, 2);arena_game_inc_spectator_count(#{game_id});")}
                            LordsWs.Endpoint.broadcast "user:#{owner_id}", "protocol_raw", %{commands: URI.encode("arena_game_add_player(#{game_id},#{owner_id})")}
                        else
                            LordsWs.Endpoint.broadcast "user:#{socket.assigns.user_id}", "err", %{
                                code: enter_req["header_result"]["error_code"],
                                value: enter_req["header_result"]["error_params"]
                            }
                        end
                end
            end
          "arena_game_player_team_set" ->
            if req["header_result"]["success"] == "1" do
                game_id = params["params"]["game_id"]
                LordsWs.Endpoint.broadcast "game:#{game_id}", "protocol_raw", %{commands: URI.encode("arena_game_player_move_to_team(#{params["params"]["user_id"]},#{game_id},#{params["params"]["team_id"]});")}
                if req["data_result"]["was_spectator"] == "1" do
                    LordsWs.Endpoint.broadcast "game:#{game_id}", "protocol_raw", %{commands: URI.encode("arena_game_dec_spectator_count(#{game_id}); arena_game_inc_player_count(#{game_id});")}
                end
            end
          "arena_game_player_spectator_move" ->
            if req["header_result"]["success"] == "1" do
                game_id = params["params"]["game_id"]
                LordsWs.Endpoint.broadcast "game:#{game_id}", "protocol_raw", %{commands: URI.encode("arena_game_player_move_to_spectators(#{params["params"]["user_id"]},#{game_id});")}
                if req["data_result"]["was_spectator"] == "1" do
                    LordsWs.Endpoint.broadcast "game:#{game_id}", "protocol_raw", %{commands: URI.encode("arena_game_inc_spectator_count(#{game_id}); arena_game_dec_player_count(#{game_id});")}
                end
            end
          "arena_game_feature_set" ->
            if req["header_result"]["success"] == "1" do
                game_id = params["params"]["game_id"]
                LordsWs.Endpoint.broadcast "game:#{game_id}", "protocol_raw", %{commands: URI.encode("arena_game_set_feature(#{game_id},#{params["params"]["feature_id"]},#{params["params"]["value"]})")}
            end
          "arena_game_enter" ->
            if req["header_result"]["success"] == "1" do
                game_id = params["params"]["game_id"]
                user_id = socket.assigns.user_id
                new_status = 2
                LordsWs.Endpoint.broadcast "game:#{game_id}", "protocol_raw", %{commands: URI.encode("arena_game_add_player(#{game_id},#{user_id})")}
                LordsWs.Endpoint.broadcast "user:#{socket.assigns.user_id}", "protocol_raw", %{commands: URI.encode("arena_game_add_player(#{game_id},#{user_id})")}
                LordsWs.Endpoint.broadcast "arena", "protocol_raw", %{commands: URI.encode("arena_player_set_status(#{user_id},#{new_status});arena_game_inc_spectator_count(#{game_id});")}
            end
          "arena_game_player_remove" ->
            if req["header_result"]["success"] == "1" do
                game_id = params["params"]["game_id"]
                user_id = params["params"]["user_id"]
                if req["data_result"]["owner"] == "1" do
                    arena_cmds = arena_cmds <> Enum.join(Enum.map(UserPresence.list("game:#{game_id}"),  fn {u_id, _metas} ->
                        "arena_player_set_status(#{u_id}, 1);"
                    end))
                    arena_cmds = "#{arena_cmds}arena_game_delete(#{game_id});"
                end
                unless req["data_result"]["owner"] == "1" do
                    LordsWs.Endpoint.broadcast "game:#{game_id}", "protocol_raw", %{commands: URI.encode("arena_game_remove_player(#{game_id},#{user_id});")}
                    arena_cmds = "#{arena_cmds}arena_player_set_status(#{user_id}, 1);"
                    if req["data_result"]["was_spectator"] == "1", do: arena_cmds = "#{arena_cmds}arena_game_dec_spectator_count(#{game_id});", else: arena_cmds = "#{arena_cmds}arena_game_dec_player_count(#{game_id});"
                end
            end
          "arena_game_spectator_enter" ->
            if req["header_result"]["success"] == "1" do
                game_id = params["params"]["game_id"]
                user_id = socket.assigns.user_id
                new_status = 3
                LordsWs.Endpoint.broadcast "game:#{game_id}", "protocol_raw", %{commands: URI.encode("add_spectator(#{req["data_result"]["player_num"]}, \"#{req["data_result"]["player_name"]}\");")}
                LordsWs.Endpoint.broadcast "arena", "protocol_raw", %{commands: URI.encode("arena_player_set_status(#{user_id},#{new_status});arena_game_inc_spectator_count(#{game_id});")}
            end
          "arena_exit" ->
            if req["header_result"]["success"] == "1" do
                user_id = socket.assigns.user_id
                if req["data_result"]["was_owner"] == "1" do
                    game_id = req["data_result"]["game_id"]
                    arena_cmds = arena_cmds <> Enum.join(Enum.map(UserPresence.list("game:#{game_id}"),  fn {u_id, _metas} ->
                        "arena_player_set_status(#{u_id}, 1);"
                    end))
                    arena_cmds = "#{arena_cmds}arena_game_delete(#{game_id});"
                end
                if req["data_result"]["was_owner"] != "1" && Map.has_key?(req, "data_result") && Map.has_key?(req["data_result"], "game_id") do
                    game_id = req["data_result"]["game_id"]
                    LordsWs.Endpoint.broadcast "game:#{game_id}", "protocol_raw", %{commands: URI.encode("arena_game_remove_player(#{game_id},#{user_id});")}
                    if req["data_result"]["was_spectator"] == "1", do: arena_cmds = "#{arena_cmds}arena_game_dec_spectator_count(#{game_id});", else: arena_cmds = "#{arena_cmds}arena_game_dec_player_count(#{game_id});"
                end
                if Map.has_key?(req, "data_result") && Map.has_key?(req["data_result"], "chats_ids") do
                    Enum.each String.split(req["data_result"]["chats_ids"], ","), fn chat_id -> 
                        LordsWs.Endpoint.broadcast "chat:#{chat_id}", "protocol_raw", %{commands: URI.encode("chat_remove_player(#{chat_id},#{user_id})")}
                    end
                end
                arena_cmds = "#{arena_cmds}#{URI.encode("arena_player_remove(#{user_id});")}"
            end
          "arena_game_start" ->
            if req["header_result"]["success"] == "1" do
                game_id = params["params"]["game_id"]
                arena_cmds = arena_cmds <> Enum.join(Enum.map(UserPresence.list("game:#{game_id}"),  fn {u_id, _metas} ->
                    "arena_player_set_status(#{u_id}, 3);"
                end))
                arena_cmds = "#{arena_cmds}arena_game_set_status(#{game_id}, 2);"
                url = "http://web/site/ajax/get_game_info.php?game_id=#{game_id}"
                case HTTPoison.get(url) do
                    {:ok, %HTTPoison.Response{status_code: 200, body: game_body}} ->
                        Logger.info "Received get_game_info answer #{game_body}"
                        game = Jason.decode!(game_body)
                        if Map.has_key?(game, "game_id") && game["status_id"] == "2" do
                            LordsWs.SendPhrase.Timer.create(game)
                            if game["time_restriction"] != "0" do
                                LordsWs.NextTurn.Timer.create(game)
                            end
                        end
                end
            end
          _ ->
            eval_cmds = ""
        end
        # Send error
        if req["header_result"]["success"] != "1" do
            LordsWs.Endpoint.broadcast "user:#{socket.assigns.user_id}", "err", %{
                code: req["header_result"]["error_code"],
                value: req["header_result"]["error_params"]
            }
        end 

        if eval_cmds != "" do
            Logger.info "CMDS: #{eval_cmds}"
            LordsWs.Endpoint.broadcast "user:#{socket.assigns.user_id}", "protocol_raw", %{commands: eval_cmds}
        end
        if arena_cmds != "" do
            LordsWs.Endpoint.broadcast "arena", "protocol_raw", %{commands: URI.encode(arena_cmds)}
        end
    end
end