defmodule LordsWs.UserSocket do
  use Phoenix.Socket
  require Logger

  channel "chat:*", LordsWs.ChatChannel
  channel "user:*", LordsWs.UserChannel
  channel "game:*", LordsWs.UserChannel
  channel "arena", LordsWs.UserChannel
  channel "base", LordsWs.BaseChannel
  channel "end_turn_timer:*", LordsWs.EndTurnTimerChannel
  channel "send_phrase_timer:*", LordsWs.SendPhraseTimerChannel
  channel "bot:*", LordsWs.BotChannel

  transport :websocket, Phoenix.Transports.WebSocket

  def connect(params = %{"token" => token}, socket) do
    Logger.info "New socket with token " <> token
    session = LordsWs.User.GetSession.run(params)
    socket = socket 
      |> assign(:token, params["token"])
      |> conditional_assign(session, "user_id")
      |> conditional_assign(session, "game_id")
      |> conditional_assign(session, "player_num")
      |> conditional_assign(session, "game")
    {:ok, socket}
  end

  def connect(%{}, socket) do
    Logger.info "New system socket"
    {:ok, socket}
  end

  def conditional_assign(socket, session, key) do
    if Map.has_key?(session, key) && session[key] != nil do
      assign(socket, String.to_atom(key), session[key])
    else
      socket
    end
  end

  def socket_id(socket) do
    if Map.has_key?(socket.assigns, :user_id) do
      "users_socket:#{socket.assigns.user_id}"
    else
      nil
    end
  end

  def id(socket), do: socket_id(socket)
end
