package ai.gui;

import javax.swing.*;
import javax.swing.border.LineBorder;
import java.awt.*;

public class GBoardCell extends JPanel {
    public int x;
    public int y;
    GBoardCellType type = GBoardCellType.EMPTY;

    public GBoardCell(int x, int y) {
        this.x = x;
        this.y = y;
        setBackground(GBoard.EMPTY);
        setPreferredSize(new Dimension(5, 5));
        addMouseListener(new GBoardCellListener());
        setToolTipText(String.format("%s, %s", x, y));
        setBorder(new LineBorder(Color.DARK_GRAY));
    }

    public void setType(GBoardCellType type) {
        this.type = type;

        switch (type) {
            case MY_UNIT:
                setBackground(GBoard.MY_UNIT);
                break;
            case OBSTACLE:
                setBackground(GBoard.OBSTACLE);
                break;
            case ENEMY:
                setBackground(GBoard.ENEMY);
                break;
            case PATH:
                setBackground(GBoard.PATH);
                break;
            case EMPTY:
                setBackground(GBoard.EMPTY);
                break;
        }
    }

    public GBoardCellType getType() {
        return type;
    }
}
