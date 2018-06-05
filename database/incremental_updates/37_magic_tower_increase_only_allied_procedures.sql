use lords;

DELIMITER $$

DROP FUNCTION IF EXISTS `lords`.`get_magic_field_factor_at` $$
DROP FUNCTION IF EXISTS `lords`.`get_magic_field_factor` $$

CREATE FUNCTION `get_magic_field_factor`(g_id INT, p_num INT, x INT, y INT) RETURNS int(11)
BEGIN
  DECLARE result INT DEFAULT 1;
  DECLARE magic_tower_board_id INT;
  DECLARE p_team INT;
  
  SELECT p.team INTO p_team FROM players p WHERE p.game_id = g_id AND p.player_num = p_num LIMIT 1;

  SELECT bb.id INTO magic_tower_board_id
    FROM board b_mt
      JOIN board_buildings bb ON (b_mt.ref=bb.id)
      JOIN players p ON (p.game_id = bb.game_id AND p.player_num = bb.player_num)
    WHERE bb.game_id=g_id AND b_mt.`type`<>'unit' AND building_feature_check(bb.id,'magic_increase')=1 AND check_building_deactivated(bb.id)=0
      AND x BETWEEN b_mt.x-bb.radius AND b_mt.x+bb.radius AND y BETWEEN b_mt.y-bb.radius AND b_mt.y+bb.radius
      AND NOT(x=b_mt.x AND y=b_mt.y)
      AND p.team = p_team LIMIT 1;

  IF (magic_tower_board_id IS NOT NULL) THEN
    SET result = result * building_feature_get_param(magic_tower_board_id, 'magic_increase');
  END IF;

    RETURN result;
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
        IF get_random_int_between(1, 6) <= 3 THEN
          CALL unit_add_attack(board_unit_id, attack_bonus * get_magic_field_factor(g_id, p_num, x, y));
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
        CALL unit_add_moves(board_unit_id, speed_bonus * get_magic_field_factor(g_id, p_num, x, y));
        CALL unit_add_health(board_unit_id, health_bonus * get_magic_field_factor(g_id, p_num, x, y));
        CALL unit_add_attack(board_unit_id, attack_bonus * get_magic_field_factor(g_id, p_num, x, y));
      ELSE
        CALL cmd_magic_resistance_log(g_id,p_num,board_unit_id);
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
        CALL unit_add_moves(board_unit_id, speed_bonus * get_magic_field_factor(g_id, p_num, x, y));
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

      CALL user_action_end();
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`magical_damage` $$

CREATE PROCEDURE `magical_damage`(g_id INT,   p_num INT,   x INT,   y INT,   damage INT)
BEGIN
  DECLARE aim_id INT;
  DECLARE aim_type VARCHAR(45);
  DECLARE damage_final INT;
  DECLARE aim_health INT;
  DECLARE aim_shield INT DEFAULT 0;

  SET damage_final=damage * get_magic_field_factor(g_id, p_num, x, y);

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

  SET hp_final=hp * get_magic_field_factor(g_id, p_num, x, y);

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

CREATE PROCEDURE `magical_shield_on`(g_id INT,  p_num INT,  x INT,  y INT)
BEGIN
  DECLARE aim_id INT;
  DECLARE shields INT;

  SET shields= 1 * get_magic_field_factor(g_id, p_num, x, y);

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


