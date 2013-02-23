package ai;

import java.util.ArrayList;
import java.util.List;

public class EndTurningAI implements PlayerAI
{
	@Override
	public List<Command> getCommands()
	{
		List<Command> cmds = new ArrayList<>();
		cmds.add(new EndTurnCommand());
		return cmds;
	}
}