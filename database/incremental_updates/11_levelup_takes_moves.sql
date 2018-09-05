use lords;

DELIMITER $$

DROP FUNCTION IF EXISTS `lords`.`check_all_units_moved` $$

CREATE FUNCTION `check_all_units_moved`(g_id INT,p_num INT) RETURNS int(11)
BEGIN
  IF NOT EXISTS
    (SELECT bu.id FROM board_units bu 
      WHERE bu.game_id = g_id AND bu.player_num = p_num 
        AND moves_left > 0 AND unit_feature_check(bu.id, 'paralich') = 0 LIMIT 1)
  THEN
    RETURN 1;
  END IF;
  RETURN 0;
END$$

DROP FUNCTION IF EXISTS `lords`.`check_unit_can_do_action` $$

CREATE FUNCTION `check_unit_can_do_action`(g_id INT, p_num INT, x INT, y INT, action_procedure VARCHAR(30)) RETURNS int(11)
BEGIN
  DECLARE board_unit_id INT;
  DECLARE p_num_unit_owner INT;
  DECLARE moves_left INT;
  DECLARE u_id INT;
  DECLARE for_all_units VARCHAR(30) DEFAULT '_applcable_for_any_unit_';

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id LIMIT 1) THEN RETURN 1; END IF;
  IF (SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id LIMIT 1)<>0 THEN RETURN 28; END IF;

  SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;
  IF board_unit_id IS NULL THEN RETURN 14; END IF;

  SELECT bu.player_num,bu.moves_left,bu.unit_id INTO p_num_unit_owner,moves_left,u_id FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

  IF p_num_unit_owner<>p_num THEN RETURN 16; END IF;
  IF moves_left<=0 THEN RETURN 17; END IF;
  IF (unit_feature_check(board_unit_id,'paralich')=1) THEN RETURN 18; END IF;

  IF action_procedure <> for_all_units AND NOT EXISTS
    (SELECT up.id FROM units_procedures up JOIN procedures pm ON up.procedure_id=pm.id
      WHERE up.unit_id=u_id AND pm.name=action_procedure LIMIT 1)
  THEN RETURN 30; END IF;

  UPDATE active_players SET current_procedure=action_procedure WHERE game_id=g_id;

  RETURN 0;
END$$

DROP PROCEDURE IF EXISTS `lords`.`unit_level_up` $$

CREATE PROCEDURE `unit_level_up`(g_id INT, p_num INT, x INT, y INT, stat VARCHAR(10))
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE level_up_bonus INT DEFAULT 1;
  DECLARE log_msg_code_part VARCHAR(50) CHARSET utf8 DEFAULT 'unit_levelup_';
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'unit_level_up_$stat($x,$y)';

  SET err_code = check_unit_can_do_action(g_id, p_num, x, y, '_applcable_for_any_unit_');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;
    IF check_unit_can_level_up(board_unit_id) = 0 THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='unit_cannot_levelup';
    ELSE
      CALL unit_action_begin(g_id, p_num);

      UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
      CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

      UPDATE board_units bu SET level = level + 1 WHERE bu.id=board_unit_id;
            
      CASE stat
        WHEN 'attack' THEN
        BEGIN
          UPDATE board_units bu SET attack = attack + level_up_bonus WHERE bu.id=board_unit_id;
        END;
        WHEN 'moves' THEN
        BEGIN
          UPDATE board_units bu SET moves = moves + level_up_bonus WHERE bu.id=board_unit_id;
        END;
        WHEN 'health' THEN
        BEGIN
          UPDATE board_units bu SET health = health + level_up_bonus, max_health = max_health + level_up_bonus WHERE bu.id=board_unit_id;
        END;
      END CASE;
            
      CALL cmd_log_add_message(g_id, p_num, CONCAT(log_msg_code_part, stat), CONCAT_WS(';', log_unit(board_unit_id), level_up_bonus));
            
      SET cmd=REPLACE(cmd,'$stat',stat);
      SET cmd=REPLACE(cmd,'$x',x);
      SET cmd=REPLACE(cmd,'$y',y);
      INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);
            
      CALL unit_action_end(g_id, p_num);
    END IF;
  END IF;
END$$

