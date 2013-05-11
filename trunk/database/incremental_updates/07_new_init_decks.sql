use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`init_decks` $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `init_decks`(g_id INT)
BEGIN
  DECLARE g_mode INT;

  DECLARE p_num INT;
  DECLARE crd_id INT;
  DECLARE qty INT; /*Quantity of cards*/
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
      UPDATE tmp_deck_shuffled SET player_num=p_num WHERE `type`=card_type AND player_num IS NULL LIMIT qty;
    END IF;
  UNTIL done END REPEAT;
  CLOSE cur_player_deck;

  INSERT INTO player_deck(game_id,player_num,card_id)
  SELECT g_id,player_num,card_id FROM tmp_deck_shuffled WHERE player_num IS NOT NULL;

  INSERT INTO deck(game_id,card_id)
  SELECT g_id,card_id FROM tmp_deck_shuffled WHERE player_num IS NULL;

  DROP TEMPORARY TABLE tmp_deck_ordered;
  DROP TEMPORARY TABLE tmp_deck_shuffled;

END $$

DELIMITER ;