package ai.gui;

import javax.swing.*;
import java.awt.*;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;

public class CellListener extends MouseAdapter {
    private boolean flag = false;

    @Override
    public void mouseClicked(MouseEvent e) {
        JPanel b = (JPanel)e.getSource();
        if(!flag) {
            if(TesterGUI.myUnit.isSelected())
                b.setBackground(TesterGUI.MY_UNIT);
            else if(TesterGUI.obstacles.isSelected())
                b.setBackground(TesterGUI.OBSTACLE);
            else if(TesterGUI.target.isSelected())
                b.setBackground(TesterGUI.ENEMY);
            flag = true;
        }
        else {
            b.setBackground(new Color(60, 182, 22));
            flag = false;
        }
    }
}
