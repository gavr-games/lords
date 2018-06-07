defmodule LordsWs.UserChannel do
  use Phoenix.Channel
  require Logger
  alias LordsWs.UserPresence

  def join("user:" <> user_id, _params, socket) do
    Logger.info "User #{socket.assigns.user_id} joined personal user channel user:#{user_id}"
    {:ok, socket}
  end

  def join("arena", _params, socket) do
    Logger.info "User #{socket.assigns.user_id} joined channel arena"
    send(self(), :set_online_offline)
    {:ok, socket}
  end

  def join("game:" <> game_id, _params, socket) do
    Logger.info "User #{socket.assigns.user_id} joined channel game:#{game_id}"
    send(self(), :after_join)
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    {:ok, _} = UserPresence.track(socket, socket.assigns.user_id, %{
      online_at: inspect(System.system_time(:seconds))
    })
    LordsWs.Arena.PlayerOnlineOffline.run(%{user_id: socket.assigns.user_id, flag: 1})
    {:noreply, socket}
  end

  def handle_info(:set_online_offline, socket) do
    LordsWs.Arena.PlayerOnlineOffline.run(%{user_id: socket.assigns.user_id, flag: 1})
    {:noreply, socket}
  end

  def terminate(_, socket) do
    Logger.info "User #{socket.assigns.user_id} left #{socket.topic}"
    if socket.topic == "arena" do
      LordsWs.Arena.PlayerOnlineOffline.run(%{user_id: socket.assigns.user_id, flag: 0})
    end
  end

  def handle_in("logged_protocol_cmd", %{"json_params" => json_params}, socket) do
    url = "http://web/site/ajax/logged_protocol.php?phpsessid=#{socket.assigns.token}"
    params = Jason.decode!(json_params)
    case HTTPoison.post(url, json_params, [{"Content-Type", "application/json"}], [timeout: 15_000, recv_timeout: 15_000]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Logger.info "Received logged_protocol_cmd answer #{body}"
        req = Jason.decode!(body)
        LordsWs.Arena.ProcessCmd.run(%{answer: req, socket: socket, params: params})
    end
    {:noreply, socket}
  end

  def handle_in("game_protocol_cmd", %{"json_params" => json_params}, socket) do
    start = :os.system_time()
    url = "http://web/site/ajax/game_protocol.php?phpsessid=#{socket.assigns.token}"
    params = Jason.decode!(json_params)
    if params["proc_name"] == "multi" do
        url = "http://web/site/ajax/multi_game_protocol.php?phpsessid=#{socket.assigns.token}"
    end
    case HTTPoison.post(url, json_params, [{"Content-Type", "application/json"}]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Logger.info "Received game_protocol_cmd answer #{body}"
        ans = Jason.decode!(body)
        LordsWs.Game.ProcessCmd.run(%{game: socket.assigns.game, answer: ans, user_id: socket.assigns.user_id, params: params |> Map.put("start", start)})
    end
    {:noreply, socket}
  end

  def handle_in("get_game_info", _, socket) do
    url = "http://web-internal/internal/ajax/get_all_game_info.php?game_id=#{socket.assigns.game_id}&player_num=#{socket.assigns.player_num}"
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: game_body}} ->
        game_body = game_body |> Phoenix.HTML.html_escape() |> Phoenix.HTML.safe_to_string()
        push socket, "game_info_raw", %{commands: game_body}
    end
    {:noreply, socket}
  end

  def handle_in("get_game_statistic", _, socket) do
    url = "http://web/site/ajax/get_statistic.php?phpsessid=#{socket.assigns.token}"
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: game_body}} ->
        game_body = game_body |> Phoenix.HTML.html_escape() |> Phoenix.HTML.safe_to_string()
        push socket, "game_statistic_raw", %{commands: game_body}
    end
    {:noreply, socket}
  end

  def handle_in("performance", %{"json_params" => json_params}, socket) do
    url = "http://web/site/ajax/call_save_perfomance.php"
    json_params = json_params
      |> Jason.decode!
      |> Map.put(:game_id, socket.assigns.game_id)
      |> Jason.encode!
    case HTTPoison.post(url, json_params, [{"Content-Type", "application/json"}]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Logger.info "Received call_save_perfomance answer #{body}"
    end
    {:noreply, socket}
  end

  def handle_in("new_msg", %{"msg" => msg}, socket) do
    LordsWs.Endpoint.broadcast "game:#{socket.assigns.game_id}", "game_raw", %{commands: URI.encode("chat_add_user_message(#{socket.assigns.player_num},\"#{URI.decode(msg)}\");")}
    {:noreply, socket}
  end
end
