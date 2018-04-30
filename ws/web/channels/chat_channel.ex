defmodule LordsWs.ChatChannel do
  use Phoenix.Channel
  require Logger

  def join("chat:" <> chat_id, _params, socket) do
    Logger.info "User " <> socket.assigns.user_id <> " joined chat " <> chat_id
    {:ok, socket}
  end

  def handle_in("new_msg", %{"msg" => msg}, socket) do
    Logger.info "Socket ID " <> socket.id
    broadcast! socket, "new_msg", %{msg: msg, from_user_id: socket.assigns.user_id, time: :os.system_time(:seconds)}
    {:noreply, socket}
  end
end