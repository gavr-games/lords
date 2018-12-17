package ai.ailogic;

import ai.command.Command;
import ai.command.ShootCommand;
import ai.command.UnitAttackCommand;
import ai.game.Game;
import ai.game.Player;
import ai.game.board.BoardObject;
import ai.game.board.BoardObjectType;
import ai.game.board.RangeUnit;
import ai.game.board.Unit;

import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class PlayerAIFactory
{
	private static final Logger log = Logger.getLogger(PlayerAIFactory.class.getName());
	
	private static Player getMyPlayer(Game g, int playerNum)
	{
		Player myPlayer = null;
		for(Player p:g.getPlayers())
		{
			if(p.getPlayerNum() == playerNum)
			{
				myPlayer = p;
				break;
			}
		}
		return myPlayer;
	}

	/**
	 * Returns the unit for a given player, or null if there are no units
	 */
	private static Unit getMyUnit(Game g, Player myPlayer)
	{
		for(BoardObject bo:g.getBoard().getObjects())
		{
			if(bo.getPlayer() != null && bo.getPlayer().equals(myPlayer) && bo instanceof Unit)
			{
				return (Unit) bo;
			}
		}
		return null;
	}

	public static PlayerAI createPlayerAI(Game g, int playerNum)
	{
		PlayerAI normalAI = createPlayerAIWithoutLevelUp(g, playerNum);

		//level up
		Player myPlayer = getMyPlayer(g,playerNum);
		Unit myUnit = getMyUnit(g,myPlayer);
		if(myUnit.canLevelUp()) {
			List<Command> commands = normalAI.getCommands();
			Command lastCommand = commands.get(commands.size() - 1);
			if (!(lastCommand instanceof UnitAttackCommand || lastCommand instanceof ShootCommand))
				return new LevelUpAI(myUnit);
		}

		return normalAI;
	}

	private static PlayerAI createPlayerAIWithoutLevelUp(Game g, int playerNum)
	{
		//find myPlayer
		Player myPlayer = getMyPlayer(g,playerNum);

		if(myPlayer == null)
		{
			throw new IllegalArgumentException("Player "+playerNum+" was not found");
		}

		//find myUnit
		Unit myUnit = getMyUnit(g,myPlayer);
		PathToCommandsConverter pathConverter;
		if (myUnit instanceof RangeUnit) {
			pathConverter = new UnitMovingShootingPathConverter();
		} else {
			pathConverter = new UnitMovingAttackingPathConverter();
		}

		if(myUnit == null)
		{
			log.warning(String.format("Game %s player %s No units found. Ending turn.",String.valueOf(g.getId()),String.valueOf(playerNum)));
			return new EndTurningAI();
		}

		List<BoardObject> targets = new ArrayList<>();

		if(myUnit.checkFeature("paralich"))
		{
			return new EndTurningAI();
		}

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
			return new VampireAI(g.getBoard(), myUnit, pathConverter);
		}

		if(targets.isEmpty())
		{
			log.info(String.format("Game %s player %s No targets for unit found. Start searching a 'home'.",String.valueOf(g.getId()),String.valueOf(playerNum)));
			if (myUnit.checkFeature("parent_building")) {
				int parentBuildingId = Integer.parseInt(myUnit.getFeatureValue("parent_building"));
				BoardObject parentBuilding = g.getBoard().getBuildingById(parentBuildingId);
				if (parentBuilding != null) {
					targets.add(parentBuilding);
					return new MultiTargetUnitAI(g.getBoard(), myUnit, targets, new UnitMoveToTargetPathConverter());
				}
			}

			log.info(String.format("Game %s player %s No 'home' for unit found.",String.valueOf(g.getId()),String.valueOf(playerNum)));
			return new EndTurningAI();
		}

		return new MultiTargetUnitAI(g.getBoard(), myUnit, targets, pathConverter);
	}
}