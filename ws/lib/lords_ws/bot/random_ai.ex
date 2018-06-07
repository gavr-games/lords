defmodule LordsWs.Bot.RandomAi do
    alias LordsWs.Bot.Commands
    require Logger

    def move(state = %{game: game, static_info: static_info}) do
        game_info = nil
        Logger.info "Moving random bot #{game["game_id"]}_#{game["player_num"]}"
        url = "http://web-internal/internal/ajax/get_all_game_info.php?game_id=#{game["game_id"]}&player_num=#{game["player_num"]}&format=json"
        case HTTPoison.get(url, [], [timeout: 20_000, recv_timeout: 20_000]) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
            Logger.info "Answer from get_all_game_info.php"
            game_info = Jason.decode!(body)
        end
        {_res, cmds} = Commands.possible_cmds(game, game_info, static_info)
        Logger.info "Possible cmds for bot #{inspect(cmds)}"
        if length(cmds) > 0 do
            cmd = choose_cmd(game, cmds)
            Commands.exec_cmd(game, cmd)
            if cmd =~ "player_exit(" do
                Logger.info "Bot #{game["game_id"]}_#{game["player_num"]} player_exit received"
            else
                move(state)
            end
        end
    end

    def choose_cmd(game, cmds) do
        cmd = Enum.find(cmds, "", fn(c) -> c =~ "agree_draw(" end) #Agree to draw automatically
        if cmd == "", do: cmd = Enum.random(cmds)
        cmd
    end
end