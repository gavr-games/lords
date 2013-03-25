package ai.paths_finding.astar;

import java.util.List;

public class AiBoard {
    private int size_x;
    private int size_y;

    private List<AiBoardObject> objects;
    private BoardCell[][] map;

    public AiBoard(int size_x, int size_y, List<AiBoardObject> objects) {
        this.size_x = size_x;
        this.size_y = size_y;
        this.objects = objects;
        map = new BoardCell[size_x][size_y];

        // filling map by standard boardCells which are not closed and not goals
        for(int x=0; x< size_x; x++)
            for(int y=0; y< size_y; y++)
                map[x][y] = new BoardCell(x, y);

        // boardCell with object on it, marking as obstacle
        for(AiBoardObject o : objects)
            for(Cell cell : o.getCells())
                map[cell.x][cell.y].makeAnObstacle();
    }

    public BoardCell getCell(int x, int y) {
        return map[x][y];
    }

    public AiBoardObject getObjectByHash(int hash) {

        for(AiBoardObject object : objects)
            if (hash == object.getHash())
                return object;

        return null;
    }

    public void setMyUnitCells(List<Cell> unitCells) {
        for(Cell unitCell : unitCells) {
            map[unitCell.x][unitCell.y].makeAsMyUnitCell();
        }
    }

    public void setGoal(AiBoardObject goal) {
        for(Cell goalCell : goal.getCells())
            map[goalCell.x][goalCell.y].makeAGoal();
    }

    public boolean pointInRange(Cell p) {
        return p.x >= 0 & p.x < size_x & p.y >= 0 & p.y < size_y;
    }

    public int estimateHeuristicDistance(Cell from, AiBoardObject to) {
        int MIN_HEURISTIC_DISTANCE = Integer.MAX_VALUE;

        for(Cell cell : to.getCells()) {
            int temp = estimateHeuristicDistance(from, cell);
            if(temp < MIN_HEURISTIC_DISTANCE)
                MIN_HEURISTIC_DISTANCE = temp;
        }
        return MIN_HEURISTIC_DISTANCE;
    }

    public int estimateHeuristicDistance(Cell from, Cell to) {
        return Math.abs(from.x - to.x) > Math.abs(from.y - to.y) ? Math.abs(from.x - to.x) : Math.abs(from.y - to.y);
    }

    public Offset calculateOffsetBetweenCellsCoordinates(Cell a, Cell b) {
        return new Offset(b.x - a.x, b.y - a.y);
    }

    public void restore() {
        for(int x=0; x< size_x; x++)
            for(int y=0; y< size_y; y++)
                map[x][y].reset();
    }
}
