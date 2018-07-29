use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_zone_express_into` $$

CREATE PROCEDURE `cast_zone_express_into`(g_id INT, p_num INT, player_deck_id INT, zone INT)
BEGIN
  DECLARE err_code INT;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_zone_express_into');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF zone NOT IN(0,1,2,3) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='invalid_zone';
    ELSE
        CALL user_action_begin(g_id, p_num);
        CALL play_card_actions(g_id,p_num,player_deck_id); 

        CALL units_to_zone(g_id, p_num, zone);

        CALL finish_playing_card(g_id,p_num);
        CALL end_cards_phase(g_id,p_num);
        CALL user_action_end(g_id, p_num);
    END IF;
  END IF;
END$$


DROP PROCEDURE IF EXISTS `lords`.`cast_zone_express_out` $$

CREATE PROCEDURE `cast_zone_express_out`(g_id INT, p_num INT, player_deck_id INT, zone INT)
BEGIN
  DECLARE err_code INT;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_zone_express_out');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF zone NOT IN(0,1,2,3) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='invalid_zone';
    ELSE
        CALL user_action_begin(g_id, p_num);
        CALL play_card_actions(g_id,p_num,player_deck_id); 

        CALL units_from_zone(g_id, p_num, zone);

        CALL finish_playing_card(g_id,p_num);
        CALL end_cards_phase(g_id,p_num);
        CALL user_action_end(g_id, p_num);
    END IF;
  END IF;
END$$

