defmodule LordsWs.Bot.Commands do
    alias LordsWs.Bot.GameInfo
    alias LordsWs.Bot.StaticInfo
    require Logger

    def possible_cmds(game, game_info, static_info) do
        game_data = %{
            game_info: GameInfo.process(game_info),
            static_info: StaticInfo.process(static_info),
            game: game,
            commands: []
        }

        if game_data[:game_info][:active_player]["player_num"] == game["player_num"] do
            game_data = game_data
            |> end_turn_cmd
            |> buy_card_cmd
        end

        {:ok, game_data[:commands]}
    end

    def end_turn_cmd(game_data = %{game: game, commands: commands}) do
        commands = commands ++ ["player_end_turn(#{game["game_id"]},#{game["player_num"]});"]
        game_data |> Map.put(:commands, commands)
    end

    def buy_card_cmd(game_data = %{game_info: game_info, static_info: static_info, game: game, commands: commands}) do
        card_played   = game_info[:active_player]["card_played_flag"]
        my_gold       = String.to_integer(game_info[:players][game["player_num"]]["gold"])
        required_gold = String.to_integer(static_info[:mode_config]["card cost"])
        if card_played == "0" && my_gold >= required_gold do
            commands = commands ++ ["buy_card(#{game["game_id"]},#{game["player_num"]});"]
        end
        game_data |> Map.put(:commands, commands)
    end

    def exec_cmd(game, cmd) do
        url = "http://web-internal/internal/ajax/bot.php"
        case HTTPoison.post(url, Jason.encode!(%{cmd: cmd}), [{"Content-Type", "application/json"}]) do
            {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
                Logger.info "Received bot.php answer #{body}"
                ans = Jason.decode!(body)
                LordsWs.Game.ProcessCmd.run(%{game: game, answer: ans, user_id: %{}, params: %{}})
        end
    end
end