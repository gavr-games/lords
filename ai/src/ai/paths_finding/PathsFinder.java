package ai.paths_finding;

import ai.paths_finding.astar.AiBoard;
import ai.paths_finding.astar.AiBoardObject;
import ai.paths_finding.astar.Astar;
import ai.paths_finding.astar.Cell;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class PathsFinder {
    private AiBoard aiBoard;


    public PathsFinder(int size_x, int size_y, List<AiBoardObject> objects)  {
        aiBoard = new AiBoard(size_x, size_y, objects);
    }

    public Map<Integer, List<Cell>> searchPaths(int myUnit_id, List<Integer> targets_id, boolean knightMoving) {

        List<AiBoardObject> targets = new ArrayList<>();
        for(int target_id : targets_id)
            targets.add(aiBoard.getObjectById(target_id));

        Map<Integer, List<Cell>> paths = new HashMap<>();


        for(AiBoardObject target : targets) {
            paths.put(target.getId(), new Astar(aiBoard, aiBoard.getObjectById(myUnit_id), target, knightMoving).search());
        }


        return paths;
    }
}
