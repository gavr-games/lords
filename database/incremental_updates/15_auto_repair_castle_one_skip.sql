use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`player_end_turn` $$

CREATE PROCEDURE `player_end_turn`(g_id INT,  p_num INT)
BEGIN
  DECLARE moved_units INT;
  DECLARE did_card_action INT;
  DECLARE taken_subsidy INT;
  DECLARE owner INT;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;
  ELSE
    CALL user_action_begin(g_id, p_num);

    SELECT units_moves_flag, card_played_flag, subsidy_flag
      INTO moved_units, did_card_action, taken_subsidy
      FROM active_players WHERE game_id=g_id LIMIT 1;
    SELECT p.owner INTO owner FROM players p WHERE p.game_id=g_id AND p.player_num=p_num LIMIT 1;

    IF moved_units=1 OR owner<>1 THEN
      CALL cmd_log_add_message(g_id, p_num, 'end_turn', log_player(g_id, p_num));
      CALL finish_moving_units(g_id,p_num);
    ELSE
      CALL cmd_log_add_independent_message(g_id, p_num, 'end_turn', log_player(g_id, p_num));
    END IF;
    
    IF moved_units = 0 AND did_card_action = 0 AND taken_subsidy = 0 THEN
      CALL castle_auto_repair(g_id,p_num);
    END IF;

    CALL end_turn(g_id,p_num);

    CALL user_action_end(g_id, p_num);
  END IF;
END$$

DELIMITER ;

use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`end_turn` $$

CREATE PROCEDURE `end_turn`(g_id INT,   p_num INT)
BEGIN
  DECLARE board_unit_id INT;
  DECLARE p_num2 INT;
  DECLARE move_order_p1 INT;
  DECLARE move_order_p2 INT;
  DECLARE owner_p1 INT;
  DECLARE owner_p2 INT;
  DECLARE last_turn INT;
  DECLARE turn,new_turn INT;
  DECLARE mode_id INT;

  DECLARE nonfinished_action INT;

  DECLARE board_building_id INT;


  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id AND bu.player_num=p_num AND bu.moves_left<ABS(bu.moves);

  DECLARE cur_building_features CURSOR FOR
    SELECT bb.id FROM board_buildings bb WHERE bb.game_id=g_id AND bb.player_num=p_num2 AND check_building_deactivated(bb.id)=0;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    SELECT a.turn,a.nonfinished_action_id INTO turn,nonfinished_action FROM active_players a WHERE a.game_id=g_id LIMIT 1;
    SELECT p.owner, p.move_order INTO owner_p1, move_order_p1 FROM players p WHERE p.game_id=g_id AND p.player_num=p_num LIMIT 1;

    IF(nonfinished_action<>0)THEN
      CALL finish_nonfinished_action(g_id,p_num,nonfinished_action);
    END IF;

    IF move_order_p1 = (SELECT MAX(move_order) FROM players WHERE game_id=g_id) THEN
      SET new_turn=turn+1;
      SELECT MIN(move_order) INTO move_order_p2 FROM players WHERE game_id=g_id;
    ELSE
      SET new_turn=turn;
      SELECT MIN(move_order) INTO move_order_p2 FROM players WHERE game_id=g_id AND move_order > move_order_p1;
    END IF;

    SELECT player_num INTO p_num2 FROM players WHERE game_id = g_id AND move_order = move_order_p2 LIMIT 1;

    UPDATE active_players SET turn=new_turn, player_num=p_num2, subsidy_flag=0, units_moves_flag=0, card_played_flag=0, nonfinished_action_id=0, last_end_turn=CURRENT_TIMESTAMP, current_procedure='end_turn' WHERE game_id=g_id;

    SELECT UNIX_TIMESTAMP(a.last_end_turn) INTO last_turn FROM active_players a WHERE a.game_id=g_id;

    CALL cmd_set_active_player(g_id,p_num2,last_turn,new_turn);

    OPEN cur;
    REPEAT
      FETCH cur INTO board_unit_id;
      IF NOT done THEN
        UPDATE board_units SET moves_left=moves WHERE id=board_unit_id;
        CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur;

  SELECT p.owner INTO owner_p2 FROM players p WHERE p.game_id=g_id AND p.player_num=p_num2 LIMIT 1;

  IF owner_p2=1 THEN 
  BEGIN
    DECLARE cmd_log_close_container VARCHAR(1000) CHARSET utf8 DEFAULT 'log_close_container()';


    DECLARE income INT;
    DECLARE u_income INT;


    IF (owner_p1 NOT IN(0,1)) THEN
      INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log_close_container);
    END IF;


    SELECT IFNULL(SUM(bb.income),0) INTO income FROM board_buildings bb WHERE bb.game_id=g_id AND bb.player_num=p_num2 AND bb.income<>0 AND check_building_deactivated(bb.id)=0;

    SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
    SELECT cfg.`value` INTO u_income FROM mode_config cfg WHERE cfg.param='unit income' AND cfg.mode_id=mode_id;
    SET income=income+(SELECT IFNULL((COUNT(*))*u_income,0) FROM board b JOIN board_units bu ON (b.ref=bu.id) WHERE b.game_id=g_id AND b.`type`='unit' AND bu.player_num=p_num2 AND quart(b.x,b.y)<>p_num2);

    IF income>0 THEN
      UPDATE players SET gold=gold+income WHERE game_id=g_id AND player_num=p_num2;
      CALL cmd_player_set_gold(g_id,p_num2);
    END IF;

    SET done=0;

    OPEN cur_building_features;
    REPEAT
      FETCH cur_building_features INTO board_building_id;
      IF NOT done THEN

        IF(building_feature_check(board_building_id,'healing'))=1 THEN
          CALL healing_tower_heal(g_id,board_building_id);
        END IF;

        IF(building_feature_check(board_building_id,'frog_factory'))=1 THEN
          CALL lake_summon_frogs(g_id,board_building_id);
        END IF;

        IF(building_feature_check(board_building_id,'troll_factory'))=1 THEN
          CALL mountains_summon_troll(g_id,board_building_id);
        END IF;

        IF(building_feature_check(board_building_id,'coin_factory'))=1 THEN
          CALL coin_factory_income(g_id,board_building_id);
        END IF;

        IF(building_feature_check(board_building_id,'barracks'))=1 THEN
          CALL barracks_summon(g_id,board_building_id);
        END IF;

      END IF;
    UNTIL done END REPEAT;
    CLOSE cur_building_features;

  END;
  ELSE

  BEGIN
    IF (owner_p1 = 1 AND owner_p2 NOT IN(0,1)) THEN
      CALL cmd_log_add_container(g_id, p_num2, 'npc_turn', NULL);
    END IF;
  END;
  END IF;

END$$

DELIMITER ;
