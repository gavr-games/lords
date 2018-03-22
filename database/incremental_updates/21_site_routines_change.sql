use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`get_all_game_info` $$

CREATE PROCEDURE `get_all_game_info`(g_id INT, p_num INT)
BEGIN

  SELECT g.title,g.owner_id,g.time_restriction,g.status_id,g.`date` AS `creation_date`,g.mode_id,g.type_id FROM games g WHERE g.id=g_id;

  SELECT b.id,MIN(b.x) as `x`,MIN(b.y) as `y`,b.ref,b.`type` FROM board b WHERE b.game_id=g_id AND b.`type`<>'unit' GROUP BY b.ref,b.`type`;

  SELECT b.id,MIN(b.x) as `x`,MIN(b.y) as `y`,b.ref,b.`type` FROM board b WHERE b.game_id=g_id AND b.`type`='unit' GROUP BY b.ref,b.`type`;

  SELECT a.player_num,a.turn,a.subsidy_flag,a.units_moves_flag,a.card_played_flag,UNIX_TIMESTAMP(a.last_end_turn) as `last_end_turn`,n.command_procedure FROM active_players a LEFT JOIN nonfinished_actions_dictionary n ON (a.nonfinished_action_id=n.id) WHERE a.game_id=g_id;

  SELECT p.player_num, p.name, p.gold, p.owner, p.team, p.agree_draw FROM players p WHERE p.game_id=g_id ORDER BY p.player_num;

  SELECT b.id, b.building_id, b.player_num, b.health, b.max_health, b.radius, b.card_id, b.income, b.rotation, b.flip FROM board_buildings b WHERE b.game_id=g_id;

  SELECT bbf.board_building_id,bbf.feature_id,bbf.param FROM board_buildings_features bbf JOIN board_buildings bb ON (bb.id=bbf.board_building_id) WHERE bb.game_id=g_id;

  SELECT b.id, b.player_num, b.unit_id, b.card_id, b.health, b.max_health, b.attack, b.moves_left, b.moves, b.shield, b.experience, b.level FROM board_units b WHERE b.game_id=g_id;

  SELECT buf.board_unit_id,buf.feature_id,buf.param FROM board_units_features buf JOIN board_units bu ON (bu.id=buf.board_unit_id) WHERE bu.game_id=g_id;

  SELECT v.grave_id,v.card_id, v.x, v.y, v.size FROM vw_grave v WHERE v.game_id=g_id;

  SELECT p.id,p.card_id FROM player_deck p WHERE p.game_id=g_id AND p.player_num=p_num;

  select command from log_commands where game_id=g_id AND((hidden_flag=0) OR (player_num = p_num));

END$$

DELIMITER ;

use lords_site;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords_site`.`arena_game_create` $$

CREATE PROCEDURE `arena_game_create`(user_id INT, title VARCHAR(45) CHARSET utf8, pass VARCHAR(45) CHARSET utf8, time_restriction_seconds INT, mode_id INT)
BEGIN
  DECLARE arena_game_type_id INT DEFAULT 1; 
  DECLARE created_game_status INT DEFAULT 1; 
  DECLARE game_id INT;

  IF NOT EXISTS(SELECT au.id FROM arena_users au WHERE au.user_id=user_id LIMIT 1)THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=8;
  ELSE
    IF (time_restriction_seconds<0) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=9;
    ELSE
      IF EXISTS(SELECT 1 FROM arena_games ag WHERE ag.owner_id=user_id AND ag.status_id=created_game_status LIMIT 1) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=30;
      ELSE
        IF NOT EXISTS (SELECT m.id FROM lords.modes m WHERE m.id=mode_id LIMIT 1) THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=9;
        ELSE

          INSERT INTO lords.games(title,owner_id,time_restriction,status_id,mode_id,type_id)VALUES(title,user_id,time_restriction_seconds,created_game_status,mode_id,arena_game_type_id);
          SET game_id=@@last_insert_id;

          INSERT INTO arena_games(id,title,pass,owner_id,time_restriction,status_id,mode_id)VALUES(game_id,title,MD5(pass),user_id,time_restriction_seconds,created_game_status,mode_id);


          INSERT INTO arena_games_features_usage(game_id,feature_id,`value`,feature_type)
          SELECT game_id,id,default_param,feature_type FROM lords.games_features;

          SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;

          SELECT 'game_id' AS `name`, game_id as `value` FROM DUAL;

        END IF;
      END IF;
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords_site`.`user_add` $$

CREATE PROCEDURE `user_add`(login VARCHAR(200) CHARSET utf8, pass_hash VARCHAR(255) CHARSET utf8, email VARCHAR(500) CHARSET utf8, language_code VARCHAR(2) CHARSET utf8)
BEGIN
  DECLARE language_id INT;

  IF EXISTS(SELECT u.id FROM users u WHERE u.login=login LIMIT 1) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, CONCAT('"',REPLACE(login,'\\"','\\\\\\"'),'"') as `error_params` FROM error_dictionary ed WHERE id=1;
  ELSE
    IF((IFNULL(login,'')='')OR(IFNULL(pass_hash,'')='')) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=2;
    ELSE
      SELECT l.id INTO language_id FROM languages l WHERE l.code = language_code;
      IF language_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, CONCAT('"',REPLACE(language_code,'\\"','\\\\\\"'),'"') as `error_params` FROM error_dictionary ed WHERE id=35;
      ELSE
        INSERT INTO users (login,pass_hash,email,language_id) VALUES (login,pass_hash,email,language_id);

        SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;
      END IF;
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords_site`.`user_authorize` $$
DROP PROCEDURE IF EXISTS `lords_site`.`user_get_pass_hash` $$

CREATE PROCEDURE `user_get_pass_hash`(login VARCHAR(200) CHARSET utf8)
BEGIN
  DECLARE pass_hash VARCHAR(255) CHARSET utf8;

  SELECT u.pass_hash INTO pass_hash FROM users u WHERE u.login=login LIMIT 1;
  IF pass_hash IS NULL THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=3;
  ELSE
    SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;
    SELECT 'pass_hash' AS `name`, pass_hash as `value` FROM DUAL;
  END IF;
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

  SELECT u.id, u.language_id INTO user_id, user_language_id FROM users u WHERE u.login=login LIMIT 1;
  IF user_id IS NULL THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=3;
  ELSE
    CALL get_my_location_inner(user_id,game_type_id,g_id,p_num,mode_id);
    UPDATE users SET last_login = CURRENT_TIMESTAMP WHERE id = user_id;

    SELECT l.code INTO user_language_code FROM languages l WHERE l.id = user_language_id LIMIT 1;

    SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;

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

  END IF;
END$$

DROP PROCEDURE IF EXISTS `lords_site`.`arena_game_enter` $$

CREATE PROCEDURE `arena_game_enter`(user_id INT, game_id INT,  pass VARCHAR(45) CHARSET utf8)
BEGIN
  DECLARE created_game_status INT DEFAULT 1; 
  DECLARE player_ingame_status_id INT DEFAULT 2; 
  DECLARE game_status_id INT;
  DECLARE md5_game_pass VARCHAR(45) CHARSET utf8;

  SELECT ag.status_id, ag.pass INTO game_status_id, md5_game_pass FROM arena_games ag WHERE ag.id=game_id LIMIT 1;

  IF NOT EXISTS(SELECT au.id FROM arena_users au WHERE au.user_id=user_id LIMIT 1)THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=8;
  ELSE
    IF EXISTS(SELECT p.id FROM arena_game_players p WHERE p.user_id=user_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      IF game_status_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=16;
      ELSE
        IF IFNULL(md5_game_pass,'')<>IFNULL(MD5(pass),'') THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=13;
        ELSE
          IF (game_status_id<>created_game_status) THEN
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=17;
          ELSE

            INSERT INTO arena_game_players(user_id,game_id,spectator_flag)VALUES(user_id,game_id,1); 

            UPDATE arena_users au SET au.status_id=player_ingame_status_id WHERE au.user_id=user_id;

            SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;

          END IF;
        END IF;
      END IF;
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords_site`.`arena_game_spectator_enter` $$

CREATE PROCEDURE `arena_game_spectator_enter`(user_id INT, game_id INT,  pass VARCHAR(45) CHARSET utf8)
BEGIN
  DECLARE created_game_status INT DEFAULT 1; 
  DECLARE player_playing_status_id INT DEFAULT 3; 
  DECLARE game_status_id INT;
  DECLARE md5_game_pass VARCHAR(45) CHARSET utf8;
  DECLARE p_num INT;
  DECLARE p_name VARCHAR(200) CHARSET utf8;

  SELECT ag.status_id, ag.pass INTO game_status_id, md5_game_pass FROM arena_games ag WHERE ag.id=game_id LIMIT 1;

  IF NOT EXISTS(SELECT au.id FROM arena_users au WHERE au.user_id=user_id LIMIT 1)THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=8;
  ELSE
    IF EXISTS(SELECT p.id FROM arena_game_players p WHERE p.user_id=user_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      IF game_status_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=16;
      ELSE
        IF IFNULL(md5_game_pass,'')<>IFNULL(MD5(pass),'') THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=13;
        ELSE
          IF (game_status_id=created_game_status) THEN
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=29;
          ELSE

            INSERT INTO arena_game_players(user_id,game_id,spectator_flag)VALUES(user_id,game_id,1); 

            UPDATE arena_users au SET au.status_id=player_playing_status_id WHERE au.user_id=user_id;

            SET p_num=100+user_id;
            SET p_name=user_nick(user_id);

            INSERT INTO lords.players(user_id,game_id,player_num,name,owner,team)
            VALUES(user_id,game_id,p_num,p_name,0,0);

            SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;

            SELECT 'player_num' AS `name`, p_num as `value` FROM DUAL
            UNION
            SELECT 'player_name' AS `name`, p_name as `value` FROM DUAL;

          END IF;
        END IF;
      END IF;
    END IF;
  END IF;
END$$

DROP PROCEDURE IF EXISTS `lords_site`.`arena_game_start` $$

CREATE PROCEDURE `arena_game_start`(user_id INT,  game_id INT)
BEGIN
  DECLARE created_game_status INT DEFAULT 1; 
  DECLARE playing_game_status INT DEFAULT 2; 
  DECLARE player_ingame_status_id INT DEFAULT 2; 
  DECLARE player_playing_status_id INT DEFAULT 3; 
  DECLARE arena_game_type_id INT DEFAULT 1; 
  DECLARE owner_id INT;
  DECLARE status_id INT;
  DECLARE player_count INT;
  DECLARE mode_id INT;

  SELECT ag.owner_id, ag.status_id, ag.mode_id INTO owner_id,status_id,mode_id FROM arena_games ag WHERE ag.id=game_id LIMIT 1;

  IF (owner_id IS NULL) OR (owner_id<>user_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=26;
  ELSE
    IF status_id<>created_game_status THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=27;
    ELSE
      SELECT COUNT(*) INTO player_count FROM arena_game_players agp WHERE agp.game_id=game_id AND spectator_flag=0;
      IF NOT EXISTS(SELECT lm.id FROM lords.modes lm WHERE lm.id=mode_id AND player_count BETWEEN lm.min_players AND lm.max_players LIMIT 1) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=28;
      ELSE

        UPDATE arena_games ag SET ag.status_id=playing_game_status WHERE ag.id=game_id;

        UPDATE arena_users au, arena_game_players agp SET au.status_id=player_playing_status_id
          WHERE au.user_id=agp.user_id AND agp.game_id=game_id AND au.status_id=player_ingame_status_id;

        INSERT INTO lords.players(user_id,game_id,player_num,name,owner,team)
          SELECT
            agp.user_id,
            game_id,
            CASE WHEN agp.spectator_flag=0 THEN 0 ELSE 100+agp.user_id END,
            u.login,
            CASE WHEN agp.spectator_flag=1 THEN 0 ELSE 1 END,
            IFNULL(agp.team,0)
          FROM arena_game_players agp JOIN users u ON agp.user_id = u.id WHERE agp.game_id=game_id;

        INSERT INTO lords.games_features_usage(game_id,feature_id,param)
          SELECT f.game_id,f.feature_id,f.`value` FROM arena_games_features_usage f WHERE f.game_id=game_id;

        CALL lords.initialization(game_id);

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
      u.avatar_filename
    FROM arena_game_players ap
    JOIN users u ON (ap.user_id = u.id)
    WHERE ap.game_id=game_id;

  END IF;

END$$


