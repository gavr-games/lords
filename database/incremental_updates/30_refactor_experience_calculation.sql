use lords;

DELIMITER $$

DROP FUNCTION IF EXISTS `lords`.`get_health_after_hit` $$

CREATE FUNCTION `get_health_after_hit`(aim_board_id INT, aim_type VARCHAR(45)) RETURNS INT
BEGIN
  DECLARE health_after_hit INT;

  IF (aim_type='unit') THEN
    SELECT bu.health INTO health_after_hit FROM board_units bu WHERE bu.id=aim_board_id LIMIT 1;
  ELSE
    SELECT bb.health INTO health_after_hit FROM board_buildings bb WHERE bb.id=aim_board_id LIMIT 1;
  END IF;
  IF (health_after_hit IS NULL) THEN
    SET health_after_hit = 0;
  END IF;

  RETURN health_after_hit;
END$$


DROP FUNCTION IF EXISTS `lords`.`get_experience_for_hitting` $$

CREATE FUNCTION `get_experience_for_hitting`(aim_board_id INT, aim_type VARCHAR(45), health_before_hit INT) RETURNS INT
BEGIN
  DECLARE experience INT;
  DECLARE health_after_hit INT;

  SET health_after_hit = get_health_after_hit(aim_board_id, aim_type);

  SET experience = health_before_hit - health_after_hit;
  IF(health_after_hit = 0)THEN
    SET experience = experience + 1;
  END IF;

  RETURN experience;
END$$

DROP PROCEDURE IF EXISTS `lords`.`attack_actions` $$

CREATE PROCEDURE `attack_actions`(board_unit_id INT,   aim_type VARCHAR(45),   aim_board_id INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT; 
  DECLARE p2_num INT; 
  DECLARE u_id,aim_object_id INT;
  DECLARE health_before_hit,health_after_hit,experience INT;
  DECLARE aim_card_id INT;
  DECLARE aim_x,aim_y INT;
  DECLARE aim_shield INT DEFAULT 0;
  DECLARE aim_goes_to_deck INT;
  DECLARE aim_cannot_be_vampired INT;
  DECLARE grave_id INT;
  DECLARE aim_no_exp INT DEFAULT 0;

  DECLARE damage INT;
  DECLARE attack_success,critical INT;

  DECLARE cmd_log_unit VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_attack_unit_message($x,$y,$x2,$y2,$p_num,$unit_id,$p2_num,$aim_unit_id,$attack_success,$critical,$damage,"$npc_name","$npc2_name")';
  DECLARE cmd_log_building VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_attack_building_message($x,$y,$x2,$y2,$p_num,$unit_id,$p2_num,$aim_building_id,$attack_success,$critical,$damage,"$npc_name")';
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8;

  SET cmd_log='log_add_attack_unit_message($x,$y,$x2,$y2,$p_num,$p2_num,$attack_success,$critical,$damage)';

  SELECT bu.game_id,bu.player_num,bu.unit_id INTO g_id,p_num,u_id FROM board_units bu JOIN games g ON (bu.game_id=g.id) WHERE bu.id=board_unit_id LIMIT 1;

  CASE
    WHEN aim_type='unit' THEN
    BEGIN
      SELECT bu.player_num,bu.unit_id,bu.health,bu.card_id,shield INTO p2_num,aim_object_id,health_before_hit,aim_card_id,aim_shield FROM board_units bu WHERE bu.id=aim_board_id LIMIT 1;
      SET aim_goes_to_deck = unit_feature_check(aim_board_id,'goes_to_deck_on_death');
      SET aim_cannot_be_vampired = unit_feature_check(aim_board_id,'mechanical') + unit_feature_check(aim_board_id,'magic_immunity');
      SELECT MIN(b.x),MIN(b.y) INTO aim_x,aim_y FROM board b WHERE b.game_id=g_id AND b.`type`=aim_type AND b.ref=aim_board_id;
      SET cmd_log = REPLACE(cmd_log_unit, '$aim_unit_id', aim_object_id);
      IF ((SELECT p.owner FROM players p WHERE p.game_id = g_id AND p.player_num = p2_num LIMIT 1) <> 1) THEN
        SET cmd_log=REPLACE(cmd_log,'$npc2_name', (SELECT p.name FROM players p WHERE p.game_id = g_id AND p.player_num = p2_num LIMIT 1));
      ELSE
        SET cmd_log=REPLACE(cmd_log,'$npc2_name', '');
      END IF;
    END;
    WHEN aim_type='building' OR aim_type='castle' THEN
    BEGIN
      SELECT bb.player_num,bb.building_id,bb.health INTO p2_num,aim_object_id,health_before_hit FROM board_buildings bb WHERE bb.id=aim_board_id LIMIT 1;
      SELECT b.x,b.y INTO aim_x,aim_y FROM board b WHERE b.game_id=g_id AND b.`type`=aim_type AND b.ref=aim_board_id LIMIT 1;
      SET cmd_log = REPLACE(cmd_log_building, '$aim_building_id', aim_object_id);
    END;
  END CASE;

  CALL calculate_attack_damage(board_unit_id,aim_type,aim_board_id,attack_success,damage,critical);

      SET cmd_log=REPLACE(cmd_log,'$unit_id',u_id);
      SET cmd_log=REPLACE(cmd_log,'$x,$y',(SELECT CONCAT(b.x,',',b.y) FROM board b WHERE b.`type`='unit' AND b.ref=board_unit_id LIMIT 1));
      SET cmd_log=REPLACE(cmd_log,'$x2,$y2',(SELECT CONCAT(aim_x,',',aim_y) FROM DUAL));

      SET cmd_log=REPLACE(cmd_log,'$p_num',p_num);
      SET cmd_log=REPLACE(cmd_log,'$p2_num',p2_num);

      SET cmd_log=REPLACE(cmd_log,'$attack_success',attack_success);
      SET cmd_log=REPLACE(cmd_log,'$critical',critical);
      SET cmd_log=REPLACE(cmd_log,'$damage',CASE WHEN aim_shield=0 THEN damage ELSE 0 END);
      IF ((SELECT p.owner FROM players p WHERE p.game_id = g_id AND p.player_num = p_num LIMIT 1) <> 1) THEN
        SET cmd_log=REPLACE(cmd_log,'$npc_name', (SELECT p.name FROM players p WHERE p.game_id = g_id AND p.player_num = p_num LIMIT 1));
      ELSE
        SET cmd_log=REPLACE(cmd_log,'$npc_name', '');
      END IF;

      INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

  IF critical=1 THEN
    INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'critical_hit');
  END IF;

      IF attack_success=1 THEN 

        
        IF(aim_type='unit' AND unit_feature_check(aim_board_id,'agressive')=1) THEN 
          CALL unit_feature_set(aim_board_id,'attack_target',board_unit_id);
        END IF;

        IF(aim_type='building' AND building_feature_check(aim_board_id,'no_exp')=1) THEN 
          SET aim_no_exp = 1;
        END IF;

        CASE aim_type
          WHEN 'unit' THEN CALL hit_unit(aim_board_id,p_num,damage);
          WHEN 'building' THEN CALL hit_building(aim_board_id,p_num,damage);
          WHEN 'castle' THEN CALL hit_castle(aim_board_id,p_num,damage);
        END CASE;

        SET health_after_hit = get_health_after_hit(aim_board_id, aim_type);

        SET experience = get_experience_for_hitting(aim_board_id, aim_type, health_before_hit);
        IF(experience > 0 AND aim_no_exp = 0 AND EXISTS(SELECT id FROM board_units WHERE id=board_unit_id))THEN
          CALL unit_add_exp(board_unit_id, experience);
        END IF;

        IF (aim_type='unit') THEN

          IF (unit_feature_check(board_unit_id,'drink_health')=1) AND (health_after_hit<health_before_hit)THEN
            CALL drink_health(board_unit_id);
          END IF;


          IF (unit_feature_check(board_unit_id,'vamp')=1) AND (health_after_hit = 0) AND (aim_cannot_be_vampired = 0) THEN
            IF (aim_card_id IS NOT NULL AND aim_goes_to_deck=0) THEN
              SELECT gc.grave_id INTO grave_id FROM graves g JOIN grave_cells gc ON g.id=gc.grave_id WHERE g.game_id=g_id AND g.card_id=aim_card_id AND gc.x=aim_x AND gc.y=aim_y LIMIT 1;
              CALL vampire_resurrect_by_card(board_unit_id,grave_id);
            ELSE
              CALL vampire_resurrect_by_u_id(board_unit_id,aim_object_id,aim_x,aim_y);
            END IF;
          END IF;
          
          IF(unit_feature_check(board_unit_id,'pushes')=1 AND aim_type='unit') THEN 
            CALL unit_push(board_unit_id,aim_board_id);
          END IF;

        END IF;

      ELSE 
        INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'miss_attack');
      END IF;

END$$


DROP PROCEDURE IF EXISTS `lords`.`arbalester_shoot` $$

CREATE PROCEDURE `arbalester_shoot`(g_id INT,  p_num INT,  x INT,  y INT,   x2 INT,   y2 INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE err_code INT;
  DECLARE aim_bu_id INT;
  DECLARE board_unit_id INT;
  DECLARE distance INT;
  DECLARE dice INT;
  DECLARE chance INT;
  DECLARE damage INT;
  DECLARE miss INT DEFAULT 0;
  DECLARE health_before_hit,experience INT;


  DECLARE aim_unit_id INT;
  DECLARE damage_modificator INT DEFAULT 0;
  DECLARE dice_max_modificator INT DEFAULT 0;
  DECLARE chance_modificator INT DEFAULT 0;

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'arbalester_shoot'); 
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
      SELECT b.ref INTO aim_bu_id FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.x=x2 AND b.y=y2 LIMIT 1;
      IF aim_bu_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=40;
      ELSE
        SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;

        SELECT MIN(GREATEST(ABS(shooter.x-aim.x),ABS(shooter.y-aim.y))) INTO distance
        FROM
          (SELECT b.x,b.y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=board_unit_id) shooter,
          (SELECT b.x,b.y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=aim_bu_id) aim;

        IF((distance<2)OR(distance>4))THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=29;
        ELSE

          CALL user_action_begin();

          IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
            CALL start_moving_units(g_id,p_num);
          END IF;

          UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
          CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

          SELECT unit_id INTO aim_unit_id FROM board_units WHERE id=aim_bu_id;
          IF EXISTS(SELECT 1 FROM attack_bonus ab WHERE ab.mode_id=mode_id AND ab.unit_id IS NULL AND ab.aim_type='unit' AND ab.aim_id=aim_unit_id)THEN
            SELECT ab.dice_max,ab.chance,ab.damage_bonus INTO dice_max_modificator,chance_modificator,damage_modificator FROM attack_bonus ab WHERE ab.mode_id=mode_id AND ab.unit_id IS NULL AND ab.aim_type='unit' AND ab.aim_id=aim_unit_id LIMIT 1;
          END IF;

          SELECT bu.attack+damage_modificator INTO damage FROM board_units bu WHERE bu.id=board_unit_id;
          IF(dice_max_modificator > 0)THEN

            SELECT FLOOR(1 + (RAND() * dice_max_modificator)) INTO dice FROM DUAL;
            IF dice<chance_modificator THEN
              SET miss=1;
            END IF;
          END IF;

          IF miss=0 THEN
            IF distance=2 THEN 
              SET chance=1;
            END IF;
            IF distance=3 THEN 
              SET chance=1;
              SET damage=damage-FLOOR(RAND() * 2);
            END IF;
            IF distance=4 THEN 
              SET chance=4;
              SET damage=damage-1;
            END IF;

            SELECT FLOOR(1 + (RAND() * 6)) INTO dice FROM DUAL;
            IF dice<chance THEN
              SET miss=1;
            END IF;
          END IF;

          INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'unit_attack');
          IF miss=1 THEN
            CALL cmd_log_add_message(g_id, p_num, 'unit_shoots_unit_miss', CONCAT_WS(';', log_unit(board_unit_id), log_unit(aim_bu_id)));
            INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'miss_attack');
          ELSE
            CALL cmd_log_add_message(g_id, p_num, 'unit_shoots_unit', CONCAT_WS(';', log_unit(board_unit_id), log_unit(aim_bu_id), damage));

            SELECT bu.health INTO health_before_hit FROM board_units bu WHERE bu.id=aim_bu_id LIMIT 1;
            CALL hit_unit(aim_bu_id,p_num,damage);

            SET experience = get_experience_for_hitting(aim_bu_id, 'unit', health_before_hit);
            IF(experience > 0)THEN
              CALL unit_add_exp(board_unit_id, experience);
            END IF;
          END IF;

          IF (check_all_units_moved(g_id,p_num) = 1) THEN
            CALL finish_moving_units(g_id,p_num);
            CALL end_units_phase(g_id,p_num);
          END IF;

          CALL user_action_end();
        END IF;
      END IF;
  END IF;
  
END$$

DROP PROCEDURE IF EXISTS `lords`.`archer_shoot` $$

CREATE PROCEDURE `archer_shoot`(g_id INT,  p_num INT,  x INT,  y INT,   x2 INT,   y2 INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE err_code INT;
  DECLARE aim_bu_id INT;
  DECLARE board_unit_id INT;
  DECLARE distance INT;
  DECLARE dice INT;
  DECLARE chance INT;
  DECLARE damage INT;
  DECLARE miss INT DEFAULT 0;
  DECLARE health_before_hit,experience INT;

  DECLARE aim_unit_id INT;
  DECLARE damage_modificator INT DEFAULT 0;
  DECLARE dice_max_modificator INT DEFAULT 0;
  DECLARE chance_modificator INT DEFAULT 0;

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'archer_shoot'); 
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
      SELECT b.ref INTO aim_bu_id FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.x=x2 AND b.y=y2 LIMIT 1;
      IF aim_bu_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=40;
      ELSE
        SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;

        SELECT MIN(GREATEST(ABS(shooter.x-aim.x),ABS(shooter.y-aim.y))) INTO distance
        FROM
          (SELECT b.x,b.y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=board_unit_id) shooter,
          (SELECT b.x,b.y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=aim_bu_id) aim;

        IF((distance<2)OR(distance>4))THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=29;
        ELSE

          CALL user_action_begin();

          IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
            CALL start_moving_units(g_id,p_num);
          END IF;

          UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
          CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

          SELECT unit_id INTO aim_unit_id FROM board_units WHERE id=aim_bu_id;
          IF EXISTS(SELECT 1 FROM attack_bonus ab WHERE ab.mode_id=mode_id AND ab.unit_id IS NULL AND ab.aim_type='unit' AND ab.aim_id=aim_unit_id)THEN
            SELECT ab.dice_max,ab.chance,ab.damage_bonus INTO dice_max_modificator,chance_modificator,damage_modificator FROM attack_bonus ab WHERE ab.mode_id=mode_id AND ab.unit_id IS NULL AND ab.aim_type='unit' AND ab.aim_id=aim_unit_id LIMIT 1;
          END IF;

          SELECT bu.attack+damage_modificator INTO damage FROM board_units bu WHERE bu.id=board_unit_id;
          IF(dice_max_modificator > 0)THEN

            SELECT FLOOR(1 + (RAND() * dice_max_modificator)) INTO dice FROM DUAL;
            IF dice<chance_modificator THEN
              SET miss=1;
            END IF;
          END IF;

          IF miss=0 THEN
            IF distance=2 THEN 
              SET chance=1;
            END IF;
            IF distance=3 THEN 
              SET chance=4;
            END IF;
            IF distance=4 THEN 
              SET chance=6;
            END IF;

            SELECT FLOOR(1 + (RAND() * 6)) INTO dice FROM DUAL;
            IF dice<chance THEN
              SET miss=1;
            END IF;
          END IF;

          INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'unit_attack');
          IF miss=1 THEN
            CALL cmd_log_add_message(g_id, p_num, 'unit_shoots_unit_miss', CONCAT_WS(';', log_unit(board_unit_id), log_unit(aim_bu_id)));
            INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'miss_attack');
          ELSE
            CALL cmd_log_add_message(g_id, p_num, 'unit_shoots_unit', CONCAT_WS(';', log_unit(board_unit_id), log_unit(aim_bu_id), damage));

            SELECT bu.health INTO health_before_hit FROM board_units bu WHERE bu.id=aim_bu_id LIMIT 1;
            CALL hit_unit(aim_bu_id,p_num,damage);

            SET experience = get_experience_for_hitting(aim_bu_id, 'unit', health_before_hit);
            IF(experience > 0)THEN
              CALL unit_add_exp(board_unit_id, experience);
            END IF;
          END IF;


          IF (check_all_units_moved(g_id,p_num) = 1) THEN
            CALL finish_moving_units(g_id,p_num);
            CALL end_units_phase(g_id,p_num);
          END IF;

          CALL user_action_end();
        END IF;
      END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`catapult_shoot` $$

CREATE PROCEDURE `catapult_shoot`(g_id INT,   p_num INT,   x INT,   y INT,    x2 INT,    y2 INT)
BEGIN
  DECLARE err_code INT;
  DECLARE aim_bb_id INT;
  DECLARE aim_type VARCHAR(45);
  DECLARE board_unit_id INT;
  DECLARE distance INT;
  DECLARE dice INT;
  DECLARE chance INT;
  DECLARE damage INT;
  DECLARE miss INT DEFAULT 0;
  DECLARE health_before_hit,experience INT;
  DECLARE aim_no_exp INT DEFAULT 0;

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'catapult_shoot'); 
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
      SELECT b.ref,b.`type` INTO aim_bb_id,aim_type FROM board b WHERE b.game_id=g_id AND (b.`type`='building' OR b.`type`='castle') AND b.x=x2 AND b.y=y2 LIMIT 1;
      IF aim_bb_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=26;
      ELSE
        SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;

        SELECT MIN(GREATEST(ABS(shooter.x-aim.x),ABS(shooter.y-aim.y))) INTO distance
        FROM
          (SELECT b.x,b.y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=board_unit_id) shooter,
          (SELECT b.x,b.y FROM board b WHERE b.game_id=g_id AND (b.`type`='building' OR b.`type`='castle') AND b.ref=aim_bb_id) aim;

        IF((distance<2)OR(distance>5))THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=29;
        ELSE

          CALL user_action_begin();

          IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
            CALL start_moving_units(g_id,p_num);
          END IF;

          UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
          CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

          IF distance=2 THEN 
            SET chance=1;
          END IF;
          IF distance=3 THEN 
            SET chance=4;
          END IF;
          IF distance=4 THEN 
            SET chance=5;
          END IF;
          IF distance=5 THEN 
            SET chance=6;
          END IF;

          SELECT FLOOR(1 + (RAND() * 6)) INTO dice FROM DUAL;
          IF dice<chance THEN
            SET miss=1;
          END IF;

          SELECT bu.attack INTO damage FROM board_units bu WHERE bu.id=board_unit_id;

          INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'unit_attack');
          IF miss=1 THEN
            CALL cmd_log_add_message(g_id, p_num, 'unit_shoots_building_miss', CONCAT_WS(';', log_unit(board_unit_id), log_building(aim_bb_id)));
            INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'miss_attack');
          ELSE
            CALL cmd_log_add_message(g_id, p_num, 'unit_shoots_building', CONCAT_WS(';', log_unit(board_unit_id), log_building(aim_bb_id), damage));

            SELECT bb.health INTO health_before_hit FROM board_buildings bb WHERE bb.id=aim_bb_id LIMIT 1;
            IF(building_feature_check(aim_bb_id,'no_exp')=1) THEN 
              SET aim_no_exp = 1;
            END IF;

            CASE aim_type
              WHEN 'building' THEN CALL hit_building(aim_bb_id,p_num,damage);
              WHEN 'castle' THEN CALL hit_castle(aim_bb_id,p_num,damage);
            END CASE;

            SET experience = get_experience_for_hitting(aim_bb_id, aim_type, health_before_hit);
            IF(experience > 0 AND aim_no_exp = 0)THEN
              CALL unit_add_exp(board_unit_id, experience);
            END IF;

          END IF;

          IF (check_all_units_moved(g_id,p_num) = 1) THEN
            CALL finish_moving_units(g_id,p_num);
            CALL end_units_phase(g_id,p_num);
          END IF;

          CALL user_action_end();
        END IF;
      END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`wizard_fireball` $$

CREATE PROCEDURE `wizard_fireball`(g_id INT,   p_num INT,   x INT,   y INT,    x2 INT,    y2 INT)
BEGIN
  DECLARE err_code INT;
  DECLARE aim_bu_id INT;
  DECLARE board_unit_id INT;
  DECLARE dice INT;
  DECLARE fb_damage INT DEFAULT 1;
  DECLARE health_before_hit,experience INT;

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'wizard_fireball'); 
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
      SELECT b.ref INTO aim_bu_id FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.x=x2 AND b.y=y2 LIMIT 1;
      IF aim_bu_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=33;
      ELSE
        CALL user_action_begin();

        IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
          CALL start_moving_units(g_id,p_num);
        END IF;

        SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;
        SELECT bu.health INTO health_before_hit FROM board_units bu WHERE bu.id=aim_bu_id LIMIT 1;

        UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
        CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

        CALL cmd_log_add_message(g_id, p_num, 'unit_casts_fb', CONCAT_WS(';', log_unit(board_unit_id), log_unit(aim_bu_id)));

        SELECT FLOOR(1 + (RAND() * 6)) INTO dice FROM DUAL;

        IF dice=1 THEN 
          IF (SELECT FLOOR(1 + (RAND() * 6)) as `dice` FROM DUAL)<6 THEN
            CALL cmd_log_add_message(g_id, p_num, 'miss_rus_rul', log_unit(board_unit_id));
          ELSE
            CALL magic_kill_unit(board_unit_id,p_num);
          END IF;
        ELSE
          IF dice IN (5,6) THEN 
            IF (SELECT FLOOR(1 + (RAND() * 6)) as `dice` FROM DUAL)<3 THEN
              CALL cmd_miss_game_log(g_id,x2,y2);
            ELSE
              CALL magical_damage(g_id,p_num,x2,y2,fb_damage);
              
              SET experience = get_experience_for_hitting(aim_bu_id, 'unit', health_before_hit);
              IF(experience > 0)THEN
                CALL unit_add_exp(board_unit_id, experience);
              END IF;
            END IF;
          ELSE 
            CALL cmd_log_add_message(g_id, p_num, 'cast_unsuccessful', NULL);
          END IF;
        END IF;

        INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'magical_attack');

        IF (check_all_units_moved(g_id,p_num) = 1) THEN
          CALL finish_moving_units(g_id,p_num);
          CALL end_units_phase(g_id,p_num);
        END IF;

        CALL user_action_end();
      END IF;
  END IF;

END$$

DELIMITER ;
