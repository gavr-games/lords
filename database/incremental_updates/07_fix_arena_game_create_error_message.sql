USE `lords_site`;
DROP procedure IF EXISTS `arena_game_create`;

DELIMITER $$
USE `lords_site`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `arena_game_create`(user_id INT, title VARCHAR(45) CHARSET utf8, pass VARCHAR(45) CHARSET utf8, time_restriction_seconds INT, mode_id INT)
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
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=10;
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

DELIMITER ;

