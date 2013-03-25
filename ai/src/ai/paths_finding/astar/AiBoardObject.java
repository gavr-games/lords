package ai.paths_finding.astar;

import java.util.List;

public class AiBoardObject {
    private int hash;
    private List<Cell> cells;

    public AiBoardObject(int hash, List<Cell> cells) {
        this.hash = hash;
        this.cells = cells;
    }

    public int getHash() {
        return hash;
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
