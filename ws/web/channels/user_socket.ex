defmodule LordsWs.UserSocket do
  use Phoenix.Socket
  require Logger
  require HTTPoison

  ## Channels
  channel "chat:*", LordsWs.ChatChannel
  channel "user:*", LordsWs.UserChannel
  channel "arena", LordsWs.UserChannel
  channel "base", LordsWs.BaseChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket
  # transport :longpoll, Phoenix.Transports.LongPoll

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  def connect(params, socket) do
    Logger.info "New socket with token " <> params["token"]
    url = "http://web/site/ajax/get_user_session.php?phpsessid=#{params["token"]}"
    # Get user_id by token
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Logger.info "Received user by token " <> body
        req = Jason.decode!(body)
        case req |> Map.has_key?("user_id") && req["user_id"] != nil do
          true -> 
            Logger.info "Successfully received user info"
            {:ok, socket |> assign(:user_id, req["user_id"]) |> assign(:token, params["token"])}
          _ -> {:ok, socket |> assign(:token, params["token"])}
        end
      {_, _} ->
        {:ok, socket |> assign(:token, params["token"])}
    end
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "users_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     LordsWs.Endpoint.broadcast("users_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(socket), do: "users_socket:#{socket.assigns.user_id}"
end
