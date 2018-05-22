use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`barracks_summon` $$

CREATE PROCEDURE `barracks_summon`(g_id INT,  board_building_id INT)
BEGIN
  DECLARE cops_count INT;
  DECLARE dice INT;

  SELECT COUNT(*) INTO cops_count FROM board_units bu WHERE bu.game_id=g_id AND unit_feature_check(bu.id,'parent_building')=1 AND unit_feature_get_param(bu.id,'parent_building')=board_building_id;
  SET dice = POW(6,CASE WHEN cops_count IN(0,1,2,3) THEN 1 ELSE cops_count-2 END);
  IF (get_random_int_between(1, dice) = 1) THEN
    CALL summon_one_creature_by_config(board_building_id);
  END IF;
END$$

DROP PROCEDURE IF EXISTS `lords`.`calculate_attack_damage` $$

CREATE PROCEDURE `calculate_attack_damage`(board_unit_id INT, aim_type VARCHAR(45), aim_board_id INT,  OUT attack_success INT,  OUT damage INT,  OUT critical INT)
BEGIN
  DECLARE g_mode INT;
  DECLARE u_id,aim_object_id INT;
  DECLARE base_damage,damage_bonus,critical_bonus INT;
  DECLARE dice_max,chance,critical_chance,dice INT;

  SELECT bu.attack,bu.unit_id,g.mode_id INTO base_damage,u_id,g_mode FROM board_units bu JOIN games g ON (bu.game_id=g.id) WHERE bu.id=board_unit_id LIMIT 1;

  CASE
    WHEN aim_type='unit' THEN SELECT bu.unit_id INTO aim_object_id FROM board_units bu WHERE bu.id=aim_board_id LIMIT 1;
    WHEN aim_type='building' OR aim_type='castle' THEN SELECT bb.building_id INTO aim_object_id FROM board_buildings bb WHERE bb.id=aim_board_id LIMIT 1;
  END CASE;


  SELECT ab.dice_max,ab.chance,ab.critical_chance,ab.damage_bonus,ab.critical_bonus
    INTO dice_max,chance,critical_chance,damage_bonus,critical_bonus
    FROM attack_bonus ab
    WHERE ab.mode_id=g_mode
      AND (ab.unit_id=u_id OR ab.unit_id IS NULL)
      AND (ab.aim_type=aim_type OR ab.aim_type IS NULL)
      AND (ab.aim_id=aim_object_id OR ab.aim_id IS NULL)
    ORDER BY ab.priority DESC
    LIMIT 1;

  SELECT get_random_int_between(1, dice_max) INTO dice FROM DUAL;

  IF dice>=critical_chance THEN 
    SET attack_success=1;
    SET critical=1;
    SET damage=CASE WHEN base_damage+critical_bonus>0 THEN base_damage+critical_bonus ELSE 0 END;
  ELSE
    IF dice>=chance THEN 
      SET attack_success=1;
      SET critical=0;
      SET damage=CASE WHEN base_damage+damage_bonus>0 THEN base_damage+damage_bonus ELSE 0 END;
    ELSE 
      SET attack_success=0;
      SET critical=0;
      SET damage=0;
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`cast_armageddon` $$

CREATE PROCEDURE `cast_armageddon`(g_id INT,  p_num INT,  player_deck_id INT)
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

    CALL user_action_end();
  END IF;
END$$

DROP PROCEDURE IF EXISTS `lords`.`cast_eagerness` $$

CREATE PROCEDURE `cast_eagerness`(g_id INT,  p_num INT,  player_deck_id INT,  x INT,  y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE attack_bonus INT DEFAULT 2;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_eagerness');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;

      IF (unit_feature_check(board_unit_id,'magic_immunity')=0) THEN 
        IF get_random_int_between(1, 6) <= 3 THEN
          CALL unit_add_attack(board_unit_id, attack_bonus * get_magic_field_factor_at(g_id, x, y));
        ELSE
          UPDATE board_units SET moves=1,moves_left=1 WHERE id=board_unit_id;
          CALL unit_feature_set(board_unit_id,'knight',null);
          CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);
          CALL cmd_unit_add_effect(g_id,board_unit_id,'knight');
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

DROP PROCEDURE IF EXISTS `lords`.`cast_fireball` $$

CREATE PROCEDURE `cast_fireball`(g_id INT, p_num INT, player_deck_id INT, x INT, y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE fb_damage INT DEFAULT 1;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_fireball');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      IF get_random_int_between(1, 6) < 3 THEN
        CALL cmd_miss_game_log(g_id,x,y);
      ELSE
        CALL magical_damage(g_id,p_num,x,y,fb_damage);
      END IF;

      INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'magical_attack');

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`cast_lightening_max` $$

CREATE PROCEDURE `cast_lightening_max`(g_id INT, p_num INT, player_deck_id INT, x INT, y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE li_damage INT DEFAULT 3;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_lightening_max');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      IF get_random_int_between(1, 6) < 4 THEN
        CALL cmd_miss_game_log(g_id,x,y);
      ELSE
        CALL magical_damage(g_id,p_num,x,y,li_damage);
      END IF;

      INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'magical_attack');

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`cast_lightening_min` $$

CREATE PROCEDURE `cast_lightening_min`(g_id INT, p_num INT, player_deck_id INT, x INT, y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE li_damage INT DEFAULT 2;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_lightening_min');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      IF get_random_int_between(1, 6) < 3 THEN
        CALL cmd_miss_game_log(g_id,x,y);
      ELSE
        CALL magical_damage(g_id,p_num,x,y,li_damage);
      END IF;

      INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'magical_attack');

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`cast_mind_control` $$

CREATE PROCEDURE `cast_mind_control`(g_id INT,   p_num INT,   player_deck_id INT,   x INT,   y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE p2_num INT;
  DECLARE shield INT;
  DECLARE npc_gold INT;
  DECLARE log_msg_code VARCHAR(50) CHARSET utf8 DEFAULT 'mind_control';

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_mind_control');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;
      SELECT bu.player_num INTO p2_num FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;
      SELECT bu.shield INTO shield FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

      IF (unit_feature_check(board_unit_id,'magic_immunity')=0) THEN

        IF shield>0 THEN
          CALL shield_off(board_unit_id);
        ELSE

          IF get_random_int_between(1, 6) <= 3 THEN 
            CALL make_mad(board_unit_id);
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

DROP PROCEDURE IF EXISTS `lords`.`cast_o_d` $$

CREATE PROCEDURE `cast_o_d`(g_id INT,  p_num INT,  player_deck_id INT,  x INT,  y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE shield INT;

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

      CALL user_action_end();
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`cast_polza_main` $$

CREATE PROCEDURE `cast_polza_main`(g_id INT,   p_num INT,   player_deck_id INT)
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

    CALL user_action_end();
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`cast_russian_ruletka` $$

CREATE PROCEDURE `cast_russian_ruletka`(g_id INT,   p_num INT,   player_deck_id INT,   x INT,   y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_russian_ruletka');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      SELECT ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;

      IF get_random_int_between(1, 6) < 6 THEN
        CALL cmd_log_add_message(g_id, p_num, 'miss_rus_rul', log_unit(board_unit_id));
      ELSE
        CALL magic_kill_unit(board_unit_id,p_num);
      END IF;

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`cast_telekinesis` $$

CREATE PROCEDURE `cast_telekinesis`(g_id INT,  p_num INT,  player_deck_id INT,  p2_num INT)
BEGIN
  DECLARE err_code INT;
  DECLARE rand_card INT;
  DECLARE big_dice INT;
  DECLARE stolen_card_id INT;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_telekinesis');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT id FROM players WHERE game_id=g_id AND player_num=p2_num) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=13;
    ELSE
      IF NOT EXISTS(SELECT id FROM player_deck WHERE game_id=g_id AND player_num=p2_num LIMIT 1) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=22;
      ELSE
        CALL user_action_begin();

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

        CALL user_action_end();
      END IF;
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`cast_unit_upgrade_random` $$

CREATE PROCEDURE `cast_unit_upgrade_random`(g_id INT,  p_num INT,  player_deck_id INT,  x INT,  y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE dice INT;
  DECLARE speed_bonus INT DEFAULT 3;
  DECLARE health_bonus INT DEFAULT 3;
  DECLARE attack_bonus INT DEFAULT 3;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_unit_upgrade_random');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;

      IF (unit_feature_check(board_unit_id,'magic_immunity')=0) THEN 
        SET dice = get_random_int_between(1, 3);
        IF dice=1 THEN
          CALL unit_add_moves(board_unit_id, speed_bonus * get_magic_field_factor_at(g_id, x, y));
        END IF;
        IF dice=2 THEN
          CALL unit_add_health(board_unit_id, health_bonus * get_magic_field_factor_at(g_id, x, y));
        END IF;
        IF dice=3 THEN
          CALL unit_add_attack(board_unit_id, attack_bonus * get_magic_field_factor_at(g_id, x, y));
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

DROP PROCEDURE IF EXISTS `lords`.`cast_vred_main` $$

CREATE PROCEDURE `cast_vred_main`(g_id INT,   p_num INT,   player_deck_id INT)
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

    CALL user_action_end();
  END IF;


END$$

DROP PROCEDURE IF EXISTS `lords`.`drink_health` $$

CREATE PROCEDURE `drink_health`(board_unit_id INT)
BEGIN
  DECLARE dice_max INT DEFAULT 2;
  DECLARE chance INT DEFAULT 1;
  DECLARE drink_health_amt INT DEFAULT 1;
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE health,max_health INT;

  IF get_random_int_between(1, dice_max) > chance THEN 
    SELECT bu.game_id,bu.player_num,bu.health,bu.max_health INTO g_id,p_num,health,max_health FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

    IF(health+drink_health_amt>max_health)THEN
      UPDATE board_units SET max_health=health+drink_health_amt, health=health+drink_health_amt WHERE id=board_unit_id;
      CALL cmd_unit_set_max_health(g_id,p_num,board_unit_id);
      CALL cmd_unit_set_health(g_id,p_num,board_unit_id);
    ELSE 
      UPDATE board_units SET health=health+drink_health_amt WHERE id=board_unit_id;
      CALL cmd_unit_set_health(g_id,p_num,board_unit_id);
    END IF;

    CALL cmd_log_add_message(g_id, p_num, 'unit_drinks_health', CONCAT_WS(';', log_unit(board_unit_id), drink_health_amt));

  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`move_building_randomly` $$

CREATE PROCEDURE `move_building_randomly`(board_building_id INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE x_len,y_len INT;
  DECLARE shape VARCHAR(400);
  DECLARE rotation INT DEFAULT 0;
  DECLARE flip INT DEFAULT 0;
  DECLARE x,y,b_x,b_y INT;

  SELECT b.x_len, b.y_len, b.shape, bb.game_id, bb.player_num INTO x_len, y_len, shape, g_id, p_num FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.id=board_building_id LIMIT 1;

  SELECT b.x,b.y INTO b_x,b_y FROM board b WHERE b.game_id=g_id AND b.`type` IN ('building','obstacle') AND b.ref=board_building_id LIMIT 1;

  UPDATE board SET ref=0 WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=board_building_id;

  WHILE NOT EXISTS (SELECT id FROM board WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=board_building_id LIMIT 1) DO
    IF shape='1' THEN
      SET x = get_random_int_between(0, 19);
      SET y = get_random_int_between(0, 19);
    ELSE
      SET rotation = get_random_int_between(0, 3);
      SET flip = get_random_int_between(0, 1);

      SET x = get_random_int_between(0, (20 - CASE WHEN rotation IN(0,2) THEN x_len ELSE y_len END));
      SET x = get_random_int_between(0, (20 - CASE WHEN rotation IN(0,2) THEN y_len ELSE x_len END));
    END IF;

    CALL place_building_on_board(board_building_id,x,y,rotation,flip);
  END WHILE;

  DELETE FROM board WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0; 
  UPDATE board_buildings bb SET bb.rotation=rotation,bb.flip=flip WHERE bb.id=board_building_id;

  CALL count_income(board_building_id);
  CALL cmd_move_building(g_id,p_num,b_x,b_y,board_building_id);

END$$

DROP FUNCTION IF EXISTS `lords`.`get_random_others_moveable_building_or_obstacle` $$

CREATE FUNCTION `get_random_others_moveable_building_or_obstacle`(g_id INT, p_num INT) RETURNS INT
BEGIN
  DECLARE big_dice INT;
  DECLARE rand_building_id INT;

  CREATE TEMPORARY TABLE tmp_buildings (id_rand INT AUTO_INCREMENT PRIMARY KEY)AUTO_INCREMENT=1
    SELECT DISTINCT b.ref AS `board_building_id`
    FROM board b
    JOIN board_buildings bb ON (b.ref=bb.id)
    WHERE b.game_id=g_id AND b.`type` IN ('building','obstacle') AND bb.player_num<>p_num AND building_feature_check(bb.id,'not_movable')=0;
  IF (SELECT COUNT(*) FROM tmp_buildings) = 0 THEN
    RETURN NULL;
  ELSE
    SET big_dice = get_random_int_between(1, (SELECT MAX(id_rand) FROM tmp_buildings));
    SELECT `board_building_id` INTO rand_building_id FROM tmp_buildings WHERE id_rand=big_dice LIMIT 1;
    DROP TEMPORARY TABLE tmp_buildings;
    RETURN rand_building_id;
  END IF;
END$$

DROP PROCEDURE IF EXISTS `lords`.`finish_nonfinished_action` $$

CREATE PROCEDURE `finish_nonfinished_action`(g_id INT,   p_num INT,   nonfinished_action INT)
BEGIN
  DECLARE mode_id INT;

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;

  CASE nonfinished_action

    WHEN 1 THEN 
    BEGIN
      DECLARE big_dice INT;
      DECLARE x_appear,y_appear INT;
      DECLARE max_size INT;
      DECLARE random_grave INT;
      DECLARE random_dead_card INT;

      SELECT ap.x,ap.y INTO x_appear,y_appear FROM appear_points ap WHERE ap.mode_id=mode_id AND ap.player_num=p_num;
      
      SELECT IFNULL(MIN(GREATEST(ABS(b.x-18),ABS(b.y-18))),18) INTO max_size FROM board b
      WHERE b.x NOT IN(0,19) AND b.y NOT IN(0,19);
      
        CREATE TEMPORARY TABLE tmp_dead_units (id_rand INT AUTO_INCREMENT PRIMARY KEY)AUTO_INCREMENT=1
          SELECT g.grave_id AS `grave_id`,g.card_id AS `card_id`
          FROM vw_grave g
          WHERE g.game_id=g_id AND g.size<=max_size;
        SET big_dice = get_random_int_between(1, (SELECT MAX(id_rand) FROM tmp_dead_units));
        SELECT `grave_id`,`card_id` INTO random_grave,random_dead_card FROM tmp_dead_units WHERE id_rand=big_dice LIMIT 1;
        DROP TEMPORARY TABLE tmp_dead_units;

        CALL resurrect(g_id,p_num,random_grave);
        CALL cmd_resurrect_by_card_log(g_id,p_num,random_dead_card);
    END;

    WHEN 2 THEN 
    BEGIN
      DECLARE zone INT;

      SET zone = get_random_int_between(0, 3);

      CALL units_from_zone(g_id, p_num, zone);
    END;

    WHEN 3 THEN 
    BEGIN
      DECLARE rand_building_id INT;
      SET rand_building_id = get_random_others_moveable_building_or_obstacle(g_id, p_num);
      UPDATE board_buildings bb SET bb.player_num = p_num WHERE bb.id = rand_building_id;
      CALL cmd_building_set_owner(g_id,p_num,rand_building_id);
      CALL move_building_randomly(rand_building_id);
    END;

    WHEN 4 THEN 
    BEGIN
      DECLARE random_player INT;

      SELECT player_num INTO random_player FROM players WHERE game_id=g_id AND owner <> 0 ORDER BY RAND() LIMIT 1;
      CALL vred_pooring(g_id,random_player);
    END;

    WHEN 5 THEN 
    BEGIN
      DECLARE random_bu_id,u_id INT;
      DECLARE shield INT;

      SELECT bu.id,bu.unit_id,bu.shield INTO random_bu_id,u_id,shield FROM board_units bu WHERE bu.game_id=g_id ORDER BY RAND() LIMIT 1;

      CALL magic_kill_unit(random_bu_id,p_num);
    END;

    WHEN 6 THEN 
    BEGIN
      DECLARE random_bb_id,b_id INT;

      SELECT bb.id INTO random_bb_id FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.game_id=g_id AND b.`type`<>'castle' ORDER BY RAND() LIMIT 1;
      CALL destroy_building(random_bb_id,p_num);
    END;

    WHEN 7 THEN 
    BEGIN
      DECLARE rand_building_id INT;
      SET rand_building_id = get_random_others_moveable_building_or_obstacle(g_id, p_num);
      CALL move_building_randomly(rand_building_id);
    END;

  END CASE;

  UPDATE active_players SET nonfinished_action_id=0 WHERE game_id=g_id AND player_num=p_num;

  CALL finish_playing_card(g_id,p_num);

END$$


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

    IF EXISTS(SELECT 1 FROM dic_unit_phrases d WHERE d.unit_id=unit_id AND d.language_id = lang_id LIMIT 1)THEN
      CREATE TEMPORARY TABLE tmp_unit_phrases (id_rand INT AUTO_INCREMENT PRIMARY KEY)AUTO_INCREMENT=1
        SELECT
          d.id
        FROM dic_unit_phrases d
        WHERE d.unit_id=unit_id AND d.language_id = lang_id;

      SET random_row = get_random_int_between(1, (SELECT MAX(id_rand) FROM tmp_unit_phrases));
      SELECT t.id INTO phrase_id FROM tmp_unit_phrases t WHERE t.id_rand=random_row LIMIT 1;
      DROP TEMPORARY TABLE tmp_unit_phrases;

      SELECT board_unit_id,phrase_id FROM DUAL;

    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`lake_summon_frogs` $$

CREATE PROCEDURE `lake_summon_frogs`(g_id INT,  board_building_id INT)
BEGIN
  DECLARE frogs_count INT;
  DECLARE dice INT;

  IF EXISTS(SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id AND (unit_feature_check(bu.id,'parent_building')=0 OR unit_feature_get_param(bu.id,'parent_building')<>board_building_id) LIMIT 1) THEN
    SELECT COUNT(*) INTO frogs_count FROM board_units bu WHERE bu.game_id=g_id AND unit_feature_check(bu.id,'parent_building')=1 AND unit_feature_get_param(bu.id,'parent_building')=board_building_id;
    SET dice = POW(6,CASE WHEN frogs_count IN(0,1,2,3) THEN 1 ELSE frogs_count-2 END);
    IF get_random_int_between(1, dice) = 1 THEN
      CALL summon_one_creature_by_config(board_building_id);
    END IF;
  END IF;
END$$

use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`mountains_summon_troll` $$

CREATE PROCEDURE `mountains_summon_troll`(g_id INT,  board_building_id INT)
BEGIN
  DECLARE troll_count INT;
  DECLARE dice INT;

  IF EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.`type`='building' LIMIT 1) THEN
    SELECT COUNT(*) INTO troll_count FROM board_units bu WHERE bu.game_id=g_id AND unit_feature_check(bu.id,'parent_building')=1 AND unit_feature_get_param(bu.id,'parent_building')=board_building_id;
    SET dice = POW(6,troll_count+1);
    IF get_random_int_between(1, dice) = 1 THEN
      CALL summon_one_creature_by_config(board_building_id);
    END IF;
  END IF;

END$$

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`vampire_resurrect_by_card` $$

CREATE PROCEDURE `vampire_resurrect_by_card`(vamp_board_id INT,     grave_id INT)
BEGIN
  DECLARE dead_card_id INT;
  DECLARE dice_max INT DEFAULT 2;
  DECLARE chance INT DEFAULT 1;
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE team INT;
  DECLARE vamp_owner INT DEFAULT 4;
  DECLARE new_player INT;
  DECLARE new_unit_id INT;
  DECLARE new_move_order INT;
  DECLARE u_id INT;
  DECLARE vamp_name VARCHAR(45) CHARSET utf8 DEFAULT '{vampire} {$u_id}';

  IF get_random_int_between(1, dice_max) > chance THEN 
    SELECT bu.game_id,bu.player_num,p.team INTO g_id,p_num,team FROM board_units bu JOIN players p ON (bu.game_id=p.game_id AND bu.player_num=p.player_num) WHERE bu.id=vamp_board_id LIMIT 1;

    SELECT CASE WHEN MAX(p.player_num)<10 THEN 10 ELSE MAX(p.player_num)+1 END INTO new_player FROM players p WHERE p.game_id=g_id;

    SELECT g.card_id INTO dead_card_id FROM graves g WHERE id=grave_id;
    SELECT c.ref INTO u_id FROM cards c WHERE c.id=dead_card_id LIMIT 1;

    SET vamp_name=REPLACE(vamp_name,'$u_id', u_id);
    SET new_move_order = get_move_order_for_new_npc(g_id, p_num);

    UPDATE players SET move_order = move_order + 1 WHERE game_id = g_id AND move_order >= new_move_order;
    INSERT INTO players(game_id,player_num,name,gold,owner,team,move_order,language_id) VALUES(g_id,new_player,vamp_name,0,vamp_owner,team,new_move_order,get_player_language_id(g_id,p_num));

    INSERT INTO board_units(game_id,player_num,card_id) VALUES (g_id,new_player,dead_card_id);
    SET new_unit_id=@@last_insert_id;
    INSERT INTO board_units_features(board_unit_id,feature_id,param) SELECT new_unit_id,ufu.feature_id,ufu.param FROM unit_default_features ufu WHERE ufu.unit_id=u_id;

    INSERT INTO board(game_id,x,y,`type`,ref) SELECT g_id,gc.x,gc.y,'unit',new_unit_id FROM grave_cells gc WHERE gc.grave_id=grave_id;
    DELETE FROM graves WHERE game_id=g_id AND id=grave_id;

    CALL unit_feature_set(new_unit_id,'vamp',NULL);

    CALL cmd_add_player(g_id,new_player);
    CALL cmd_add_unit(g_id,new_player,new_unit_id);
    CALL cmd_remove_from_grave(g_id,p_num,grave_id);

    CALL cmd_log_add_message(g_id, p_num, 'unit_becomes_vampire', log_unit(new_unit_id));

  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`vampire_resurrect_by_u_id` $$

CREATE PROCEDURE `vampire_resurrect_by_u_id`(vamp_board_id INT,    u_id INT,    x INT,    y INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE dice_max INT DEFAULT 2;
  DECLARE chance INT DEFAULT 1;
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE team INT;
  DECLARE vamp_owner INT DEFAULT 4;
  DECLARE new_player INT;
  DECLARE new_unit_id INT;
  DECLARE new_move_order INT;
  DECLARE size INT;
  DECLARE vamp_name VARCHAR(45) CHARSET utf8 DEFAULT '{vampire} {$u_id}';

  IF get_random_int_between(1, dice_max) > chance THEN 
    SELECT bu.game_id,bu.player_num,p.team INTO g_id,p_num,team FROM board_units bu JOIN players p ON (bu.game_id=p.game_id AND bu.player_num=p.player_num) WHERE bu.id=vamp_board_id LIMIT 1;
    SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;

    SELECT CASE WHEN MAX(p.player_num)<10 THEN 10 ELSE MAX(p.player_num)+1 END INTO new_player FROM players p WHERE p.game_id=g_id;

    SET vamp_name=REPLACE(vamp_name,'$u_id', u_id);
    SET new_move_order = get_move_order_for_new_npc(g_id, p_num);

    UPDATE players SET move_order = move_order + 1 WHERE game_id = g_id AND move_order >= new_move_order;
    INSERT INTO players(game_id,player_num,name,gold,owner,team,move_order,language_id) VALUES(g_id,new_player,vamp_name,0,vamp_owner,team,new_move_order,get_player_language_id(g_id,p_num));

    INSERT INTO board_units(game_id,player_num,unit_id) VALUES(g_id,new_player,u_id);
    SET new_unit_id=@@last_insert_id;
    INSERT INTO board_units_features(board_unit_id,feature_id,param) SELECT new_unit_id,ufu.feature_id,ufu.param FROM unit_default_features ufu WHERE ufu.unit_id=u_id;

    SELECT u.size INTO size FROM units u WHERE u.id=u_id LIMIT 1;

    INSERT INTO board(game_id,x,y,`type`,ref) SELECT g_id,a.x,a.y,'unit',new_unit_id FROM allcoords a WHERE a.mode_id=mode_id AND a.x BETWEEN x AND x+size-1 AND a.y BETWEEN y AND y+size-1;

    CALL unit_feature_set(new_unit_id,'vamp',NULL);

    CALL cmd_add_player(g_id,new_player);
    CALL cmd_add_unit_by_id(g_id,new_player,new_unit_id);

    CALL cmd_log_add_message(g_id, p_num, 'unit_becomes_vampire', log_unit(new_unit_id));

  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`wizard_fireball` $$

CREATE PROCEDURE `wizard_fireball`(g_id INT,    p_num INT,    x INT,    y INT,     x2 INT,     y2 INT)
BEGIN
  DECLARE err_code INT;
  DECLARE aim_bu_id INT;
  DECLARE board_unit_id INT;
  DECLARE dice INT;
  DECLARE fb_damage INT DEFAULT 1;
  DECLARE health_before_hit,experience INT;

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

END$$

DROP PROCEDURE IF EXISTS `lords`.`player_move_unit` $$

CREATE PROCEDURE `player_move_unit`(g_id INT, p_num INT, x INT, y INT,  x2 INT,  y2 INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE size INT;
  DECLARE p_team INT;
  DECLARE moveable INT DEFAULT 0;
  DECLARE teleportable INT DEFAULT 0;
  DECLARE taran_unit_id INT;
  DECLARE taran_x,taran_y,taran_prev_x,taran_prev_y INT;
  DECLARE x0,y0 INT;

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'player_move_unit'); 
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
    SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;
    SELECT u.size INTO size FROM board_units bu JOIN units u ON (bu.unit_id=u.id) WHERE bu.id=board_unit_id LIMIT 1;

    SET moveable=check_one_step_from_unit(g_id,x,y,x2,y2);


    SELECT p.team INTO p_team FROM players p WHERE p.game_id=g_id AND p.player_num=p_num LIMIT 1;
    IF (moveable=0)AND(unit_feature_check(board_unit_id,'magic_immunity')=0) AND EXISTS
    (SELECT a.id FROM board_buildings bb,board b,allcoords a,players p
      WHERE bb.game_id=g_id AND building_feature_check(bb.id,'teleport')=1 AND check_building_deactivated(bb.id)=0
      AND p.game_id=g_id AND p.player_num=bb.player_num AND p.team=p_team
      AND b.`type`<>'unit' AND b.ref=bb.id
      AND a.mode_id=mode_id
      AND a.x BETWEEN b.x-bb.radius AND b.x+bb.radius AND a.y BETWEEN b.y-bb.radius AND b.y+bb.radius
      AND a.x BETWEEN x2 AND x2+size-1 AND a.y BETWEEN y2 AND y2+size-1 LIMIT 1)
    THEN
      SET teleportable=1;
    END IF;
    IF moveable=0 AND teleportable=0
    THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=19;
    ELSE
      IF EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x BETWEEN x2 AND x2+size-1 AND b.y BETWEEN y2 AND y2+size-1 AND NOT(b.`type`='unit' AND b.ref=board_unit_id) LIMIT 1) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=12;
      ELSE

                CALL unit_action_begin(g_id, p_num);

                IF (unit_feature_get_param(board_unit_id,'bind_target') IS NOT NULL) THEN
                  CALL unit_feature_remove(board_unit_id,'bind_target');
                END IF; 

                SELECT MIN(b.x),MIN(b.y) INTO x0,y0 FROM board b WHERE b.game_id=g_id AND b.ref=board_unit_id AND b.`type`='unit';

                CALL move_unit(board_unit_id,x2,y2);
                UPDATE board_units bu SET bu.moves_left=CASE WHEN teleportable=1 THEN 0 ELSE bu.moves_left-1 END WHERE bu.id=board_unit_id;
                CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);


                SELECT bu.id INTO taran_unit_id FROM board_units bu WHERE unit_feature_get_param(bu.id,'bind_target')=board_unit_id LIMIT 1;
                IF taran_unit_id IS NOT NULL THEN
                  IF teleportable=1 THEN
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

END$$

DROP PROCEDURE IF EXISTS `lords`.`unit_action_end` $$

CREATE PROCEDURE `unit_action_end`(g_id INT,  p_num INT)
BEGIN
  IF (check_all_units_moved(g_id,p_num) = 1)
    AND (SELECT player_num FROM active_players WHERE game_id=g_id)=p_num 
  THEN
    CALL finish_moving_units(g_id,p_num);
    CALL end_units_phase(g_id,p_num);
  END IF;

  CALL user_action_end();
END$$

DROP PROCEDURE IF EXISTS `lords`.`attack` $$

CREATE PROCEDURE `attack`(g_id INT, p_num INT, x INT, y INT,  x2 INT,  y2 INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE size INT;
  DECLARE aim_type VARCHAR(45);
  DECLARE aim_id INT;

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT DISTINCT b.`type`,b.ref FROM board b WHERE b.game_id=g_id AND b.`type`<>'obstacle' AND b.x BETWEEN x2 AND x2+size-1 AND b.y BETWEEN y2 AND y2+size-1 AND NOT(b.`type`='unit' AND b.ref=board_unit_id);
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

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
                    END IF;
                  UNTIL done END REPEAT;
                  CLOSE cur;
                END IF;

                CALL unit_action_end(g_id, p_num);
      END IF;
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`taran_bind` $$

CREATE PROCEDURE `taran_bind`(g_id INT,  p_num INT,  x INT,  y INT,   x2 INT,   y2 INT)
BEGIN
  DECLARE err_code INT;
  DECLARE aim_bu_id INT;
  DECLARE board_unit_id INT;

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'taran_bind'); 
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF check_one_step_from_unit(g_id,x,y,x2,y2)=0 THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=29;
    ELSE
      SELECT b.ref INTO aim_bu_id FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.x=x2 AND b.y=y2 LIMIT 1;
      IF aim_bu_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=31;
      ELSE
        CALL unit_action_begin(g_id, p_num);

        SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;

        UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
        CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

        CALL unit_feature_set(board_unit_id,'bind_target',aim_bu_id);

        CALL cmd_log_add_message(g_id, p_num, 'unit_attaches', CONCAT_WS(';', log_unit(board_unit_id), log_unit(aim_bu_id)));

        CALL unit_action_end(g_id, p_num);

      END IF;
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`wizard_heal` $$

CREATE PROCEDURE `wizard_heal`(g_id INT,  p_num INT,  x INT,  y INT,   x2 INT,   y2 INT)
BEGIN
  DECLARE err_code INT;
  DECLARE aim_bu_id INT;
  DECLARE board_unit_id INT;
  DECLARE hp_heal INT DEFAULT 1;

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'wizard_heal'); 
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF check_one_step_from_unit(g_id,x,y,x2,y2)=0 THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=29;
    ELSE
      SELECT b.ref INTO aim_bu_id FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.x=x2 AND b.y=y2 LIMIT 1;
      IF aim_bu_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=32;
      ELSE
        CALL unit_action_begin(g_id, p_num);

        SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;

        UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
        CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

        CALL cmd_log_add_message(g_id, p_num, 'unit_heals', CONCAT_WS(';', log_unit(board_unit_id), log_unit(aim_bu_id)));

        CALL magical_heal(g_id,p_num,x2,y2,hp_heal);

        CALL unit_action_end(g_id, p_num);
      END IF;
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`necromancer_resurrect` $$

CREATE PROCEDURE `necromancer_resurrect`(g_id INT,  p_num INT,  x INT,  y INT,  grave_id INT)
BEGIN
  DECLARE dead_card_id INT;
  DECLARE err_code INT;
  DECLARE u2_id INT;
  DECLARE board_unit_id INT;
  DECLARE new_unit_id INT;
  DECLARE resur_cost INT;

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'necromancer_resurrect'); 
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT id FROM graves WHERE game_id=g_id AND id=grave_id LIMIT 1) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=8;
    ELSE
      IF NOT EXISTS (SELECT id FROM grave_cells gc WHERE grave_id=grave_id AND check_one_step_from_unit(g_id,x,y,gc.x,gc.y)=1 LIMIT 1) THEN
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

            SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;
            SELECT c.ref INTO u2_id FROM cards c WHERE c.id=dead_card_id LIMIT 1;

            UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
            CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);


            INSERT INTO board_units(game_id,player_num,card_id) VALUES (g_id,p_num,dead_card_id);
            SET new_unit_id=@@last_insert_id;
            INSERT INTO board_units_features(board_unit_id,feature_id,param) SELECT new_unit_id,ufu.feature_id,ufu.param FROM unit_default_features ufu WHERE ufu.unit_id=u2_id;
            UPDATE board_units SET moves_left=0 WHERE id=new_unit_id;

            INSERT INTO board_units_features(board_unit_id,feature_id,param) SELECT new_unit_id,unit_feature_get_id_by_code('under_control'),board_unit_id;

            INSERT INTO board(game_id,x,y,`type`,ref) SELECT g_id,gc.x,gc.y,'unit',new_unit_id FROM grave_cells gc WHERE gc.grave_id=grave_id;
            DELETE FROM graves WHERE game_id=g_id AND id=grave_id;

            CALL cmd_add_unit(g_id,p_num,new_unit_id);
            CALL cmd_remove_from_grave(g_id,p_num,grave_id);
            CALL cmd_unit_set_moves_left(g_id,p_num,new_unit_id);


            CALL unit_add_exp(board_unit_id, 1);

            INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'resurrect_unit',u2_id);

            CALL cmd_log_add_message(g_id, p_num, 'unit_resurrects', CONCAT_WS(';', log_unit(board_unit_id), log_unit(new_unit_id)));

            CALL unit_action_end(g_id, p_num);

          END IF;
        END IF;
      END IF;
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`necromancer_sacrifice` $$

CREATE PROCEDURE `necromancer_sacrifice`(g_id INT,  p_num INT,  x INT,  y INT,  x_sacr INT,  y_sacr INT,   x_target INT,   y_target INT)
BEGIN
  DECLARE err_code INT;
  DECLARE sacr_bu_id INT;
  DECLARE target_bu_id INT;
  DECLARE board_unit_id INT;
  DECLARE sacr_health INT;
  DECLARE damage_bonus INT DEFAULT 1;

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
            
            IF(sacr_bu_id<>target_bu_id)THEN
              CALL magical_damage(g_id,p_num,x_target,y_target,sacr_health+damage_bonus);
            END IF;

          END IF;

          CALL unit_action_end(g_id, p_num);

        END IF;
      END IF;
    END IF;
  END IF;

END$$

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`shields_restore` $$

CREATE PROCEDURE `shields_restore`(board_unit_id INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE u_id INT;

  SELECT bu.game_id, bu.player_num, bu.unit_id INTO g_id, p_num, u_id FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

  UPDATE board_units SET shield=(SELECT shield FROM units u WHERE u.id=u_id LIMIT 1) WHERE id=board_unit_id;
  CALL cmd_unit_set_shield(g_id,p_num,board_unit_id);

  CALL cmd_log_add_message(g_id, p_num, 'restore_magic_shield', log_unit(board_unit_id));

END$$

