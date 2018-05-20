defmodule LordsWs.Bot.Ai do
  use GenServer
  require Logger

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
    static_info = nil
    url = "http://web-internal/internal/ajax/get_static_info.php?game_id=#{state["game_id"]}"
    case HTTPoison.get(url, [], [timeout: 20_000, recv_timeout: 20_000]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Logger.info "Answer from get_static_info.php"
        static_info = Jason.decode!(body)
    end
    {:ok, %{game: state, static_info: static_info}}
  end

  def handle_info(%{event: "move"}, %{game: game, static_info: static_info}) do
    Logger.info "Move bot #{game["game_id"]}"
    game_info = nil
    url = "http://web-internal/internal/ajax/get_all_game_info.php?game_id=#{game["game_id"]}&player_num=#{game["player_num"]}&format=json"
    case HTTPoison.get(url, [], [timeout: 20_000, recv_timeout: 20_000]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Logger.info "Answer from get_all_game_info.php"
        game_info = Jason.decode!(body)
    end
    #TODO: make move
    {:noreply, %{game: game, static_info: static_info}}
  end

  defp broadcast(game_id, cmds) do
    LordsWs.Endpoint.broadcast "game:#{game_id}", "game_raw", %{commands: URI.encode(cmds)}
  end
end