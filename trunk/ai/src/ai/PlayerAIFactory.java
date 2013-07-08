package ai;

import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class PlayerAIFactory
{
    private static final Logger log = Logger.getLogger(PlayerAIFactory.class.getName());

	public static PlayerAI createPlayerAI(Game g, int playerNum)
	{
		//find myPlayer
		Player myPlayer = null;
		for(Player p:g.getPlayers())
		{
			if(p.getPlayerNum() == playerNum)
			{
				myPlayer = p;
				break;
			}
		}
		
		if(myPlayer == null)
		{
			throw new IllegalArgumentException("Player "+playerNum+" was not found");
		}
		
		//find myUnit
		BoardObject myUnit = null;
		for(BoardObject bo:g.getBoard().getObjects())
		{
			if(bo.getPlayer() != null && bo.getPlayer().equals(myPlayer))
			{
				myUnit = bo;
				break;
			}
		}
		
		if(myUnit == null)
		{
			log.warning(String.format("Game %s player %s No units found. Ending turn.",String.valueOf(g.getId()),String.valueOf(playerNum)));
			return new EndTurningAI();
		}

		List<BoardObject> targets = new ArrayList<>();
		
		//mad
		if(myUnit.checkFeature("madness"))
		{
			for(BoardObject bo:g.getBoard().getObjects())
			{
				if(bo.getType() == BoardObjectType.UNIT && bo != myUnit)
				{
					targets.add(bo);
				}
			}
		}
		else
		//agred troll
		if(myUnit.checkFeature("attack_target"))
		{
			int targetUnitId = Integer.parseInt(myUnit.getFeatureValue("attack_target"));
			BoardObject target = g.getBoard().getUnitById(targetUnitId);
			if(target == null)
			{
				log.warning(String.format("Game %s player %s Agressive Troll. Target unit not found id=%s. Ending turn.",String.valueOf(g.getId()),String.valueOf(playerNum),String.valueOf(targetUnitId)));
				return new EndTurningAI();
			}
			targets.add(target);
		}
		else
		//frog or zombie
		if(myPlayer.getOwner() == 2)
		{
			int myTeam = myPlayer.getTeam();
			for(BoardObject bo:g.getBoard().getObjects())
			{
				if(bo.getType() == BoardObjectType.UNIT && (bo.getPlayer() == null || bo.getPlayer().getTeam() != myTeam))
				{
					targets.add(bo);
				}
			}
		}
		else
		//troll
		if(myPlayer.getOwner() == 3)
		{
			int myTeam = myPlayer.getTeam();
			for(BoardObject bo:g.getBoard().getObjects())
			{
				if(bo.getType() == BoardObjectType.BUILDING && !bo.checkFeature("not_interesting_for_npc"))
				{
					targets.add(bo);
				}
			}
		}
		else
		//vampire
		if(myPlayer.getOwner() == 4)
		{
			return new VampireAI(g.getBoard(), myUnit);
		}

		if(targets.isEmpty())
		{
			log.info(String.format("Game %s player %s No targets for unit found. Start searching a 'home'.",String.valueOf(g.getId()),String.valueOf(playerNum)));
			for(BoardObject bo : g.getBoard().getObjects()) {
                if(bo.checkFeature("summon_team") && Integer.parseInt(bo.getFeatureValue("summon_team")) == myPlayer.getTeam() && !bo.checkFeature("not_interesting_for_npc")) {
                    targets.add(bo);
                    return new UnitMoveToTargetAI(g.getBoard(), myUnit, targets);
                }
            }

            log.info(String.format("Game %s player %s No 'home' for unit found.",String.valueOf(g.getId()),String.valueOf(playerNum)));
            return new EndTurningAI();
		}
		
		return new MultiTargetUnitAI(g.getBoard(), myUnit, targets);
	}
}