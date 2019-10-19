use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`repair_buildings` $$

CREATE PROCEDURE `repair_buildings`(g_id INT, p_num INT)
BEGIN
  DECLARE board_building_id INT;
  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT bb.id FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id)
                         WHERE bb.game_id=g_id AND bb.player_num=p_num AND bb.health<bb.max_health AND b.type != 'castle';
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  OPEN cur;
  REPEAT
    FETCH cur INTO board_building_id;
    IF NOT done THEN
      CALL cmd_log_add_message(g_id, p_num, 'building_completely_repaired', log_building(board_building_id));
      UPDATE board_buildings SET health=max_health WHERE id=board_building_id;
      CALL cmd_building_set_health(g_id,p_num,board_building_id);
    END IF;
  UNTIL done END REPEAT;
  CLOSE cur;


END$$

DELIMITER ;


