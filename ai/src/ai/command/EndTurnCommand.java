package ai.command;

public class EndTurnCommand extends Command {
	@Override
	public String toString(int gameId, int playerNum) {
		return "player_end_turn("+gameId+","+playerNum+")";
	}
}
