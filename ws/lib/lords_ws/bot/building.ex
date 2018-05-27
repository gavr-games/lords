defmodule LordsWs.Bot.Building do
    def get_cells(object, game_info, static_info) do
        x = String.to_integer(object["x"])
        y = String.to_integer(object["y"])
        board_building = game_info[:board_buildings][object["ref"]]
        rotation = String.to_integer(board_building["rotation"])
        flip = String.to_integer(board_building["flip"])
        building = static_info[:buildings][board_building["building_id"]]
        coords = get_coords(x, y, rotation, flip, building)
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

    def get_coords(x, y, rotation, flip, b) do
        add_coords([], 0, x, y, rotation, flip, b)
    end

    def add_coords(coords, i, x, y, rotation, flip, b) do
        mflip = case flip do
            0 -> 1
            _ -> -1
        end
        x_len = String.to_integer(b["x_len"])
        y_len = String.to_integer(b["y_len"])

        if i >= x_len * y_len do
            coords
        else
            case rotation do
                0 ->
                    x_0 = case mflip do
                        1 -> x
                        _ -> x + x_len - 1
                    end
                    y_0 = y
                    if String.slice(b["shape"], i, 1) == "1" do
                        coords = coords ++ [{
                            x_0 + mflip * rem(i, x_len),
                            y_0 + Integer.floor_div(i, x_len)
                        }]
                    end
                1 ->
                    x_0 = case mflip do
                        1 -> x + y_len - 1
                        _ -> x
                    end
                    y_0 = y
                    if String.slice(b["shape"], i, 1) == "1" do
                        coords = coords ++ [{
                            x_0 - Integer.floor_div(i, x_len),
                            y_0 + rem(i, x_len)
                        }]
                    end
                2 ->
                    x_0 = case mflip do
                        1 -> x + y_len - 1
                        _ -> x
                    end
                    y_0 = y + y_len - 1
                    if String.slice(b["shape"], i, 1) == "1" do
                        coords = coords ++ [{
                            x_0 - mflip * rem(i, x_len),
                            y_0 - Integer.floor_div(i, x_len)
                        }]
                    end
                3 ->
                    x_0 = case mflip do
                        1 -> x
                        _ -> x + y_len
                    end
                    y_0 = y + x_len - 1
                    if String.slice(b["shape"], i, 1) == "1" do
                        coords = coords ++ [{
                            x_0 + mflip * Integer.floor_div(i, x_len),
                            y_0 - rem(i, x_len)
                        }]
                    end
            end
            i = i + 1
            add_coords(coords, i, x, y, rotation, flip, b)
        end
    end
end