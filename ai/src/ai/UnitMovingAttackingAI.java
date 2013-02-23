package ai;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public abstract class UnitMovingAttackingAI implements PlayerAI
{
	protected List<Command> getMoveAttackCommandsFromCellsList(List<BoardCell> path)
	{
		List<Command> commands = new ArrayList<>();

		int i;
		for(i = 0; i < path.size()-2; i++) {
			commands.add(new UnitMoveCommand(path.get(i), path.get(i + 1)));
		}
		commands.add(new UnitAttackCommand(path.get(i), path.get(i+1)));
		
		return commands;
	}

}
