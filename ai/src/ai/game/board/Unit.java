package ai.game.board;

import ai.game.Player;

public class Unit extends BoardObject {
	private int moves;
	private boolean canLevelUp;

	public Unit(int id, Player player, int moves, boolean canLevelUp) {
		super(id, BoardObjectType.UNIT, player);
		this.moves = moves;
		this.canLevelUp = canLevelUp;
	}

	public int getMoves() {
		return moves;
	}

	public boolean canLevelUp() {
		return canLevelUp;
	}

	public void setCanLevelUp(boolean canLevelUp) {
		this.canLevelUp = canLevelUp;
	}

	@Override
	public void setType(BoardObjectType type) {
		throw new RuntimeException("Error: attempting to set type to a Unit");
	}

	public int getSize() {
		return (int) Math.sqrt(getCells().size());
	}
}
