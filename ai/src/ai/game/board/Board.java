package ai.game.board;

import java.util.List;

public class Board
{
    private List<BoardObject> objects;
    private int sizeX;
    private int sizeY;

    public Board(int sizeX, int sizeY, List<BoardObject> objects)
    {
        this.objects = objects;
        this.sizeX = sizeX;
        this.sizeY = sizeY;
    }

    public List<BoardObject> getObjects()
    {
        return objects;
    }

    public int getSizeX()
    {
        return sizeX;
    }

    public int getSizeY()
    {
        return sizeY;
    }
    
    public Unit getUnitById(int id)
	{
		for(BoardObject bo:objects)
		{
			if(bo.getId() == id && bo instanceof Unit) return (Unit) bo;
		}
		throw new IllegalArgumentException("Unit with id = "+id+" was not found");
	}

	public BoardObject getBuildingById(int id)
	{
		for(BoardObject bo:objects)
		{
			if(bo.getId() == id && !bo.getType().equals(BoardObjectType.UNIT)) return bo;
		}
		return null;
	}
}
