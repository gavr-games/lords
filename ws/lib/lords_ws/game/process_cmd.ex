defmodule LordsWs.Game.ProcessCmd do
    require Logger
    require HTTPoison
    
    def run(%{game: game, answer: ans, user_id: user_id, params: params}) do
        start = :os.system_time()
        if Map.has_key?(ans, "data_result") do
            Enum.each ans["data_result"], fn cmd -> 
                if cmd["command"] == "end_game()" do
                    GenServer.start_link(LordsWs.Game.RemoveTimer, %{game_id: game["game_id"]})
                end
                # Next turn
                if cmd["command"] =~ "set_active_player(" && game["time_restriction"] != "0" do
                    LordsWs.Endpoint.broadcast "end_turn_timer:#{game["game_id"]}", "cancel", %{}
                    next_p_num = cmd["command"]
                        |> String.split(",")
                        |> Enum.at(0)
                        |> String.split("(")
                        |> Enum.at(1)
                        |> String.to_integer()
                    if next_p_num < 4 do
                        LordsWs.NextTurn.Timer.create(game |> Map.put("active_player_num", next_p_num))
                    end
                end
                # NPC
                if cmd["command"] =~ "NPC(" do
                    npc_p_num = cmd["command"]
                        |> String.split("(")
                        |> Enum.at(1)
                        |> String.split(")")
                        |> Enum.at(0)
                    GenServer.start_link(LordsWs.Npc.Worker, %{game: game, p_num: npc_p_num})
                end
                # Hidden cmds
                if cmd["hidden_flag"] == "0" do
                    LordsWs.Endpoint.broadcast "game:#{game["game_id"]}", "game_raw", %{commands: URI.encode(cmd["command"])}
                else
                    LordsWs.Endpoint.broadcast "user:#{cmd["user_id"]}", "game_raw", %{commands: URI.encode(cmd["command"])}
                end
            end
        end

        if Map.has_key?(params, "proc_uid") do
            if ans["header_result"]["success"] == "1" do
                cmd = "proc_answer(#{params["proc_uid"]},1,0,\"\",#{:os.system_time() - start},#{ans["phptime"]});"
                LordsWs.Endpoint.broadcast "game:#{game["game_id"]}", "game_raw", %{commands: URI.encode(cmd)}
            else
                cmd = "proc_answer(#{params["proc_uid"]},0,#{ans["header_result"]["error_code"]},\"#{ans["header_result"]["error_params"]}\");"
                LordsWs.Endpoint.broadcast "user:#{user_id}", "game_raw", %{commands: URI.encode(cmd)}
            end
        end
    end

end