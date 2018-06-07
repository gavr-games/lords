use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`get_random_free_cell_near_building` $$

CREATE PROCEDURE `get_random_free_cell_near_building`(board_building_id INT, OUT x INT, OUT y INT)
BEGIN
  DECLARE g_id INT;
  DECLARE g_mode INT;

  SELECT game_id INTO g_id FROM board_buildings WHERE id=board_building_id LIMIT 1;
  SELECT mode_id INTO g_mode FROM games WHERE id=g_id LIMIT 1;

  SELECT DISTINCT a.x,a.y INTO x,y 
    FROM allcoords a, board b
    WHERE b.game_id=g_id
      AND b.`type`<>'unit'
      AND b.ref=board_building_id
      AND a.mode_id=g_mode
      AND (ABS(b.x-a.x)<=1 AND ABS(b.y-a.y)<=1)
      AND NOT EXISTS (SELECT b2.id FROM board b2 WHERE b2.x=a.x AND b2.y=a.y)
    ORDER BY RAND() LIMIT 1;
END$$

DROP FUNCTION IF EXISTS `lords`.`free_cell_near_building_exists` $$

CREATE FUNCTION `free_cell_near_building_exists`(board_building_id INT) RETURNS INT
BEGIN
  DECLARE x, y INT;
  CALL get_random_free_cell_near_building(board_building_id, x, y);
  RETURN IF(x IS NOT NULL, 1, 0);
END$$

DROP PROCEDURE IF EXISTS `lords`.`summon_creatures` $$

CREATE PROCEDURE `summon_creatures`(board_building_id INT)
BEGIN
  DECLARE g_id INT;
  DECLARE g_mode INT;
  DECLARE bld_id INT;
  DECLARE cr_count INT;
  DECLARE x, y INT;
  DECLARE cr_owner INT;
  DECLARE cr_unit_id INT;

  DECLARE done INT DEFAULT 0;

  DECLARE cur CURSOR FOR
    SELECT sc.unit_id,sc.`count`,sc.owner
      FROM summon_cfg sc
      WHERE building_id = bld_id AND mode_id = g_mode;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SELECT game_id,building_id INTO g_id,bld_id FROM board_buildings WHERE id=board_building_id LIMIT 1;

  SELECT mode_id INTO g_mode FROM games WHERE id=g_id LIMIT 1;

  OPEN cur;
  REPEAT
    FETCH cur INTO cr_unit_id, cr_count, cr_owner;
    IF NOT done THEN
      WHILE (cr_count>0 AND free_cell_near_building_exists(board_building_id)) DO
        CALL get_random_free_cell_near_building(board_building_id, x, y);
        SET cr_count = cr_count - 1;
        CALL summon_creature(g_id, cr_owner, cr_unit_id, x, y, board_building_id);
      END WHILE;
    END IF;
  UNTIL done END REPEAT;
  CLOSE cur;

END$$

DROP PROCEDURE IF EXISTS `lords`.`summon_one_creature_by_config` $$

CREATE PROCEDURE `summon_one_creature_by_config`(board_building_id INT)
BEGIN
  DECLARE g_id INT;
  DECLARE g_mode INT;
  DECLARE bld_id INT;
  DECLARE x, y INT;
  DECLARE cr_owner INT;
  DECLARE cr_unit_id INT;

  SELECT game_id,building_id INTO g_id,bld_id FROM board_buildings WHERE id=board_building_id LIMIT 1;

  SELECT mode_id INTO g_mode FROM games WHERE id=g_id LIMIT 1;

  SELECT sc.unit_id,sc.owner INTO cr_unit_id,cr_owner
    FROM summon_cfg sc
    WHERE building_id = bld_id AND mode_id = g_mode ORDER BY RAND() LIMIT 1;

  CALL get_random_free_cell_near_building(board_building_id, x, y);
  IF x IS NOT NULL THEN
    CALL summon_creature(g_id,cr_owner,cr_unit_id,x,y,board_building_id);
  END IF;

END$$

DROP FUNCTION IF EXISTS `lords`.`get_number_of_spawned_creatures` $$

CREATE FUNCTION `get_number_of_spawned_creatures`(board_building_id INT) RETURNS INT
BEGIN
  DECLARE g_id INT;

  SELECT game_id INTO g_id FROM board_buildings WHERE id=board_building_id LIMIT 1;

  RETURN (SELECT COUNT(*) FROM board_units bu
    WHERE bu.game_id = g_id
      AND unit_feature_check(bu.id, 'parent_building') = 1
      AND unit_feature_get_param(bu.id, 'parent_building') = board_building_id);
END$$

DROP PROCEDURE IF EXISTS `lords`.`barracks_summon` $$

CREATE PROCEDURE `barracks_summon`(g_id INT,  board_building_id INT)
BEGIN
  DECLARE spawned_count INT;
  DECLARE dice INT;

  SET spawned_count = get_number_of_spawned_creatures(board_building_id);
  SET dice = POW(6, CASE WHEN spawned_count IN(0,1,2,3) THEN 1 ELSE spawned_count-2 END);
  IF (get_random_int_between(1, dice) = 1) THEN
    CALL summon_one_creature_by_config(board_building_id);
  END IF;
END$$

DROP PROCEDURE IF EXISTS `lords`.`lake_summon_frogs` $$

CREATE PROCEDURE `lake_summon_frogs`(g_id INT,  board_building_id INT)
BEGIN
  DECLARE spawned_count INT;
  DECLARE dice INT;

  IF EXISTS(SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id AND (unit_feature_check(bu.id,'parent_building')=0 OR unit_feature_get_param(bu.id,'parent_building')<>board_building_id) LIMIT 1) THEN
    SET spawned_count = get_number_of_spawned_creatures(board_building_id);
    SET dice = POW(6, CASE WHEN spawned_count IN(0,1,2,3) THEN 1 ELSE spawned_count-2 END);
    IF (get_random_int_between(1, dice) = 1) THEN
      CALL summon_one_creature_by_config(board_building_id);
    END IF;
  END IF;
END$$

DROP PROCEDURE IF EXISTS `lords`.`mountains_summon_troll` $$

CREATE PROCEDURE `mountains_summon_troll`(g_id INT,  board_building_id INT)
BEGIN
  DECLARE spawned_count INT;
  DECLARE dice INT;

  IF EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.`type`='building' LIMIT 1) THEN
    SET spawned_count = get_number_of_spawned_creatures(board_building_id);
    SET dice = POW(6, spawned_count + 1);
    IF (get_random_int_between(1, dice) = 1) THEN
      CALL summon_one_creature_by_config(board_building_id);
    END IF;
  END IF;

END$$

DELIMITER ;
