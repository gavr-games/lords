package ai;

import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.jws.WebService;
import org.json.simple.JSONArray;


@WebService(endpointInterface = "ai.AiService")
public class AiServiceImpl implements AiService
{
    private static final Logger log = Logger.getLogger(AiServiceImpl.class.getName());
    
    @Override
    public String makeMove(int gameId, int playerNum)
    {
		log.log(Level.INFO, "Entering makeMove({0},{1})", new Object[]{gameId, playerNum});
		
        String gameDataRetrieveURL = String.format("http://localhost/game/mode1/ajax/get_all_game_info_ai.php?g_id=%s&p_num=%s",String.valueOf(gameId),String.valueOf(playerNum));
		
		Game game;
		PlayerAI ai;
        try
        {
            String gameDataJson = UrlContentsLoader.load(gameDataRetrieveURL);
			log.log(Level.INFO, gameDataJson);
			
            game = GameJsonFactory.getGameFromJson(gameDataJson);
			game.setId(gameId);
			
            ai = PlayerAIFactory.createPlayerAI(game,playerNum);
			
			List<Command> cmds = ai.getCommands();
			
			JSONArray commandsJsonArr = new JSONArray();
			for(Command cmd:cmds)
			{
				commandsJsonArr.add(cmd.toString(gameId, playerNum));
			}
			
			String result = commandsJsonArr.toString();
			log.log(Level.INFO, "Exiting with result {0}", result);
			return result;
        }
        catch(Exception ex)
        {
			//TODO add info about turn
            log.log(Level.SEVERE, String.format("Exception game=%s player=%s : ",String.valueOf(gameId),String.valueOf(playerNum)), ex);
			//empty array
			return "[]";
        }
    }
}
