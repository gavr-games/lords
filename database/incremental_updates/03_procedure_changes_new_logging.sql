use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`agree_draw` $$

CREATE PROCEDURE `agree_draw`(g_id INT, p_num INT)
BEGIN
  CALL user_action_begin();

  UPDATE players SET agree_draw=1 WHERE game_id=g_id AND player_num=p_num;

  CALL cmd_log_add_independent_message(g_id, p_num, 'agrees_to_draw', NULL);

  IF NOT EXISTS(SELECT p.id FROM players p WHERE p.game_id=g_id AND p.owner=1 AND p.agree_draw=0) THEN
    CALL end_game(g_id);
  END IF;

  CALL user_action_end();

END$$

DROP PROCEDURE IF EXISTS `lords`.`arbalester_shoot` $$

CREATE PROCEDURE `arbalester_shoot`(g_id INT, p_num INT, x INT, y INT,  x2 INT,  y2 INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE err_code INT;
  DECLARE aim_bu_id INT;
  DECLARE board_unit_id INT;
  DECLARE distance INT;
  DECLARE dice INT;
  DECLARE chance INT;
  DECLARE damage INT;
  DECLARE miss INT DEFAULT 0;
  DECLARE health_before_hit,health_after_hit,experience INT;


  DECLARE aim_unit_id INT;
  DECLARE damage_modificator INT DEFAULT 0;
  DECLARE dice_max_modificator INT DEFAULT 0;
  DECLARE chance_modificator INT DEFAULT 0;

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'arbalester_shoot'); 
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
      SELECT b.ref INTO aim_bu_id FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.x=x2 AND b.y=y2 LIMIT 1;
      IF aim_bu_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=40;
      ELSE
        SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;

        SELECT MIN(GREATEST(ABS(shooter.x-aim.x),ABS(shooter.y-aim.y))) INTO distance
        FROM
          (SELECT b.x,b.y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=board_unit_id) shooter,
          (SELECT b.x,b.y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=aim_bu_id) aim;

        IF((distance<2)OR(distance>4))THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=29;
        ELSE

          CALL user_action_begin();

          IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
            CALL start_moving_units(g_id,p_num);
          END IF;

          UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
          CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

          SELECT unit_id INTO aim_unit_id FROM board_units WHERE id=aim_bu_id;
          IF EXISTS(SELECT 1 FROM attack_bonus ab WHERE ab.mode_id=mode_id AND ab.unit_id IS NULL AND ab.aim_type='unit' AND ab.aim_id=aim_unit_id)THEN
            SELECT ab.dice_max,ab.chance,ab.damage_bonus INTO dice_max_modificator,chance_modificator,damage_modificator FROM attack_bonus ab WHERE ab.mode_id=mode_id AND ab.unit_id IS NULL AND ab.aim_type='unit' AND ab.aim_id=aim_unit_id LIMIT 1;
          END IF;

          SELECT bu.attack+damage_modificator INTO damage FROM board_units bu WHERE bu.id=board_unit_id;
          IF(dice_max_modificator > 0)THEN

            SELECT FLOOR(1 + (RAND() * dice_max_modificator)) INTO dice FROM DUAL;
            IF dice<chance_modificator THEN
              SET miss=1;
            END IF;
          END IF;

          IF miss=0 THEN
            IF distance=2 THEN 
              SET chance=1;
            END IF;
            IF distance=3 THEN 
              SET chance=1;
              SET damage=damage-FLOOR(RAND() * 2);
            END IF;
            IF distance=4 THEN 
              SET chance=4;
              SET damage=damage-1;
            END IF;

            SELECT FLOOR(1 + (RAND() * 6)) INTO dice FROM DUAL;
            IF dice<chance THEN
              SET miss=1;
            END IF;
          END IF;

          INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'unit_attack');
          IF miss=1 THEN
            CALL cmd_log_add_message(g_id, p_num, 'unit_shoots_unit_miss', CONCAT_WS(',', log_unit(board_unit_id), log_unit(aim_bu_id)));
            INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'miss_attack');
          ELSE
            CALL cmd_log_add_message(g_id, p_num, 'unit_shoots_unit', CONCAT_WS(',', log_unit(board_unit_id), log_unit(aim_bu_id), damage));

            SELECT bu.health INTO health_before_hit FROM board_units bu WHERE bu.id=aim_bu_id LIMIT 1;
            CALL hit_unit(aim_bu_id,p_num,damage);
            
            SELECT bu.health INTO health_after_hit FROM board_units bu WHERE bu.id=aim_bu_id LIMIT 1;
            IF (health_after_hit IS NULL) THEN
              SET health_after_hit = 0;
            END IF;
            SET experience = health_before_hit - health_after_hit;
            IF(health_after_hit = 0)THEN
              SET experience = experience + 1;
            END IF;
            IF(experience > 0)THEN
              CALL unit_add_exp(board_unit_id, experience);
            END IF;
          END IF;

          IF (check_all_units_moved(g_id,p_num) = 1) THEN
            CALL finish_moving_units(g_id,p_num);
            CALL end_units_phase(g_id,p_num);
          END IF;

          CALL user_action_end();
        END IF;
      END IF;
  END IF;
END$$

DROP PROCEDURE IF EXISTS `lords`.`archer_shoot` $$

CREATE PROCEDURE `archer_shoot`(g_id INT, p_num INT, x INT, y INT,  x2 INT,  y2 INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE err_code INT;
  DECLARE aim_bu_id INT;
  DECLARE board_unit_id INT;
  DECLARE distance INT;
  DECLARE dice INT;
  DECLARE chance INT;
  DECLARE damage INT;
  DECLARE miss INT DEFAULT 0;
  DECLARE health_before_hit,health_after_hit,experience INT;


  DECLARE aim_unit_id INT;
  DECLARE damage_modificator INT DEFAULT 0;
  DECLARE dice_max_modificator INT DEFAULT 0;
  DECLARE chance_modificator INT DEFAULT 0;

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'archer_shoot'); 
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
      SELECT b.ref INTO aim_bu_id FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.x=x2 AND b.y=y2 LIMIT 1;
      IF aim_bu_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=40;
      ELSE
        SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;

        SELECT MIN(GREATEST(ABS(shooter.x-aim.x),ABS(shooter.y-aim.y))) INTO distance
        FROM
          (SELECT b.x,b.y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=board_unit_id) shooter,
          (SELECT b.x,b.y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=aim_bu_id) aim;

        IF((distance<2)OR(distance>4))THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=29;
        ELSE

          CALL user_action_begin();

          IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
            CALL start_moving_units(g_id,p_num);
          END IF;

          UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
          CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

          SELECT unit_id INTO aim_unit_id FROM board_units WHERE id=aim_bu_id;
          IF EXISTS(SELECT 1 FROM attack_bonus ab WHERE ab.mode_id=mode_id AND ab.unit_id IS NULL AND ab.aim_type='unit' AND ab.aim_id=aim_unit_id)THEN
            SELECT ab.dice_max,ab.chance,ab.damage_bonus INTO dice_max_modificator,chance_modificator,damage_modificator FROM attack_bonus ab WHERE ab.mode_id=mode_id AND ab.unit_id IS NULL AND ab.aim_type='unit' AND ab.aim_id=aim_unit_id LIMIT 1;
          END IF;

          SELECT bu.attack+damage_modificator INTO damage FROM board_units bu WHERE bu.id=board_unit_id;
          IF(dice_max_modificator > 0)THEN

            SELECT FLOOR(1 + (RAND() * dice_max_modificator)) INTO dice FROM DUAL;
            IF dice<chance_modificator THEN
              SET miss=1;
            END IF;
          END IF;

          IF miss=0 THEN
            IF distance=2 THEN 
              SET chance=1;
            END IF;
            IF distance=3 THEN 
              SET chance=4;
            END IF;
            IF distance=4 THEN 
              SET chance=6;
            END IF;

            SELECT FLOOR(1 + (RAND() * 6)) INTO dice FROM DUAL;
            IF dice<chance THEN
              SET miss=1;
            END IF;
          END IF;

          INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'unit_attack');
          IF miss=1 THEN
            CALL cmd_log_add_message(g_id, p_num, 'unit_shoots_unit_miss', CONCAT_WS(',', log_unit(board_unit_id), log_unit(aim_bu_id)));
            INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'miss_attack');
          ELSE
            CALL cmd_log_add_message(g_id, p_num, 'unit_shoots_unit', CONCAT_WS(',', log_unit(board_unit_id), log_unit(aim_bu_id), damage));

            SELECT bu.health INTO health_before_hit FROM board_units bu WHERE bu.id=aim_bu_id LIMIT 1;
            CALL hit_unit(aim_bu_id,p_num,damage);
            
            SELECT bu.health INTO health_after_hit FROM board_units bu WHERE bu.id=aim_bu_id LIMIT 1;
            IF (health_after_hit IS NULL) THEN
              SET health_after_hit = 0;
            END IF;
            SET experience = health_before_hit - health_after_hit;
            IF(health_after_hit = 0)THEN
              SET experience = experience + 1;
            END IF;
            IF(experience > 0)THEN
              CALL unit_add_exp(board_unit_id, experience);
            END IF;
          END IF;


          IF (check_all_units_moved(g_id,p_num) = 1) THEN
            CALL finish_moving_units(g_id,p_num);
            CALL end_units_phase(g_id,p_num);
          END IF;

          CALL user_action_end();
        END IF;
      END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`attack_actions` $$

CREATE PROCEDURE `attack_actions`(board_unit_id INT, aim_type VARCHAR(45), aim_board_id INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT; 
  DECLARE p2_num INT; 
  DECLARE u_id,aim_object_id INT;
  DECLARE health_before_hit,health_after_hit,experience INT;
  DECLARE aim_card_id INT;
  DECLARE aim_x,aim_y INT;
  DECLARE aim_shield INT DEFAULT 0;
  DECLARE aim_goes_to_deck INT;
  DECLARE grave_id INT;

  DECLARE damage INT;
  DECLARE attack_success,critical INT;

  DECLARE cmd_log_unit VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_attack_unit_message($x,$y,$x2,$y2,$p_num,$unit_id,$p2_num,$aim_unit_id,$attack_success,$critical,$damage)';
  DECLARE cmd_log_building VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_attack_building_message($x,$y,$x2,$y2,$p_num,$unit_id,$p2_num,$aim_building_id,$attack_success,$critical,$damage)';
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8;

  SET cmd_log='log_add_attack_unit_message($x,$y,$x2,$y2,$p_num,$p2_num,$attack_success,$critical,$damage)';

  SELECT bu.game_id,bu.player_num,bu.unit_id INTO g_id,p_num,u_id FROM board_units bu JOIN games g ON (bu.game_id=g.id) WHERE bu.id=board_unit_id LIMIT 1;

  CASE
    WHEN aim_type='unit' THEN
    BEGIN
      SELECT bu.player_num,bu.unit_id,bu.health,bu.card_id,shield INTO p2_num,aim_object_id,health_before_hit,aim_card_id,aim_shield FROM board_units bu WHERE bu.id=aim_board_id LIMIT 1;
      SET aim_goes_to_deck = unit_feature_check(aim_board_id,'goes_to_deck_on_death');
      SELECT MIN(b.x),MIN(b.y) INTO aim_x,aim_y FROM board b WHERE b.game_id=g_id AND b.`type`=aim_type AND b.ref=aim_board_id;
      SET cmd_log = REPLACE(cmd_log_unit, '$aim_unit_id', aim_object_id);
    END;
    WHEN aim_type='building' OR aim_type='castle' THEN
    BEGIN
      SELECT bb.player_num,bb.building_id,bb.health INTO p2_num,aim_object_id,health_before_hit FROM board_buildings bb WHERE bb.id=aim_board_id LIMIT 1;
      SELECT b.x,b.y INTO aim_x,aim_y FROM board b WHERE b.game_id=g_id AND b.`type`=aim_type AND b.ref=aim_board_id LIMIT 1;
      SET cmd_log = REPLACE(cmd_log_building, '$aim_building_id', aim_object_id);
    END;
  END CASE;

  CALL calculate_attack_damage(board_unit_id,aim_type,aim_board_id,attack_success,damage,critical);

      SET cmd_log=REPLACE(cmd_log,'$unit_id',u_id);
      SET cmd_log=REPLACE(cmd_log,'$x,$y',(SELECT CONCAT(b.x,',',b.y) FROM board b WHERE b.`type`='unit' AND b.ref=board_unit_id LIMIT 1));
      SET cmd_log=REPLACE(cmd_log,'$x2,$y2',(SELECT CONCAT(aim_x,',',aim_y) FROM DUAL));

      SET cmd_log=REPLACE(cmd_log,'$p_num',p_num);
      SET cmd_log=REPLACE(cmd_log,'$p2_num',p2_num);

      SET cmd_log=REPLACE(cmd_log,'$attack_success',attack_success);
      SET cmd_log=REPLACE(cmd_log,'$critical',critical);
      SET cmd_log=REPLACE(cmd_log,'$damage',CASE WHEN aim_shield=0 THEN damage ELSE 0 END);

      INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

  IF critical=1 THEN
    INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'critical_hit');
  END IF;

      IF attack_success=1 THEN 

        
        IF(aim_type='unit' AND unit_feature_check(aim_board_id,'agressive')=1) THEN 
          CALL unit_feature_set(aim_board_id,'attack_target',board_unit_id);
        END IF;

        CASE aim_type
          WHEN 'unit' THEN CALL hit_unit(aim_board_id,p_num,damage);
          WHEN 'building' THEN CALL hit_building(aim_board_id,p_num,damage);
          WHEN 'castle' THEN CALL hit_castle(aim_board_id,p_num,damage);
        END CASE;

        IF (aim_type='unit') THEN
          SELECT bu.health INTO health_after_hit FROM board_units bu WHERE bu.id=aim_board_id LIMIT 1;
        ELSE
          SELECT bb.health INTO health_after_hit FROM board_buildings bb WHERE bb.id=aim_board_id LIMIT 1;
        END IF;
        IF (health_after_hit IS NULL) THEN
          SET health_after_hit = 0;
        END IF;


        SET experience = health_before_hit - health_after_hit;
        IF(health_after_hit = 0)THEN
          SET experience = experience + 1;
        END IF;
        IF(experience > 0 AND EXISTS(SELECT id FROM board_units WHERE id=board_unit_id))THEN
          CALL unit_add_exp(board_unit_id, experience);
        END IF;

        IF (aim_type='unit') THEN

          IF (unit_feature_check(board_unit_id,'drink_health')=1) AND (health_after_hit<health_before_hit)THEN
            CALL drink_health(board_unit_id);
          END IF;


          IF (unit_feature_check(board_unit_id,'vamp')=1) AND (health_after_hit = 0) THEN
            IF (aim_card_id IS NOT NULL AND aim_goes_to_deck=0) THEN
              SELECT gc.grave_id INTO grave_id FROM graves g JOIN grave_cells gc ON g.id=gc.grave_id WHERE g.game_id=g_id AND g.card_id=aim_card_id AND gc.x=aim_x AND gc.y=aim_y LIMIT 1;
              CALL vampire_resurrect_by_card(board_unit_id,grave_id);
            ELSE
              CALL vampire_resurrect_by_u_id(board_unit_id,aim_object_id,aim_x,aim_y);
            END IF;
          END IF;
          
          IF(unit_feature_check(board_unit_id,'pushes')=1 AND aim_type='unit') THEN 
            CALL unit_push(board_unit_id,aim_board_id);
          END IF;

        END IF;

      ELSE 
        INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'miss_attack');
      END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`buy_card` $$

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
            CALL cmd_log_add_independent_message_hidden(g_id, p_num, 'new_card', first_card_id);

            INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'buy_card');
            CALL end_cards_phase(g_id,p_num);

            CALL user_action_end();
          END IF;
        END IF;
      END IF;
    END IF;
  END IF;
END$$

DROP PROCEDURE IF EXISTS `lords`.`castle_auto_repair` $$

CREATE PROCEDURE `castle_auto_repair`(g_id INT, p_num INT)
BEGIN
  DECLARE board_building_id INT;
  DECLARE health_repair INT DEFAULT 1;
  DECLARE delta_health INT;

  SELECT bb.id,bb.max_health-bb.health INTO board_building_id,delta_health FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.game_id=g_id AND bb.player_num=p_num AND b.`type`='castle' LIMIT 1;

  IF(delta_health>0)THEN
    SET health_repair=LEAST(health_repair,delta_health);

    UPDATE board_buildings SET health=health+health_repair WHERE id=board_building_id;
    CALL cmd_building_set_health(g_id,p_num,board_building_id);

    CALL cmd_log_add_independent_message(g_id, p_num, 'building_repair', CONCAT_WS(',', log_building(board_building_id), health_repair));

  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`cast_mind_control` $$

CREATE PROCEDURE `cast_mind_control`(g_id INT, p_num INT, player_deck_id INT, x INT, y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE p2_num INT;
  DECLARE dice INT;
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

      SELECT FLOOR(1 + (RAND() * 6)) INTO dice FROM DUAL;
      IF (dice<=3) THEN 
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

        CALL cmd_log_add_message(g_id, p_num, log_msg_code, CONCAT_WS(',', log_unit(board_unit_id), p_num));

      END IF;

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`cast_polza_main` $$

CREATE PROCEDURE `cast_polza_main`(g_id INT, p_num INT, player_deck_id INT)
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

DROP PROCEDURE IF EXISTS `lords`.`cast_polza_move_building` $$

CREATE PROCEDURE `cast_polza_move_building`(g_id INT, p_num INT, b_x INT, b_y INT, x INT, y INT, rot INT, flp INT)
BEGIN
  DECLARE nonfinished_action INT DEFAULT 3;
  DECLARE board_building_id INT;
  DECLARE p2_num INT;
  DECLARE building_id INT;

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
            CALL user_action_begin();


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

              CALL user_action_end();
            END IF;
          END IF;
        END IF;
      END IF;
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`cast_polza_resurrect` $$

CREATE PROCEDURE `cast_polza_resurrect`(g_id INT, p_num INT, grave_id INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE nonfinished_action INT DEFAULT 1;
  DECLARE x_appear,y_appear,x_dir,y_dir INT;
  DECLARE size INT;
  DECLARE u_id INT;
  DECLARE dead_card_id INT;

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
          CALL user_action_begin();

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

            CALL user_action_end();
          END IF;
      END IF;
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`cast_polza_units_from_zone` $$

CREATE PROCEDURE `cast_polza_units_from_zone`(g_id INT, p_num INT, zone INT)
BEGIN
  DECLARE nonfinished_action INT DEFAULT 2;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;
  ELSE
    IF NOT nonfinished_action=(SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=24;
    ELSE
      IF zone NOT IN(0,1,2,3) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=25;
      ELSE
            CALL user_action_begin();

            CALL units_from_zone(g_id,zone);

            UPDATE active_players SET nonfinished_action_id=0 WHERE game_id=g_id AND player_num=p_num;

            CALL finish_playing_card(g_id,p_num);
            CALL end_cards_phase(g_id,p_num);

            CALL user_action_end();
      END IF;
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`cast_pooring` $$

CREATE PROCEDURE `cast_pooring`(g_id INT, p_num INT, player_deck_id INT, p2_num INT)
BEGIN
  DECLARE err_code INT;
  DECLARE pooring_sum INT DEFAULT 50;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_pooring');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT id FROM players WHERE game_id=g_id AND player_num=p2_num) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=13;
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); 


      UPDATE players SET gold=CASE WHEN gold<pooring_sum THEN 0 ELSE gold-pooring_sum END WHERE game_id=g_id AND player_num=p2_num;
      CALL cmd_player_set_gold(g_id,p2_num);

      CALL cmd_log_add_message(g_id, p_num, 'player_loses_gold', CONCAT_WS(',', p2_num, pooring_sum));

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;
END$$

DROP PROCEDURE IF EXISTS `lords`.`cast_russian_ruletka` $$

CREATE PROCEDURE `cast_russian_ruletka`(g_id INT, p_num INT, player_deck_id INT, x INT, y INT)
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

      IF (SELECT FLOOR(1 + (RAND() * 6)) as `dice` FROM DUAL)<6 THEN
        CALL cmd_log_add_message(g_id, p_num, 'miss_rus_rul', log_unit(board_unit_id));
      ELSE
        CALL kill_unit(board_unit_id,p_num);
      END IF;

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`cast_show_cards` $$

CREATE PROCEDURE `cast_show_cards`(g_id INT, p_num INT, player_deck_id INT, p2_num INT)
BEGIN
  DECLARE err_code INT;
  DECLARE card_id INT;

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT pd.card_id FROM player_deck pd WHERE pd.game_id=g_id AND pd.player_num=p2_num;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;


  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_show_cards');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT id FROM players WHERE game_id=g_id AND player_num=p2_num) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=13;
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      CALL cmd_log_add_message(g_id, p_num, 'players_cards', p2_num);

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

      CALL user_action_end();
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`cast_telekinesis` $$

CREATE PROCEDURE `cast_telekinesis`(g_id INT, p_num INT, player_deck_id INT, p2_num INT)
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
        SELECT FLOOR(1 + (RAND() * MAX(id_rand))) INTO big_dice FROM pl_cards;
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

DROP PROCEDURE IF EXISTS `lords`.`cast_vampire` $$

CREATE PROCEDURE `cast_vampire`(g_id INT, p_num INT, player_deck_id INT, x INT, y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE mode_id INT;
  DECLARE vamp_ui_code VARCHAR(45) CHARSET utf8 DEFAULT 'vampire'; 
  DECLARE vamp_u_id INT;
  DECLARE vamp_owner INT DEFAULT 4;
  DECLARE team INT;
  DECLARE new_player INT;
  DECLARE vamp_name VARCHAR(45) CHARSET utf8;
  DECLARE new_unit_id INT;

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

        CALL user_action_begin();

        CALL play_card_actions(g_id,p_num,player_deck_id); 

        SELECT MAX(p.team)+1 INTO team FROM players p WHERE p.game_id=g_id;
        SELECT CASE WHEN MAX(p.player_num)<10 THEN 10 ELSE MAX(p.player_num)+1 END INTO new_player FROM players p WHERE p.game_id=g_id;

        SELECT vu.id INTO vamp_u_id FROM vw_mode_units vu WHERE vu.mode_id=mode_id AND vu.ui_code=vamp_ui_code;
        SELECT ui_code INTO vamp_name FROM units WHERE id=vamp_u_id LIMIT 1;

        INSERT INTO players(game_id,player_num,name,gold,owner,team) VALUES(g_id,new_player,vamp_name,0,vamp_owner,team);
        CALL cmd_add_player(g_id,new_player);

        INSERT INTO board_units(game_id,player_num,unit_id) VALUES(g_id,new_player,vamp_u_id);
        SET new_unit_id=@@last_insert_id;
        INSERT INTO board_units_features(board_unit_id,feature_id,param) SELECT new_unit_id,ufu.feature_id,ufu.param FROM unit_default_features ufu WHERE ufu.unit_id=vamp_u_id;

        INSERT INTO board(game_id,x,y,`type`,ref) VALUES (g_id,x,y,'unit',new_unit_id);

        CALL cmd_add_unit_by_id(g_id,new_player,new_unit_id);
        
        CALL cmd_log_add_message(g_id, p_num, 'unit_appears_in_cell', CONCAT_WS(',', log_unit(new_unit_id), log_cell(x,y)));

        CALL finish_playing_card(g_id,p_num);
        CALL end_cards_phase(g_id,p_num);

        CALL user_action_end();
      END IF;
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`cast_vred_main` $$

CREATE PROCEDURE `cast_vred_main`(g_id INT, p_num INT, player_deck_id INT)
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
        CALL units_to_zone(g_id,zone);
      END;

      WHEN 5 THEN 
      BEGIN
        DECLARE random_player INT;

        CALL cmd_log_add_message(g_id, p_num, 'vred_random_player_takes_card', NULL);

        SELECT player_num INTO random_player FROM players WHERE game_id=g_id AND player_num IN(0,1,2,3) AND owner<>0 ORDER BY RAND() LIMIT 1;
        CALL vred_player_takes_card_from_everyone(g_id,random_player);
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

DROP PROCEDURE IF EXISTS `lords`.`cast_vred_destroy_building` $$

CREATE PROCEDURE `cast_vred_destroy_building`(g_id INT, p_num INT, x INT, y INT)
BEGIN
  DECLARE nonfinished_action INT DEFAULT 6;
  DECLARE board_building_id INT;

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
        CALL user_action_begin();

        CALL destroy_building(board_building_id,p_num);

        UPDATE active_players SET nonfinished_action_id=0 WHERE game_id=g_id AND player_num=p_num;

        CALL finish_playing_card(g_id,p_num);
        CALL end_cards_phase(g_id,p_num);

        CALL user_action_end();
      END IF;
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`cast_vred_kill_unit` $$

CREATE PROCEDURE `cast_vred_kill_unit`(g_id INT, p_num INT, x INT, y INT)
BEGIN
  DECLARE nonfinished_action INT DEFAULT 5;
  DECLARE board_unit_id INT;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;
  ELSE
    IF NOT nonfinished_action=(SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=24;
    ELSE
      IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
      ELSE
        CALL user_action_begin();

        SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;

        CALL magic_kill_unit(board_unit_id,p_num);

        UPDATE active_players SET nonfinished_action_id=0 WHERE game_id=g_id AND player_num=p_num;

        CALL finish_playing_card(g_id,p_num);
        CALL end_cards_phase(g_id,p_num);

        CALL user_action_end();
      END IF;
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`cast_vred_move_building` $$

CREATE PROCEDURE `cast_vred_move_building`(g_id INT, p_num INT, b_x INT, b_y INT, x INT, y INT, rot INT, flp INT)
BEGIN
  DECLARE nonfinished_action INT DEFAULT 7;
  DECLARE board_building_id INT;
  DECLARE p2_num INT;
  DECLARE building_id INT;

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
            CALL user_action_begin();


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

              CALL user_action_end();
            END IF;
          END IF;
        END IF;
      END IF;
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`cast_vred_pooring` $$

CREATE PROCEDURE `cast_vred_pooring`(g_id INT, p_num INT, p2_num INT)
BEGIN
  DECLARE nonfinished_action INT DEFAULT 4;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;
  ELSE
    IF NOT nonfinished_action=(SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=24;
    ELSE
      IF NOT EXISTS(SELECT id FROM players WHERE game_id=g_id AND player_num=p2_num AND owner<>0) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=13;
      ELSE
        CALL user_action_begin();

        CALL vred_pooring(g_id,p2_num);

        UPDATE active_players SET nonfinished_action_id=0 WHERE game_id=g_id AND player_num=p_num;

        CALL finish_playing_card(g_id,p_num);
        CALL end_cards_phase(g_id,p_num);

        CALL user_action_end();
      END IF;
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`catapult_shoot` $$

CREATE PROCEDURE `catapult_shoot`(g_id INT, p_num INT, x INT, y INT,  x2 INT,  y2 INT)
BEGIN
  DECLARE err_code INT;
  DECLARE aim_bb_id INT;
  DECLARE aim_type VARCHAR(45);
  DECLARE board_unit_id INT;
  DECLARE distance INT;
  DECLARE dice INT;
  DECLARE chance INT;
  DECLARE damage INT;
  DECLARE miss INT DEFAULT 0;
  DECLARE health_before_hit,health_after_hit,experience INT;

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'catapult_shoot'); 
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
      SELECT b.ref,b.`type` INTO aim_bb_id,aim_type FROM board b WHERE b.game_id=g_id AND (b.`type`='building' OR b.`type`='castle') AND b.x=x2 AND b.y=y2 LIMIT 1;
      IF aim_bb_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=26;
      ELSE
        SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;

        SELECT MIN(GREATEST(ABS(shooter.x-aim.x),ABS(shooter.y-aim.y))) INTO distance
        FROM
          (SELECT b.x,b.y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=board_unit_id) shooter,
          (SELECT b.x,b.y FROM board b WHERE b.game_id=g_id AND (b.`type`='building' OR b.`type`='castle') AND b.ref=aim_bb_id) aim;

        IF((distance<2)OR(distance>5))THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=29;
        ELSE

          CALL user_action_begin();

          IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
            CALL start_moving_units(g_id,p_num);
          END IF;

          UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
          CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

          IF distance=2 THEN 
            SET chance=1;
          END IF;
          IF distance=3 THEN 
            SET chance=4;
          END IF;
          IF distance=4 THEN 
            SET chance=5;
          END IF;
          IF distance=5 THEN 
            SET chance=6;
          END IF;

          SELECT FLOOR(1 + (RAND() * 6)) INTO dice FROM DUAL;
          IF dice<chance THEN
            SET miss=1;
          END IF;

          SELECT bu.attack INTO damage FROM board_units bu WHERE bu.id=board_unit_id;

          INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'unit_attack');
          IF miss=1 THEN
            CALL cmd_log_add_message(g_id, p_num, 'unit_shoots_building_miss', CONCAT_WS(',', log_unit(board_unit_id), log_building(aim_bb_id)));
            INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'miss_attack');
          ELSE
            CALL cmd_log_add_message(g_id, p_num, 'unit_shoots_building', CONCAT_WS(',', log_unit(board_unit_id), log_building(aim_bb_id), damage));

            SELECT bb.health INTO health_before_hit FROM board_buildings bb WHERE bb.id=aim_bb_id LIMIT 1;

            CASE aim_type
              WHEN 'building' THEN CALL hit_building(aim_bb_id,p_num,damage);
              WHEN 'castle' THEN CALL hit_castle(aim_bb_id,p_num,damage);
            END CASE;

            
            SELECT bb.health INTO health_after_hit FROM board_buildings bb WHERE bb.id=aim_bb_id LIMIT 1;
            IF (health_after_hit IS NULL) THEN
              SET health_after_hit = 0;
            END IF;
            SET experience = health_before_hit - health_after_hit;
            IF(health_after_hit = 0)THEN
              SET experience = experience + 1;
            END IF;
            IF(experience > 0)THEN
              CALL unit_add_exp(board_unit_id, experience);
            END IF;

          END IF;

          IF (check_all_units_moved(g_id,p_num) = 1) THEN
            CALL finish_moving_units(g_id,p_num);
            CALL end_units_phase(g_id,p_num);
          END IF;

          CALL user_action_end();
        END IF;
      END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`cmd_magic_resistance_log` $$

CREATE PROCEDURE `cmd_magic_resistance_log`(g_id INT, p_num INT,  board_unit_id INT)
BEGIN
  IF((SELECT current_procedure FROM active_players WHERE game_id=g_id LIMIT 1)='end_turn')THEN
    CALL cmd_log_add_independent_message(g_id, p_num, 'unit_magic_resistance', log_unit(board_unit_id));
  ELSE
    CALL cmd_log_add_message(g_id, p_num, 'unit_magic_resistance', log_unit(board_unit_id));
  END IF;
END$$

DROP PROCEDURE IF EXISTS `lords`.`cmd_mechanical_log` $$

CREATE PROCEDURE `cmd_mechanical_log`(g_id INT, p_num INT,  board_unit_id INT)
BEGIN
  IF((SELECT current_procedure FROM active_players WHERE game_id=g_id LIMIT 1)='end_turn')THEN
    CALL cmd_log_add_independent_message(g_id, p_num, 'unit_mechanical', log_unit(board_unit_id));
  ELSE
    CALL cmd_log_add_message(g_id, p_num, 'unit_mechanical', log_unit(board_unit_id));
  END IF;
END$$

DROP PROCEDURE IF EXISTS `lords`.`cmd_miss_game_log` $$

CREATE PROCEDURE `cmd_miss_game_log`(g_id INT, x INT, y INT)
BEGIN
  DECLARE obj_type VARCHAR(45);
  DECLARE obj_id INT;
  DECLARE p_num INT;

  SELECT b.`type`,b.ref INTO obj_type,obj_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y LIMIT 1;
  SELECT player_num INTO p_num FROM active_players WHERE game_id=g_id LIMIT 1;

  IF (obj_type='unit') THEN
    CALL cmd_log_add_message(g_id, p_num, 'miss_unit', log_unit(obj_id));
  ELSE
    CALL cmd_log_add_message(g_id, p_num, 'miss_building', log_building(obj_id));
  END IF;

  INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'miss_attack');

END$$

DROP PROCEDURE IF EXISTS `lords`.`cmd_miss_russian_rul` $$
DROP PROCEDURE IF EXISTS `lords`.`cmd_player_end_turn` $$
DROP PROCEDURE IF EXISTS `lords`.`cmd_player_end_turn_schedule` $$

DROP PROCEDURE IF EXISTS `lords`.`cmd_resurrect_by_card_log` $$

CREATE PROCEDURE `cmd_resurrect_by_card_log`(g_id INT, p_num INT, crd_id INT)
BEGIN
  DECLARE board_unit_id INT;

  SELECT MAX(bu.id) INTO board_unit_id FROM board_units bu WHERE bu.game_id=g_id AND bu.player_num=p_num AND bu.card_id=crd_id;
  CALL cmd_log_add_message(g_id, p_num, 'resurrect', CONCAT_WS(',', p_num, log_unit(board_unit_id)));

END$$

DROP PROCEDURE IF EXISTS `lords`.`cmd_unit_add_effect` $$

CREATE PROCEDURE `cmd_unit_add_effect`(g_id INT, board_unit_id INT, eff VARCHAR(30))
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'unit_add_effect($x,$y,"$effect","$param")';
  DECLARE log_key_add_effect VARCHAR(50) CHARSET utf8;
  DECLARE x,y INT;
  DECLARE p2_num INT; 

  SELECT b.x,b.y INTO x,y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=board_unit_id LIMIT 1;
  SELECT bu.player_num INTO p2_num FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;
  SET cmd=REPLACE(cmd,'$x',x);
  SET cmd=REPLACE(cmd,'$y',y);
  SET cmd=REPLACE(cmd,'$effect',eff);
  SET cmd=REPLACE(cmd,'$param',IFNULL(unit_feature_get_param(board_unit_id,eff),''));

  SELECT uf.log_key_add INTO log_key_add_effect FROM unit_features uf WHERE uf.code = eff LIMIT 1;
  CALL cmd_log_add_message(g_id, p2_num, log_key_add_effect, log_unit(board_unit_id));
    
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p2_num,cmd);

END$$

DROP PROCEDURE IF EXISTS `lords`.`cmd_unit_remove_effect` $$

CREATE PROCEDURE `cmd_unit_remove_effect`(g_id INT, board_unit_id INT, eff VARCHAR(30))
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'unit_remove_effect($x,$y,"$effect")';
  DECLARE log_key_remove_effect VARCHAR(50) CHARSET utf8;
  DECLARE x,y INT;
  DECLARE p2_num INT; 

  SELECT b.x,b.y INTO x,y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=board_unit_id LIMIT 1;
  SELECT bu.player_num INTO p2_num FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;
  SET cmd=REPLACE(cmd,'$x',x);
  SET cmd=REPLACE(cmd,'$y',y);
  SET cmd=REPLACE(cmd,'$effect',eff);

  SELECT uf.log_key_remove INTO log_key_remove_effect FROM unit_features uf WHERE uf.code = eff LIMIT 1;

  IF((SELECT current_procedure FROM active_players WHERE game_id=g_id LIMIT 1)='end_turn')THEN
    CALL cmd_log_add_independent_message(g_id, p2_num, log_key_remove_effect, log_unit(board_unit_id));
  ELSE
    CALL cmd_log_add_message(g_id, p2_num, log_key_remove_effect, log_unit(board_unit_id));
  END IF;

  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p2_num,cmd);

END$$

DROP PROCEDURE IF EXISTS `lords`.`destroy_building` $$

CREATE PROCEDURE `destroy_building`(board_b_id INT, p_num INT)
BEGIN
  DECLARE g_id INT;
  DECLARE reward INT DEFAULT 50;
  DECLARE old_x,old_y,old_rotation,old_flip INT;
  DECLARE destroy_bridge INT DEFAULT 0;

  SELECT game_id INTO g_id FROM board_buildings WHERE id=board_b_id LIMIT 1;

  CALL cmd_log_add_message(g_id, p_num, 'building_destroyed', log_building(board_b_id));

  IF EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.`type`='obstacle' AND b.ref=board_b_id) THEN
    SET reward=0; 
  END IF;

  IF(building_feature_check(board_b_id,'destroy_reward'))THEN
    SET reward=building_feature_get_param(board_b_id,'destroy_reward');
  END IF;

  IF(building_feature_check(board_b_id,'destroyable_bridge'))THEN
    SELECT MIN(b.x),MIN(b.y) INTO old_x,old_y FROM board b WHERE b.game_id=g_id AND b.`type`<>'unit' AND b.ref=board_b_id;
    SELECT bb.rotation,bb.flip INTO old_rotation,old_flip FROM board_buildings bb WHERE bb.id=board_b_id LIMIT 1;
    SET destroy_bridge=1;
  END IF;

  CALL remove_building_from_board(board_b_id,p_num);

  IF reward>0 THEN
    UPDATE players SET gold=gold+reward WHERE game_id=g_id AND player_num=p_num;
    CALL cmd_player_set_gold(g_id,p_num);
  END IF;

  IF(destroy_bridge=1)THEN
   CALL bridge_destroy(g_id,p_num,old_x,old_y,old_rotation,old_flip);
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`destroy_castle` $$

CREATE PROCEDURE `destroy_castle`(board_castle_id INT, p_num INT)
BEGIN
  DECLARE g_id INT;
  DECLARE g_mode INT;
  DECLARE p2_num INT; 
  DECLARE destroyed_castle_x INT;
  DECLARE destroyed_castle_y INT;
  DECLARE destroyed_castle_rotation INT;
  DECLARE destroyed_castle_flip INT;
  DECLARE ruins_building_id INT;
  DECLARE ruins_board_building_id INT;
  DECLARE user_id INT;
  DECLARE mode_id INT;
  DECLARE game_type_id INT;

  SELECT game_id,player_num INTO g_id,p2_num FROM board_buildings WHERE id=board_castle_id LIMIT 1;
  SELECT g.mode_id INTO g_mode FROM games g WHERE g.id=g_id LIMIT 1;

  CALL cmd_log_add_independent_message(g_id, p2_num, 'castle_destroyed', log_building(board_castle_id));

  INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'destroy_building',p2_num);

  SELECT bb.rotation,bb.flip INTO destroyed_castle_rotation,destroyed_castle_flip FROM board_buildings bb WHERE bb.id=board_castle_id LIMIT 1;
  SELECT MIN(b.x),MIN(b.y) INTO destroyed_castle_x,destroyed_castle_y FROM board b WHERE game_id=g_id AND `type`<>'unit' AND ref=board_castle_id;

  CALL delete_player_objects(g_id,p2_num);


  SELECT v.building_id INTO ruins_building_id FROM vw_mode_building_default_features v WHERE v.mode_id=g_mode AND v.feature_id=building_feature_get_id_by_code('ruins');

  INSERT INTO board_buildings(game_id,player_num,building_id,rotation,flip)VALUES (g_id,p2_num,ruins_building_id,destroyed_castle_rotation,destroyed_castle_flip);
  SET ruins_board_building_id=@@last_insert_id;

  CALL place_building_on_board(ruins_board_building_id,destroyed_castle_x,destroyed_castle_y,destroyed_castle_rotation,destroyed_castle_flip);

  CALL cmd_put_building_by_id(g_id,p2_num,ruins_board_building_id);


  IF (SELECT player_num FROM active_players WHERE game_id=g_id LIMIT 1)=p2_num THEN
    CALL end_turn(g_id,p2_num);
  END IF;

  UPDATE players SET owner=0 WHERE game_id=g_id AND player_num=p2_num;

  SELECT p.user_id INTO user_id FROM players p WHERE game_id=g_id AND player_num=p2_num;
  UPDATE lords_site.arena_game_players agp SET agp.spectator_flag=1 WHERE agp.user_id=user_id;

  CALL cmd_delete_player(g_id,p2_num);
  CALL cmd_add_spectator(g_id,p2_num);
  CALL cmd_play_video(g_id,p2_num,'destroyed_castle',1);

  SELECT g.mode_id, g.type_id INTO mode_id, game_type_id FROM games g WHERE g.id = g_id;

  INSERT INTO lords_site.user_statistics_games(user_id,game_type_id,mode_id,game_result)
  VALUES(user_id,game_type_id,mode_id,'lose');

  IF (SELECT COUNT(DISTINCT p.team) FROM players p WHERE game_id=g_id AND owner=1)=1 THEN
    CALL end_game(g_id);
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`disagree_draw` $$

CREATE PROCEDURE `disagree_draw`(g_id INT, p_num INT)
BEGIN
  CALL user_action_begin();

  UPDATE players SET agree_draw=0 WHERE game_id=g_id AND player_num=p_num;
  CALL cmd_log_add_independent_message(g_id, p_num, 'disagrees_to_draw', NULL);

  CALL user_action_end();

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

  IF ((SELECT FLOOR(1 + (RAND() * dice_max)) FROM DUAL)>chance) THEN 
    SELECT bu.game_id,bu.player_num,bu.health,bu.max_health INTO g_id,p_num,health,max_health FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

    IF(health+drink_health_amt>max_health)THEN
      UPDATE board_units SET max_health=health+drink_health_amt, health=health+drink_health_amt WHERE id=board_unit_id;
      CALL cmd_unit_set_max_health(g_id,p_num,board_unit_id);
      CALL cmd_unit_set_health(g_id,p_num,board_unit_id);
    ELSE 
      UPDATE board_units SET health=health+drink_health_amt WHERE id=board_unit_id;
      CALL cmd_unit_set_health(g_id,p_num,board_unit_id);
    END IF;

    CALL cmd_log_add_message(g_id, p_num, 'unit_drinks_health', CONCAT_WS(',', log_unit(board_unit_id), drink_health_amt));

  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`end_turn` $$

CREATE PROCEDURE `end_turn`(g_id INT, p_num INT)
BEGIN
  DECLARE board_unit_id INT;
  DECLARE p_num2 INT;
  DECLARE owner_p2 INT;
  DECLARE last_turn INT;
  DECLARE turn,new_turn INT;
  DECLARE mode_id INT;

  DECLARE nonfinished_action INT;

  DECLARE board_building_id INT;


  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id AND bu.player_num=p_num AND bu.moves_left<ABS(bu.moves);

  DECLARE cur_building_features CURSOR FOR
    SELECT bb.id FROM board_buildings bb WHERE bb.game_id=g_id AND bb.player_num=p_num2 AND check_building_deactivated(bb.id)=0;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    SELECT a.turn,a.nonfinished_action_id INTO turn,nonfinished_action FROM active_players a WHERE a.game_id=g_id LIMIT 1;

    IF(nonfinished_action<>0)THEN
      CALL finish_nonfinished_action(g_id,p_num,nonfinished_action);
    END IF;

    IF p_num=(SELECT MAX(player_num) FROM players WHERE game_id=g_id AND owner<>0) THEN
      SET new_turn=turn+1;
      UPDATE active_players SET turn=new_turn,player_num=(SELECT MIN(player_num) FROM players WHERE game_id=g_id AND owner<>0),subsidy_flag=0,units_moves_flag=0,card_played_flag=0,nonfinished_action_id=0,last_end_turn=CURRENT_TIMESTAMP,current_procedure='end_turn' WHERE game_id=g_id;
    ELSE
      SET new_turn=turn;
      UPDATE active_players SET player_num=(SELECT MIN(player_num) FROM players WHERE game_id=g_id AND player_num>p_num AND owner<>0),subsidy_flag=0,units_moves_flag=0,card_played_flag=0,nonfinished_action_id=0,last_end_turn=CURRENT_TIMESTAMP,current_procedure='end_turn' WHERE game_id=g_id;
    END IF;

    SELECT a.player_num,UNIX_TIMESTAMP(a.last_end_turn) INTO p_num2,last_turn FROM active_players a WHERE a.game_id=g_id;

    CALL cmd_set_active_player(g_id,p_num2,last_turn,new_turn);

    OPEN cur;
    REPEAT
      FETCH cur INTO board_unit_id;
      IF NOT done THEN
        UPDATE board_units SET moves_left=moves WHERE id=board_unit_id;
        CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur;


  IF @player_end_turn IS NULL THEN
    DELETE FROM player_features_usage WHERE game_id=g_id AND player_num=p_num AND feature_id=player_feature_get_id_by_code('end_turn');
  END IF;

  SELECT p.owner INTO owner_p2 FROM players p WHERE p.game_id=g_id AND p.player_num=p_num2 LIMIT 1;

  IF owner_p2=1 THEN 
  BEGIN
    DECLARE cmd_log_close_container VARCHAR(1000) CHARSET utf8 DEFAULT 'log_close_container()';


    DECLARE income INT;
    DECLARE u_income INT;


    IF((SELECT MAX(p.player_num) FROM players p WHERE p.game_id=g_id AND owner NOT IN(0,1))=p_num)THEN
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
    IF((SELECT MIN(p.player_num) FROM players p WHERE p.game_id=g_id AND owner NOT IN(0,1))=p_num2)THEN
      CALL cmd_log_add_container(g_id, p_num2, 'npc_turn', NULL);
    END IF;
  END;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`finish_nonfinished_action` $$

CREATE PROCEDURE `finish_nonfinished_action`(g_id INT, p_num INT, nonfinished_action INT)
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
        SELECT FLOOR(1 + (RAND() * MAX(id_rand))) INTO big_dice FROM tmp_dead_units;
        SELECT `grave_id`,`card_id` INTO random_grave,random_dead_card FROM tmp_dead_units WHERE id_rand=big_dice LIMIT 1;
        DROP TEMPORARY TABLE tmp_dead_units;

        CALL resurrect(g_id,p_num,random_grave);
        CALL cmd_resurrect_by_card_log(g_id,p_num,random_dead_card);
    END;

    WHEN 2 THEN 
    BEGIN
      DECLARE zone INT;

      SELECT FLOOR(RAND() * 4) INTO zone FROM DUAL;

      CALL units_from_zone(g_id,zone);
    END;

    WHEN 3 THEN 
    BEGIN
      DECLARE big_dice INT;
      DECLARE rand_building_id INT;
      DECLARE x_len,y_len INT;
      DECLARE shape VARCHAR(400);
      DECLARE radius INT;
      DECLARE rotation INT DEFAULT 0;
      DECLARE flip INT DEFAULT 0;
      DECLARE x,y,b_x,b_y INT;

      
        CREATE TEMPORARY TABLE tmp_buildings (id_rand INT AUTO_INCREMENT PRIMARY KEY)AUTO_INCREMENT=1
          SELECT DISTINCT b.ref AS `board_building_id`
          FROM board b
          JOIN board_buildings bb ON (b.ref=bb.id)
          WHERE b.game_id=g_id AND b.`type` IN ('building','obstacle') AND bb.player_num<>p_num AND building_feature_check(bb.id,'not_movable')=0;
        SELECT FLOOR(1 + (RAND() * MAX(id_rand))) INTO big_dice FROM tmp_buildings;
        SELECT `board_building_id` INTO rand_building_id FROM tmp_buildings WHERE id_rand=big_dice LIMIT 1;
        DROP TEMPORARY TABLE tmp_buildings;

        SELECT b.x_len,b.y_len,b.shape,b.radius INTO x_len,y_len,shape,radius FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.id=rand_building_id LIMIT 1;

        
        SELECT b.x,b.y INTO b_x,b_y FROM board b WHERE b.game_id=g_id AND b.`type` IN ('building','obstacle') AND b.ref=rand_building_id LIMIT 1;
        
        UPDATE board SET ref=0 WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=rand_building_id;

        
        WHILE NOT EXISTS (SELECT id FROM board WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=rand_building_id LIMIT 1) DO
          IF shape='1' THEN
            SELECT FLOOR(RAND() * 20) INTO x FROM DUAL;
            SELECT FLOOR(RAND() * 20) INTO y FROM DUAL;
          ELSE
            SELECT FLOOR(RAND() * 4) INTO rotation FROM DUAL;
            SELECT FLOOR(RAND() * 2) INTO flip FROM DUAL;
            
            SELECT FLOOR(RAND() * (21- CASE WHEN rotation IN(0,2) THEN x_len ELSE y_len END)) INTO x FROM DUAL;
            SELECT FLOOR(RAND() * (21- CASE WHEN rotation IN(0,2) THEN y_len ELSE x_len END)) INTO y FROM DUAL;
          END IF;
          
          CALL place_building_on_board(rand_building_id,x,y,rotation,flip);
        END WHILE;

        DELETE FROM board WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0; 

        UPDATE board_buildings bb SET bb.player_num=p_num,bb.rotation=rotation,bb.flip=flip WHERE bb.id=rand_building_id;

        CALL count_income(rand_building_id);

        CALL cmd_move_building(g_id,p_num,b_x,b_y,rand_building_id);
        CALL cmd_building_set_owner(g_id,p_num,rand_building_id);
    END;

    WHEN 4 THEN 
    BEGIN
      DECLARE random_player INT;

      SELECT player_num INTO random_player FROM players WHERE game_id=g_id ORDER BY RAND() LIMIT 1;
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
      DECLARE big_dice INT;
      DECLARE rand_building_id INT;
      DECLARE x_len,y_len INT;
      DECLARE shape VARCHAR(400);
      DECLARE radius INT;
      DECLARE rotation INT DEFAULT 0;
      DECLARE flip INT DEFAULT 0;
      DECLARE x,y,b_x,b_y INT;

      
        CREATE TEMPORARY TABLE tmp_buildings (id_rand INT AUTO_INCREMENT PRIMARY KEY)AUTO_INCREMENT=1
          SELECT DISTINCT b.ref AS `board_building_id`
          FROM board b
          JOIN board_buildings bb ON (b.ref=bb.id)
          WHERE b.game_id=g_id AND b.`type` IN ('building','obstacle') AND bb.player_num<>p_num AND building_feature_check(bb.id,'not_movable')=0;
        SELECT FLOOR(1 + (RAND() * MAX(id_rand))) INTO big_dice FROM tmp_buildings;
        SELECT `board_building_id` INTO rand_building_id FROM tmp_buildings WHERE id_rand=big_dice LIMIT 1;
        DROP TEMPORARY TABLE tmp_buildings;

        SELECT b.x_len,b.y_len,b.shape,b.radius INTO x_len,y_len,shape,radius FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.id=rand_building_id LIMIT 1;

        
        SELECT b.x,b.y INTO b_x,b_y FROM board b WHERE b.game_id=g_id AND b.`type` IN ('building','obstacle') AND b.ref=rand_building_id LIMIT 1;
        
        UPDATE board SET ref=0 WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=rand_building_id;

        
        WHILE NOT EXISTS (SELECT id FROM board WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=rand_building_id LIMIT 1) DO
          IF shape='1' THEN
            SELECT FLOOR(RAND() * 20) INTO x FROM DUAL;
            SELECT FLOOR(RAND() * 20) INTO y FROM DUAL;
          ELSE
            SELECT FLOOR(RAND() * 4) INTO rotation FROM DUAL;
            SELECT FLOOR(RAND() * 2) INTO flip FROM DUAL;
            
            SELECT FLOOR(RAND() * (21- CASE WHEN rotation IN(0,2) THEN x_len ELSE y_len END)) INTO x FROM DUAL;
            SELECT FLOOR(RAND() * (21- CASE WHEN rotation IN(0,2) THEN y_len ELSE x_len END)) INTO y FROM DUAL;
          END IF;
          
          CALL place_building_on_board(rand_building_id,x,y,rotation,flip);
        END WHILE;

        DELETE FROM board WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0; 

        UPDATE board_buildings bb SET bb.rotation=rotation,bb.flip=flip WHERE bb.id=rand_building_id;

        CALL count_income(rand_building_id);

        CALL cmd_move_building(g_id,p_num,b_x,b_y,rand_building_id);
    END;

  END CASE;

  UPDATE active_players SET nonfinished_action_id=0 WHERE game_id=g_id AND player_num=p_num;

  CALL finish_playing_card(g_id,p_num);

END$$

DROP PROCEDURE IF EXISTS `lords`.`get_create_game_modes` $$

DROP PROCEDURE IF EXISTS `lords`.`heal_unit_health` $$

CREATE PROCEDURE `heal_unit_health`(board_unit_id INT, hp INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;

  SELECT bu.game_id,bu.player_num INTO g_id,p_num FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

  UPDATE board_units SET health=health+hp WHERE id=board_unit_id;
  CALL cmd_unit_set_health(g_id,p_num,board_unit_id);

  IF((SELECT current_procedure FROM active_players WHERE game_id=g_id LIMIT 1)='end_turn')THEN
    CALL cmd_log_add_independent_message(g_id, p_num, 'unit_restores_health', CONCAT_WS(',', log_unit(board_unit_id), hp));
  ELSE
    CALL cmd_log_add_message(g_id, p_num, 'unit_restores_health', CONCAT_WS(',', log_unit(board_unit_id), hp));
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`kill_unit` $$

CREATE PROCEDURE `kill_unit`(bu_id INT, p_num INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p2_num INT; 
  DECLARE crd_id INT;
  DECLARE grave_id INT;
  DECLARE u_id INT;
  DECLARE reward INT DEFAULT 0;
  DECLARE kill_reward_divisor INT DEFAULT 2; 
  DECLARE binded_unit_id INT;

  SELECT game_id,player_num,card_id,unit_id INTO g_id,p2_num,crd_id,u_id FROM board_units WHERE id=bu_id LIMIT 1;

  CALL cmd_log_add_message(g_id, p_num, 'unit_killed', log_unit(bu_id));

  IF crd_id IS NOT NULL THEN
    IF unit_feature_check(bu_id,'goes_to_deck_on_death') = 1 THEN
      INSERT INTO deck(game_id,card_id) VALUES(g_id,crd_id);
    ELSE 
      INSERT INTO graves(game_id,card_id) VALUES(g_id,crd_id);
      SET grave_id=@@last_insert_id;
      INSERT INTO grave_cells(grave_id,x,y) SELECT grave_id,b.x,b.y FROM board b WHERE game_id=g_id AND b.`type`='unit' AND b.ref=bu_id;
      CALL cmd_add_to_grave(g_id,p_num,grave_id);
    END IF;
  END IF;

  CALL cmd_kill_unit(g_id,p_num,bu_id);

  DELETE FROM board WHERE game_id=g_id AND `type`='unit' AND ref=bu_id;
  DELETE FROM board_units_features WHERE board_unit_id=bu_id;
  DELETE FROM board_units WHERE id=bu_id;


  SELECT IFNULL(cost/kill_reward_divisor,0) INTO reward FROM cards WHERE `type`='u' AND ref=u_id LIMIT 1;


  IF ((SELECT owner FROM players WHERE game_id=g_id AND player_num=p2_num LIMIT 1)<>1)
    AND NOT EXISTS (SELECT id FROM board_units WHERE game_id=g_id AND player_num=p2_num)
    AND NOT EXISTS (SELECT id FROM board_buildings WHERE game_id=g_id AND player_num=p2_num)
  THEN 
    SET reward=reward+(SELECT gold FROM players WHERE game_id=g_id AND player_num=p2_num LIMIT 1);
    DELETE FROM players WHERE game_id=g_id AND player_num=p2_num;
    CALL cmd_delete_player(g_id,p2_num);
  END IF;

  IF(reward>0 AND EXISTS (SELECT id FROM players p WHERE p.game_id=g_id AND p.player_num=p_num))THEN
    UPDATE players SET gold=gold+reward WHERE game_id=g_id AND player_num=p_num;
    CALL cmd_player_set_gold(g_id,p_num);
  END IF;


  DELETE FROM board_units_features WHERE feature_id IN(unit_feature_get_id_by_code('bind_target'),unit_feature_get_id_by_code('attack_target')) AND param=bu_id;


  IF EXISTS(SELECT id FROM board_units_features WHERE feature_id=unit_feature_get_id_by_code('under_control') AND param=bu_id LIMIT 1)THEN
    CALL zombies_make_mad(g_id,bu_id);
  END IF;

  INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'kill_unit',p2_num);

END$$

DROP FUNCTION IF EXISTS `lords`.`log_attack` $$
DROP FUNCTION IF EXISTS `lords`.`log_damage` $$
DROP FUNCTION IF EXISTS `lords`.`log_gold` $$
DROP FUNCTION IF EXISTS `lords`.`log_health` $$
DROP FUNCTION IF EXISTS `lords`.`log_moves` $$
DROP FUNCTION IF EXISTS `lords`.`log_player` $$
DROP FUNCTION IF EXISTS `lords`.`log_unit_rod_pad` $$

DROP PROCEDURE IF EXISTS `lords`.`magical_damage` $$

CREATE PROCEDURE `magical_damage`(g_id INT, p_num INT, x INT, y INT, damage INT)
BEGIN
  DECLARE aim_id INT;
  DECLARE aim_type VARCHAR(45);
  DECLARE damage_final INT;
  DECLARE magic_tower_board_id INT;
  DECLARE aim_health INT;
  DECLARE aim_shield INT DEFAULT 0;

  SET damage_final=damage;


    SELECT bb.id INTO magic_tower_board_id FROM board b_mt JOIN board_buildings bb ON (b_mt.ref=bb.id)
      WHERE bb.game_id=g_id AND b_mt.`type`<>'unit' AND building_feature_check(bb.id,'magic_increase')=1 AND check_building_deactivated(bb.id)=0
      AND x BETWEEN b_mt.x-bb.radius AND b_mt.x+bb.radius AND y BETWEEN b_mt.y-bb.radius AND b_mt.y+bb.radius
      AND NOT(x=b_mt.x AND y=b_mt.y) LIMIT 1;
    IF (magic_tower_board_id IS NOT NULL) THEN
      SET damage_final=damage_final*building_feature_get_param(magic_tower_board_id,'magic_increase');
    END IF;

  SELECT b.`type`,b.ref INTO aim_type,aim_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y LIMIT 1;

  CASE
    WHEN aim_type='unit' THEN
    BEGIN
      SELECT shield,health INTO aim_shield,aim_health FROM board_units bu WHERE bu.id=aim_id LIMIT 1;
    END;
    WHEN aim_type='building' OR aim_type='castle' THEN
    BEGIN
      SELECT bb.health INTO aim_health FROM board_buildings bb WHERE bb.id=aim_id LIMIT 1;
    END;
  END CASE;

  IF(aim_shield=0 AND damage_final<aim_health AND NOT(aim_type='unit' AND unit_feature_check(aim_id,'magic_immunity')=1))THEN

    CASE aim_type
      WHEN 'building' THEN
        CALL cmd_log_add_message(g_id, p_num, 'building_damage', CONCAT_WS(',', log_building(aim_id), damage_final));
      WHEN 'unit' THEN
        CALL cmd_log_add_message(g_id, p_num, 'unit_damage', CONCAT_WS(',', log_unit(aim_id), damage_final));
    END CASE;

  END IF;

  CASE aim_type
    WHEN 'building' THEN CALL hit_building(aim_id,p_num,damage_final);
    WHEN 'unit' THEN
      IF (unit_feature_check(aim_id,'magic_immunity')=0) THEN 
        CALL hit_unit(aim_id,p_num,damage_final);
      ELSE
        CALL cmd_magic_resistance_log(g_id,p_num,aim_id);
      END IF;
  END CASE;

END$$

DROP PROCEDURE IF EXISTS `lords`.`make_mad` $$

CREATE PROCEDURE `make_mad`(board_unit_id INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE u_id INT;

  SELECT bu.game_id,bu.player_num,bu.unit_id INTO g_id,p_num,u_id FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

  IF (unit_feature_check(board_unit_id,'madness')=0) THEN 
    CALL unit_feature_set(board_unit_id,'madness',p_num);
    CALL cmd_unit_add_effect(g_id,board_unit_id,'madness');

    IF EXISTS(SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id AND bu.player_num=p_num AND bu.id<>board_unit_id LIMIT 1)
      OR EXISTS(SELECT bb.id FROM board_buildings bb WHERE bb.game_id=g_id AND bb.player_num=p_num LIMIT 1) THEN

    BEGIN
      DECLARE new_player,team INT;
      DECLARE mad_name VARCHAR(45) CHARSET utf8 DEFAULT 'Сумасшедший $u_name';

      SET mad_name=REPLACE(mad_name,'$u_name',(SELECT ui_code FROM units WHERE id=u_id LIMIT 1));
      SELECT MAX(p.team)+1 INTO team FROM players p WHERE p.game_id=g_id;
      SELECT CASE WHEN MAX(p.player_num)<10 THEN 10 ELSE MAX(p.player_num)+1 END INTO new_player FROM players p WHERE p.game_id=g_id;

      INSERT INTO players(game_id,player_num,name,gold,owner,team) VALUES(g_id,new_player,mad_name,0,2,team); 
      CALL cmd_add_player(g_id,new_player);

      UPDATE board_units SET player_num=new_player WHERE id=board_unit_id;
      CALL cmd_unit_set_owner(g_id,p_num,board_unit_id);

      IF EXISTS(SELECT id FROM board_units_features WHERE feature_id=unit_feature_get_id_by_code('under_control') AND param=board_unit_id LIMIT 1)THEN
        CALL zombies_make_mad(g_id,board_unit_id);
      END IF;
    END;
    END IF;
  ELSE
    CALL cmd_log_add_message(g_id, p_num, 'unit_already_mad', log_unit(board_unit_id));
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`move_unit` $$

CREATE PROCEDURE `move_unit`(board_unit_id INT, x2 INT, y2 INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE x,y INT;
  DECLARE delta_x,delta_y INT;
  DECLARE u_id INT;

  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_move_message($x,$y,$x2,$y2,$p_num,$unit_id)';

  SELECT bu.game_id,bu.player_num,bu.unit_id INTO g_id,p_num,u_id FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;
  SELECT MIN(b.x),MIN(b.y) INTO x,y FROM board b WHERE b.`type`='unit' AND b.ref=board_unit_id;
  SET delta_x=x2-x;
  SET delta_y=y2-y;
  UPDATE board b SET b.x=b.x+delta_x,b.y=b.y+delta_y WHERE b.`type`='unit' AND b.ref=board_unit_id;

  CALL cmd_move_unit(g_id,p_num,x,y,x2,y2);

  SET cmd_log=REPLACE(cmd_log,'$p_num',p_num);
  SET cmd_log=REPLACE(cmd_log,'$unit_id',u_id);
  SET cmd_log=REPLACE(cmd_log,'$x,$y',CONCAT(x,',',y));
  SET cmd_log=REPLACE(cmd_log,'$x2,$y2',CONCAT(x2,',',y2));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

END$$

DROP PROCEDURE IF EXISTS `lords`.`necromancer_resurrect` $$

CREATE PROCEDURE `necromancer_resurrect`(g_id INT, p_num INT, x INT, y INT, grave_id INT)
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

            CALL user_action_begin();

            IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
              CALL start_moving_units(g_id,p_num);
            END IF;

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

            CALL cmd_log_add_message(g_id, p_num, 'unit_resurrects', CONCAT_WS(',', log_unit(board_unit_id), log_unit(new_unit_id)));

            IF (check_all_units_moved(g_id,p_num) = 1) THEN
              CALL finish_moving_units(g_id,p_num);
              CALL end_units_phase(g_id,p_num);
            END IF;

            CALL user_action_end();

          END IF;
        END IF;
      END IF;
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`necromancer_sacrifice` $$

CREATE PROCEDURE `necromancer_sacrifice`(g_id INT, p_num INT, x INT, y INT, x_sacr INT, y_sacr INT,  x_target INT,  y_target INT)
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

          CALL user_action_begin();

          IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
            CALL start_moving_units(g_id,p_num);
          END IF;

          SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;

          UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
          CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);


          CALL cmd_log_add_message(g_id, p_num, 'sacrifice', CONCAT_WS(',', log_unit(board_unit_id), log_unit(sacr_bu_id), log_unit(target_bu_id)));
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

          IF (check_all_units_moved(g_id,p_num) = 1) THEN
            CALL finish_moving_units(g_id,p_num);
            CALL end_units_phase(g_id,p_num);
          END IF;

          CALL user_action_end();

        END IF;
      END IF;
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`play_card_actions` $$

CREATE PROCEDURE `play_card_actions`(g_id INT, p_num INT, player_deck_id INT)
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
  IF(card_type IN ('m','e'))THEN INSERT INTO deck(game_id,card_id) VALUES(g_id,crd_id); END IF;

  CALL cmd_log_add_container(g_id, p_num, 'plays_card', crd_id);
  INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'play_card',crd_id);
END$$

DROP PROCEDURE IF EXISTS `lords`.`player_end_turn` $$

CREATE PROCEDURE `player_end_turn`(g_id INT, p_num INT)
BEGIN
  DECLARE moved_units INT;
  DECLARE moves_to_auto_repair INT DEFAULT 2;
  DECLARE moves_ended INT DEFAULT 2;
  DECLARE end_turn_feature_id INT;
  DECLARE owner INT;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;
  ELSE
    CALL user_action_begin();

    SELECT units_moves_flag INTO moved_units FROM active_players WHERE game_id=g_id LIMIT 1;
    SELECT p.owner INTO owner FROM players p WHERE p.game_id=g_id AND p.player_num=p_num LIMIT 1;

    IF moved_units=1 OR owner<>1 THEN
      CALL cmd_log_add_message(g_id, p_num, 'end_turn', p_num);
      CALL finish_moving_units(g_id,p_num);
    ELSE
      CALL cmd_log_add_independent_message(g_id, p_num, 'end_turn', p_num);
    END IF;

    
    IF moved_units=0 THEN
      SET end_turn_feature_id=player_feature_get_id_by_code('end_turn');

      IF EXISTS(SELECT pfu.id FROM player_features_usage pfu WHERE pfu.game_id=g_id AND pfu.player_num=p_num AND feature_id=end_turn_feature_id LIMIT 1)THEN
        SELECT pfu.param INTO moves_ended FROM player_features_usage pfu WHERE pfu.game_id=g_id AND pfu.player_num=p_num AND feature_id=end_turn_feature_id LIMIT 1;

        IF(moves_ended+1=moves_to_auto_repair)THEN
          DELETE FROM player_features_usage WHERE game_id=g_id AND player_num=p_num AND feature_id=end_turn_feature_id;
          CALL castle_auto_repair(g_id,p_num);
        ELSE
          SET @player_end_turn=1;
          UPDATE player_features_usage pfu SET param=param+1 WHERE pfu.game_id=g_id AND pfu.player_num=p_num AND feature_id=end_turn_feature_id;
        END IF;

      ELSE
        IF (moves_to_auto_repair=1) THEN
          CALL castle_auto_repair(g_id,p_num);
        ELSE
          SET @player_end_turn=1;
          INSERT INTO player_features_usage(game_id,player_num,feature_id,param) VALUES(g_id,p_num,end_turn_feature_id,1);
        END IF;
      END IF;
    END IF;

    CALL end_turn(g_id,p_num);

    CALL user_action_end();
  END IF;
END$$

DROP PROCEDURE IF EXISTS `lords`.`player_end_turn_by_timeout` $$

CREATE PROCEDURE `player_end_turn_by_timeout`(g_id INT, p_num INT)
BEGIN

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;
  ELSE
    CALL user_action_begin();

    IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=1 THEN
      CALL cmd_log_add_message(g_id, p_num, 'end_turn_timeout', p_num);
      CALL finish_moving_units(g_id,p_num);
    ELSE
      CALL cmd_log_add_independent_message(g_id, p_num, 'end_turn_timeout', p_num);
    END IF;

    CALL end_turn(g_id,p_num);

    CALL user_action_end();
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`player_exit` $$

CREATE PROCEDURE `player_exit`(g_id INT, p_num INT)
BEGIN
  DECLARE p_id INT;
  DECLARE finished_game_status INT DEFAULT 3; 
  DECLARE user_id INT;
  DECLARE owner INT;
  DECLARE player_online_status_id INT DEFAULT 1; 
  DECLARE mode_id INT;
  DECLARE game_type_id INT;

  CALL user_action_begin();

  SELECT g.mode_id, g.type_id INTO mode_id, game_type_id FROM games g WHERE g.id = g_id;

  SELECT p.id,p.owner,p.user_id INTO p_id,owner,user_id FROM players p WHERE game_id=g_id AND player_num=p_num;

  IF (SELECT g.status_id FROM games g WHERE g.id=g_id LIMIT 1)<>finished_game_status AND (owner=1) THEN
    CALL cmd_log_add_independent_message(g_id, p_num, 'player_exit', p_num);

    CALL delete_player_objects(g_id,p_num);

    IF (SELECT player_num FROM active_players WHERE game_id=g_id LIMIT 1)=p_num THEN
      CALL end_turn(g_id,p_num);
    END IF;

    CALL cmd_delete_player(g_id,p_num);

    UPDATE players SET owner=0 WHERE game_id=g_id AND player_num=p_num;

    INSERT INTO lords_site.user_statistics_games(user_id,game_type_id,mode_id,game_result)
    VALUES(user_id,game_type_id,mode_id,'exit');

    IF (SELECT COUNT(DISTINCT p.team) FROM players p WHERE p.game_id=g_id AND p.owner=1)=1 THEN
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

  CALL user_action_end();
  
  DELETE FROM players WHERE game_id=g_id AND player_num=p_num;  
END$$

DROP PROCEDURE IF EXISTS `lords`.`player_resurrect` $$

CREATE PROCEDURE `player_resurrect`(g_id INT, p_num INT, grave_id INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE dead_card_id INT;
  DECLARE resurrection_cost_coefficient INT;
  DECLARE resur_cost INT;
  DECLARE x_appear,y_appear,x_dir,y_dir INT;
  DECLARE new_unit_id INT;
  DECLARE size INT;
  DECLARE u_id INT;
  DECLARE new_bu_id INT;

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
  SELECT cfg.`value` INTO resurrection_cost_coefficient FROM mode_config cfg WHERE cfg.param='resurrection cost coefficient' AND cfg.mode_id=mode_id;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;
  ELSE
    IF (SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id LIMIT 1)<>0 THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=28;
    ELSE
      IF (SELECT card_played_flag FROM active_players WHERE game_id=g_id)=1 THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=42;
      ELSE
        IF NOT EXISTS(SELECT id FROM graves WHERE game_id=g_id AND id=grave_id LIMIT 1) THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=8;
        ELSE
          SELECT g.card_id INTO dead_card_id FROM graves g WHERE id=grave_id;
          SELECT cost*resurrection_cost_coefficient INTO resur_cost FROM cards WHERE id=dead_card_id LIMIT 1;
          IF (SELECT gold FROM players WHERE game_id=g_id AND player_num=p_num LIMIT 1)<resur_cost THEN
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=2;
          ELSE
            SELECT ap.x,ap.y,ap.direction_into_board_x,ap.direction_into_board_y INTO x_appear,y_appear,x_dir,y_dir FROM appear_points ap WHERE ap.mode_id=mode_id AND ap.player_num=p_num;
            SELECT u.id,u.size INTO u_id,size FROM cards c JOIN units u ON c.ref=u.id WHERE c.id=dead_card_id LIMIT 1;
            IF EXISTS(SELECT id FROM board WHERE game_id=g_id AND x BETWEEN LEAST(x_appear,x_appear+x_dir*(size-1)) AND GREATEST(x_appear,x_appear+x_dir*(size-1)) AND y BETWEEN LEAST(y_appear,y_appear+y_dir*(size-1)) AND GREATEST(y_appear,y_appear+y_dir*(size-1)) LIMIT 1) THEN
              SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=9;
            ELSE
              CALL user_action_begin();

              UPDATE players SET gold=gold-resur_cost WHERE game_id=g_id AND player_num=p_num;
              CALL cmd_player_set_gold(g_id,p_num);

              CALL resurrect(g_id,p_num,grave_id);

              SELECT MAX(id) INTO new_bu_id FROM board_units bu WHERE bu.game_id=g_id AND bu.player_num=p_num;
              CALL cmd_log_add_independent_message(g_id, p_num, 'resurrect', CONCAT_WS(',', p_num, log_unit(new_bu_id)));

              CALL end_cards_phase(g_id,p_num);

              CALL user_action_end();
            END IF;
          END IF;
        END IF;
      END IF;
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`repair_buildings` $$

CREATE PROCEDURE `repair_buildings`(g_id INT, p_num INT)
BEGIN
  DECLARE board_building_id INT;
  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT bb.id FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.game_id=g_id AND bb.player_num=p_num AND bb.health<bb.max_health;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  OPEN cur;
  REPEAT
    FETCH cur INTO board_building_id;
    IF NOT done THEN
      CALL cmd_log_add_message(g_id, p_num, 'building_completely_repaired', log_building(board_building_id));
      UPDATE board_buildings SET health=max_health WHERE id=board_building_id;
      CALL cmd_building_set_health(g_id,p_num,board_building_id);
    END IF;
  UNTIL done END REPEAT;
  CLOSE cur;


END$$

DROP PROCEDURE IF EXISTS `lords`.`send_money` $$

CREATE PROCEDURE `send_money`(g_id INT, p_num INT, p2_num INT, amount_input_str VARCHAR(100) CHARSET utf8)
BEGIN
  DECLARE amount INT;

  DECLARE conversion_error INT DEFAULT 0;
  DECLARE CONTINUE HANDLER FOR SQLSTATE '22007' SET conversion_error = 1;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;
  ELSE
  SET amount=CAST(amount_input_str AS SIGNED INTEGER);

  IF (conversion_error=1 OR amount<=0) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=4;
  ELSE

    IF (p_num=p2_num) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=36;
    ELSE

      IF (SELECT gold FROM players WHERE game_id=g_id AND player_num=p_num)<amount THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=2;
      ELSE

        CALL user_action_begin();

        UPDATE players SET gold=gold-amount WHERE game_id=g_id AND player_num=p_num;
        UPDATE players SET gold=gold+amount WHERE game_id=g_id AND player_num=p2_num;

        CALL cmd_player_set_gold(g_id,p_num);
        CALL cmd_player_set_gold(g_id,p2_num);

        CALL cmd_log_add_independent_message(g_id, p_num, 'send_money', CONCAT_WS(',', p2_num, amount));

        CALL user_action_end();
      END IF;
    END IF;
  END IF;
  END IF;
END$$

DROP PROCEDURE IF EXISTS `lords`.`shield_off` $$

CREATE PROCEDURE `shield_off`(board_unit_id INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;

  SELECT bu.game_id,bu.player_num INTO g_id,p_num FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

  UPDATE board_units SET shield=shield-1 WHERE id=board_unit_id;
  CALL cmd_unit_set_shield(g_id,p_num,board_unit_id);

  CALL cmd_log_add_message(g_id, p_num, 'loses_magic_shield', log_unit(board_unit_id));

END$$

DROP PROCEDURE IF EXISTS `lords`.`shield_on` $$

CREATE PROCEDURE `shield_on`(board_unit_id INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;

  SELECT bu.game_id,bu.player_num INTO g_id,p_num FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

  UPDATE board_units SET shield=shield+1 WHERE id=board_unit_id;
  CALL cmd_unit_set_shield(g_id,p_num,board_unit_id);

  IF((SELECT current_procedure FROM active_players WHERE game_id=g_id LIMIT 1)='end_turn')THEN
    CALL cmd_log_add_independent_message(g_id, p_num, 'gets_magic_shield', log_unit(board_unit_id));
  ELSE
    CALL cmd_log_add_message(g_id, p_num, 'gets_magic_shield', log_unit(board_unit_id));
  END IF;


END$$

DROP PROCEDURE IF EXISTS `lords`.`shields_restore` $$

CREATE PROCEDURE `shields_restore`(board_unit_id INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;

  SELECT bu.game_id,bu.player_num INTO g_id,p_num FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

  UPDATE board_units SET shield=(SELECT shield FROM units u WHERE u.id=u_id LIMIT 1) WHERE id=board_unit_id;
  CALL cmd_unit_set_shield(g_id,p_num,board_unit_id);

  CALL cmd_log_add_message(g_id, p_num, 'restore_magic_shield', log_unit(board_unit_id));

END$$

DROP PROCEDURE IF EXISTS `lords`.`sink_building` $$

CREATE PROCEDURE `sink_building`(bb_id INT, p_num INT)
BEGIN
  DECLARE g_id INT;

  SELECT game_id INTO g_id FROM board_buildings WHERE id=bb_id LIMIT 1;

  CALL cmd_log_add_message(g_id, p_num, 'building_sinks', log_building(bb_id));

  CALL remove_building_from_board(bb_id,p_num);
END$$

DROP PROCEDURE IF EXISTS `lords`.`sink_unit` $$

CREATE PROCEDURE `sink_unit`(bu_id INT, p_num INT)
BEGIN
  DECLARE g_id INT;

  SELECT game_id INTO g_id FROM board_units WHERE id=bu_id LIMIT 1;

  CALL cmd_log_add_message(g_id, p_num, 'unit_drowns', log_unit(bu_id));

  CALL unit_feature_set(bu_id,'goes_to_deck_on_death',null);
  CALL kill_unit(bu_id,p_num);
END$$

DROP PROCEDURE IF EXISTS `lords`.`start_moving_units` $$

CREATE PROCEDURE `start_moving_units`(g_id INT, p_num INT)
BEGIN
  UPDATE active_players SET units_moves_flag=1 WHERE game_id=g_id AND player_num=p_num;

  IF((SELECT owner FROM players p WHERE p.game_id=g_id AND p.player_num=p_num LIMIT 1)=1)THEN
    CALL cmd_log_add_container(g_id, p_num, 'moves_units', NULL);
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`summon_creature` $$

CREATE PROCEDURE `summon_creature`(g_id INT,  cr_player_name VARCHAR(45) CHARSET utf8,  cr_owner INT , cr_unit_id INT , x INT , y INT,  parent_building_id INT)
BEGIN
  DECLARE new_player,team INT;
  DECLARE new_unit_id INT;

    SELECT CASE WHEN MAX(p.player_num)<10 THEN 10 ELSE MAX(p.player_num)+1 END INTO new_player FROM players p WHERE p.game_id=g_id;
    SET team=building_feature_get_param(parent_building_id,'summon_team');


    INSERT INTO players(game_id,player_num,name,gold,owner,team) VALUES(g_id,new_player,cr_player_name,0,cr_owner,team);

    INSERT INTO board_units(game_id,player_num,unit_id) VALUES(g_id,new_player,cr_unit_id);
    SET new_unit_id=@@last_insert_id;
    INSERT INTO board_units_features(board_unit_id,feature_id,param) SELECT new_unit_id,ufu.feature_id,ufu.param FROM unit_default_features ufu WHERE ufu.unit_id=cr_unit_id;
    INSERT INTO board_units_features(board_unit_id,feature_id,param) VALUES(new_unit_id,unit_feature_get_id_by_code('parent_building'),parent_building_id);

    INSERT INTO board(game_id,x,y,`type`,ref) VALUES (g_id,x,y,'unit',new_unit_id);

    CALL cmd_add_player(g_id,new_player);
    CALL cmd_add_unit_by_id(g_id,new_player,new_unit_id);

    IF((SELECT current_procedure FROM active_players WHERE game_id=g_id LIMIT 1)='end_turn')THEN
      CALL cmd_log_add_independent_message(g_id, new_player, 'unit_appears_in_cell', CONCAT_WS(',', log_unit(new_unit_id), log_cell(x,y)));
    ELSE
      CALL cmd_log_add_message(g_id, new_player, 'unit_appears_in_cell', CONCAT_WS(',', log_unit(new_unit_id), log_cell(x,y)));
    END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`take_subsidy` $$

CREATE PROCEDURE `take_subsidy`(g_id INT, p_num INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE subsidy_amt INT;
  DECLARE subsidy_damage INT;
  DECLARE board_castle_id INT;
  DECLARE health_remaining INT;

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
        CALL user_action_begin();

        SELECT bb.id INTO board_castle_id FROM board_buildings bb JOIN board b ON bb.id=b.ref WHERE b.`type`='castle' AND b.game_id=g_id AND bb.player_num=p_num LIMIT 1;
        UPDATE players SET gold=gold+subsidy_amt WHERE game_id=g_id AND player_num=p_num;
        UPDATE board_buildings SET health=health-subsidy_damage WHERE id=board_castle_id;
        UPDATE active_players SET subsidy_flag=1 WHERE game_id=g_id;
        
        SELECT health INTO remaining_healh FROM board_buildings WHERE id=board_castle_id;

        CALL cmd_player_set_gold(g_id,p_num);
        CALL cmd_building_set_health(g_id,p_num,board_castle_id);

        CALL cmd_log_add_independent_message(g_id, p_num, 'take_subsidy', CONCAT_WS(',', log_building(board_castle_id), remaining_healh));

        CALL user_action_end();
      END IF;
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`taran_bind` $$

CREATE PROCEDURE `taran_bind`(g_id INT, p_num INT, x INT, y INT,  x2 INT,  y2 INT)
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
        CALL user_action_begin();

        IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
          CALL start_moving_units(g_id,p_num);
        END IF;

        SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;

        UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
        CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

        CALL unit_feature_set(board_unit_id,'bind_target',aim_bu_id);

        CALL cmd_log_add_message(g_id, p_num, 'unit_attaches', CONCAT_WS(',', log_unit(board_unit_id), log_unit(aim_bu_id)));

        IF (check_all_units_moved(g_id,p_num) = 1) THEN
          CALL finish_moving_units(g_id,p_num);
          CALL end_units_phase(g_id,p_num);
        END IF;

        CALL user_action_end();

      END IF;
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`total_heal` $$

CREATE PROCEDURE `total_heal`(board_unit_id INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE hp_minus INT;
  DECLARE shield_minus INT;

  SELECT bu.game_id,bu.player_num,bu.max_health-bu.health,u.shield-bu.shield INTO g_id,p_num,hp_minus,shield_minus
  FROM board_units bu JOIN units u ON (bu.unit_id=u.id) WHERE bu.id=board_unit_id LIMIT 1;

  IF((unit_feature_check(board_unit_id,'paralich')=0)AND(unit_feature_check(board_unit_id,'madness')=0)AND(hp_minus<=0)AND(shield_minus<=0))THEN
      CALL cmd_log_add_message(g_id, p_num, 'unit_healed', log_unit(board_unit_id));
  END IF;

  IF (unit_feature_check(board_unit_id,'paralich')=1) THEN
    CALL unit_feature_remove(board_unit_id,'paralich');
    CALL cmd_unit_remove_effect(g_id,board_unit_id,'paralich');
  END IF;

  IF (unit_feature_check(board_unit_id,'madness')=1) THEN
    CALL make_not_mad(board_unit_id);
  END IF;

  IF hp_minus>0 THEN
    CALL heal_unit_health(board_unit_id,hp_minus);
  END IF;

  IF shield_minus>0 THEN
    CALL shields_restore(board_unit_id);
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`unit_add_attack` $$

CREATE PROCEDURE `unit_add_attack`(board_unit_id INT,  qty INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;

  SELECT bu.game_id,bu.player_num INTO g_id,p_num FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

  UPDATE board_units SET attack=attack+qty WHERE id=board_unit_id;
  CALL cmd_unit_set_attack(g_id,p_num,board_unit_id);
  CALL cmd_log_add_message(g_id, p_num, 'unit_gets_attack', CONCAT_WS(',', log_unit(board_unit_id), qty));

END$$

DROP PROCEDURE IF EXISTS `lords`.`unit_add_health` $$

CREATE PROCEDURE `unit_add_health`(board_unit_id INT,  qty INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;

  SELECT bu.game_id,bu.player_num INTO g_id,p_num FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

  UPDATE board_units SET max_health=max_health+qty, health=health+qty WHERE id=board_unit_id;
  CALL cmd_unit_set_max_health(g_id,p_num,board_unit_id);
  CALL cmd_unit_set_health(g_id,p_num,board_unit_id);

  CALL cmd_log_add_message(g_id, p_num, 'unit_gets_health', CONCAT_WS(',', log_unit(board_unit_id), qty));

END$$

DROP PROCEDURE IF EXISTS `lords`.`unit_add_moves` $$

CREATE PROCEDURE `unit_add_moves`(board_unit_id INT,  qty INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;

  SELECT bu.game_id,bu.player_num INTO g_id,p_num FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

  UPDATE board_units SET moves=moves+qty, moves_left=moves_left+qty WHERE id=board_unit_id;
  CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);
  CALL cmd_unit_set_moves(g_id,p_num,board_unit_id);

  CALL cmd_log_add_message(g_id, p_num, 'unit_gets_moves', CONCAT_WS(',', log_unit(board_unit_id), qty));
END$$

DROP PROCEDURE IF EXISTS `lords`.`unit_level_up` $$

CREATE PROCEDURE `unit_level_up`(g_id INT, p_num INT, x INT, y INT,  stat VARCHAR(10))
BEGIN
  DECLARE board_unit_id INT;
  DECLARE level_up_bonus INT DEFAULT 1;
  DECLARE log_msg_code_part VARCHAR(50) CHARSET utf8 DEFAULT 'unit_levelup_';
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'unit_level_up_$stat($x,$y)';
  
  
  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id LIMIT 1) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;
  ELSE
    IF (SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id LIMIT 1)<>0 THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=28;
    ELSE
      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;
      IF board_unit_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
      ELSE
        IF NOT p_num=(SELECT bu.player_num FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1) THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=16;
        ELSE
          IF check_unit_can_level_up(board_unit_id) = 0 THEN
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=41;
          ELSE

            CALL user_action_begin();
            IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
              CALL start_moving_units(g_id,p_num);
            END IF;

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
            
            CALL cmd_log_add_message(g_id, p_num, CONCAT(log_msg_code_part, stat), CONCAT_WS(',', log_unit(board_unit_id), level_up_bonus));
            
            SET cmd=REPLACE(cmd,'$stat',stat);
            SET cmd=REPLACE(cmd,'$x',x);
            SET cmd=REPLACE(cmd,'$y',y);
            INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);
            
            IF (check_all_units_moved(g_id,p_num) = 1) THEN
              CALL finish_moving_units(g_id,p_num);
              CALL end_units_phase(g_id,p_num);
            END IF;

            CALL user_action_end();
          END IF;
        END IF;
      END IF;
    END IF;
  END IF;
END$$

DROP PROCEDURE IF EXISTS `lords`.`unit_push` $$

CREATE PROCEDURE `unit_push`(board_unit_id_1 INT,  board_unit_id_2 INT)
BEGIN

  DECLARE g_id INT;
  DECLARE mode_id INT;
  DECLARE p_num INT; 
  DECLARE cur_unit1_id,cur_unit2_id INT;
  DECLARE cur_push_id INT;
  DECLARE x_min_1, x_max_1, y_min_1, y_max_1, x_min_2, x_max_2, y_min_2, y_max_2 INT; 
  DECLARE push_x,push_y INT DEFAULT 0;
  DECLARE unit_to_move_id INT;
  DECLARE move_x,move_y INT;
  DECLARE cur_sink_flag INT;

  DECLARE success INT;

  DECLARE done INT DEFAULT 0;

  DECLARE cur CURSOR FOR
    SELECT unit_id,x,y,sink_flag FROM move_queue ORDER BY id DESC;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SET success=1;

  CREATE TEMPORARY TABLE pushing_queue(
    id INT AUTO_INCREMENT PRIMARY KEY,
    `unit1_id` INT NOT NULL,
    `unit2_id` INT NOT NULL) ENGINE=MEMORY;

  CREATE TEMPORARY TABLE move_queue(
    id INT AUTO_INCREMENT PRIMARY KEY,
    `unit_id` INT NOT NULL,
    `x` INT NOT NULL,
    `y` INT NOT NULL,
    `sink_flag` INT NULL) ENGINE=MEMORY;

  SELECT bu.game_id INTO g_id FROM board_units bu WHERE bu.id=board_unit_id_1 LIMIT 1;
  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;

  INSERT INTO pushing_queue(unit1_id,unit2_id) VALUES (board_unit_id_1,board_unit_id_2);

  REPEAT

    SELECT q.unit1_id,q.unit2_id,q.id INTO cur_unit1_id,cur_unit2_id,cur_push_id FROM pushing_queue q ORDER BY q.id LIMIT 1;
    DELETE FROM pushing_queue WHERE id=cur_push_id;

    SELECT MIN(x),MAX(x),MIN(y),MAX(y)
      INTO x_min_1, x_max_1, y_min_1, y_max_1
      FROM board b
      WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=cur_unit1_id;

    SELECT MIN(x),MAX(x),MIN(y),MAX(y)
      INTO x_min_2, x_max_2, y_min_2, y_max_2
      FROM board b
      WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=cur_unit2_id;

    
    SET push_x=0;
    SET push_y=0;
    IF(x_max_2<x_min_1)THEN 
      SET push_x=-1;
    END IF;
    IF(x_min_2>x_max_1)THEN 
      SET push_x=1;
    END IF;
    IF(y_max_2<y_min_1)THEN 
      SET push_y=-1;
    END IF;
    IF(y_min_2>y_max_1)THEN 
      SET push_y=1;
    END IF;

    IF 
    (SELECT COUNT(*) FROM allcoords a
        WHERE a.mode_id=mode_id
          AND a.x BETWEEN x_min_2+push_x AND x_max_2+push_x
          AND a.y BETWEEN y_min_2+push_y AND y_max_2+push_y)<>((x_max_2-x_min_2+1) * (y_max_2-y_min_2+1))
    THEN
      SET success=0;
    ELSE
      IF 
      EXISTS
      (
        SELECT 1 FROM board b
          WHERE b.game_id=g_id AND b.`type`<>'unit'
            AND b.x BETWEEN x_min_2+push_x AND x_max_2+push_x
            AND b.y BETWEEN y_min_2+push_y AND y_max_2+push_y
      )
      THEN
        IF 
          NOT EXISTS
          (SELECT 1 FROM board b
            WHERE b.game_id=g_id AND b.`type`<>'unit'
              AND b.x BETWEEN x_min_2+push_x AND x_max_2+push_x
              AND b.y BETWEEN y_min_2+push_y AND y_max_2+push_y
              AND building_feature_check(b.ref,'water')=0 
          )
        THEN
          
          INSERT INTO move_queue(unit_id,x,y,sink_flag) VALUES(cur_unit2_id,x_min_2+push_x,y_min_2+push_y,1);
        ELSE
          SET success=0;
        END IF;
      ELSE

        INSERT INTO move_queue(unit_id,x,y) VALUES(cur_unit2_id,x_min_2+push_x,y_min_2+push_y);

        
        INSERT INTO pushing_queue(unit1_id,unit2_id)
        SELECT cur_unit2_id,b.ref FROM board b
          WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref<>cur_unit2_id
            AND b.x BETWEEN x_min_2+push_x AND x_max_2+push_x
            AND b.y BETWEEN y_min_2+push_y AND y_max_2+push_y;

      END IF;
    END IF;

  UNTIL success=0 OR NOT EXISTS(SELECT 1 FROM pushing_queue LIMIT 1) END REPEAT;

  IF(success=1)THEN

    SELECT bu.player_num INTO p_num FROM board_units bu WHERE bu.id=board_unit_id_1 LIMIT 1;
    CALL cmd_log_add_message(g_id, p_num, 'unit_pushes', CONCAT_WS(',', log_unit(board_unit_id_1), log_unit(board_unit_id_2)));
    
    OPEN cur;
    REPEAT
      FETCH cur INTO unit_to_move_id,move_x,move_y,cur_sink_flag;
      IF NOT done THEN
        CALL move_unit(unit_to_move_id,move_x,move_y);
        IF(cur_sink_flag IS NOT NULL)THEN
          CALL sink_unit(unit_to_move_id,p_num);
        END IF;
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur;

  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`user_action_end` $$

CREATE PROCEDURE `user_action_end`()
BEGIN

  INSERT INTO log_commands(game_id,player_num,command,hidden_flag)
  SELECT
    command.game_id,
    command.player_num,
    command.command,
    command.hidden_flag
  FROM command WHERE
    command.command LIKE 'log_add_message%'
    OR
    command.command LIKE 'log_add_independent_message%'
    OR
    command.command LIKE 'log_add_container%'
    OR
    command.command LIKE 'log_close_container%'
    OR
    command.command LIKE 'log_add_move_message%'
    OR
    command.command LIKE 'log_add_attack_unit_message%'
    OR
    command.command LIKE 'log_add_attack_building_message%';

  SELECT p.user_id, command, hidden_flag
  FROM command c LEFT JOIN players p ON (c.game_id=p.game_id AND c.player_num=p.player_num);

  DROP TEMPORARY TABLE `lords`.`command`;

END$$

DROP PROCEDURE IF EXISTS `lords`.`vampire_resurrect_by_card` $$

CREATE PROCEDURE `vampire_resurrect_by_card`(vamp_board_id INT,  grave_id INT)
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
  DECLARE u_id INT;
  DECLARE vamp_name VARCHAR(45) CHARSET utf8 DEFAULT 'Вампир $u_name';

  IF ((SELECT FLOOR(1 + (RAND() * dice_max)) FROM DUAL)>chance) THEN 
    SELECT bu.game_id,bu.player_num,p.team INTO g_id,p_num,team FROM board_units bu JOIN players p ON (bu.game_id=p.game_id AND bu.player_num=p.player_num) WHERE bu.id=vamp_board_id LIMIT 1;

    SELECT CASE WHEN MAX(p.player_num)<10 THEN 10 ELSE MAX(p.player_num)+1 END INTO new_player FROM players p WHERE p.game_id=g_id;

    SELECT g.card_id INTO dead_card_id FROM graves g WHERE id=grave_id;
    SELECT c.ref INTO u_id FROM cards c WHERE c.id=dead_card_id LIMIT 1;

    SET vamp_name=REPLACE(vamp_name,'$u_name',(SELECT ui_code FROM units WHERE id=u_id LIMIT 1));

    INSERT INTO players(game_id,player_num,name,gold,owner,team) VALUES(g_id,new_player,vamp_name,0,vamp_owner,team);

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

CREATE PROCEDURE `vampire_resurrect_by_u_id`(vamp_board_id INT, u_id INT, x INT, y INT)
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
  DECLARE size INT;
  DECLARE vamp_name VARCHAR(45) CHARSET utf8 DEFAULT 'Вампир $u_name';

  IF ((SELECT FLOOR(1 + (RAND() * dice_max)) FROM DUAL)>chance) THEN 
    SELECT bu.game_id,bu.player_num,p.team INTO g_id,p_num,team FROM board_units bu JOIN players p ON (bu.game_id=p.game_id AND bu.player_num=p.player_num) WHERE bu.id=vamp_board_id LIMIT 1;
    SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;

    SELECT CASE WHEN MAX(p.player_num)<10 THEN 10 ELSE MAX(p.player_num)+1 END INTO new_player FROM players p WHERE p.game_id=g_id;

    SET vamp_name=REPLACE(vamp_name,'$u_name',(SELECT ui_code FROM units WHERE id=u_id LIMIT 1));

    INSERT INTO players(game_id,player_num,name,gold,owner,team) VALUES(g_id,new_player,vamp_name,0,vamp_owner,team);

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

DROP PROCEDURE IF EXISTS `lords`.`vred_player_takes_card_from_everyone` $$

CREATE PROCEDURE `vred_player_takes_card_from_everyone`(g_id INT, p_num INT)
BEGIN
  DECLARE p2_num INT; 
  DECLARE random_card INT;
  DECLARE player_deck_id INT;

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT DISTINCT p.player_num FROM player_deck p WHERE p.game_id=g_id AND p.player_num<>p_num;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;
    REPEAT
      FETCH cur INTO p2_num;
      IF NOT done THEN
        SELECT id,card_id INTO player_deck_id,random_card FROM player_deck p WHERE p.game_id=g_id AND p.player_num=p2_num ORDER BY RAND() LIMIT 1;
        UPDATE player_deck SET player_num=p_num WHERE id=player_deck_id;

        CALL cmd_add_card(g_id,p_num,player_deck_id);
        CALL cmd_remove_card(g_id,p2_num,player_deck_id);

        CALL cmd_log_add_message_hidden(g_id, p_num, 'vred_got_card_from', CONCAT_WS(',', p2_num, random_card));
        CALL cmd_log_add_message_hidden(g_id, p2_num, 'vred_gave_card_to', CONCAT_WS(',', p_num, random_card));
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur;

END$$

DROP PROCEDURE IF EXISTS `lords`.`vred_pooring` $$

CREATE PROCEDURE `vred_pooring`(g_id INT, p_num INT)
BEGIN
  DECLARE pooring_sum INT DEFAULT 60;

  UPDATE players SET gold=CASE WHEN gold<pooring_sum THEN 0 ELSE gold-pooring_sum END WHERE game_id=g_id AND player_num=p_num;
  CALL cmd_player_set_gold(g_id,p_num);
  CALL cmd_log_add_message(g_id, p_num, 'player_loses_gold', CONCAT_WS(',', p_num, pooring_sum));

END$$

DROP PROCEDURE IF EXISTS `lords`.`wall_close` $$

CREATE PROCEDURE `wall_close`(g_id INT, p_num INT, x INT, y INT)
BEGIN
  DECLARE g_mode INT;
  DECLARE err_code INT;
  DECLARE board_building_id INT;
  DECLARE current_turn INT;
  DECLARE old_wall_building_id INT;
  DECLARE new_wall_building_id INT;
  DECLARE rotation,flip,x_min,y_min INT;

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
      CALL user_action_begin();

      DELETE FROM board WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0; 

      IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
        CALL start_moving_units(g_id,p_num);
      END IF;

      CALL cmd_destroy_building(g_id,p_num,board_building_id);
      CALL cmd_put_building_by_id(g_id,p_num,board_building_id);
      CALL cmd_building_set_health(g_id,p_num,board_building_id);

      CALL building_feature_set(board_building_id,'turn_when_changed',current_turn);

      CALL cmd_log_add_message(g_id, p_num, 'building_closes', log_building(board_building_id));

      CALL user_action_end();
    END IF;
  END IF;
END$$

DROP PROCEDURE IF EXISTS `lords`.`wall_open` $$

CREATE PROCEDURE `wall_open`(g_id INT, p_num INT, x INT, y INT)
BEGIN
  DECLARE g_mode INT;
  DECLARE err_code INT;
  DECLARE board_building_id INT;
  DECLARE current_turn INT;
  DECLARE old_wall_building_id INT;
  DECLARE new_wall_building_id INT;
  DECLARE rotation,flip,x_min,y_min INT;

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
      CALL user_action_begin();

      DELETE FROM board WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0; 

      IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
        CALL start_moving_units(g_id,p_num);
      END IF;

      CALL cmd_destroy_building(g_id,p_num,board_building_id);
      CALL cmd_put_building_by_id(g_id,p_num,board_building_id);
      CALL cmd_building_set_health(g_id,p_num,board_building_id);

      CALL building_feature_set(board_building_id,'turn_when_changed',current_turn);

      CALL cmd_log_add_message(g_id, p_num, 'building_opens', log_building(board_building_id));

      CALL user_action_end();
    END IF;
  END IF;
END$$

DROP PROCEDURE IF EXISTS `lords`.`wizard_fireball` $$

CREATE PROCEDURE `wizard_fireball`(g_id INT, p_num INT, x INT, y INT,  x2 INT,  y2 INT)
BEGIN
  DECLARE err_code INT;
  DECLARE aim_bu_id INT;
  DECLARE board_unit_id INT;
  DECLARE dice INT;
  DECLARE fb_damage INT DEFAULT 1;
  DECLARE health_before_hit,health_after_hit,experience INT;

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'wizard_fireball'); 
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
      SELECT b.ref INTO aim_bu_id FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.x=x2 AND b.y=y2 LIMIT 1;
      IF aim_bu_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=33;
      ELSE
        CALL user_action_begin();

        IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
          CALL start_moving_units(g_id,p_num);
        END IF;

        SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;
        SELECT bu.health INTO health_before_hit FROM board_units bu WHERE bu.id=aim_bu_id LIMIT 1;

        UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
        CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

        CALL cmd_log_add_message(g_id, p_num, 'unit_casts_fb', CONCAT_WS(',', log_unit(board_unit_id), log_unit(aim_bu_id)));

        SELECT FLOOR(1 + (RAND() * 6)) INTO dice FROM DUAL;

        IF dice=1 THEN 
          IF (SELECT FLOOR(1 + (RAND() * 6)) as `dice` FROM DUAL)<6 THEN
            CALL cmd_log_add_message(g_id, p_num, 'miss_rus_rul', log_unit(board_unit_id));
          ELSE
            CALL kill_unit(board_unit_id,p_num);
          END IF;
        ELSE
          IF dice IN (5,6) THEN 
            IF (SELECT FLOOR(1 + (RAND() * 6)) as `dice` FROM DUAL)<3 THEN
              CALL cmd_miss_game_log(g_id,x2,y2);
            ELSE
              CALL magical_damage(g_id,p_num,x2,y2,fb_damage);
              SELECT bu.health INTO health_after_hit FROM board_units bu WHERE bu.id=aim_bu_id LIMIT 1;
              IF (health_after_hit IS NULL) THEN
                SET health_after_hit = 0;
              END IF;
              
              SET experience = health_before_hit - health_after_hit;
              IF(health_after_hit = 0)THEN
                SET experience = experience + 1;
              END IF;
              IF(experience > 0)THEN
                CALL unit_add_exp(board_unit_id, experience);
              END IF;
            END IF;
          ELSE 
            CALL cmd_log_add_message(g_id, p_num, 'cast_unsuccessful', NULL);
          END IF;
        END IF;

        INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'magical_attack');

        IF (check_all_units_moved(g_id,p_num) = 1) THEN
          CALL finish_moving_units(g_id,p_num);
          CALL end_units_phase(g_id,p_num);
        END IF;

        CALL user_action_end();
      END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`wizard_heal` $$

CREATE PROCEDURE `wizard_heal`(g_id INT, p_num INT, x INT, y INT,  x2 INT,  y2 INT)
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
        CALL user_action_begin();

        IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
          CALL start_moving_units(g_id,p_num);
        END IF;

        SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;

        UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
        CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

        CALL cmd_log_add_message(g_id, p_num, 'unit_heals', CONCAT_WS(',', log_unit(board_unit_id), log_unit(aim_bu_id)));

        CALL magical_heal(g_id,p_num,x2,y2,hp_heal);

        IF (check_all_units_moved(g_id,p_num) = 1) THEN
          CALL finish_moving_units(g_id,p_num);
          CALL end_units_phase(g_id,p_num);
        END IF;

        CALL user_action_end();
      END IF;
    END IF;
  END IF;

END$$

DROP FUNCTION IF EXISTS `lords`.`log_cell` $$

CREATE FUNCTION `log_cell`(x INT,  y INT) RETURNS varchar(50) CHARSET utf8
BEGIN
  RETURN CONCAT('{"type":"cell","x":', x, ',"y":' y, '}');
END$$

DROP FUNCTION IF EXISTS `lords`.`log_unit` $$

CREATE FUNCTION `log_unit`(board_unit_id INT) RETURNS varchar(200) CHARSET utf8
BEGIN
  DECLARE u_id INT;
  DECLARE p_num INT;
  DECLARE x INT;
  DECLARE y INT;
  
  SELECT unit_id, player_num INTO u_id, p_num FROM board_units bu WHERE bu.id = board_unit_id;
  SELECT b.x, b.y INTO x, y FROM board b WHERE b.type = 'unit' AND b.ref = board_unit_id LIMIT 1;
  RETURN CONCAT('{"type":"unit","board_id":', board_unit_id, '"player_num":', p_num, ',"unit_id":', u_id, ',"x":', x, ',"y":' y, '}');
END$$

DROP FUNCTION IF EXISTS `lords`.`log_building` $$

CREATE FUNCTION `log_building`(board_building_id INT) RETURNS varchar(200) CHARSET utf8
BEGIN
  DECLARE b_id INT;
  DECLARE p_num INT;
  DECLARE x INT;
  DECLARE y INT;
  DECLARE obj_type VARCHAR(45);
  
  SELECT building_id, player_num INTO b_id, p_num FROM board_buildings bb WHERE bb.id = board_building_id;
  SELECT b.x, b.y, b.type INTO x, y, obj_type FROM board b WHERE b.type != 'unit' AND b.ref = board_building_id LIMIT 1;
  RETURN CONCAT('{"type":"', obj_type, '","board_id":', board_building_id, '"player_num":', p_num, ',"building_id":', b_id, ',"x":', x, ',"y":' y, '}');
END$$

