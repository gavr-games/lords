USE lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `arbalester_shoot`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `arbalester_shoot`(g_id INT,p_num INT,x INT,y INT, x2 INT, y2 INT)
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
  DECLARE health_before_hit,health_after_hit,experience INT;

/*for attack bonuses - ninja, golem*/
  DECLARE aim_unit_id INT;
  DECLARE damage_modificator INT DEFAULT 0;
  DECLARE dice_max_modificator INT DEFAULT 0;
  DECLARE chance_modificator INT DEFAULT 0;

  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit1 стреляет в $log_unit2_rod_pad $log_damage")';

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'arbalester_shoot'); /*unit can do it*/
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
      SELECT b.ref INTO aim_bu_id FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.x=x2 AND b.y=y2 LIMIT 1;
      IF aim_bu_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=40;/*Unit to shoot not chosen*/
      ELSE
        SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;

        SELECT MIN(GREATEST(ABS(shooter.x-aim.x),ABS(shooter.y-aim.y))) INTO distance
        FROM
          (SELECT b.x,b.y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=board_unit_id) shooter,
          (SELECT b.x,b.y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=aim_bu_id) aim;

        IF((distance<2)OR(distance>4))THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=29;/*out of rande*/
        ELSE
/*OK*/
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
/*miss or success attack*/
            SELECT FLOOR(1 + (RAND() * dice_max_modificator)) INTO dice FROM DUAL;
            IF dice<chance_modificator THEN
              SET miss=1;
            END IF;
          END IF;

          IF miss=0 THEN
            IF distance=2 THEN /* always hit */
              SET chance=1;
            END IF;
            IF distance=3 THEN /* always,but 1/2 - minus 1 damage */
              SET chance=1;
              SET damage=damage-FLOOR(RAND() * 2);
            END IF;
            IF distance=4 THEN /* 1/2, -1 damage */
              SET chance=4;
              SET damage=damage-1;
            END IF;

            SELECT FLOOR(1 + (RAND() * 6)) INTO dice FROM DUAL;
            IF dice<chance THEN
              SET miss=1;
            END IF;
          END IF;

          SET cmd_log=REPLACE(cmd_log,'$log_unit1',log_unit(board_unit_id));
          SET cmd_log=REPLACE(cmd_log,'$log_unit2_rod_pad',log_unit_rod_pad(aim_bu_id));

          INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'unit_attack');
          IF miss=1 THEN
            SET cmd_log=REPLACE(cmd_log,'$log_damage','(Промах)');
            INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);
            INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'miss_attack');
          ELSE
            SET cmd_log=REPLACE(cmd_log,'$log_damage',log_damage(damage));
            INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

            SELECT bu.health INTO health_before_hit FROM board_units bu WHERE bu.id=aim_bu_id LIMIT 1;
            CALL hit_unit(aim_bu_id,p_num,damage);
            /*exp*/
            SELECT bu.health INTO health_after_hit FROM board_units bu WHERE bu.id=aim_bu_id LIMIT 1;
            IF (health_after_hit IS NULL) THEN
              SET health_after_hit = 0;
            END IF;
            SET experience = health_before_hit - health_after_hit;
            IF(health_after_hit = 0)THEN
              SET experience = experience + 1;
            END IF;
            IF(experience > 0)THEN
              CALL unit_add_exp(board_unit_id, experience);
            END IF;
          END IF;

          IF (check_all_units_moved(g_id,p_num) = 1) THEN
            CALL finish_moving_units(g_id,p_num);
            CALL end_turn(g_id,p_num);
          END IF;

          CALL user_action_end();
        END IF;
      END IF;
  END IF;
END$$

DROP PROCEDURE IF EXISTS `archer_shoot`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `archer_shoot`(g_id INT,p_num INT,x INT,y INT, x2 INT, y2 INT)
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
  DECLARE health_before_hit,health_after_hit,experience INT;

/*for attack bonuses - ninja, golem*/
  DECLARE aim_unit_id INT;
  DECLARE damage_modificator INT DEFAULT 0;
  DECLARE dice_max_modificator INT DEFAULT 0;
  DECLARE chance_modificator INT DEFAULT 0;

  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit1 стреляет в $log_unit2_rod_pad $log_damage")';

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'archer_shoot'); /*unit can do it*/
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
      SELECT b.ref INTO aim_bu_id FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.x=x2 AND b.y=y2 LIMIT 1;
      IF aim_bu_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=40;/*Unit to shoot not chosen*/
      ELSE
        SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;

        SELECT MIN(GREATEST(ABS(shooter.x-aim.x),ABS(shooter.y-aim.y))) INTO distance
        FROM
          (SELECT b.x,b.y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=board_unit_id) shooter,
          (SELECT b.x,b.y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=aim_bu_id) aim;

        IF((distance<2)OR(distance>4))THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=29;/*out of rande*/
        ELSE
/*OK*/
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
/*miss or success attack*/
            SELECT FLOOR(1 + (RAND() * dice_max_modificator)) INTO dice FROM DUAL;
            IF dice<chance_modificator THEN
              SET miss=1;
            END IF;
          END IF;

          IF miss=0 THEN
            IF distance=2 THEN /* always hit */
              SET chance=1;
            END IF;
            IF distance=3 THEN /* 1/2 */
              SET chance=4;
            END IF;
            IF distance=4 THEN /* 1/6 */
              SET chance=6;
            END IF;

            SELECT FLOOR(1 + (RAND() * 6)) INTO dice FROM DUAL;
            IF dice<chance THEN
              SET miss=1;
            END IF;
          END IF;

          SET cmd_log=REPLACE(cmd_log,'$log_unit1',log_unit(board_unit_id));
          SET cmd_log=REPLACE(cmd_log,'$log_unit2_rod_pad',log_unit_rod_pad(aim_bu_id));

          INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'unit_attack');
          IF miss=1 THEN
            SET cmd_log=REPLACE(cmd_log,'$log_damage','(Промах)');
            INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);
            INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'miss_attack');
          ELSE
            SET cmd_log=REPLACE(cmd_log,'$log_damage',log_damage(damage));
            INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

            SELECT bu.health INTO health_before_hit FROM board_units bu WHERE bu.id=aim_bu_id LIMIT 1;
            CALL hit_unit(aim_bu_id,p_num,damage);
            /*exp*/
            SELECT bu.health INTO health_after_hit FROM board_units bu WHERE bu.id=aim_bu_id LIMIT 1;
            IF (health_after_hit IS NULL) THEN
              SET health_after_hit = 0;
            END IF;
            SET experience = health_before_hit - health_after_hit;
            IF(health_after_hit = 0)THEN
              SET experience = experience + 1;
            END IF;
            IF(experience > 0)THEN
              CALL unit_add_exp(board_unit_id, experience);
            END IF;
          END IF;


          IF (check_all_units_moved(g_id,p_num) = 1) THEN
            CALL finish_moving_units(g_id,p_num);
            CALL end_turn(g_id,p_num);
          END IF;

          CALL user_action_end();
        END IF;
      END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `catapult_shoot`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `catapult_shoot`(g_id INT,p_num INT,x INT,y INT, x2 INT, y2 INT)
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
  DECLARE health_before_hit,health_after_hit,experience INT;

  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit1 стреляет в $log_building $log_damage")';

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'catapult_shoot'); /*unit can do it*/
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
      SELECT b.ref,b.`type` INTO aim_bb_id,aim_type FROM board b WHERE b.game_id=g_id AND (b.`type`='building' OR b.`type`='castle') AND b.x=x2 AND b.y=y2 LIMIT 1;
      IF aim_bb_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=26;/*Building not chosen*/
      ELSE
        SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;

        SELECT MIN(GREATEST(ABS(shooter.x-aim.x),ABS(shooter.y-aim.y))) INTO distance
        FROM
          (SELECT b.x,b.y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=board_unit_id) shooter,
          (SELECT b.x,b.y FROM board b WHERE b.game_id=g_id AND (b.`type`='building' OR b.`type`='castle') AND b.ref=aim_bb_id) aim;

        IF((distance<2)OR(distance>5))THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=29;/*out of rande*/
        ELSE
/*OK*/
          CALL user_action_begin();

          IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
            CALL start_moving_units(g_id,p_num);
          END IF;

          UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
          CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

          IF distance=2 THEN /* always hit */
            SET chance=1;
          END IF;
          IF distance=3 THEN /* 1/2 */
            SET chance=4;
          END IF;
          IF distance=4 THEN /* 1/3 */
            SET chance=5;
          END IF;
          IF distance=5 THEN /* 1/6 */
            SET chance=6;
          END IF;

          SELECT FLOOR(1 + (RAND() * 6)) INTO dice FROM DUAL;
          IF dice<chance THEN
            SET miss=1;
          END IF;

          SELECT bu.attack INTO damage FROM board_units bu WHERE bu.id=board_unit_id;

          SET cmd_log=REPLACE(cmd_log,'$log_unit1',log_unit(board_unit_id));
          SET cmd_log=REPLACE(cmd_log,'$log_building',log_building(aim_bb_id));

          INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'unit_attack');
          IF miss=1 THEN
            SET cmd_log=REPLACE(cmd_log,'$log_damage','(Промах)');
            INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);
            INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'miss_attack');
          ELSE
            SET cmd_log=REPLACE(cmd_log,'$log_damage',log_damage(damage));
            INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

            SELECT bb.health INTO health_before_hit FROM board_buildings bb WHERE bb.id=aim_bb_id LIMIT 1;

            CASE aim_type
              WHEN 'building' THEN CALL hit_building(aim_bb_id,p_num,damage);
              WHEN 'castle' THEN CALL hit_castle(aim_bb_id,p_num,damage);
            END CASE;

            /*exp*/
            SELECT bb.health INTO health_after_hit FROM board_buildings bb WHERE bb.id=aim_bb_id LIMIT 1;
            IF (health_after_hit IS NULL) THEN
              SET health_after_hit = 0;
            END IF;
            SET experience = health_before_hit - health_after_hit;
            IF(health_after_hit = 0)THEN
              SET experience = experience + 1;
            END IF;
            IF(experience > 0)THEN
              CALL unit_add_exp(board_unit_id, experience);
            END IF;
			
          END IF;

          IF (check_all_units_moved(g_id,p_num) = 1) THEN
            CALL finish_moving_units(g_id,p_num);
            CALL end_turn(g_id,p_num);
          END IF;

          CALL user_action_end();
        END IF;
      END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `wizard_fireball`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `wizard_fireball`(g_id INT,p_num INT,x INT,y INT, x2 INT, y2 INT)
BEGIN
  DECLARE err_code INT;
  DECLARE aim_bu_id INT;
  DECLARE board_unit_id INT;
  DECLARE dice INT;
  DECLARE fb_damage INT DEFAULT 1;
  DECLARE health_before_hit,health_after_hit,experience INT;

  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit1 колдует огненный шар на $log_unit2_rod_pad")';
  DECLARE cmd_log_fail VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Колдовство не удалось")';

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'wizard_fireball'); /*unit can do it*/
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
      SELECT b.ref INTO aim_bu_id FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.x=x2 AND b.y=y2 LIMIT 1;
      IF aim_bu_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=33;/*Noone to shoot*/
      ELSE
        CALL user_action_begin();

        IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
          CALL start_moving_units(g_id,p_num);
        END IF;

        SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;
        SELECT bu.health INTO health_before_hit FROM board_units bu WHERE bu.id=aim_bu_id LIMIT 1;

        UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
        CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

/*log*/
        SET cmd_log=REPLACE(cmd_log,'$log_unit1',log_unit(board_unit_id));
        SET cmd_log=REPLACE(cmd_log,'$log_unit2_rod_pad',log_unit_rod_pad(aim_bu_id));
        INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

        SELECT FLOOR(1 + (RAND() * 6)) INTO dice FROM DUAL;

        IF dice=1 THEN /*russian rul*/
          IF (SELECT FLOOR(1 + (RAND() * 6)) as `dice` FROM DUAL)<6 THEN
            CALL cmd_miss_russian_rul(board_unit_id);
          ELSE
            CALL kill_unit(board_unit_id,p_num);
          END IF;
        ELSE
          IF dice IN (5,6) THEN /*fireball*/
            IF (SELECT FLOOR(1 + (RAND() * 6)) as `dice` FROM DUAL)<3 THEN
              CALL cmd_miss_game_log(g_id,x2,y2);
            ELSE
              CALL magical_damage(g_id,p_num,x2,y2,fb_damage);
              SELECT bu.health INTO health_after_hit FROM board_units bu WHERE bu.id=aim_bu_id LIMIT 1;
              IF (health_after_hit IS NULL) THEN
                SET health_after_hit = 0;
              END IF;
              /*exp*/
              SET experience = health_before_hit - health_after_hit;
              IF(health_after_hit = 0)THEN
                SET experience = experience + 1;
              END IF;
              IF(experience > 0)THEN
                CALL unit_add_exp(board_unit_id, experience);
              END IF;
            END IF;
          ELSE /*fail*/
            INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log_fail);
          END IF;
        END IF;

        INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'magical_attack');

        IF (check_all_units_moved(g_id,p_num) = 1) THEN
          CALL finish_moving_units(g_id,p_num);
          CALL end_turn(g_id,p_num);
        END IF;

        CALL user_action_end();
      END IF;
  END IF;

END$$

DELIMITER ;