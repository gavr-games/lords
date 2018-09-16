package ai.ailogic;

import ai.command.Command;
import ai.command.EndTurnCommand;
import ai.command.UnitAttackCommand;
import ai.command.UnitMoveCommand;
import ai.game.board.BoardCell;
import ai.pathfinding.Path;

import java.util.ArrayList;
import java.util.List;

public class UnitMovingAttackingPathConverter implements PathToCommandsConverter
{
	public List<Command> generateCommandsFromPath(Path path, int moves)
	{
		List<Command> commands = new ArrayList<>();
		List<Path> linearPath = unwindPath(path);

		int i;
		for(i = 0; i < linearPath.size()-1; i++) {
			if (linearPath.get(i + 1).getDistance() > moves) {
				if (commands.size() < moves) {
					commands.add(new EndTurnCommand());
				}
				return commands;
			}

			Command command;
			if (i == linearPath.size()-2) {
				command = finalCommand(linearPath.get(i).getCell(), linearPath.get(i + 1).getCell());
			} else {
				command = new UnitMoveCommand(linearPath.get(i).getCell(), linearPath.get(i + 1).getCell());
			}
			commands.add(command);
		}
		return commands;
	}

	private List<Path> unwindPath(Path path) {
		if (path == null) {
			return new ArrayList<>();
		}
		List<Path> prevPath = unwindPath(path.getRandomPreviousStep());
		prevPath.add(path);
		return prevPath;
	}

	protected Command finalCommand(BoardCell cellFrom, BoardCell cellTo){
		return new UnitAttackCommand(cellFrom, cellTo);
	}
}
