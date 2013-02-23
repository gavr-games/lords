package ai;

import java.util.List;

public class Game
{
    private List<Player> players;
    private Board board;
    private int id;
    private int currentPlayerNum;
    
    public Game(List<Player> players, Board board)
    {
        this.players = players;
        this.board = board;
    }
    
    public List<Player> getPlayers()
    {
        return players;
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
