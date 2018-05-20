package ai.game.board;

public class BoardCell
{
    public int x;
    public int y;
	
	public BoardCell(int x, int y)
	{
		this.x = x;
		this.y = y;
	}

	/**
	 * @return how many moves it is necessary to make to get from this cell to the other cell
	 * (not considering obstacles)
	 */
	public int distanceTo(BoardCell otherCell) {
		return Math.max(Math.abs(x - otherCell.x), Math.abs(y - otherCell.y));
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
