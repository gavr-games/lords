defmodule LordsWs.Bot.Unit do
    require Logger

    def get_cells(object, game_info, static_info) do
        x = String.to_integer(object["x"])
        y = String.to_integer(object["y"])
        board_unit = game_info[:board_units][object["ref"]]
        unit = static_info[:units][board_unit["unit_id"]]
        size = String.to_integer(unit["size"])
        coords = get_coords(x, y, size)
        add_cells([], object, coords)
    end

    def add_cells(cells, object, [o | tail]) do
        {x, y} = o
        object = object |> Map.put("x", x) |> Map.put("y", y)
        add_cells(cells ++ [object], object, tail)
    end

    def add_cells(cells, object, []) do
        cells
    end

    def get_coords(x, y, size) do
        add_coords([], 0, x, y, size)
    end

    def add_coords(coords, i, x, y, size) do
        if i >= size * size do
            coords
        else
            coords = coords ++ [{
                x + rem(i, size),
                y + Integer.floor_div(i, size)
            }]
            i = i + 1
            add_coords(coords, i, x, y, size)
        end
    end

    def possible_move_coords(board_unit, unit, board) do
        add_possible_move_coords([], 0, board_unit, unit, board)
    end

    def add_possible_move_coords(coords, i, board_unit, unit, board) do
        len = 3
        if i >= len * len do
            coords
        else
            size = String.to_integer(unit["size"])
            x = board_unit["x"] - 1 + rem(i, len)
            y = board_unit["y"] - 1 + Integer.floor_div(i, len)
            if (x >= 0) && (x - 1 + size <= 19) && (y >= 0) && (y - 1 + size <= 19) && ((x != board_unit["x"]) || (y != board_unit["y"])) do 
                new_unit_coords = get_coords(x, y, size)
                if Enum.all?(new_unit_coords, fn {x, y} -> board[x][y] == nil || (board[x][y]["type"] == "unit" && board[x][y]["ref"] == board_unit["id"]) end) do
                    coords = coords ++ [{x, y}]
                end
            end
            i = i + 1
            add_possible_move_coords(coords, i, board_unit, unit, board)
        end
    end

    def possible_attack_coords(board_unit, unit, game_info) do
        add_possible_attack_coords([], 0, board_unit, unit, game_info)
    end

    def add_possible_attack_coords(coords, i, board_unit, unit, game_info) do
        len = 3
        if i >= len * len do
            coords
        else
            board = game_info[:board]
            board_units = game_info[:board_units]
            board_buildings = game_info[:board_buildings]
            players = game_info[:players]
            size = String.to_integer(unit["size"])
            x = board_unit["x"] - 1 + rem(i, len)
            y = board_unit["y"] - 1 + Integer.floor_div(i, len)
            if (x >= 0) && (x <= 19) && (y >= 0) && (y <= 19) && ((x != board_unit["x"]) || (y != board_unit["y"])) do 
                if board[x][y] != nil do
                    new_unit_coords = get_coords(x, y, size)
                    if Enum.any?(new_unit_coords, fn {x, y} ->
                        target_p_num = case board[x][y]["type"] do
                            "unit" -> board_units[board[x][y]["ref"]]["player_num"]
                            _ -> board_buildings[board[x][y]["ref"]]["player_num"]
                        end
                        my_team = players[board_unit["player_num"]]["team"]
                        target_team = players[target_p_num]["team"]
                        my_team != target_team
                    end) do
                        coords = coords ++ [{x, y}]
                    end
                end
            end
            i = i + 1
            add_possible_attack_coords(coords, i, board_unit, unit, game_info)
        end
    end
end