package ai.ailogic;

import ai.command.Command;
import ai.command.UnitAttackCommand;
import ai.command.UnitMoveCommand;
import ai.game.board.BoardCell;

import java.util.ArrayList;
import java.util.List;

public class UnitMovingAttackingPathConverter implements PathToCommandsConverter
{
	public List<Command> generateCommandsFromPath(List<BoardCell> path)
	{
		List<Command> commands = new ArrayList<>();

		int i;
		for(i = 0; i < path.size()-2; i++) {
			commands.add(new UnitMoveCommand(path.get(i), path.get(i + 1)));
		}
		commands.add(finalCommand(path.get(i), path.get(i+1)));
		
		return commands;
	}

	protected Command finalCommand(BoardCell cellFrom, BoardCell cellTo){
		return new UnitAttackCommand(cellFrom, cellTo);
	}
}
