package ai.ailogic;

import ai.ailogic.PlayerAI;
import ai.command.Command;
import ai.command.UnitAttackCommand;
import ai.command.UnitMoveCommand;
import ai.game.board.BoardCell;

import java.util.ArrayList;
import java.util.List;

public abstract class UnitMovingAttackingAI implements PlayerAI
{
	protected List<Command> generateCommandsFromPath(List<BoardCell> path)
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
