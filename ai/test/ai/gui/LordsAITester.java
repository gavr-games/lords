package ai.gui;

import ai.ailogic.UnitMovingAttackingPathConverter;
import ai.command.Command;
import ai.ailogic.MultiTargetUnitAI;
import ai.game.board.Board;
import ai.game.board.BoardCell;
import ai.command.ActionCommand;

import javax.swing.*;
import java.util.List;

public class LordsAITester {
    private static TesterGUI testerGUI;


    public static void main(String[] args) {
        testerGUI = new TesterGUI();
        testerGUI.setVisible(true);
    }


    public static void runTest(TestProperties testProperties) {
        if(testProperties != null) {
            Board board = new Board(20,20, testProperties.getAllObjects());
            MultiTargetUnitAI ai = new MultiTargetUnitAI(board, testProperties.getMyUnit(), testProperties.getEnemies(), new UnitMovingAttackingPathConverter());
            try {
                visualizePath(ai.getCommands());
            }
            catch(Exception e) {
                JDialog exceptionDialog = new JDialog(testerGUI, "Exception in MultiTargetUnitAI");
                JTextArea jTextArea = new JTextArea(e.toString());
                jTextArea.setEditable(false);
                jTextArea.setLineWrap(true);
                exceptionDialog.add(jTextArea);
                exceptionDialog.setSize(300, 200);
                exceptionDialog.setLocation(testerGUI.getLocation());
                exceptionDialog.setVisible(true);
            }
        }
    }

    private static void visualizePath(List<Command> commands) {
        GBoard.shadePreviousPaths();
        for(Command command : commands) {
            if(command instanceof ActionCommand) {
                ActionCommand acmd = (ActionCommand)command;
                BoardCell pathCell = acmd.getTo();
                GBoard.markPathCell(pathCell.x, pathCell.y);
            }
        }
    }
}
