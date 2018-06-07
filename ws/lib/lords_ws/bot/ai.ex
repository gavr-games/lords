defmodule LordsWs.Bot.Ai do
  use GenServer
  require Logger
  alias LordsWs.Bot.RandomAi

  def create(state) do
    case GenServer.whereis(ref(state)) do
      nil ->
        Supervisor.start_child(LordsWs.Bot.Supervisor, [state])
      _game ->
        {:error, "bot ai already exists"}
    end
  end

  def create_for_game(game) do
    url = "http://web-internal/internal/ajax/get_bots_info.php?game_id=#{game["game_id"]}"
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: bots_body}} ->
        Logger.info "Received get_bots_info answer #{bots_body}"
        bots = Jason.decode!(bots_body)
        Enum.each(bots, fn bot ->
          case bot["player_num"] do
            nil -> nil
            _ -> create(bot)
          end
        end)
        {:ok}
      _ ->
        {:error, "failed to get bots info"}       
    end
  end

  def stop_for_game(game) do
    Logger.info "Stop bots for game #{game["game_id"]}"
    url = "http://web-internal/internal/ajax/get_bots_info.php?game_id=#{game["game_id"]}"
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: bots_body}} ->
        Logger.info "Received get_bots_info answer #{bots_body}"
        bots = Jason.decode!(bots_body)
        Enum.each(bots, fn bot ->
          case bot["player_num"] do
            nil -> nil
            _ -> LordsWs.Endpoint.broadcast "bot:#{game["game_id"]}_#{bot["player_num"]}", "stop", %{}
          end
        end)
        {:ok}
      _ ->
        {:error, "failed to get bots info"}       
    end
  end

  def start_link(state) do
    GenServer.start_link __MODULE__, state, name: ref(state)
  end

  defp ref(game) do
    {:global, {:bot, game["game_id"], game["player_num"]}}
  end

  def init(state) do
    Logger.info "Init bot for #{state["game_id"]}_#{state["player_num"]}"
    send self(), :post_init
    {:ok, state}
  end

  def handle_info(:post_init, state) do
    # Current game info
    url = "http://web-internal/internal/ajax/get_game_info.php?game_id=#{state["game_id"]}"
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: game_body}} ->
        Logger.info "Answer from get_game_info #{game_body}"
        game_info = Jason.decode!(game_body)
        if game_info == nil, do: game_info = %{"status_id"=>"3"}
        state = Map.merge(state, game_info)
    end
    if state["status_id"] != "2" do
      send self(), :stop
      {:noreply, state}
    else
      Logger.info "Bot subscribe bot:#{state["game_id"]}_#{state["player_num"]}"
      LordsWs.Endpoint.subscribe "bot:#{state["game_id"]}_#{state["player_num"]}", []
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
        Logger.info "Move bot on init"
        send self(), :move
      end
      {:noreply, state}
    end
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

  def handle_info(:stop, game) do
    Logger.info "Stop bot #{game["game_id"]}"
    {:stop, :normal, game}
  end

  def ai_move(state) do
    RandomAi.move(state)
  end

  defp broadcast(game_id, cmds) do
    LordsWs.Endpoint.broadcast "game:#{game_id}", "game_raw", %{commands: URI.encode(cmds)}
  end
end