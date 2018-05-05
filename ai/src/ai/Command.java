package ai;

public abstract class Command {
	public abstract String toString(int gameId, int playerNum);
}

class UnitMoveCommand extends ActionCommand {
    private BoardCell from;
    private BoardCell to;

    public UnitMoveCommand(BoardCell from, BoardCell to) {
        this.from = from;
        this.to = to;
    }

    @Override
	public BoardCell getFrom() {
		return from;
	}

    @Override
	public BoardCell getTo() {
		return to;
	}
    
    @Override
    public String toString(int gameId, int playerNum) {
        return "player_move_unit("+gameId+","+playerNum+","+from.x+","+from.y+","+to.x+","+to.y+")";
    }
}

class UnitAttackCommand extends ActionCommand
{
    private BoardCell from;
    private BoardCell to;

    public UnitAttackCommand(BoardCell from, BoardCell to) {
        this.from = from;
        this.to = to;
    }

    @Override
	public BoardCell getFrom() {
		return from;
	}

    @Override
	public BoardCell getTo() {
		return to;
	}
    
    @Override
    public String toString(int gameId, int playerNum) {
        return "attack("+gameId+","+playerNum+","+from.x+","+from.y+","+to.x+","+to.y+")";
    }
}

class EndTurnCommand extends Command {
    @Override
    public String toString(int gameId, int playerNum) {
        return "player_end_turn("+gameId+","+playerNum+")";
    }
}

class LevelUpCommand extends Command {
    private BoardCell unitCell;
    private String attribute;

    public LevelUpCommand(BoardCell unitCell, String attribute) {
        this.unitCell = unitCell;
        this.attribute = attribute;
    }

    @Override
    public String toString(int gameId, int playerNum) {
        return "unit_level_up_"+this.attribute+"("+gameId+","+playerNum+","+unitCell.x+","+unitCell.y+")";
    }
}