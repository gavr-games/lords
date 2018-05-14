package ai.game.board;

public class BoardObjectFeature
{
    public String name;
    public String value;
	
	public BoardObjectFeature(String name, String value)
	{
		this.name = name;
		this.value = value;
	}
	
	public BoardObjectFeature(String name)
	{
		this(name,null);
	}
}
