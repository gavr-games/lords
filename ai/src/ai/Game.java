package ai;

import java.util.List;
import java.util.ArrayList;

public class Game
{
    private List<Player> players;
    private List<UnitLevel> unitLevels;
    private Board board;
    private int id;
    private int currentPlayerNum;
    
    public Game(List<Player> players, List<UnitLevel> unitLevels, Board board)
    {
        this.players = players;
        this.unitLevels = unitLevels;
        this.board = board;
    }
    
    public List<Player> getPlayers()
    {
        return players;
    }

    public List<UnitLevel> getUnitLevels()
    {
        return unitLevels;
    }
    
    public Board getBoard()
    {
        return board;
    }

    public int getId()
    {
        return id;
    }

    public void setId(int newId)
    {
        id = newId;
    }
}
