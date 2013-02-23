package ai;

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
    
    public BoardObject getUnitById(int id)
	{
		for(BoardObject bo:objects)
		{
			//if(bo.getId() == id && bo.getType() == BoardObjectType.UNIT) return bo;
            if(bo.getId() == id) return bo;
		}
		return null;
	}
}
