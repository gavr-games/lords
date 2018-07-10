use lords;

DELIMITER $$

DROP FUNCTION IF EXISTS `lords`.`get_distance_from_unit_to_object` $$

CREATE FUNCTION `get_distance_from_unit_to_object`(board_unit_id INT, obj_type VARCHAR(45), obj_id INT)
RETURNS int(11)
COMMENT 'obj_type can be either a type from board or ''grave'''
BEGIN
  RETURN
    (SELECT MIN(GREATEST(ABS(unit.x - obj.x),ABS(unit.y - obj.y)))
    FROM
      (SELECT b.x,b.y FROM board b WHERE b.`type`='unit' AND b.ref=board_unit_id) unit,
      (SELECT b.x,b.y FROM board b WHERE b.`type`=obj_type AND b.ref=obj_id
       UNION
       SELECT g.x,g.y FROM grave_cells g WHERE obj_type = 'grave' AND obj_id = g.grave_id) obj);
END$$

DROP FUNCTION IF EXISTS `lords`.`get_distance_between_units` $$

CREATE FUNCTION `get_distance_between_units`(board_unit_id_1 INT, board_unit_id_2 INT) RETURNS int(11)
BEGIN
  RETURN get_distance_from_unit_to_object(board_unit_id_1, 'unit', board_unit_id_2);
END$$


DROP PROCEDURE IF EXISTS `lords`.`unit_shoot` $$

CREATE PROCEDURE `unit_shoot`(g_id INT,   p_num INT,   x INT,   y INT,   x2 INT,   y2 INT)
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
        SET distance = get_distance_from_unit_to_object(board_unit_id, aim_type, aim_board_id);
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

              IF (aim_type = 'unit' AND unit_feature_check(aim_board_id, 'agressive') = 1) THEN
                CALL unit_feature_set(aim_board_id,'attack_target',board_unit_id);
              END IF;

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


DROP PROCEDURE IF EXISTS `lords`.`necromancer_resurrect` $$

CREATE PROCEDURE `necromancer_resurrect`(g_id INT,   p_num INT,   x INT,   y INT,   grave_id INT)
BEGIN
  DECLARE dead_card_id INT;
  DECLARE err_code INT;
  DECLARE u2_id INT;
  DECLARE board_unit_id INT;
  DECLARE new_unit_id INT;
  DECLARE resur_cost INT;

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'necromancer_resurrect'); 
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT id FROM graves WHERE game_id=g_id AND id=grave_id LIMIT 1) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=8;
    ELSE
      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;
      IF get_distance_from_unit_to_object(board_unit_id, 'grave', grave_id) <> 1 THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=34;
      ELSE
        IF EXISTS (SELECT b.id FROM board b JOIN grave_cells gc ON (b.x=gc.x AND b.y=gc.y) WHERE b.game_id=g_id AND gc.grave_id=grave_id LIMIT 1) THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=12;
        ELSE
          SELECT g.card_id INTO dead_card_id FROM graves g WHERE id=grave_id;
          SELECT c.cost INTO resur_cost FROM cards c WHERE c.id=dead_card_id LIMIT 1;
          IF (SELECT gold FROM players WHERE game_id=g_id AND player_num=p_num LIMIT 1)<resur_cost THEN
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=2;
          ELSE

            CALL unit_action_begin(g_id, p_num);

            UPDATE players SET gold=gold-resur_cost WHERE game_id=g_id AND player_num=p_num;
            CALL cmd_player_set_gold(g_id,p_num);

            SELECT c.ref INTO u2_id FROM cards c WHERE c.id=dead_card_id LIMIT 1;

            UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
            CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);


            INSERT INTO board_units(game_id,player_num,card_id) VALUES (g_id,p_num,dead_card_id);
            SET new_unit_id=@@last_insert_id;
            INSERT INTO board_units_features(board_unit_id,feature_id,param) SELECT new_unit_id,ufu.feature_id,ufu.param FROM unit_default_features ufu WHERE ufu.unit_id=u2_id;
            UPDATE board_units SET moves_left=0 WHERE id=new_unit_id;

            INSERT INTO board_units_features(board_unit_id,feature_id,param) SELECT new_unit_id,unit_feature_get_id_by_code('under_control'),board_unit_id;

            INSERT INTO board(game_id,x,y,`type`,ref) SELECT g_id,gc.x,gc.y,'unit',new_unit_id FROM grave_cells gc WHERE gc.grave_id=grave_id;
            DELETE FROM graves WHERE game_id=g_id AND id=grave_id;

            CALL cmd_add_unit(g_id,p_num,new_unit_id);
            CALL cmd_remove_from_grave(g_id,p_num,grave_id);
            CALL cmd_unit_set_moves_left(g_id,p_num,new_unit_id);


            CALL unit_add_exp(board_unit_id, 1);

            INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'resurrect_unit',u2_id);

            CALL cmd_log_add_message(g_id, p_num, 'unit_resurrects', CONCAT_WS(';', log_unit(board_unit_id), log_unit(new_unit_id)));

            CALL unit_action_end(g_id, p_num);

          END IF;
        END IF;
      END IF;
    END IF;
  END IF;

END$$


DROP PROCEDURE IF EXISTS `lords`.`taran_bind` $$

CREATE PROCEDURE `taran_bind`(g_id INT,   p_num INT,   x INT,   y INT,    x2 INT,    y2 INT)
BEGIN
  DECLARE err_code INT;
  DECLARE aim_bu_id INT;
  DECLARE board_unit_id INT;

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'taran_bind'); 
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;
    SELECT b.ref INTO aim_bu_id FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.x=x2 AND b.y=y2 LIMIT 1;
    IF aim_bu_id IS NULL THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=31;
    ELSE
      IF get_distance_between_units(board_unit_id, aim_bu_id) <> 1 THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=29;
      ELSE
        CALL unit_action_begin(g_id, p_num);

        UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
        CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

        CALL unit_feature_set(board_unit_id,'bind_target',aim_bu_id);

        CALL cmd_log_add_message(g_id, p_num, 'unit_attaches', CONCAT_WS(';', log_unit(board_unit_id), log_unit(aim_bu_id)));

        CALL unit_action_end(g_id, p_num);

      END IF;
    END IF;
  END IF;

END$$


DROP PROCEDURE IF EXISTS `lords`.`wizard_heal` $$

CREATE PROCEDURE `wizard_heal`(g_id INT,   p_num INT,   x INT,   y INT,    x2 INT,    y2 INT)
BEGIN
  DECLARE err_code INT;
  DECLARE aim_bu_id INT;
  DECLARE board_unit_id INT;
  DECLARE hp_heal INT DEFAULT 1;

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'wizard_heal'); 
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;
    SELECT b.ref INTO aim_bu_id FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.x=x2 AND b.y=y2 LIMIT 1;
    IF aim_bu_id IS NULL THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=32;
    ELSE
      IF get_distance_between_units(board_unit_id, aim_bu_id) <> 1 THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=29;
      ELSE
        CALL unit_action_begin(g_id, p_num);

        UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
        CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

        CALL cmd_log_add_message(g_id, p_num, 'unit_heals', CONCAT_WS(';', log_unit(board_unit_id), log_unit(aim_bu_id)));

        CALL magical_heal(g_id,p_num,x2,y2,hp_heal);

        CALL unit_action_end(g_id, p_num);
      END IF;
    END IF;
  END IF;

END$$


