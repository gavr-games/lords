use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`get_unit_appear_point_near_castle` $$

CREATE PROCEDURE `get_unit_appear_point_near_castle`(g_id INT, p_num INT, unit_id INT, OUT x INT, OUT y INT)
BEGIN
  DECLARE g_mode INT;
  DECLARE size INT;

  SELECT mode_id INTO g_mode FROM games WHERE id=g_id LIMIT 1;
  SELECT u.size INTO size FROM units u WHERE u.id = unit_id LIMIT 1;

  SELECT
    LEAST(ap.x, ap.x + direction_into_board_x * (size - 1)),
    LEAST(ap.y, ap.y + direction_into_board_y * (size - 1))
  INTO x, y
    FROM appear_points ap WHERE ap.mode_id = g_mode AND ap.player_num = p_num LIMIT 1;

END$$


DROP PROCEDURE IF EXISTS `lords`.`create_new_unit` $$

CREATE PROCEDURE `create_new_unit`(g_id INT, p_num INT, unit_id INT, card_id INT, x INT, y INT, log_unit_appears INT)
BEGIN
  DECLARE bu_id INT;
  DECLARE size INT;
  DECLARE mode_id INT;

  INSERT INTO board_units(game_id, player_num, unit_id, card_id)
    VALUES (g_id, p_num, IFNULL(unit_id, 0), card_id);
  SET bu_id = LAST_INSERT_ID();
  SELECT bu.unit_id INTO unit_id FROM board_units bu WHERE bu.id = bu_id;

  INSERT INTO board_units_features(board_unit_id, feature_id, param)
    SELECT bu_id, ufu.feature_id, ufu.param FROM unit_default_features ufu WHERE ufu.unit_id = unit_id;

  SELECT u.size INTO size FROM units u WHERE u.id = unit_id LIMIT 1;
  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id = g_id LIMIT 1;

  INSERT INTO board(game_id, x, y, `type`, ref)
    SELECT g_id, a.x, a.y, 'unit', bu_id FROM allcoords a
      WHERE a.mode_id = mode_id AND a.x BETWEEN x AND x+size-1 AND a.y BETWEEN y AND y+size-1;

  IF card_id IS NOT NULL THEN
    CALL cmd_add_unit(g_id, p_num, bu_id);
  ELSE
    CALL cmd_add_unit_by_id(g_id, p_num, bu_id);
  END IF;

  IF log_unit_appears THEN
    IF((SELECT current_procedure FROM active_players WHERE game_id = g_id LIMIT 1) = 'end_turn')THEN
      CALL cmd_log_add_independent_message(g_id, p_num, 'unit_appears_in_cell', CONCAT_WS(';', log_unit(bu_id), log_cell(x,y)));
    ELSE
      CALL cmd_log_add_message(g_id, p_num, 'unit_appears_in_cell', CONCAT_WS(';', log_unit(bu_id), log_cell(x,y)));
    END IF;
  END IF;

  IF check_unit_in_paralysing_range(bu_id) THEN
    CALL paralyse_unit(bu_id);
  END IF;

  SET @new_board_unit_id = bu_id;

END$$

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

END$$


DROP PROCEDURE IF EXISTS `lords`.`resurrect` $$

CREATE PROCEDURE `resurrect`(g_id INT, p_num INT, grave_id INT)
BEGIN
  DECLARE dead_card_id INT;
  DECLARE u_id INT;
  DECLARE new_unit_id INT;
  DECLARE x_appear, y_appear INT;

  SELECT g.card_id INTO dead_card_id FROM graves g WHERE id = grave_id LIMIT 1;
  SELECT c.ref INTO u_id FROM cards c WHERE c.id = dead_card_id LIMIT 1;
  CALL get_unit_appear_point_near_castle(g_id, p_num, u_id, x_appear, y_appear);

  CALL create_new_unit(g_id, p_num, NULL, dead_card_id, x_appear, y_appear, 0);
  SET new_unit_id = @new_board_unit_id;

  UPDATE board_units SET moves_left=0 WHERE id=new_unit_id;
  CALL cmd_unit_set_moves_left(g_id,p_num,new_unit_id);

  DELETE FROM graves WHERE game_id=g_id AND id=grave_id;
  CALL cmd_remove_from_grave(g_id,p_num,grave_id);

  INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'resurrect_unit',u_id);
END$$

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

END$$


DROP PROCEDURE IF EXISTS `lords`.`summon_unit` $$

CREATE PROCEDURE `summon_unit`(g_id INT,  p_num INT,  player_deck_id INT)
BEGIN
  DECLARE crd_id INT;
  DECLARE err_code INT;
  DECLARE x_appear,y_appear INT;
  DECLARE size INT;
  DECLARE new_unit_id INT;
  DECLARE u_id INT;

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
    VALUES(g_id, p_num, name, 0, 2, team, new_move_order, language_id);

  CALL cmd_add_player(g_id, p_num);
  SET @new_player_num = p_num;
  
END$$

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

END$$


DROP PROCEDURE IF EXISTS `lords`.`summon_creature` $$

CREATE PROCEDURE `summon_creature`(g_id INT,    cr_owner INT ,   cr_unit_id INT ,   x INT ,   y INT,    parent_building_id INT)
BEGIN
  DECLARE new_player, team INT;
  DECLARE new_unit_id INT;
  DECLARE cr_player_name VARCHAR(45) CHARSET utf8;

  SET team = building_feature_get_param(parent_building_id, 'summon_team');
  SET cr_player_name = CONCAT('{', cr_unit_id, '}');

  CALL create_new_player(g_id, cr_player_name, team, cr_owner, get_player_language_id(g_id, get_current_p_num(g_id)));
  SET new_player = @new_player_num;

  CALL create_new_unit(g_id, new_player, cr_unit_id, NULL, x, y, 1);
  SET new_unit_id = @new_board_unit_id;
  CALL unit_feature_set(new_unit_id, 'parent_building', parent_building_id);
END$$

DROP PROCEDURE IF EXISTS `lords`.`attack_actions` $$

CREATE PROCEDURE `attack_actions`(board_unit_id INT,    aim_type VARCHAR(45),    aim_board_id INT)
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
  DECLARE aim_cannot_be_vampired INT;
  DECLARE grave_id INT;
  DECLARE aim_no_exp INT DEFAULT 0;

  DECLARE damage INT;
  DECLARE attack_success,critical INT;

  DECLARE cmd_log_unit VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_attack_unit_message($x,$y,$x2,$y2,$p_num,$unit_id,$p2_num,$aim_unit_id,$attack_success,$critical,$damage,"$npc_name","$npc2_name")';
  DECLARE cmd_log_building VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_attack_building_message($x,$y,$x2,$y2,$p_num,$unit_id,$p2_num,$aim_building_id,$attack_success,$critical,$damage,"$npc_name")';
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8;

  SET cmd_log='log_add_attack_unit_message($x,$y,$x2,$y2,$p_num,$p2_num,$attack_success,$critical,$damage)';

  SELECT bu.game_id,bu.player_num,bu.unit_id INTO g_id,p_num,u_id FROM board_units bu JOIN games g ON (bu.game_id=g.id) WHERE bu.id=board_unit_id LIMIT 1;

  CASE
    WHEN aim_type='unit' THEN
    BEGIN
      SELECT bu.player_num,bu.unit_id,bu.health,bu.card_id,shield INTO p2_num,aim_object_id,health_before_hit,aim_card_id,aim_shield FROM board_units bu WHERE bu.id=aim_board_id LIMIT 1;
      SET aim_goes_to_deck = unit_feature_check(aim_board_id,'goes_to_deck_on_death');
      SET aim_cannot_be_vampired = unit_feature_check(aim_board_id,'mechanical') + unit_feature_check(aim_board_id,'magic_immunity');
      SELECT MIN(b.x),MIN(b.y) INTO aim_x,aim_y FROM board b WHERE b.game_id=g_id AND b.`type`=aim_type AND b.ref=aim_board_id;
      SET cmd_log = REPLACE(cmd_log_unit, '$aim_unit_id', aim_object_id);
      IF ((SELECT p.owner FROM players p WHERE p.game_id = g_id AND p.player_num = p2_num LIMIT 1) <> 1) THEN
        SET cmd_log=REPLACE(cmd_log,'$npc2_name', (SELECT p.name FROM players p WHERE p.game_id = g_id AND p.player_num = p2_num LIMIT 1));
      ELSE
        SET cmd_log=REPLACE(cmd_log,'$npc2_name', '');
      END IF;
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
      IF ((SELECT p.owner FROM players p WHERE p.game_id = g_id AND p.player_num = p_num LIMIT 1) <> 1) THEN
        SET cmd_log=REPLACE(cmd_log,'$npc_name', (SELECT p.name FROM players p WHERE p.game_id = g_id AND p.player_num = p_num LIMIT 1));
      ELSE
        SET cmd_log=REPLACE(cmd_log,'$npc_name', '');
      END IF;

      INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

  IF critical=1 THEN
    INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'critical_hit');
  END IF;

      IF attack_success=1 THEN 

        
        IF(aim_type='unit' AND unit_feature_check(aim_board_id,'agressive')=1) THEN 
          CALL unit_feature_set(aim_board_id,'attack_target',board_unit_id);
        END IF;

        IF(aim_type='building' AND building_feature_check(aim_board_id,'no_exp')=1) THEN 
          SET aim_no_exp = 1;
        END IF;

        CASE aim_type
          WHEN 'unit' THEN CALL hit_unit(aim_board_id,p_num,damage);
          WHEN 'building' THEN CALL hit_building(aim_board_id,p_num,damage);
          WHEN 'castle' THEN CALL hit_castle(aim_board_id,p_num,damage);
        END CASE;

        SET health_after_hit = get_health_after_hit(aim_board_id, aim_type);

        SET experience = get_experience_for_hitting(aim_board_id, aim_type, health_before_hit);
        IF(experience > 0 AND aim_no_exp = 0 AND EXISTS(SELECT id FROM board_units WHERE id=board_unit_id))THEN
          CALL unit_add_exp(board_unit_id, experience);
        END IF;

        IF (aim_type='unit') THEN

          IF (unit_feature_check(board_unit_id,'drink_health')=1) AND (health_after_hit<health_before_hit)THEN
            CALL drink_health(board_unit_id);
          END IF;


          IF unit_feature_check(board_unit_id,'vamp')
             AND (health_after_hit = 0)
             AND NOT aim_cannot_be_vampired
             AND get_random_int_between(1, 2) > 1
          THEN
            IF (aim_card_id IS NOT NULL AND NOT aim_goes_to_deck) THEN
              SELECT gc.grave_id INTO grave_id FROM graves g JOIN grave_cells gc ON g.id=gc.grave_id WHERE g.game_id=g_id AND g.card_id=aim_card_id AND gc.x=aim_x AND gc.y=aim_y LIMIT 1;
              CALL vampire_resurrect(board_unit_id, grave_id, NULL, aim_x, aim_y);
            ELSE
              CALL vampire_resurrect(board_unit_id, NULL, aim_object_id, aim_x, aim_y);
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

DROP PROCEDURE IF EXISTS `lords`.`vampire_resurrect_by_card` $$
DROP PROCEDURE IF EXISTS `lords`.`vampire_resurrect_by_u_id` $$
DROP PROCEDURE IF EXISTS `lords`.`vampire_resurrect` $$

CREATE PROCEDURE `vampire_resurrect`(vamp_board_id INT, grave_id INT, u_id INT, x INT, y INT)
BEGIN
  DECLARE dead_card_id INT;
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE vamp_owner INT DEFAULT 4;
  DECLARE new_player INT;
  DECLARE new_unit_id INT;
  DECLARE vamp_name VARCHAR(45) CHARSET utf8 DEFAULT '{vampire} {$u_id}';

  SELECT bu.game_id, bu.player_num INTO g_id, p_num FROM board_units bu WHERE bu.id=vamp_board_id LIMIT 1;

  IF grave_id IS NOT NULL THEN
    SELECT g.card_id INTO dead_card_id FROM graves g WHERE id=grave_id;
    SELECT c.ref INTO u_id FROM cards c WHERE c.id=dead_card_id LIMIT 1;

    DELETE FROM graves WHERE game_id=g_id AND id=grave_id;
    CALL cmd_remove_from_grave(g_id,p_num,grave_id);
  END IF;

  SET vamp_name=REPLACE(vamp_name,'$u_id', u_id);

  CALL create_new_player(g_id, vamp_name, get_unit_team(vamp_board_id), vamp_owner, get_player_language_id(g_id, p_num));
  SET new_player = @new_player_num;

  IF grave_id IS NOT NULL THEN
    CALL create_new_unit(g_id, new_player, NULL, dead_card_id, x, y, 0);
  ELSE
    CALL create_new_unit(g_id, new_player, u_id, NULL, x, y, 0);
  END IF;
  SET new_unit_id = @new_board_unit_id;

  CALL unit_feature_set(new_unit_id, 'vamp', NULL);

  CALL cmd_log_add_message(g_id, p_num, 'unit_becomes_vampire', log_unit(new_unit_id));
END$$


DROP PROCEDURE IF EXISTS `lords`.`paralyse_unit` $$

CREATE PROCEDURE `paralyse_unit`(board_unit_id INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE shield INT;

  SELECT bu.game_id, bu.player_num INTO g_id, p_num FROM board_units bu WHERE bu.id = board_unit_id LIMIT 1;

  SELECT bu.shield INTO shield FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

  IF unit_feature_check(board_unit_id,'magic_immunity') = 0 THEN
    IF shield > 0 THEN
      CALL shield_off(board_unit_id);
    ELSE
      CALL unit_feature_set(board_unit_id,'paralich',null);
      CALL cmd_unit_add_effect(g_id, board_unit_id,'paralich');
    END IF;
  ELSE
    CALL cmd_magic_resistance_log(g_id, p_num, board_unit_id);
  END IF;

END$$


DROP PROCEDURE IF EXISTS `lords`.`cast_paralich` $$

CREATE PROCEDURE `cast_paralich`(g_id INT,  p_num INT,  player_deck_id INT,  x INT,  y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE shield INT;

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

END$$


DROP PROCEDURE IF EXISTS `lords`.`buidling_paralyse_enemies` $$

CREATE PROCEDURE `buidling_paralyse_enemies`(board_building_id INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;

  DECLARE radius INT;
  DECLARE building_x, building_y INT;

  DECLARE board_unit_id INT;

  DECLARE done INT DEFAULT 0;

  DECLARE cur CURSOR FOR
    SELECT bu.id
      FROM board b
      JOIN board_units bu ON (b.ref=bu.id)
    WHERE
      b.game_id = g_id
      AND b.`type`='unit'
      AND b.x BETWEEN building_x - radius AND building_x + radius
      AND b.y BETWEEN building_y - radius AND building_y + radius
      AND get_unit_team(bu.id) <> get_player_team(g_id, p_num)
      AND unit_feature_check(bu.id, 'paralich') = 0;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  IF check_building_deactivated(board_building_id) = 0 THEN
    SELECT bb.radius, bb.player_num, bb.game_id INTO radius, p_num, g_id FROM board_buildings bb
      WHERE bb.id = board_building_id LIMIT 1;
    SELECT b.x, b.y INTO building_x, building_y FROM board b
      WHERE b.game_id = g_id AND b.ref = board_building_id AND b.`type`<>'unit' LIMIT 1;

    OPEN cur;
    REPEAT
      FETCH cur INTO board_unit_id;
      IF NOT done THEN
        CALL paralyse_unit(board_unit_id);
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`put_building` $$

CREATE PROCEDURE `put_building`(g_id INT,    p_num INT,    player_deck_id INT,    x INT,    y INT,    rotation INT,    flip INT)
BEGIN
  DECLARE crd_id INT;
  DECLARE err_code INT;
  DECLARE x_len,y_len INT;
  DECLARE x2,y2 INT; 
  DECLARE new_building_id INT;

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
END$$

DROP PROCEDURE IF EXISTS `lords`.`cast_relocation` $$

CREATE PROCEDURE `cast_relocation`(g_id INT,  p_num INT,  player_deck_id INT,  b_x INT,  b_y INT,  x INT,  y INT,  rot INT,  flp INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_building_id INT;
  DECLARE log_msg_code VARCHAR(50) CHARSET utf8 DEFAULT 'building_moved';

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
END$$


DROP PROCEDURE IF EXISTS `lords`.`cast_capture` $$

CREATE PROCEDURE `cast_capture`(g_id INT,  p_num INT,  player_deck_id INT,  b_x INT,  b_y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_building_id INT;
  DECLARE log_msg_code VARCHAR(50) CHARSET utf8 DEFAULT 'building_captured';

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
END$$

DROP FUNCTION IF EXISTS `lords`.`check_unit_in_paralysing_range` $$

CREATE FUNCTION `check_unit_in_paralysing_range`(board_unit_id INT) RETURNS int(11)
BEGIN
  RETURN EXISTS
  (
    SELECT 1 FROM
      board_units bu
      JOIN board b_unit ON (bu.id = b_unit.ref AND b_unit.type = 'unit')
      JOIN board_buildings bb ON (bb.game_id = bu.game_id)
      JOIN board b_building ON (bb.id = b_building.ref AND b_building.type <> 'unit')
      WHERE
        bu.id = board_unit_id
        AND building_feature_check(bb.id, 'paralysing')
        AND NOT check_building_deactivated(bb.id)
        AND get_unit_team(bu.id) <> get_building_team(bb.id)
        AND NOT unit_feature_check(bu.id, 'paralich')
        AND b_unit.x BETWEEN b_building.x - bb.radius AND b_building.x + bb.radius
        AND b_unit.y BETWEEN b_building.y - bb.radius AND b_building.y + bb.radius
  );
END$$

DROP PROCEDURE IF EXISTS `lords`.`move_unit` $$

CREATE PROCEDURE `move_unit`(board_unit_id INT,  x2 INT,  y2 INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE x,y INT;
  DECLARE delta_x,delta_y INT;
  DECLARE u_id INT;

  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_move_message($x,$y,$x2,$y2,$p_num,$unit_id,"$npc_name")';

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
  IF ((SELECT p.owner FROM players p WHERE p.game_id = g_id AND p.player_num = p_num LIMIT 1) <> 1) THEN
    SET cmd_log=REPLACE(cmd_log,'$npc_name', (SELECT p.name FROM players p WHERE p.game_id = g_id AND p.player_num = p_num LIMIT 1));
  ELSE
    SET cmd_log=REPLACE(cmd_log,'$npc_name', '');
  END IF;
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);
  
  IF check_unit_in_paralysing_range(board_unit_id) THEN
    CALL paralyse_unit(board_unit_id);
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`zombies_make_mad` $$

CREATE PROCEDURE `zombies_make_mad`(g_id INT,  nec_board_id INT)
BEGIN
  DECLARE zombie_board_id INT;
  DECLARE zombie_u_id INT;
  DECLARE zombie_p_num INT;
  DECLARE new_move_order INT;
  DECLARE new_player, team INT;
  DECLARE zombie_name_template VARCHAR(45) CHARSET utf8 DEFAULT '{zombie} {$u_id}';
  DECLARE zombie_name VARCHAR(45) CHARSET utf8;

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR
    SELECT buf.board_unit_id,bu.player_num,bu.unit_id
    FROM board_units_features buf JOIN board_units bu ON (buf.board_unit_id=bu.id)
    WHERE buf.feature_id=unit_feature_get_id_by_code('under_control') AND buf.param=nec_board_id;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  IF EXISTS (SELECT bu.id FROM board_units bu WHERE bu.id=nec_board_id LIMIT 1) THEN
    SET team = get_unit_team(nec_board_id);
  ELSE
    SET team = get_new_team_number(g_id);
  END IF;

  SET done=0;
  OPEN cur;
  REPEAT
    FETCH cur INTO zombie_board_id,zombie_p_num,zombie_u_id;
    IF NOT done THEN

      IF EXISTS(SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id AND bu.player_num=zombie_p_num AND bu.id<>zombie_board_id LIMIT 1)
        OR EXISTS(SELECT bb.id FROM board_buildings bb WHERE bb.game_id=g_id AND bb.player_num=zombie_p_num LIMIT 1)
      THEN
        SET zombie_name = REPLACE(zombie_name_template, '$u_id', zombie_u_id);

        CALL create_new_player(g_id, zombie_name, team, 2, get_player_language_id(g_id, zombie_p_num));
        SET new_player = @new_player_num;

        UPDATE board_units SET player_num=new_player WHERE id=zombie_board_id;
        CALL cmd_unit_set_owner(g_id,zombie_p_num,zombie_board_id);

        IF check_unit_in_paralysing_range(zombie_board_id) THEN
          CALL paralyse_unit(zombie_board_id);
        END IF;

      END IF;
    END IF;
  UNTIL done END REPEAT;
  CLOSE cur;

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
      DECLARE new_player INT;
      DECLARE mad_name VARCHAR(45) CHARSET utf8 DEFAULT '{mad} {$u_id}';

      SET mad_name=REPLACE(mad_name,'$u_id', u_id);
      CALL create_new_player(g_id, mad_name, NULL, 2, get_player_language_id(g_id, p_num));
      SET new_player = @new_player_num;

      UPDATE board_units SET player_num=new_player WHERE id=board_unit_id;
      CALL cmd_unit_set_owner(g_id,p_num,board_unit_id);

      IF EXISTS(SELECT id FROM board_units_features WHERE feature_id=unit_feature_get_id_by_code('under_control') AND param=board_unit_id LIMIT 1)THEN
        CALL zombies_make_mad(g_id,board_unit_id);
      END IF;

      IF check_unit_in_paralysing_range(board_unit_id) THEN
        CALL paralyse_unit(board_unit_id);
      END IF;

    END;
    END IF;
  ELSE
    CALL cmd_log_add_message(g_id, p_num, 'unit_already_mad', log_unit(board_unit_id));
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`zombies_change_player_to_nec` $$

CREATE PROCEDURE `zombies_change_player_to_nec`(nec_board_id INT)
BEGIN
  DECLARE g_id INT;
  DECLARE zombie_board_id INT;
  DECLARE nec_p_num,zombie_p_num INT;
  DECLARE npc_gold INT;

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR
    SELECT buf.board_unit_id,bu.player_num
    FROM board_units_features buf JOIN board_units bu ON (buf.board_unit_id=bu.id)
    WHERE buf.feature_id=unit_feature_get_id_by_code('under_control') AND buf.param=nec_board_id AND bu.player_num<>nec_p_num;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SELECT bu.game_id,bu.player_num INTO g_id,nec_p_num FROM board_units bu WHERE bu.id=nec_board_id LIMIT 1;

    OPEN cur;
    REPEAT
      FETCH cur INTO zombie_board_id,zombie_p_num;
      IF NOT done THEN

          UPDATE board_units SET player_num=nec_p_num,moves_left=0 WHERE id=zombie_board_id;
          CALL cmd_unit_set_owner(g_id,nec_p_num,zombie_board_id);
          CALL cmd_unit_set_moves_left(g_id,nec_p_num,zombie_board_id);

          IF ((SELECT owner FROM players WHERE game_id=g_id AND player_num=zombie_p_num LIMIT 1)<>1)
            AND NOT EXISTS (SELECT id FROM board_units WHERE game_id=g_id AND player_num=zombie_p_num)
            AND NOT EXISTS (SELECT id FROM board_buildings WHERE game_id=g_id AND player_num=zombie_p_num)
          THEN
            SELECT gold INTO npc_gold FROM players WHERE game_id=g_id AND player_num=zombie_p_num LIMIT 1; 
            IF(npc_gold>0)THEN
              UPDATE players SET gold = gold + npc_gold WHERE game_id = g_id AND player_num = nec_p_num;
              CALL cmd_player_set_gold(g_id,nec_p_num);
            END IF;

            DELETE FROM players WHERE game_id=g_id AND player_num=zombie_p_num; 
            CALL cmd_delete_player(g_id,zombie_p_num);
          END IF;

          IF check_unit_in_paralysing_range(zombie_board_id) THEN
            CALL paralyse_unit(zombie_board_id);
          END IF;

      END IF;
    UNTIL done END REPEAT;
    CLOSE cur;


END$$

