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
            CALL cmd_log_add_message(g_id, p_num, 'unit_shoots_unit_miss', CONCAT_WS(',', board_unit_id, aim_bu_id));
            INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'miss_attack');
          ELSE
            CALL cmd_log_add_message(g_id, p_num, 'unit_shoots_unit', CONCAT_WS(',', board_unit_id, aim_bu_id, damage));

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
            CALL cmd_log_add_message(g_id, p_num, 'unit_shoots_unit_miss', CONCAT_WS(',', board_unit_id, aim_bu_id));
            INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'miss_attack');
          ELSE
            CALL cmd_log_add_message(g_id, p_num, 'unit_shoots_unit', CONCAT_WS(',', board_unit_id, aim_bu_id, damage));

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
  DECLARE aim_short_name VARCHAR(45) CHARSET utf8;
  DECLARE health_before_hit,health_after_hit,experience INT;
  DECLARE aim_card_id INT;
  DECLARE aim_x,aim_y INT;
  DECLARE aim_shield INT DEFAULT 0;
  DECLARE aim_goes_to_deck INT;
  DECLARE grave_id INT;

  DECLARE damage INT;
  DECLARE attack_success,critical INT;

  DECLARE cmd_log VARCHAR(1000) CHARSET utf8;

  SET cmd_log='log_add_attack_message($x,$y,$x2,$y2,$p_num,$p2_num,$attack_success,$critical,$damage)';

  SELECT bu.game_id,bu.player_num,bu.unit_id INTO g_id,p_num,u_id FROM board_units bu JOIN games g ON (bu.game_id=g.id) WHERE bu.id=board_unit_id LIMIT 1;

  CASE
    WHEN aim_type='unit' THEN
    BEGIN
      SELECT bu.player_num,bu.unit_id,bu.health,bu.card_id,shield INTO p2_num,aim_object_id,health_before_hit,aim_card_id,aim_shield FROM board_units bu WHERE bu.id=aim_board_id LIMIT 1;
      SET aim_goes_to_deck = unit_feature_check(aim_board_id,'goes_to_deck_on_death');
      SELECT MIN(b.x),MIN(b.y) INTO aim_x,aim_y FROM board b WHERE b.game_id=g_id AND b.`type`=aim_type AND b.ref=aim_board_id;
      SELECT ui_code INTO aim_short_name FROM units WHERE id=aim_object_id LIMIT 1;
    END;
    WHEN aim_type='building' OR aim_type='castle' THEN
    BEGIN
      SELECT bb.player_num,bb.building_id,bb.health INTO p2_num,aim_object_id,health_before_hit FROM board_buildings bb WHERE bb.id=aim_board_id LIMIT 1;
      SELECT b.x,b.y INTO aim_x,aim_y FROM board b WHERE b.game_id=g_id AND b.`type`=aim_type AND b.ref=aim_board_id LIMIT 1;
      SELECT ui_code INTO aim_short_name FROM buildings WHERE id=aim_object_id LIMIT 1;
    END;
  END CASE;

  CALL calculate_attack_damage(board_unit_id,aim_type,aim_board_id,attack_success,damage,critical);

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

    CALL cmd_log_add_independent_message(g_id, p_num, 'building_repair', CONCAT_WS(',', board_building_id, health_repair));

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

        CALL cmd_log_add_message(g_id, p_num, log_msg_code, CONCAT_WS(',', board_unit_id, p_num));

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
  DECLARE building_name VARCHAR(45) CHARSET utf8;

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
            SELECT b.ui_code INTO building_name FROM buildings b WHERE b.id=building_id;
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
        CALL cmd_log_add_message(g_id, p_num, 'miss_rus_rul', board_unit_id);
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
        
        CALL cmd_log_add_message(g_id, p_num, 'unit_appears_in_cell', CONCAT_WS(',', new_unit_id, log_cell(x,y)));

        CALL finish_playing_card(g_id,p_num);
        CALL end_cards_phase(g_id,p_num);

        CALL user_action_end();
      END IF;
    END IF;
  END IF;

END$$

DROP FUNCTION IF EXISTS `lords`.`log_cell` $$

CREATE FUNCTION `log_cell`(x INT,  y INT) RETURNS varchar(10) CHARSET utf8
BEGIN
  RETURN CONCAT_WS(';', x, y);
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
  DECLARE building_name VARCHAR(45) CHARSET utf8;

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
            SELECT b.ui_code INTO building_name FROM buildings b WHERE b.id=building_id;
            SELECT 0 AS `success`, ed.id as `error_code`, building_name as `error_params` FROM error_dictionary ed WHERE id=43;
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
            CALL cmd_log_add_message(g_id, p_num, 'unit_shoots_building_miss', CONCAT_WS(',', board_unit_id, aim_bb_id));
            INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'miss_attack');
          ELSE
            CALL cmd_log_add_message(g_id, p_num, 'unit_shoots_building', CONCAT_WS(',', board_unit_id, aim_bb_id, damage));

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
    CALL cmd_log_add_independent_message(g_id, p_num, 'unit_magic_resistance', board_unit_id);
  ELSE
    CALL cmd_log_add_message(g_id, p_num, 'unit_magic_resistance', board_unit_id);
  END IF;
END$$

DROP PROCEDURE IF EXISTS `lords`.`cmd_mechanical_log` $$

CREATE PROCEDURE `cmd_mechanical_log`(g_id INT, p_num INT,  board_unit_id INT)
BEGIN
  IF((SELECT current_procedure FROM active_players WHERE game_id=g_id LIMIT 1)='end_turn')THEN
    CALL cmd_log_add_independent_message(g_id, p_num, 'unit_mechanical', board_unit_id);
  ELSE
    CALL cmd_log_add_message(g_id, p_num, 'unit_mechanical', board_unit_id);
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
    CALL cmd_log_add_message(g_id, p_num, 'miss_unit', obj_id);
  ELSE
    CALL cmd_log_add_message(g_id, p_num, 'miss_building', obj_id);
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
  CALL cmd_log_add_message(g_id, p_num, 'resurrect', CONCAT_WS(',', p_num, board_unit_id));

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
  CALL cmd_log_add_message(g_id, p2_num, log_key_add_effect, board_unit_id);
    
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
    CALL cmd_log_add_independent_message(g_id, p2_num, log_key_remove_effect, board_unit_id);
  ELSE
    CALL cmd_log_add_message(g_id, p2_num, log_key_remove_effect, board_unit_id);
  END IF;

  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p2_num,cmd);

END$$

# UNFINISHED !!!!!!!!!!!!!!!!!!!!!!!!!!

