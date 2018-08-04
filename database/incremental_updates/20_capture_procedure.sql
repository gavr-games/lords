use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cmd_building_set_owner` $$

CREATE PROCEDURE `cmd_building_set_owner`(g_id INT, p_num INT, board_building_id INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'building_set_owner($x,$y,$p_num,$income)';
  DECLARE x,y INT;
  DECLARE income INT;

  SELECT b.x,b.y INTO x,y FROM board b WHERE b.game_id=g_id AND b.`type`<>'unit' AND b.ref=board_building_id LIMIT 1;
  SELECT bb.income INTO income FROM board_buildings bb WHERE bb.id=board_building_id LIMIT 1;
  SET cmd=REPLACE(cmd,'$x',x);
  SET cmd=REPLACE(cmd,'$y',y);
  SET cmd=REPLACE(cmd,'$p_num',(SELECT player_num FROM board_buildings WHERE id=board_building_id LIMIT 1));
  SET cmd=REPLACE(cmd,'$income',income);
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END$$


DROP PROCEDURE IF EXISTS `lords`.`cast_capture` $$

CREATE PROCEDURE `cast_capture`(g_id INT, p_num INT, player_deck_id INT, b_x INT, b_y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_building_id INT;
  DECLARE log_msg_code VARCHAR(50) CHARSET utf8 DEFAULT 'building_captured';

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_capture');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    SELECT b.ref INTO board_building_id FROM board b WHERE b.game_id=g_id AND b.`type`='building' AND b.x=b_x AND b.y=b_y LIMIT 1;
    IF board_building_id IS NULL THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='building_not_selected';
    ELSE
        CALL user_action_begin(g_id, p_num);
        CALL play_card_actions(g_id,p_num,player_deck_id); 

        IF p_num = (SELECT bb.player_num FROM board_buildings bb WHERE bb.id = board_building_id) THEN
          SET log_msg_code = 'building_captured_own';
        END IF;

        CALL cmd_log_add_message(g_id, p_num, log_msg_code, CONCAT_WS(';', log_building(board_building_id), log_player(g_id, p_num)));

        UPDATE board_buildings SET player_num=p_num WHERE id=board_building_id;

        IF(building_feature_check(board_building_id,'ally') = 1)THEN
          CALL building_feature_set(board_building_id,'summon_team',get_player_team(g_id, p_num));
        END IF;

        CALL count_income(board_building_id);
        CALL cmd_building_set_owner(g_id,p_num,board_building_id);

        CALL finish_playing_card(g_id,p_num);
        CALL end_cards_phase(g_id,p_num);
        CALL user_action_end(g_id, p_num);
    END IF;
  END IF;
END$$

