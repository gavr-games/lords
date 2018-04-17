use lords;

update cards_i18n set description = 'С вероятностью 1/6: -60 золота любому игроку; убить любого юнита; разрушить любое здание; переместить юнитов в случайную зону; вытянуть у всех остальных по карте; переместить чужое здание.'
where card_id = (select id from cards where code = 'vred') and language_id = 2;
update cards_i18n set description = 'One of the following events randomly: -60 gold to a chosen player; kill a chosen unit; destroy a chosen building (except castles); teleport someone else''s building (except castles); move all units to a random zone; steal a card from every other player'
where card_id = (select id from cards where code = 'vred') and language_id = 1;

update log_message_text_i18n set code = 'vred_player_takes_card_from_everyone' where code = 'vred_random_player_takes_card';

update log_message_text_i18n set message = 'Вред: Вытянуть у всех по карте'
where code = 'vred_player_takes_card_from_everyone' and language_id = 2;
update log_message_text_i18n set message = 'Black dice: Steal a card from each other player'
where code = 'vred_player_takes_card_from_everyone' and language_id = 1;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_vred_main` $$

CREATE PROCEDURE `cast_vred_main`(g_id INT,  p_num INT,  player_deck_id INT)
BEGIN
  DECLARE err_code INT;
  DECLARE dice INT;
  DECLARE nonfinished_action INT DEFAULT 0;
  DECLARE pooring_sum INT DEFAULT 60;
  DECLARE take_cards_qty INT DEFAULT 1;
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'execute_procedure("$cmd_name")';

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_vred_main');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    CALL user_action_begin();

    CALL play_card_actions(g_id,p_num,player_deck_id); 

    SELECT FLOOR(1 + (RAND() * 6)) INTO dice FROM DUAL;

    CASE dice

      WHEN 1 THEN 
        CALL cmd_log_add_message(g_id, p_num, 'vred_gold', NULL);
        SET nonfinished_action=4;

      WHEN 2 THEN 
        CALL cmd_log_add_message(g_id, p_num, 'vred_kill', NULL);
        IF EXISTS(SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id AND unit_feature_check(bu.id,'magic_immunity')=0 LIMIT 1) THEN
          SET nonfinished_action=5;
        END IF;

      WHEN 3 THEN 
        CALL cmd_log_add_message(g_id, p_num, 'vred_destroy_building', NULL);
        IF EXISTS(SELECT bb.id FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.game_id=g_id AND b.`type`<>'castle' LIMIT 1) THEN
          SET nonfinished_action=6;
        END IF;

      WHEN 4 THEN 
      BEGIN
        DECLARE zone INT;

        CALL cmd_log_add_message(g_id, p_num, 'vred_move_units_to_random_zone', NULL);
        SELECT FLOOR(RAND() * 4) INTO zone FROM DUAL;
        CALL units_to_zone(g_id, p_num, zone);
      END;

      WHEN 5 THEN 
      BEGIN
        CALL cmd_log_add_message(g_id, p_num, 'vred_player_takes_card_from_everyone', NULL);
        CALL vred_player_takes_card_from_everyone(g_id,p_num);
      END;

      WHEN 6 THEN 
        CALL cmd_log_add_message(g_id, p_num, 'vred_move_building', NULL);
        IF EXISTS(SELECT bb.id FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.game_id=g_id AND bb.player_num<>p_num AND b.`type`<>'castle' AND building_feature_check(bb.id,'not_movable')=0 LIMIT 1) THEN
          SET nonfinished_action=7;
        END IF;

    END CASE;

    IF(nonfinished_action=0)THEN
      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);
    ELSE
      UPDATE active_players SET nonfinished_action_id=nonfinished_action WHERE game_id=g_id AND player_num=p_num;
      SET cmd=REPLACE(cmd,'$cmd_name',(SELECT command_procedure FROM nonfinished_actions_dictionary WHERE id=nonfinished_action LIMIT 1));
      INSERT INTO command (game_id,player_num,command,hidden_flag) VALUES (g_id,p_num,cmd,1);
    END IF;

    CALL user_action_end();
  END IF;


END$$

DELIMITER ;

