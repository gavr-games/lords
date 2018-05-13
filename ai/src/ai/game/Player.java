package ai.game;

public class Player
{
	private int playerNum;
	private int owner;
	private int team;

	public Player(int playerNum,int owner,int team)
	{
		this.playerNum = playerNum;
		this.owner = owner;
		this.team = team;
	}

	public int getOwner()
    {
        return owner;
    }

	public int getPlayerNum()
    {
        return playerNum;
    }

	public int getTeam()
    {
        return team;
    }

	public void setOwner(int owner) {
		this.owner = owner;
	}

	@Override
	public boolean equals(Object obj)
	{
		if(this == obj)
			return true;
		if((obj == null) || (obj.getClass() != this.getClass()))
			return false;
		Player test = (Player)obj;
		return playerNum == test.playerNum;
	}

	@Override
	public int hashCode()
	{
		return playerNum;
	}
}
