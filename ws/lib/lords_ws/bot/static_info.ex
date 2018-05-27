defmodule LordsWs.Bot.StaticInfo do
    # Resulting map with static info should look like this:
    # %{
    #   mode_config: %{param: value},
    #   buildings: %{id: building},
    #   units: %{id: unit},
    # }
    def process(static_info) do
        static_info 
        |> mode_config
        |> buildings
        |> units
    end

    def mode_config(static_info) do
        {mode_config, static_info} = Map.pop(static_info, "mode_config")
        static_info |> Map.put(:mode_config, Enum.into(mode_config, %{}, fn (%{"param"=>param, "value"=>value}) -> {param, value} end))
    end

    def buildings(static_info) do
        {buildings, static_info} = Map.pop(static_info, "vw_mode_buildings")
        static_info |> Map.put(:buildings, Enum.into(buildings, %{}, fn (b = %{"id"=>id}) -> {id, b} end))
    end

    def units(static_info) do
        {units, static_info} = Map.pop(static_info, "vw_mode_units")
        static_info |> Map.put(:units, Enum.into(units, %{}, fn (u = %{"id"=>id}) -> {id, u} end))
    end
end