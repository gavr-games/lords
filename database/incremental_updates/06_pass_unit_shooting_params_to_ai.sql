use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`get_all_game_info_ai` $$

CREATE PROCEDURE `get_all_game_info_ai`(g_id INT, p_num INT)
BEGIN

  SELECT p.player_num, p.owner, p.team FROM players p WHERE p.game_id=g_id ORDER BY p.player_num;

  SELECT b.id, b.player_num, b.health, b.max_health FROM board_buildings b WHERE b.game_id=g_id;

  SELECT bbf.board_building_id,bf.code AS `feature_name`,bbf.param AS `feature_value` FROM board_buildings_features bbf JOIN board_buildings bb ON (bb.id=bbf.board_building_id) JOIN building_features bf ON (bbf.feature_id = bf.id) WHERE bb.game_id=g_id;

  SELECT
    u.id,
    u.player_num,
    u.health,
    u.max_health,
    u.attack,
    u.moves_left,
    u.moves,
    u.shield,
    check_unit_can_level_up(u.id) AS `can_levelup`,
    s.min_range,
    s.max_range,
    s.shoots_units,
    s.shoots_buildings,
    s.shoots_castles
    FROM board_units u
    LEFT JOIN (SELECT
      sp.unit_id,
      MIN(sp.distance) as `min_range`,
      MAX(sp.distance) as `max_range`,
      MAX(CASE aim_type WHEN 'unit' THEN 1 ELSE 0 END) as `shoots_units`,
      MAX(CASE aim_type WHEN 'building' THEN 1 ELSE 0 END) as `shoots_buildings`,
      MAX(CASE aim_type WHEN 'castle' THEN 1 ELSE 0 END) as `shoots_castles`
      FROM shooting_params sp
      GROUP BY sp.unit_id) s ON u.unit_id = s.unit_id
    WHERE u.game_id=g_id;

  SELECT buf.board_unit_id,uf.code AS `feature_name`,buf.param AS `feature_value` FROM board_units_features buf JOIN board_units bu ON (bu.id=buf.board_unit_id) JOIN unit_features uf ON (buf.feature_id = uf.id) WHERE bu.game_id=g_id;

  SELECT b.x, b.y, b.`type`, b.ref FROM board b WHERE b.game_id=g_id;

END$$

