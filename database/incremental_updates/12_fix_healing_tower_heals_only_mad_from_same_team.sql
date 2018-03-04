use lords;

DROP PROCEDURE IF EXISTS `healing_tower_heal`;

DELIMITER ;;
CREATE PROCEDURE `healing_tower_heal`(g_id INT, board_building_id INT)
BEGIN
  DECLARE p_num INT;
  DECLARE team INT;
  DECLARE board_unit_id INT;
  DECLARE obj_x,obj_y INT;

  DECLARE ht_radius INT;
  DECLARE ht_x,ht_y INT;


  DECLARE done INT DEFAULT 0;

  DECLARE cur CURSOR FOR
    SELECT bu.id, b.x, b.y
      FROM board b
      JOIN board_units bu ON (b.ref=bu.id)
      JOIN players p ON (bu.game_id=p.game_id AND bu.player_num=p.player_num)
    WHERE
      b.game_id=g_id
      AND b.`type`='unit'
      AND b.x BETWEEN ht_x-ht_radius AND ht_x+ht_radius
      AND b.y BETWEEN ht_y-ht_radius AND ht_y+ht_radius
      AND (p.team=team OR (unit_feature_check(bu.id,'madness')=1 AND unit_feature_get_param(bu.id,'madness') IN
          (SELECT pl.player_num FROM players pl WHERE pl.game_id = g_id AND pl.team = team)));

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SELECT bb.radius,bb.player_num INTO ht_radius,p_num FROM board_buildings bb WHERE bb.id=board_building_id LIMIT 1;
  SELECT b.x,b.y INTO ht_x,ht_y FROM board b WHERE b.game_id=g_id AND b.ref=board_building_id AND b.`type`<>'unit' LIMIT 1;

  SELECT p.team INTO team FROM players p WHERE p.game_id=g_id AND p.player_num=p_num LIMIT 1;


  OPEN cur;
  REPEAT
    FETCH cur INTO board_unit_id,obj_x,obj_y;
    IF NOT done THEN
      CALL magical_heal(g_id,p_num,obj_x,obj_y,1);
    END IF;
  UNTIL done END REPEAT;
  CLOSE cur;

END ;;
DELIMITER ;

