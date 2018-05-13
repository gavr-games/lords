package ai.ailogic;

import ai.command.Command;
import ai.command.LevelUpCommand;
import ai.game.board.BoardObject;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.logging.Level;
import java.util.logging.Logger;

public class LevelUpAI implements PlayerAI
{
	private static final Logger log = Logger.getLogger(LevelUpAI.class.getName());

	private BoardObject myUnit;

	public LevelUpAI(BoardObject myUnit) {
		this.myUnit = myUnit;
	}

	@Override
	public List<Command> getCommands()
	{
		List<Command> cmds = new ArrayList<>();
		String[] attributes = {"moves","health","attack"};
		int rnd = new Random().nextInt(attributes.length);
		cmds.add(new LevelUpCommand(myUnit.getTopLeftCell(), attributes[rnd]));
		log.log(Level.INFO, "Level up {0}", attributes[rnd]);

		return cmds;
	}
}
