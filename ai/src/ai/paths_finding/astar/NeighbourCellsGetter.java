package ai.paths_finding.astar;

import java.util.ArrayList;
import java.util.List;

interface NeighbourCellsGetter
{
    List<Cell> getNeighbourCells(Cell p);
}

class OrdinaryNeighbourCellsGetter implements NeighbourCellsGetter {
    @Override
    public List<Cell> getNeighbourCells(Cell p) {
        List<Cell> list = new ArrayList<>();
        list.add(new Cell(p.x-1,p.y-1));
        list.add(new Cell(p.x-1,p.y));
        list.add(new Cell(p.x-1,p.y+1));
        list.add(new Cell(p.x,p.y-1));
        list.add(new Cell(p.x,p.y+1));
        list.add(new Cell(p.x+1,p.y-1));
        list.add(new Cell(p.x+1,p.y));
        list.add(new Cell(p.x+1,p.y+1));
        return list;
    }
}

class KnightNeighbourCellsGetter implements NeighbourCellsGetter {
    @Override
    public List<Cell> getNeighbourCells(Cell p) {
        List<Cell> list = new ArrayList<>();
        list.add(new Cell(p.x-1,p.y-2));
        list.add(new Cell(p.x+1,p.y-2));
        list.add(new Cell(p.x-2,p.y-1));
        list.add(new Cell(p.x-2,p.y+1));
        list.add(new Cell(p.x-1,p.y+2));
        list.add(new Cell(p.x+1,p.y+2));
        list.add(new Cell(p.x+2,p.y-1));
        list.add(new Cell(p.x+2,p.y+1));
        return list;
    }
}