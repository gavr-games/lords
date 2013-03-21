use lords;

DROP FUNCTION IF EXISTS `check_unit_can_level_up`;

DELIMITER $$

CREATE DEFINER=`root`@`localhost` FUNCTION `check_unit_can_level_up`(board_unit_id INT) RETURNS int(11)
BEGIN
	DECLARE unit_id INT;
	DECLARE unit_exp INT;
	DECLARE unit_level INT;
	
	SELECT bu.unit_id, bu.experience, bu.level INTO unit_id, unit_exp, unit_level FROM board_units bu WHERE bu.id = board_unit_id;
	
	IF EXISTS(SELECT 1 FROM unit_level_up_experience l WHERE l.unit_id = unit_id AND l.level = unit_level + 1 AND l.experience <= unit_exp) THEN
		RETURN 1;
	END IF;
	
	RETURN 0;
END $$

DELIMITER ;

DROP FUNCTION IF EXISTS `check_all_units_moved`;

DELIMITER $$

CREATE DEFINER=`root`@`localhost` FUNCTION `check_all_units_moved`(g_id INT,p_num INT) RETURNS int(11)
BEGIN
	IF NOT EXISTS(SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id AND bu.player_num=p_num AND ((moves_left>0 AND unit_feature_check(bu.id,'paralich')=0) OR (check_unit_can_level_up(bu.id) = 1)) LIMIT 1) THEN
		RETURN 1;
	END IF;
	
	RETURN 0;
END $$

DELIMITER ;

DROP PROCEDURE IF EXISTS `player_move_unit`;

DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `player_move_unit`(g_id INT,p_num INT,x INT,y INT, x2 INT, y2 INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE size INT;
  DECLARE p_team INT;
  DECLARE moveable INT DEFAULT 0;
  DECLARE teleportable INT DEFAULT 0;
  DECLARE taran_unit_id INT;
  DECLARE taran_x,taran_y,taran_prev_x,taran_prev_y INT;
  DECLARE x0,y0 INT;

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'player_move_unit'); /*unit can do it*/
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
    SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;
    SELECT u.size INTO size FROM board_units bu JOIN units u ON (bu.unit_id=u.id) WHERE bu.id=board_unit_id LIMIT 1;

    SET moveable=check_one_step_from_unit(g_id,x,y,x2,y2);

/*if can't step there and not magic resistant and there is a teleport - set teleportable*/
    SELECT p.team INTO p_team FROM players p WHERE p.game_id=g_id AND p.player_num=p_num LIMIT 1;
    IF (moveable=0)AND(unit_feature_check(board_unit_id,'magic_immunity')=0) AND EXISTS
    (SELECT a.id FROM board_buildings bb,board b,allcoords a,players p
      WHERE bb.game_id=g_id AND building_feature_check(bb.id,'teleport')=1 AND check_building_deactivated(bb.id)=0
      AND p.game_id=g_id AND p.player_num=bb.player_num AND p.team=p_team
      AND b.`type`<>'unit' AND b.ref=bb.id
      AND a.mode_id=mode_id
      AND a.x BETWEEN b.x-bb.radius AND b.x+bb.radius AND a.y BETWEEN b.y-bb.radius AND b.y+bb.radius
      AND a.x BETWEEN x2 AND x2+size-1 AND a.y BETWEEN y2 AND y2+size-1 LIMIT 1)
    THEN
      SET teleportable=1;
    END IF;
    IF moveable=0 AND teleportable=0
    THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=19;/*Out of range*/
    ELSE
      IF EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x BETWEEN x2 AND x2+size-1 AND b.y BETWEEN y2 AND y2+size-1 AND NOT(b.`type`='unit' AND b.ref=board_unit_id) LIMIT 1) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=12;/*Place occupied*/
      ELSE
/*OK*/
                CALL user_action_begin();

                IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
                  CALL start_moving_units(g_id,p_num);
                END IF;

                /*if Taran is moving, unbind him*/
                IF (unit_feature_get_param(board_unit_id,'bind_target') IS NOT NULL) THEN
                  CALL unit_feature_remove(board_unit_id,'bind_target');
                END IF; /*unbind taran*/

                SELECT MIN(b.x),MIN(b.y) INTO x0,y0 FROM board b WHERE b.game_id=g_id AND b.ref=board_unit_id AND b.`type`='unit';

                CALL move_unit(board_unit_id,x2,y2);
                UPDATE board_units bu SET bu.moves_left=CASE WHEN teleportable=1 THEN 0 ELSE bu.moves_left-1 END WHERE bu.id=board_unit_id;
                CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

/*if taran is binded to this unit - move taran*/
                SELECT bu.id INTO taran_unit_id FROM board_units bu WHERE unit_feature_get_param(bu.id,'bind_target')=board_unit_id LIMIT 1;
                IF taran_unit_id IS NOT NULL THEN
                  IF teleportable=1 THEN
                    CALL unit_feature_remove(taran_unit_id,'bind_target');
                  ELSE
                    IF (size=1) THEN
                      SET taran_x=x;
                      SET taran_y=y;
                    ELSE /*select place for taran if binded to a dragon*/
                      SELECT b.x,b.y INTO taran_prev_x,taran_prev_y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=taran_unit_id LIMIT 1;
                      SELECT a.x,a.y INTO taran_x,taran_y FROM allcoords a WHERE a.mode_id=mode_id AND a.x BETWEEN x0 AND x0+size-1 AND a.y BETWEEN y0 AND y0+size-1 AND a.x BETWEEN x2-1 AND x2+size AND a.y BETWEEN y2-1 AND y2+size AND NOT (a.x BETWEEN x2 AND x2+size-1 AND a.y BETWEEN y2 AND y2+size-1) ORDER BY ((taran_prev_x-a.x)*(taran_prev_x-a.x)+(taran_prev_y-a.y)*(taran_prev_y-a.y)) LIMIT 1;
                    END IF;
                    CALL move_unit(taran_unit_id,taran_x,taran_y);
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

END $$

DELIMITER ;

DROP PROCEDURE IF EXISTS `attack`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `attack`(g_id INT,p_num INT,x INT,y INT, x2 INT, y2 INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE size INT;
  DECLARE aim_type VARCHAR(45);
  DECLARE aim_id INT;
/*cursor for dragon multiattack*/
  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT DISTINCT b.`type`,b.ref FROM board b WHERE b.game_id=g_id AND b.`type`<>'obstacle' AND b.x BETWEEN x2 AND x2+size-1 AND b.y BETWEEN y2 AND y2+size-1 AND NOT(b.`type`='unit' AND b.ref=board_unit_id);
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'attack'); /*unit can do it*/
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF check_one_step_from_unit(g_id,x,y,x2,y2)=0 THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=20;/* attack out of range*/
    ELSE

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;
      SELECT u.size INTO size FROM board_units bu JOIN units u ON (bu.unit_id=u.id) WHERE bu.id=board_unit_id LIMIT 1;

      IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.`type`<>'obstacle' AND b.x BETWEEN x2 AND x2+size-1 AND b.y BETWEEN y2 AND y2+size-1 AND NOT(b.`type`='unit' AND b.ref=board_unit_id) LIMIT 1)
      THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=21;/*Nothing to attack*/
      ELSE
/*OK*/
                CALL user_action_begin();

                IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
                  CALL start_moving_units(g_id,p_num);
                END IF;

                IF (unit_feature_get_param(board_unit_id,'bind_target') IS NOT NULL) THEN /*if taran is binded to another unit - unbind it*/
                  CALL unit_feature_remove(board_unit_id,'bind_target');
                END IF; /*unbind taran*/

                UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
                CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

                IF size=1 THEN
                  SELECT b.`type`,b.ref INTO aim_type,aim_id FROM board b WHERE b.game_id=g_id AND b.x=x2 AND b.y=y2 LIMIT 1;
                  CALL attack_actions(board_unit_id,aim_type,aim_id);
                  INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'unit_attack');
                ELSE /*dragons*/
                  OPEN cur;
                  REPEAT
                    FETCH cur INTO aim_type,aim_id;
                    IF NOT done AND EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.`type`=aim_type AND b.ref=aim_id LIMIT 1) THEN
                      CALL attack_actions(board_unit_id,aim_type,aim_id);
                      INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'unit_attack');
                    END IF;
                  UNTIL done END REPEAT;
                  CLOSE cur;
                END IF;

                IF (check_all_units_moved(g_id,p_num) = 1)
                  AND (SELECT player_num FROM active_players WHERE game_id=g_id)=p_num /*and still his turn*/
                THEN
                  CALL finish_moving_units(g_id,p_num);
                  CALL end_turn(g_id,p_num);
                END IF;

                CALL user_action_end();
      END IF;
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

DROP PROCEDURE IF EXISTS `taran_bind`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `taran_bind`(g_id INT,p_num INT,x INT,y INT, x2 INT, y2 INT)
BEGIN
  DECLARE err_code INT;
  DECLARE aim_bu_id INT;
  DECLARE board_unit_id INT;

  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit1 цепляется к юниту $log_unit2")';

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'taran_bind'); /*unit can do it*/
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF check_one_step_from_unit(g_id,x,y,x2,y2)=0 THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=29;/* out of range*/
    ELSE
      SELECT b.ref INTO aim_bu_id FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.x=x2 AND b.y=y2 LIMIT 1;
      IF aim_bu_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=31;/*Nothing to bind to*/
      ELSE
        CALL user_action_begin();

        IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
          CALL start_moving_units(g_id,p_num);
        END IF;

        SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;

        UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
        CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

        CALL unit_feature_set(board_unit_id,'bind_target',aim_bu_id);

/*log*/
        SET cmd_log=REPLACE(cmd_log,'$log_unit1',log_unit(board_unit_id));
        SET cmd_log=REPLACE(cmd_log,'$log_unit2',log_unit(aim_bu_id));
        INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

        IF (check_all_units_moved(g_id,p_num) = 1) THEN
          CALL finish_moving_units(g_id,p_num);
          CALL end_turn(g_id,p_num);
        END IF;

        CALL user_action_end();

      END IF;
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

DROP PROCEDURE IF EXISTS `wizard_heal`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `wizard_heal`(g_id INT,p_num INT,x INT,y INT, x2 INT, y2 INT)
BEGIN
  DECLARE err_code INT;
  DECLARE aim_bu_id INT;
  DECLARE board_unit_id INT;
  DECLARE hp_heal INT DEFAULT 1;

  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit1 лечит $log_unit2_rod_pad")';

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'wizard_heal'); /*unit can do it*/
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF check_one_step_from_unit(g_id,x,y,x2,y2)=0 THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=29;/* out of range*/
    ELSE
      SELECT b.ref INTO aim_bu_id FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.x=x2 AND b.y=y2 LIMIT 1;
      IF aim_bu_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=32;/*Noone to heal*/
      ELSE
        CALL user_action_begin();

        IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
          CALL start_moving_units(g_id,p_num);
        END IF;

        SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;

        UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
        CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

/*log*/
        SET cmd_log=REPLACE(cmd_log,'$log_unit1',log_unit(board_unit_id));
        SET cmd_log=REPLACE(cmd_log,'$log_unit2_rod_pad',log_unit_rod_pad(aim_bu_id));
        INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

        CALL magical_heal(g_id,p_num,x2,y2,hp_heal);

        IF (check_all_units_moved(g_id,p_num) = 1) THEN
          CALL finish_moving_units(g_id,p_num);
          CALL end_turn(g_id,p_num);
        END IF;

        CALL user_action_end();
      END IF;
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$


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

        IF (check_all_units_moved(g_id,p_num) = 1) THEN
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


          IF (check_all_units_moved(g_id,p_num) = 1) THEN
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

          IF (check_all_units_moved(g_id,p_num) = 1) THEN
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

          IF (check_all_units_moved(g_id,p_num) = 1) THEN
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

            IF (check_all_units_moved(g_id,p_num) = 1) THEN
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

DROP PROCEDURE IF EXISTS `necromancer_sacrifice`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `necromancer_sacrifice`(g_id INT,p_num INT,x INT,y INT,x_sacr INT,y_sacr INT, x_target INT, y_target INT)
BEGIN
  DECLARE err_code INT;
  DECLARE sacr_bu_id INT;
  DECLARE target_bu_id INT;
  DECLARE board_unit_id INT;
  DECLARE sacr_health INT;
  DECLARE damage_bonus INT DEFAULT 1;

  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit1 жертвует $log_unit2_rod_pad за $log_unit3_rod_pad")';

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'necromancer_sacrifice'); /*unit can do it*/
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    SELECT b.ref INTO sacr_bu_id FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.x=x_sacr AND b.y=y_sacr LIMIT 1;
    IF sacr_bu_id IS NULL THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=37;/*Noone to sacrifice*/
    ELSE
      IF (SELECT player_num FROM board_units WHERE id=sacr_bu_id)<>p_num THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=38;/*Can sacrifice only own unit*/
      ELSE
        SELECT b.ref INTO target_bu_id FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.x=x_target AND b.y=y_target LIMIT 1;
        IF target_bu_id IS NULL THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=39;/*Noone to sacrifice*/
        ELSE
/*OK*/
          CALL user_action_begin();

          IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
            CALL start_moving_units(g_id,p_num);
          END IF;

          SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;

          UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
          CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

/*log*/
          SET cmd_log=REPLACE(cmd_log,'$log_unit1',log_unit(board_unit_id));
          SET cmd_log=REPLACE(cmd_log,'$log_unit2_rod_pad',log_unit_rod_pad(sacr_bu_id));
          SET cmd_log=REPLACE(cmd_log,'$log_unit3_rod_pad',log_unit_rod_pad(target_bu_id));
          IF(sacr_bu_id=target_bu_id) THEN
            SET cmd_log=REPLACE(cmd_log,'")',CONCAT('. ',log_unit(board_unit_id),' такой ',log_unit(board_unit_id),'")'));
          END IF;
          INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

          IF (unit_feature_check(sacr_bu_id,'magic_immunity')=1) THEN /*if magic-resistant*/
            CALL cmd_magic_resistance_log(g_id,p_num,board_unit_id);
          ELSE

/*TODO shields? */

            SELECT bu.health INTO sacr_health FROM board_units bu WHERE bu.id=sacr_bu_id;

            CALL unit_feature_set(sacr_bu_id,'goes_to_deck_on_death',null);
            CALL kill_unit(sacr_bu_id,p_num);
            
            IF(sacr_bu_id<>target_bu_id)THEN
              CALL magical_damage(g_id,p_num,x_target,y_target,sacr_health+damage_bonus);
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
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;
