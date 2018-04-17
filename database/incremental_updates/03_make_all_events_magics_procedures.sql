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
END$$

DROP PROCEDURE IF EXISTS `lords`.`cast_mind_control` $$

CREATE PROCEDURE `cast_mind_control`(g_id INT,  p_num INT,  player_deck_id INT,  x INT,  y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE p2_num INT;
  DECLARE shield INT;
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
      SELECT bu.shield INTO shield FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

      IF (unit_feature_check(board_unit_id,'magic_immunity')=0) THEN

        IF shield>0 THEN
          CALL shield_off(board_unit_id);
        ELSE

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

DROP PROCEDURE IF EXISTS `lords`.`cast_madness` $$

CREATE PROCEDURE `cast_madness`(g_id INT, p_num INT, player_deck_id INT, x INT, y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE shield INT;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_madness');
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
          CALL make_mad(board_unit_id);
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

DROP PROCEDURE IF EXISTS `lords`.`cast_russian_ruletka` $$

CREATE PROCEDURE `cast_russian_ruletka`(g_id INT,  p_num INT,  player_deck_id INT,  x INT,  y INT)
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
        CALL magic_kill_unit(board_unit_id,p_num);
      END IF;

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`cast_speeding` $$

CREATE PROCEDURE `cast_speeding`(g_id INT, p_num INT, player_deck_id INT, x INT, y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE speed_bonus INT DEFAULT 2;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_speeding');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;

      IF (unit_feature_check(board_unit_id,'magic_immunity')=0) THEN 
        CALL unit_add_moves(board_unit_id, speed_bonus * get_magic_field_factor_at(g_id, x, y));
      ELSE
        CALL cmd_magic_resistance_log(g_id,p_num,board_unit_id);
      END IF;

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`cast_eagerness` $$

CREATE PROCEDURE `cast_eagerness`(g_id INT, p_num INT, player_deck_id INT, x INT, y INT)
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
        IF (SELECT FLOOR(1 + (RAND() * 6)) as `dice` FROM DUAL)<=3 THEN
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

DROP PROCEDURE IF EXISTS `lords`.`cast_unit_upgrade_all` $$

CREATE PROCEDURE `cast_unit_upgrade_all`(g_id INT, p_num INT, player_deck_id INT, x INT, y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE speed_bonus INT DEFAULT 1;
  DECLARE health_bonus INT DEFAULT 1;
  DECLARE attack_bonus INT DEFAULT 1;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_unit_upgrade_all');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;

      IF (unit_feature_check(board_unit_id,'magic_immunity')=0) THEN 
        CALL unit_add_moves(board_unit_id, speed_bonus * get_magic_field_factor_at(g_id, x, y));
        CALL unit_add_health(board_unit_id, health_bonus * get_magic_field_factor_at(g_id, x, y));
        CALL unit_add_attack(board_unit_id, attack_bonus * get_magic_field_factor_at(g_id, x, y));
      ELSE
        CALL cmd_magic_resistance_log(g_id,p_num,board_unit_id);
      END IF;

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`cast_unit_upgrade_random` $$

CREATE PROCEDURE `cast_unit_upgrade_random`(g_id INT, p_num INT, player_deck_id INT, x INT, y INT)
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
        SELECT FLOOR(1 + (RAND() * 3)) INTO dice FROM DUAL;
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

DROP FUNCTION IF EXISTS `lords`.`get_magic_field_factor_at` $$

CREATE FUNCTION `get_magic_field_factor_at`(g_id INT, x INT, y INT) RETURNS int(11)
BEGIN
  DECLARE result INT DEFAULT 1;
  DECLARE magic_tower_board_id INT;
  
    SELECT bb.id INTO magic_tower_board_id FROM board b_mt JOIN board_buildings bb ON (b_mt.ref=bb.id)
      WHERE bb.game_id=g_id AND b_mt.`type`<>'unit' AND building_feature_check(bb.id,'magic_increase')=1 AND check_building_deactivated(bb.id)=0
      AND x BETWEEN b_mt.x-bb.radius AND b_mt.x+bb.radius AND y BETWEEN b_mt.y-bb.radius AND b_mt.y+bb.radius
      AND NOT(x=b_mt.x AND y=b_mt.y) LIMIT 1;
    IF (magic_tower_board_id IS NOT NULL) THEN
      SET result=result*building_feature_get_param(magic_tower_board_id,'magic_increase');
    END IF;

    RETURN result;
END$$

DROP PROCEDURE IF EXISTS `lords`.`magical_damage` $$

CREATE PROCEDURE `magical_damage`(g_id INT,  p_num INT,  x INT,  y INT,  damage INT)
BEGIN
  DECLARE aim_id INT;
  DECLARE aim_type VARCHAR(45);
  DECLARE damage_final INT;
  DECLARE aim_health INT;
  DECLARE aim_shield INT DEFAULT 0;

  SET damage_final=damage * get_magic_field_factor_at(g_id, x, y);

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
        CALL cmd_log_add_message(g_id, p_num, 'building_damage', CONCAT_WS(';', log_building(aim_id), damage_final));
      WHEN 'unit' THEN
        CALL cmd_log_add_message(g_id, p_num, 'unit_damage', CONCAT_WS(';', log_unit(aim_id), damage_final));
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

DROP PROCEDURE IF EXISTS `lords`.`magical_heal` $$

CREATE PROCEDURE `magical_heal`(g_id INT, p_num INT, x INT, y INT, hp INT)
BEGIN
  DECLARE aim_id INT;
  DECLARE hp_final INT;
  DECLARE is_hurt INT DEFAULT 1;
  DECLARE hp_minus INT;
  DECLARE shield_minus INT;

  SET hp_final=hp * get_magic_field_factor_at(g_id, x, y);

  SELECT b.ref INTO aim_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y LIMIT 1;

    SELECT bu.max_health-bu.health,u.shield-bu.shield INTO hp_minus,shield_minus
    FROM board_units bu JOIN units u ON (bu.unit_id=u.id) WHERE bu.id=aim_id LIMIT 1;

    IF(unit_feature_check(aim_id,'paralich')=0 AND unit_feature_check(aim_id,'madness')=0 AND hp_minus=0 AND shield_minus=0)THEN
      SET is_hurt=0;
    END IF;

    IF (unit_feature_check(aim_id,'magic_immunity')=1 AND is_hurt=1) THEN 
      CALL cmd_magic_resistance_log(g_id,p_num,aim_id);
    ELSE
      IF (unit_feature_check(aim_id,'mechanical')=1 AND is_hurt=1) THEN 
        CALL cmd_mechanical_log(g_id,p_num,aim_id);
      ELSE
        CALL heal_unit(aim_id,hp_final);
      END IF;
    END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`magical_shield_on` $$

CREATE PROCEDURE `magical_shield_on`(g_id INT, p_num INT, x INT, y INT)
BEGIN
  DECLARE aim_id INT;
  DECLARE shields INT;

  SET shields= 1 * get_magic_field_factor_at(g_id, x, y);

  SELECT b.ref INTO aim_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y LIMIT 1;

    IF (unit_feature_check(aim_id,'magic_immunity')=0) THEN 
      WHILE shields>0 DO
        CALL shield_on(aim_id);
        SET shields=shields-1;
      END WHILE;
    ELSE
      CALL cmd_magic_resistance_log(g_id,p_num,aim_id);
    END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`units_from_zone` $$

CREATE PROCEDURE `units_from_zone`(g_id INT,  p_num INT,  zone INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE u_x,u_y,new_x,new_y INT;
  DECLARE board_unit_id INT;
  DECLARE bu_p_num INT;
  DECLARE size INT;

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR
    SELECT b.ref,MIN(b.x),MIN(b.y),u.size,bu.player_num
    FROM board b
    JOIN board_units bu ON (b.ref=bu.id)
    JOIN units u ON (bu.unit_id=u.id)
    WHERE b.`type`='unit' AND b.game_id=g_id AND unit_feature_check(bu.id,'magic_immunity')=0
    AND quart(b.x,b.y)=zone
    GROUP BY b.ref,u.size;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;

    OPEN cur;
    REPEAT
      FETCH cur INTO board_unit_id,u_x,u_y,size,bu_p_num;
      IF NOT done THEN
        IF size=1 THEN 
          SELECT a.x,a.y INTO new_x,new_y FROM allcoords a
          LEFT JOIN board b ON (a.x=b.x AND a.y=b.y AND b.game_id=g_id)
          WHERE a.mode_id=mode_id AND quart(a.x,a.y)<>zone AND b.id IS NULL
          ORDER BY ((u_x-a.x)*(u_x-a.x)+(u_y-a.y)*(u_y-a.y)) LIMIT 1;
        ELSE 
          SELECT a.x,a.y INTO new_x,new_y FROM allcoords a
          WHERE a.mode_id=mode_id AND quart(a.x,a.y)<>zone AND quart(a.x+size-1,a.y+size-1)<>zone AND quart(a.x,a.y+size-1)<>zone AND quart(a.x+size-1,a.y)<>zone
          AND NOT EXISTS
              (SELECT b.id FROM board b
                  WHERE b.game_id=g_id
                    AND NOT (b.`type`='unit' AND b.ref = board_unit_id)
                    AND b.x BETWEEN a.x AND a.x+size-1
                    AND b.y BETWEEN a.y AND a.y+size-1 LIMIT 1)
          ORDER BY ((u_x-a.x)*(u_x-a.x)+(u_y-a.y)*(u_y-a.y)) LIMIT 1;
        END IF;
        CALL move_unit(board_unit_id,new_x,new_y);
        IF bu_p_num = p_num THEN
          UPDATE board_units SET moves_left=0 WHERE id=board_unit_id;
          CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);
        END IF;
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur;

END$$

DELIMITER ;
