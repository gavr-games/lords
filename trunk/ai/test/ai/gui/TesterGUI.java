package ai.gui;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class TesterGUI extends JFrame {

    private static int screenWidth;
    private static int screenHeight;
    private static GBoard gBoard;

    public static JRadioButton myUnit;
    public static JRadioButton obstacles;
    public static JRadioButton target;


    @SuppressWarnings("MagicConstant")
    public TesterGUI() {
        setTitle("LordsAITester alpha");
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        saveScreenSize();
        setHalfScreenFrameSize();
        setLocationOnCenterOfScreen();
        generateGUI();
    }

    private void saveScreenSize() {
        Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
        screenWidth = screenSize.width;
        screenHeight = screenSize.height;
    }

    private void setLocationOnCenterOfScreen() {
        setLocation(screenWidth / 4, screenHeight / 4);
    }

    private void setHalfScreenFrameSize() {
        Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
        int screenHeight = screenSize.height;
        int screenWidth = screenSize.width;
        setSize(screenWidth / 2, screenHeight / 2);
    }

    private void generateGUI() {
        setLayout(new GridBagLayout());

        gBoard = new GBoard();

        JPanel optionsPanel = new JPanel(new GridBagLayout());
        JPanel objectTypeSelectionPanel = new JPanel(new GridBagLayout());
        JPanel testPropertiesPanel = new JPanel(new GridBagLayout());

        JButton startTestButton = new JButton("Start test!");
        startTestButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) { LordsAITester.runTest(gBoard.getTestProperties()); }
        });

        JButton clearGBoardButton = new JButton("Clear all");
        clearGBoardButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                gBoard.clearAll();
            }
        });
        JButton clearPathButton = new JButton("Clear path");
        clearPathButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                gBoard.clearPath();
            }
        });


        myUnit = new JRadioButton();
        obstacles = new JRadioButton();
        obstacles.setSelected(true);
        target = new JRadioButton();

        JLabel myUnitRadioButtonLabel = new JLabel("myUnit");
        JLabel obstaclesRadioButtonLabel = new JLabel("obstacle");
        JLabel targetRadioButtonLabel = new JLabel("target");
        JLabel testTypeLabel = new JLabel("MultiTargetUnitAI");

        ButtonGroup bg = new ButtonGroup();
        bg.add(myUnit);
        bg.add(obstacles);
        bg.add(target);


        objectTypeSelectionPanel.add(myUnit, new GridBagConstraints(0,0, 1,1, 1.0,1.0,
                GridBagConstraints.EAST, GridBagConstraints.CENTER, new Insets(0,0,0,0), 0,0));
        objectTypeSelectionPanel.add(myUnitRadioButtonLabel, new GridBagConstraints(1,0,1,1,1.0,1.0,
                GridBagConstraints.WEST, GridBagConstraints.CENTER, new Insets(0,0,0,0), 0,0));

        objectTypeSelectionPanel.add(obstacles, new GridBagConstraints(0,1,1,1,1.0,1.0,
                GridBagConstraints.EAST, GridBagConstraints.CENTER, new Insets(0,0,0,0), 0,0));
        objectTypeSelectionPanel.add(obstaclesRadioButtonLabel, new GridBagConstraints(1,1,1,1,1.0,1.0,
                GridBagConstraints.WEST, GridBagConstraints.CENTER, new Insets(0,0,0,0), 0,0));

        objectTypeSelectionPanel.add(target, new GridBagConstraints(0,2,1,1,1.0,1.0,
                GridBagConstraints.EAST, GridBagConstraints.CENTER, new Insets(0,0,0,0), 0,0));
        objectTypeSelectionPanel.add(targetRadioButtonLabel, new GridBagConstraints(1,2,1,1,1.0,1.0,
                GridBagConstraints.WEST, GridBagConstraints.CENTER, new Insets(0,0,0,0), 0,0));

        testPropertiesPanel.add(testTypeLabel, new GridBagConstraints(0,0,1,1,1.0,1.0,
                GridBagConstraints.CENTER, GridBagConstraints.CENTER, new Insets(0,0,0,0), 0,0));
        testPropertiesPanel.add(startTestButton, new GridBagConstraints(1,0, 1,1, 1.0,1.0,
                GridBagConstraints.WEST, GridBagConstraints.CENTER, new Insets(0,0,0,0), 0,0));
        testPropertiesPanel.add(clearGBoardButton, new GridBagConstraints(0,1, 1,1, 1.0,1.0,
                GridBagConstraints.CENTER, GridBagConstraints.CENTER, new Insets(0,0,0,0), 0,0));
        testPropertiesPanel.add(clearPathButton, new GridBagConstraints(1,1, 1,1, 1.0,1.0,
                GridBagConstraints.CENTER, GridBagConstraints.CENTER, new Insets(0,0,0,0), 0,0));

        optionsPanel.add(objectTypeSelectionPanel, new GridBagConstraints(0, 0, 1, 1, 0.2, 0.2,
                GridBagConstraints.CENTER, GridBagConstraints.BOTH, new Insets(0, 0, 0, 0), 0, 0));
        optionsPanel.add(testPropertiesPanel, new GridBagConstraints(0, 1, 1, 1, 1.0, 1.0,
                GridBagConstraints.CENTER, GridBagConstraints.BOTH, new Insets(0, 0, 0, 0), 0, 0));

        add(gBoard, new GridBagConstraints(0,0, 1,1, 1.0, 1.0,
                GridBagConstraints.CENTER, GridBagConstraints.BOTH, new Insets(0, 0, 0, 0), 0, 0));
        add(optionsPanel, new GridBagConstraints(1,0, 1,1, 0.25,0.25,
                GridBagConstraints.CENTER, GridBagConstraints.BOTH, new Insets(0,0,0,0), 0,0));
    }

    public GBoard getBoard() {
        return gBoard;
    }
}


