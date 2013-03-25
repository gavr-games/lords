package ai;

import ai.paths_finding.astar.AiBoardObject;
import ai.paths_finding.astar.Cell;
import ai.paths_finding.PathsFinder;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

class PathsFinderConnector {
    private static Map<Integer, BoardObject> hashMapOfTargets;

    public static Map<BoardObject, List<BoardCell>> getPaths(Board board, BoardObject myUnit, List<BoardObject> targets) {

        hashMapOfTargets = getHashMapOfBoardObjects(targets);

        PathsFinder pathsFinder =
                new PathsFinder(board.getSizeX(), board.getSizeY(),
                        convertListOfBoardObjectsToListOfAiBoardObjects(board.getObjects()));

        List<Integer> targets_hashes = new ArrayList<>(hashMapOfTargets.keySet());

        Map<Integer, List<Cell>> foundPaths = pathsFinder.searchPaths(myUnit.hashCode(), targets_hashes, myUnit.checkFeature("knight"));

        return convertPathsToGameTypes(foundPaths, board);
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

    private static Map<BoardObject, List<BoardCell>> convertPathsToGameTypes(Map<Integer, List<Cell>> paths, Board board) {

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
