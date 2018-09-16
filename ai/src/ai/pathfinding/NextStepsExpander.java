package ai.pathfinding;

import ai.game.board.BoardCell;
import ai.game.board.Unit;

import java.util.HashMap;
import java.util.Map;

public class NextStepsExpander {
	Unit myUnit;

	public NextStepsExpander(Unit myUnit) {
		this.myUnit = myUnit;
	}

	public Map<BoardCell, Integer> expand(BoardCell cell) {
		int cx = cell.x;
		int cy = cell.y;
		Map<BoardCell, Integer> nextCells = new HashMap<>();
		if (myUnit.checkFeature("knight")) {
			nextCells.put(new BoardCell(cx - 2, cy - 1), 1);
			nextCells.put(new BoardCell(cx - 2, cy + 1), 1);
			nextCells.put(new BoardCell(cx + 2, cy - 1), 1);
			nextCells.put(new BoardCell(cx + 2, cy + 1), 1);
			nextCells.put(new BoardCell(cx - 1, cy - 2), 1);
			nextCells.put(new BoardCell(cx - 1, cy + 2), 1);
			nextCells.put(new BoardCell(cx + 1, cy - 2), 1);
			nextCells.put(new BoardCell(cx + 1, cy + 2), 1);
		} else {
			int range = 1;
			if (myUnit.checkFeature("flying")) {
				range = myUnit.getMoves();
			}
			for (int x = cx - range; x <= cx + range; x++) {
				for (int y = cy - range; y <= cy + range; y++) {
					BoardCell next = new BoardCell(x, y);
					if (!cell.equals(next)) {
						nextCells.put(next, next.distanceTo(cell));
					}
				}
			}
		}
		return nextCells;
	}
}
