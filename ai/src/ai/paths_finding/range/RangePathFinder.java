package ai.paths_finding.range;

import ai.game.board.*;

import java.util.*;
import java.util.stream.Collectors;

public class RangePathFinder {
	private RangeUnit myUnit;
	private List<BoardObject> targets;
	private Board board;

	/**
	 * from target to ends of shortest paths
	 */
	private Map<BoardObject, List<BoardCell>> currentPaths;

	private Map<BoardObject, List<BoardCell>> resultingPaths;

	/**
	 * array of distances from myUnit to other cells, -1 occupied cells, -2 my top left cell
	 */
	private int[][] distances;
	private Random random;

	public RangePathFinder(RangeUnit myUnit, List<BoardObject> targets, Board board) {
		this.myUnit = myUnit;
		this.targets = targets.stream().filter(myUnit::canShootAt).collect(Collectors.toList());
		this.board = board;
		random = new Random();

		initObstacles();
	}

	private void initObstacles() {
		distances = new int[board.getSizeX()][board.getSizeY()];
		for (BoardObject obj : board.getObjects()) {
			if (obj.equals(myUnit)) {
				BoardCell myTopLeftCell = myUnit.getTopLeftCell();
				setDistance(myTopLeftCell, -2);
			} else {
				for (BoardCell cell : obj.getCells()) {
					setDistance(cell, -1);
				}
			}
		}
	}

	private void setDistance(BoardCell cell, int dist) {
		distances[cell.x][cell.y] = dist;
	}

	private int getDistance(BoardCell cell) {
		int dist = distances[cell.x][cell.y];
		return dist == -2? 0 : dist;
	}

	public Map<BoardObject, List<BoardCell>> getPaths(){
		this.resultingPaths = new HashMap<>();
		this.currentPaths = new HashMap<>();
		if (targets.isEmpty()) {
			return resultingPaths;
		}

		Queue<BoardCell> q = new ArrayDeque<>();
		q.add(myUnit.getTopLeftCell());

		while (!q.isEmpty() && !targets.isEmpty()) {
			BoardCell curCell = q.poll();
			int curDist = getDistance(curCell);
			checkTargets(curCell);
			for (BoardCell neighbour : getNeighbours(curCell)) {
				if (distances[neighbour.x][neighbour.y] == 0 && canStepOn(neighbour)) {
					setDistance(neighbour, curDist + 1);
					q.add(neighbour);
				}
			}
			if (q.isEmpty() || getDistance(q.peek()) > curDist) {
				collectPaths();
			}
		}

		return resultingPaths;
	}

	private void collectPaths() {
		for (Map.Entry<BoardObject, List<BoardCell>> e : currentPaths.entrySet()) {
			BoardObject target = e.getKey();
			List<BoardCell> possiblePathEnds = e.getValue();
			BoardCell pathEnd = randomClosestShot(target, possiblePathEnds);
			List<BoardCell> path = reconstructPathTo(pathEnd);
			path.add(target.getTopLeftCell());
			resultingPaths.put(target, path);
			targets.remove(target);
		}
		currentPaths.clear();
	}

	private BoardCell randomClosestShot(BoardObject target, List<BoardCell> possiblePathEnds) {
		List<BoardCell> closestCells = new ArrayList<>();
		int minDistance = Integer.MAX_VALUE;
		for (BoardCell cell : possiblePathEnds) {
			int dist = distanceToTarget(target, cell);
			if (dist < minDistance) {
				minDistance = dist;
				closestCells.clear();
				closestCells.add(cell);
			} else if (dist == minDistance) {
				closestCells.add(cell);
			}
		}
		return randomElementFrom(closestCells);
	}

	private List<BoardCell> reconstructPathTo(BoardCell pathEnd) {
		List<BoardCell> backwardPath = new ArrayList<>();
		backwardPath.add(pathEnd);
		while (getDistance(backwardPath.get(backwardPath.size() - 1)) > 0) {
			BoardCell lastCell = backwardPath.get(backwardPath.size() - 1);
			BoardCell prevCell = getRandomPrevCell(lastCell);
			backwardPath.add(prevCell);
		}
		Collections.reverse(backwardPath);
		return backwardPath; //already forward
	}

	private BoardCell getRandomPrevCell(BoardCell cell) {
		int distance = getDistance(cell);
		return randomElementFrom(
				getNeighbours(cell).stream()
						.filter(x -> getDistance(x) == distance - 1)
						.collect(Collectors.toList()));
	}

	private boolean canStepOn(BoardCell cell) {
		for (BoardCell c : myUnit.hypotheticalCopyAtPosition(cell).getCells()) {
			if (distances[c.x][c.y] == -1) {
				return false;
			}
		}
		return true;
	}

	private List<BoardCell> getNeighbours(BoardCell cell) {
		int[][] offsets;
		List<BoardCell> res = new ArrayList<>();
		if (!myUnit.checkFeature("knight")) {
			offsets = new int[][]{{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}};
		} else {
			offsets = new int[][]{{-2, -1}, {-2, 1}, {2, -1}, {2, 1}, {-1, -2}, {1, -2}, {-1, 2}, {1, 2}};
		}
		for (int[] offset : offsets) {
			int x = cell.x + offset[0];
			int y = cell.y + offset[1];
			if (validCell(x, y)) {
				res.add(new BoardCell(x, y));
			}
		}
		return res;
	}

	private boolean validCell(int x, int y) {
		return x >= 0 && y >= 0 && x < board.getSizeX() && y < board.getSizeY();
	}

	private void checkTargets(BoardCell cell) {
		for (BoardObject t : targets) {
			if (canShootTargetFrom(t, cell)) {
				if (!currentPaths.containsKey(t)) {
					currentPaths.put(t, new ArrayList<>());
				}
				currentPaths.get(t).add(cell);
			}
		}
	}

	private boolean canShootTargetFrom(BoardObject t, BoardCell cell) {
		int dist = distanceToTarget(t, cell);
		return dist >= myUnit.getMinRange() && dist <= myUnit.getMaxRange();
	}

	private int distanceToTarget(BoardObject t, BoardCell cell) {
		return myUnit.hypotheticalCopyAtPosition(cell).distanceTo(t);
	}

	private <T> T randomElementFrom(List<T> list) {
		return list.get(random.nextInt(list.size()));
	}
}
