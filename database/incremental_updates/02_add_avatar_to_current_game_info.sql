USE `lords_site`;

DROP PROCEDURE IF EXISTS `get_current_game_info`;

DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_current_game_info`(user_id INT)
BEGIN
  DECLARE arena_game_type_id INT DEFAULT 1; /*NOTE hardcode because this id is unlikely to change*/
  DECLARE game_type_id INT;
  DECLARE game_id INT;

  SELECT u.game_type_id INTO game_type_id FROM users u WHERE u.id=user_id LIMIT 1;

  IF game_type_id=arena_game_type_id THEN
    SELECT ap.game_id INTO game_id FROM arena_game_players ap WHERE ap.user_id=user_id LIMIT 1;

/*game*/
    SELECT
      ag.id AS `game_id`,
      title AS `title`,
      owner_id AS `owner_id`,
      ap.name AS `owner_name`,
      time_restriction AS `time_restriction`,
      mode_id AS `mode_id`,
      lm.name AS `mode_name`
    FROM arena_games ag
    JOIN arena_game_players ap ON (ap.user_id=ag.owner_id)
    JOIN lords.modes lm ON (ag.mode_id=lm.id)
    WHERE ag.id=game_id;

/*features*/
    SELECT feature_id,`value`,feature_type FROM arena_games_features_usage f WHERE f.game_id=game_id;

/*players*/
    SELECT
      ap.name AS `name`,
      ap.user_id AS `user_id`,
      ap.spectator_flag AS `spectator_flag`,
      ap.team AS `team`,
	  u.avatar_filename
    FROM arena_game_players ap
    JOIN users u ON (ap.user_id = u.id)
    WHERE ap.game_id=game_id;

  END IF;

END $$

DELIMITER ;
