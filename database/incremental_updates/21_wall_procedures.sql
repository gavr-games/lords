use lords;

DELIMITER $$

DROP FUNCTION IF EXISTS `lords`.`check_building_can_do_action` $$
CREATE DEFINER=`root`@`localhost` FUNCTION `check_building_can_do_action`(g_id INT,p_num INT,x INT,y INT,action_procedure VARCHAR(30)) RETURNS int(11)
BEGIN
  DECLARE board_building_id INT;
  DECLARE p_num_building_owner INT;
  DECLARE b_id INT;
  DECLARE current_turn INT;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id LIMIT 1) THEN RETURN 1; END IF;/*Not your turn*/
  IF (SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id LIMIT 1)<>0 THEN RETURN 28; END IF;/*polza/vred in progress*/

  SELECT b.ref INTO board_building_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`<>'unit' LIMIT 1;
  IF board_building_id IS NULL THEN RETURN 26; END IF;/*Not a building*/

  SELECT bb.player_num,bb.building_id INTO p_num_building_owner,b_id FROM board_buildings bb WHERE bb.id=board_building_id LIMIT 1;

  IF p_num_unit_owner<>p_num THEN RETURN 44; END IF;/*Not my building*/
  IF (check_building_deactivated(board_building_id)=1) THEN RETURN 45; END IF;/*building deactivated*/

  IF(building_feature_check(board_building_id,'turn_when_changed')=1)THEN
    SELECT turn INTO current_turn FROM active_players WHERE game_id=g_id;
    IF(building_feature_get_param(board_building_id,'turn_when_changed') = current_turn)THEN
      RETURN 47;
    END IF;
  END IF;

  IF NOT EXISTS(SELECT bp.id FROM buildings_procedures bp JOIN procedures pm ON bp.procedure_id=pm.id WHERE bp.building_id=b_id AND pm.name=action_procedure LIMIT 1) THEN RETURN 46; END IF;/*Cheater - procedure from another building*/

  UPDATE active_players SET current_procedure=action_procedure WHERE game_id=g_id;

  RETURN 0;
END$$

DROP PROCEDURE IF EXISTS `lords`.`wall_open` $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `wall_open`(g_id INT,p_num INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_building_id INT;
  DECLARE current_turn INT;

  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_building открывается")';

  SET err_code=check_building_can_do_action(g_id,p_num,x,y,'wall_open'); /*building can do it*/
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
        CALL user_action_begin();

        IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
          CALL start_moving_units(g_id,p_num);
        END IF;

        SELECT b.ref INTO board_building_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`<>'unit' LIMIT 1;
        SELECT turn INTO current_turn FROM active_players WHERE game_id=g_id;

/*TODO*/
        CALL building_feature_set(board_building_id,'turn_when_changed',current_turn);

/*log*/
        SET cmd_log=REPLACE(cmd_log,'$log_building',log_building(board_building_id));
        INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

        CALL user_action_end();
  END IF;
END $$

DELIMITER ;
