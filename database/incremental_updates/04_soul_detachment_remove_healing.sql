use lords;

update cards_i18n set description = 'С вероятностью 5/6 убивает юнит или 1/6 повергает в бешенство.'
where card_id = (select id from cards where code = 'od') and language_id = 2;
update cards_i18n set description = 'Kills a unit with probability 5/6 or makes mad with probability 1/6'
where card_id = (select id from cards where code = 'od') and language_id = 1;


DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_o_d` $$

CREATE PROCEDURE `cast_o_d`(g_id INT, p_num INT, player_deck_id INT, x INT, y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE shield INT;
  DECLARE dice INT;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_o_d');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;
      SELECT bu.shield INTO shield FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

      IF (unit_feature_check(board_unit_id,'magic_immunity')=0) THEN 

        SELECT FLOOR(1 + (RAND() * 6)) INTO dice FROM DUAL;

        IF shield>0 THEN
          CALL shield_off(board_unit_id);
        ELSE
          IF dice=6 THEN 
            CALL make_mad(board_unit_id);
          ELSE 
            CALL kill_unit(board_unit_id,p_num);
          END IF;
        END IF;
      ELSE
        CALL cmd_magic_resistance_log(g_id,p_num,board_unit_id);
      END IF;

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END$$

DELIMITER ;

