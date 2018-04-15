use lords;

update cards_i18n set description = 'С вероятностью 1/6: починка всех своих зданий включая Замок и исцеление всех своих юнитов; воскресить любого юнита; +60 золота; взять 2 карты; переместить всех юнитов из выбранной зоны; переместить и присвоить здание.'
where card_id = (select id from cards where code = 'polza') and language_id = 2;
update cards_i18n set description = 'One of the following events randomly: repair all your buildings including the castle and heal all your units; resurrect any unit (if there are any); +60 gold; pick 2 cards from the deck; move all units out of a chosen zone; steal someone else''s building and move it anywhere'
where card_id = (select id from cards where code = 'polza') and language_id = 1;

update log_message_text_i18n set code = 'polza_repair_and_heal' where code = 'polza_repair';

update log_message_text_i18n set message = 'Польза: Починить все здания и исцелить юнитов'
where code = 'polza_repair_and_heal' and language_id = 2;
update log_message_text_i18n set message = 'White dice: Repair all buildings and heal units'
where code = 'polza_repair_and_heal' and language_id = 1;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`magic_total_heal` $$

CREATE PROCEDURE `magic_total_heal`(board_unit_id INT, p_num INT)
BEGIN
  DECLARE g_id INT;

  SELECT bu.game_id INTO g_id FROM board_units bu WHERE id=board_unit_id LIMIT 1;

  IF (unit_feature_check(board_unit_id,'magic_immunity')=0) THEN 
    CALL total_heal(board_unit_id);
  ELSE
    CALL cmd_magic_resistance_log(g_id,p_num,board_unit_id);
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`magic_total_heal_all_units_of_player` $$

CREATE PROCEDURE `magic_total_heal_all_units_of_player`(g_id INT,  p_num INT)
BEGIN
  DECLARE board_unit_id INT;

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT bu.id FROM board_units bu WHERE
    bu.game_id=g_id
    AND (
      bu.player_num = p_num 
      OR (
        unit_feature_check(bu.id,'madness')=1
        AND unit_feature_get_param(bu.id,'madness')=p_num));
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  OPEN cur;
  REPEAT
    FETCH cur INTO board_unit_id;
    IF NOT done THEN
      CALL magic_total_heal(board_unit_id,p_num);
    END IF;
  UNTIL done END REPEAT;
  CLOSE cur;

END$$

DROP PROCEDURE IF EXISTS `lords`.`cast_polza_main` $$

CREATE PROCEDURE `cast_polza_main`(g_id INT,  p_num INT,  player_deck_id INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE err_code INT;
  DECLARE dice INT;
  DECLARE nonfinished_action INT DEFAULT 0;
  DECLARE riching_sum INT DEFAULT 60;
  DECLARE take_cards_qty INT DEFAULT 2;
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'execute_procedure("$cmd_name")';

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_polza_main');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    CALL user_action_begin();

    CALL play_card_actions(g_id,p_num,player_deck_id); 

    SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
    SELECT FLOOR(1 + (RAND() * 6)) INTO dice FROM DUAL;

    CASE dice

      WHEN 1 THEN
        CALL cmd_log_add_message(g_id, p_num, 'polza_repair', NULL);
        CALL magic_total_heal_all_units_of_player(g_id, p_num);
        CALL repair_buildings(g_id,p_num);
      WHEN 2 THEN 
      BEGIN
        DECLARE x_appear,y_appear,x_dir,y_dir INT;
        DECLARE size INT;

        CALL cmd_log_add_message(g_id, p_num, 'polza_resurrect', NULL);
        SELECT MIN(g.size) INTO size FROM vw_grave g WHERE g.game_id=g_id;
        IF size IS NOT NULL THEN
          SELECT ap.x,ap.y,ap.direction_into_board_x,ap.direction_into_board_y INTO x_appear,y_appear,x_dir,y_dir FROM appear_points ap WHERE ap.mode_id=mode_id AND ap.player_num=p_num;
          IF NOT EXISTS(SELECT id FROM board WHERE game_id=g_id AND x BETWEEN LEAST(x_appear,x_appear+x_dir*(size-1)) AND GREATEST(x_appear,x_appear+x_dir*(size-1)) AND y BETWEEN LEAST(y_appear,y_appear+y_dir*(size-1)) AND GREATEST(y_appear,y_appear+y_dir*(size-1)) LIMIT 1) THEN
            SET nonfinished_action=1;
          END IF;
        END IF;
      END;

      WHEN 3 THEN 
        CALL cmd_log_add_message(g_id, p_num, 'polza_gold', NULL);
        UPDATE players SET gold=gold+riching_sum WHERE game_id=g_id AND player_num=p_num;
        CALL cmd_player_set_gold(g_id,p_num);

      WHEN 4 THEN 
        CALL cmd_log_add_message(g_id, p_num, 'polza_cards', NULL);
        BEGIN
          DECLARE new_card INT;
          DECLARE first_card_id INT;
          DECLARE player_deck_id INT;

          WHILE take_cards_qty>0 AND EXISTS(SELECT id FROM deck WHERE game_id=g_id LIMIT 1) DO
            SET take_cards_qty=take_cards_qty-1;

            SELECT MIN(id) INTO first_card_id FROM deck WHERE game_id=g_id;
            SELECT card_id INTO new_card FROM deck WHERE game_id=g_id AND id=first_card_id;
            INSERT INTO player_deck (game_id,player_num,card_id) VALUES (g_id,p_num,new_card);
            SET player_deck_id=@@last_insert_id;
            DELETE FROM deck WHERE game_id=g_id AND id=first_card_id;

            CALL cmd_add_card(g_id,p_num,player_deck_id);

            CALL cmd_log_add_message(g_id, p_num, 'new_card', new_card);
            
            IF (take_cards_qty>0) AND NOT EXISTS (SELECT id FROM deck WHERE game_id=g_id LIMIT 1) THEN
              CALL cmd_log_add_message(g_id, p_num, 'no_more_cards', NULL);
            END IF;
          END WHILE;
        END;

      WHEN 5 THEN
        CALL cmd_log_add_message(g_id, p_num, 'polza_move_from_zone', NULL);
        IF EXISTS(SELECT id FROM board_units WHERE game_id=g_id LIMIT 1) THEN
          SET nonfinished_action=2;
        END IF;

      WHEN 6 THEN 
        CALL cmd_log_add_message(g_id, p_num, 'polza_steal_move_building', NULL);
        IF EXISTS(SELECT bb.id FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.game_id=g_id AND bb.player_num<>p_num AND b.`type`<>'castle' AND building_feature_check(bb.id,'not_movable')=0 LIMIT 1) THEN
          SET nonfinished_action=3;
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

