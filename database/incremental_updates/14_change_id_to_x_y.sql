USE lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `unit_add_exp`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `unit_add_exp`(board_unit_id INT, qty INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE x,y INT;

  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'unit_add_exp($x,$y,$qty)';

  SELECT bu.game_id,bu.player_num INTO g_id,p_num FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;
  SELECT b.x,b.y INTO x,y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=board_unit_id LIMIT 1;

  UPDATE board_units SET experience = experience + qty WHERE id=board_unit_id;

  SET cmd=REPLACE(cmd,'$x',x);
  SET cmd=REPLACE(cmd,'$y',y);
  SET cmd=REPLACE(cmd,'$qty',(SELECT experience FROM board_units WHERE id=board_unit_id LIMIT 1));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END$$

DROP PROCEDURE IF EXISTS `unit_level_up`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `unit_level_up`(g_id INT,p_num INT,x INT,y INT, stat VARCHAR(10))
BEGIN
	DECLARE board_unit_id INT;
	DECLARE level_up_bonus INT DEFAULT 1;
	DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit получает уровень и $log_stat")';
	DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'unit_level_up_$stat($x,$y)';
	
	/*some checks from check_unit_can_do_action*/
	IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id LIMIT 1) THEN
		SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;/*Not your turn*/
	ELSE
		IF (SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id LIMIT 1)<>0 THEN
			SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=28;/*polza/vred in progress*/
		ELSE
			SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;
			IF board_unit_id IS NULL THEN
				SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
			ELSE
				IF NOT p_num=(SELECT bu.player_num FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1) THEN
					SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=16;/*Not my unit*/
				ELSE
/*OK*/
					CALL user_action_begin();
					IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
						CALL start_moving_units(g_id,p_num);
					END IF;

					UPDATE board_units bu SET level = level + 1 WHERE bu.id=board_unit_id;
					
					SET cmd_log=REPLACE(cmd_log,'$log_unit',log_unit(board_unit_id));
					
					CASE stat
						WHEN 'attack' THEN
						BEGIN
							SET cmd_log=REPLACE(cmd_log,'$log_stat',log_attack(level_up_bonus));
							UPDATE board_units bu SET attack = attack + level_up_bonus WHERE bu.id=board_unit_id;
						END;
						WHEN 'moves' THEN
						BEGIN
							SET cmd_log=REPLACE(cmd_log,'$log_stat',log_moves(level_up_bonus));
							UPDATE board_units bu SET moves = moves + level_up_bonus WHERE bu.id=board_unit_id;
						END;
						WHEN 'health' THEN
						BEGIN
							SET cmd_log=REPLACE(cmd_log,'$log_stat',log_health(level_up_bonus));
							UPDATE board_units bu SET health = health + level_up_bonus, max_health = max_health + level_up_bonus WHERE bu.id=board_unit_id;
						END;
					END CASE;
					
					INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

					SET cmd=REPLACE(cmd,'$stat',stat);
					SET cmd=REPLACE(cmd,'$x',x);
					SET cmd=REPLACE(cmd,'$y',y);
					INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);
					
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

DELIMITER ;