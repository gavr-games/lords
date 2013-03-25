package ai.gui;

import ai.BoardCell;
import ai.BoardObject;
import ai.BoardObjectType;
import ai.Player;


import javax.swing.*;

import java.awt.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class GBoard extends JPanel {
    public static final Color MY_UNIT = Color.BLUE;
    public static final Color OBSTACLE = Color.BLACK;
    public static final Color ENEMY = Color.RED;
    public static final Color EMPTY = new Color(60, 182, 22);
    public static final Color PATH = Color.CYAN;
    public static final Color ATTACKED = new Color(193, 0, 193);
    private static Player myPlayer;
    private static Player enemyPlayer;

    private static List<GBoardCell> gBoardCells = new ArrayList<>();

    public GBoard() {
        setLayout(new GridLayout(20,20));
        setBackground(new Color(73, 73, 73));
        fill();
    }

    private void fill() {
        for(int x = 0; x < 20; x++)
            for(int y = 0; y < 20; y++) {
                GBoardCell cell = new GBoardCell(x, y);
                add(cell);
                gBoardCells.add(cell);
            }
    }

    public static TestProperties getTestProperties() {
        myPlayer = new Player(0,0,0);
        enemyPlayer = new Player(1,1,1);
        BoardObject myUnit = getMyUnit();

        if(myUnit != null)
            return new TestProperties(myUnit, getObstacles(), getEnemies());
        else
            return null;
    }

    private static BoardObject getMyUnit() {
        List<BoardCell> myUnitCells = getMyUnitCells();

        if(!myUnitCells.isEmpty())
            return new BoardObject(0, BoardObjectType.UNIT, myPlayer, getMyUnitCells(), 20000);
        else
            return null;
    }

    private static List<BoardCell> getMyUnitCells() {
        List<BoardCell> myUnitCells = new ArrayList<>();

        for(GBoardCell gbc : gBoardCells)
            if (gbc.getType() == GBoardCellType.MY_UNIT)
                myUnitCells.add(new BoardCell(gbc.x, gbc.y));

        return myUnitCells;
    }

    private static List<BoardObject> getObstacles() {
        List<BoardObject> obstacles = new ArrayList<>();
        int i = 10;
        for(GBoardCell gbc : gBoardCells) {
            if(gbc.getType() == GBoardCellType.OBSTACLE) {
                obstacles.add(new BoardObject(i++, BoardObjectType.OBSTACLE, enemyPlayer,
                        Collections.singletonList(new BoardCell(gbc.x, gbc.y)), 0));
            }
        }

        return obstacles;
    }

    private static List<BoardObject> getEnemies() {
        List<BoardObject> enemies = new ArrayList<>();
        int i = 1000;
        for(GBoardCell gbc : gBoardCells) {
            if(gbc.getType() == GBoardCellType.ENEMY) {
                enemies.add(new BoardObject(i++, BoardObjectType.UNIT, enemyPlayer,
                        Collections.singletonList(new BoardCell(gbc.x, gbc.y)), 0));
            }
        }

        return enemies;
    }

    public static void markPathCell(int x, int y) {
        int componentNumber = x*20 + y;
        GBoardCell gbc = gBoardCells.get(componentNumber);
        if(gbc.getType() == GBoardCellType.ENEMY)
            gbc.setBackground(ATTACKED);
        else gbc.setType(GBoardCellType.PATH);
    }

    public static void clearAll() {
        for(GBoardCell gbc : gBoardCells) {
            gbc.setType(GBoardCellType.EMPTY);
        }
    }

    public static void clearPath() {
        for(GBoardCell gbc : gBoardCells) {
            if(gbc.getType() == GBoardCellType.PATH) {
                gbc.setType(GBoardCellType.EMPTY);
            }
            else if(gbc.getType() == GBoardCellType.ENEMY) {
                gbc.setBackground(ENEMY);
            }
        }
    }

    public static void shadePreviousPaths() {
        for(GBoardCell gbc : gBoardCells)
            if(gbc.getType() == GBoardCellType.PATH)
                gbc.setBackground(new Color(14, 197, 158));
    }


}
