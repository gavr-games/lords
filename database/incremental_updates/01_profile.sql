USE `lords_site`;

ALTER TABLE `users` ADD COLUMN `email` VARCHAR(500) NULL;
ALTER TABLE `users` ADD COLUMN `avatar_filename` VARCHAR(100) NULL;

DELIMITER $$

DROP procedure IF EXISTS `user_add`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `user_add`(login VARCHAR(200) CHARSET utf8, pass VARCHAR(200) CHARSET utf8, email VARCHAR(500) CHARSET utf8)
BEGIN
  IF EXISTS(SELECT u.id FROM users u WHERE u.login=login LIMIT 1) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, CONCAT('"',REPLACE(login,'\"','\\\"'),'"') as `error_params` FROM error_dictionary ed WHERE id=1;/*User with this login already exists*/
  ELSE
    IF((IFNULL(login,'')='')OR(IFNULL(pass,'')='')) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=2;/*Empty login or password*/
    ELSE
      INSERT INTO users (login,pass,email) VALUES (login,MD5(pass),email);

      SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;
    END IF;
  END IF;

END
$$

DROP procedure IF EXISTS `user_profile_update`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `user_profile_update`(user_id INT, avatar_filename VARCHAR(100) CHARSET utf8)
BEGIN
  IF NOT EXISTS(SELECT id FROM users u WHERE u.id=user_id LIMIT 1) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=4;/*Incorrect user_id*/
  ELSE
    UPDATE users u SET u.avatar_filename = avatar_filename WHERE u.id=user_id;	
    SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;
  END IF;
END
$$

DROP procedure IF EXISTS `get_my_profile`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_my_profile`(user_id INT)
BEGIN
  SELECT login, avatar_filename, email FROM users u WHERE u.id=user_id LIMIT 1;
END
$$

DROP procedure IF EXISTS `get_user_profile`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_user_profile`(user_id_whose_profile_to_get INT)
BEGIN
  SELECT login, avatar_filename FROM users u WHERE u.id=user_id_whose_profile_to_get LIMIT 1;
END
$$

DROP PROCEDURE IF EXISTS `lords_site`.`get_all_arena_info` $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_arena_info`(user_id INT)
BEGIN
  /*arena users*/
  SELECT au.user_id AS `user_id`,user_nick(au.user_id) AS `nick`,au.status_id AS `status_id`, u.avatar_filename FROM arena_users au JOIN users u ON (au.user_id=u.id);
END $$

DROP PROCEDURE IF EXISTS `lords_site`.`arena_enter` $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `arena_enter`(user_id INT)
BEGIN
  DECLARE arena_game_type_id INT DEFAULT 1; /*NOTE hardcode because this id is unlikely to change*/
  DECLARE player_online_status_id INT DEFAULT 1; /*NOTE hardcode because this id is unlikely to change*/
  DECLARE game_type_id INT;
  DECLARE avatar_filename VARCHAR(100) CHARSET utf8;

  SELECT u.game_type_id, u.avatar_filename INTO game_type_id, avatar_filename FROM users u WHERE u.id=user_id LIMIT 1;
  IF game_type_id IS NULL THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=4;/*Incorrect user_id*/
  ELSE
    IF game_type_id=arena_game_type_id THEN
      /*if user is already in arena do nothing*/
      SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;
    ELSE
      UPDATE users SET game_type_id=arena_game_type_id WHERE id=user_id;
      INSERT INTO arena_users(user_id,status_id) VALUES (user_id,player_online_status_id);

      SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;

      SELECT 'nick' AS `name`, user_nick(user_id) as `value` FROM DUAL
      UNION
      SELECT 'avatar_filename' AS `name`, avatar_filename as `value` FROM DUAL;
    END IF;
  END IF;
END $$

DELIMITER ;
