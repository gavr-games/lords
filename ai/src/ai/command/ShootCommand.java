package ai.command;

import ai.game.board.BoardCell;

public class ShootCommand extends ActionCommand {

	private BoardCell unitCell;
	private BoardCell aim;

	public ShootCommand(BoardCell unitCell, BoardCell aim) {
		this.unitCell = unitCell;
		this.aim = aim;
	}

	@Override
	public BoardCell getFrom() {
		return unitCell;
	}

	@Override
	public BoardCell getTo() {
		return aim;
	}

	@Override
	public String toString(int gameId, int playerNum) {
		return "unit_shoot("+gameId+","+playerNum+","+unitCell.x+","+unitCell.y+","+aim.x+","+aim.y+")";
	}
}
