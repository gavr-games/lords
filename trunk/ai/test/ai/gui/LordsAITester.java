package ai.gui;

import ai.Command;
import ai.MultiTargetUnitAI;
import ai.Board;

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
            visualizePath(ai.getCommands());
        }
    }

    private static void visualizePath(List<Command> commands) {
        GBoard GBoard = testerGUI.getBoard();
        for(int i =0; i<commands.size()-1; i++) {
            ai.BoardCell pathCell = commands.get(i).getTo();
            GBoard.markPathCell(pathCell.x, pathCell.y);
        }
    }
}
