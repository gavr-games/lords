package ai;

public class BoardCell
{
    public int x;
    public int y;
	
	public BoardCell(int x, int y)
	{
		this.x = x;
		this.y = y;
	}
		
    @Override
	public boolean equals(Object obj)
	{
		if(this == obj)
			return true;
		if((obj == null) || (obj.getClass() != this.getClass()))
			return false;
		BoardCell test = (BoardCell)obj;
		return x == test.x && y == test.y;
	}

    @Override
	public int hashCode()
	{
		int hash = 7;
		hash = 31 * hash + x;
		hash = 31 * hash + y;
		return hash;
	}	
}
