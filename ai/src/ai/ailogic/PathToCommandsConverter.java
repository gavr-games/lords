package ai.ailogic;

import ai.command.Command;
import ai.game.board.BoardCell;
import ai.pathfinding.Path;

import java.util.List;

public interface PathToCommandsConverter {
	List<Command> generateCommandsFromPath(Path path, int moves);
}
