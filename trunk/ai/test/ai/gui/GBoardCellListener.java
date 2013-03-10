package ai.gui;

import javax.swing.JPanel;
import java.awt.Color;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;

public class GBoardCellListener extends MouseAdapter {
    private boolean flag = false;

    @Override
    public void mouseClicked(MouseEvent e) {
        JPanel b = (JPanel)e.getSource();
        if(!flag) {
            if(TesterGUI.myUnit.isSelected())
                b.setBackground(GBoard.MY_UNIT);
            else if(TesterGUI.obstacles.isSelected())
                b.setBackground(GBoard.OBSTACLE);
            else if(TesterGUI.target.isSelected())
                b.setBackground(GBoard.ENEMY);
            flag = true;
        }
        else {
            b.setBackground(new Color(60, 182, 22));
            flag = false;
        }
    }
}
