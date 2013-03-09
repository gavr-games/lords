package ai.gui;

import ai.BoardObject;
import ai.BoardObjectType;
import ai.Player;

import javax.swing.*;
import java.awt.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class Board extends JPanel{

    public Board() {
        setLayout(new GridBagLayout());
        setBackground(new Color(73, 73, 73));
        fillBoard();
    }

    private void fillBoard() {
        for(int x = 0; x < 20; x++)
            for(int y = 0; y < 20; y++) {
                BoardCell cell = createBoardCell(x, y);
                add(cell, cell.getDefaultGridBagConstraints());
            }

    }

    private BoardCell createBoardCell(int x, int y) {
        BoardCell cell = new BoardCell(x, y);
        cell.setBackground(new Color(60, 182, 22));
        cell.setPreferredSize(new Dimension(5,5));
        cell.addMouseListener(new CellListener());
        return cell;
    }

    public TestProperties getTestProperties() {
        Player myPlayer = new Player(0,0,0);
        Player enemyPlayer = new Player(1,1,1);
        BoardObject me = null;
        List<BoardObject> obstacles = new ArrayList<>();
        List<ai.BoardCell> myUnitCells = new ArrayList<>();
        List<BoardObject> enemies = new ArrayList<>();

        Component[] components = getComponents();

        for(Component component : components) {
            BoardCell bc = (BoardCell)component;
            if(bc.getBackground() == TesterGUI.MY_UNIT) {
                myUnitCells.add(new ai.BoardCell(bc.x, bc.y));
            }
        }

        if(!myUnitCells.isEmpty())
            me = new BoardObject(0, BoardObjectType.UNIT, myPlayer, myUnitCells, 200);

        for(int i=0; i < components.length; i++) {
            BoardCell bc = (BoardCell)components[i];
            if(bc.getBackground() == TesterGUI.OBSTACLE) {
                obstacles.add(new BoardObject(i+1, BoardObjectType.OBSTACLE, enemyPlayer,
                        Collections.singletonList(new ai.BoardCell(bc.x, bc.y)), 0));
            }
            else if(bc.getBackground() == TesterGUI.ENEMY) {
                enemies.add(new BoardObject(i+1, BoardObjectType.UNIT, enemyPlayer,
                        Collections.singletonList(new ai.BoardCell(bc.x, bc.y)), 0));
            }
        }

        TestProperties testProperties = null;

        if(me != null)
             testProperties = new TestProperties(me, obstacles, enemies);

        return testProperties;
    }

}
