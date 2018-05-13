package ai.command;

import ai.game.board.BoardCell;

public abstract class ActionCommand extends Command {
	public abstract BoardCell getFrom();
	public abstract BoardCell getTo();
}
