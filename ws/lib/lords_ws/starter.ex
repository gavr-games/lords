defmodule LordsWs.Starter do
  use GenServer
  require Logger
  
  def start_link do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    send(self(), :start_children)
    {:ok, nil}
  end

  def handle_info(:start_children, state) do
    url = "http://web-internal/internal/ajax/get_games_info.php"
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: games_body}} ->
        Logger.info "Received get_games_info answer #{games_body}"
        games = Jason.decode!(games_body)
        Enum.each(games, fn game ->
          case game["status_id"] do
            "2" ->
              LordsWs.SendPhrase.Timer.create(game)
              if game["time_restriction"] != "0" do
                Logger.info "---> Starting next turn timer"
                LordsWs.NextTurn.Timer.create(game)
              end
              if String.to_integer(game["active_player_num"]) >= 4 do
                GenServer.start_link(LordsWs.Npc.Worker, %{game: game, p_num: game["active_player_num"]})
              end
            "3" ->
              GenServer.start_link(LordsWs.Game.RemoveTimer, game)
            _ -> nil
          end
        end)
        {:ok, :normal, state}
      _ ->
        {:stop, "failed to get games info", state}       
    end
    # Init bots
    url = "http://web-internal/internal/ajax/get_bots_info.php"
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: bots_body}} ->
        Logger.info "Received get_bots_info answer #{bots_body}"
        bots = Jason.decode!(bots_body)
        Enum.each(bots, fn bot ->
          case bot["player_num"] do
            nil -> nil
            _ -> LordsWs.Bot.Ai.create(bot)
          end
        end)
        {:stop, :normal, state}
      _ ->
        {:stop, "failed to get bots info", state}       
    end
  end
end