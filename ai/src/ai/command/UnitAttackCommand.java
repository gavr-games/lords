package ai.command;

import ai.game.board.BoardCell;

public class UnitAttackCommand extends ActionCommand
{
	private BoardCell from;
	private BoardCell to;

	public UnitAttackCommand(BoardCell from, BoardCell to) {
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
		return "attack("+gameId+","+playerNum+","+from.x+","+from.y+","+to.x+","+to.y+")";
	}
}
