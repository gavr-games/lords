package ai.gui;

import ai.*;
import ai.Board;

import java.awt.*;
import java.util.ArrayList;
import java.util.List;

public class LordsAITester {
    private static TesterGUI testerGUI;


    public static void main(String[] args) {
        testerGUI = new TesterGUI();
        testerGUI.setVisible(true);
    }


    public static void runTest(TestProperties testProperties) {
        if(testProperties != null) {
            List<BoardObject> objects = new ArrayList<>();
            objects.add(testProperties.me);
            objects.addAll(testProperties.obstacles);
            objects.addAll(testProperties.enemies);
            Board board = new Board(20,20, objects);
            ai.MultiTargetUnitAI ai = new MultiTargetUnitAI(board, testProperties.me, testProperties.enemies);

            visualizeCommands(ai.getCommands());
        }
    }

    private static void visualizeCommands(List<Command> commands) {
        Component[] boardComponents = testerGUI.getBoard().getComponents();
        int componentNumber = 0;
        for(int i =0; i<commands.size()-1; i++) {
            componentNumber = commands.get(i).getTo().x*20 + commands.get(i).getTo().y;
            boardComponents[componentNumber].setBackground(Color.CYAN);
        }

    }
}
