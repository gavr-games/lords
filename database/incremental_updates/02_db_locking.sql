use lords;

DELIMITER $$

DROP FUNCTION IF EXISTS `lords`.`get_game_lock_name` $$

CREATE FUNCTION `get_game_lock_name`(g_id INT) RETURNS VARCHAR(20)
BEGIN
  RETURN CONCAT('lock_game_', g_id);
END$$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`player_end_turn` $$

CREATE PROCEDURE `player_end_turn`(g_id INT,  p_num INT)
BEGIN
  DECLARE moved_units INT;
  DECLARE did_card_action INT;
  DECLARE taken_subsidy INT;
  DECLARE owner INT;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;
  ELSE
    CALL user_action_begin(g_id, p_num);

    SELECT units_moves_flag, card_played_flag, subsidy_flag
      INTO moved_units, did_card_action, taken_subsidy
      FROM active_players WHERE game_id=g_id LIMIT 1;
    SELECT p.owner INTO owner FROM players p WHERE p.game_id=g_id AND p.player_num=p_num LIMIT 1;

    IF moved_units=1 OR owner<>1 THEN
      CALL cmd_log_add_message(g_id, p_num, 'end_turn', log_player(g_id, p_num));
      CALL finish_moving_units(g_id,p_num);
    ELSE
      CALL cmd_log_add_independent_message(g_id, p_num, 'end_turn', log_player(g_id, p_num));
    END IF;
    
    IF moved_units = 0 AND did_card_action = 0 AND taken_subsidy = 0 THEN
      CALL castle_auto_repair(g_id,p_num);
    END IF;

    CALL end_turn(g_id,p_num);

    CALL user_action_end(g_id, p_num);
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
  DECLARE CONTINUE HANDLER FOR SQLSTATE '22007' SET conversion_error = 1;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

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

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

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
            CALL end_cards_phase(g_id,p_num);

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

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
  SELECT cfg.`value` INTO subsidy_amt FROM mode_config cfg WHERE cfg.param='subsidy amount' AND cfg.mode_id=mode_id;
  SELECT cfg.`value` INTO subsidy_damage FROM mode_config cfg WHERE cfg.param='subsidy castle damage' AND cfg.mode_id=mode_id;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;
  ELSE
    IF (SELECT subsidy_flag FROM active_players WHERE game_id=g_id)=1 THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=5;
    ELSE
      IF (SELECT bb.health FROM board_buildings bb JOIN buildings b ON bb.building_id=b.id WHERE bb.game_id=g_id AND bb.player_num=p_num AND b.`type`='castle' LIMIT 1)<=subsidy_damage THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=6;
      ELSE
        CALL user_action_begin(g_id, p_num);

        SELECT bb.id INTO board_castle_id FROM board_buildings bb JOIN board b ON bb.id=b.ref WHERE b.`type`='castle' AND b.game_id=g_id AND bb.player_num=p_num LIMIT 1;
        UPDATE players SET gold=gold+subsidy_amt WHERE game_id=g_id AND player_num=p_num;
        UPDATE board_buildings SET health=health-subsidy_damage WHERE id=board_castle_id;
        UPDATE active_players SET subsidy_flag=1 WHERE game_id=g_id;
        
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

DROP PROCEDURE IF EXISTS `lords`.`player_resurrect` $$

CREATE PROCEDURE `player_resurrect`(g_id INT,    p_num INT,    grave_id INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE dead_card_id INT;
  DECLARE resurrection_cost_coefficient INT;
  DECLARE resur_cost INT;
  DECLARE x_appear, y_appear INT;
  DECLARE new_unit_id INT;
  DECLARE size INT;
  DECLARE u_id INT;
  DECLARE new_bu_id INT;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
  SELECT cfg.`value` INTO resurrection_cost_coefficient FROM mode_config cfg WHERE cfg.param='resurrection cost coefficient' AND cfg.mode_id=mode_id;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'not_your_turn';
  ELSE
    IF (SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id LIMIT 1)<>0 THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'need_to_finish_card_action';
    ELSE
      IF (SELECT card_played_flag FROM active_players WHERE game_id=g_id)=1 THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'can_play_card_or_resurrect_only_once_per_turn';
      ELSE
        IF NOT EXISTS(SELECT id FROM graves WHERE game_id=g_id AND id=grave_id LIMIT 1) THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'no_such_dead_unit';
        ELSE
          IF EXISTS (SELECT id FROM graves
                        WHERE game_id = g_id
                          AND id=grave_id
                          AND player_num_when_killed = get_current_p_num(g_id)
                          AND turn_when_killed = get_current_turn(g_id))
          THEN
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'cant_resurrect_same_turn';
          ELSE
            SELECT g.card_id INTO dead_card_id FROM graves g WHERE id=grave_id;
            SELECT cost*resurrection_cost_coefficient INTO resur_cost FROM cards WHERE id=dead_card_id LIMIT 1;
            IF (SELECT gold FROM players WHERE game_id=g_id AND player_num=p_num LIMIT 1)<resur_cost THEN
              SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'not_enough_gold';
            ELSE
              SELECT u.id, u.size INTO u_id, size FROM cards c JOIN units u ON c.ref = u.id WHERE c.id = dead_card_id LIMIT 1;
              CALL get_unit_appear_point_near_castle(g_id, p_num, u_id, x_appear, y_appear);
              IF EXISTS(
                SELECT b.id FROM board b WHERE b.game_id = g_id
                  AND b.x BETWEEN x_appear AND x_appear + size - 1
                  AND b.y BETWEEN y_appear AND y_appear + size - 1)
              THEN
                SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'spawn_point_occupued';
              ELSE
                CALL user_action_begin(g_id, p_num);

                UPDATE players SET gold=gold-resur_cost WHERE game_id=g_id AND player_num=p_num;
                CALL cmd_player_set_gold(g_id,p_num);

                CALL resurrect(g_id,p_num,grave_id);

                SELECT MAX(id) INTO new_bu_id FROM board_units bu WHERE bu.game_id=g_id AND bu.player_num=p_num;
                CALL cmd_log_add_independent_message(g_id, p_num, 'resurrect', CONCAT_WS(';', log_player(g_id, p_num), log_unit(new_bu_id)));

                CALL end_cards_phase(g_id,p_num);

                CALL user_action_end(g_id, p_num);
              END IF;
            END IF;
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

DROP PROCEDURE IF EXISTS `lords`.`put_building` $$

CREATE PROCEDURE `put_building`(g_id INT,    p_num INT,    player_deck_id INT,    x INT,    y INT,    rotation INT,    flip INT)
BEGIN
  DECLARE crd_id INT;
  DECLARE err_code INT;
  DECLARE x_len,y_len INT;
  DECLARE x2,y2 INT; 
  DECLARE new_building_id INT;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

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
      CALL create_new_building(g_id, p_num, NULL, crd_id, x, y, rotation, flip);
      SET new_building_id = @new_board_building_id;
      IF new_building_id = 0 THEN 
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='place_occupied';
      ELSE
        CALL user_action_begin(g_id, p_num);
        CALL play_card_actions(g_id,p_num,player_deck_id); 

        CALL cmd_put_building_by_card(g_id,p_num,new_building_id);

        IF EXISTS(SELECT sc.id FROM summon_cfg sc WHERE sc.building_id=(SELECT bb.building_id FROM board_buildings bb WHERE id=new_building_id)) THEN
          CALL summon_creatures(new_building_id);
        END IF;
        
        IF building_feature_check(new_building_id, 'paralysing') THEN
          CALL buidling_paralyse_enemies(new_building_id);
        END IF;

        CALL finish_playing_card(g_id,p_num);
        CALL end_cards_phase(g_id,p_num);
        CALL user_action_end(g_id, p_num);
      END IF;
    END IF;
  END IF;

  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_pooring` $$

CREATE PROCEDURE `cast_pooring`(g_id INT,  p_num INT,  player_deck_id INT,  p2_num INT)
BEGIN
  DECLARE err_code INT;
  DECLARE pooring_sum INT DEFAULT 50;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_pooring');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT id FROM players WHERE game_id=g_id AND player_num=p2_num) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=13;
    ELSE
      CALL user_action_begin(g_id, p_num);

      CALL play_card_actions(g_id,p_num,player_deck_id); 


      UPDATE players SET gold=CASE WHEN gold<pooring_sum THEN 0 ELSE gold-pooring_sum END WHERE game_id=g_id AND player_num=p2_num;
      CALL cmd_player_set_gold(g_id,p2_num);

      CALL cmd_log_add_message(g_id, p_num, 'player_loses_gold', CONCAT_WS(';', log_player(g_id, p2_num), pooring_sum));

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end(g_id, p_num);
    END IF;
  END IF;

  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_riching` $$

CREATE PROCEDURE `cast_riching`(g_id INT, p_num INT, player_deck_id INT)
BEGIN
  DECLARE err_code INT;
  DECLARE riching_sum INT DEFAULT 50;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_riching');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    CALL user_action_begin(g_id, p_num);

    CALL play_card_actions(g_id,p_num,player_deck_id); 


    UPDATE players SET gold=gold+riching_sum WHERE game_id=g_id AND player_num=p_num;
    CALL cmd_player_set_gold(g_id,p_num);

    CALL finish_playing_card(g_id,p_num);
    CALL end_cards_phase(g_id,p_num);

    CALL user_action_end(g_id, p_num);
  END IF;


  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_half_money` $$

CREATE PROCEDURE `cast_half_money`(g_id INT, p_num INT, player_deck_id INT)
BEGIN
  DECLARE err_code INT;
  DECLARE p_num_cur INT;

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT p.player_num FROM players p WHERE p.game_id=g_id AND owner<>0 AND gold>0;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_half_money');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    CALL user_action_begin(g_id, p_num);

    CALL play_card_actions(g_id,p_num,player_deck_id); 


    UPDATE players SET gold=gold/2 WHERE game_id=g_id AND owner<>0 AND gold>0;

    OPEN cur;
    REPEAT
      FETCH cur INTO p_num_cur;
      IF NOT done THEN
        CALL cmd_player_set_gold(g_id,p_num_cur);
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur;


    CALL finish_playing_card(g_id,p_num);
    CALL end_cards_phase(g_id,p_num);

    CALL user_action_end(g_id, p_num);
  END IF;


  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`summon_unit` $$

CREATE PROCEDURE `summon_unit`(g_id INT,  p_num INT,  player_deck_id INT)
BEGIN
  DECLARE crd_id INT;
  DECLARE err_code INT;
  DECLARE x_appear,y_appear INT;
  DECLARE size INT;
  DECLARE new_unit_id INT;
  DECLARE u_id INT;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'summon_unit');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    SELECT card_id INTO crd_id FROM player_deck WHERE id=player_deck_id;
    SELECT u.size,u.id INTO size,u_id FROM cards c JOIN units u ON c.ref=u.id WHERE c.id=crd_id LIMIT 1;
    CALL get_unit_appear_point_near_castle(g_id, p_num, u_id, x_appear, y_appear);
    IF EXISTS(
      SELECT b.id FROM board b WHERE b.game_id = g_id
        AND b.x BETWEEN x_appear AND x_appear + size - 1
        AND b.y BETWEEN y_appear AND y_appear + size - 1)
    THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'spawn_point_occupued';
    ELSE
      CALL user_action_begin(g_id, p_num);

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      CALL create_new_unit(g_id, p_num, NULL, crd_id, x_appear, y_appear, 0);
      SET new_unit_id = @new_board_unit_id;

      UPDATE board_units SET moves_left = 0 WHERE id = new_unit_id;
      CALL cmd_unit_set_moves_left(g_id,p_num,new_unit_id);

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end(g_id, p_num);
    END IF;
  END IF;


  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_fireball` $$

CREATE PROCEDURE `cast_fireball`(g_id INT,   p_num INT,   player_deck_id INT,   x INT,   y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE fb_damage INT DEFAULT 1;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_fireball');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      CALL user_action_begin(g_id, p_num);

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      CALL magical_damage(g_id,p_num,x,y,fb_damage);

      INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'magical_attack');

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end(g_id, p_num);
    END IF;
  END IF;


  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_lightening_min` $$

CREATE PROCEDURE `cast_lightening_min`(g_id INT,   p_num INT,   player_deck_id INT,   x INT,   y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE li_damage INT DEFAULT 2;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_lightening_min');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      CALL user_action_begin(g_id, p_num);

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      CALL magical_damage(g_id,p_num,x,y,li_damage);

      INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'magical_attack');

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end(g_id, p_num);
    END IF;
  END IF;


  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_lightening_max` $$

CREATE PROCEDURE `cast_lightening_max`(g_id INT,   p_num INT,   player_deck_id INT,   x INT,   y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE li_damage INT DEFAULT 3;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_lightening_max');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      CALL user_action_begin(g_id, p_num);

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      IF get_random_int_between(1, 6) < 3 THEN
        CALL cmd_miss_game_log(g_id,x,y);
      ELSE
        CALL magical_damage(g_id,p_num,x,y,li_damage);
      END IF;

      INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'magical_attack');

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end(g_id, p_num);
    END IF;
  END IF;


  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`player_move_unit` $$

CREATE PROCEDURE `player_move_unit`(g_id INT, p_num INT, x INT, y INT, x2 INT, y2 INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE size INT;
  DECLARE moveable INT DEFAULT 0;
  DECLARE teleportable INT DEFAULT 0;
  DECLARE flyable INT DEFAULT 0;
  DECLARE moves_spent INT DEFAULT 1;
  DECLARE moves_left INT DEFAULT 1;
  DECLARE taran_unit_id INT;
  DECLARE taran_x,taran_y,taran_prev_x,taran_prev_y INT;
  DECLARE x0,y0 INT;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'player_move_unit'); 
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
    SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;
    SELECT u.size, bu.moves_left INTO size, moves_left FROM board_units bu JOIN units u ON (bu.unit_id=u.id) WHERE bu.id=board_unit_id LIMIT 1;
    SELECT MIN(b.x),MIN(b.y) INTO x0,y0 FROM board b WHERE b.game_id=g_id AND b.ref=board_unit_id AND b.`type`='unit';

    SET moveable=check_one_step_from_unit(g_id,x,y,x2,y2);

    IF moveable=0
       AND unit_feature_check(board_unit_id,'flying') AND NOT unit_feature_check(board_unit_id,'knight')
       AND get_distance_between_cells(x0, y0, x2, y2) BETWEEN 1 AND moves_left
    THEN
      SET flyable = 1;
      SET moves_spent = get_distance_between_cells(x0, y0, x2, y2);
    END IF; 

    IF (moveable=0 AND flyable=0) AND (unit_feature_check(board_unit_id,'magic_immunity')=0) AND EXISTS
    (SELECT a.id FROM board_buildings bb,board b,allcoords a
      WHERE bb.game_id=g_id AND building_feature_check(bb.id,'teleport')=1 AND check_building_deactivated(bb.id)=0
      AND b.`type`<>'unit' AND b.ref=bb.id
      AND get_building_team(bb.id) = get_unit_team(board_unit_id)
      AND a.mode_id=mode_id
      AND a.x BETWEEN b.x-bb.radius AND b.x+bb.radius AND a.y BETWEEN b.y-bb.radius AND b.y+bb.radius
      AND a.x BETWEEN x2 AND x2+size-1 AND a.y BETWEEN y2 AND y2+size-1 LIMIT 1)
    THEN
      SET teleportable=1;
    END IF;
    
    IF NOT (moveable OR teleportable OR flyable)
    THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'cant_step_on_cell';
    ELSE
      IF EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x BETWEEN x2 AND x2+size-1 AND b.y BETWEEN y2 AND y2+size-1 AND NOT(b.`type`='unit' AND b.ref=board_unit_id) LIMIT 1) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'place_occupied';
      ELSE

                CALL unit_action_begin(g_id, p_num);

                IF (unit_feature_get_param(board_unit_id,'bind_target') IS NOT NULL) THEN
                  CALL unit_feature_remove(board_unit_id,'bind_target');
                END IF; 

                CALL move_unit(board_unit_id,x2,y2);
                UPDATE board_units bu SET bu.moves_left=CASE WHEN teleportable THEN 0 ELSE bu.moves_left - moves_spent END WHERE bu.id=board_unit_id;
                CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);


                SELECT bu.id INTO taran_unit_id FROM board_units bu WHERE unit_feature_get_param(bu.id,'bind_target')=board_unit_id LIMIT 1;
                IF taran_unit_id IS NOT NULL THEN
                  IF teleportable OR flyable THEN
                    CALL unit_feature_remove(taran_unit_id,'bind_target');
                  ELSE
                    IF (size=1) THEN
                      SET taran_x=x;
                      SET taran_y=y;
                    ELSE
                      SELECT b.x,b.y INTO taran_prev_x,taran_prev_y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=taran_unit_id LIMIT 1;
                      SELECT a.x,a.y INTO taran_x,taran_y FROM allcoords a WHERE a.mode_id=mode_id AND a.x BETWEEN x0 AND x0+size-1 AND a.y BETWEEN y0 AND y0+size-1 AND a.x BETWEEN x2-1 AND x2+size AND a.y BETWEEN y2-1 AND y2+size AND NOT (a.x BETWEEN x2 AND x2+size-1 AND a.y BETWEEN y2 AND y2+size-1) ORDER BY ((taran_prev_x-a.x)*(taran_prev_x-a.x)+(taran_prev_y-a.y)*(taran_prev_y-a.y)) LIMIT 1;
                    END IF;
                    CALL move_unit(taran_unit_id,taran_x,taran_y);
                  END IF;
                END IF;

                CALL unit_action_end(g_id, p_num);
      END IF;
    END IF;
  END IF;


  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`attack` $$

CREATE PROCEDURE `attack`(g_id INT, p_num INT, x INT, y INT,  x2 INT,  y2 INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE size INT;
  DECLARE aim_type VARCHAR(45);
  DECLARE aim_id INT;

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT DISTINCT b.`type`,b.ref FROM board b
      WHERE b.game_id=g_id AND b.`type`<>'obstacle'
        AND b.x BETWEEN x2 AND x2+size-1 AND b.y BETWEEN y2 AND y2+size-1
        AND NOT(b.`type`='unit' AND b.ref=board_unit_id);
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'attack'); 
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF check_one_step_from_unit(g_id,x,y,x2,y2)=0 THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=20;
    ELSE

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;
      SELECT u.size INTO size FROM board_units bu JOIN units u ON (bu.unit_id=u.id) WHERE bu.id=board_unit_id LIMIT 1;

      IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.`type`<>'obstacle' AND b.x BETWEEN x2 AND x2+size-1 AND b.y BETWEEN y2 AND y2+size-1 AND NOT(b.`type`='unit' AND b.ref=board_unit_id) LIMIT 1)
      THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=21;
      ELSE

                CALL unit_action_begin(g_id, p_num);

                IF (unit_feature_get_param(board_unit_id,'bind_target') IS NOT NULL) THEN 
                  CALL unit_feature_remove(board_unit_id,'bind_target');
                END IF; 

                UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
                CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

                IF size=1 THEN
                  SELECT b.`type`,b.ref INTO aim_type,aim_id FROM board b WHERE b.game_id=g_id AND b.x=x2 AND b.y=y2 LIMIT 1;
                  CALL attack_actions(board_unit_id,aim_type,aim_id);
                  INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'unit_attack');
                ELSE 
                  OPEN cur;
                  REPEAT
                    FETCH cur INTO aim_type,aim_id;
                    IF NOT done AND EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.`type`=aim_type AND b.ref=aim_id LIMIT 1) THEN
                      CALL attack_actions(board_unit_id,aim_type,aim_id);
                      INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'unit_attack');
                      SET done = 0;
                    END IF;
                  UNTIL done END REPEAT;
                  CLOSE cur;
                END IF;

                CALL unit_action_end(g_id, p_num);
      END IF;
    END IF;
  END IF;


  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`player_exit` $$

CREATE PROCEDURE `player_exit`(g_id INT,    p_num INT)
BEGIN
  DECLARE p_id INT;
  DECLARE finished_game_status INT DEFAULT 3; 
  DECLARE user_id INT;
  DECLARE owner INT;
  DECLARE player_online_status_id INT DEFAULT 1; 
  DECLARE mode_id INT;
  DECLARE game_type_id INT;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  CALL user_action_begin(g_id, p_num);

  SELECT g.mode_id, g.type_id INTO mode_id, game_type_id FROM games g WHERE g.id = g_id;

  SELECT p.id,p.owner,p.user_id INTO p_id,owner,user_id FROM players p WHERE game_id=g_id AND player_num=p_num;

  IF (SELECT g.status_id FROM games g WHERE g.id=g_id LIMIT 1)<>finished_game_status AND (owner=1) THEN
    CALL cmd_log_add_independent_message(g_id, p_num, 'player_exit', log_player(g_id, p_num));

    CALL delete_player_objects(g_id,p_num);

    IF (SELECT player_num FROM active_players WHERE game_id=g_id LIMIT 1)=p_num THEN
      CALL end_turn(g_id,p_num);
    END IF;

    CALL cmd_delete_player(g_id,p_num);

    UPDATE players SET owner=0, move_order = NULL WHERE game_id=g_id AND player_num=p_num;

    INSERT INTO lords_site.user_statistics_games(user_id,game_type_id,mode_id,game_result)
    VALUES(user_id,game_type_id,mode_id,'exit');

    IF ((SELECT COUNT(DISTINCT p.team) FROM players p WHERE p.game_id=g_id AND p.owner=1)=1) OR (NOT EXISTS(SELECT p.id FROM players p WHERE p.game_id=g_id AND p.owner=1 AND p.agree_draw=0)) THEN
      CALL end_game(g_id);
    END IF;
  END IF;

  IF(owner=0)THEN
    CALL cmd_remove_spectator(g_id,p_num);
  END IF;

  DELETE agp FROM lords_site.arena_game_players agp WHERE agp.user_id=user_id;

  UPDATE lords_site.arena_users au SET au.status_id=player_online_status_id
    WHERE au.user_id=user_id;


  IF (SELECT COUNT(*) FROM players p WHERE p.game_id=g_id AND p.player_num<>p_num AND p.owner IN(0,1))=0 THEN
    CALL delete_game_data(g_id);
  END IF;

  CALL user_action_end(g_id, p_num);
  
  DELETE FROM players WHERE game_id=g_id AND player_num=p_num;  

  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`agree_draw` $$

CREATE PROCEDURE `agree_draw`(g_id INT,  p_num INT)
BEGIN

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  CALL user_action_begin(g_id, p_num);

  UPDATE players SET agree_draw=1 WHERE game_id=g_id AND player_num=p_num;

  CALL cmd_log_add_independent_message(g_id, p_num, 'agrees_to_draw', NULL);

  IF NOT EXISTS(SELECT p.id FROM players p WHERE p.game_id=g_id AND p.owner=1 AND p.agree_draw=0) THEN
    CALL end_game(g_id);
  END IF;

  CALL user_action_end(g_id, p_num);


  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`disagree_draw` $$

CREATE PROCEDURE `disagree_draw`(g_id INT,  p_num INT)
BEGIN

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  CALL user_action_begin(g_id, p_num);

  UPDATE players SET agree_draw=0 WHERE game_id=g_id AND player_num=p_num;
  CALL cmd_log_add_independent_message(g_id, p_num, 'disagrees_to_draw', NULL);

  CALL user_action_end(g_id, p_num);


  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_paralich` $$

CREATE PROCEDURE `cast_paralich`(g_id INT,  p_num INT,  player_deck_id INT,  x INT,  y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE shield INT;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_paralich');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      CALL user_action_begin(g_id, p_num);

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;
      CALL paralyse_unit(board_unit_id);

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end(g_id, p_num);
    END IF;
  END IF;


  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_madness` $$

CREATE PROCEDURE `cast_madness`(g_id INT,  p_num INT,  player_deck_id INT,  x INT,  y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE shield INT;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_madness');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      CALL user_action_begin(g_id, p_num);

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;
      SELECT bu.shield INTO shield FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

      IF (unit_feature_check(board_unit_id,'magic_immunity')=0) THEN 
        IF shield>0 THEN
          CALL shield_off(board_unit_id);
        ELSE
          CALL make_mad(board_unit_id);
        END IF;
      ELSE
        CALL cmd_magic_resistance_log(g_id,p_num,board_unit_id);
      END IF;

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end(g_id, p_num);
    END IF;
  END IF;


  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_shield` $$

CREATE PROCEDURE `cast_shield`(g_id INT, p_num INT, player_deck_id INT, x INT, y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_shield');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      CALL user_action_begin(g_id, p_num);

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;

      CALL magical_shield_on(g_id,p_num,x,y);

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end(g_id, p_num);
    END IF;
  END IF;


  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_healing` $$

CREATE PROCEDURE `cast_healing`(g_id INT, p_num INT, player_deck_id INT, x INT, y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE hp_heal INT DEFAULT 1;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_healing');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      CALL user_action_begin(g_id, p_num);

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      CALL magical_heal(g_id,p_num,x,y,hp_heal);

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end(g_id, p_num);
    END IF;
  END IF;


  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_o_d` $$

CREATE PROCEDURE `cast_o_d`(g_id INT,   p_num INT,   player_deck_id INT,   x INT,   y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE shield INT;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_o_d');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      CALL user_action_begin(g_id, p_num);

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;
      SELECT bu.shield INTO shield FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

      IF (unit_feature_check(board_unit_id,'magic_immunity')=0) THEN 

        IF shield>0 THEN
          CALL shield_off(board_unit_id);
        ELSE
          IF get_random_int_between(1, 6) = 6 THEN 
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

      CALL user_action_end(g_id, p_num);
    END IF;
  END IF;


  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_teleport` $$

CREATE PROCEDURE `cast_teleport`(g_id INT, p_num INT, player_deck_id INT, x INT, y INT,  x2 INT,  y2 INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE u_id INT;
  DECLARE size INT;
  DECLARE target INT;
  DECLARE binded_unit_id INT;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_teleport');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;
      SELECT bu.unit_id,u.size INTO u_id,size FROM board_units bu JOIN units u ON (bu.unit_id=u.id) WHERE bu.id=board_unit_id LIMIT 1;

      IF EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x BETWEEN x2 AND x2+size-1 AND b.y BETWEEN y2 AND y2+size-1 AND NOT(b.`type`='unit' AND b.ref=board_unit_id) LIMIT 1) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=12;
      ELSE
        CALL user_action_begin(g_id, p_num);

        CALL play_card_actions(g_id,p_num,player_deck_id); 

        IF (unit_feature_check(board_unit_id,'magic_immunity')=0) THEN 

          IF (unit_feature_get_param(board_unit_id,'bind_target') IS NOT NULL) THEN 
            CALL unit_feature_remove(board_unit_id,'bind_target');
          END IF; 

          CALL move_unit(board_unit_id,x2,y2);
          UPDATE board_units SET moves_left=0 WHERE id=board_unit_id;
          CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

          
          DELETE FROM board_units_features WHERE feature_id=unit_feature_get_id_by_code('bind_target') AND param=board_unit_id;

        ELSE
          CALL cmd_magic_resistance_log(g_id,p_num,board_unit_id);
        END IF;

        CALL finish_playing_card(g_id,p_num);
        CALL end_cards_phase(g_id,p_num);

        CALL user_action_end(g_id, p_num);
      END IF;
    END IF;
  END IF;


  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_mind_control` $$

CREATE PROCEDURE `cast_mind_control`(g_id INT,   p_num INT,   player_deck_id INT,   x INT,   y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE p2_num INT;
  DECLARE shield INT;
  DECLARE npc_gold INT;
  DECLARE log_msg_code VARCHAR(50) CHARSET utf8 DEFAULT 'mind_control';

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_mind_control');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      CALL user_action_begin(g_id, p_num);

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;
      SELECT bu.player_num INTO p2_num FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;
      SELECT bu.shield INTO shield FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

      IF (unit_feature_check(board_unit_id,'magic_immunity')=0) THEN

        IF shield>0 THEN
          CALL shield_off(board_unit_id);
        ELSE

          IF(unit_feature_check(board_unit_id,'under_control')=1)THEN
            CALL unit_feature_remove(board_unit_id,'under_control');
          END IF;

          IF(unit_feature_check(board_unit_id,'madness')=1)THEN
            CALL unit_feature_set(board_unit_id,'madness',p_num);
            CALL make_not_mad(board_unit_id);
          END IF;

          IF(p_num<>p2_num)THEN
            UPDATE board_units SET player_num=p_num,moves_left=0 WHERE id=board_unit_id;
            CALL cmd_unit_set_owner(g_id,p_num,board_unit_id);
            CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

            IF (((SELECT owner FROM players WHERE game_id=g_id AND player_num=p2_num LIMIT 1)<>1)
              AND NOT EXISTS (SELECT id FROM board_units WHERE game_id=g_id AND player_num=p2_num)
              AND NOT EXISTS (SELECT id FROM board_buildings WHERE game_id=g_id AND player_num=p2_num))
            THEN
              SELECT gold INTO npc_gold FROM players WHERE game_id=g_id AND player_num=p2_num LIMIT 1; 
              IF(npc_gold>0)THEN
                UPDATE players SET gold=gold+npc_gold WHERE game_id=g_id AND player_num=p_num;
                CALL cmd_player_set_gold(g_id,p_num);
              END IF;

              DELETE FROM players WHERE game_id=g_id AND player_num=p2_num; 
              CALL cmd_delete_player(g_id,p2_num);
            END IF;

          ELSE
            SET log_msg_code = 'mind_control_own_unit';
          END IF;


          IF EXISTS(SELECT id FROM board_units_features WHERE feature_id=unit_feature_get_id_by_code('under_control') AND param=board_unit_id LIMIT 1)THEN
            CALL zombies_change_player_to_nec(board_unit_id);
          END IF;

          CALL cmd_log_add_message(g_id, p_num, log_msg_code, CONCAT_WS(';', log_unit(board_unit_id), log_player(g_id, p_num)));

          IF check_unit_in_paralysing_range(board_unit_id) THEN
            CALL paralyse_unit(board_unit_id);
          END IF;

        END IF;
      ELSE
        CALL cmd_magic_resistance_log(g_id,p_num,board_unit_id);
      END IF;

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end(g_id, p_num);
    END IF;
  END IF;


  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_show_cards` $$

CREATE PROCEDURE `cast_show_cards`(g_id INT,  p_num INT,  player_deck_id INT,  p2_num INT)
BEGIN
  DECLARE err_code INT;
  DECLARE card_id INT;

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT pd.card_id FROM player_deck pd WHERE pd.game_id=g_id AND pd.player_num=p2_num;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_show_cards');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT id FROM players WHERE game_id=g_id AND player_num=p2_num) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=13;
    ELSE
      CALL user_action_begin(g_id, p_num);

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      CALL cmd_log_add_message(g_id, p_num, 'players_cards', log_player(g_id, p2_num));

      OPEN cur;
      REPEAT
        FETCH cur INTO card_id;
        IF NOT done THEN
          CALL cmd_log_add_message(g_id, p_num, 'card_name', card_id);
        END IF;
      UNTIL done END REPEAT;
      CLOSE cur;

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end(g_id, p_num);
    END IF;
  END IF;


  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_telekinesis` $$

CREATE PROCEDURE `cast_telekinesis`(g_id INT,   p_num INT,   player_deck_id INT,   p2_num INT)
BEGIN
  DECLARE err_code INT;
  DECLARE rand_card INT;
  DECLARE big_dice INT;
  DECLARE stolen_card_id INT;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_telekinesis');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT id FROM players WHERE game_id=g_id AND player_num=p2_num) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=13;
    ELSE
      IF NOT EXISTS(SELECT id FROM player_deck WHERE game_id=g_id AND player_num=p2_num LIMIT 1) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=22;
      ELSE
        CALL user_action_begin(g_id, p_num);

        CALL play_card_actions(g_id,p_num,player_deck_id); 

        CREATE TEMPORARY TABLE pl_cards (id_rand INT AUTO_INCREMENT PRIMARY KEY)AUTO_INCREMENT=1 SELECT id AS `pd_id` FROM player_deck WHERE game_id=g_id AND player_num=p2_num;
        SELECT get_random_int_between(1, MAX(id_rand)) INTO big_dice FROM pl_cards;
        SELECT pd_id INTO rand_card FROM pl_cards WHERE id_rand=big_dice LIMIT 1;
        DROP TEMPORARY TABLE pl_cards;

        SELECT card_id INTO stolen_card_id FROM player_deck WHERE id=rand_card;
        UPDATE player_deck SET player_num=p_num WHERE id=rand_card;
        CALL cmd_remove_card(g_id,p2_num,rand_card);
        CALL cmd_add_card(g_id,p_num,rand_card);

        CALL cmd_log_add_message_hidden(g_id, p_num, 'new_card', stolen_card_id);
        CALL cmd_log_add_message_hidden(g_id, p2_num, 'card_stolen', stolen_card_id);

        CALL finish_playing_card(g_id,p_num);
        CALL end_cards_phase(g_id,p_num);

        CALL user_action_end(g_id, p_num);
      END IF;
    END IF;
  END IF;


  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_speeding` $$

CREATE PROCEDURE `cast_speeding`(g_id INT,  p_num INT,  player_deck_id INT,  x INT,  y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE speed_bonus INT DEFAULT 2;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_speeding');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      CALL user_action_begin(g_id, p_num);

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;

      IF (unit_feature_check(board_unit_id,'magic_immunity')=0) THEN 
        CALL unit_add_moves(board_unit_id, speed_bonus * get_magic_field_factor(g_id, p_num, x, y));
      ELSE
        CALL cmd_magic_resistance_log(g_id,p_num,board_unit_id);
      END IF;

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end(g_id, p_num);
    END IF;
  END IF;


  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_unit_upgrade_all` $$

CREATE PROCEDURE `cast_unit_upgrade_all`(g_id INT,  p_num INT,  player_deck_id INT,  x INT,  y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE speed_bonus INT DEFAULT 1;
  DECLARE health_bonus INT DEFAULT 1;
  DECLARE attack_bonus INT DEFAULT 1;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_unit_upgrade_all');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      CALL user_action_begin(g_id, p_num);

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;

      IF (unit_feature_check(board_unit_id,'magic_immunity')=0) THEN 
        CALL unit_add_moves(board_unit_id, speed_bonus * get_magic_field_factor(g_id, p_num, x, y));
        CALL unit_add_health(board_unit_id, health_bonus * get_magic_field_factor(g_id, p_num, x, y));
        CALL unit_add_attack(board_unit_id, attack_bonus * get_magic_field_factor(g_id, p_num, x, y));
      ELSE
        CALL cmd_magic_resistance_log(g_id,p_num,board_unit_id);
      END IF;

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end(g_id, p_num);
    END IF;
  END IF;


  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_unit_upgrade_random` $$

CREATE PROCEDURE `cast_unit_upgrade_random`(g_id INT,  p_num INT,  player_deck_id INT,  x INT,  y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE dice INT;
  DECLARE speed_bonus INT DEFAULT 3;
  DECLARE health_bonus INT DEFAULT 3;
  DECLARE attack_bonus INT DEFAULT 3;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_unit_upgrade_random');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      CALL user_action_begin(g_id, p_num);

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;

      IF (unit_feature_check(board_unit_id,'magic_immunity')=0) THEN 
        SET dice = get_random_int_between(1, 3);
        IF dice=1 THEN
          CALL unit_add_moves(board_unit_id, speed_bonus * get_magic_field_factor(g_id, p_num, x, y));
        END IF;
        IF dice=2 THEN
          CALL unit_add_health(board_unit_id, health_bonus * get_magic_field_factor(g_id, p_num, x, y));
        END IF;
        IF dice=3 THEN
          CALL unit_add_attack(board_unit_id, attack_bonus * get_magic_field_factor(g_id, p_num, x, y));
        END IF;
      ELSE
        CALL cmd_magic_resistance_log(g_id,p_num,board_unit_id);
      END IF;

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end(g_id, p_num);
    END IF;
  END IF;


  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_armageddon` $$

CREATE PROCEDURE `cast_armageddon`(g_id INT,    p_num INT,    player_deck_id INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE board_building_id INT;
  DECLARE chance INT DEFAULT 1;

  DECLARE done INT DEFAULT 0;
  
  DECLARE cur CURSOR FOR SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id;
  
  DECLARE cur2 CURSOR FOR SELECT bb.id FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.game_id=g_id AND b.`type`<>'castle';
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_armageddon');
  IF err_code<>0 THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    CALL user_action_begin(g_id, p_num);

    CALL play_card_actions(g_id,p_num,player_deck_id); 

    CALL cmd_play_video(g_id,p_num,'armageddon',0,0);

    OPEN cur;
    REPEAT
      FETCH cur INTO board_unit_id;
      IF NOT done THEN
        IF get_random_int_between(1, 6) > chance THEN
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
        IF get_random_int_between(1, 6) > chance THEN
          CALL destroy_building(board_building_id,p_num);
        END IF;
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur2;

    CALL finish_playing_card(g_id,p_num);
    CALL end_cards_phase(g_id,p_num);

    CALL user_action_end(g_id, p_num);
  END IF;

  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_meteor_shower` $$

CREATE PROCEDURE `cast_meteor_shower`(g_id INT, p_num INT, player_deck_id INT, x INT, y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE x1,y1 INT;
  DECLARE meteor_damage INT DEFAULT 2;
  DECLARE meteor_size INT DEFAULT 2;

  DECLARE aim_id INT;
  DECLARE aim_type VARCHAR(45);

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT b.x,b.y,b.`type`,b.ref FROM board b WHERE b.game_id=g_id AND b.`type` IN ('unit','building') AND b.x BETWEEN x AND x+meteor_size-1 AND b.y BETWEEN y AND y+meteor_size-1;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_meteor_shower');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF (x<0 OR x>(20-meteor_size) OR y<0 OR y>(20-meteor_size)) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=23;
    ELSE
      CALL user_action_begin(g_id, p_num);

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      OPEN cur;
      REPEAT
        FETCH cur INTO x1,y1,aim_type,aim_id;
        IF NOT done THEN
          
          IF((aim_type='unit' AND EXISTS(SELECT bu.id FROM board_units bu WHERE bu.id=aim_id LIMIT 1))
            OR(aim_type='building' AND EXISTS(SELECT bb.id FROM board_buildings bb WHERE bb.id=aim_id LIMIT 1)))THEN
            CALL magical_damage(g_id,p_num,x1,y1,meteor_damage);
          END IF;
        END IF;
      UNTIL done END REPEAT;
      CLOSE cur;

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end(g_id, p_num);
    END IF;
  END IF;


  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_repair_buildings` $$

CREATE PROCEDURE `cast_repair_buildings`(g_id INT, p_num INT, player_deck_id INT)
BEGIN
  DECLARE err_code INT;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_repair_buildings');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    CALL user_action_begin(g_id, p_num);

    CALL play_card_actions(g_id,p_num,player_deck_id); 

    CALL repair_buildings(g_id,p_num);

    CALL finish_playing_card(g_id,p_num);
    CALL end_cards_phase(g_id,p_num);

    CALL user_action_end(g_id, p_num);
  END IF;


  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_polza_main` $$

CREATE PROCEDURE `cast_polza_main`(g_id INT,    p_num INT,    player_deck_id INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE err_code INT;
  DECLARE dice INT;
  DECLARE nonfinished_action INT DEFAULT 0;
  DECLARE riching_sum INT DEFAULT 60;
  DECLARE take_cards_qty INT DEFAULT 2;
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'execute_procedure("$cmd_name")';

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_polza_main');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    CALL user_action_begin(g_id, p_num);

    CALL play_card_actions(g_id,p_num,player_deck_id); 

    SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
    SET dice = get_random_int_between(1, 6);

    CASE dice

      WHEN 1 THEN
        CALL cmd_log_add_message(g_id, p_num, 'polza_repair_and_heal', NULL);
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

    CALL user_action_end(g_id, p_num);
  END IF;


  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_polza_resurrect` $$

CREATE PROCEDURE `cast_polza_resurrect`(g_id INT,  p_num INT,  grave_id INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE nonfinished_action INT DEFAULT 1;
  DECLARE x_appear,y_appear,x_dir,y_dir INT;
  DECLARE size INT;
  DECLARE u_id INT;
  DECLARE dead_card_id INT;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;
  ELSE
    IF NOT nonfinished_action=(SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=24;
    ELSE
      IF NOT EXISTS(SELECT id FROM graves WHERE game_id=g_id AND id=grave_id LIMIT 1) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=8;
      ELSE
          CALL user_action_begin(g_id, p_num);

          SELECT g.card_id INTO dead_card_id FROM graves g WHERE id=grave_id;
          SELECT ap.x,ap.y,ap.direction_into_board_x,ap.direction_into_board_y INTO x_appear,y_appear,x_dir,y_dir FROM appear_points ap WHERE ap.mode_id=mode_id AND ap.player_num=p_num;
          SELECT u.id,u.size INTO u_id,size FROM cards c JOIN units u ON c.ref=u.id WHERE c.id=dead_card_id LIMIT 1;
          IF EXISTS(SELECT id FROM board WHERE game_id=g_id AND x BETWEEN LEAST(x_appear,x_appear+x_dir*(size-1)) AND GREATEST(x_appear,x_appear+x_dir*(size-1)) AND y BETWEEN LEAST(y_appear,y_appear+y_dir*(size-1)) AND GREATEST(y_appear,y_appear+y_dir*(size-1)) LIMIT 1) THEN
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=9;
          ELSE

            CALL resurrect(g_id,p_num,grave_id);
            CALL cmd_resurrect_by_card_log(g_id,p_num,dead_card_id);

            UPDATE active_players SET nonfinished_action_id=0 WHERE game_id=g_id AND player_num=p_num;

            CALL finish_playing_card(g_id,p_num);
            CALL end_cards_phase(g_id,p_num);

            CALL user_action_end(g_id, p_num);
          END IF;
      END IF;
    END IF;
  END IF;


  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_polza_units_from_zone` $$

CREATE PROCEDURE `cast_polza_units_from_zone`(g_id INT,  p_num INT,  zone INT)
BEGIN
  DECLARE nonfinished_action INT DEFAULT 2;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;
  ELSE
    IF NOT nonfinished_action=(SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=24;
    ELSE
      IF zone NOT IN(0,1,2,3) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=25;
      ELSE
            CALL user_action_begin(g_id, p_num);

            CALL units_from_zone(g_id, p_num, zone);

            UPDATE active_players SET nonfinished_action_id=0 WHERE game_id=g_id AND player_num=p_num;

            CALL finish_playing_card(g_id,p_num);
            CALL end_cards_phase(g_id,p_num);

            CALL user_action_end(g_id, p_num);
      END IF;
    END IF;
  END IF;


  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_polza_move_building` $$

CREATE PROCEDURE `cast_polza_move_building`(g_id INT,  p_num INT,  b_x INT,  b_y INT,  x INT,  y INT,  rot INT,  flp INT)
BEGIN
  DECLARE nonfinished_action INT DEFAULT 3;
  DECLARE board_building_id INT;
  DECLARE p2_num INT;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;
  ELSE
    IF NOT nonfinished_action=(SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=24;
    ELSE
      SELECT b.ref INTO board_building_id FROM board b WHERE b.game_id=g_id AND b.`type` IN ('building','obstacle') AND b.x=b_x AND b.y=b_y LIMIT 1;
      IF board_building_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=26;
      ELSE
        SELECT bb.player_num INTO p2_num FROM board_buildings bb WHERE bb.id=board_building_id LIMIT 1;
        IF p2_num=p_num THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=27;
        ELSE
          IF building_feature_check(board_building_id,'not_movable')=1 THEN
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=43;
          ELSE
            CALL user_action_begin(g_id, p_num);


            UPDATE board SET ref=0 WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=board_building_id;

            CALL place_building_on_board(board_building_id,x,y,rot,flp);

            IF NOT EXISTS(SELECT id FROM board WHERE game_id=g_id AND `type`<>'unit' AND ref=board_building_id) THEN 
              UPDATE board SET ref=board_building_id WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0;
              SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=12;
            ELSE
            
              DELETE FROM board WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0; 

              UPDATE board_buildings SET player_num=p_num,rotation=rot,flip=flp WHERE id=board_building_id;

              CALL count_income(board_building_id);

              CALL cmd_move_building(g_id,p_num,b_x,b_y,board_building_id);
              CALL cmd_building_set_owner(g_id,p_num,board_building_id);


              UPDATE active_players SET nonfinished_action_id=0 WHERE game_id=g_id AND player_num=p_num;

              CALL finish_playing_card(g_id,p_num);
              CALL end_cards_phase(g_id,p_num);

              CALL user_action_end(g_id, p_num);
            END IF;
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

DROP PROCEDURE IF EXISTS `lords`.`cast_vred_main` $$

CREATE PROCEDURE `cast_vred_main`(g_id INT,    p_num INT,    player_deck_id INT)
BEGIN
  DECLARE err_code INT;
  DECLARE dice INT;
  DECLARE nonfinished_action INT DEFAULT 0;
  DECLARE pooring_sum INT DEFAULT 60;
  DECLARE take_cards_qty INT DEFAULT 1;
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'execute_procedure("$cmd_name")';

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_vred_main');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    CALL user_action_begin(g_id, p_num);

    CALL play_card_actions(g_id,p_num,player_deck_id); 

    SET dice = get_random_int_between(1, 6);

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
        SET zone = get_random_int_between(0, 3);
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

    CALL user_action_end(g_id, p_num);
  END IF;



  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_vred_pooring` $$

CREATE PROCEDURE `cast_vred_pooring`(g_id INT,  p_num INT,  p2_num INT)
BEGIN
  DECLARE nonfinished_action INT DEFAULT 4;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;
  ELSE
    IF NOT nonfinished_action=(SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=24;
    ELSE
      IF NOT EXISTS(SELECT id FROM players WHERE game_id=g_id AND player_num=p2_num AND owner<>0) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=13;
      ELSE
        CALL user_action_begin(g_id, p_num);

        CALL vred_pooring(g_id,p2_num);

        UPDATE active_players SET nonfinished_action_id=0 WHERE game_id=g_id AND player_num=p_num;

        CALL finish_playing_card(g_id,p_num);
        CALL end_cards_phase(g_id,p_num);

        CALL user_action_end(g_id, p_num);
      END IF;
    END IF;
  END IF;


  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_vred_kill_unit` $$

CREATE PROCEDURE `cast_vred_kill_unit`(g_id INT,  p_num INT,  x INT,  y INT)
BEGIN
  DECLARE nonfinished_action INT DEFAULT 5;
  DECLARE board_unit_id INT;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;
  ELSE
    IF NOT nonfinished_action=(SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=24;
    ELSE
      IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
      ELSE
        CALL user_action_begin(g_id, p_num);

        SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;

        CALL magic_kill_unit(board_unit_id,p_num);

        UPDATE active_players SET nonfinished_action_id=0 WHERE game_id=g_id AND player_num=p_num;

        CALL finish_playing_card(g_id,p_num);
        CALL end_cards_phase(g_id,p_num);

        CALL user_action_end(g_id, p_num);
      END IF;
    END IF;
  END IF;


  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_vred_destroy_building` $$

CREATE PROCEDURE `cast_vred_destroy_building`(g_id INT,  p_num INT,  x INT,  y INT)
BEGIN
  DECLARE nonfinished_action INT DEFAULT 6;
  DECLARE board_building_id INT;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;
  ELSE
    IF NOT nonfinished_action=(SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=24;
    ELSE
      SELECT b.ref INTO board_building_id FROM board b WHERE b.game_id=g_id AND b.`type` IN ('building','obstacle') AND b.x=x AND b.y=y LIMIT 1;
      IF board_building_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=26;
      ELSE
        CALL user_action_begin(g_id, p_num);

        CALL destroy_building(board_building_id,p_num);

        UPDATE active_players SET nonfinished_action_id=0 WHERE game_id=g_id AND player_num=p_num;

        CALL finish_playing_card(g_id,p_num);
        CALL end_cards_phase(g_id,p_num);

        CALL user_action_end(g_id, p_num);
      END IF;
    END IF;
  END IF;


  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_vred_move_building` $$

CREATE PROCEDURE `cast_vred_move_building`(g_id INT,  p_num INT,  b_x INT,  b_y INT,  x INT,  y INT,  rot INT,  flp INT)
BEGIN
  DECLARE nonfinished_action INT DEFAULT 7;
  DECLARE board_building_id INT;
  DECLARE p2_num INT;
  DECLARE building_id INT;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;
  ELSE
    IF NOT nonfinished_action=(SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=24;
    ELSE
      SELECT b.ref INTO board_building_id FROM board b WHERE b.game_id=g_id AND b.`type` IN ('building','obstacle') AND b.x=b_x AND b.y=b_y LIMIT 1;
      IF board_building_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=26;
      ELSE
        SELECT bb.player_num INTO p2_num FROM board_buildings bb WHERE bb.id=board_building_id LIMIT 1;
        IF p2_num=p_num THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=27;
        ELSE
          IF building_feature_check(board_building_id,'not_movable')=1 THEN
            SELECT bb.building_id INTO building_id FROM board_buildings bb WHERE bb.id=board_building_id;
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=43;
          ELSE
            CALL user_action_begin(g_id, p_num);


            UPDATE board SET ref=0 WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=board_building_id;

            CALL place_building_on_board(board_building_id,x,y,rot,flp);

            IF NOT EXISTS(SELECT id FROM board WHERE game_id=g_id AND `type`<>'unit' AND ref=board_building_id) THEN 
              UPDATE board SET ref=board_building_id WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0;
              SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=12;
            ELSE
            
              DELETE FROM board WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0; 

              UPDATE board_buildings SET rotation=rot,flip=flp WHERE id=board_building_id;

              CALL count_income(board_building_id);

              CALL cmd_move_building(g_id,p_num,b_x,b_y,board_building_id);

              UPDATE active_players SET nonfinished_action_id=0 WHERE game_id=g_id AND player_num=p_num;

              CALL finish_playing_card(g_id,p_num);
              CALL end_cards_phase(g_id,p_num);

              CALL user_action_end(g_id, p_num);
            END IF;
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

DROP PROCEDURE IF EXISTS `lords`.`taran_bind` $$

CREATE PROCEDURE `taran_bind`(g_id INT,   p_num INT,   x INT,   y INT,    x2 INT,    y2 INT)
BEGIN
  DECLARE err_code INT;
  DECLARE aim_bu_id INT;
  DECLARE board_unit_id INT;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'taran_bind'); 
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;
    SELECT b.ref INTO aim_bu_id FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.x=x2 AND b.y=y2 LIMIT 1;
    IF aim_bu_id IS NULL THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=31;
    ELSE
      IF get_distance_between_units(board_unit_id, aim_bu_id) <> 1 THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=29;
      ELSE
        CALL unit_action_begin(g_id, p_num);

        UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
        CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

        CALL unit_feature_set(board_unit_id,'bind_target',aim_bu_id);

        CALL cmd_log_add_message(g_id, p_num, 'unit_attaches', CONCAT_WS(';', log_unit(board_unit_id), log_unit(aim_bu_id)));

        CALL unit_action_end(g_id, p_num);

      END IF;
    END IF;
  END IF;


  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`wizard_heal` $$

CREATE PROCEDURE `wizard_heal`(g_id INT,   p_num INT,   x INT,   y INT,    x2 INT,    y2 INT)
BEGIN
  DECLARE err_code INT;
  DECLARE aim_bu_id INT;
  DECLARE board_unit_id INT;
  DECLARE hp_heal INT DEFAULT 1;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'wizard_heal'); 
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;
    SELECT b.ref INTO aim_bu_id FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.x=x2 AND b.y=y2 LIMIT 1;
    IF aim_bu_id IS NULL THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=32;
    ELSE
      IF get_distance_between_units(board_unit_id, aim_bu_id) <> 1 THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=29;
      ELSE
        CALL unit_action_begin(g_id, p_num);

        UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
        CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

        CALL cmd_log_add_message(g_id, p_num, 'unit_heals', CONCAT_WS(';', log_unit(board_unit_id), log_unit(aim_bu_id)));

        CALL magical_heal(g_id,p_num,x2,y2,hp_heal);

        CALL unit_action_end(g_id, p_num);
      END IF;
    END IF;
  END IF;


  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`wizard_fireball` $$

CREATE PROCEDURE `wizard_fireball`(g_id INT,    p_num INT,    x INT,    y INT,     x2 INT,     y2 INT)
BEGIN
  DECLARE err_code INT;
  DECLARE aim_bu_id INT;
  DECLARE board_unit_id INT;
  DECLARE dice INT;
  DECLARE fb_damage INT DEFAULT 1;
  DECLARE health_before_hit,experience INT;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'wizard_fireball'); 
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
      SELECT b.ref INTO aim_bu_id FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.x=x2 AND b.y=y2 LIMIT 1;
      IF aim_bu_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=33;
      ELSE
        CALL unit_action_begin(g_id, p_num);

        SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;
        SELECT bu.health INTO health_before_hit FROM board_units bu WHERE bu.id=aim_bu_id LIMIT 1;

        UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
        CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

        CALL cmd_log_add_message(g_id, p_num, 'unit_casts_fb', CONCAT_WS(';', log_unit(board_unit_id), log_unit(aim_bu_id)));

        SET dice = get_random_int_between(1, 6);

        IF dice=1 THEN 
          IF get_random_int_between(1, 6) < 6 THEN
            CALL cmd_log_add_message(g_id, p_num, 'miss_rus_rul', log_unit(board_unit_id));
          ELSE
            CALL magic_kill_unit(board_unit_id,p_num);
          END IF;
        ELSE
          IF dice IN (5,6) THEN 
            IF get_random_int_between(1, 6) < 3 THEN
              CALL cmd_miss_game_log(g_id,x2,y2);
            ELSE
              CALL magical_damage(g_id,p_num,x2,y2,fb_damage);
              
              SET experience = get_experience_for_hitting(aim_bu_id, 'unit', health_before_hit);
              IF(experience > 0)THEN
                CALL unit_add_exp(board_unit_id, experience);
              END IF;
            END IF;
          ELSE 
            CALL cmd_log_add_message(g_id, p_num, 'cast_unsuccessful', NULL);
          END IF;
        END IF;

        INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'magical_attack');

        CALL unit_action_end(g_id, p_num);
      END IF;
  END IF;


  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`necromancer_resurrect` $$

CREATE PROCEDURE `necromancer_resurrect`(g_id INT,    p_num INT,    x INT,    y INT,    grave_id INT)
BEGIN
  DECLARE dead_card_id INT;
  DECLARE err_code INT;
  DECLARE u2_id INT;
  DECLARE board_unit_id INT;
  DECLARE new_unit_id INT;
  DECLARE resur_cost INT;
  DECLARE grave_x, grave_y INT;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'necromancer_resurrect'); 
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT id FROM graves WHERE game_id=g_id AND id=grave_id LIMIT 1) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=8;
    ELSE
      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;
      IF get_distance_from_unit_to_object(board_unit_id, 'grave', grave_id) <> 1 THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=34;
      ELSE
        IF EXISTS (SELECT b.id FROM board b JOIN grave_cells gc ON (b.x=gc.x AND b.y=gc.y) WHERE b.game_id=g_id AND gc.grave_id=grave_id LIMIT 1) THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=12;
        ELSE
          SELECT g.card_id INTO dead_card_id FROM graves g WHERE id=grave_id;
          SELECT c.cost INTO resur_cost FROM cards c WHERE c.id=dead_card_id LIMIT 1;
          IF (SELECT gold FROM players WHERE game_id=g_id AND player_num=p_num LIMIT 1)<resur_cost THEN
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=2;
          ELSE

            CALL unit_action_begin(g_id, p_num);

            UPDATE players SET gold=gold-resur_cost WHERE game_id=g_id AND player_num=p_num;
            CALL cmd_player_set_gold(g_id,p_num);

            SELECT c.ref INTO u2_id FROM cards c WHERE c.id=dead_card_id LIMIT 1;

            UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id = board_unit_id;
            CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

            SELECT MIN(gc.x), MIN(gc.y) INTO grave_x, grave_y
              FROM grave_cells gc WHERE gc.grave_id = grave_id;

            CALL create_new_unit(g_id, p_num, NULL, dead_card_id, grave_x, grave_y, 0);
            SET new_unit_id = @new_board_unit_id;

            UPDATE board_units SET moves_left=0 WHERE id=new_unit_id;
            CALL cmd_unit_set_moves_left(g_id,p_num,new_unit_id);

            CALL unit_feature_set(new_unit_id, 'under_control', board_unit_id);

            DELETE FROM graves WHERE game_id=g_id AND id=grave_id;
            CALL cmd_remove_from_grave(g_id,p_num,grave_id);

            CALL unit_add_exp(board_unit_id, 1);

            INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'resurrect_unit',u2_id);

            CALL cmd_log_add_message(g_id, p_num, 'unit_resurrects', CONCAT_WS(';', log_unit(board_unit_id), log_unit(new_unit_id)));

            CALL unit_action_end(g_id, p_num);

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

DROP PROCEDURE IF EXISTS `lords`.`cast_vampire` $$

CREATE PROCEDURE `cast_vampire`(g_id INT,     p_num INT,     player_deck_id INT,     x INT,     y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE mode_id INT;
  DECLARE vamp_ui_code VARCHAR(45) CHARSET utf8 DEFAULT 'vampire'; 
  DECLARE vamp_u_id INT;
  DECLARE vamp_owner INT DEFAULT 4;
  DECLARE new_player INT;
  DECLARE vamp_name VARCHAR(45) CHARSET utf8;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_vampire');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF (quart(x,y)<>p_num) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=35;
    ELSE
      IF EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y LIMIT 1) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=9;
      ELSE

        CALL user_action_begin(g_id, p_num);

        CALL play_card_actions(g_id,p_num,player_deck_id); 

        SELECT vu.id INTO vamp_u_id FROM vw_mode_units vu WHERE vu.mode_id=mode_id AND vu.ui_code=vamp_ui_code;
        SET vamp_name = CONCAT('{', vamp_u_id, '}');
        CALL create_new_player(g_id, vamp_name, NULL, vamp_owner, get_player_language_id(g_id,p_num));
        SET new_player = @new_player_num;

        CALL create_new_unit(g_id, new_player, vamp_u_id, NULL, x, y, 1);

        CALL finish_playing_card(g_id,p_num);
        CALL end_cards_phase(g_id,p_num);

        CALL user_action_end(g_id, p_num);
      END IF;
    END IF;
  END IF;


  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`necromancer_sacrifice` $$

CREATE PROCEDURE `necromancer_sacrifice`(g_id INT,   p_num INT,   x INT,   y INT,   x_sacr INT,   y_sacr INT,    x_target INT,    y_target INT)
BEGIN
  DECLARE err_code INT;
  DECLARE sacr_bu_id INT;
  DECLARE target_bu_id INT;
  DECLARE board_unit_id INT;
  DECLARE sacr_health INT;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'necromancer_sacrifice'); 
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    SELECT b.ref INTO sacr_bu_id FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.x=x_sacr AND b.y=y_sacr LIMIT 1;
    IF sacr_bu_id IS NULL THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=37;
    ELSE
      IF (SELECT player_num FROM board_units WHERE id=sacr_bu_id)<>p_num THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=38;
      ELSE
        SELECT b.ref INTO target_bu_id FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.x=x_target AND b.y=y_target LIMIT 1;
        IF target_bu_id IS NULL THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=39;
        ELSE

          CALL unit_action_begin(g_id, p_num);

          SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;

          UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
          CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);


          CALL cmd_log_add_message(g_id, p_num, 'sacrifice', CONCAT_WS(';', log_unit(board_unit_id), log_unit(sacr_bu_id), log_unit(target_bu_id)));
          IF(sacr_bu_id=target_bu_id) THEN
            CALL cmd_log_add_message(g_id, p_num, 'unit_is_such_a_unit', log_unit(board_unit_id));
          END IF;

          IF (unit_feature_check(sacr_bu_id,'magic_immunity')=1) THEN 
            CALL cmd_magic_resistance_log(g_id,p_num,board_unit_id);
          ELSE

            SELECT bu.health INTO sacr_health FROM board_units bu WHERE bu.id=sacr_bu_id;

            CALL unit_feature_set(sacr_bu_id,'goes_to_deck_on_death',null);
            CALL kill_unit(sacr_bu_id,p_num);
            
            IF(sacr_bu_id <> target_bu_id)THEN
              CALL magical_damage(g_id, p_num, x_target, y_target, sacr_health);
            END IF;

          END IF;

          CALL unit_action_end(g_id, p_num);

        END IF;
      END IF;
    END IF;
  END IF;


  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`player_end_turn_by_timeout` $$

CREATE PROCEDURE `player_end_turn_by_timeout`(g_id INT,  p_num INT)
BEGIN

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;
  ELSE
    CALL user_action_begin(g_id, p_num);

    IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=1 THEN
      CALL cmd_log_add_message(g_id, p_num, 'end_turn_timeout', log_player(g_id, p_num));
      CALL finish_moving_units(g_id,p_num);
    ELSE
      CALL cmd_log_add_independent_message(g_id, p_num, 'end_turn_timeout', log_player(g_id, p_num));
    END IF;

    CALL end_turn(g_id,p_num);

    CALL user_action_end(g_id, p_num);
  END IF;


  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`get_unit_phrase` $$

CREATE PROCEDURE `get_unit_phrase`(g_id INT)
BEGIN
  DECLARE random_row INT;
  DECLARE board_unit_id INT;
  DECLARE unit_id INT;
  DECLARE phrase_id INT;
  DECLARE p_num INT;
  DECLARE lang_id INT;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  IF EXISTS(SELECT 1 FROM board_units bu WHERE bu.game_id=g_id LIMIT 1)THEN
    CREATE TEMPORARY TABLE tmp_units (id_rand INT AUTO_INCREMENT PRIMARY KEY)AUTO_INCREMENT=1
      SELECT
        bu.id AS `board_unit_id`,
        bu.unit_id AS `unit_id`,
        bu.player_num
      FROM board_units bu
      WHERE bu.game_id=g_id;

    SET random_row = get_random_int_between(1, (SELECT MAX(id_rand) FROM tmp_units));
    SELECT t.board_unit_id,t.unit_id,t.player_num INTO board_unit_id,unit_id,p_num FROM tmp_units t WHERE t.id_rand=random_row LIMIT 1;
    SET lang_id = get_player_language_id(g_id,p_num);
    DROP TEMPORARY TABLE tmp_units;

    IF EXISTS (SELECT 1 FROM dic_unit_phrases d WHERE d.unit_id=unit_id AND d.language_id = lang_id AND d.code IS NULL) THEN
      CREATE TEMPORARY TABLE tmp_unit_phrases (id_rand INT AUTO_INCREMENT PRIMARY KEY) AUTO_INCREMENT=1
        SELECT
          d.id
        FROM dic_unit_phrases d
        WHERE d.unit_id=unit_id AND d.language_id = lang_id AND d.code IS NULL;

      SET random_row = get_random_int_between(1, (SELECT MAX(id_rand) FROM tmp_unit_phrases));
      SELECT t.id INTO phrase_id FROM tmp_unit_phrases t WHERE t.id_rand=random_row LIMIT 1;
      DROP TEMPORARY TABLE tmp_unit_phrases;

      SELECT board_unit_id,phrase_id FROM DUAL;

    END IF;
  END IF;


  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`unit_shoot` $$

CREATE PROCEDURE `unit_shoot`(g_id INT,   p_num INT,   x INT,   y INT,   x2 INT,   y2 INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE shooting_unit_id INT;
  DECLARE aim_type VARCHAR(45);
  DECLARE aim_board_id INT;
  DECLARE aim_unit_id INT;
  DECLARE distance INT;
  DECLARE dice INT;
  DECLARE chance INT;
  DECLARE damage_modificator INT DEFAULT 0;
  DECLARE damage INT;
  DECLARE miss INT DEFAULT 0;
  DECLARE health_before_hit,experience INT;
  DECLARE aim_no_exp INT DEFAULT 0;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id = g_id LIMIT 1;
  SET err_code = check_unit_can_do_action(g_id,p_num,x,y,'unit_shoot'); 
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;
    SELECT bu.unit_id INTO shooting_unit_id FROM board_units bu WHERE bu.id = board_unit_id;
    SELECT b.type, b.ref INTO aim_type, aim_board_id FROM board b WHERE b.game_id = g_id AND b.x = x2 AND b.y = y2 LIMIT 1;
    IF aim_board_id IS NULL THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='no_valid_target';
    ELSE
      IF NOT EXISTS (SELECT id FROM shooting_params sp WHERE sp.unit_id = shooting_unit_id AND sp.aim_type = aim_type LIMIT 1) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='invalid_target_for_this_unit';
      ELSE
        SET distance = get_distance_from_unit_to_object(board_unit_id, aim_type, aim_board_id);
        IF distance < (SELECT MIN(sp.distance) FROM shooting_params sp WHERE sp.unit_id = shooting_unit_id AND sp.aim_type = aim_type) THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='target_too_close';
        ELSE
          IF distance > (SELECT MAX(sp.distance) FROM shooting_params sp WHERE sp.unit_id = shooting_unit_id AND sp.aim_type = aim_type) THEN
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='target_too_far';
          ELSE

            CALL unit_action_begin(g_id, p_num);

            UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
            CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);
            
            IF aim_type = 'unit' THEN
              SELECT bu.unit_id INTO aim_unit_id FROM board_units bu WHERE bu.id = aim_board_id LIMIT 1;
              IF EXISTS (SELECT 1 FROM attack_bonus ab WHERE ab.mode_id=mode_id AND ab.unit_id IS NULL AND ab.aim_type='unit' AND ab.aim_id=aim_unit_id) THEN
                SELECT ab.dice_max, ab.chance, ab.damage_bonus INTO dice, chance, damage_modificator FROM attack_bonus ab WHERE ab.mode_id=mode_id AND ab.unit_id IS NULL AND ab.aim_type='unit' AND ab.aim_id=aim_unit_id LIMIT 1;
                IF get_random_int_between(1, dice) < chance THEN
                  SET miss=1;
                END IF;
              END IF;
              SELECT bu.health INTO health_before_hit FROM board_units bu WHERE bu.id=aim_board_id LIMIT 1;
            ELSE
              IF(building_feature_check(aim_board_id,'no_exp')=1) THEN 
                SET aim_no_exp = 1;
              END IF;
              SELECT bb.health INTO health_before_hit FROM board_buildings bb WHERE bb.id=aim_board_id LIMIT 1;
            END IF;

            IF miss=0 THEN
              SELECT sp.dice_max, sp.chance, get_random_int_between(sp.damage_modificator_min, sp.damage_modificator_max) + damage_modificator
                INTO dice, chance, damage_modificator
                FROM shooting_params sp WHERE sp.unit_id = shooting_unit_id AND sp.aim_type = aim_type AND sp.distance = distance LIMIT 1;

              IF get_random_int_between(1, dice) < chance THEN
                SET miss=1;
              END IF;
            END IF;

            INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'unit_attack');
            IF miss=1 THEN
              INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'miss_attack');
              IF aim_type = 'unit' THEN
                CALL cmd_log_add_message(g_id, p_num, 'unit_shoots_unit_miss', CONCAT_WS(';', log_unit(board_unit_id), log_unit(aim_board_id)));
              ELSE
                CALL cmd_log_add_message(g_id, p_num, 'unit_shoots_building_miss', CONCAT_WS(';', log_unit(board_unit_id), log_building(aim_board_id)));
              END IF;
            ELSE
              SELECT bu.attack + damage_modificator INTO damage FROM board_units bu WHERE bu.id=board_unit_id;

              CASE aim_type
                WHEN 'unit' THEN CALL cmd_log_add_message(g_id, p_num, 'unit_shoots_unit', CONCAT_WS(';', log_unit(board_unit_id), log_unit(aim_board_id), damage));
                ELSE CALL cmd_log_add_message(g_id, p_num, 'unit_shoots_building', CONCAT_WS(';', log_unit(board_unit_id), log_building(aim_board_id), damage));
              END CASE;

              IF (aim_type = 'unit' AND unit_feature_check(aim_board_id, 'agressive') = 1) THEN
                CALL unit_feature_set(aim_board_id,'attack_target',board_unit_id);
              END IF;

              CASE aim_type
                WHEN 'unit' THEN CALL hit_unit(aim_board_id, p_num, damage);
                WHEN 'building' THEN CALL hit_building(aim_board_id, p_num, damage);
                WHEN 'castle' THEN CALL hit_castle(aim_board_id, p_num, damage);
              END CASE;

              SET experience = get_experience_for_hitting(aim_board_id, aim_type, health_before_hit);
              IF (experience > 0 AND aim_no_exp = 0) THEN
                CALL unit_add_exp(board_unit_id, experience);
              END IF;
            END IF;

            CALL unit_action_end(g_id, p_num);

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

DROP PROCEDURE IF EXISTS `lords`.`wall_open` $$

CREATE PROCEDURE `wall_open`(g_id INT,  p_num INT,  x INT,  y INT)
BEGIN
  DECLARE g_mode INT;
  DECLARE err_code INT;
  DECLARE board_building_id INT;
  DECLARE current_turn INT;
  DECLARE old_wall_building_id INT;
  DECLARE new_wall_building_id INT;
  DECLARE rotation,flip,x_min,y_min INT;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SELECT g.mode_id INTO g_mode FROM games g WHERE g.id=g_id LIMIT 1;

  SET err_code=check_building_can_do_action(g_id,p_num,x,y,'wall_open'); 
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    SELECT b.ref INTO board_building_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`<>'unit' LIMIT 1;
    SELECT turn INTO current_turn FROM active_players WHERE game_id=g_id;

    SELECT MIN(b.x),MIN(b.y) INTO x_min,y_min FROM board b WHERE b.game_id=g_id AND b.`type`<>'unit' AND b.ref=board_building_id;
    SELECT bb.rotation,bb.flip,bb.building_id INTO rotation,flip,old_wall_building_id FROM board_buildings bb WHERE bb.id=board_building_id LIMIT 1;

    SELECT v.building_id INTO new_wall_building_id FROM  vw_mode_building_default_features v WHERE v.mode_id=g_mode AND v.feature_id=building_feature_get_id_by_code('wall_opened');

    UPDATE board_buildings SET building_id=new_wall_building_id WHERE id=board_building_id;

    
    UPDATE board SET ref=0 WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=board_building_id;

    CALL place_building_on_board(board_building_id,x_min,y_min,rotation,flip);

    IF NOT EXISTS(SELECT id FROM board WHERE game_id=g_id AND `type`<>'unit' AND ref=board_building_id) THEN 
      UPDATE board SET ref=board_building_id WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0;
      UPDATE board_buildings SET building_id=old_wall_building_id WHERE id=board_building_id;
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=12;
    ELSE
      CALL user_action_begin(g_id, p_num);

      DELETE FROM board WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0; 

      IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
        CALL start_moving_units(g_id,p_num);
      END IF;

      CALL cmd_destroy_building(g_id,p_num,board_building_id);
      CALL cmd_put_building_by_id(g_id,p_num,board_building_id);
      CALL cmd_building_set_health(g_id,p_num,board_building_id);

      CALL building_feature_set(board_building_id,'turn_when_changed',current_turn);

      CALL cmd_log_add_message(g_id, p_num, 'building_opens', log_building(board_building_id));

      CALL user_action_end(g_id, p_num);
    END IF;
  END IF;

  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`wall_close` $$

CREATE PROCEDURE `wall_close`(g_id INT,  p_num INT,  x INT,  y INT)
BEGIN
  DECLARE g_mode INT;
  DECLARE err_code INT;
  DECLARE board_building_id INT;
  DECLARE current_turn INT;
  DECLARE old_wall_building_id INT;
  DECLARE new_wall_building_id INT;
  DECLARE rotation,flip,x_min,y_min INT;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SELECT g.mode_id INTO g_mode FROM games g WHERE g.id=g_id LIMIT 1;

  SET err_code=check_building_can_do_action(g_id,p_num,x,y,'wall_close'); 
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    SELECT b.ref INTO board_building_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`<>'unit' LIMIT 1;
    SELECT turn INTO current_turn FROM active_players WHERE game_id=g_id;

    SELECT MIN(b.x),MIN(b.y) INTO x_min,y_min FROM board b WHERE b.game_id=g_id AND b.`type`<>'unit' AND b.ref=board_building_id;
    SELECT bb.rotation,bb.flip,bb.building_id INTO rotation,flip,old_wall_building_id FROM board_buildings bb WHERE bb.id=board_building_id LIMIT 1;

    SELECT v.building_id INTO new_wall_building_id FROM  vw_mode_building_default_features v WHERE v.mode_id=g_mode AND v.feature_id=building_feature_get_id_by_code('wall_closed');

    UPDATE board_buildings SET building_id=new_wall_building_id WHERE id=board_building_id;

    
    UPDATE board SET ref=0 WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=board_building_id;

    CALL place_building_on_board(board_building_id,x_min,y_min,rotation,flip);

    IF NOT EXISTS(SELECT id FROM board WHERE game_id=g_id AND `type`<>'unit' AND ref=board_building_id) THEN 
      UPDATE board SET ref=board_building_id WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0;
      UPDATE board_buildings SET building_id=old_wall_building_id WHERE id=board_building_id;
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=12;
    ELSE
      CALL user_action_begin(g_id, p_num);

      DELETE FROM board WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0; 

      IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
        CALL start_moving_units(g_id,p_num);
      END IF;

      CALL cmd_destroy_building(g_id,p_num,board_building_id);
      CALL cmd_put_building_by_id(g_id,p_num,board_building_id);
      CALL cmd_building_set_health(g_id,p_num,board_building_id);

      CALL building_feature_set(board_building_id,'turn_when_changed',current_turn);

      CALL cmd_log_add_message(g_id, p_num, 'building_closes', log_building(board_building_id));

      CALL user_action_end(g_id, p_num);
    END IF;
  END IF;

  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_iron_skin` $$

CREATE PROCEDURE `cast_iron_skin`(g_id INT,  p_num INT,  player_deck_id INT,  x INT,  y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE bonus INT DEFAULT 2;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_iron_skin');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      CALL user_action_begin(g_id, p_num);

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;

      IF (unit_feature_check(board_unit_id,'magic_immunity')=0) THEN 
        CALL unit_add_health(board_unit_id, bonus * get_magic_field_factor(g_id, p_num, x, y));
      ELSE
        CALL cmd_magic_resistance_log(g_id,p_num,board_unit_id);
      END IF;

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end(g_id, p_num);
    END IF;
  END IF;


  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_horseshoe` $$

CREATE PROCEDURE `cast_horseshoe`(g_id INT,  p_num INT,  player_deck_id INT,  x INT,  y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_horseshoe');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      CALL user_action_begin(g_id, p_num);

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;

      IF (unit_feature_check(board_unit_id,'magic_immunity')=0) THEN 
        UPDATE board_units SET moves = 1, moves_left = LEAST(moves_left, 1) WHERE id=board_unit_id;
        CALL unit_feature_set(board_unit_id,'knight',null);
        CALL cmd_unit_set_moves(g_id,p_num,board_unit_id);
        CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);
        CALL cmd_unit_add_effect(g_id,board_unit_id,'knight');
      ELSE
        CALL cmd_magic_resistance_log(g_id,p_num,board_unit_id);
      END IF;

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end(g_id, p_num);
    END IF;
  END IF;


  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_berserk` $$

CREATE PROCEDURE `cast_berserk`(g_id INT,  p_num INT,  player_deck_id INT,  x INT,  y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE bonus INT DEFAULT 2;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_berserk');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      CALL user_action_begin(g_id, p_num);

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;

      IF (unit_feature_check(board_unit_id,'magic_immunity')=0) THEN 
        CALL unit_add_attack(board_unit_id, bonus * get_magic_field_factor(g_id, p_num, x, y));
      ELSE
        CALL cmd_magic_resistance_log(g_id,p_num,board_unit_id);
      END IF;

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end(g_id, p_num);
    END IF;
  END IF;


  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_demolition` $$

CREATE PROCEDURE `cast_demolition`(g_id INT, p_num INT, player_deck_id INT, b_x INT, b_y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_building_id INT;
  DECLARE demolition_damage INT DEFAULT 4;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_demolition');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    SELECT b.ref INTO board_building_id FROM board b WHERE b.game_id=g_id AND b.`type`='building' AND b.x=b_x AND b.y=b_y LIMIT 1;
    IF board_building_id IS NULL THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='building_not_selected';
    ELSE
        CALL user_action_begin(g_id, p_num);
        CALL play_card_actions(g_id,p_num,player_deck_id); 
        CALL magical_damage(g_id,p_num,b_x,b_y,demolition_damage);
        CALL finish_playing_card(g_id,p_num);
        CALL end_cards_phase(g_id,p_num);
        CALL user_action_end(g_id, p_num);
    END IF;
  END IF;

  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_capture` $$

CREATE PROCEDURE `cast_capture`(g_id INT,  p_num INT,  player_deck_id INT,  b_x INT,  b_y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_building_id INT;
  DECLARE log_msg_code VARCHAR(50) CHARSET utf8 DEFAULT 'building_captured';

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_capture');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    SELECT b.ref INTO board_building_id FROM board b WHERE b.game_id=g_id AND b.`type`='building' AND b.x=b_x AND b.y=b_y LIMIT 1;
    IF board_building_id IS NULL THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='building_not_selected';
    ELSE
        CALL user_action_begin(g_id, p_num);
        CALL play_card_actions(g_id,p_num,player_deck_id); 

        IF p_num = (SELECT bb.player_num FROM board_buildings bb WHERE bb.id = board_building_id) THEN
          SET log_msg_code = 'building_captured_own';
        END IF;

        CALL cmd_log_add_message(g_id, p_num, log_msg_code, CONCAT_WS(';', log_building(board_building_id), log_player(g_id, p_num)));

        UPDATE board_buildings SET player_num=p_num WHERE id=board_building_id;

        IF(building_feature_check(board_building_id,'ally') = 1)THEN
          CALL building_feature_set(board_building_id,'summon_team',get_player_team(g_id, p_num));
        END IF;

        CALL count_income(board_building_id);
        CALL cmd_building_set_owner(g_id,p_num,board_building_id);

        IF building_feature_check(board_building_id, 'paralysing') THEN
          CALL buidling_paralyse_enemies(board_building_id);
        END IF;

        CALL finish_playing_card(g_id,p_num);
        CALL end_cards_phase(g_id,p_num);
        CALL user_action_end(g_id, p_num);
    END IF;
  END IF;

  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_relocation` $$

CREATE PROCEDURE `cast_relocation`(g_id INT,  p_num INT,  player_deck_id INT,  b_x INT,  b_y INT,  x INT,  y INT,  rot INT,  flp INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_building_id INT;
  DECLARE log_msg_code VARCHAR(50) CHARSET utf8 DEFAULT 'building_moved';

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

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

          IF building_feature_check(board_building_id, 'paralysing') THEN
            CALL buidling_paralyse_enemies(board_building_id);
          END IF;

          CALL finish_playing_card(g_id,p_num);
          CALL end_cards_phase(g_id,p_num);
          CALL user_action_end(g_id, p_num);
        END IF;
      END IF;
    END IF;
  END IF;

  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_zone_express_out` $$

CREATE PROCEDURE `cast_zone_express_out`(g_id INT, p_num INT, player_deck_id INT, zone INT)
BEGIN
  DECLARE err_code INT;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

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

  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_zone_express_into` $$

CREATE PROCEDURE `cast_zone_express_into`(g_id INT, p_num INT, player_deck_id INT, zone INT)
BEGIN
  DECLARE err_code INT;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

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

  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_forest` $$

CREATE PROCEDURE `cast_forest`(g_id INT, p_num INT, player_deck_id INT, x INT, y INT)
BEGIN
  DECLARE neutral_p_num INT DEFAULT 9;
  DECLARE err_code INT;
  DECLARE forest_range INT DEFAULT 2;
  DECLARE tree_building_id INT;
  DECLARE tree_x, tree_y INT;
  DECLARE new_bb_id INT;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_forest');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT is_valid_cell(g_id, x, y) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='invalid_coord';
    ELSE
      CALL user_action_begin(g_id, p_num);
      CALL play_card_actions(g_id,p_num,player_deck_id); 

      SELECT b.id INTO tree_building_id FROM vw_mode_buildings b
        WHERE b.mode_id = get_game_mode(g_id) AND b.ui_code = 'tree';

      SET tree_x = x - forest_range;
      WHILE tree_x <= x + forest_range DO
        SET tree_y = y - forest_range;
        WHILE tree_y <= y + forest_range DO
          IF is_valid_cell(g_id, tree_x, tree_y) THEN
            CALL create_new_building(g_id, neutral_p_num, tree_building_id, NULL, tree_x, tree_y, 0, 0);
            SET new_bb_id = @new_board_building_id;
            IF new_bb_id > 0 THEN
              CALL cmd_put_building_by_id(g_id, neutral_p_num, new_bb_id);
            END IF;
          END IF;
          SET tree_y = tree_y + 1;
        END WHILE;
        SET tree_x = tree_x + 1;
      END WHILE;

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);
      CALL user_action_end(g_id, p_num);
    END IF;
  END IF;


  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_bandit` $$

CREATE PROCEDURE `cast_bandit`(g_id INT, p_num INT, player_deck_id INT, x INT, y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE mode_id INT;
  DECLARE bandit_ui_code VARCHAR(45) CHARSET utf8 DEFAULT 'bandit';
  DECLARE bandit_u_id INT;
  DECLARE bandit_owner INT DEFAULT 4;
  DECLARE new_player INT;
  DECLARE bandit_name VARCHAR(45) CHARSET utf8;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_bandit');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF (quart(x,y)<>p_num) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'card_unit_not_in_own_zone';
    ELSE
      IF EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y LIMIT 1) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'spawn_point_occupued';
      ELSE

        CALL user_action_begin(g_id, p_num);

        CALL play_card_actions(g_id,p_num,player_deck_id); 

        SELECT vu.id INTO bandit_u_id FROM vw_mode_units vu WHERE vu.mode_id = mode_id AND vu.ui_code = bandit_ui_code;
        SET bandit_name = CONCAT('{', bandit_u_id, '}');
        CALL create_new_player(g_id, bandit_name, NULL, bandit_owner, get_player_language_id(g_id, p_num));
        SET new_player = @new_player_num;

        CALL create_new_unit(g_id, new_player, bandit_u_id, NULL, x, y, 1);
        CALL unit_feature_set(@new_board_unit_id, 'initial_team', get_player_team(g_id, new_player));

        CALL finish_playing_card(g_id,p_num);
        CALL end_cards_phase(g_id,p_num);

        CALL user_action_end(g_id, p_num);
      END IF;
    END IF;
  END IF;


  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;
use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_flight` $$

CREATE PROCEDURE `cast_flight`(g_id INT, p_num INT, player_deck_id INT, x INT, y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_flight');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      CALL user_action_begin(g_id, p_num);

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;

      IF (unit_feature_check(board_unit_id,'magic_immunity')=0) THEN 
        CALL unit_feature_set(board_unit_id,'flying', null);
        CALL cmd_unit_add_effect(g_id,board_unit_id,'flying');
      ELSE
        CALL cmd_magic_resistance_log(g_id,p_num,board_unit_id);
      END IF;

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end(g_id, p_num);
    END IF;
  END IF;


  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;

use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`unit_level_up` $$

CREATE PROCEDURE `unit_level_up`(g_id INT, p_num INT, x INT, y INT, stat VARCHAR(10))
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE level_up_bonus INT DEFAULT 1;
  DECLARE log_msg_code_part VARCHAR(50) CHARSET utf8 DEFAULT 'unit_levelup_';
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'unit_level_up_$stat($x,$y)';

  SELECT GET_LOCK(get_game_lock_name(g_id), 10) INTO @tmp;

  SET err_code = check_unit_can_do_action(g_id, p_num, x, y, '_applcable_for_any_unit_');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;
    IF check_unit_can_level_up(board_unit_id) = 0 THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='unit_cannot_levelup';
    ELSE
      CALL unit_action_begin(g_id, p_num);

      UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
      CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

      UPDATE board_units bu SET level = level + 1 WHERE bu.id=board_unit_id;
            
      CASE stat
        WHEN 'attack' THEN
        BEGIN
          UPDATE board_units bu SET attack = attack + level_up_bonus WHERE bu.id=board_unit_id;
        END;
        WHEN 'moves' THEN
        BEGIN
          UPDATE board_units bu SET moves = moves + level_up_bonus WHERE bu.id=board_unit_id;
        END;
        WHEN 'health' THEN
        BEGIN
          UPDATE board_units bu SET health = health + level_up_bonus, max_health = max_health + level_up_bonus WHERE bu.id=board_unit_id;
        END;
      END CASE;
            
      CALL cmd_log_add_message(g_id, p_num, CONCAT(log_msg_code_part, stat), CONCAT_WS(';', log_unit(board_unit_id), level_up_bonus));
            
      SET cmd=REPLACE(cmd,'$stat',stat);
      SET cmd=REPLACE(cmd,'$x',x);
      SET cmd=REPLACE(cmd,'$y',y);
      INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);
            
      CALL unit_action_end(g_id, p_num);
    END IF;
  END IF;

  SELECT RELEASE_LOCK(get_game_lock_name(g_id)) INTO @tmp;

END$$

DELIMITER ;

