USE lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `unit_add_exp`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `unit_add_exp`(board_unit_id INT, qty INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;

  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'unit_add_exp($bu_id,$qty)';

  SELECT bu.game_id,bu.player_num INTO g_id,p_num FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

  UPDATE board_units SET experience = experience + qty WHERE id=board_unit_id;

  SET cmd=REPLACE(cmd,'$bu_id',board_unit_id);
  SET cmd=REPLACE(cmd,'$qty',(SELECT experience FROM board_units WHERE id=board_unit_id LIMIT 1));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END$$

DROP PROCEDURE IF EXISTS `attack_actions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `attack_actions`(board_unit_id INT,aim_type VARCHAR(45),aim_board_id INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT; /*atacker*/
  DECLARE p2_num INT; /*aim*/
  DECLARE u_id,aim_object_id INT;
  DECLARE aim_short_name VARCHAR(45) CHARSET utf8;
  DECLARE health_before_hit,health_after_hit,experience INT;
  DECLARE aim_card_id INT;
  DECLARE aim_x,aim_y INT;
  DECLARE aim_shield INT DEFAULT 0;
  DECLARE aim_goes_to_deck INT;
  DECLARE grave_id INT;

  DECLARE damage INT;
  DECLARE attack_success,critical INT;

  DECLARE cmd_log VARCHAR(1000) CHARSET utf8;

  SET cmd_log='log_add_attack_message($x,$y,$x2,$y2,$p_num,"$u_short_name",$p2_num,"$aim_short_name",$attack_success,$critical,$damage)';

  SELECT bu.game_id,bu.player_num,bu.unit_id INTO g_id,p_num,u_id FROM board_units bu JOIN games g ON (bu.game_id=g.id) WHERE bu.id=board_unit_id LIMIT 1;

  CASE
    WHEN aim_type='unit' THEN
    BEGIN
      SELECT bu.player_num,bu.unit_id,bu.health,bu.card_id,shield INTO p2_num,aim_object_id,health_before_hit,aim_card_id,aim_shield FROM board_units bu WHERE bu.id=aim_board_id LIMIT 1;
      SET aim_goes_to_deck = unit_feature_check(aim_board_id,'goes_to_deck_on_death');
      SELECT MIN(b.x),MIN(b.y) INTO aim_x,aim_y FROM board b WHERE b.game_id=g_id AND b.`type`=aim_type AND b.ref=aim_board_id;
      SELECT log_short_name INTO aim_short_name FROM units WHERE id=aim_object_id LIMIT 1;
    END;
    WHEN aim_type='building' OR aim_type='castle' THEN
    BEGIN
      SELECT bb.player_num,bb.building_id,bb.health INTO p2_num,aim_object_id,health_before_hit FROM board_buildings bb WHERE bb.id=aim_board_id LIMIT 1;
      SELECT b.x,b.y INTO aim_x,aim_y FROM board b WHERE b.game_id=g_id AND b.`type`=aim_type AND b.ref=aim_board_id LIMIT 1;
      SELECT log_short_name INTO aim_short_name FROM buildings WHERE id=aim_object_id LIMIT 1;
    END;
  END CASE;

  CALL calculate_attack_damage(board_unit_id,aim_type,aim_board_id,attack_success,damage,critical);

/*log*/
      SET cmd_log=REPLACE(cmd_log,'$x,$y',(SELECT CONCAT(b.x,',',b.y) FROM board b WHERE b.`type`='unit' AND b.ref=board_unit_id LIMIT 1));
      SET cmd_log=REPLACE(cmd_log,'$x2,$y2',(SELECT CONCAT(aim_x,',',aim_y) FROM DUAL));

      SET cmd_log=REPLACE(cmd_log,'$p_num',p_num);
      SET cmd_log=REPLACE(cmd_log,'$p2_num',p2_num);

      SET cmd_log=REPLACE(cmd_log,'$u_short_name',(SELECT log_short_name FROM units WHERE id=u_id LIMIT 1));
      SET cmd_log=REPLACE(cmd_log,'$aim_short_name',aim_short_name);

      SET cmd_log=REPLACE(cmd_log,'$attack_success',attack_success);
      SET cmd_log=REPLACE(cmd_log,'$critical',critical);
      SET cmd_log=REPLACE(cmd_log,'$damage',CASE WHEN aim_shield=0 THEN damage ELSE 0 END);

      INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

  IF critical=1 THEN
    INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'critical_hit');
  END IF;

      IF attack_success=1 THEN /*not miss*/

        /*troll agres*/
        IF(aim_type='unit' AND unit_feature_check(aim_board_id,'agressive')=1) THEN /*if agressive - set attack target*/
          CALL unit_feature_set(aim_board_id,'attack_target',board_unit_id);
        END IF;

        CASE aim_type
          WHEN 'unit' THEN CALL hit_unit(aim_board_id,p_num,damage);
          WHEN 'building' THEN CALL hit_building(aim_board_id,p_num,damage);
          WHEN 'castle' THEN CALL hit_castle(aim_board_id,p_num,damage);
        END CASE;

        IF (aim_type='unit') THEN
          SELECT IFNULL(bu.health,0) INTO health_after_hit FROM board_units bu WHERE bu.id=aim_board_id LIMIT 1;
        ELSE
          SELECT IFNULL(bb.health,0) INTO health_after_hit FROM board_buildings bb WHERE bb.id=aim_board_id LIMIT 1;
        END IF;

/*exp*/
        SET experience = health_before_hit - health_after_hit;
        IF(health_after_hit = 0)THEN
          SET experience = experience + 1;
        END IF;
        IF(experience > 0)THEN
          CALL unit_add_exp(board_unit_id, experience);
        END IF;

        IF (aim_type='unit') THEN
/*drink health*/
          IF (unit_feature_check(board_unit_id,'drink_health')=1) AND (health_after_hit<health_before_hit)THEN
            CALL drink_health(board_unit_id);
          END IF;

/*vampirism*/
          IF (unit_feature_check(board_unit_id,'vamp')=1) AND (health_after_hit IS NULL) THEN
            IF (aim_card_id IS NOT NULL AND aim_goes_to_deck=0) THEN
              SELECT gc.grave_id INTO grave_id FROM graves g JOIN grave_cells gc ON g.id=gc.grave_id WHERE g.game_id=g_id AND g.card_id=aim_card_id AND gc.x=aim_x AND gc.y=aim_y LIMIT 1;
              CALL vampire_resurrect_by_card(board_unit_id,grave_id);
            ELSE
              CALL vampire_resurrect_by_u_id(board_unit_id,aim_object_id,aim_x,aim_y);
            END IF;
          END IF;

          /*taran pushes*/
          IF(unit_feature_check(board_unit_id,'pushes')=1 AND aim_type='unit') THEN /*if pushes - push*/
            CALL unit_push(board_unit_id,aim_board_id);
          END IF;

        END IF;

      ELSE /*miss*/
        INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'miss_attack');
      END IF;

END$$

DROP PROCEDURE IF EXISTS wizard_fireball$$
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
              SELECT IFNULL(bu.health,0) INTO health_after_hit FROM board_units bu WHERE bu.id=aim_bu_id LIMIT 1;
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

        IF NOT EXISTS(SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id AND bu.player_num=p_num AND moves_left>0 AND unit_feature_check(bu.id,'paralich')=0 LIMIT 1) THEN
          CALL finish_moving_units(g_id,p_num);
          CALL end_turn(g_id,p_num);
        END IF;

        CALL user_action_end();
      END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS archer_shoot$$
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
            SELECT IFNULL(bu.health,0) INTO health_after_hit FROM board_units bu WHERE bu.id=aim_bu_id LIMIT 1;
            SET experience = health_before_hit - health_after_hit;
            IF(health_after_hit = 0)THEN
              SET experience = experience + 1;
            END IF;
            IF(experience > 0)THEN
              CALL unit_add_exp(board_unit_id, experience);
            END IF;
          END IF;


          IF NOT EXISTS(SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id AND bu.player_num=p_num AND moves_left>0 AND unit_feature_check(bu.id,'paralich')=0 LIMIT 1) THEN
            CALL finish_moving_units(g_id,p_num);
            CALL end_turn(g_id,p_num);
          END IF;

          CALL user_action_end();
        END IF;
      END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS arbalester_shoot$$
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
            SELECT IFNULL(bu.health,0) INTO health_after_hit FROM board_units bu WHERE bu.id=aim_bu_id LIMIT 1;
            SET experience = health_before_hit - health_after_hit;
            IF(health_after_hit = 0)THEN
              SET experience = experience + 1;
            END IF;
            IF(experience > 0)THEN
              CALL unit_add_exp(board_unit_id, experience);
            END IF;
          END IF;

          IF NOT EXISTS(SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id AND bu.player_num=p_num AND moves_left>0 AND unit_feature_check(bu.id,'paralich')=0 LIMIT 1) THEN
            CALL finish_moving_units(g_id,p_num);
            CALL end_turn(g_id,p_num);
          END IF;

          CALL user_action_end();
        END IF;
      END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS catapult_shoot$$
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
            SELECT IFNULL(bb.health,0) INTO health_after_hit FROM board_buildings bb WHERE bb.id=aim_bb_id LIMIT 1;
            SET experience = health_before_hit - health_after_hit;
            IF(health_after_hit = 0)THEN
              SET experience = experience + 1;
            END IF;
            IF(experience > 0)THEN
              CALL unit_add_exp(board_unit_id, experience);
            END IF;
			
          END IF;

          IF NOT EXISTS(SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id AND bu.player_num=p_num AND moves_left>0 AND unit_feature_check(bu.id,'paralich')=0 LIMIT 1) THEN
            CALL finish_moving_units(g_id,p_num);
            CALL end_turn(g_id,p_num);
          END IF;

          CALL user_action_end();
        END IF;
      END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS necromancer_resurrect$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `necromancer_resurrect`(g_id INT,p_num INT,x INT,y INT,grave_id INT)
BEGIN
  DECLARE dead_card_id INT;
  DECLARE err_code INT;
  DECLARE u2_id INT;
  DECLARE board_unit_id INT;
  DECLARE new_unit_id INT;
  DECLARE resur_cost INT;

  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit1 воскрешает $log_unit2_rod_pad")';

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'necromancer_resurrect'); /*unit can do it*/
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT id FROM graves WHERE game_id=g_id AND id=grave_id LIMIT 1) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=8;/*Card not in grave*/
    ELSE
      IF NOT EXISTS (SELECT id FROM grave_cells gc WHERE grave_id=grave_id AND check_one_step_from_unit(g_id,x,y,gc.x,gc.y)=1 LIMIT 1) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=34;/*grave is out of range*/
      ELSE
        IF EXISTS (SELECT b.id FROM board b JOIN grave_cells gc ON (b.x=gc.x AND b.y=gc.y) WHERE b.game_id=g_id AND gc.grave_id=grave_id LIMIT 1) THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=12;/*place occupied*/
        ELSE
          SELECT g.card_id INTO dead_card_id FROM graves g WHERE id=grave_id;
          SELECT c.cost INTO resur_cost FROM cards c WHERE c.id=dead_card_id LIMIT 1;
          IF (SELECT gold FROM players WHERE game_id=g_id AND player_num=p_num LIMIT 1)<resur_cost THEN
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=2;/*Not enough gold*/
          ELSE
/*OK*/
            CALL user_action_begin();

            IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
              CALL start_moving_units(g_id,p_num);
            END IF;

            UPDATE players SET gold=gold-resur_cost WHERE game_id=g_id AND player_num=p_num;
            CALL cmd_player_set_gold(g_id,p_num);

            SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;
            SELECT c.ref INTO u2_id FROM cards c WHERE c.id=dead_card_id LIMIT 1;

            UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
            CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);


            INSERT INTO board_units(game_id,player_num,card_id) VALUES (g_id,p_num,dead_card_id);
            SET new_unit_id=@@last_insert_id;
            INSERT INTO board_units_features(board_unit_id,feature_id,param) SELECT new_unit_id,ufu.feature_id,ufu.param FROM unit_default_features ufu WHERE ufu.unit_id=u2_id;
            UPDATE board_units SET moves_left=0 WHERE id=new_unit_id;
/*zombie*/
            INSERT INTO board_units_features(board_unit_id,feature_id,param) SELECT new_unit_id,unit_feature_get_id_by_code('under_control'),board_unit_id;

            INSERT INTO board(game_id,x,y,`type`,ref) SELECT g_id,gc.x,gc.y,'unit',new_unit_id FROM grave_cells gc WHERE gc.grave_id=grave_id;
            DELETE FROM graves WHERE game_id=g_id AND id=grave_id;

            CALL cmd_add_unit(g_id,p_num,new_unit_id);
            CALL cmd_remove_from_grave(g_id,p_num,grave_id);
            CALL cmd_unit_set_moves_left(g_id,p_num,new_unit_id);

/*exp*/
            CALL unit_add_exp(board_unit_id, 1);

            INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'resurrect_unit',u2_id);

/*log*/
            SET cmd_log=REPLACE(cmd_log,'$log_unit1',log_unit(board_unit_id));
            SET cmd_log=REPLACE(cmd_log,'$log_unit2_rod_pad',log_unit_rod_pad(new_unit_id));
            INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

            IF NOT EXISTS(SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id AND bu.player_num=p_num AND moves_left>0 AND unit_feature_check(bu.id,'paralich')=0 LIMIT 1) THEN
              CALL finish_moving_units(g_id,p_num);
              CALL end_turn(g_id,p_num);
            END IF;

            CALL user_action_end();

          END IF;
        END IF;
      END IF;
    END IF;
  END IF;

END$$

DELIMITER ;