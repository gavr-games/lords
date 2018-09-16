package ai;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import ai.ailogic.MultiTargetUnitAI;
import ai.ailogic.UnitMovingAttackingPathConverter;
import ai.command.Command;
import ai.command.EndTurnCommand;
import ai.command.UnitAttackCommand;
import ai.command.UnitMoveCommand;
import ai.game.Player;
import ai.game.board.*;
import org.junit.BeforeClass;
import org.junit.Test;

public class MultiTargetUnitAITest
{
	private static Player myPlayer;
	private static Player enemyPlayer;
	
	@BeforeClass
	public static void initPlayers()
	{
		myPlayer = new Player(0,0,0);
		enemyPlayer = new Player(1,1,1);
	}
	
	private Board prepareBoard(int sizeX, int sizeY, Unit me, BoardObject obstacle, BoardObject enemy)
	{
		List<BoardObject> objects = new ArrayList<>();
		objects.add(me);
		objects.add(enemy);
		if(obstacle != null)
		{
			objects.add(obstacle);
		}
		return new Board(sizeX,sizeY,objects);
	}

	private Board prepareBoard(Unit me, BoardObject obstacle, BoardObject enemy)
	{
		return prepareBoard(20,20,me,obstacle,enemy);
	}
	
	private Unit getMe(int x, int y, int moves)
	{
		Unit me = new Unit(1, myPlayer,moves, false);
		me.addCell(new BoardCell(x,y));
		return me;
	}

	private Unit getMe(int x, int y)
	{
		return getMe(x,y,20);
	}

	private Unit getMeDragon(int x, int y)
	{
		Unit me = new Unit(1,myPlayer,20, false);
		me.addCell(new BoardCell(x,y));
		me.addCell(new BoardCell(x+1,y));
		me.addCell(new BoardCell(x,y+1));
		me.addCell(new BoardCell(x+1,y+1));
		return me;
	}

	private MultiTargetUnitAI getAi(Board board, Unit myUnit, List<BoardObject> targets) {
		return new MultiTargetUnitAI(board, myUnit, targets, new UnitMovingAttackingPathConverter());
	}
	
	private Unit getEnemy(int x, int y)
	{
		return getEnemy(x, y, 10);
	}

	private Unit getEnemy(int x, int y, int id)
	{
		Unit enemy = new Unit(id, enemyPlayer, 1, false);
		enemy.addCell(new BoardCell(x,y));
		return enemy;
	}
	
	private BoardObject getObstacle(int[][] coords)
	{
		BoardObject obstacle = new BoardObject(3,BoardObjectType.OBSTACLE,enemyPlayer);
		for (int[] coord : coords) {
			obstacle.addCell(new BoardCell(coord[0], coord[1]));
		}
		return obstacle;
	}
	
	@Test
	public void test_simple_move()
	{
		Unit me = getMe(0,3,1);
		Unit enemy = getEnemy(2,1);
		
		Board b = prepareBoard(4,4,me,null,enemy);
		
		MultiTargetUnitAI ai = getAi(b, me, Collections.singletonList(enemy));
		List<Command> cmds = ai.getCommands();
		
		assertTrue(cmds.size() == 1);
		
		assertTrue(cmds.get(0) instanceof UnitMoveCommand);
		UnitMoveCommand c1 = (UnitMoveCommand)cmds.get(0);
		assertEquals(c1.getTo(),new BoardCell(1,2));
	}

	@Test
	public void test_simple_move_attack()
	{
		Unit me = getMe(0,3,2);
		Unit enemy = getEnemy(2,1);
		
		Board b = prepareBoard(4,4,me,null,enemy);
		
		MultiTargetUnitAI ai = getAi(b, me, Collections.singletonList(enemy));
		List<Command> cmds = ai.getCommands();
		
		assertTrue(cmds.size() == 2);
		
		assertTrue(cmds.get(0) instanceof UnitMoveCommand);
		UnitMoveCommand c1 = (UnitMoveCommand)cmds.get(0);
		assertEquals(c1.getTo(),new BoardCell(1,2));
		
		assertTrue(cmds.get(1) instanceof UnitAttackCommand);
		UnitAttackCommand c2 = (UnitAttackCommand)cmds.get(1);
		assertEquals(c2.getTo(),new BoardCell(2,1));
	}

	@Test
	public void test_with_obstacle()
	{
		Unit me = getMe(0,2);
		Unit enemy = getEnemy(2,0);
		int[][] obstacleCoords = {{1,1}};
		BoardObject obstacle = getObstacle(obstacleCoords);
		int howManyMovesShouldBe = 3;
		
		Board b = prepareBoard(me,obstacle,enemy);
		
		MultiTargetUnitAI ai = getAi(b, me, Collections.singletonList(enemy));
		List<Command> cmds = ai.getCommands();
		
		assertHitsOneCellAimInNumberOfMoves(cmds, howManyMovesShouldBe, enemy);
	}

	@Test
	public void test_two_targets()
	{
		Unit me = getMe(2,0);
		Unit enemy = getEnemy(0,1,10);
		Unit enemy2 = getEnemy(2,3,11);
		int howManyMovesShouldBe = 2;
		
		Board b = prepareBoard(me,enemy2,enemy);
		
		MultiTargetUnitAI ai = getAi(b, me, Arrays.asList(enemy,enemy2));
		List<Command> cmds = ai.getCommands();
		
		assertHitsOneCellAimInNumberOfMoves(cmds, howManyMovesShouldBe, enemy);
	}

	@Test
	public void test_complex_obstacle()
	{
		Unit me = getMe(0,3);
		Unit enemy = getEnemy(3,0);
		int[][] obstacleCoords = {{0,2},{1,2},{2,2},{2,0},{3,1}};
		BoardObject obstacle = getObstacle(obstacleCoords);
		int howManyMovesShouldBe = 5;
		
		Board b = prepareBoard(me,obstacle,enemy);
		
		MultiTargetUnitAI ai = getAi(b, me, Collections.singletonList(enemy));
		List<Command> cmds = ai.getCommands();
		
		assertHitsOneCellAimInNumberOfMoves(cmds, howManyMovesShouldBe, enemy);
	}

	@Test
	public void test_no_path()
	{
		Unit me = getMe(0,2);
		Unit enemy = getEnemy(1,0);
		int[][] obstacleCoords = {{0,1},{1,1},{2,1}};
		BoardObject obstacle = getObstacle(obstacleCoords);
		
		Board b = prepareBoard(3,3,me,obstacle,enemy);
		
		MultiTargetUnitAI ai = getAi(b, me, Collections.singletonList(enemy));
		List<Command> cmds = ai.getCommands();
		
		assertTrue(cmds.size() == 1);
		assertTrue(cmds.get(0) instanceof EndTurnCommand);
	}

	@Test
	public void test_attack_nearest_cell_in_big_target()
	{
		Unit me = getMe(0,3);
		int[][] obstacleCoords = {{1,0},{2,0},{2,1}};
		BoardObject obstacle = getObstacle(obstacleCoords);
		Unit fictiveEnemy = getEnemy(2,1);
		int howManyMovesShouldBe = 2;
		
		Board b = prepareBoard(me,null,obstacle);
		
		MultiTargetUnitAI ai = getAi(b, me, Collections.singletonList(obstacle));
		List<Command> cmds = ai.getCommands();
		
		assertHitsOneCellAimInNumberOfMoves(cmds, howManyMovesShouldBe, fictiveEnemy);
	}

	@Test
	public void test_dragon()
	{
		Unit me = getMeDragon(0,4);
		int[][] obstacleCoords = {{2,1},{0,3}};
		BoardObject obstacle = getObstacle(obstacleCoords);
		Unit enemy = getEnemy(2,0);
		int howManyMovesShouldBe = 4;
		
		Board b = prepareBoard(3,6,me,obstacle,enemy);
		
		MultiTargetUnitAI ai = getAi(b, me, Collections.singletonList(enemy));
		List<Command> cmds = ai.getCommands();

		Unit fictiveEnemy = getEnemy(1,0); //this is where Dragon's top left cell shoud attack
		
		assertHitsOneCellAimInNumberOfMoves(cmds, howManyMovesShouldBe, fictiveEnemy);
	}

	@Test
	public void test_dragon_squeze_through_hole()
	{
		Unit me = getMeDragon(0,0);
		int[][] obstacleCoords = {{3,1},{0,3},{1,3}};
		BoardObject obstacle = getObstacle(obstacleCoords);
		Unit enemy = getEnemy(0,5);
		int howManyMovesShouldBe = 5;
		
		Board b = prepareBoard(4,6,me,obstacle,enemy);
		
		MultiTargetUnitAI ai = getAi(b, me, Collections.singletonList(enemy));
		List<Command> cmds = ai.getCommands();

		Unit fictiveEnemy = getEnemy(0,4); //this is where Dragon's top left cell shoud attack
		
		assertHitsOneCellAimInNumberOfMoves(cmds, howManyMovesShouldBe, fictiveEnemy);
	}

	@Test
	public void test_dragon_no_way()
	{
		Unit me = getMeDragon(0,0);
		int[][] obstacleCoords = {{3,1},{3,2},{0,3},{1,3}};
		BoardObject obstacle = getObstacle(obstacleCoords);
		Unit enemy = getEnemy(2,4);
		
		Board b = prepareBoard(4,5,me,obstacle,enemy);
		
		MultiTargetUnitAI ai = getAi(b, me, Collections.singletonList(enemy));
		List<Command> cmds = ai.getCommands();
		
		assertTrue(cmds.size() == 1);
		assertTrue(cmds.get(0) instanceof EndTurnCommand);
	}

	@Test
	public void test_knight_simple_move()
	{
		Unit me = getMe(0,3,1);
		me.addFeature(new BoardObjectFeature("knight"));
		int[][] obstacleCoords = {{2,2}};
		BoardObject obstacle = getObstacle(obstacleCoords);
		Unit enemy = getEnemy(2,1);
		
		Board b = prepareBoard(3,4,me,obstacle,enemy);
		
		MultiTargetUnitAI ai = getAi(b, me, Collections.singletonList(enemy));
		List<Command> cmds = ai.getCommands();
		
		assertTrue(cmds.size() == 1);
		
		assertTrue(cmds.get(0) instanceof UnitMoveCommand);
		UnitMoveCommand c1 = (UnitMoveCommand)cmds.get(0);
		assertEquals(c1.getTo(),new BoardCell(1,1));
	}

	@Test
	public void test_knight_move_attack()
	{
		Unit me = getMe(0,0);
		me.addFeature(new BoardObjectFeature("knight"));
		Unit enemy = getEnemy(2,2);
		int howManyMovesShouldBe = 4;
		
		Board b = prepareBoard(4,4,me,null,enemy);
		
		MultiTargetUnitAI ai = getAi(b, me, Collections.singletonList(enemy));
		List<Command> cmds = ai.getCommands();
		
		assertHitsOneCellAimInNumberOfMoves(cmds, howManyMovesShouldBe, enemy);
	}

	@Test
	public void test_knight_jump_over_obstacles()
	{
		Unit me = getMe(0,3);
		me.addFeature(new BoardObjectFeature("knight"));
		int[][] obstacleCoords = {{0,2},{1,2},{2,2},{3,2},{2,1},{2,0}};
		BoardObject obstacle = getObstacle(obstacleCoords);
		Unit enemy = getEnemy(3,0);
		int howManyMovesShouldBe = 2;
		
		Board b = prepareBoard(4,4,me,obstacle,enemy);
		
		MultiTargetUnitAI ai = getAi(b, me, Collections.singletonList(enemy));
		List<Command> cmds = ai.getCommands();
		
		assertHitsOneCellAimInNumberOfMoves(cmds, howManyMovesShouldBe, enemy);
	}

	@Test
	public void test_knight_no_way()
	{
		Unit me = getMe(0,3);
		me.addFeature(new BoardObjectFeature("knight"));
		int[][] obstacleCoords = {{2,2},{2,3}};
		BoardObject obstacle = getObstacle(obstacleCoords);
		Unit enemy = getEnemy(2,1);
		
		Board b = prepareBoard(3,4,me,obstacle,enemy);
		
		MultiTargetUnitAI ai = getAi(b, me, Collections.singletonList(enemy));
		List<Command> cmds = ai.getCommands();
		
		assertTrue(cmds.size() == 1);
		assertTrue(cmds.get(0) instanceof EndTurnCommand);
	}

	@Test
	public void test_flying()
	{
		Unit me = getMe(0,0);
		me.addFeature(new BoardObjectFeature("flying"));
		int[][] obstacleCoords = {{0,1},{1,0},{1,1}};
		BoardObject obstacle = getObstacle(obstacleCoords);
		Unit enemy = getEnemy(3,3);

		Board b = prepareBoard(4,4,me,obstacle,enemy);

		MultiTargetUnitAI ai = getAi(b, me, Collections.singletonList(enemy));
		List<Command> cmds = ai.getCommands();

		assertTrue(cmds.size() == 2);
		assertHitsOneCellAimInNumberOfMoves(cmds, 2, enemy);
	}

	@Test
	public void test_flying_come_end_turn()
	{
		Unit me = getMe(0,0, 2);
		me.addFeature(new BoardObjectFeature("flying"));
		int[][] obstacleCoords = {{2,0},{2,1},{2,2},{2,3}};
		BoardObject obstacle = getObstacle(obstacleCoords);
		Unit enemy = getEnemy(3,3);

		Board b = prepareBoard(4,4,me,obstacle,enemy);

		MultiTargetUnitAI ai = getAi(b, me, Collections.singletonList(enemy));
		List<Command> cmds = ai.getCommands();

		assertTrue(cmds.size() == 2);
		assertTrue(cmds.get(0) instanceof UnitMoveCommand);
		assertTrue(cmds.get(1) instanceof EndTurnCommand);
	}

	@Test
	public void test_flying_randomness()
	{
		Unit me = getMe(0,1);
		me.addFeature(new BoardObjectFeature("flying"));
		int[][] obstacleCoords = {{1,0},{1,1},{1,2}};
		BoardObject obstacle = getObstacle(obstacleCoords);
		Unit enemy = getEnemy(2,1);

		Board b = prepareBoard(3,3,me,obstacle,enemy);

		MultiTargetUnitAI ai = getAi(b, me, Collections.singletonList(enemy));
		List<Command> cmds = ai.getCommands();
		BoardCell topCell = new BoardCell(2, 0);
		BoardCell bottomCell = new BoardCell(2, 2);
		int topPathCount = 0;
		int bottomPathCount = 0;
		for(int i = 0; i<1000; i++)
		{
			cmds = ai.getCommands();
			BoardCell moveCell = ((UnitMoveCommand)cmds.get(0)).getTo();
			if(moveCell.equals(topCell)) topPathCount++;
			if(moveCell.equals(bottomCell)) bottomPathCount++;
		}
		System.out.println("top="+topPathCount+" bottom="+bottomPathCount);

		assertTrue(topPathCount > 0);
		assertTrue(bottomPathCount > 0);
	}

	@Test
	public void test_dragon_knight()
	{
		Unit me = getMeDragon(0,0);
		me.addFeature(new BoardObjectFeature("knight"));
		int[][] obstacleCoords = {{0,2},{2,0},{2,1},{3,3},{4,2}};
		BoardObject obstacle = getObstacle(obstacleCoords);
		Unit enemy = getEnemy(4,1);
		int howManyMovesShouldBe = 2;
		
		Board b = prepareBoard(5,4,me,obstacle,enemy);
		
		MultiTargetUnitAI ai = getAi(b, me, Collections.singletonList(enemy));
		List<Command> cmds = ai.getCommands();

		Unit fictiveEnemy = getEnemy(3,1); //this is where Dragon's top left cell shoud attack
		
		assertHitsOneCellAimInNumberOfMoves(cmds, howManyMovesShouldBe, fictiveEnemy);
	}

	@Test
	public void test_path_randomness()
	{
		Unit me = getMe(1,0);
		Unit enemy = getEnemy(1,2);
		int leftPathCount = 0;
		BoardCell leftCell = new BoardCell(0,1);
		int centerPathCount = 0;
		BoardCell centerCell = new BoardCell(1,1);
		int rightPathCount = 0;
		BoardCell rightCell = new BoardCell(2,1);
		
		Board b = prepareBoard(me,null,enemy);
		
		MultiTargetUnitAI ai = getAi(b, me, Collections.singletonList(enemy));
		List<Command> cmds;
		for(int i = 0; i<10000; i++)
		{
			cmds = ai.getCommands();
			BoardCell moveCell = ((UnitMoveCommand)cmds.get(0)).getTo();
			if(moveCell.equals(leftCell)) leftPathCount++;
			if(moveCell.equals(centerCell)) centerPathCount++;
			if(moveCell.equals(rightCell)) rightPathCount++;
		}
		
		System.out.println("left="+leftPathCount+" center="+centerPathCount+" right="+rightPathCount);
		
		assertTrue(leftPathCount > 0);
		assertTrue(centerPathCount > 0);
		assertTrue(rightPathCount > 0);
	}

	@Test
	public void test_path_randomness_dragon()
	{
		Unit me = getMeDragon(1,0);
		Unit enemy = getEnemy(1,3);
		int leftPathCount = 0;
		BoardCell leftCell = new BoardCell(0,1);
		int centerPathCount = 0;
		BoardCell centerCell = new BoardCell(1,1);
		int rightPathCount = 0;
		BoardCell rightCell = new BoardCell(2,1);
		
		Board b = prepareBoard(me,null,enemy);
		
		MultiTargetUnitAI ai = getAi(b, me, Collections.singletonList(enemy));
		List<Command> cmds;
		for(int i = 0; i<10000; i++)
		{
			cmds = ai.getCommands();
			BoardCell moveCell = ((UnitMoveCommand)cmds.get(0)).getTo();
			if(moveCell.equals(leftCell)) leftPathCount++;
			if(moveCell.equals(centerCell)) centerPathCount++;
			if(moveCell.equals(rightCell)) rightPathCount++;
		}
		
		System.out.println("left="+leftPathCount+" center="+centerPathCount+" right="+rightPathCount);
		
		assertTrue(leftPathCount > 0);
		assertTrue(centerPathCount > 0);
		assertTrue(rightPathCount > 0);
	}

	@Test
	public void test_path_randomness_dragon_knight()
	{
		Unit me = getMeDragon(1,0);
		me.addFeature(new BoardObjectFeature("knight"));
		Unit enemy = getEnemy(2,5);
		int leftPathCount = 0;
		BoardCell leftCell = new BoardCell(0,2);
		int rightPathCount = 0;
		BoardCell rightCell = new BoardCell(2,2);
		
		Board b = prepareBoard(me,null,enemy);
		
		MultiTargetUnitAI ai = getAi(b, me, Collections.singletonList(enemy));
		List<Command> cmds;
		for(int i = 0; i<10000; i++)
		{
			cmds = ai.getCommands();
			BoardCell moveCell = ((UnitMoveCommand)cmds.get(0)).getTo();
			if(moveCell.equals(leftCell)) leftPathCount++;
			if(moveCell.equals(rightCell)) rightPathCount++;
		}
		
		System.out.println("left="+leftPathCount+" right="+rightPathCount);
		
		assertTrue(leftPathCount > 0);
		assertTrue(rightPathCount > 0);
	}
	
	private void assertHitsOneCellAimInNumberOfMoves(List<Command> cmds, int moves, BoardObject aim)
	{
		assertTrue(cmds.size() == moves);
		
		for(int i = 0; i < moves-1; i++)
		{
			assertTrue(cmds.get(i) instanceof UnitMoveCommand);
		}
		
		assertTrue(cmds.get(moves-1) instanceof UnitAttackCommand);
		UnitAttackCommand c = (UnitAttackCommand)cmds.get(moves-1);
		assertEquals(c.getTo(), aim.getCells().get(0));
	}
}