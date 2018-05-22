package ai.game;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

import ai.game.board.*;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

public class GameJsonFactory
{
	private static final Logger log = Logger.getLogger(GameJsonFactory.class.getName());
	
	private static final int MAP_SIZE_X = 20;
	private static final int MAP_SIZE_Y = 20;

	private Map<Integer, Player> playersMap;
	private Map<String, BoardObject> boardObjectsMap;

	public Game getGameFromJson(String jsonStrng) throws ParseException
	{
		JSONParser parser = new JSONParser();

		Object obj = parser.parse(jsonStrng);
		JSONObject jsonObject = (JSONObject) obj;
		
		//players
		playersMap = new HashMap<>();
		JSONArray playersJ = (JSONArray) jsonObject.get("players");
		for(Object p:playersJ)
		{
			Player player = parsePlayer((JSONObject)p);
			playersMap.put(player.getPlayerNum(),player);
		}

		boardObjectsMap = new HashMap<>();
		
		//units
		JSONArray unitsJ = (JSONArray) jsonObject.get("board_units");
		if(unitsJ != null)
		{
			for(Object u:unitsJ)
			{
				Unit unit = parseUnit((JSONObject)u);
				boardObjectsMap.put(Integer.toString(unit.getId())+"u", unit);
			}
		}

		//buildings
		JSONArray buildingsJ = (JSONArray) jsonObject.get("board_buildings");
		if(buildingsJ != null)
		{
			for(Object b:buildingsJ)
			{
				JSONObject buildingJ = (JSONObject)b;
				int id = Integer.parseInt((String)buildingJ.get("id"));
				int pNum = Integer.parseInt((String)buildingJ.get("player_num"));
				Player p = playersMap.get(pNum);
				BoardObject bo = new BoardObject(id, BoardObjectType.BUILDING, p);
				boardObjectsMap.put(Integer.toString(id)+"b",bo);
			}
		}
		
		//unit features
		JSONArray uFeaturesJ = (JSONArray) jsonObject.get("board_units_features");
		if(uFeaturesJ != null)
		{
			for(Object f:uFeaturesJ)
			{
				JSONObject featureJ = (JSONObject)f;
				int unitId = Integer.parseInt((String)featureJ.get("board_unit_id"));
				String name = (String)featureJ.get("feature_name");
				String value = (String)featureJ.get("feature_value");
				
				BoardObject bo = boardObjectsMap.get(Integer.toString(unitId)+"u");
				BoardObjectFeature bof = new BoardObjectFeature(name,value);
				bo.addFeature(bof);
			}
		}

		//building features
		JSONArray bFeaturesJ = (JSONArray) jsonObject.get("board_building_features");
		if(bFeaturesJ != null)
		{
			for(Object f:bFeaturesJ)
			{
				JSONObject featureJ = (JSONObject)f;
				int buildingId = Integer.parseInt((String)featureJ.get("board_building_id"));
				String name = (String)featureJ.get("feature_name");
				String value = (String)featureJ.get("feature_value");
				
				BoardObject bo = boardObjectsMap.get(Integer.toString(buildingId)+"b");
				BoardObjectFeature bof = new BoardObjectFeature(name,value);
				bo.addFeature(bof);
			}
		}
		
		//cells
		JSONArray cellsJ = (JSONArray) jsonObject.get("board");
		if(cellsJ != null)
		{
			for(Object c:cellsJ)
			{
				JSONObject cellJ = (JSONObject)c;
				int ref = Integer.parseInt((String)cellJ.get("ref"));
				int x = Integer.parseInt((String)cellJ.get("x"));
				int y = Integer.parseInt((String)cellJ.get("y"));
				String type = (String)cellJ.get("type");
				
				String boardObjectKey = Integer.toString(ref) + (type.equals("unit") ? "u" : "b");
				
				BoardObject bo = boardObjectsMap.get(boardObjectKey);
				BoardCell bc = new BoardCell(x,y);
				bo.addCell(bc);
				
				if(type.equals("castle") && bo.getType() != BoardObjectType.CASTLE) bo.setType(BoardObjectType.CASTLE);
				if(type.equals("obstacle") && bo.getType() != BoardObjectType.OBSTACLE) bo.setType(BoardObjectType.OBSTACLE);
			}
		}
		
		Board b = new Board(MAP_SIZE_X,MAP_SIZE_Y,new ArrayList<>(boardObjectsMap.values()));
		return new Game(new ArrayList<>(playersMap.values()),b);
	}

	private Player parsePlayer(JSONObject playerJ) {
		int pNum = Integer.parseInt((String)playerJ.get("player_num"));
		int owner = Integer.parseInt((String)playerJ.get("owner"));
		int team = Integer.parseInt((String)playerJ.get("team"));
		return new Player(pNum, owner, team);
	}

	private Unit parseUnit(JSONObject unitJ) {
		int id = Integer.parseInt((String)unitJ.get("id"));
		int pNum = Integer.parseInt((String)unitJ.get("player_num"));
		int moves = Integer.parseInt((String)unitJ.get("moves"));
		boolean canLevelUp = Integer.parseInt((String)unitJ.get("can_levelup")) == 1;
		Player p = playersMap.get(pNum);

		if (unitJ.get("min_range") != null) {
			int minRange = Integer.parseInt((String)unitJ.get("min_range"));
			int maxRange = Integer.parseInt((String)unitJ.get("max_range"));
			List<BoardObjectType> aimTypes = new ArrayList<>();
			if (unitJ.get("shoots_units").equals("1")) {
				aimTypes.add(BoardObjectType.UNIT);
			}
			if (unitJ.get("shoots_buildings").equals("1")) {
				aimTypes.add(BoardObjectType.BUILDING);
			}
			if (unitJ.get("shoots_castles").equals("1")) {
				aimTypes.add(BoardObjectType.CASTLE);
			}
			return new RangeUnit(id, p, moves, canLevelUp, minRange, maxRange, aimTypes);
		}
		return new Unit(id, p, moves, canLevelUp);
	}
}
