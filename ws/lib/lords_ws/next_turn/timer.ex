defmodule LordsWs.NextTurn.Timer do
  use GenServer
  require Logger

  def create(state) do
    case GenServer.whereis(ref(state["game_id"])) do
      nil ->
        Supervisor.start_child(LordsWs.NextTurn.Supervisor, [state])
      _game ->
        GenServer.cast GenServer.whereis(ref(state["game_id"])), {:restart, state}
    end
  end

  def start_link(state) do
    GenServer.start_link __MODULE__, state, name: ref(state["game_id"])
  end

  defp ref(game_id) do
    {:global, {:next_turn, game_id}}
  end

  def init(state) do
    Logger.info "Init end turn timer for #{state["game_id"]}"
    LordsWs.Endpoint.subscribe "end_turn_timer:#{state["game_id"]}", []
    broadcast state["game_id"], "update_next_turn_timer(#{state["time_restriction"]});"
    timer_ref = schedule_timer 1_000
    {:ok, %{game: state, timer: String.to_integer(state["time_restriction"]), timer_ref: timer_ref}}
  end

  def handle_info(:update, %{game: game, timer: time}) do
    leftover = time - 1
    case leftover do
      0 ->
        Logger.info "End turn by timeout for game #{game["game_id"]} with p_num #{game["active_player_num"]}"
        broadcast game["game_id"], "update_next_turn_timer(0);"
        url = "http://web/site/ajax/end_turn_timeout.php?game_id=#{game["game_id"]}&player_num=#{game["active_player_num"]}"
        case HTTPoison.get(url) do
          {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
            Logger.info "Answer from end_turn_timeout #{body}"
            ans = Jason.decode!(body)
            LordsWs.Game.ProcessCmd.run(%{game: game, answer: ans, user_id: nil, params: %{}})
            # TODO: send error if request failed
        end
        {:noreply, %{game: game, timer: String.to_integer(game["time_restriction"]), timer_ref: nil}}
      _ ->
        broadcast game["game_id"], "update_next_turn_timer(#{leftover});"
        timer_ref = schedule_timer 1_000
        {:noreply, %{game: game, timer: leftover, timer_ref: timer_ref}}
    end
  end

  def handle_info(%{event: "cancel"}, %{game: game, timer_ref: ref}) do
    Logger.info "Cancel end turn timer"
    cancel_timer(ref)
    {:noreply, %{game: game, timer_ref: nil, timer: String.to_integer(game["time_restriction"])}}
  end

  def handle_cast({:restart, game}, _state) do
    Logger.info "Handle restart #{game["game_id"]}"
    broadcast game["game_id"], "update_next_turn_timer(#{game["time_restriction"]});"
    timer_ref = schedule_timer 1_000
    {:noreply, %{game: game, timer: String.to_integer(game["time_restriction"]), timer_ref: timer_ref}}
  end

  defp cancel_timer(nil), do: :ok
  defp cancel_timer(ref), do: Process.cancel_timer(ref)

  defp schedule_timer(interval) do
    Process.send_after self(), :update, interval
  end

  defp broadcast(game_id, cmds) do
    LordsWs.Endpoint.broadcast "game:#{game_id}", "game_raw", %{commands: URI.encode(cmds)}
  end
end