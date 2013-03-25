package ai.paths_finding;

import ai.paths_finding.astar.*;

import java.util.*;

public class PathsFinder {
    private AiBoard aiBoard;


    public PathsFinder(int size_x, int size_y, List<AiBoardObject> objects)  {
        aiBoard = new AiBoard(size_x, size_y, objects);
    }

    public Map<Integer, List<Cell>> searchPaths(int myUnit_hash, List<Integer> targets_hashes, boolean knightMoving) {

        List<AiBoardObject> targets = new ArrayList<>();
        for(int target_hash : targets_hashes)
            targets.add(aiBoard.getObjectByHash(target_hash));

        Map<Integer, List<Cell>> paths = new HashMap<>();


        for(AiBoardObject target : targets) {
            paths.put(target.getHash(), new Astar(aiBoard, aiBoard.getObjectByHash(myUnit_hash), target, knightMoving).search());
            aiBoard.restore();
        }


        return paths;
    }
}
