defmodule LordsWs.SendPhrase.Timer do
  use GenServer
  require Logger

  def create(state) do
    case GenServer.whereis(ref(state["game_id"])) do
      nil ->
        Supervisor.start_child(LordsWs.SendPhrase.Supervisor, [state])
      _game ->
        {:error, :game_already_exists}
    end
  end

  def start_link(state) do
    GenServer.start_link __MODULE__, state, name: ref(state["game_id"])
  end

  defp ref(game_id) do
    {:global, {:send_phrase, game_id}}
  end

  def init(state) do
    Logger.info "Init send phrase timer for game #{state["game_id"]}"
    LordsWs.Endpoint.subscribe "send_phrase_timer:#{state["game_id"]}", []
    ref = schedule_timer
    {:ok, %{game: state, timer_ref: ref}}
  end

  def handle_info(:send_phrase, %{game: game}) do
    Logger.info "Send phrase for game #{game["game_id"]}"
    url = "http://web/game/mode#{game["mode_id"]}/ajax/get_unit_phrase.php?game_id=#{game["game_id"]}"
    ref = nil
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: phrase_body}} ->
        Logger.info "Received get_unit_phrase answer #{phrase_body}"
        if phrase_body != "null" do
          phrase = Jason.decode!(phrase_body)
          broadcast game["game_id"], "show_unit_message(#{phrase["board_unit_id"]},#{phrase["phrase_id"]});"
        end
        ref = schedule_timer()
      _ ->
        ref = schedule_timer()
    end
    {:noreply, %{game: game, timer_ref: ref}}
  end

  def handle_info(%{event: "cancel"}, %{timer_ref: ref}) do
    Logger.info "Cancel send phrase timer"
    cancel_timer(ref)
    {:noreply, %{}}
  end
  
  defp schedule_timer() do
    interval = 120_000 + 1_000 * :rand.uniform(120)
    Process.send_after self(), :send_phrase, interval
  end

  defp cancel_timer(nil), do: :ok
  defp cancel_timer(ref), do: Process.cancel_timer(ref)

  defp broadcast(game_id, cmds) do
    LordsWs.Endpoint.broadcast "game:#{game_id}", "game_raw", %{commands: URI.encode(cmds)}
  end
end