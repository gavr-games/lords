package ai.ailogic;

import ai.command.Command;
import ai.command.EndTurnCommand;
import ai.game.board.*;
import ai.paths_finding.PathsFinderConnector;

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

		Map<BoardObject, List<BoardCell>> pathsToTargets = PathsFinderConnector.getPaths(board, myUnit, targets);

		List<Command> commands;
		List<BoardObject> keysForShortestPaths;
		List<BoardCell> finalPath;
		int minPathLength = 10000;

		if (pathsToTargets.isEmpty()) {
			commands = new ArrayList<>();
			commands.add(new EndTurnCommand());
		} else {

			keysForShortestPaths = new ArrayList<>();
			for(BoardObject target : targets) {
				if(pathsToTargets.get(target) != null) {
					if (pathsToTargets.get(target).size() < minPathLength) {
						minPathLength = pathsToTargets.get(target).size();
						keysForShortestPaths.clear();
						keysForShortestPaths.add(target);
					} else if(pathsToTargets.get(target).size() == minPathLength) {
						keysForShortestPaths.add(target);
					}
				}
			}

			if (myUnit instanceof RangeUnit) {
				int minShootDistance = Integer.MAX_VALUE;
				List<BoardObject> keysForShortestShots = new ArrayList<>();
				for (BoardObject target : keysForShortestPaths) {
					List<BoardCell> path = pathsToTargets.get(target);
					BoardCell shootingPosition = path.get(path.size() - 2);
					int dist = myUnit.hypotheticalCopyAtPosition(shootingPosition).distanceTo(target);
					if (dist < minShootDistance) {
						minShootDistance = dist;
						keysForShortestShots.clear();
						keysForShortestShots.add(target);
					} else if (dist == minShootDistance) {
						keysForShortestShots.add(target);
					}
				}
				keysForShortestPaths = keysForShortestShots;
			}

			finalPath = pathsToTargets.get(keysForShortestPaths.get(new Random().nextInt(keysForShortestPaths.size())));
			commands = pathToCommandsConverter.generateCommandsFromPath(finalPath);
		}

		if(commands.size() < myUnit.getMoves())
			return commands;
		else
			return commands.subList(0, myUnit.getMoves());

	}
}