defmodule LordsWs.Bot.Commands do
    alias LordsWs.Bot.GameInfo
    alias LordsWs.Bot.StaticInfo
    alias LordsWs.Bot.Unit
    require Logger

    def possible_cmds(game, game_info, static_info) do
        si = StaticInfo.process(static_info)
        gi = GameInfo.process(game, game_info, si)
        game_data = %{
            game_info: gi,
            static_info: si,
            game: game,
            commands: []
        }

        if game_data[:game_info][:active_player]["player_num"] == game["player_num"] do
            game_data = game_data
            |> end_turn_cmd
            |> agree_draw_cmd
            |> buy_card_cmd
            |> take_subsidy_cmd
            |> move_units_cmds
            |> units_attack_cmds
        end

        {:ok, game_data[:commands]}
    end

    def end_turn_cmd(game_data = %{game: game, commands: commands}) do
        commands = commands ++ ["player_end_turn(#{game["game_id"]},#{game["player_num"]});"]
        game_data |> Map.put(:commands, commands)
    end

    def agree_draw_cmd(game_data = %{game_info: game_info, static_info: static_info, game: game, commands: commands}) do
        if game_info[:players][game["player_num"]]["agree_draw"] == "0" do
            commands = commands ++ ["agree_draw(#{game["game_id"]},#{game["player_num"]});"]
        end
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

    def take_subsidy_cmd(game_data = %{game_info: game_info, static_info: static_info, game: game, commands: commands}) do
        subsidy_taken = game_info[:active_player]["subsidy_flag"]
        castle_health = String.to_integer(game_info[:my_castle]["health"])
        required_health = String.to_integer(static_info[:mode_config]["subsidy castle damage"])
        if subsidy_taken == "0" && castle_health > required_health do
            commands = commands ++ ["take_subsidy(#{game["game_id"]},#{game["player_num"]});"]
        end
        game_data |> Map.put(:commands, commands)
    end

    def move_units_cmds(game_data = %{game_info: game_info, static_info: static_info, game: game, commands: commands}) do
        commands = commands ++ List.flatten(Enum.map(game_info[:my_units], fn {_, u} -> move_unit_cmds(u, static_info[:units][u["unit_id"]], game_info[:board], game) end))
        game_data |> Map.put(:commands, commands)
    end

    def move_unit_cmds(board_unit, unit, board, game) do
        coords = Unit.possible_move_coords(board_unit, unit, board)
        Enum.map(coords, fn {x, y} -> "player_move_unit(#{game["game_id"]},#{game["player_num"]},#{board_unit["x"]},#{board_unit["y"]},#{x},#{y});" end)
    end

    def units_attack_cmds(game_data = %{game_info: game_info, static_info: static_info, game: game, commands: commands}) do
        commands = commands ++ List.flatten(Enum.map(game_info[:my_units], fn {_, u} -> unit_attack_cmds(u, static_info[:units][u["unit_id"]], game_info, game) end))
        game_data |> Map.put(:commands, commands)
    end

    def unit_attack_cmds(board_unit, unit, game_info, game) do
        coords = Unit.possible_attack_coords(board_unit, unit, game_info)
        Enum.map(coords, fn {x, y} -> "attack(#{game["game_id"]},#{game["player_num"]},#{board_unit["x"]},#{board_unit["y"]},#{x},#{y});" end)
    end

    def exec_cmd(game, cmd) do
        Logger.info("Executing bot cmd for game #{game["game_id"]} cmd: #{cmd}")
        url = "http://web-internal/internal/ajax/bot.php"
        case HTTPoison.post(url, Jason.encode!(%{cmd: cmd}), [{"Content-Type", "application/json"}]) do
            {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
                Logger.info "Received bot.php answer #{body}"
                ans = Jason.decode!(body)
                LordsWs.Game.ProcessCmd.run(%{game: game, answer: ans, user_id: %{}, params: %{}})
        end
    end
end