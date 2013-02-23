package ai.paths_finding.astar;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Random;

public class Astar {
    private AiBoard aiBoard;
    private AiBoardObject unit;
    private AiBoardObject goalObject;
    private NeighbourCellsGetter neighbourCellsGetter;

    private BoardCell currentCell;
    private List<Cell> foundPath = new ArrayList<>();
    private List<BoardCell> openedSet = new ArrayList<>();

    public Astar(AiBoard aiBoard, AiBoardObject unit, AiBoardObject goalObject, boolean knightMoving) {
        this.aiBoard = aiBoard;
        this.unit = unit;
        this.goalObject = goalObject;
        aiBoard.setGoal(goalObject);
        aiBoard.setMyUnitCells(unit.getCells());
        if(knightMoving) neighbourCellsGetter = new KnightNeighbourCellsGetter();
        else neighbourCellsGetter = new OrdinaryNeighbourCellsGetter();
    }

    public List<Cell> search() {
        BoardCell start = aiBoard.getCell(unit.getTopLeftCell().x, unit.getTopLeftCell().y);
        start.heuristicDistanceToGoal = aiBoard.estimateHeuristicDistance(start.getPoint(), goalObject);
        start.updatePathCost();
        openedSet.add(start);

        while(!openedSet.isEmpty()) {
            currentCell = getRandomCellWithMinPathCost(openedSet);
            openedSet.remove(currentCell);
            currentCell.close();

            if(goalIsFound(currentCell)) {
                return reconstructPath(currentCell);
            }

            checkNeighbours(currentCell);
        }

        return foundPath;
    }

    private BoardCell getRandomCellWithMinPathCost(List<BoardCell> openedSet) {
        int MIN_PATH_COST = Integer.MAX_VALUE;
        List<BoardCell> cellsWithMinPathCost = new ArrayList<>();
        for(BoardCell cell : openedSet) {
            if(cell.pathCost < MIN_PATH_COST) {
                MIN_PATH_COST = cell.pathCost;
                cellsWithMinPathCost.clear();
                cellsWithMinPathCost.add(cell);
            }
            else if(cell.pathCost == MIN_PATH_COST)
                cellsWithMinPathCost.add(cell);
        }
        BoardCell randomCell = cellsWithMinPathCost.get(new Random().nextInt(cellsWithMinPathCost.size()));
        return randomCell;
    }

    private List<Cell> reconstructPath(BoardCell currentCell) {
        while(currentCell.parent != null) {
            foundPath.add(currentCell.getPoint());
            currentCell = currentCell.parent;
        }
        foundPath.add(currentCell.getPoint());
        Collections.reverse(foundPath);
        return foundPath;
    }

    private boolean goalIsFound(BoardCell currentCell) {
        for(Cell unitCell : getUnitCellsForCurrentPosition(currentCell.getPoint()))
            for(Cell goalCell : goalObject.getCells())
                if(unitCell.equals(goalCell))
                    return true;

        return false;
    }

    private List<Cell> getUnitCellsForCurrentPosition(Cell currentPosition) {
        List<Cell> cells = new ArrayList<>();
        Offset offset = aiBoard.calculateOffsetBetweenCellsCoordinates(unit.getTopLeftCell(), currentPosition);
        for(Cell unitCell : unit.getCells())
            cells.add(new Cell(unitCell.x+offset.by_x, unitCell.y+offset.by_y));

        return cells;
    }

    private void checkNeighbours(BoardCell currentCell) {
        List<Cell> neighbours = neighbourCellsGetter.getNeighbourCells(currentCell.getPoint());

        for(Cell point : neighbours) {
            if(notMoveable(point))
                continue;

            BoardCell checkingCell = aiBoard.getCell(point.x, point.y);
            if(checkingCell.isClosed())
                continue;

            boolean tentativeIsBetter = true;
            int tentativePathLength;
            if(KnightNeighbourCellsGetter.class.isInstance(neighbourCellsGetter))
                tentativePathLength = currentCell.pathLength + 2;
            else
                 tentativePathLength = currentCell.pathLength + 1;

            if(!openedSet.contains(checkingCell)) {
                openedSet.add(checkingCell);
            }
            else if (tentativePathLength >= checkingCell.pathLength)
                tentativeIsBetter = false;

            if(tentativeIsBetter) {
                checkingCell.parent = currentCell;
                checkingCell.pathLength = tentativePathLength;
                checkingCell.heuristicDistanceToGoal = aiBoard.estimateHeuristicDistance(checkingCell.getPoint(), goalObject);
                checkingCell.updatePathCost();
            }
        }
    }

    private boolean notMoveable(Cell cell) {
        for(Cell unitCell : getUnitCellsForCurrentPosition(cell)) {
            if(!aiBoard.pointInRange(unitCell))
                return true;
        }
        for(Cell unitCell : getUnitCellsForCurrentPosition(cell)) {
            if(goalObject.contains(unitCell))
                return false;
        }
        for(Cell unitCell : getUnitCellsForCurrentPosition(cell)) {
            if(aiBoard.getCell(unitCell.x, unitCell.y).isObstacle())
                return true;
        }
        return false;
    }
}
