package ai.command;

import ai.game.board.BoardCell;

public class UnitMoveCommand extends ActionCommand {
	private BoardCell from;
	private BoardCell to;

	public UnitMoveCommand(BoardCell from, BoardCell to) {
		this.from = from;
		this.to = to;
	}

	@Override
	public BoardCell getFrom() {
		return from;
	}

	@Override
	public BoardCell getTo() {
		return to;
	}

	@Override
	public String toString(int gameId, int playerNum) {
		return "player_move_unit("+gameId+","+playerNum+","+from.x+","+from.y+","+to.x+","+to.y+")";
	}
}
