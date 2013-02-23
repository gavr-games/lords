package ai.paths_finding.astar;

import java.util.List;

public class AiBoardObject {
    private int id;
    private List<Cell> cells;

    public AiBoardObject(int id, List<Cell> cells) {
        this.id = id;
        this.cells = cells;
    }

    public int getId() {
        return id;
    }

    public List<Cell> getCells() {
        return cells;
    }

    public boolean contains(Cell cell) {
        for(Cell c : cells)
            if (c.equals(cell)) return true;
        return false;
    }

    public Cell getTopLeftCell()
    {
        int minX = Integer.MAX_VALUE;
        int minY = Integer.MAX_VALUE;

        for(Cell cell : cells)
        {
            if(cell.x < minX)minX = cell.x;
            if(cell.y < minY)minY = cell.y;
        }
        return new Cell(minX,minY);
    }
}
