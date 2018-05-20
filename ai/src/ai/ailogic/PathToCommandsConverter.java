package ai.ailogic;

import ai.command.Command;
import ai.game.board.BoardCell;

import java.util.List;

public interface PathToCommandsConverter {
	List<Command> generateCommandsFromPath(List<BoardCell> path);
}
