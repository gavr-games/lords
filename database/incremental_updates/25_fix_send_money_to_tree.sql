use lords;

insert into error_dictionary(code) values ('send_money_invalid_player');
SET @err_id = LAST_INSERT_ID();
insert into error_dictionary_i18n(error_id, language_id, description) values
(@err_id, 1, 'Transaction cancelled, the recipient could not sign'),
(@err_id, 2, 'Перевод отменен, адресат не смог расписаться о получении');

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`send_money` $$

CREATE PROCEDURE `send_money`(g_id INT,  p_num INT,  p2_num INT,  amount_input_str VARCHAR(100) CHARSET utf8)
BEGIN
  DECLARE amount INT;

  DECLARE conversion_error INT DEFAULT 0;
  DECLARE CONTINUE HANDLER FOR SQLSTATE '22007' SET conversion_error = 1;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
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

          CALL user_action_begin();

          UPDATE players SET gold=gold-amount WHERE game_id=g_id AND player_num=p_num;
          UPDATE players SET gold=gold+amount WHERE game_id=g_id AND player_num=p2_num;

          CALL cmd_player_set_gold(g_id,p_num);
          CALL cmd_player_set_gold(g_id,p2_num);

          CALL cmd_log_add_independent_message(g_id, p_num, 'send_money', CONCAT_WS(';', log_player(g_id, p2_num), amount));

          CALL user_action_end();
        END IF;
      END IF;
    END IF;
  END IF;
  END IF;
END$$

DELIMITER ;
