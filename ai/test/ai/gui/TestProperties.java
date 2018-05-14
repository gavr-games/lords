package ai.gui;


import ai.game.board.BoardObject;
import ai.game.board.Unit;

import java.util.ArrayList;
import java.util.List;

public class TestProperties {
    private Unit myUnit;
    private List<BoardObject> obstacles;
    private List<BoardObject> enemies;

    public TestProperties(Unit me, List<BoardObject> obstacles, List<BoardObject> enemies) {
        this.myUnit = me;
        this.obstacles = obstacles;
        this.enemies = enemies;
    }

    public List<BoardObject> getAllObjects() {
        List<BoardObject> objects = new ArrayList<>();
        objects.add(myUnit);
        objects.addAll(obstacles);
        objects.addAll(enemies);
        return objects;
    }

    public Unit getMyUnit() {
        return myUnit;
    }

    public List<BoardObject> getEnemies() {
        return enemies;
    }
}
