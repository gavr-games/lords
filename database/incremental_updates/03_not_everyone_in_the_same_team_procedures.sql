use lords_site;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords_site`.`arena_game_start` $$

CREATE PROCEDURE `arena_game_start`(user_id INT, game_id INT)
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
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'no_right_to_start_game';
  ELSE
    IF status_id<>created_game_status THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'game_already_started';
    ELSE
      SELECT COUNT(*) INTO player_count FROM arena_game_players agp WHERE agp.game_id=game_id AND spectator_flag=0;
      IF NOT EXISTS(SELECT lm.id FROM lords.modes lm WHERE lm.id=mode_id AND player_count BETWEEN lm.min_players AND lm.max_players LIMIT 1) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'incorrect_number_of_players';
      ELSE
        IF (SELECT COUNT(DISTINCT agp.team) FROM arena_game_players agp WHERE agp.game_id=game_id AND spectator_flag=0) = 1
          AND NOT EXISTS 
            (SELECT f.id FROM arena_games_features_usage f JOIN lords.games_features fd ON f.feature_id = fd.id
            WHERE f.game_id = game_id AND f.value = 1 AND fd.code IN ('all_versus_all', 'random_teams'))
        THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'everyone_is_in_the_same_team';
        ELSE
          UPDATE arena_games ag SET ag.status_id=playing_game_status WHERE ag.id=game_id;

          UPDATE arena_users au, arena_game_players agp SET au.status_id=player_playing_status_id
            WHERE au.user_id=agp.user_id AND agp.game_id=game_id AND au.status_id=player_ingame_status_id;

          INSERT INTO lords.players(user_id,game_id,player_num,name,owner,team,language_id)
            SELECT
              agp.user_id,
              game_id,
              CASE WHEN agp.spectator_flag=0 THEN 0 ELSE 100+agp.user_id END,
              u.login,
              CASE WHEN agp.spectator_flag=1 THEN 0 ELSE 1 END,
              IFNULL(agp.team,0),
              user_language(agp.user_id)
            FROM arena_game_players agp JOIN users u ON agp.user_id = u.id WHERE agp.game_id=game_id;

          INSERT INTO lords.games_features_usage(game_id,feature_id,param)
            SELECT f.game_id,f.feature_id,f.`value` FROM arena_games_features_usage f WHERE f.game_id=game_id;

          CALL lords.initialization(game_id);

          SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;
        END IF;
      END IF;
    END IF;
  END IF;

END$$

