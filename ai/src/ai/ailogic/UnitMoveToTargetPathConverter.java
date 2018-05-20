package ai.ailogic;

import ai.command.Command;
import ai.command.EndTurnCommand;
import ai.command.ShootCommand;
import ai.game.board.BoardCell;

public class UnitMoveToTargetPathConverter extends UnitMovingAttackingPathConverter
{
	@Override
	protected Command finalCommand(BoardCell cellFrom, BoardCell cellTo) {
		return new EndTurnCommand();
	}
}
