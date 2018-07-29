use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_demolition` $$

CREATE PROCEDURE `cast_demolition`(g_id INT, p_num INT, player_deck_id INT, b_x INT, b_y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_building_id INT;
  DECLARE demolition_damage INT DEFAULT 4;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_demolition');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    SELECT b.ref INTO board_building_id FROM board b WHERE b.game_id=g_id AND b.`type`='building' AND b.x=b_x AND b.y=b_y LIMIT 1;
    IF board_building_id IS NULL THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='building_not_selected';
    ELSE
        CALL user_action_begin(g_id, p_num);
        CALL play_card_actions(g_id,p_num,player_deck_id); 
        CALL magical_damage(g_id,p_num,b_x,b_y,demolition_damage);
        CALL finish_playing_card(g_id,p_num);
        CALL end_cards_phase(g_id,p_num);
        CALL user_action_end(g_id, p_num);
    END IF;
  END IF;
END$$


use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_polza_move_building` $$

CREATE PROCEDURE `cast_polza_move_building`(g_id INT,  p_num INT,  b_x INT,  b_y INT,  x INT,  y INT,  rot INT,  flp INT)
BEGIN
  DECLARE nonfinished_action INT DEFAULT 3;
  DECLARE board_building_id INT;
  DECLARE p2_num INT;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;
  ELSE
    IF NOT nonfinished_action=(SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=24;
    ELSE
      SELECT b.ref INTO board_building_id FROM board b WHERE b.game_id=g_id AND b.`type` IN ('building','obstacle') AND b.x=b_x AND b.y=b_y LIMIT 1;
      IF board_building_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=26;
      ELSE
        SELECT bb.player_num INTO p2_num FROM board_buildings bb WHERE bb.id=board_building_id LIMIT 1;
        IF p2_num=p_num THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=27;
        ELSE
          IF building_feature_check(board_building_id,'not_movable')=1 THEN
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=43;
          ELSE
            CALL user_action_begin(g_id, p_num);


            UPDATE board SET ref=0 WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=board_building_id;

            CALL place_building_on_board(board_building_id,x,y,rot,flp);

            IF NOT EXISTS(SELECT id FROM board WHERE game_id=g_id AND `type`<>'unit' AND ref=board_building_id) THEN 
              UPDATE board SET ref=board_building_id WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0;
              SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=12;
            ELSE
            
              DELETE FROM board WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0; 

              UPDATE board_buildings SET player_num=p_num,rotation=rot,flip=flp WHERE id=board_building_id;

              CALL count_income(board_building_id);

              CALL cmd_move_building(g_id,p_num,b_x,b_y,board_building_id);
              CALL cmd_building_set_owner(g_id,p_num,board_building_id);


              UPDATE active_players SET nonfinished_action_id=0 WHERE game_id=g_id AND player_num=p_num;

              CALL finish_playing_card(g_id,p_num);
              CALL end_cards_phase(g_id,p_num);

              CALL user_action_end(g_id, p_num);
            END IF;
          END IF;
        END IF;
      END IF;
    END IF;
  END IF;

END$$

DELIMITER ;

