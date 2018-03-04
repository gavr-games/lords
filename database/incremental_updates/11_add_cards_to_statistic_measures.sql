use lords;

DROP PROCEDURE IF EXISTS `buy_card`;

DELIMITER ;;
CREATE PROCEDURE `buy_card`(g_id INT, p_num INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE card_cost INT;
  DECLARE new_card INT;
  DECLARE first_card_id INT;
  DECLARE player_deck_id INT;

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
  SELECT cfg.`value` INTO card_cost FROM mode_config cfg WHERE cfg.param='card cost' AND cfg.mode_id=mode_id;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;
  ELSE
    IF (SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id LIMIT 1)<>0 THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=28;
    ELSE
      IF (SELECT card_played_flag FROM active_players WHERE game_id=g_id)=1 THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=42;
      ELSE
        IF (SELECT gold FROM players WHERE game_id=g_id AND player_num=p_num)<card_cost THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=2;
        ELSE
          IF NOT EXISTS (SELECT id FROM deck WHERE game_id=g_id) THEN
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=3;
          ELSE

            CALL user_action_begin();

            UPDATE players SET gold=gold-card_cost WHERE game_id=g_id AND player_num=p_num;
            SELECT MIN(id) INTO first_card_id FROM deck WHERE game_id=g_id;
            SELECT card_id INTO new_card FROM deck WHERE game_id=g_id AND id=first_card_id;
            INSERT INTO player_deck (game_id,player_num,card_id) VALUES (g_id,p_num,new_card);
            SET player_deck_id=@@last_insert_id;

            DELETE FROM deck WHERE game_id=g_id AND id=first_card_id;

            CALL cmd_player_set_gold(g_id,p_num);
            CALL cmd_add_card(g_id,p_num,player_deck_id);

            CALL cmd_log_add_independent_message(g_id, p_num, 'buys_card', NULL);
            CALL cmd_log_add_independent_message_hidden(g_id, p_num, 'card_name', new_card);

            INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'buy_card',new_card);
            CALL end_cards_phase(g_id,p_num);

            CALL user_action_end();
          END IF;
        END IF;
      END IF;
    END IF;
  END IF;
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS `init_decks`;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `init_decks`(g_id INT)
BEGIN
  DECLARE g_mode INT;

  DECLARE p_num INT;
  DECLARE crd_id INT;
  DECLARE qty INT; 
  DECLARE card_type VARCHAR(45) CHARSET utf8;

  DECLARE done INT DEFAULT 0;
  DECLARE cur_modes_cards CURSOR FOR SELECT cfg.card_id,cfg.quantity,c.`type` FROM modes_cards cfg JOIN cards c ON (cfg.card_id=c.id) WHERE cfg.mode_id=g_mode;
  DECLARE cur_player_deck CURSOR FOR SELECT cfg.player_num,cfg.quantity,cfg.`type` FROM player_start_deck_config cfg JOIN players p ON cfg.player_num=p.player_num WHERE p.game_id=g_id AND p.owner<>0 AND cfg.mode_id=g_mode;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SELECT g.mode_id INTO g_mode FROM games g WHERE g.id=g_id LIMIT 1;

  CREATE TEMPORARY TABLE tmp_deck_ordered (id INT AUTO_INCREMENT PRIMARY KEY, card_id INT, `type` varchar(45), player_num int null);
  CREATE TEMPORARY TABLE tmp_deck_shuffled (id INT AUTO_INCREMENT PRIMARY KEY, card_id INT, `type` varchar(45), player_num int null);

  OPEN cur_modes_cards;
  REPEAT
    FETCH cur_modes_cards INTO crd_id, qty, card_type;
    IF NOT done THEN
      WHILE qty > 0 DO
        INSERT INTO tmp_deck_ordered(card_id,`type`) VALUES(crd_id, card_type);
        SET qty = qty - 1;
      END WHILE;
    END IF;
  UNTIL done END REPEAT;
  CLOSE cur_modes_cards;

  SET done=0;

  INSERT INTO tmp_deck_shuffled(card_id,`type`) SELECT card_id,`type` FROM tmp_deck_ordered ORDER BY RAND();

  OPEN cur_player_deck;
  REPEAT
    FETCH cur_player_deck INTO p_num, qty, card_type;
    IF NOT done THEN
      IF(g_mode = 1)THEN 
        UPDATE tmp_deck_shuffled SET player_num=p_num WHERE `type`=card_type AND player_num IS NULL LIMIT qty;
      ELSE 
        UPDATE tmp_deck_shuffled SET player_num=p_num WHERE `type`=card_type AND player_num IS NULL
          AND card_id NOT IN
            (SELECT c.id FROM cards c JOIN buildings b ON (c.ref = b.id)
              WHERE c.`type`='b' AND b.`type`='obstacle')
          LIMIT qty;
      END IF;
    END IF;
  UNTIL done END REPEAT;
  CLOSE cur_player_deck;

  INSERT INTO player_deck(game_id,player_num,card_id)
  SELECT g_id,player_num,card_id FROM tmp_deck_shuffled WHERE player_num IS NOT NULL;

  INSERT INTO deck(game_id,card_id)
  SELECT g_id,card_id FROM tmp_deck_shuffled WHERE player_num IS NULL;

  INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`)
  SELECT g_id,pd.player_num,'initial_card',pd.card_id FROM player_deck pd WHERE pd.game_id = g_id;

  DROP TEMPORARY TABLE tmp_deck_ordered;
  DROP TEMPORARY TABLE tmp_deck_shuffled;

END$$
DELIMITER ;

