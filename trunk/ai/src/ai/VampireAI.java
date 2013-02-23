package ai;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Random;

public class VampireAI extends UnitMovingAttackingAI
{
	private Board board;
	private BoardObject myUnit;
	
	public VampireAI(Board board, BoardObject myUnit)
	{
		this.board = board;
		this.myUnit = myUnit;
	}

	
	
	@Override
	public List<Command> getCommands()
	{
		//add all objects not from my team as targets
		List<BoardObject> targets = new ArrayList<>();
		int myTeam = myUnit.getPlayer().getTeam();
		for(BoardObject bo:board.getObjects())
		{
			if(bo.getType() != BoardObjectType.OBSTACLE && (bo.getPlayer() == null || bo.getPlayer().getTeam() != myTeam)) targets.add(bo);
		}

        List<Command> commands;
		Map<BoardObject, List<BoardCell>> pathsToTargets = PathsFinderConnector.getPaths(board, myUnit, targets);

		if (pathsToTargets.isEmpty())
		{
			commands = new ArrayList<>();
			commands.add(new EndTurnCommand());
		} else
		{
			List<BoardObject> highestPriorityTargets = new ArrayList<>();

			//target priorities from highest to lowest:
			//units in range of 4 cells
			//buildings in 4 cells
			//units in 8 cells
			//buildings in 8 cells
			//castles in 8 cells
			//units all over the board
			//buildings all over the board
			//castles all over the board

			int minPriority = 9999999;
			for(BoardObject t : targets)
			{
				if(pathsToTargets.containsKey(t))
				{
					int pathLength = pathsToTargets.get(t).size() - 1;
					int priorityClass;
					int currentTargetPriority;
					if(t.getType() == BoardObjectType.UNIT && pathLength <= 4) priorityClass = 0;
					else if(t.getType() == BoardObjectType.BUILDING && pathLength <= 4) priorityClass = 1;
					else if(t.getType() == BoardObjectType.UNIT && pathLength <= 8) priorityClass = 2;
					else if(t.getType() == BoardObjectType.BUILDING && pathLength <= 8) priorityClass = 3;
					else if(t.getType() == BoardObjectType.CASTLE && pathLength <= 8) priorityClass = 4;
					else if(t.getType() == BoardObjectType.UNIT) priorityClass = 5;
					else if(t.getType() == BoardObjectType.BUILDING) priorityClass = 6;
					else priorityClass = 7; //castle far away

					currentTargetPriority = priorityClass*10000 + pathLength;
					if(currentTargetPriority < minPriority)
					{
						minPriority = currentTargetPriority;
						highestPriorityTargets.clear();
						highestPriorityTargets.add(t);
					}
					else if(currentTargetPriority == minPriority)
					{
						highestPriorityTargets.add(t);
					}
				}
			}

			List<BoardCell> finalPath = pathsToTargets.get(highestPriorityTargets.get(new Random().nextInt(highestPriorityTargets.size())));
			commands = generateCommandsFromPath(finalPath);
		}

		if(commands.size() <= myUnit.getMoves())
			return commands;
		else
			return commands.subList(0, myUnit.getMoves());
	}

}
