USE `lords_site`;
DROP procedure IF EXISTS `user_add`;

DELIMITER $$
USE `lords_site`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `user_add`(login VARCHAR(200) CHARSET utf8, pass VARCHAR(200) CHARSET utf8, email VARCHAR(500) CHARSET utf8, language_code VARCHAR(2) CHARSET utf8)
BEGIN
  DECLARE language_id INT;

  IF EXISTS(SELECT u.id FROM users u WHERE u.login=login LIMIT 1) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, CONCAT('"',REPLACE(login,'\"','\\\"'),'"') as `error_params` FROM error_dictionary ed WHERE id=1;
  ELSE
    IF((IFNULL(login,'')='')OR(IFNULL(pass,'')='')) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=2;
    ELSE
      SELECT l.id INTO language_id FROM languages l WHERE l.code = language_code;
      IF language_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, CONCAT('"',REPLACE(language_code,'\"','\\\"'),'"') as `error_params` FROM error_dictionary ed WHERE id=35;
      ELSE
        INSERT INTO users (login,pass,email,language_id) VALUES (login,MD5(pass),email,language_id);

        SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;
      END IF;
    END IF;
  END IF;

END$$

DELIMITER ;

DROP procedure IF EXISTS `user_language_change`;

DELIMITER $$
USE `lords_site`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `user_language_change`(user_id INT, language_code VARCHAR(2) CHARSET utf8)
BEGIN
  DECLARE language_id INT;

  IF NOT EXISTS(SELECT id FROM users u WHERE u.id=user_id LIMIT 1) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=4;
  ELSE
    SELECT l.id INTO language_id FROM languages l WHERE l.code = language_code;
    IF language_id IS NULL THEN
      SELECT 0 AS `success`, ed.id as `error_code`, CONCAT('"',REPLACE(language_code,'\"','\\\"'),'"') as `error_params` FROM error_dictionary ed WHERE id=35;
    ELSE
      UPDATE users u SET u.language_id = language_id WHERE u.id=user_id;	
      SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;
    END IF;
  END IF;
END$$

DELIMITER ;


