package ai.pathfinding;

import ai.game.board.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class PositionChecker {
	private Board board;
	private Unit myUnit;
	private boolean[][] obstacles;
	private List<BoardObject> targets;

	/**
	 * targets[x][y] - null if I cannot attack any target x,y. Keys of map - target objects I can attack;
	 * value (only for range units) - coordinate of a target into which I can shoot from x,y
	 */
	private Map<BoardObject, BoardCell>[][] targetAttacks;

	public PositionChecker(Board board, Unit myUnit, List<BoardObject> targets) {
		this.board = board;
		this.myUnit = myUnit;
		this.targets = targets;

		obstacles = new boolean[board.getSizeX()][board.getSizeY()];
		for (BoardObject object : board.getObjects()) {
			if (object != myUnit) {
				for (BoardCell cell : object.getCells()) {
					obstacles[cell.x][cell.y] = true;
				}
			}
		}
		initTargets();
	}

	private void initTargets() {
		targetAttacks = new Map[board.getSizeX()][board.getSizeY()];

		if (myUnit instanceof RangeUnit) {
			RangeUnit myRangeUnit = (RangeUnit) myUnit;
			int minRange = myRangeUnit.getMinRange();
			int maxRange = myRangeUnit.getMaxRange();

			for (BoardObject target : targets.stream().filter(myRangeUnit::canShootAt).collect(Collectors.toList())) {
				BoardCell targetTopLeft = target.getTopLeftCell();
				BoardCell targetBottomRight = target.getBottomRightCell();
				for (int x = targetTopLeft.x - maxRange - (myUnit.getSize() - 1); x <= targetBottomRight.x + maxRange; x++) {
					for (int y = targetTopLeft.y - maxRange - (myUnit.getSize() - 1); y <= targetBottomRight.y + maxRange; y++) {
						BoardCell shootingPosition = new BoardCell(x,y);
						if (target.distanceTo(myUnit.hypotheticalCopyAtPosition(shootingPosition)) >= minRange
								&& canStandOn(shootingPosition)) {
							addTargetAttack(shootingPosition, target, target.getCells().get(0));
						}
					}
				}
			}
		} else {
			for (BoardObject target : targets) {
				for (BoardCell targetCell : target.getCells()) {
					List<BoardCell> possibleAttackPositions = myCellsAtTopLeftPosition(
							new BoardCell(targetCell.x - (myUnit.getSize() - 1), targetCell.y - (myUnit.getSize() - 1)))
							.stream().filter(this::validPosition).collect(Collectors.toList());
					for (BoardCell possibleAttackPosition : possibleAttackPositions) {
						addTargetAttack(possibleAttackPosition, target, null);
					}
				}
			}
		}
	}

	private void addTargetAttack(BoardCell attackPosition, BoardObject target, BoardCell rangeTargetCell) {
		if (targetAttacks[attackPosition.x][attackPosition.y] == null) {
			targetAttacks[attackPosition.x][attackPosition.y] = new HashMap<>();
		}
		targetAttacks[attackPosition.x][attackPosition.y].put(target, rangeTargetCell);
	}

	public boolean canStandOn(BoardCell cell) {
		if (!validPosition(cell)) {
			return false;
		}
		for (BoardCell myCell : myCellsAtTopLeftPosition(cell)) {
			if (obstacles[myCell.x][myCell.y]) {
				return false;
			}
		}
		return true;
	}

	/**
	 * @return all targets that can be attacked from given cell. For range units, map value is the coordinate
	 */
	public Map<BoardObject, BoardCell> getPossibleAttacksFromPosition(BoardCell cell) {
		if (!validPosition(cell)) {
			return null;
		}
		return targetAttacks[cell.x][cell.y];
	}

	public boolean validPosition(BoardCell cell) {
		return !(cell.x < 0 || cell.y < 0 || cell.x > board.getSizeX() - myUnit.getSize() || cell.y > board.getSizeY() - myUnit.getSize());
	}

	private List<BoardCell> myCellsAtTopLeftPosition(BoardCell topLeftCell) {
		List<BoardCell> myCells = new ArrayList<>();
		for (int x = topLeftCell.x; x < topLeftCell.x + myUnit.getSize(); x++) {
			for (int y = topLeftCell.y; y < topLeftCell.y + myUnit.getSize(); y++) {
				myCells.add(new BoardCell(x, y));
			}
		}
		return myCells;
	}
}
