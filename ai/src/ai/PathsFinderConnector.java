package ai;

import ai.paths_finding.astar.AiBoardObject;
import ai.paths_finding.astar.Cell;
import ai.paths_finding.PathsFinder;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

class PathsFinderConnector {
    public static Map<BoardObject, List<BoardCell>> getPaths(Board board, BoardObject myUnit, List<BoardObject> targets) {

        PathsFinder pathsFinder =
                new PathsFinder(board.getSizeX(), board.getSizeY(),
                        convertListOfBoardObjectsToListOfAiBoardObjects(board.getObjects()));

        List<Integer> targets_id = new ArrayList<>();
        for(BoardObject target : targets)
            targets_id.add(target.getId());

        return convertPathsToGameTypes(pathsFinder.searchPaths(myUnit.getId(), targets_id, myUnit.checkFeature("knight")), board);
    }

    private static AiBoardObject convertBoardObjectToAiBoardObject(BoardObject boardObject) {

        List<Cell> AiBoardObjectCells = new ArrayList<>();
        for(BoardCell boardCell : boardObject.getCells())
            AiBoardObjectCells.add(new Cell(boardCell.x, boardCell.y));

        return new AiBoardObject(boardObject.getId(), AiBoardObjectCells);
    }

    private static List<AiBoardObject> convertListOfBoardObjectsToListOfAiBoardObjects(List<BoardObject> boardObjects) {

        List<AiBoardObject> aiBoardObjects = new ArrayList<>();
        for(BoardObject boardObject : boardObjects)
            aiBoardObjects.add(convertBoardObjectToAiBoardObject(boardObject));

        return aiBoardObjects;
    }

    private static Map<BoardObject, List<BoardCell>> convertPathsToGameTypes(Map<Integer, List<Cell>> paths, Board board) {

        Map<BoardObject, List<BoardCell>> convertedPaths = new HashMap<>();
        for(int key : paths.keySet()) {
            List<BoardCell> boardObjectCells = new ArrayList<>();
            for(Cell cell : paths.get(key)) {
                boardObjectCells.add(new BoardCell(cell.x, cell.y));
                convertedPaths.put(board.getUnitById(key), boardObjectCells);
            }
        }

        return convertedPaths;
    }
}
