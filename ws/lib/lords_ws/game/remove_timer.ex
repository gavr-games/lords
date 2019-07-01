defmodule LordsWs.Game.RemoveTimer do
  use GenServer
  require Logger

  def create(state) do
    case GenServer.whereis(ref(state["game_id"])) do
      nil ->
        Supervisor.start_child(LordsWs.Game.RemoveSupervisor, [state])
      _game ->
        {:error, :remove_game_already_exists}
    end
  end

  def start_link(state) do
    GenServer.start_link __MODULE__, state, name: ref(state["game_id"])
  end

  defp ref(game_id) do
    {:global, {:remove_game, game_id}}
  end

  def init(state) do
    Logger.info "Init remove timer for game #{state["game_id"]}"
    LordsWs.Endpoint.broadcast "end_turn_timer:#{state["game_id"]}", "cancel", %{}
    LordsWs.Endpoint.broadcast "send_phrase_timer:#{state["game_id"]}", "cancel", %{}
    schedule_timer
    {:ok, state}
  end

  def handle_info(:remove, state) do
    Logger.info "Removing game #{state["game_id"]}"
    url = "http://api/internal/ajax/delete_game.php?game_id=#{state["game_id"]}"
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Logger.info "Received delete_game answer #{body}"
        LordsWs.Endpoint.broadcast "arena", "protocol_raw", %{commands: URI.encode("arena_game_delete(#{state["game_id"]});")}
    end
    {:noreply, state}
  end

  defp schedule_timer() do
    Process.send_after self(), :remove, 900_000
  end
end