use lords;

DELIMITER $$

DROP FUNCTION IF EXISTS `lords`.`get_random_int_between` $$

CREATE FUNCTION `get_random_int_between`(min_value INT, max_value INT) RETURNS INT
BEGIN
  RETURN FLOOR(RAND()*(max_value - min_value + 1) + min_value);
END$$

DROP PROCEDURE IF EXISTS `lords`.`unit_action_begin` $$

CREATE PROCEDURE `unit_action_begin`(g_id INT, p_num INT)
BEGIN
  CALL user_action_begin();
  IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
    CALL start_moving_units(g_id,p_num);
  END IF;
END$$

DROP PROCEDURE IF EXISTS `lords`.`unit_action_end` $$

CREATE PROCEDURE `unit_action_end`(g_id INT, p_num INT)
BEGIN
  IF (check_all_units_moved(g_id,p_num) = 1) THEN
    CALL finish_moving_units(g_id,p_num);
    CALL end_units_phase(g_id,p_num);
  END IF;

  CALL user_action_end();
END$$

DROP PROCEDURE IF EXISTS `lords`.`unit_shoot` $$

CREATE PROCEDURE `unit_shoot`(g_id INT, p_num INT, x INT, y INT, x2 INT, y2 INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE shooting_unit_id INT;
  DECLARE aim_type VARCHAR(45);
  DECLARE aim_board_id INT;
  DECLARE aim_unit_id INT;
  DECLARE distance INT;
  DECLARE dice INT;
  DECLARE chance INT;
  DECLARE damage_modificator INT DEFAULT 0;
  DECLARE damage INT;
  DECLARE miss INT DEFAULT 0;
  DECLARE health_before_hit,experience INT;
  DECLARE aim_no_exp INT DEFAULT 0;

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id = g_id LIMIT 1;
  SET err_code = check_unit_can_do_action(g_id,p_num,x,y,'unit_shoot'); 
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;
    SELECT bu.unit_id INTO shooting_unit_id FROM board_units bu WHERE bu.id = board_unit_id;
    SELECT b.type, b.ref INTO aim_type, aim_board_id FROM board b WHERE b.game_id = g_id AND b.x = x2 AND b.y = y2 LIMIT 1;
    IF aim_board_id IS NULL THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='no_valid_target';
    ELSE
      IF NOT EXISTS (SELECT id FROM shooting_params sp WHERE sp.unit_id = shooting_unit_id AND sp.aim_type = aim_type LIMIT 1) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='invalid_target_for_this_unit';
      ELSE
        SELECT MIN(GREATEST(ABS(shooter.x-aim.x),ABS(shooter.y-aim.y))) INTO distance
        FROM
          (SELECT b.x,b.y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=board_unit_id) shooter,
          (SELECT b.x,b.y FROM board b WHERE b.game_id=g_id AND b.`type`=aim_type AND b.ref=aim_board_id) aim;
        IF distance < (SELECT MIN(sp.distance) FROM shooting_params sp WHERE sp.unit_id = shooting_unit_id AND sp.aim_type = aim_type) THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='target_too_close';
        ELSE
          IF distance > (SELECT MAX(sp.distance) FROM shooting_params sp WHERE sp.unit_id = shooting_unit_id AND sp.aim_type = aim_type) THEN
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='target_too_far';
          ELSE

            CALL unit_action_begin(g_id, p_num);

            UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
            CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);
            
            IF aim_type = 'unit' THEN
              SELECT bu.unit_id INTO aim_unit_id FROM board_units bu WHERE bu.id = aim_board_id LIMIT 1;
              IF EXISTS (SELECT 1 FROM attack_bonus ab WHERE ab.mode_id=mode_id AND ab.unit_id IS NULL AND ab.aim_type='unit' AND ab.aim_id=aim_unit_id) THEN
                SELECT ab.dice_max, ab.chance, ab.damage_bonus INTO dice, chance, damage_modificator FROM attack_bonus ab WHERE ab.mode_id=mode_id AND ab.unit_id IS NULL AND ab.aim_type='unit' AND ab.aim_id=aim_unit_id LIMIT 1;
                IF get_random_int_between(1, dice) < chance THEN
                  SET miss=1;
                END IF;
              END IF;
              SELECT bu.health INTO health_before_hit FROM board_units bu WHERE bu.id=aim_board_id LIMIT 1;
            ELSE
              IF(building_feature_check(aim_board_id,'no_exp')=1) THEN 
                SET aim_no_exp = 1;
              END IF;
              SELECT bb.health INTO health_before_hit FROM board_buildings bb WHERE bb.id=aim_board_id LIMIT 1;
            END IF;

            IF miss=0 THEN
              SELECT sp.dice_max, sp.chance, get_random_int_between(sp.damage_modificator_min, sp.damage_modificator_max) + damage_modificator
                INTO dice, chance, damage_modificator
                FROM shooting_params sp WHERE sp.unit_id = shooting_unit_id AND sp.aim_type = aim_type AND sp.distance = distance LIMIT 1;

              IF get_random_int_between(1, dice) < chance THEN
                SET miss=1;
              END IF;
            END IF;

            INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'unit_attack');
            IF miss=1 THEN
              INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'miss_attack');
              IF aim_type = 'unit' THEN
                CALL cmd_log_add_message(g_id, p_num, 'unit_shoots_unit_miss', CONCAT_WS(';', log_unit(board_unit_id), log_unit(aim_board_id)));
              ELSE
                CALL cmd_log_add_message(g_id, p_num, 'unit_shoots_building_miss', CONCAT_WS(';', log_unit(board_unit_id), log_building(aim_board_id)));
              END IF;
            ELSE
              SELECT bu.attack + damage_modificator INTO damage FROM board_units bu WHERE bu.id=board_unit_id;

              CASE aim_type
                WHEN 'unit' THEN CALL cmd_log_add_message(g_id, p_num, 'unit_shoots_unit', CONCAT_WS(';', log_unit(board_unit_id), log_unit(aim_board_id), damage));
                ELSE CALL cmd_log_add_message(g_id, p_num, 'unit_shoots_building', CONCAT_WS(';', log_unit(board_unit_id), log_building(aim_board_id), damage));
              END CASE;

              CASE aim_type
                WHEN 'unit' THEN CALL hit_unit(aim_board_id, p_num, damage);
                WHEN 'building' THEN CALL hit_building(aim_board_id, p_num, damage);
                WHEN 'castle' THEN CALL hit_castle(aim_board_id, p_num, damage);
              END CASE;

              SET experience = get_experience_for_hitting(aim_board_id, aim_type, health_before_hit);
              IF (experience > 0 AND aim_no_exp = 0) THEN
                CALL unit_add_exp(board_unit_id, experience);
              END IF;
            END IF;

            CALL unit_action_end(g_id, p_num);

          END IF;
        END IF;
      END IF;
    END IF;
  END IF;
END$$

DROP PROCEDURE IF EXISTS `lords`.`catapult_shoot` $$
DROP PROCEDURE IF EXISTS `lords`.`archer_shoot` $$
DROP PROCEDURE IF EXISTS `lords`.`arbalester_shoot` $$

DELIMITER ;

