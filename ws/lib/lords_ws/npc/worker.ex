defmodule LordsWs.Npc.Worker do
  use GenServer
  require Logger

  def start_link(state) do
    GenServer.start_link __MODULE__, state, name: ref(state[:game]["game_id"])
  end

  defp ref(game_id) do
    {:global, {:npc, game_id}}
  end

  def init(state) do
    Logger.info "Init npc for game #{state[:game]["game_id"]}"
    Process.send_after self(), :move, 1
    {:ok, state}
  end

  def handle_info(:move, state = %{game: game, p_num: p_num}) do
    Logger.info "Call NPC for game #{game["game_id"]} with p_num #{p_num}"
    url = "http://api/internal/ajax/npc.php?game_id=#{game["game_id"]}&player_num=#{p_num}"
    case HTTPoison.get(url, [], [timeout: 20_000, recv_timeout: 20_000]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Logger.info "Answer from npc.php #{body}"
        ans = Jason.decode!(body)
        LordsWs.Game.ProcessCmd.run(%{game: game, answer: ans, user_id: nil, params: %{}})
    end
    {:noreply, state}
  end
end