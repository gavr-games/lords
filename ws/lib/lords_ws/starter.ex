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
    #accounts = [:a, :b, :c]
    #Enum.each(accounts, fn account ->
    #  LordsWs.NextTurn.Timer.create(account)
    #end)
    url = "http://web/site/ajax/get_games_info.php"
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
            "3" ->
              GenServer.start_link(LordsWs.Game.RemoveTimer, %{game_id: game["game_id"]})
            _ -> nil
          end
        end)
        {:stop, :normal, state}
      _ ->
        {:stop, "failed to get games info", state}       
    end
  end
end