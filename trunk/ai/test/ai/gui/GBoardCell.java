package ai.gui;

import javax.swing.*;
import javax.swing.border.BevelBorder;
import javax.swing.border.Border;
import javax.swing.border.LineBorder;
import java.awt.*;

public class GBoardCell extends JPanel {
    public int x;
    public int y;

    public GBoardCell(int x, int y) {
        this.x = x;
        this.y = y;
        setBackground(GBoard.DEFAULT);
        setPreferredSize(new Dimension(5, 5));
        addMouseListener(new GBoardCellListener());
        setToolTipText(String.format("%s, %s", x, y));
        setBorder(new LineBorder(Color.DARK_GRAY));
    }
}
