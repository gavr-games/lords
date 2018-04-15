use lords;

update cards_i18n set description = 'С вероятностью 5/6 уничтожает каждый объект на карте кроме замков'
where card_id = (select id from cards where code = 'armageddon') and language_id = 2;
update cards_i18n set description = 'Destroys each object on board (except castles) with probability 5/6'
where card_id = (select id from cards where code = 'armageddon') and language_id = 1;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_armageddon` $$

CREATE PROCEDURE `cast_armageddon`(g_id INT, p_num INT, player_deck_id INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE board_building_id INT;
  DECLARE chance INT DEFAULT 1;

  DECLARE done INT DEFAULT 0;
  
  DECLARE cur CURSOR FOR SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id;
  
  DECLARE cur2 CURSOR FOR SELECT bb.id FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.game_id=g_id AND b.`type`<>'castle';
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;


  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_armageddon');
  IF err_code<>0 THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    CALL user_action_begin();

    CALL play_card_actions(g_id,p_num,player_deck_id); 

    OPEN cur;
    REPEAT
      FETCH cur INTO board_unit_id;
      IF NOT done THEN
        IF (SELECT FLOOR(1 + (RAND() * 6)) as `dice` FROM DUAL)>chance THEN
          CALL magic_kill_unit(board_unit_id,p_num);
        END IF;
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur;

    SET done=0;

    OPEN cur2;
    REPEAT
      FETCH cur2 INTO board_building_id;
      IF NOT done THEN
        IF (SELECT FLOOR(1 + (RAND() * 6)) as `dice` FROM DUAL)>chance THEN
          CALL destroy_building(board_building_id,p_num);
        END IF;
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur2;

    CALL finish_playing_card(g_id,p_num);
    CALL end_cards_phase(g_id,p_num);

    CALL user_action_end();
  END IF;
END$$

