package ai.game.board;

import ai.game.Player;

import java.util.ArrayList;
import java.util.List;

public class BoardObject
{
	private Player player;
	private List<BoardObjectFeature> features;
	private List<BoardCell> cells;
	private int id;
	private BoardObjectType type;

	public BoardObject(int id, BoardObjectType type, Player player)
	{
		this.id = id;
		this.type = type;
		this.player = player;
		this.features = new ArrayList<>();
		this.cells = new ArrayList<>();
	}

	public List<BoardCell> getCells()
	{
		return cells;
	}

	public void addCell(BoardCell cell)
	{
		cells.add(cell);
	}

	public Player getPlayer()
	{
		return player;
	}

	public List<BoardObjectFeature> getFeatures()
	{
		return features;
	}
	
	public boolean checkFeature(String featureName)
	{
		for(BoardObjectFeature f : features)
		{
			if(f.name.equals(featureName)) return true;
		}
		return false;
	}

	public void addFeature(BoardObjectFeature f)
	{
		features.add(f);
	}

	public String getFeatureValue(String featureName)
	{
		for(BoardObjectFeature f : features)
		{
			if(f.name.equals(featureName)) return f.value;
		}
		return null;
	}
	
	public BoardCell getTopLeftCell()
	{
		int minX = Integer.MAX_VALUE;
		int minY = Integer.MAX_VALUE;
		
		for(BoardCell cell : cells)
		{
			if(cell.x < minX)minX = cell.x;
			if(cell.y < minY)minY = cell.y;
		}
		return new BoardCell(minX,minY);
	}
	
	public int getId()
	{
		return id;
	}
	
	public BoardObjectType getType()
	{
		return type;
	}

	public void setType(BoardObjectType type) {
		this.type = type;
	}

	@Override
	public boolean equals(Object obj)
	{
		if(this == obj)
			return true;
		if((obj == null) || (obj.getClass() != this.getClass()))
			return false;
		BoardObject test = (BoardObject) obj;
		return type == test.type && id == test.id;
	}

	@Override
	public int hashCode()
	{
		int hash = 5;
		hash = 41 * hash + this.id;
		hash = 41 * hash + (this.type != null ? this.type.hashCode() : 0);
		return hash;
	}
}
