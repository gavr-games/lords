defmodule LordsWs.BaseChannel do
  use Phoenix.Channel
  require Logger

  def join("base", _params, socket) do
    Logger.info "User joined base channel"
    {:ok, socket}
  end

  def handle_in("base_protocol_cmd", %{"json_params" => json_params}, socket) do
    url = "http://web/site/ajax/base_protocol.php?phpsessid=#{socket.assigns.token}"
    eval_cmds = ""
    params = Jason.decode!(json_params)
    case HTTPoison.post(url, json_params, [{"Content-Type", "application/json"}]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Logger.info "Received base_protocol_cmd answer " <> body
        req = Jason.decode!(body)
        case params["action"] do
          "user_authorize" -> eval_cmds = eval_cmds <> URI.encode("loginAnswer(" <> body <> ")");
          "guest_user_authorize" -> eval_cmds = eval_cmds <> URI.encode("loginAnswer(" <> body <> ")");
          "user_add" -> eval_cmds = eval_cmds <> URI.encode("regAnswer(" <> body <> ")");
        end
    end
    if eval_cmds != "" do
        push socket, "protocol_raw", %{commands: eval_cmds}
    end
    {:noreply, socket}
  end
end