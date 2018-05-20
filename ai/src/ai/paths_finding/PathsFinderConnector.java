package ai.paths_finding;

import ai.game.board.*;
import ai.paths_finding.astar.AiBoardObject;
import ai.paths_finding.astar.Cell;
import ai.paths_finding.range.RangePathFinder;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class PathsFinderConnector {
	private static Map<Integer, BoardObject> hashMapOfTargets;

	public static Map<BoardObject, List<BoardCell>> getPaths(Board board, Unit myUnit, List<BoardObject> targets) {
		if (myUnit instanceof RangeUnit) {
			return getPathsForRangeUnit(board, (RangeUnit) myUnit, targets);
		} else {
			return getPathsForMeleeUnit(board, myUnit, targets);
		}
	}

	private static Map<BoardObject, List<BoardCell>> getPathsForRangeUnit(Board board, RangeUnit myUnit, List<BoardObject> targets) {
		return new RangePathFinder(myUnit, targets, board).getPaths();
	}


	private static Map<BoardObject, List<BoardCell>> getPathsForMeleeUnit(Board board, Unit myUnit, List<BoardObject> targets) {

		hashMapOfTargets = getHashMapOfBoardObjects(targets);

		PathsFinder pathsFinder =
				new PathsFinder(board.getSizeX(), board.getSizeY(),
						convertListOfBoardObjectsToListOfAiBoardObjects(board.getObjects()));

		List<Integer> targets_hashes = new ArrayList<>(hashMapOfTargets.keySet());

		Map<Integer, List<Cell>> foundPaths = pathsFinder.searchPaths(myUnit.hashCode(), targets_hashes, myUnit.checkFeature("knight"));

		return convertPathsToGameTypes(foundPaths);
	}

	private static Map<Integer, BoardObject> getHashMapOfBoardObjects(List<BoardObject> targets) {
		Map<Integer, BoardObject> map = new HashMap<>();
		for(BoardObject target : targets)
			map.put(target.hashCode(), target);
		return map;
	}

	private static List<AiBoardObject> convertListOfBoardObjectsToListOfAiBoardObjects(List<BoardObject> boardObjects) {

		List<AiBoardObject> aiBoardObjects = new ArrayList<>();
		for(BoardObject boardObject : boardObjects)
			aiBoardObjects.add(convertBoardObjectToAiBoardObject(boardObject));

		return aiBoardObjects;
	}

	private static AiBoardObject convertBoardObjectToAiBoardObject(BoardObject boardObject) {

		List<Cell> AiBoardObjectCells = new ArrayList<>();
		for(BoardCell boardCell : boardObject.getCells())
			AiBoardObjectCells.add(new Cell(boardCell.x, boardCell.y));

		return new AiBoardObject(boardObject.hashCode(), AiBoardObjectCells);
	}

	private static Map<BoardObject, List<BoardCell>> convertPathsToGameTypes(Map<Integer, List<Cell>> paths) {

		Map<BoardObject, List<BoardCell>> convertedPaths = new HashMap<>();
		for(int key : paths.keySet()) {
			List<BoardCell> pathCells = new ArrayList<>();
			for(Cell cell : paths.get(key)) {
				pathCells.add(new BoardCell(cell.x, cell.y));
				convertedPaths.put(hashMapOfTargets.get(key), pathCells);
			}
		}

		return convertedPaths;
	}
}
