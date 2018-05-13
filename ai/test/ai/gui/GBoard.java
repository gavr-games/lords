package ai.gui;

import ai.game.board.BoardCell;
import ai.game.board.BoardObject;
import ai.game.board.BoardObjectType;
import ai.game.Player;
import ai.game.board.Unit;


import javax.swing.*;

import java.awt.*;
import java.util.ArrayList;
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
		Unit myUnit = getMyUnit();

		if(myUnit != null)
			return new TestProperties(myUnit, getObstacles(), getEnemies());
		else
			return null;
	}

	private static Unit getMyUnit() {
		List<BoardCell> myUnitCells = getMyUnitCells();

		if(!myUnitCells.isEmpty()) {
			Unit myUnit = new Unit(0, myPlayer,20000, false);
			for(BoardCell cell : myUnitCells) {
				myUnit.addCell(cell);
			}
			return myUnit;
		}
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
				BoardObject obstacle = new BoardObject(i++, BoardObjectType.OBSTACLE, enemyPlayer);
				obstacle.addCell(new BoardCell(gbc.x, gbc.y));
				obstacles.add(obstacle);
			}
		}

		return obstacles;
	}

	private static List<BoardObject> getEnemies() {
		List<BoardObject> enemies = new ArrayList<>();
		int i = 1000;
		for(GBoardCell gbc : gBoardCells) {
			if(gbc.getType() == GBoardCellType.ENEMY) {
				BoardObject enemy = new BoardObject(i++, BoardObjectType.UNIT, enemyPlayer);
				enemy.addCell(new BoardCell(gbc.x, gbc.y));
				enemies.add(enemy);
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
