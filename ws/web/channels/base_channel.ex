defmodule LordsWs.BaseChannel do
  use Phoenix.Channel
  require Logger

  def join("base", _params, socket) do
    Logger.info "User joined base channel"
    {:ok, socket}
  end

  def handle_in("base_protocol_cmd", %{"json_params" => json_params}, socket) do
    url = "http://api/site/ajax/base_protocol.php?phpsessid=#{socket.assigns.token}"
    case HTTPoison.post(url, json_params, [{"Content-Type", "application/json"}]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Logger.info "Received base_protocol_cmd answer " <> body
        params = Jason.decode!(json_params)
        answer = Jason.decode!(body)
        answer = Map.put(answer, :action, params["action"])
        push socket, "protocol_raw", answer
    end
    {:noreply, socket}
  end
end