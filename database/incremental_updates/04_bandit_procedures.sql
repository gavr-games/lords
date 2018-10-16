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

END$$

DROP PROCEDURE IF EXISTS `lords`.`send_money` $$

CREATE PROCEDURE `send_money`(g_id INT,    p_num INT,    p2_num INT,    amount_input_str VARCHAR(100) CHARSET utf8)
BEGIN
  DECLARE amount INT;

  DECLARE conversion_error INT DEFAULT 0;
  DECLARE bandit_bu_id INT;
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
END$$

DROP PROCEDURE IF EXISTS `lords`.`cmd_unit_phrase` $$

CREATE PROCEDURE `cmd_unit_phrase`(board_unit_id INT, code VARCHAR(45))
BEGIN
  DECLARE g_id, p_num INT;
  DECLARE random_row INT;
  DECLARE phrase_id INT;
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'show_unit_message($board_unit_id,$phrase_id)';

  SELECT game_id, player_num INTO g_id, p_num FROM board_units WHERE id = board_unit_id LIMIT 1;

  CREATE TEMPORARY TABLE tmp_unit_phrases (id_rand INT AUTO_INCREMENT PRIMARY KEY) AUTO_INCREMENT=1
    SELECT
      d.id
    FROM dic_unit_phrases d
    WHERE d.code = code AND d.language_id = get_player_language_id(g_id, p_num);

  IF (SELECT COUNT(*) FROM tmp_unit_phrases) > 0 THEN
    SET random_row = get_random_int_between(1, (SELECT MAX(id_rand) FROM tmp_unit_phrases));
    SELECT t.id INTO phrase_id FROM tmp_unit_phrases t WHERE t.id_rand=random_row LIMIT 1;
    DROP TEMPORARY TABLE tmp_unit_phrases;

    SET cmd=REPLACE(cmd,'$board_unit_id', board_unit_id);
    SET cmd=REPLACE(cmd,'$phrase_id', phrase_id);

    INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`bandit_get_money` $$

CREATE PROCEDURE `bandit_get_money`(bandit_bu_id INT, sender_p_num INT, amount INT)
BEGIN
  DECLARE g_id INT;
  DECLARE bandit_p_num INT;
  DECLARE got_from_p0, got_from_p1, got_from_p2, got_from_p3 INT;
  DECLARE cur_max INT;
  DECLARE cur_team INT;
  DECLARE cur_player INT;

  SELECT game_id, player_num INTO g_id, bandit_p_num FROM board_units WHERE id = bandit_bu_id;

  CREATE TEMPORARY TABLE tmp_got (p_num INT, team INT, amt INT);
  INSERT INTO tmp_got(p_num, team, amt) VALUES
    (0, get_player_team(g_id, 0), unit_feature_get_param(bandit_bu_id, 'bandit_got_from_player0')),
    (1, get_player_team(g_id, 1), unit_feature_get_param(bandit_bu_id, 'bandit_got_from_player1')),
    (2, get_player_team(g_id, 2), unit_feature_get_param(bandit_bu_id, 'bandit_got_from_player2')),
    (3, get_player_team(g_id, 3), unit_feature_get_param(bandit_bu_id, 'bandit_got_from_player3'));

  CREATE TEMPORARY TABLE tmp_got_from_teams
    SELECT team, SUM(amt) as amt FROM tmp_got WHERE team IS NOT NULL GROUP BY team;

  SELECT MAX(amt) INTO cur_max FROM tmp_got_from_teams;
  SELECT amt + amount INTO cur_team FROM tmp_got_from_teams WHERE team = get_player_team(g_id, sender_p_num);
  SELECT amt + amount INTO cur_player FROM tmp_got WHERE p_num = sender_p_num;
  CALL unit_feature_set(bandit_bu_id, CONCAT('bandit_got_from_player',sender_p_num), cur_player);

  IF get_player_team(g_id, sender_p_num) <> get_unit_team(bandit_bu_id) THEN
    IF cur_team > cur_max THEN
      UPDATE players SET team = get_player_team(g_id, sender_p_num) WHERE game_id = g_id AND player_num = bandit_p_num;
      CALL cmd_log_add_independent_message(g_id, bandit_p_num, 'bandit_fights_for_player', CONCAT_WS(';', log_unit(bandit_bu_id), log_player(g_id, sender_p_num)));
      CALL cmd_unit_phrase(bandit_bu_id, 'bandit_thanks');
    ELSE
      CALL cmd_unit_phrase(bandit_bu_id, 'bandit_not_enough');
    END IF;
  ELSE
    CALL cmd_unit_phrase(bandit_bu_id, 'bandit_thanks');
  END IF;

  DROP TEMPORARY TABLE tmp_got;
  DROP TEMPORARY TABLE tmp_got_from_teams;

END$$


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

END$$

DROP PROCEDURE IF EXISTS `lords`.`end_turn` $$

CREATE PROCEDURE `end_turn`(g_id INT,   p_num INT)
BEGIN
  DECLARE board_unit_id INT;
  DECLARE p_num2 INT;
  DECLARE move_order_p1 INT;
  DECLARE move_order_p2 INT;
  DECLARE owner_p1 INT;
  DECLARE owner_p2 INT;
  DECLARE last_turn INT;
  DECLARE turn,new_turn INT;
  DECLARE mode_id INT;

  DECLARE nonfinished_action INT;

  DECLARE board_building_id INT;


  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id AND bu.player_num=p_num;

  DECLARE cur_building_features CURSOR FOR
    SELECT bb.id FROM board_buildings bb WHERE bb.game_id=g_id AND bb.player_num=p_num2 AND check_building_deactivated(bb.id)=0;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    SELECT a.turn,a.nonfinished_action_id INTO turn,nonfinished_action FROM active_players a WHERE a.game_id=g_id LIMIT 1;
    SELECT p.owner, p.move_order INTO owner_p1, move_order_p1 FROM players p WHERE p.game_id=g_id AND p.player_num=p_num LIMIT 1;

    IF(nonfinished_action<>0)THEN
      CALL finish_nonfinished_action(g_id,p_num,nonfinished_action);
    END IF;

    IF move_order_p1 = (SELECT MAX(move_order) FROM players WHERE game_id=g_id) THEN
      SET new_turn=turn+1;
      SELECT MIN(move_order) INTO move_order_p2 FROM players WHERE game_id=g_id;
    ELSE
      SET new_turn=turn;
      SELECT MIN(move_order) INTO move_order_p2 FROM players WHERE game_id=g_id AND move_order > move_order_p1;
    END IF;

    SELECT player_num INTO p_num2 FROM players WHERE game_id = g_id AND move_order = move_order_p2 LIMIT 1;

    UPDATE active_players SET turn=new_turn, player_num=p_num2, subsidy_flag=0, units_moves_flag=0, card_played_flag=0, nonfinished_action_id=0, last_end_turn=CURRENT_TIMESTAMP, current_procedure='end_turn' WHERE game_id=g_id;

    SELECT UNIX_TIMESTAMP(a.last_end_turn) INTO last_turn FROM active_players a WHERE a.game_id=g_id;

    CALL cmd_set_active_player(g_id,p_num2,last_turn,new_turn);

    OPEN cur;
    REPEAT
      FETCH cur INTO board_unit_id;
      IF NOT done THEN
        IF (SELECT bu.moves_left < ABS(bu.moves) FROM board_units bu WHERE bu.id = board_unit_id) THEN
          UPDATE board_units SET moves_left=moves WHERE id=board_unit_id;
          CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);
        END IF;
        IF owner_p1 <> 1 AND unit_feature_check(board_unit_id, 'bandit') THEN
          CALL bandit_end_turn(board_unit_id);
        END IF;
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur;

  SELECT p.owner INTO owner_p2 FROM players p WHERE p.game_id=g_id AND p.player_num=p_num2 LIMIT 1;

  IF owner_p2=1 THEN 
  BEGIN
    DECLARE cmd_log_close_container VARCHAR(1000) CHARSET utf8 DEFAULT 'log_close_container()';


    DECLARE income INT;
    DECLARE u_income INT;


    IF (owner_p1 NOT IN(0,1)) THEN
      INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log_close_container);
    END IF;


    SELECT IFNULL(SUM(bb.income),0) INTO income FROM board_buildings bb WHERE bb.game_id=g_id AND bb.player_num=p_num2 AND bb.income<>0 AND check_building_deactivated(bb.id)=0;

    SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
    SELECT cfg.`value` INTO u_income FROM mode_config cfg WHERE cfg.param='unit income' AND cfg.mode_id=mode_id;
    SET income=income+(SELECT IFNULL((COUNT(*))*u_income,0) FROM board b JOIN board_units bu ON (b.ref=bu.id) WHERE b.game_id=g_id AND b.`type`='unit' AND bu.player_num=p_num2 AND quart(b.x,b.y)<>p_num2);

    IF income>0 THEN
      UPDATE players SET gold=gold+income WHERE game_id=g_id AND player_num=p_num2;
      CALL cmd_player_set_gold(g_id,p_num2);
    END IF;

    SET done=0;

    OPEN cur_building_features;
    REPEAT
      FETCH cur_building_features INTO board_building_id;
      IF NOT done THEN

        IF(building_feature_check(board_building_id,'healing'))=1 THEN
          CALL healing_tower_heal(g_id,board_building_id);
        END IF;

        IF(building_feature_check(board_building_id,'frog_factory'))=1 THEN
          CALL lake_summon_frogs(g_id,board_building_id);
        END IF;

        IF(building_feature_check(board_building_id,'troll_factory'))=1 THEN
          CALL mountains_summon_troll(g_id,board_building_id);
        END IF;

        IF(building_feature_check(board_building_id,'coin_factory'))=1 THEN
          CALL coin_factory_income(g_id,board_building_id);
        END IF;

        IF(building_feature_check(board_building_id,'barracks'))=1 THEN
          CALL barracks_summon(g_id,board_building_id);
        END IF;

      END IF;
    UNTIL done END REPEAT;
    CLOSE cur_building_features;

  END;
  ELSE

  BEGIN
    IF (owner_p1 = 1 AND owner_p2 NOT IN(0,1)) THEN
      CALL cmd_log_add_container(g_id, p_num2, 'npc_turn', NULL);
    END IF;
  END;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`bandit_end_turn` $$

CREATE PROCEDURE `bandit_end_turn`(bandit_bu_id INT)
BEGIN
  DECLARE g_id INT;
  DECLARE bandit_p_num INT;
  DECLARE bandit_gold INT;
  DECLARE spent INT;

  SELECT game_id, player_num INTO g_id, bandit_p_num FROM board_units WHERE id = bandit_bu_id;

  SELECT gold INTO bandit_gold FROM players WHERE game_id = g_id AND player_num = bandit_p_num;

  IF bandit_gold > 0 THEN
    SET spent = get_random_int_between(1, LEAST(bandit_gold, 20));
    UPDATE players SET gold = gold - spent WHERE game_id = g_id AND player_num = bandit_p_num;
    CALL cmd_player_set_gold(g_id, bandit_p_num);
    CALL cmd_log_add_message(g_id, bandit_p_num, 'bandit_spends', CONCAT_WS(';', log_unit(bandit_bu_id), spent));
  END IF;

  IF unit_feature_get_param(bandit_bu_id, 'initial_team') <> get_player_team(g_id, bandit_p_num) THEN
    UPDATE players SET team = unit_feature_get_param(bandit_bu_id, 'initial_team') WHERE game_id = g_id AND player_num = bandit_p_num;
    CALL cmd_log_add_message(g_id, bandit_p_num, 'bandit_fights_for_himself', log_unit(bandit_bu_id));
    CALL unit_feature_set(bandit_bu_id, 'bandit_got_from_player0', 0);
    CALL unit_feature_set(bandit_bu_id, 'bandit_got_from_player1', 0);
    CALL unit_feature_set(bandit_bu_id, 'bandit_got_from_player2', 0);
    CALL unit_feature_set(bandit_bu_id, 'bandit_got_from_player3', 0);
  END IF;

END$$


DROP PROCEDURE IF EXISTS `lords`.`create_new_player` $$

CREATE PROCEDURE `create_new_player`(g_id INT, name VARCHAR(200) CHARSET utf8, team INT, owner INT, language_id INT)
BEGIN
  DECLARE p_num INT;
  DECLARE new_move_order INT;

  IF team IS NULL THEN
    SET team = get_new_team_number(g_id);
  END IF;

  SELECT CASE WHEN MAX(p.player_num) < 10 THEN 10 ELSE MAX(p.player_num) + 1 END INTO p_num
    FROM players p WHERE p.game_id=g_id;
  SET new_move_order = get_move_order_for_new_npc(g_id, get_current_p_num(g_id));

  UPDATE players SET move_order = move_order + 1 WHERE game_id = g_id AND move_order >= new_move_order;
  
  INSERT INTO players(game_id, player_num, name, gold, owner, team, move_order, language_id)
    VALUES(g_id, p_num, name, 0, owner, team, new_move_order, language_id);

  CALL cmd_add_player(g_id, p_num);
  SET @new_player_num = p_num;
  
END$$

