package ai.gui;

import ai.Command;
import ai.MultiTargetUnitAI;
import ai.Board;

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
            ai.MultiTargetUnitAI ai = new MultiTargetUnitAI(board, testProperties.getMyUnit(), testProperties.getEnemies());
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
        GBoard gBoard = testerGUI.getBoard();
        gBoard.shadePreviousPaths();
        for(Command command : commands) {
            if(command instanceof ai.ActionCommand) {
                ai.ActionCommand acmd = (ai.ActionCommand)command;
                ai.BoardCell pathCell = acmd.getTo();
                gBoard.markPathCell(pathCell.x, pathCell.y);
            }
        }
    }
}
