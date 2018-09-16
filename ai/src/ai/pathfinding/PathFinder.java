package ai.pathfinding;

import ai.game.board.Board;
import ai.game.board.BoardCell;
import ai.game.board.BoardObject;
import ai.game.board.Unit;

import java.util.*;
import java.util.concurrent.ThreadLocalRandom;

public class PathFinder {
	private Unit myUnit;
	private List<BoardObject> targets;
	private Path[][] paths;
	private PositionChecker positionChecker;
	private NextStepsExpander next;

	public PathFinder(Board board, Unit myUnit, List<BoardObject> targets) {
		this.myUnit = myUnit;
		this.targets = targets;
		paths = new Path[board.getSizeX()][board.getSizeY()];
		positionChecker = new PositionChecker(board, myUnit, targets);
		next = new NextStepsExpander(myUnit);
	}

	/**
	 * If a path to a given cell is empty, creates and returns the new path
	 * Otherwise updates existing path if necessary and returns null
	 */
	private Path registerPath(Path prevPath, int addedDistance, BoardCell cell) {
		if (paths[cell.x][cell.y] == null) {
			paths[cell.x][cell.y] = new Path(addedDistance, cell, prevPath);
			return paths[cell.x][cell.y];
		} else {
			Path existingPath = paths[cell.x][cell.y];
			if (existingPath.getDistance() == prevPath.getDistance() + addedDistance) {
				if (existingPath.getDistance() - existingPath.getPreviousSteps().get(0).getDistance() > addedDistance) {
					existingPath.getPreviousSteps().clear();
				}
				existingPath.getPreviousSteps().add(prevPath);
			}
		}
		return null;
	}

	public Map<BoardObject, Path> findPaths(boolean onlyFirstTarget) {
		BoardCell initialPosition = myUnit.getTopLeftCell();
		Path path = registerPath(null, 0, initialPosition);
		PriorityQueue<Path> q = new PriorityQueue<>();
		q.add(path);
		Map<BoardObject, List<Path>> foundPaths = new HashMap<>();
		int pathsToFind = onlyFirstTarget ? 1 : targets.size();
		int currentDistance = 0;
		while (!q.isEmpty() && (foundPaths.size() < pathsToFind || currentDistance == q.peek().getDistance())) {
			Path curPath = q.poll();
			currentDistance = curPath.getDistance();
			BoardCell curCell = curPath.getCell();

			Map<BoardObject, BoardCell> attacks = positionChecker.getPossibleAttacksFromPosition(curCell);
			if (attacks != null) {
				for (BoardObject target: attacks.keySet()) {
					Path attackPath;
					if (attacks.get(target) != null) {
						attackPath = new Path(1, attacks.get(target), curPath);
					} else {
						attackPath = curPath;
					}

					if (foundPaths.containsKey(target) && foundPaths.get(target).get(0).getDistance() < attackPath.getDistance()) {
						continue;
					}
					if (!foundPaths.containsKey(target) || foundPaths.get(target).get(0).getDistance() > attackPath.getDistance()) {
						foundPaths.put(target, new ArrayList<>());
					}
					foundPaths.get(target).add(attackPath);
				}
			}

			if (positionChecker.canStandOn(curCell)) {
				Map<BoardCell, Integer> nextCells = next.expand(curCell);
				for (BoardCell nextCell : nextCells.keySet()) {
					if (positionChecker.validPosition(nextCell)
							&& (nextCells.get(nextCell) == 1 || positionChecker.canStandOn(nextCell))) {
						Path nextPath = registerPath(curPath, nextCells.get(nextCell), nextCell);
						if (nextPath != null) {
							q.add(nextPath);
						}
					}
				}
			}
		}
		Map<BoardObject, Path> resultingPaths = new HashMap<>();
		for (BoardObject target : foundPaths.keySet()) {
			List<Path> pathsForTarget = foundPaths.get(target);
			Path p = pathsForTarget.get(ThreadLocalRandom.current().nextInt(pathsForTarget.size()));
			resultingPaths.put(target, p);
		}
		return resultingPaths;
	}
}
