defmodule LordsWs.Bot.GameInfo do
    require Logger
    alias LordsWs.Bot.Building
    alias LordsWs.Bot.Unit
    # Resulting map with game info should look like this:
    # %{
    #   active_player: %{},
    #   players: %{p_num: player},
    #   board_buildings: %{id: building},
    #   my_buildings: %{id: building},
    #   my_castle: %{},
    #   board_units: %{id: unit},
    #   my_units: %{id: unit},
    #   board: ${}
    # }
    def process(game, game_info, static_info) do
        game_info 
        |> active_player
        |> players
        |> board_buildings(game, static_info)
        |> board_units(game, static_info)
        |> board(static_info)
    end

    def active_player(game_info) do
        {active_players, game_info} = Map.pop(game_info, "active_players")
        game_info |> Map.put(:active_player, List.first(active_players))
    end

    def players(game_info) do
        {players, game_info} = Map.pop(game_info, "players")
        game_info |> Map.put(:players, Enum.into(players, %{}, fn (player = %{"player_num"=>p_num}) -> {p_num, player} end))
    end

    def board_buildings(game_info, game, static_info) do
        {board_buildings, game_info} = Map.pop(game_info, "board_buildings")
        board_buildings = Enum.into(board_buildings, %{}, fn (b = %{"id"=>id}) -> {id, b} end)
        my_buildings = Enum.filter(board_buildings, fn {_, b} -> b["player_num"] == game["player_num"] end)
        {_, my_castle} = Enum.find(my_buildings, fn {_, b} -> static_info[:buildings][b["building_id"]]["type"] == "castle" end)
        game_info 
        |> Map.put(:board_buildings, board_buildings)
        |> Map.put(:my_buildings, my_buildings)
        |> Map.put(:my_castle, my_castle)
    end

    def board_units(game_info, game, static_info) do
        {board_units, game_info} = Map.pop(game_info, "board_units")
        board_units = board_units
        |> Enum.into(%{}, fn (u = %{"id"=>id}) -> {id, u} end)
        |> add_coords_to_board_units(game_info["init_board_units"])
        my_units = Enum.filter(board_units, fn {_, u} -> u["player_num"] == game["player_num"] end)
        game_info 
        |> Map.put(:board_units, board_units)
        |> Map.put(:my_units, my_units)
    end

    def add_coords_to_board_units(board_units, [init_board_unit | tail]) do
        board_units = put_in(board_units[init_board_unit["ref"]]["x"], String.to_integer(init_board_unit["x"]))
        board_units = put_in(board_units[init_board_unit["ref"]]["y"], String.to_integer(init_board_unit["y"]))
        add_coords_to_board_units(board_units, tail)
    end

    def add_coords_to_board_units(board_units, []) do
        board_units
    end

    def board(game_info, static_info) do
        {init_board_buildings, game_info} = Map.pop(game_info, "init_board_buildings")
        {init_board_units, game_info} = Map.pop(game_info, "init_board_units")
        # Init board
        board = Enum.into(0..19, %{}, fn (x) -> {x, Enum.into(0..19, %{}, fn (y) -> {y, nil} end)} end)
        cells = []
        |> get_objects_cells(init_board_buildings, game_info, static_info)
        |> get_objects_cells(init_board_units, game_info, static_info)
        board = set_board_cells(board, cells)
        game_info |> Map.put(:board, board)
    end

    def get_objects_cells(cells, [o | tail], game_info, static_info) do
        cells = cells ++ case o["type"] do
           "unit" -> Unit.get_cells(o, game_info, static_info)
            _ -> Building.get_cells(o, game_info, static_info)
        end
        get_objects_cells(cells, tail, game_info, static_info)
    end

    def get_objects_cells(cells, [], game_info, static_info) do
        cells
    end

    def set_board_cells(board, [o | tail]) do
        board = put_in board[o["x"]][o["y"]], o
        set_board_cells(board, tail)
    end

    def set_board_cells(board, []) do
        board
    end
end