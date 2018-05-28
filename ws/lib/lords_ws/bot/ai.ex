defmodule LordsWs.Bot.Ai do
  use GenServer
  require Logger
  alias LordsWs.Bot.RandomAi

  def create(state) do
    case GenServer.whereis(ref(state["game_id"])) do
      nil ->
        Supervisor.start_child(LordsWs.NextTurn.Supervisor, [state])
      _game ->
        {:error, "bot ai already exists"}
    end
  end

  def start_link(state) do
    GenServer.start_link __MODULE__, state, name: ref(state["game_id"])
  end

  defp ref(game_id) do
    {:global, {:bot, game_id}}
  end

  def init(state) do
    Logger.info "Init bot for #{state["game_id"]}"
    LordsWs.Endpoint.subscribe "bot:#{state["game_id"]}_#{state["player_num"]}", []
    # Current game info
    url = "http://web-internal/internal/ajax/get_game_info.php?game_id=#{state["game_id"]}"
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: game_body}} ->
        Logger.info "Answer from get_game_info #{game_body}"
        state = Map.merge(state, Jason.decode!(game_body))
    end
    # Static info
    static_info = nil
    url = "http://web-internal/internal/ajax/get_static_info.php?mode_id=#{state["mode_id"]}"
    case HTTPoison.get(url, [], [timeout: 20_000, recv_timeout: 20_000]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Logger.info "Answer from get_static_info.php"
        static_info = Jason.decode!(body)
    end
    # Move bot if it's his turn
    state = %{game: state, static_info: static_info}
    if state[:game]["active_player_num"] == state[:game]["player_num"] do
      send self(), :move
    end
    {:ok, state}
  end

  def handle_info(%{event: "move"}, state = %{game: game, static_info: static_info}) do
    Logger.info "Move bot #{game["game_id"]}"
    ai_move(state)
    {:noreply, state}
  end

  def handle_info(:move, state = %{game: game, static_info: static_info}) do
    Logger.info "Move bot #{game["game_id"]}"
    ai_move(state)
    {:noreply, state}
  end

  def handle_info(%{event: "stop"}, state = %{game: game}) do
    Logger.info "Stop bot #{game["game_id"]}"
    {:stop, :normal, state}
  end

  def ai_move(state) do
    RandomAi.move(state)
  end

  defp broadcast(game_id, cmds) do
    LordsWs.Endpoint.broadcast "game:#{game_id}", "game_raw", %{commands: URI.encode(cmds)}
  end
end