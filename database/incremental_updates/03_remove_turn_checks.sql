use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`play_card_actions` $$

CREATE PROCEDURE `play_card_actions`(g_id INT,  p_num INT,  player_deck_id INT)
BEGIN

  DECLARE crd_id INT;
  DECLARE card_cost INT;
  DECLARE card_type VARCHAR(5);

  SELECT card_id INTO crd_id FROM player_deck WHERE id=player_deck_id;

  SELECT cost,`type` INTO card_cost,card_type FROM cards WHERE id=crd_id LIMIT 1;
  IF card_cost>0 THEN
    UPDATE players SET gold=gold-card_cost WHERE game_id=g_id AND player_num=p_num;
    CALL cmd_player_set_gold(g_id,p_num);
  END IF;

  DELETE FROM player_deck WHERE id=player_deck_id;
  CALL cmd_remove_card(g_id,p_num,player_deck_id);
  IF card_type = 'm' THEN
    INSERT INTO deck(game_id,card_id) VALUES(g_id,crd_id);
  END IF;

  CALL cmd_log_add_container(g_id, p_num, 'plays_card', crd_id);
  INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'play_card',crd_id);

  SET @current_card_type = card_type;

END$$

DELIMITER ;

use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`end_cards_phase` $$

CREATE PROCEDURE `end_cards_phase`(g_id INT,p_num INT)
this_procedure:BEGIN
  DECLARE g_mode INT;
  DECLARE two_phase_turn INT;

  SELECT g.mode_id INTO g_mode FROM games g WHERE g.id=g_id LIMIT 1;
  SELECT cfg.`value` INTO two_phase_turn FROM mode_config cfg WHERE cfg.param='two_phase_turn' AND cfg.mode_id=g_mode;

  IF (game_feature_get_param(g_id, 'realtime_cards') AND @current_card_type = 'm') THEN
    LEAVE this_procedure;
  END IF;

  IF(two_phase_turn IS NULL OR two_phase_turn=0)THEN
    CALL end_turn(g_id,p_num);
  ELSE
    UPDATE active_players SET card_played_flag=1 WHERE game_id=g_id AND player_num=p_num;
    IF (check_all_units_moved(g_id,p_num) = 1) THEN
      CALL end_turn(g_id,p_num);
    END IF;
  END IF;

END$$

DELIMITER ;

use lords;

DELIMITER $$

DROP FUNCTION IF EXISTS `lords`.`check_play_card` $$

CREATE FUNCTION `check_play_card`(g_id INT,p_num INT,player_deck_id INT,sender VARCHAR(30)) RETURNS int(11)
BEGIN
  DECLARE crd_id INT;

  SELECT card_id INTO crd_id FROM player_deck WHERE id=player_deck_id;
  IF (SELECT gold FROM players WHERE game_id=g_id AND player_num=p_num LIMIT 1)<(SELECT cost FROM cards WHERE id=crd_id LIMIT 1) THEN RETURN 2; END IF;
  IF NOT EXISTS(SELECT cp.id FROM player_deck pd JOIN cards_procedures cp ON pd.card_id=cp.card_id JOIN procedures pm ON cp.procedure_id=pm.id WHERE pd.id=player_deck_id AND pm.name=sender LIMIT 1) THEN RETURN 15; END IF;
  IF NOT EXISTS(SELECT id FROM player_deck WHERE game_id=g_id AND player_num=p_num AND id=player_deck_id) THEN RETURN 10; END IF;

  IF game_feature_get_param(g_id, 'realtime_cards') = 0 OR (SELECT `type` FROM cards WHERE id=crd_id LIMIT 1) <> 'm' THEN
    IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id LIMIT 1) THEN RETURN 1; END IF;
    IF (SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id LIMIT 1)<>0 THEN RETURN 28; END IF;
    IF (SELECT card_played_flag FROM active_players WHERE game_id=g_id LIMIT 1)=1 THEN RETURN 42; END IF;
  END IF;

  UPDATE active_players SET current_procedure=sender WHERE game_id=g_id;

  RETURN 0;
END$$

DELIMITER ;

use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`buy_card` $$

CREATE PROCEDURE `buy_card`(g_id INT,  p_num INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE card_cost INT;
  DECLARE new_card INT;
  DECLARE first_card_id INT;
  DECLARE player_deck_id INT;
  DECLARE can_buy_only_in_my_turn INT;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SET can_buy_only_in_my_turn = 1 - game_feature_get_param(g_id, 'realtime_cards');

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
  SELECT cfg.`value` INTO card_cost FROM mode_config cfg WHERE cfg.param='card cost' AND cfg.mode_id=mode_id;

  IF can_buy_only_in_my_turn AND NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;
  ELSE
    IF can_buy_only_in_my_turn AND (SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id LIMIT 1)<>0 THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=28;
    ELSE
      IF can_buy_only_in_my_turn AND (SELECT card_played_flag FROM active_players WHERE game_id=g_id)=1 THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=42;
      ELSE
        IF (SELECT gold FROM players WHERE game_id=g_id AND player_num=p_num)<card_cost THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=2;
        ELSE
          IF NOT EXISTS (SELECT id FROM deck WHERE game_id=g_id) THEN
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=3;
          ELSE

            CALL user_action_begin(g_id, p_num);

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
            
            IF can_buy_only_in_my_turn THEN
              CALL end_cards_phase(g_id,p_num);
            END IF;

            CALL user_action_end(g_id, p_num);
          END IF;
        END IF;
      END IF;
    END IF;
  END IF;

  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;

use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`take_subsidy` $$

CREATE PROCEDURE `take_subsidy`(g_id INT,  p_num INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE subsidy_amt INT;
  DECLARE subsidy_damage INT;
  DECLARE board_castle_id INT;
  DECLARE health_remaining INT;
  DECLARE can_only_in_my_turn INT;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
  SELECT cfg.`value` INTO subsidy_amt FROM mode_config cfg WHERE cfg.param='subsidy amount' AND cfg.mode_id=mode_id;
  SELECT cfg.`value` INTO subsidy_damage FROM mode_config cfg WHERE cfg.param='subsidy castle damage' AND cfg.mode_id=mode_id;
  SET can_only_in_my_turn = 1 - game_feature_get_param(g_id, 'realtime_cards');

  IF can_only_in_my_turn AND NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;
  ELSE
    IF can_only_in_my_turn AND (SELECT subsidy_flag FROM active_players WHERE game_id=g_id)=1 THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=5;
    ELSE
      IF (SELECT bb.health FROM board_buildings bb JOIN buildings b ON bb.building_id=b.id WHERE bb.game_id=g_id AND bb.player_num=p_num AND b.`type`='castle' LIMIT 1)<=subsidy_damage THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=6;
      ELSE
        CALL user_action_begin(g_id, p_num);

        SELECT bb.id INTO board_castle_id FROM board_buildings bb JOIN board b ON bb.id=b.ref WHERE b.`type`='castle' AND b.game_id=g_id AND bb.player_num=p_num LIMIT 1;
        UPDATE players SET gold=gold+subsidy_amt WHERE game_id=g_id AND player_num=p_num;
        UPDATE board_buildings SET health=health-subsidy_damage WHERE id=board_castle_id;

        IF can_only_in_my_turn THEN
          UPDATE active_players SET subsidy_flag=1 WHERE game_id=g_id;
        END IF;

        SELECT health INTO health_remaining FROM board_buildings WHERE id=board_castle_id;

        CALL cmd_player_set_gold(g_id,p_num);
        CALL cmd_building_set_health(g_id,p_num,board_castle_id);

        CALL cmd_log_add_independent_message(g_id, p_num, 'take_subsidy', CONCAT_WS(';', log_building(board_castle_id), health_remaining));

        CALL user_action_end(g_id, p_num);
      END IF;
    END IF;
  END IF;


  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;

use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`send_money` $$

CREATE PROCEDURE `send_money`(g_id INT,    p_num INT,    p2_num INT,    amount_input_str VARCHAR(100) CHARSET utf8)
BEGIN
  DECLARE amount INT;

  DECLARE conversion_error INT DEFAULT 0;
  DECLARE bandit_bu_id INT;
  DECLARE can_only_in_my_turn INT;
  DECLARE CONTINUE HANDLER FOR SQLSTATE '22007' SET conversion_error = 1;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SET can_only_in_my_turn = 1 - game_feature_get_param(g_id, 'realtime_cards');

  IF can_only_in_my_turn AND NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='not_your_turn';
  ELSE
    SET amount=CAST(amount_input_str AS SIGNED INTEGER);
    IF (conversion_error=1 OR amount<=0) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='incorrect_sum';
    ELSE
      IF (p_num=p2_num) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='cant_send_money_to_self';
      ELSE
        IF (SELECT gold FROM players WHERE game_id=g_id AND player_num=p_num)<amount THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='not_enough_gold';
        ELSE
          IF NOT EXISTS(SELECT id FROM players WHERE game_id=g_id AND player_num=p2_num) THEN
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='send_money_invalid_player';
          ELSE

            CALL user_action_begin(g_id, p_num);

            UPDATE players SET gold=gold-amount WHERE game_id=g_id AND player_num=p_num;
            UPDATE players SET gold=gold+amount WHERE game_id=g_id AND player_num=p2_num;

            CALL cmd_player_set_gold(g_id,p_num);
            CALL cmd_player_set_gold(g_id,p2_num);

            CALL cmd_log_add_independent_message(g_id, p_num, 'send_money', CONCAT_WS(';', log_player(g_id, p2_num), amount));
            
            IF (SELECT p.owner FROM players p WHERE p.game_id = g_id AND p.player_num = p2_num) <> 1 THEN
              SELECT bu.id INTO bandit_bu_id FROM board_units bu
                WHERE bu.game_id = g_id AND bu.player_num = p2_num AND unit_feature_check(bu.id, 'bandit') LIMIT 1;
              IF bandit_bu_id IS NOT NULL THEN
                CALL bandit_get_money(bandit_bu_id, p_num, amount);
              END IF;
            END IF;

            CALL user_action_end(g_id, p_num);
          END IF;
        END IF;
      END IF;
    END IF;
  END IF;

  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;

