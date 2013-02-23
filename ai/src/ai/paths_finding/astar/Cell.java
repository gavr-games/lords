package ai.paths_finding.astar;

public class Cell {
    public int x;
    public int y;

    public Cell(int x, int y)
    {
        this.x = x;
        this.y = y;
    }

    @Override
    public boolean equals(Object obj)
    {
        if((obj == null) || (obj.getClass() != this.getClass()))
            return false;
        Cell cell = (Cell)obj;
        return x == cell.x & y == cell.y;
    }
}
