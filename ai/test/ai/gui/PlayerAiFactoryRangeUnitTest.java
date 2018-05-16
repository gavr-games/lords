package ai.gui;

import ai.ailogic.*;
import ai.command.*;
import ai.game.Game;
import ai.game.Player;
import ai.game.board.*;
import org.junit.Before;
import org.junit.Test;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import static org.junit.Assert.assertTrue;

public class PlayerAiFactoryRangeUnitTest {
	private Game game;
	private final static int myPlayerNum = 1;
	private final static int myUnitX = 10;
	private final static int myUnitY = 10;
	private Player myPlayer;
	private Unit myUnit;
	private Player otherPlayer;

	@Before
	public void setup() {
		myPlayer = new Player(myPlayerNum, 3, 0);
		otherPlayer = new Player(5, 0, 1);
		myUnit = new RangeUnit(1,myPlayer, 2,false, 2, 3, Collections.singletonList(BoardObjectType.UNIT));
		myUnit.addCell(new BoardCell(myUnitX, myUnitY));
		List<BoardObject> boardObjects = new ArrayList<>();
		boardObjects.add(myUnit);
		Board board = new Board(20, 20, boardObjects);
		game = new Game(Arrays.asList(myPlayer, otherPlayer), board);
		game.setId(1);
	}

	private void addObstacle(int x, int y) {
		BoardObject b = new BoardObject(11, BoardObjectType.OBSTACLE, null);
		b.addCell(new BoardCell(x, y));
		game.getBoard().getObjects().add(b);
	}

	private void addObstacleBox(int xleft, int ytop, int xright, int ybottom) {
		for (int i = 0; i < game.getBoard().getSizeX(); i++) {
			for (int j = 0; j < game.getBoard().getSizeY(); j++) {
				if ((i == xleft || i == xright) && (j == ytop || j == ybottom)) {
					addObstacle(i, j);
				}
			}
		}
	}

	private void addBuilding(int x, int y, Player p) {
		BoardObject b = new BoardObject(50, BoardObjectType.BUILDING, p);
		b.addCell(new BoardCell(x, y));
		game.getBoard().getObjects().add(b);
	}

	private void addUnit(int x, int y) {
		BoardObject b = new Unit(50, otherPlayer, 1, false);
		b.addCell(new BoardCell(x, y));
		game.getBoard().getObjects().add(b);
	}

	@Test
	public void testWalkTowardsAndShoot() {
		addUnit(myUnitX + 4, myUnitY + 4);
		PlayerAI ai = PlayerAIFactory.createPlayerAI(game, myPlayerNum);
		List<Command> cmds = ai.getCommands();
		assertTrue(cmds.size() == 2);
		assertTrue(cmds.get(0) instanceof UnitMoveCommand);
		BoardCell moveFrom = ((UnitMoveCommand) cmds.get(0)).getFrom();
		BoardCell moveTo = ((UnitMoveCommand) cmds.get(0)).getTo();
		assertTrue(moveFrom.x == myUnitX && moveFrom.y == myUnitY);
		assertTrue(moveTo.x == myUnitX + 1 && moveTo.y == myUnitY + 1);
		assertTrue(cmds.get(1) instanceof ShootCommand);
		BoardCell shootFrom = ((ShootCommand) cmds.get(1)).getFrom();
		BoardCell shootTo = ((ShootCommand) cmds.get(1)).getTo();
		assertTrue(shootFrom.x == myUnitX + 1 && shootFrom.y == myUnitY + 1);
		assertTrue(shootTo.x == myUnitX + 4 && shootTo.y == myUnitY + 4);
	}

	@Test
	public void testWalkAwayAndShoot() {
		addUnit(myUnitX + 1, myUnitY);
		PlayerAI ai = PlayerAIFactory.createPlayerAI(game, myPlayerNum);
		List<Command> cmds = ai.getCommands();
		assertTrue(cmds.size() == 2);
		assertTrue(cmds.get(0) instanceof UnitMoveCommand);
		assertTrue(cmds.get(1) instanceof ShootCommand);
	}

	@Test
	public void testInShootingDistance() {
		addUnit(myUnitX + 3, myUnitY);
		PlayerAI ai = PlayerAIFactory.createPlayerAI(game, myPlayerNum);
		List<Command> cmds = ai.getCommands();
		assertTrue(cmds.size() == 1);
		assertTrue(cmds.get(0) instanceof ShootCommand);
	}

	@Test
	public void testShootClosest() {
		addUnit(myUnitX + 3, myUnitY);
		addUnit(myUnitX - 2, myUnitY);
		PlayerAI ai = PlayerAIFactory.createPlayerAI(game, myPlayerNum);
		List<Command> cmds = ai.getCommands();
		assertTrue(cmds.size() == 1);
		assertTrue(cmds.get(0) instanceof ShootCommand);
		BoardCell shootTo = ((ShootCommand) cmds.get(0)).getTo();
		assertTrue(shootTo.x == myUnitX - 2 && shootTo.y == myUnitY);
	}

	@Test
	public void testWalkTowardsAndShootObstacle() {
		addUnit(myUnitX + 4, myUnitY);
		addObstacleBox(myUnitX - 2, myUnitY - 2, myUnitX + 2, myUnitY + 2);
		PlayerAI ai = PlayerAIFactory.createPlayerAI(game, myPlayerNum);
		List<Command> cmds = ai.getCommands();
		assertTrue(cmds.size() == 2);
		assertTrue(cmds.get(0) instanceof UnitMoveCommand);
		assertTrue(cmds.get(1) instanceof ShootCommand);
	}

	@Test
	public void testWalkTowardsAndShootClosestObstacle() {
		addUnit(myUnitX + 4, myUnitY);
		addUnit(myUnitX - 5, myUnitY);
		addObstacleBox(myUnitX - 7, myUnitY - 2, myUnitX + 2, myUnitY + 2);
		PlayerAI ai = PlayerAIFactory.createPlayerAI(game, myPlayerNum);
		List<Command> cmds = ai.getCommands();
		assertTrue(cmds.size() == 2);
		assertTrue(cmds.get(0) instanceof UnitMoveCommand);
		assertTrue(cmds.get(1) instanceof ShootCommand);
		BoardCell shootTo = ((ShootCommand) cmds.get(1)).getTo();
		assertTrue(shootTo.x == myUnitX + 4 && shootTo.y == myUnitY);
	}

	@Test
	public void testEndTurnInObstacle() {
		addUnit(myUnitX + 7, myUnitY);
		addObstacleBox(myUnitX - 2, myUnitY - 2, myUnitX + 2, myUnitY + 2);
		PlayerAI ai = PlayerAIFactory.createPlayerAI(game, myPlayerNum);
		List<Command> cmds = ai.getCommands();
		assertTrue(cmds.size() == 1);
		assertTrue(cmds.get(0) instanceof EndTurnCommand);
	}

	@Test
	public void testIgnoreBuilding() {
		addBuilding(myUnitX + 3, myUnitY, otherPlayer);
		PlayerAI ai = PlayerAIFactory.createPlayerAI(game, myPlayerNum);
		List<Command> cmds = ai.getCommands();
		assertTrue(cmds.size() == 1);
		assertTrue(cmds.get(0) instanceof EndTurnCommand);
	}

	@Test
	public void testShootingVampire() {
		//TODO test archer vampire, catapult vampire
	}
}