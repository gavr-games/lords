USE `lords_site`;
DROP procedure IF EXISTS `get_user_profile`;

DELIMITER $$
USE `lords_site`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_user_profile`(user_id_whose_profile_to_get INT)
BEGIN
  DECLARE last_played_game TIMESTAMP;

  SELECT MAX(insert_timestamp) INTO last_played_game FROM user_statistics_games WHERE user_id = user_id_whose_profile_to_get;

  SELECT login, avatar_filename,last_played_game FROM users u WHERE u.id=user_id_whose_profile_to_get LIMIT 1;

  SELECT
    m.name AS `mode_name`,
    COUNT(*) AS `games_played`,
    SUM(CASE WHEN game_result = 'win' THEN 1 ELSE 0 END) AS `win`,
    SUM(CASE WHEN game_result = 'lose' THEN 1 ELSE 0 END) AS `lose`,
    SUM(CASE WHEN game_result = 'draw' THEN 1 ELSE 0 END) AS `draw`,
    SUM(CASE WHEN game_result = 'exit' THEN 1 ELSE 0 END) AS `exit`
  FROM user_statistics_games u
  JOIN lords.modes m ON (u.mode_id = m.id)
  WHERE user_id = user_id_whose_profile_to_get
  GROUP BY m.name;

END
$$

DELIMITER ;

