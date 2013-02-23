package ai.paths_finding.astar;

public class BoardCell {

    public int x;
    public int y;
    public int pathLength = 0;
    public int heuristicDistanceToGoal = 0;
    public BoardCell parent = null;
    public int pathCost = Integer.MAX_VALUE;

    private boolean isClosed = false;
    private boolean isObstacle = false;
    private boolean isGoal = false;

    public BoardCell(int x, int y) {
        this.x = x;
        this.y = y;
    }

    public void close() {
        isClosed = true;
    }

    public boolean isClosed() {
        return isClosed;
    }

    public void makeAGoal() {
        isGoal = true;
    }

    public boolean isGoal() {
        return isGoal;
    }

    public void updatePathCost() {
        pathCost = pathLength + heuristicDistanceToGoal;
    }

    public Cell getPoint() {
        return new Cell(x, y);
    }

    public void makeAnObstacle() {
        isObstacle = true;
    }

    public boolean isObstacle() {
        return isObstacle;
    }

    public void makeAsMyUnitCell() {
        isObstacle = false;
    }

}
