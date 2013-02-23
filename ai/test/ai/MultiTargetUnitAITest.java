package ai;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
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
	
	private Board prepareBoard(int sizeX, int sizeY, BoardObject me, BoardObject obstacle, BoardObject enemy)
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

	private Board prepareBoard(BoardObject me, BoardObject obstacle, BoardObject enemy)
	{
		return prepareBoard(20,20,me,obstacle,enemy);
	}
	
	private BoardObject getMe(int x, int y, int moves)
	{
		BoardObject me = new BoardObject(1,BoardObjectType.UNIT,myPlayer,Collections.singletonList(new BoardCell(x,y)),moves);
		return me;
	}

	private BoardObject getMe(int x, int y)
	{
		return getMe(x,y,20);
	}

	private BoardObject getMeDragon(int x, int y)
	{
		List<BoardCell> cells = new ArrayList<>();
		cells.add(new BoardCell(x,y));
		cells.add(new BoardCell(x+1,y));
		cells.add(new BoardCell(x,y+1));
		cells.add(new BoardCell(x+1,y+1));
		BoardObject me = new BoardObject(1,BoardObjectType.UNIT,myPlayer,cells,20);
		return me;
	}
	
	private BoardObject getEnemy(int x, int y)
	{
		return getEnemy(x, y, 10);
	}

	private BoardObject getEnemy(int x, int y, int id)
	{
		BoardObject enemy = new BoardObject(id,BoardObjectType.UNIT,enemyPlayer,Collections.singletonList(new BoardCell(x,y)),1);
		return enemy;
	}
	
	private BoardObject getObstacle(int[][] coords)
	{
		List<BoardCell> cells = new ArrayList<>();
		for(int i=0; i<coords.length; i++)
		{
			cells.add(new BoardCell(coords[i][0],coords[i][1]));
		}
		BoardObject obstacle = new BoardObject(3,BoardObjectType.OBSTACLE,enemyPlayer,cells,0);
		return obstacle;
	}
	
	@Test
	public void test_simple_move()
	{
		BoardObject me = getMe(0,3,1);
		BoardObject enemy = getEnemy(2,1);
		
		Board b = prepareBoard(4,4,me,null,enemy);
		
		MultiTargetUnitAI ai = new MultiTargetUnitAI(b, me, Collections.singletonList(enemy));
		List<Command> cmds = ai.getCommands();
		
		assertTrue(cmds.size() == 1);
		
		assertTrue(cmds.get(0) instanceof UnitMoveCommand);		
		UnitMoveCommand c1 = (UnitMoveCommand)cmds.get(0);		
		assertEquals(c1.getTo(),new BoardCell(1,2));
	}

	@Test
	public void test_simple_move_attack()
	{
		BoardObject me = getMe(0,3,2);
		BoardObject enemy = getEnemy(2,1);
		
		Board b = prepareBoard(4,4,me,null,enemy);
		
		MultiTargetUnitAI ai = new MultiTargetUnitAI(b, me, Collections.singletonList(enemy));
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
		BoardObject me = getMe(0,2);
		BoardObject enemy = getEnemy(2,0);
		int[][] obstacleCoords = {{1,1}};
		BoardObject obstacle = getObstacle(obstacleCoords);
		int howManyMovesShouldBe = 3;
		
		Board b = prepareBoard(me,obstacle,enemy);
		
		MultiTargetUnitAI ai = new MultiTargetUnitAI(b, me, Collections.singletonList(enemy));
		List<Command> cmds = ai.getCommands();
		
		assertHitsOneCellAimInNumberOfMoves(cmds, howManyMovesShouldBe, enemy);
	}

	@Test
	public void test_two_targets()
	{
		BoardObject me = getMe(2,0);
		BoardObject enemy = getEnemy(0,1,10);
		BoardObject enemy2 = getEnemy(2,3,11);
		int howManyMovesShouldBe = 2;
		
		Board b = prepareBoard(me,enemy2,enemy);
		
		MultiTargetUnitAI ai = new MultiTargetUnitAI(b, me, Arrays.asList(enemy,enemy2));
		List<Command> cmds = ai.getCommands();
		
		assertHitsOneCellAimInNumberOfMoves(cmds, howManyMovesShouldBe, enemy);
	}

	@Test
	public void test_complex_obstacle()
	{
		BoardObject me = getMe(0,3);
		BoardObject enemy = getEnemy(3,0);
		int[][] obstacleCoords = {{0,2},{1,2},{2,2},{2,0},{3,1}};
		BoardObject obstacle = getObstacle(obstacleCoords);
		int howManyMovesShouldBe = 5;
		
		Board b = prepareBoard(me,obstacle,enemy);
		
		MultiTargetUnitAI ai = new MultiTargetUnitAI(b, me, Collections.singletonList(enemy));
		List<Command> cmds = ai.getCommands();
		
		assertHitsOneCellAimInNumberOfMoves(cmds, howManyMovesShouldBe, enemy);
	}

	@Test
	public void test_no_path()
	{
		BoardObject me = getMe(0,2);
		BoardObject enemy = getEnemy(1,0);
		int[][] obstacleCoords = {{0,1},{1,1},{2,1}};
		BoardObject obstacle = getObstacle(obstacleCoords);
		
		Board b = prepareBoard(3,3,me,obstacle,enemy);
		
		MultiTargetUnitAI ai = new MultiTargetUnitAI(b, me, Collections.singletonList(enemy));
		List<Command> cmds = ai.getCommands();
		
		assertTrue(cmds.size() == 1);
		assertTrue(cmds.get(0) instanceof EndTurnCommand);		
	}

	@Test
	public void test_attack_nearest_cell_in_big_target()
	{
		BoardObject me = getMe(0,3);
		int[][] obstacleCoords = {{1,0},{2,0},{2,1}};
		BoardObject obstacle = getObstacle(obstacleCoords);
		BoardObject fictiveEnemy = getEnemy(2,1);
		int howManyMovesShouldBe = 2;
		
		Board b = prepareBoard(me,null,obstacle);
		
		MultiTargetUnitAI ai = new MultiTargetUnitAI(b, me, Collections.singletonList(obstacle));
		List<Command> cmds = ai.getCommands();
		
		assertHitsOneCellAimInNumberOfMoves(cmds, howManyMovesShouldBe, fictiveEnemy);
	}

	@Test
	public void test_dragon()
	{
		BoardObject me = getMeDragon(0,4);
		int[][] obstacleCoords = {{2,1},{0,3}};
		BoardObject obstacle = getObstacle(obstacleCoords);
		BoardObject enemy = getEnemy(2,0);
		int howManyMovesShouldBe = 4;
		
		Board b = prepareBoard(3,6,me,obstacle,enemy);
		
		MultiTargetUnitAI ai = new MultiTargetUnitAI(b, me, Collections.singletonList(enemy));
		List<Command> cmds = ai.getCommands();
		
		BoardObject fictiveEnemy = getEnemy(1,0); //this is where Dragon's top left cell shoud attack
		
		assertHitsOneCellAimInNumberOfMoves(cmds, howManyMovesShouldBe, fictiveEnemy);
	}

	@Test
	public void test_dragon_squeze_through_hole()
	{
		BoardObject me = getMeDragon(0,0);
		int[][] obstacleCoords = {{3,1},{0,3},{1,3}};
		BoardObject obstacle = getObstacle(obstacleCoords);
		BoardObject enemy = getEnemy(0,5);
		int howManyMovesShouldBe = 5;
		
		Board b = prepareBoard(4,6,me,obstacle,enemy);
		
		MultiTargetUnitAI ai = new MultiTargetUnitAI(b, me, Collections.singletonList(enemy));
		List<Command> cmds = ai.getCommands();
		
		BoardObject fictiveEnemy = getEnemy(0,4); //this is where Dragon's top left cell shoud attack
		
		assertHitsOneCellAimInNumberOfMoves(cmds, howManyMovesShouldBe, fictiveEnemy);
	}

	@Test
	public void test_dragon_no_way()
	{
		BoardObject me = getMeDragon(0,0);
		int[][] obstacleCoords = {{3,1},{3,2},{0,3},{1,3}};
		BoardObject obstacle = getObstacle(obstacleCoords);
		BoardObject enemy = getEnemy(2,4);
		
		Board b = prepareBoard(4,5,me,obstacle,enemy);
		
		MultiTargetUnitAI ai = new MultiTargetUnitAI(b, me, Collections.singletonList(enemy));
		List<Command> cmds = ai.getCommands();
		
		assertTrue(cmds.size() == 1);
		assertTrue(cmds.get(0) instanceof EndTurnCommand);		
	}

	@Test
	public void test_knight_simple_move()
	{
		BoardObject me = getMe(0,3,1);
		me.addFeature(new BoardObjectFeature("knight"));
		int[][] obstacleCoords = {{2,2}};
		BoardObject obstacle = getObstacle(obstacleCoords);
		BoardObject enemy = getEnemy(2,1);
		
		Board b = prepareBoard(3,4,me,obstacle,enemy);
		
		MultiTargetUnitAI ai = new MultiTargetUnitAI(b, me, Collections.singletonList(enemy));
		List<Command> cmds = ai.getCommands();
		
		assertTrue(cmds.size() == 1);
		
		assertTrue(cmds.get(0) instanceof UnitMoveCommand);		
		UnitMoveCommand c1 = (UnitMoveCommand)cmds.get(0);		
		assertEquals(c1.getTo(),new BoardCell(1,1));
	}

	@Test
	public void test_knight_move_attack()
	{
		BoardObject me = getMe(0,0);
		me.addFeature(new BoardObjectFeature("knight"));
		BoardObject enemy = getEnemy(2,2);
		int howManyMovesShouldBe = 4;
		
		Board b = prepareBoard(4,4,me,null,enemy);
		
		MultiTargetUnitAI ai = new MultiTargetUnitAI(b, me, Collections.singletonList(enemy));
		List<Command> cmds = ai.getCommands();
		
		assertHitsOneCellAimInNumberOfMoves(cmds, howManyMovesShouldBe, enemy);
	}

	@Test
	public void test_knight_jump_over_obstacles()
	{
		BoardObject me = getMe(0,3);
		me.addFeature(new BoardObjectFeature("knight"));
		int[][] obstacleCoords = {{0,2},{1,2},{2,2},{3,2},{2,1},{2,0}};
		BoardObject obstacle = getObstacle(obstacleCoords);
		BoardObject enemy = getEnemy(3,0);
		int howManyMovesShouldBe = 2;
		
		Board b = prepareBoard(4,4,me,obstacle,enemy);
		
		MultiTargetUnitAI ai = new MultiTargetUnitAI(b, me, Collections.singletonList(enemy));
		List<Command> cmds = ai.getCommands();
		
		assertHitsOneCellAimInNumberOfMoves(cmds, howManyMovesShouldBe, enemy);
	}

	@Test
	public void test_knight_no_way()
	{
		BoardObject me = getMe(0,3);
		me.addFeature(new BoardObjectFeature("knight"));
		int[][] obstacleCoords = {{2,2},{2,3}};
		BoardObject obstacle = getObstacle(obstacleCoords);
		BoardObject enemy = getEnemy(2,1);
		
		Board b = prepareBoard(3,4,me,obstacle,enemy);
		
		MultiTargetUnitAI ai = new MultiTargetUnitAI(b, me, Collections.singletonList(enemy));
		List<Command> cmds = ai.getCommands();
		
		assertTrue(cmds.size() == 1);
		assertTrue(cmds.get(0) instanceof EndTurnCommand);		
	}

	@Test
	public void test_dragon_knight()
	{
		BoardObject me = getMeDragon(0,0);
		me.addFeature(new BoardObjectFeature("knight"));
		int[][] obstacleCoords = {{0,2},{2,0},{2,1},{3,3},{4,2}};
		BoardObject obstacle = getObstacle(obstacleCoords);
		BoardObject enemy = getEnemy(4,1);
		int howManyMovesShouldBe = 2;
		
		Board b = prepareBoard(5,4,me,obstacle,enemy);
		
		MultiTargetUnitAI ai = new MultiTargetUnitAI(b, me, Collections.singletonList(enemy));
		List<Command> cmds = ai.getCommands();
		
		BoardObject fictiveEnemy = getEnemy(3,1); //this is where Dragon's top left cell shoud attack
		
		assertHitsOneCellAimInNumberOfMoves(cmds, howManyMovesShouldBe, fictiveEnemy);
	}

	@Test
	public void test_path_randomness()
	{
		BoardObject me = getMe(1,0);
		BoardObject enemy = getEnemy(1,2);
		int leftPathCount = 0;
		BoardCell leftCell = new BoardCell(0,1);
		int centerPathCount = 0;
		BoardCell centerCell = new BoardCell(1,1);
		int rightPathCount = 0;
		BoardCell rightCell = new BoardCell(2,1);
		
		Board b = prepareBoard(me,null,enemy);
		
		MultiTargetUnitAI ai = new MultiTargetUnitAI(b, me, Collections.singletonList(enemy));
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
		BoardObject me = getMeDragon(1,0);
		BoardObject enemy = getEnemy(1,3);
		int leftPathCount = 0;
		BoardCell leftCell = new BoardCell(0,1);
		int centerPathCount = 0;
		BoardCell centerCell = new BoardCell(1,1);
		int rightPathCount = 0;
		BoardCell rightCell = new BoardCell(2,1);
		
		Board b = prepareBoard(me,null,enemy);
		
		MultiTargetUnitAI ai = new MultiTargetUnitAI(b, me, Collections.singletonList(enemy));
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
		BoardObject me = getMeDragon(1,0);
		me.addFeature(new BoardObjectFeature("knight"));
		BoardObject enemy = getEnemy(2,5);
		int leftPathCount = 0;
		BoardCell leftCell = new BoardCell(0,2);
		int rightPathCount = 0;
		BoardCell rightCell = new BoardCell(2,2);
		
		Board b = prepareBoard(me,null,enemy);
		
		MultiTargetUnitAI ai = new MultiTargetUnitAI(b, me, Collections.singletonList(enemy));
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