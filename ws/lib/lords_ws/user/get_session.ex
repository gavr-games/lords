defmodule LordsWs.User.GetSession do
    require HTTPoison
    
    def run(params) do
        params
        |> get_user_session
        |> get_user_game
    end

    def get_user_session(%{"token" => token}) do
        url = "http://web/site/ajax/get_user_session.php?phpsessid=#{token}"
        case HTTPoison.get(url) do
            {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
                Jason.decode!(body)
            _ ->
                Map.new()
        end
    end

    def get_user_game(params) do
        case Map.has_key?(params, "game_id") do
            true ->
                url = "http://web/site/ajax/get_game_info.php?game_id=#{params["game_id"]}"
                case HTTPoison.get(url) do
                    {:ok, %HTTPoison.Response{status_code: 200, body: game_body}} ->
                        game = Jason.decode!(game_body)
                        params |> Map.put("game", game)
                    _ ->
                        params
                end
            _ ->
                params
        end
    end
end