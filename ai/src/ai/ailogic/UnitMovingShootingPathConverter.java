package ai.ailogic;

import ai.command.Command;
import ai.command.EndTurnCommand;
import ai.command.ShootCommand;
import ai.game.board.Board;
import ai.game.board.BoardCell;
import ai.game.board.BoardObject;
import ai.game.board.Unit;

import java.util.List;

public class UnitMovingShootingPathConverter extends UnitMovingAttackingPathConverter
{
	@Override
	protected Command finalCommand(BoardCell cellFrom, BoardCell cellTo) {
		return new ShootCommand(cellFrom, cellTo);
	}
}
