package ai;

import ai.ailogic.*;
import ai.command.*;
import ai.game.Game;
import ai.game.Player;
import ai.game.board.*;
import org.junit.Before;
import org.junit.Test;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import static org.junit.Assert.assertTrue;

public class PlayerAiFactoryTest {
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
		myUnit = new Unit(1,myPlayer, 2,false);
		myUnit.addCell(new BoardCell(myUnitX, myUnitY));
		List<BoardObject> boardObjects = new ArrayList<>();
		boardObjects.add(myUnit);
		Board board = new Board(20, 20, boardObjects);
		game = new Game(Arrays.asList(myPlayer, otherPlayer), board);
		game.setId(1);
	}

	private void addTrollHouse(int x, int y){
		int trollHouseId = 1;
		BoardObject trollHouse = new BoardObject(trollHouseId, BoardObjectType.OBSTACLE, otherPlayer);
		trollHouse.addCell(new BoardCell(x, y));
		game.getBoard().getObjects().add(trollHouse);
		myUnit.addFeature(new BoardObjectFeature("parent_building", Integer.toString(trollHouseId)));
	}

	private void addBuilding(int x, int y, Player p) {
		BoardObject b = new BoardObject(50, BoardObjectType.BUILDING, p);
		b.addCell(new BoardCell(x, y));
		game.getBoard().getObjects().add(b);
	}

	@Test
	public void testTrollAttackBuilding() {
		addBuilding(myUnitX - 2, myUnitY, otherPlayer);
		PlayerAI ai = PlayerAIFactory.createPlayerAI(game, myPlayerNum);
		assertTrue(ai instanceof MultiTargetUnitAI);
		List<Command> cmds = ai.getCommands();
		assertTrue(cmds.size() == 2);
		assertTrue(cmds.get(0) instanceof UnitMoveCommand);
		assertTrue(cmds.get(1) instanceof UnitAttackCommand);
	}

	@Test
	public void testTrollNoBuildingsMoveHomeFar() {
		addTrollHouse(myUnitX - 5, myUnitY);
		PlayerAI ai = PlayerAIFactory.createPlayerAI(game, myPlayerNum);
		List<Command> cmds = ai.getCommands();
		assertTrue(cmds.size() == 2);
		assertTrue(cmds.get(0) instanceof UnitMoveCommand);
		assertTrue(cmds.get(1) instanceof UnitMoveCommand);
	}

	@Test
	public void testTrollNoBuildingsMoveHomeClose() {
		addTrollHouse(myUnitX - 2, myUnitY);
		PlayerAI ai = PlayerAIFactory.createPlayerAI(game, myPlayerNum);
		List<Command> cmds = ai.getCommands();
		assertTrue(cmds.size() == 2);
		assertTrue(cmds.get(0) instanceof UnitMoveCommand);
		assertTrue(cmds.get(1) instanceof EndTurnCommand);
	}

	@Test
	public void testTrollNoBuildingsAtHomeEndTurn() {
		addTrollHouse(myUnitX - 1, myUnitY);
		PlayerAI ai = PlayerAIFactory.createPlayerAI(game, myPlayerNum);
		List<Command> cmds = ai.getCommands();
		assertTrue(cmds.size() == 1);
		assertTrue(cmds.get(0) instanceof EndTurnCommand);
	}

	private void addUnit(int x, int y, int id) {
		Unit u = new Unit(id, otherPlayer, 2,false);
		u.addCell(new BoardCell(x, y));
		game.getBoard().getObjects().add(u);
	}

	@Test
	public void testTrollAgred() {
		int otherUnitId = 5;
		addUnit(myUnitX + 2, myUnitY, otherUnitId);
		myUnit.addFeature(new BoardObjectFeature("attack_target", Integer.toString(otherUnitId)));
		PlayerAI ai = PlayerAIFactory.createPlayerAI(game, myPlayerNum);
		assertTrue(ai instanceof MultiTargetUnitAI);
		List<Command> cmds = ai.getCommands();
		assertTrue(cmds.size() == 2);
		assertTrue(cmds.get(0) instanceof UnitMoveCommand);
		assertTrue(cmds.get(1) instanceof UnitAttackCommand);
	}

	@Test
	public void testParalyzed() {
		myUnit.addFeature(new BoardObjectFeature("paralich"));
		PlayerAI ai = PlayerAIFactory.createPlayerAI(game, myPlayerNum);
		assertTrue(ai instanceof EndTurningAI);
		List<Command> cmds = ai.getCommands();
		assertTrue(cmds.size() == 1);
		assertTrue(cmds.get(0) instanceof EndTurnCommand);
	}

	@Test
	public void testVampireAttacksBuildings() {
		myPlayer.setOwner(4); //vampire
		addBuilding(myUnitX+1, myUnitY, otherPlayer);
		PlayerAI ai = PlayerAIFactory.createPlayerAI(game, myPlayerNum);
		assertTrue(ai instanceof VampireAI);
		List<Command> cmds = ai.getCommands();
		assertTrue(cmds.size() == 1);
		assertTrue(cmds.get(0) instanceof UnitAttackCommand);
	}

	@Test
	public void testVampireAttacksUnits() {
		myPlayer.setOwner(4); //vampire
		addUnit(myUnitX+1, myUnitY, 20);
		PlayerAI ai = PlayerAIFactory.createPlayerAI(game, myPlayerNum);
		assertTrue(ai instanceof VampireAI);
		List<Command> cmds = ai.getCommands();
		assertTrue(cmds.size() == 1);
		assertTrue(cmds.get(0) instanceof UnitAttackCommand);
	}

	@Test
	public void testFrogAttacksUnits() {
		myPlayer.setOwner(2); //frog
		addUnit(myUnitX+1, myUnitY, 20);
		PlayerAI ai = PlayerAIFactory.createPlayerAI(game, myPlayerNum);
		assertTrue(ai instanceof MultiTargetUnitAI);
		List<Command> cmds = ai.getCommands();
		assertTrue(cmds.size() == 1);
		assertTrue(cmds.get(0) instanceof UnitAttackCommand);
	}

	@Test
	public void testFrogIgnoresBuilding() {
		myPlayer.setOwner(2); //frog
		addBuilding(myUnitX+1, myUnitY, otherPlayer);
		PlayerAI ai = PlayerAIFactory.createPlayerAI(game, myPlayerNum);
		assertTrue(ai instanceof EndTurningAI);
		List<Command> cmds = ai.getCommands();
		assertTrue(cmds.size() == 1);
		assertTrue(cmds.get(0) instanceof EndTurnCommand);
	}

	@Test
	public void testAiWithObjectsWithNullPlayer() {
		addBuilding(myUnitX+1, myUnitY, null);
		PlayerAI ai = PlayerAIFactory.createPlayerAI(game, myPlayerNum);
		assertTrue(ai instanceof MultiTargetUnitAI);
		List<Command> cmds = ai.getCommands();
		assertTrue(cmds.size() == 1);
		assertTrue(cmds.get(0) instanceof UnitAttackCommand);
	}

	@Test
	public void testLevelUp() {
		myUnit.setCanLevelUp(true);
		PlayerAI ai = PlayerAIFactory.createPlayerAI(game, myPlayerNum);
		assertTrue(ai instanceof LevelUpAI);
		List<Command> cmds = ai.getCommands();
		assertTrue(cmds.size() == 1);
		assertTrue(cmds.get(0) instanceof LevelUpCommand);
	}


}