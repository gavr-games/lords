package ai;

public abstract class ActionCommand extends Command {
    public abstract BoardCell getFrom();
    public abstract BoardCell getTo();
}
