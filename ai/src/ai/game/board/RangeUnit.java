package ai.game.board;

import ai.game.Player;

import java.util.ArrayList;
import java.util.List;

public class RangeUnit extends Unit{
	private int minRange;
	private int maxRange;
	private List<BoardObjectType> targetTypes;

	public RangeUnit(int id, Player player, int moves, boolean canLevelUp, int minRange, int maxRange, List<BoardObjectType> targetTypes) {
		super(id, player, moves, canLevelUp);
		this.minRange = minRange;
		this.maxRange = maxRange;
		this.targetTypes = targetTypes;
	}

	public boolean canShootAt(BoardObject target) {
		return targetTypes.contains(target.getType());
	}

	public List<BoardObjectType> getTargetTypes() {
		return targetTypes;
	}

	public void setTargetTypes(List<BoardObjectType> targetTypes) {
		this.targetTypes = targetTypes;
	}
}
