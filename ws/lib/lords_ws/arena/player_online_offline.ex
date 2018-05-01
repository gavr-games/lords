defmodule LordsWs.Arena.PlayerOnlineOffline do
    require HTTPoison
    require Logger
    
    def run(params) do
        params
        |> change_status
        |> broadcast_status
    end

    def change_status(%{user_id: user_id, flag: flag}) do
        url = "http://web/site/ajax/base_protocol.php"
        params = "{\"action\":\"player_online_offline\",\"params\":{\"user_id\":#{user_id},\"flag\":#{flag}}}"
        case HTTPoison.post(url, params, [{"Content-Type", "application/json"}]) do
            {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
                Logger.info "Received player_online_offline answer #{body}"
                Jason.decode!(body) |> Map.put("user_id", user_id)
        end
    end

    def broadcast_status(%{"header_result" => header_result, "data_result" => data_result, "user_id" => user_id}) do
        # TODO: Check db sends wrong status
        if header_result["success"] == "1" do
            LordsWs.Endpoint.broadcast "arena", "protocol_raw", %{commands: URI.encode("arena_player_set_status(#{user_id},#{data_result["player_status_id"]});")}
        end
    end
end