package ai.ailogic;

import ai.command.Command;

import java.util.List;

public interface PlayerAI
{
	List<Command> getCommands();
}