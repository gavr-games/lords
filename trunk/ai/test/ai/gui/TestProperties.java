package ai.gui;


import ai.BoardObject;

import java.util.List;

public class TestProperties {
    BoardObject me;
    List<BoardObject> obstacles;
    List<BoardObject> enemies;

    public TestProperties(BoardObject me, List<BoardObject> obstacles, List<BoardObject> enemies) {
        this.me = me;
        this.obstacles = obstacles;
        this.enemies = enemies;
    }
}
