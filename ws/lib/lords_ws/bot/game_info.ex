defmodule LordsWs.Bot.GameInfo do
    # Resulting map with game info should look like this:
    # %{
    #   active_player: %{},
    #   players: %{p_num: player}
    # }
    def process(game_info) do
        game_info 
        |> active_player
        |> players
    end

    def active_player(game_info) do
        {active_players, game_info} = Map.pop(game_info, "active_players")
        game_info |> Map.put(:active_player, List.first(active_players))
    end

    def players(game_info) do
        {players, game_info} = Map.pop(game_info, "players")
        game_info |> Map.put(:players, Enum.into(players, %{}, fn (player = %{"player_num"=>p_num}) -> {p_num, player} end))
    end
end