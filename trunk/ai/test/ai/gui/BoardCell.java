package ai.gui;

import javax.swing.*;
import java.awt.*;

public class BoardCell extends JPanel {
    public int x;
    public int y;
    private GridBagConstraints defaultGridBagConstraints;

    public BoardCell(int x, int y) {
        this.x = x;
        this.y = y;
        defaultGridBagConstraints = new GridBagConstraints(x,y,1,1,1.0,1.0,
                GridBagConstraints.CENTER, GridBagConstraints.BOTH, new Insets(1,1,1,1), 0, 0);
    }

    public GridBagConstraints getDefaultGridBagConstraints() {
        return defaultGridBagConstraints;
    }
}
