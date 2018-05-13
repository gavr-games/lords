package ai.ailogic;

import ai.command.Command;
import ai.command.EndTurnCommand;
import ai.game.board.Board;
import ai.game.board.BoardCell;
import ai.game.board.BoardObject;
import ai.game.board.Unit;
import ai.paths_finding.PathsFinderConnector;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Random;

public class MultiTargetUnitAI extends UnitMovingAttackingAI {
    private List<BoardObject> targets;
    private Board board;
    private Unit myUnit;

    public MultiTargetUnitAI(Board board, Unit myUnit, List<BoardObject> targets) {

        this.targets = targets;
        this.board = board;
        this.myUnit = myUnit;
    }

    //Main AI method
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

            finalPath = pathsToTargets.get(keysForShortestPaths.get(new Random().nextInt(keysForShortestPaths.size())));
			commands = generateCommandsFromPath(finalPath);
        }

        if(commands.size() < myUnit.getMoves())
            return commands;
        else
            return commands.subList(0, myUnit.getMoves());

    }
}