defmodule LordsWs.Bot.StaticInfo do
    # Resulting map with static info should look like this:
    # %{
    #   mode_config: %{param: value}
    # }
    def process(static_info) do
        static_info 
        |> mode_config
    end

    def mode_config(static_info) do
        {mode_config, static_info} = Map.pop(static_info, "mode_config")
        static_info |> Map.put(:mode_config, Enum.into(mode_config, %{}, fn (%{"param"=>param, "value"=>value}) -> {param, value} end))
    end
end