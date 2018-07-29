use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_relocation` $$

CREATE PROCEDURE `cast_relocation`(g_id INT, p_num INT, player_deck_id INT, b_x INT, b_y INT, x INT, y INT, rot INT, flp INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_building_id INT;
  DECLARE log_msg_code VARCHAR(50) CHARSET utf8 DEFAULT 'building_moved';

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_relocation');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    SELECT b.ref INTO board_building_id FROM board b WHERE b.game_id=g_id AND b.`type` IN ('building','obstacle') AND b.x=b_x AND b.y=b_y LIMIT 1;
    IF board_building_id IS NULL THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='building_not_selected';
    ELSE
      IF building_feature_check(board_building_id,'not_movable')=1 THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='moving_this_building_disallowed';
      ELSE
        UPDATE board SET ref=0 WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=board_building_id;
        CALL place_building_on_board(board_building_id,x,y,rot,flp);

        IF NOT EXISTS(SELECT id FROM board WHERE game_id=g_id AND `type`<>'unit' AND ref=board_building_id) THEN 
          UPDATE board SET ref=board_building_id WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0;
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='place_occupied';
        ELSE

          CALL user_action_begin(g_id, p_num);
          CALL play_card_actions(g_id,p_num,player_deck_id); 
            
          DELETE FROM board WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0;
          UPDATE board_buildings SET rotation=rot,flip=flp WHERE id=board_building_id;

          CALL count_income(board_building_id);

          CALL cmd_move_building(g_id,p_num,b_x,b_y,board_building_id);
          CALL cmd_log_add_message(g_id, p_num, log_msg_code, CONCAT_WS(';', log_building(board_building_id), log_cell(b_x, b_y)));

          CALL finish_playing_card(g_id,p_num);
          CALL end_cards_phase(g_id,p_num);
          CALL user_action_end(g_id, p_num);
        END IF;
      END IF;
    END IF;
  END IF;
END$$


use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`put_building` $$

CREATE PROCEDURE `put_building`(g_id INT,  p_num INT,  player_deck_id INT,  x INT,  y INT,  rotation INT,  flip INT)
BEGIN
  DECLARE crd_id INT;
  DECLARE err_code INT;
  DECLARE x_len,y_len INT;
  DECLARE x2,y2 INT; 
  DECLARE new_building_id INT;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'put_building');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    SELECT card_id INTO crd_id FROM player_deck WHERE id=player_deck_id;
    SELECT b.x_len,b.y_len INTO x_len,y_len FROM cards c JOIN buildings b ON (c.ref=b.id) WHERE c.`type`='b' AND c.id=crd_id LIMIT 1;
    IF rotation=0 OR rotation=2 THEN
      SET x2=x+x_len-1;
      SET y2=y+y_len-1;
    ELSE
      SET x2=x+y_len-1;
      SET y2=y+x_len-1;
    END IF;
    IF (quart(x,y)<>p_num) OR (quart(x2,y2)<>p_num) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='building_outside_zone';
    ELSE
      INSERT INTO board_buildings(game_id,player_num,card_id,rotation,flip)VALUES (g_id,p_num,crd_id,rotation,flip);
      SET new_building_id=@@last_insert_id;

      CALL place_building_on_board(new_building_id,x,y,rotation,flip);

      IF NOT EXISTS(SELECT id FROM board WHERE game_id=g_id AND `type`<>'unit' AND ref=new_building_id) THEN 
        DELETE FROM board_buildings WHERE id=new_building_id;
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='place_occupied';
      ELSE
        CALL user_action_begin(g_id, p_num);

        INSERT INTO board_buildings_features(board_building_id,feature_id,param)
          SELECT new_building_id,bfu.feature_id,bfu.param
            FROM board_buildings bb
            JOIN building_default_features bfu ON (bb.building_id=bfu.building_id)
            WHERE bb.id=new_building_id;

        UPDATE board_buildings_features bbf
        SET param=get_new_team_number(g_id)
        WHERE bbf.board_building_id=new_building_id AND bbf.feature_id=building_feature_get_id_by_code('summon_team');

        IF(building_feature_check(new_building_id,'ally') = 1)THEN
          CALL building_feature_set(new_building_id,'summon_team',get_player_team(g_id, p_num));
        END IF;

        CALL count_income(new_building_id);

        CALL play_card_actions(g_id,p_num,player_deck_id); 

        CALL cmd_put_building_by_card(g_id,p_num,new_building_id);

        IF EXISTS(SELECT sc.id FROM summon_cfg sc WHERE sc.building_id=(SELECT bb.building_id FROM board_buildings bb WHERE id=new_building_id)) THEN
          CALL summon_creatures(new_building_id);
        END IF;

        CALL finish_playing_card(g_id,p_num);
        CALL end_cards_phase(g_id,p_num);

        CALL user_action_end(g_id, p_num);
      END IF;
    END IF;
  END IF;
END$$

DELIMITER ;

