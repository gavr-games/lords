package ai.gui;

import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;

public class GBoardCellListener extends MouseAdapter {
    private static boolean mousePressed = false;
    private static boolean flag = false;

    @Override
    public void mousePressed(MouseEvent e) {
        mousePressed = true;
        GBoardCell gbc = (GBoardCell)e.getSource();
        if(gbc.getType() == GBoardCellType.EMPTY) {
            mark((GBoardCell)e.getSource());
            flag = true;
        }
        else {
            unmark((GBoardCell)e.getSource());
            flag = false;
        }
    }

    @Override
    public void mouseReleased(MouseEvent e) {
        mousePressed = false;
    }

    @Override
    public void mouseEntered(MouseEvent e) {
        if(mousePressed) {
            GBoardCell gbc = (GBoardCell)e.getSource();
            if(flag)
                mark((GBoardCell)e.getSource());
            else {
                unmark((GBoardCell)e.getSource());
            }
        }
    }

    private void mark(GBoardCell gbc) {
        if(TesterGUI.myUnit.isSelected())
            gbc.setType(GBoardCellType.MY_UNIT);
        else if(TesterGUI.obstacles.isSelected())
            gbc.setType(GBoardCellType.OBSTACLE);
        else if(TesterGUI.target.isSelected())
            gbc.setType(GBoardCellType.ENEMY);
    }

    private void unmark(GBoardCell gbc) {
        gbc.setType(GBoardCellType.EMPTY);
    }
}
