package ai;

public abstract class Command
{
    public abstract BoardCell getFrom();
    public abstract BoardCell getTo();
	public abstract String toString(int gameId, int playerNum);
}



class UnitMoveCommand extends Command
{
    private BoardCell from;
    private BoardCell to;

    public UnitMoveCommand(BoardCell from, BoardCell to)
    {
        this.from = from;
        this.to = to;
    }

    @Override
	public BoardCell getFrom()
	{
		return from;
	}

    @Override
	public BoardCell getTo()
	{
		return to;
	}
    
    @Override
    public String toString(int gameId, int playerNum)
    {
        return "player_move_unit("+gameId+","+playerNum+","+from.x+","+from.y+","+to.x+","+to.y+")";
    }
}

class UnitAttackCommand extends Command
{
    private BoardCell from;
    private BoardCell to;

    public UnitAttackCommand(BoardCell from, BoardCell to)
    {
        this.from = from;
        this.to = to;
    }

    @Override
	public BoardCell getFrom()
	{
		return from;
	}

    @Override
	public BoardCell getTo()
	{
		return to;
	}
    
    @Override
    public String toString(int gameId, int playerNum)
    {
        return "attack("+gameId+","+playerNum+","+from.x+","+from.y+","+to.x+","+to.y+")";
    }
}

class EndTurnCommand extends Command
{

    @Override
    public BoardCell getFrom()
    {
        return null;
    }

    @Override
    public BoardCell getTo()
    {
        return null;
    }

    @Override
    public String toString(int gameId, int playerNum)
    {
        return "player_end_turn("+gameId+","+playerNum+")";
    }
}