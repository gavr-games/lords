use lords_site;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords_site`.`arena_game_delete_inner` $$

CREATE PROCEDURE `arena_game_delete_inner`(g_id INT)
BEGIN
  DECLARE player_online_status_id INT DEFAULT 1;
  DECLARE player_waiting_game_start_status_id INT DEFAULT 2;
  DECLARE player_ingame_status_id INT DEFAULT 3;

  UPDATE arena_users au, arena_game_players agp SET au.status_id=player_online_status_id
    WHERE au.user_id=agp.user_id AND agp.game_id=g_id
      AND au.status_id IN (player_waiting_game_start_status_id, player_ingame_status_id);

  DELETE FROM users 
    WHERE id IN (SELECT user_id FROM arena_game_players WHERE game_id = g_id)
      AND is_bot = 1;

  DELETE FROM arena_games WHERE id=g_id;
  DELETE FROM lords.games WHERE id=g_id;
END$$

