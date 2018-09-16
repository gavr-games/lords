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

public class MultiTargetUnitAI implements PlayerAI {
	private List<BoardObject> targets;
	private Board board;
	private Unit myUnit;
	private PathToCommandsConverter pathToCommandsConverter;

	public MultiTargetUnitAI(Board board, Unit myUnit, List<BoardObject> targets, PathToCommandsConverter pathToCommandsConverter) {
		this.targets = targets;
		this.board = board;
		this.myUnit = myUnit;
		this.pathToCommandsConverter = pathToCommandsConverter;
	}

	@Override
	public List<Command> getCommands(){

		PathFinder pf = new PathFinder(board, myUnit, targets);
		Map<BoardObject, Path> pathsToTargets = pf.findPaths(true);

		List<Command> commands;

		if (pathsToTargets.isEmpty()) {
			commands = new ArrayList<>();
			commands.add(new EndTurnCommand());
		} else {

			if (myUnit instanceof RangeUnit) {
				int minShootDistance = Integer.MAX_VALUE;
				List<BoardObject> keysForShortestShots = new ArrayList<>();
				for (BoardObject target : pathsToTargets.keySet()) {
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
				pathsToTargets.keySet().retainAll(keysForShortestShots);
			}

			List<BoardObject> keys = new ArrayList<>(pathsToTargets.keySet());
			Path path = pathsToTargets.get(keys.get(new Random().nextInt(keys.size())));
			commands = pathToCommandsConverter.generateCommandsFromPath(path, myUnit.getMoves());
		}

		return commands;
	}
}