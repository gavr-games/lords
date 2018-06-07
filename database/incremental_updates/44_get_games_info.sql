use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`get_games_info` $$

CREATE PROCEDURE `get_games_info`()
BEGIN

  SELECT
    g.id AS `game_id`,
    g.mode_id,
    g.time_restriction,
    g.status_id,
    p.player_num AS `active_player_num`,
    p.owner AS `active_player_owner`
  FROM games g
  JOIN active_players ap ON (g.id=ap.game_id)
  LEFT JOIN players p ON (ap.game_id=p.game_id AND ap.player_num=p.player_num);

END$$