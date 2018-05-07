package ai;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.logging.Level;
import java.util.logging.Logger;

public class LevelUpAI implements PlayerAI
{
    private static final Logger log = Logger.getLogger(LevelUpAI.class.getName());

    private BoardObject myUnit;
    private List<UnitLevel> unitLevels;

    public LevelUpAI(BoardObject myUnit, List<UnitLevel> unitLevels) {
        this.myUnit = myUnit;
        this.unitLevels = unitLevels;
    }
	
	@Override
	public List<Command> getCommands()
	{
        List<Command> cmds = new ArrayList<>();
        int levelExperience = Integer.MAX_VALUE;
        do {
            UnitLevel unitLevel = null;
            int nextLevel = this.myUnit.getLevel() + 1;
            for(UnitLevel ul:this.unitLevels)
            {
                if(ul.unitId == this.myUnit.getUnitId() && ul.level == nextLevel)
                {
                    unitLevel = ul;
                    break;
                }
            }
            
            if(unitLevel == null)
            {
                break;
            }

            levelExperience = unitLevel.experience;
            
            if (this.myUnit.getExperience() >= levelExperience) {
                String[] attributes = {"moves","health","attack"};
                int rnd = new Random().nextInt(attributes.length);
                cmds.add(new LevelUpCommand(myUnit.getTopLeftCell(), attributes[rnd]));
                myUnit.setLevel(nextLevel);
                log.log(Level.INFO, "Level up {0}", attributes[rnd]);
            }
        } while (this.myUnit.getExperience() >= levelExperience);

		return cmds;
	}
}
