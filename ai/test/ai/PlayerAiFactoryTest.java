package ai;

import java.util.List;
import org.json.simple.parser.ParseException;
import static org.junit.Assert.assertTrue;
import org.junit.Test;

public class PlayerAiFactoryTest
{
    @Test
    public void testTroll() throws Exception
    {
		//not agred
        String jsonStrng = "{\"players\":[{\"player_num\":\"0\",\"owner\":\"1\",\"team\":\"0\"},{\"player_num\":\"2\",\"owner\":\"1\",\"team\":\"1\"},{\"player_num\":\"10\",\"owner\":\"3\",\"team\":\"2\"}],\"board_buildings\":[{\"id\":\"6\",\"player_num\":\"0\",\"health\":\"2\",\"max_health\":\"10\"},{\"id\":\"7\",\"player_num\":\"2\",\"health\":\"3\",\"max_health\":\"10\"},{\"id\":\"8\",\"player_num\":\"2\",\"health\":\"0\",\"max_health\":\"0\"}],\"board_building_features\":[{\"board_building_id\":\"8\",\"feature_name\":\"troll_factory\",\"feature_value\":null},{\"board_building_id\":\"8\",\"feature_name\":\"summon_team\",\"feature_value\":\"2\"}],\"board_units\":[{\"id\":\"12\",\"player_num\":\"0\",\"health\":\"1\",\"max_health\":\"1\",\"attack\":\"1\",\"moves_left\":\"1\",\"moves\":\"1\",\"shield\":\"0\"},{\"id\":\"13\",\"player_num\":\"0\",\"health\":\"1\",\"max_health\":\"1\",\"attack\":\"1\",\"moves_left\":\"1\",\"moves\":\"1\",\"shield\":\"0\"},{\"id\":\"14\",\"player_num\":\"2\",\"health\":\"1\",\"max_health\":\"1\",\"attack\":\"1\",\"moves_left\":\"1\",\"moves\":\"1\",\"shield\":\"0\"},{\"id\":\"15\",\"player_num\":\"2\",\"health\":\"1\",\"max_health\":\"1\",\"attack\":\"1\",\"moves_left\":\"1\",\"moves\":\"1\",\"shield\":\"0\"},{\"id\":\"16\",\"player_num\":\"0\",\"health\":\"1\",\"max_health\":\"1\",\"attack\":\"1\",\"moves_left\":\"1\",\"moves\":\"1\",\"shield\":\"0\"},{\"id\":\"17\",\"player_num\":\"2\",\"health\":\"5\",\"max_health\":\"5\",\"attack\":\"5\",\"moves_left\":\"5\",\"moves\":\"5\",\"shield\":\"0\"},{\"id\":\"18\",\"player_num\":\"10\",\"health\":\"3\",\"max_health\":\"3\",\"attack\":\"3\",\"moves_left\":\"2\",\"moves\":\"2\",\"shield\":\"0\"}],\"board_units_features\":[{\"board_unit_id\":\"12\",\"feature_name\":\"no_card\",\"feature_value\":null},{\"board_unit_id\":\"13\",\"feature_name\":\"no_card\",\"feature_value\":null},{\"board_unit_id\":\"14\",\"feature_name\":\"no_card\",\"feature_value\":null},{\"board_unit_id\":\"15\",\"feature_name\":\"no_card\",\"feature_value\":null},{\"board_unit_id\":\"18\",\"feature_name\":\"agressive\",\"feature_value\":null},{\"board_unit_id\":\"18\",\"feature_name\":\"no_card\",\"feature_value\":null},{\"board_unit_id\":\"18\",\"feature_name\":\"parent_building\",\"feature_value\":\"8\"}],\"board\":[{\"x\":\"0\",\"y\":\"0\",\"type\":\"castle\",\"ref\":\"6\"},{\"x\":\"1\",\"y\":\"0\",\"type\":\"castle\",\"ref\":\"6\"},{\"x\":\"0\",\"y\":\"1\",\"type\":\"castle\",\"ref\":\"6\"},{\"x\":\"19\",\"y\":\"19\",\"type\":\"castle\",\"ref\":\"7\"},{\"x\":\"18\",\"y\":\"19\",\"type\":\"castle\",\"ref\":\"7\"},{\"x\":\"19\",\"y\":\"18\",\"type\":\"castle\",\"ref\":\"7\"},{\"x\":\"2\",\"y\":\"0\",\"type\":\"unit\",\"ref\":\"12\"},{\"x\":\"0\",\"y\":\"2\",\"type\":\"unit\",\"ref\":\"13\"},{\"x\":\"16\",\"y\":\"18\",\"type\":\"unit\",\"ref\":\"14\"},{\"x\":\"18\",\"y\":\"16\",\"type\":\"unit\",\"ref\":\"15\"},{\"x\":\"1\",\"y\":\"1\",\"type\":\"unit\",\"ref\":\"16\"},{\"x\":\"10\",\"y\":\"13\",\"type\":\"unit\",\"ref\":\"17\"},{\"x\":\"11\",\"y\":\"13\",\"type\":\"unit\",\"ref\":\"17\"},{\"x\":\"10\",\"y\":\"14\",\"type\":\"unit\",\"ref\":\"17\"},{\"x\":\"11\",\"y\":\"14\",\"type\":\"unit\",\"ref\":\"17\"},{\"x\":\"16\",\"y\":\"10\",\"type\":\"obstacle\",\"ref\":\"8\"},{\"x\":\"17\",\"y\":\"10\",\"type\":\"obstacle\",\"ref\":\"8\"},{\"x\":\"15\",\"y\":\"11\",\"type\":\"obstacle\",\"ref\":\"8\"},{\"x\":\"16\",\"y\":\"11\",\"type\":\"obstacle\",\"ref\":\"8\"},{\"x\":\"14\",\"y\":\"12\",\"type\":\"obstacle\",\"ref\":\"8\"},{\"x\":\"15\",\"y\":\"12\",\"type\":\"obstacle\",\"ref\":\"8\"},{\"x\":\"13\",\"y\":\"13\",\"type\":\"obstacle\",\"ref\":\"8\"},{\"x\":\"14\",\"y\":\"13\",\"type\":\"obstacle\",\"ref\":\"8\"},{\"x\":\"13\",\"y\":\"11\",\"type\":\"unit\",\"ref\":\"18\"}]}";
        Game g = GameJsonFactory.getGameFromJson(jsonStrng);
		g.setId(1);
		PlayerAI ai = PlayerAIFactory.createPlayerAI(g,10);
		assertTrue(ai instanceof EndTurningAI);
		
		//agred
		BoardObject troll = g.getBoard().getUnitById(18);
		troll.addFeature(new BoardObjectFeature("attack_target", "17")); //17 - a dragon nearby
		ai = PlayerAIFactory.createPlayerAI(g,10);
		assertTrue(ai instanceof MultiTargetUnitAI);
		List<Command> cmds = ai.getCommands();
		assertTrue(cmds.size() == 2);
		assertTrue(cmds.get(0) instanceof UnitMoveCommand);		
		assertTrue(cmds.get(1) instanceof UnitAttackCommand);		
    }
	
	@Test
	public void testVampire() throws ParseException
	{		
        String jsonStrng = "{\"players\":[{\"player_num\":\"0\",\"owner\":\"1\",\"team\":\"1\"},{\"player_num\":\"2\",\"owner\":\"1\",\"team\":\"0\"},{\"player_num\":\"11\",\"owner\":\"2\",\"team\":\"2\"},{\"player_num\":\"13\",\"owner\":\"3\",\"team\":\"3\"},{\"player_num\":\"14\",\"owner\":\"4\",\"team\":\"4\"}],\"board_buildings\":[{\"id\":\"39\",\"player_num\":\"2\",\"health\":\"9\",\"max_health\":\"10\"},{\"id\":\"40\",\"player_num\":\"0\",\"health\":\"3\",\"max_health\":\"10\"},{\"id\":\"41\",\"player_num\":\"0\",\"health\":\"3\",\"max_health\":\"3\"},{\"id\":\"42\",\"player_num\":\"2\",\"health\":\"3\",\"max_health\":\"3\"},{\"id\":\"43\",\"player_num\":\"2\",\"health\":\"4\",\"max_health\":\"4\"},{\"id\":\"44\",\"player_num\":\"0\",\"health\":\"0\",\"max_health\":\"0\"},{\"id\":\"45\",\"player_num\":\"0\",\"health\":\"0\",\"max_health\":\"0\"}],\"board_building_features\":[{\"board_building_id\":\"41\",\"feature_name\":\"teleport\",\"feature_value\":null},{\"board_building_id\":\"42\",\"feature_name\":\"magic_increase\",\"feature_value\":\"3\"},{\"board_building_id\":\"43\",\"feature_name\":\"coin_factory\",\"feature_value\":null},{\"board_building_id\":\"44\",\"feature_name\":\"frog_factory\",\"feature_value\":null},{\"board_building_id\":\"44\",\"feature_name\":\"summon_team\",\"feature_value\":\"2\"},{\"board_building_id\":\"44\",\"feature_name\":\"water\",\"feature_value\":null},{\"board_building_id\":\"45\",\"feature_name\":\"troll_factory\",\"feature_value\":null},{\"board_building_id\":\"45\",\"feature_name\":\"summon_team\",\"feature_value\":\"3\"}],\"board_units\":[{\"id\":\"115\",\"player_num\":\"2\",\"health\":\"1\",\"max_health\":\"1\",\"attack\":\"1\",\"moves_left\":\"1\",\"moves\":\"1\",\"shield\":\"0\"},{\"id\":\"116\",\"player_num\":\"2\",\"health\":\"1\",\"max_health\":\"1\",\"attack\":\"1\",\"moves_left\":\"1\",\"moves\":\"1\",\"shield\":\"0\"},{\"id\":\"117\",\"player_num\":\"0\",\"health\":\"1\",\"max_health\":\"1\",\"attack\":\"1\",\"moves_left\":\"1\",\"moves\":\"1\",\"shield\":\"0\"},{\"id\":\"118\",\"player_num\":\"0\",\"health\":\"1\",\"max_health\":\"1\",\"attack\":\"1\",\"moves_left\":\"1\",\"moves\":\"1\",\"shield\":\"0\"},{\"id\":\"119\",\"player_num\":\"2\",\"health\":\"2\",\"max_health\":\"2\",\"attack\":\"1\",\"moves_left\":\"2\",\"moves\":\"2\",\"shield\":\"0\"},{\"id\":\"120\",\"player_num\":\"0\",\"health\":\"3\",\"max_health\":\"3\",\"attack\":\"2\",\"moves_left\":\"1\",\"moves\":\"1\",\"shield\":\"0\"},{\"id\":\"122\",\"player_num\":\"11\",\"health\":\"1\",\"max_health\":\"1\",\"attack\":\"1\",\"moves_left\":\"2\",\"moves\":\"2\",\"shield\":\"0\"},{\"id\":\"124\",\"player_num\":\"13\",\"health\":\"1\",\"max_health\":\"3\",\"attack\":\"3\",\"moves_left\":\"2\",\"moves\":\"2\",\"shield\":\"0\"},{\"id\":\"125\",\"player_num\":\"14\",\"health\":\"2\",\"max_health\":\"2\",\"attack\":\"2\",\"moves_left\":\"2\",\"moves\":\"2\",\"shield\":\"0\"}],\"board_units_features\":[{\"board_unit_id\":\"115\",\"feature_name\":\"no_card\",\"feature_value\":null},{\"board_unit_id\":\"116\",\"feature_name\":\"no_card\",\"feature_value\":null},{\"board_unit_id\":\"117\",\"feature_name\":\"no_card\",\"feature_value\":null},{\"board_unit_id\":\"118\",\"feature_name\":\"no_card\",\"feature_value\":null},{\"board_unit_id\":\"122\",\"feature_name\":\"no_card\",\"feature_value\":null},{\"board_unit_id\":\"122\",\"feature_name\":\"parent_building\",\"feature_value\":\"44\"},{\"board_unit_id\":\"124\",\"feature_name\":\"agressive\",\"feature_value\":null},{\"board_unit_id\":\"124\",\"feature_name\":\"no_card\",\"feature_value\":null},{\"board_unit_id\":\"124\",\"feature_name\":\"parent_building\",\"feature_value\":\"45\"},{\"board_unit_id\":\"125\",\"feature_name\":\"vamp\",\"feature_value\":null},{\"board_unit_id\":\"125\",\"feature_name\":\"drink_health\",\"feature_value\":null},{\"board_unit_id\":\"125\",\"feature_name\":\"no_card\",\"feature_value\":null}],\"board\":[{\"x\":\"19\",\"y\":\"19\",\"type\":\"castle\",\"ref\":\"39\"},{\"x\":\"18\",\"y\":\"19\",\"type\":\"castle\",\"ref\":\"39\"},{\"x\":\"19\",\"y\":\"18\",\"type\":\"castle\",\"ref\":\"39\"},{\"x\":\"0\",\"y\":\"0\",\"type\":\"castle\",\"ref\":\"40\"},{\"x\":\"1\",\"y\":\"0\",\"type\":\"castle\",\"ref\":\"40\"},{\"x\":\"0\",\"y\":\"1\",\"type\":\"castle\",\"ref\":\"40\"},{\"x\":\"13\",\"y\":\"15\",\"type\":\"unit\",\"ref\":\"115\"},{\"x\":\"15\",\"y\":\"13\",\"type\":\"unit\",\"ref\":\"116\"},{\"x\":\"2\",\"y\":\"0\",\"type\":\"unit\",\"ref\":\"117\"},{\"x\":\"0\",\"y\":\"2\",\"type\":\"unit\",\"ref\":\"118\"},{\"x\":\"9\",\"y\":\"9\",\"type\":\"building\",\"ref\":\"41\"},{\"x\":\"10\",\"y\":\"10\",\"type\":\"building\",\"ref\":\"42\"},{\"x\":\"11\",\"y\":\"10\",\"type\":\"building\",\"ref\":\"43\"},{\"x\":\"12\",\"y\":\"12\",\"type\":\"unit\",\"ref\":\"119\"},{\"x\":\"1\",\"y\":\"1\",\"type\":\"unit\",\"ref\":\"120\"},{\"x\":\"7\",\"y\":\"7\",\"type\":\"obstacle\",\"ref\":\"44\"},{\"x\":\"8\",\"y\":\"7\",\"type\":\"obstacle\",\"ref\":\"44\"},{\"x\":\"6\",\"y\":\"8\",\"type\":\"obstacle\",\"ref\":\"44\"},{\"x\":\"7\",\"y\":\"8\",\"type\":\"obstacle\",\"ref\":\"44\"},{\"x\":\"8\",\"y\":\"8\",\"type\":\"obstacle\",\"ref\":\"44\"},{\"x\":\"9\",\"y\":\"8\",\"type\":\"obstacle\",\"ref\":\"44\"},{\"x\":\"7\",\"y\":\"9\",\"type\":\"obstacle\",\"ref\":\"44\"},{\"x\":\"8\",\"y\":\"9\",\"type\":\"obstacle\",\"ref\":\"44\"},{\"x\":\"4\",\"y\":\"5\",\"type\":\"unit\",\"ref\":\"122\"},{\"x\":\"5\",\"y\":\"9\",\"type\":\"obstacle\",\"ref\":\"45\"},{\"x\":\"6\",\"y\":\"9\",\"type\":\"obstacle\",\"ref\":\"45\"},{\"x\":\"4\",\"y\":\"8\",\"type\":\"obstacle\",\"ref\":\"45\"},{\"x\":\"5\",\"y\":\"8\",\"type\":\"obstacle\",\"ref\":\"45\"},{\"x\":\"3\",\"y\":\"7\",\"type\":\"obstacle\",\"ref\":\"45\"},{\"x\":\"4\",\"y\":\"7\",\"type\":\"obstacle\",\"ref\":\"45\"},{\"x\":\"2\",\"y\":\"6\",\"type\":\"obstacle\",\"ref\":\"45\"},{\"x\":\"3\",\"y\":\"6\",\"type\":\"obstacle\",\"ref\":\"45\"},{\"x\":\"7\",\"y\":\"5\",\"type\":\"unit\",\"ref\":\"124\"},{\"x\":\"7\",\"y\":\"6\",\"type\":\"unit\",\"ref\":\"125\"}]}";
        Game g = GameJsonFactory.getGameFromJson(jsonStrng);
		g.setId(1);
		PlayerAI ai = PlayerAIFactory.createPlayerAI(g,14);
		assertTrue(ai instanceof VampireAI);
		List<Command> cmds = ai.getCommands();
		assertTrue(cmds.size() == 1);
		assertTrue(cmds.get(0) instanceof UnitAttackCommand);
	}
	
	@Test
	public void testAiWithObjectsWithNullPlayer() throws ParseException
	{		
        String jsonStrng = "{\"players\":[{\"player_num\":\"1\",\"owner\":\"1\",\"team\":\"1\"},{\"player_num\":\"2\",\"owner\":\"1\",\"team\":\"0\"},{\"player_num\":\"10\",\"owner\":\"2\",\"team\":\"2\"},{\"player_num\":\"14\",\"owner\":\"2\",\"team\":\"2\"},{\"player_num\":\"17\",\"owner\":\"2\",\"team\":\"2\"}],\"board_buildings\":[{\"id\":\"8\",\"player_num\":\"2\",\"health\":\"9\",\"max_health\":\"10\"},{\"id\":\"9\",\"player_num\":\"1\",\"health\":\"7\",\"max_health\":\"10\"},{\"id\":\"12\",\"player_num\":\"0\",\"health\":\"0\",\"max_health\":\"0\"},{\"id\":\"13\",\"player_num\":\"0\",\"health\":\"0\",\"max_health\":\"0\"},{\"id\":\"14\",\"player_num\":\"1\",\"health\":\"4\",\"max_health\":\"4\"}],\"board_building_features\":[{\"board_building_id\":\"14\",\"feature_name\":\"coin_factory\",\"feature_value\":null}],\"board_units\":[{\"id\":\"47\",\"player_num\":\"10\",\"health\":\"1\",\"max_health\":\"1\",\"attack\":\"1\",\"moves_left\":\"2\",\"moves\":\"2\",\"shield\":\"0\"},{\"id\":\"50\",\"player_num\":\"14\",\"health\":\"1\",\"max_health\":\"1\",\"attack\":\"1\",\"moves_left\":\"2\",\"moves\":\"2\",\"shield\":\"0\"},{\"id\":\"53\",\"player_num\":\"2\",\"health\":\"1\",\"max_health\":\"3\",\"attack\":\"2\",\"moves_left\":\"3\",\"moves\":\"3\",\"shield\":\"0\"},{\"id\":\"55\",\"player_num\":\"2\",\"health\":\"1\",\"max_health\":\"1\",\"attack\":\"2\",\"moves_left\":\"1\",\"moves\":\"1\",\"shield\":\"0\"},{\"id\":\"56\",\"player_num\":\"17\",\"health\":\"1\",\"max_health\":\"1\",\"attack\":\"1\",\"moves_left\":\"2\",\"moves\":\"2\",\"shield\":\"0\"}],\"board_units_features\":[{\"board_unit_id\":\"47\",\"feature_name\":\"no_card\",\"feature_value\":null},{\"board_unit_id\":\"47\",\"feature_name\":\"parent_building\",\"feature_value\":\"12\"},{\"board_unit_id\":\"50\",\"feature_name\":\"no_card\",\"feature_value\":null},{\"board_unit_id\":\"50\",\"feature_name\":\"parent_building\",\"feature_value\":\"12\"},{\"board_unit_id\":\"56\",\"feature_name\":\"no_card\",\"feature_value\":null},{\"board_unit_id\":\"56\",\"feature_name\":\"parent_building\",\"feature_value\":\"12\"}],\"board\":[{\"x\":\"19\",\"y\":\"19\",\"type\":\"castle\",\"ref\":\"8\"},{\"x\":\"18\",\"y\":\"19\",\"type\":\"castle\",\"ref\":\"8\"},{\"x\":\"19\",\"y\":\"18\",\"type\":\"castle\",\"ref\":\"8\"},{\"x\":\"19\",\"y\":\"0\",\"type\":\"castle\",\"ref\":\"9\"},{\"x\":\"19\",\"y\":\"1\",\"type\":\"castle\",\"ref\":\"9\"},{\"x\":\"18\",\"y\":\"0\",\"type\":\"castle\",\"ref\":\"9\"},{\"x\":\"7\",\"y\":\"6\",\"type\":\"obstacle\",\"ref\":\"12\"},{\"x\":\"8\",\"y\":\"6\",\"type\":\"obstacle\",\"ref\":\"12\"},{\"x\":\"6\",\"y\":\"7\",\"type\":\"obstacle\",\"ref\":\"12\"},{\"x\":\"7\",\"y\":\"7\",\"type\":\"obstacle\",\"ref\":\"12\"},{\"x\":\"8\",\"y\":\"7\",\"type\":\"obstacle\",\"ref\":\"12\"},{\"x\":\"9\",\"y\":\"7\",\"type\":\"obstacle\",\"ref\":\"12\"},{\"x\":\"7\",\"y\":\"8\",\"type\":\"obstacle\",\"ref\":\"12\"},{\"x\":\"8\",\"y\":\"8\",\"type\":\"obstacle\",\"ref\":\"12\"},{\"x\":\"13\",\"y\":\"1\",\"type\":\"unit\",\"ref\":\"47\"},{\"x\":\"9\",\"y\":\"0\",\"type\":\"unit\",\"ref\":\"50\"},{\"x\":\"3\",\"y\":\"4\",\"type\":\"unit\",\"ref\":\"53\"},{\"x\":\"6\",\"y\":\"2\",\"type\":\"obstacle\",\"ref\":\"13\"},{\"x\":\"6\",\"y\":\"1\",\"type\":\"obstacle\",\"ref\":\"13\"},{\"x\":\"7\",\"y\":\"3\",\"type\":\"obstacle\",\"ref\":\"13\"},{\"x\":\"7\",\"y\":\"2\",\"type\":\"obstacle\",\"ref\":\"13\"},{\"x\":\"8\",\"y\":\"4\",\"type\":\"obstacle\",\"ref\":\"13\"},{\"x\":\"8\",\"y\":\"3\",\"type\":\"obstacle\",\"ref\":\"13\"},{\"x\":\"9\",\"y\":\"5\",\"type\":\"obstacle\",\"ref\":\"13\"},{\"x\":\"9\",\"y\":\"4\",\"type\":\"obstacle\",\"ref\":\"13\"},{\"x\":\"17\",\"y\":\"19\",\"type\":\"unit\",\"ref\":\"55\"},{\"x\":\"1\",\"y\":\"1\",\"type\":\"unit\",\"ref\":\"56\"},{\"x\":\"19\",\"y\":\"3\",\"type\":\"building\",\"ref\":\"14\"}]}";
        Game g = GameJsonFactory.getGameFromJson(jsonStrng);
		g.setId(1);
		PlayerAI ai = PlayerAIFactory.createPlayerAI(g,14);
		List<Command> cmds = ai.getCommands();
		assertTrue(cmds.size() > 0);
	}
	
}