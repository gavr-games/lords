package ai.ailogic;

import ai.command.Command;
import ai.command.EndTurnCommand;
import ai.game.board.*;
import ai.pathfinding.Path;
import ai.pathfinding.PathFinder;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Random;

public class VampireAI implements PlayerAI
{
	private Board board;
	private Unit myUnit;
	private PathToCommandsConverter pathToCommandsConverter;

	public VampireAI(Board board, Unit myUnit, PathToCommandsConverter pathToCommandsConverter)
	{
		this.board = board;
		this.myUnit = myUnit;
		this.pathToCommandsConverter = pathToCommandsConverter;
	}

	@Override
	public List<Command> getCommands()
	{
		//add all objects not from my team as targets
		List<BoardObject> targets = new ArrayList<>();
		int myTeam = myUnit.getPlayer().getTeam();
		for(BoardObject bo:board.getObjects())
		{
			if(bo.getType() != BoardObjectType.OBSTACLE
					&& (bo.getPlayer() == null || bo.getPlayer().getTeam() != myTeam)
					&& !bo.checkFeature("not_interesting_for_npc"))
			{
				targets.add(bo);
			}
		}

		List<Command> commands;
		PathFinder pf = new PathFinder(board, myUnit, targets);
		Map<BoardObject, Path> pathsToTargets = pf.findPaths(false);

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
					int pathLength = pathsToTargets.get(t).getDistance();
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

			if (myUnit instanceof RangeUnit) {
				int minShootDistance = Integer.MAX_VALUE;
				List<BoardObject> keysForShortestShots = new ArrayList<>();
				for (BoardObject target : highestPriorityTargets) {
					Path path = pathsToTargets.get(target);
					BoardCell shootingPosition = path.getRandomPreviousStep().getCell();
					int dist = myUnit.hypotheticalCopyAtPosition(shootingPosition).distanceTo(target);
					if (dist < minShootDistance) {
						minShootDistance = dist;
						keysForShortestShots.clear();
						keysForShortestShots.add(target);
					} else if (dist == minShootDistance) {
						keysForShortestShots.add(target);
					}
				}
				highestPriorityTargets = keysForShortestShots;
			}

			Path path = pathsToTargets.get(highestPriorityTargets.get(new Random().nextInt(highestPriorityTargets.size())));
			commands = pathToCommandsConverter.generateCommandsFromPath(path, myUnit.getMoves());
		}
		return commands;
	}

}
