package ai.command;

import ai.game.board.BoardCell;

public class LevelUpCommand extends Command {
	private BoardCell unitCell;
	private String attribute;

	public LevelUpCommand(BoardCell unitCell, String attribute) {
		this.unitCell = unitCell;
		this.attribute = attribute;
	}

	@Override
	public String toString(int gameId, int playerNum) {
		return "unit_level_up_"+this.attribute+"("+gameId+","+playerNum+","+unitCell.x+","+unitCell.y+")";
	}
}
