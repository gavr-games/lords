use lords_site;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords_site`.`user_get_pass_hash` $$

CREATE PROCEDURE `user_get_pass_hash`(login VARCHAR(200) CHARSET utf8)
BEGIN
  DECLARE pass_hash VARCHAR(255) CHARSET utf8;

  SELECT u.pass_hash INTO pass_hash FROM users u WHERE u.login=login AND u.pass_hash IS NOT NULL LIMIT 1;
  IF pass_hash IS NULL THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='incorrect_login_or_pass';
  ELSE
    SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;
    SELECT 'pass_hash' AS `name`, pass_hash as `value` FROM DUAL;
  END IF;
END$$


DROP FUNCTION IF EXISTS `lords_site`.`is_guest_user` $$

CREATE FUNCTION `is_guest_user`(user_id INT) RETURNS int
BEGIN
  RETURN (SELECT CASE WHEN u.pass_hash IS NULL THEN 1 ELSE 0 END FROM users u WHERE u.id=user_id LIMIT 1);
END$$


DROP FUNCTION IF EXISTS `lords_site`.`is_bot_user` $$

CREATE FUNCTION `is_bot_user`(user_id INT) RETURNS int
BEGIN
  RETURN (SELECT u.is_bot FROM users u WHERE u.id=user_id LIMIT 1);
END$$


DROP PROCEDURE IF EXISTS `lords_site`.`user_profile_update` $$

CREATE PROCEDURE `user_profile_update`(user_id INT,  avatar_filename VARCHAR(100) CHARSET utf8)
BEGIN
  IF NOT EXISTS(SELECT id FROM users u WHERE u.id=user_id LIMIT 1) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='incorrect_user_id';
  ELSE
    IF is_guest_user(user_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='unavailable_for_guest_users';
    ELSE
      UPDATE users u SET u.avatar_filename = avatar_filename WHERE u.id=user_id;
      SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;
    END IF;
  END IF;
END$$

DROP PROCEDURE IF EXISTS `lords_site`.`user_info_select` $$

CREATE PROCEDURE `user_info_select`(user_id INT)
BEGIN
  DECLARE game_type_id INT;
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE mode_id INT;
  DECLARE user_language_id INT;
  DECLARE user_language_code VARCHAR(2) CHARSET utf8;

  CALL get_my_location_inner(user_id, game_type_id, g_id, p_num, mode_id);

  SELECT u.language_id INTO user_language_id FROM users u WHERE u.id = user_id LIMIT 1;
  SELECT l.code INTO user_language_code FROM languages l WHERE l.id = user_language_id LIMIT 1;

    SELECT 'user_id' AS `name`, user_id as `value` FROM DUAL
    UNION
    SELECT 'user_language_code' AS `name`, user_language_code as `value` FROM DUAL
    UNION
    SELECT 'game_type_id' AS `name`, game_type_id as `value` FROM DUAL
    UNION
    SELECT 'game_id' AS `name`, g_id as `value` FROM DUAL
    UNION
    SELECT 'player_num' AS `name`, p_num as `value` FROM DUAL
    UNION
    SELECT 'mode_id' AS `name`, mode_id as `value` FROM DUAL;

END$$



DROP PROCEDURE IF EXISTS `lords_site`.`user_get_info` $$

CREATE PROCEDURE `user_get_info`(login VARCHAR(200) CHARSET utf8)
BEGIN
  DECLARE user_id INT;
  DECLARE user_language_id INT;
  DECLARE user_language_code VARCHAR(2) CHARSET utf8;
  DECLARE game_type_id INT;
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE mode_id INT;

  SELECT u.id INTO user_id FROM users u WHERE u.login=login AND u.pass_hash IS NOT NULL LIMIT 1;
  IF user_id IS NULL THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='incorrect_login_or_pass';
  ELSE
    UPDATE users SET last_login = CURRENT_TIMESTAMP WHERE id = user_id;

    SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;
    CALL user_info_select(user_id);
  END IF;
END$$


DROP PROCEDURE IF EXISTS `lords_site`.`user_add` $$

CREATE PROCEDURE `user_add`(login VARCHAR(200) CHARSET utf8,  pass_hash VARCHAR(255) CHARSET utf8,  email VARCHAR(500) CHARSET utf8,  language_code VARCHAR(2) CHARSET utf8)
BEGIN
  DECLARE language_id INT;

  IF EXISTS(SELECT u.id FROM users u WHERE u.login=login AND u.pass_hash IS NOT NULL LIMIT 1) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, CONCAT('"',REPLACE(login,'\\\\"','\\\\\\\\\\\\"'),'"') as `error_params` FROM error_dictionary ed WHERE ed.code = 'login_exists';
  ELSE
    IF((IFNULL(login,'')='')OR(IFNULL(pass_hash,'')='')) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'empty_login_or_pass';
    ELSE
      SELECT l.id INTO language_id FROM languages l WHERE l.code = language_code;
      IF language_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, CONCAT('"',REPLACE(language_code,'\\\\"','\\\\\\\\\\\\"'),'"') as `error_params` FROM error_dictionary ed WHERE ed.code = 'incorrect_language_code';
      ELSE
        INSERT INTO users (login,pass_hash,email,language_id) VALUES (login,pass_hash,email,language_id);

        SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;
      END IF;
    END IF;
  END IF;

END$$


DROP PROCEDURE IF EXISTS `lords_site`.`get_current_game_info` $$

CREATE PROCEDURE `get_current_game_info`(user_id INT)
BEGIN
  DECLARE arena_game_type_id INT DEFAULT 1; 
  DECLARE game_type_id INT;
  DECLARE game_id INT;

  SELECT u.game_type_id INTO game_type_id FROM users u WHERE u.id=user_id LIMIT 1;

  IF game_type_id=arena_game_type_id THEN
    SELECT ap.game_id INTO game_id FROM arena_game_players ap WHERE ap.user_id=user_id LIMIT 1;

    SELECT
      ag.id AS `game_id`,
      title AS `title`,
      owner_id AS `owner_id`,
      u.login AS `owner_name`,
      time_restriction AS `time_restriction`,
      mode_id AS `mode_id`,
      lm.name AS `mode_name`
    FROM arena_games ag
    JOIN arena_game_players ap ON (ap.user_id = ag.owner_id)
    JOIN users u ON (ap.user_id = u.id)
    JOIN lords.modes lm ON (ag.mode_id = lm.id)
    WHERE ag.id=game_id;

    SELECT feature_id,`value`,feature_type FROM arena_games_features_usage f WHERE f.game_id=game_id;

    SELECT
      u.login AS `name`,
      ap.user_id AS `user_id`,
      ap.spectator_flag AS `spectator_flag`,
      ap.team AS `team`,
      u.avatar_filename,
      is_guest_user(u.id) AS `guest_user`,
      u.is_bot AS `bot`
    FROM arena_game_players ap
    JOIN users u ON (ap.user_id = u.id)
    WHERE ap.game_id=game_id;

  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords_site`.`get_all_arena_info` $$

CREATE PROCEDURE `get_all_arena_info`(user_id INT)
BEGIN
  
  SELECT
    au.user_id AS `user_id`,
    user_nick(au.user_id) AS `nick`,
    au.status_id AS `status_id`,
    u.avatar_filename,
    is_guest_user(u.id) as `guest_user`
  FROM arena_users au JOIN users u ON (au.user_id=u.id);
END$$


DROP PROCEDURE IF EXISTS `lords_site`.`guest_user_add` $$

CREATE PROCEDURE `guest_user_add`(nickname VARCHAR(200) CHARSET utf8, language_code VARCHAR(2) CHARSET utf8)
BEGIN
  DECLARE language_id INT;
  DECLARE guest_avatar VARCHAR(100) CHARSET utf8 DEFAULT 'guest_user.png';
  DECLARE user_id INT;

  SELECT l.id INTO language_id FROM languages l WHERE l.code = language_code;
  IF language_id IS NULL THEN
    SELECT 0 AS `success`, ed.id as `error_code`, CONCAT('"',REPLACE(language_code,'\\\\"','\\\\\\\\\\\\"'),'"') as `error_params` FROM error_dictionary ed WHERE ed.code = 'incorrect_language_code';
  ELSE
    INSERT INTO users (login, language_id, avatar_filename) VALUES (nickname, language_id, guest_avatar);
    SET user_id = @@last_insert_id;
    SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;
    CALL user_info_select(user_id);
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords_site`.`arena_game_delete_inner` $$

CREATE PROCEDURE `arena_game_delete_inner`(g_id INT)
BEGIN
  DECLARE player_online_status_id INT DEFAULT 1; 
  DECLARE player_ingame_status_id INT DEFAULT 2; 

  UPDATE arena_users au, arena_game_players agp SET au.status_id=player_online_status_id
    WHERE au.user_id=agp.user_id AND agp.game_id=g_id AND au.status_id=player_ingame_status_id;

  DELETE FROM users 
    WHERE id IN (SELECT user_id FROM arena_game_players WHERE game_id = g_id)
      AND is_bot = 1;

  DELETE FROM arena_games WHERE id=g_id;
  DELETE FROM lords.games WHERE id=g_id;
END$$


DROP PROCEDURE IF EXISTS `lords_site`.`arena_game_bot_add` $$

CREATE PROCEDURE `arena_game_bot_add`(user_id INT,  game_id INT)
BEGIN
  DECLARE created_game_status INT DEFAULT 1; 
  DECLARE owner_id INT;
  DECLARE status_id INT;
  DECLARE bot_nickname VARCHAR(200) CHARSET utf8 DEFAULT 'Bot';
  DECLARE bot_avatar VARCHAR(100) CHARSET utf8 DEFAULT 'bot_user.png';
  DECLARE bot_user_id INT;

  SELECT ag.owner_id, ag.status_id INTO owner_id, status_id FROM arena_games ag WHERE ag.id = game_id LIMIT 1;

  IF (owner_id IS NULL) OR (owner_id<>user_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'no_right_to_modify_game_features';
  ELSE
    IF status_id<>created_game_status THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'cant_modify_game_features_after_start';
    ELSE

      IF EXISTS (SELECT id FROM arena_game_players agp WHERE agp.game_id = game_id AND is_bot_user(agp.user_id)) THEN
        SET bot_nickname = CONCAT(bot_nickname, (SELECT COUNT(*) + 1 FROM arena_game_players agp WHERE agp.game_id = game_id AND is_bot_user(agp.user_id)));
      END IF;

      INSERT INTO users (login, avatar_filename, is_bot) VALUES (bot_nickname, bot_avatar, 1);
      SET bot_user_id = @@last_insert_id;
      INSERT INTO arena_game_players(user_id, game_id, spectator_flag)
        VALUES(bot_user_id, game_id, 1);

      SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;
      SELECT 'bot_user_id' AS `name`, bot_user_id as `value` FROM DUAL;
    END IF;
  END IF;
END$$


DROP PROCEDURE IF EXISTS `lords_site`.`arena_game_bot_remove` $$

CREATE PROCEDURE `arena_game_bot_remove`(user_id INT, game_id INT, bot_user_id INT)
BEGIN
  DECLARE created_game_status INT DEFAULT 1; 
  DECLARE owner_id INT;
  DECLARE status_id INT;

  SELECT ag.owner_id, ag.status_id INTO owner_id, status_id FROM arena_games ag WHERE ag.id = game_id LIMIT 1;

  IF (owner_id IS NULL) OR (owner_id<>user_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'no_right_to_modify_game_features';
  ELSE
    IF status_id<>created_game_status THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'cant_modify_game_features_after_start';
    ELSE
      IF NOT IFNULL(is_bot_user(bot_user_id), 0) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'incorrect_bot_id';
      ELSE
        IF NOT EXISTS (SELECT id FROM arena_game_players agp WHERE agp.game_id = game_id AND agp.user_id = bot_user_id) THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'bot_is_not_in_this_game';
        ELSE
          DELETE FROM users WHERE id = bot_user_id;
          DELETE FROM arena_game_players WHERE user_id = bot_user_id;

          SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;
        END IF;
      END IF;
    END IF;
  END IF;
END$$


DROP PROCEDURE IF EXISTS `lords_site`.`get_all_arena_bots` $$

CREATE PROCEDURE `get_all_arena_bots`()
BEGIN
  SELECT
    agp.user_id,
    agp.game_id,
    agp.spectator_flag,
    p.player_num
  FROM arena_game_players agp LEFT JOIN lords.players p ON agp.user_id = p.user_id
  WHERE is_bot_user(agp.user_id) = 1;

END$$

DELIMITER ;
