package ai;

import java.util.ArrayList;
import java.util.List;

public class UnitMoveToTargetAI extends MultiTargetUnitAI
{

    public UnitMoveToTargetAI(Board board, BoardObject myUnit, List<BoardObject> targets) {
		super(board,myUnit,targets);
    }
	
	@Override
	protected List<Command> generateCommandsFromPath(List<BoardCell> path)
	{
		// End turn instead of attack in the end - used for moving to "home" object
		
		List<Command> commands = new ArrayList<>();

		int i;
		for(i = 0; i < path.size()-2; i++) {
			commands.add(new UnitMoveCommand(path.get(i), path.get(i + 1)));
		}
		commands.add(new EndTurnCommand());
		
		return commands;
	}
}
