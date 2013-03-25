package ai;

import org.junit.Test;

import static org.junit.Assert.assertTrue;

public class GameJsonFactoryTest
{
    @Test
    public void testGetGameFromJson() throws Exception
    {
        String jsonStrng = "{\"players\":[{\"player_num\":\"0\",\"owner\":\"1\",\"team\":\"0\"},{\"player_num\":\"1\",\"owner\":\"1\",\"team\":\"1\"},{\"player_num\":\"2\",\"owner\":\"1\",\"team\":\"1\"},{\"player_num\":\"3\",\"owner\":\"1\",\"team\":\"0\"}],\"board_buildings\":[{\"id\":\"1\",\"player_num\":\"2\",\"health\":\"10\",\"max_health\":\"10\"},{\"id\":\"2\",\"player_num\":\"0\",\"health\":\"10\",\"max_health\":\"10\"},{\"id\":\"3\",\"player_num\":\"3\",\"health\":\"10\",\"max_health\":\"10\"},{\"id\":\"4\",\"player_num\":\"1\",\"health\":\"10\",\"max_health\":\"10\"}],\"board_units\":[{\"id\":\"1\",\"player_num\":\"0\",\"health\":\"1\",\"max_health\":\"1\",\"attack\":\"1\",\"moves_left\":\"1\",\"moves\":\"1\",\"shield\":\"0\"},{\"id\":\"2\",\"player_num\":\"0\",\"health\":\"1\",\"max_health\":\"1\",\"attack\":\"1\",\"moves_left\":\"1\",\"moves\":\"1\",\"shield\":\"0\"},{\"id\":\"3\",\"player_num\":\"1\",\"health\":\"1\",\"max_health\":\"1\",\"attack\":\"1\",\"moves_left\":\"1\",\"moves\":\"1\",\"shield\":\"0\"},{\"id\":\"4\",\"player_num\":\"1\",\"health\":\"1\",\"max_health\":\"1\",\"attack\":\"1\",\"moves_left\":\"1\",\"moves\":\"1\",\"shield\":\"0\"},{\"id\":\"5\",\"player_num\":\"2\",\"health\":\"1\",\"max_health\":\"1\",\"attack\":\"1\",\"moves_left\":\"1\",\"moves\":\"1\",\"shield\":\"0\"},{\"id\":\"6\",\"player_num\":\"2\",\"health\":\"1\",\"max_health\":\"1\",\"attack\":\"1\",\"moves_left\":\"1\",\"moves\":\"1\",\"shield\":\"0\"},{\"id\":\"7\",\"player_num\":\"3\",\"health\":\"1\",\"max_health\":\"1\",\"attack\":\"1\",\"moves_left\":\"1\",\"moves\":\"1\",\"shield\":\"0\"},{\"id\":\"8\",\"player_num\":\"3\",\"health\":\"1\",\"max_health\":\"1\",\"attack\":\"1\",\"moves_left\":\"1\",\"moves\":\"1\",\"shield\":\"0\"}],\"board_units_features\":[{\"board_unit_id\":\"1\",\"feature_name\":\"no_card\",\"feature_value\":null},{\"board_unit_id\":\"2\",\"feature_name\":\"no_card\",\"feature_value\":null},{\"board_unit_id\":\"3\",\"feature_name\":\"no_card\",\"feature_value\":null},{\"board_unit_id\":\"4\",\"feature_name\":\"no_card\",\"feature_value\":null},{\"board_unit_id\":\"5\",\"feature_name\":\"no_card\",\"feature_value\":null},{\"board_unit_id\":\"6\",\"feature_name\":\"no_card\",\"feature_value\":null},{\"board_unit_id\":\"7\",\"feature_name\":\"no_card\",\"feature_value\":null},{\"board_unit_id\":\"8\",\"feature_name\":\"no_card\",\"feature_value\":null}],\"board\":[{\"x\":\"19\",\"y\":\"19\",\"type\":\"castle\",\"ref\":\"1\"},{\"x\":\"18\",\"y\":\"19\",\"type\":\"castle\",\"ref\":\"1\"},{\"x\":\"19\",\"y\":\"18\",\"type\":\"castle\",\"ref\":\"1\"},{\"x\":\"0\",\"y\":\"0\",\"type\":\"castle\",\"ref\":\"2\"},{\"x\":\"1\",\"y\":\"0\",\"type\":\"castle\",\"ref\":\"2\"},{\"x\":\"0\",\"y\":\"1\",\"type\":\"castle\",\"ref\":\"2\"},{\"x\":\"0\",\"y\":\"19\",\"type\":\"castle\",\"ref\":\"3\"},{\"x\":\"0\",\"y\":\"18\",\"type\":\"castle\",\"ref\":\"3\"},{\"x\":\"1\",\"y\":\"19\",\"type\":\"castle\",\"ref\":\"3\"},{\"x\":\"19\",\"y\":\"0\",\"type\":\"castle\",\"ref\":\"4\"},{\"x\":\"19\",\"y\":\"1\",\"type\":\"castle\",\"ref\":\"4\"},{\"x\":\"18\",\"y\":\"0\",\"type\":\"castle\",\"ref\":\"4\"},{\"x\":\"3\",\"y\":\"1\",\"type\":\"unit\",\"ref\":\"1\"},{\"x\":\"1\",\"y\":\"2\",\"type\":\"unit\",\"ref\":\"2\"},{\"x\":\"17\",\"y\":\"0\",\"type\":\"unit\",\"ref\":\"3\"},{\"x\":\"19\",\"y\":\"2\",\"type\":\"unit\",\"ref\":\"4\"},{\"x\":\"17\",\"y\":\"19\",\"type\":\"unit\",\"ref\":\"5\"},{\"x\":\"19\",\"y\":\"17\",\"type\":\"unit\",\"ref\":\"6\"},{\"x\":\"0\",\"y\":\"17\",\"type\":\"unit\",\"ref\":\"7\"},{\"x\":\"2\",\"y\":\"19\",\"type\":\"unit\",\"ref\":\"8\"}]}";
        Game g = GameJsonFactory.getGameFromJson(jsonStrng);
        assertTrue(g.getPlayers().size() == 4);
        assertTrue(g.getBoard().getObjects().size() == 12);
		
		for(BoardObject bo:g.getBoard().getObjects())
		{
			if(bo.getType().equals(BoardObjectType.UNIT))
			{
				assertTrue(bo.checkFeature("no_card"));
				assertTrue(bo.getCells().size() == 1);
			}
			else
			{
				assertTrue(bo.getFeatures().size() == 0);
				assertTrue(bo.getCells().size() == 3);
			}
		}		
    }
	
	private void printGame(Game g)
	{
		System.out.println();
		for(BoardObject bo:g.getBoard().getObjects())
		{
			System.out.println(bo.getId()+" "+bo.getType());
			for(BoardCell bc:bo.getCells())
			{
				System.out.println(bc.x+" "+bc.y);
			}
			for(BoardObjectFeature f:bo.getFeatures())
			{
				System.out.println(f.name+" "+f.value);
			}
		}
	}
}
