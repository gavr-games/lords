use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`get_all_game_info_ai` $$

CREATE PROCEDURE `get_all_game_info_ai`(g_id INT,p_num INT)
BEGIN
  DECLARE mode_id INT;

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;

  SELECT p.player_num, p.owner, p.team FROM players p WHERE p.game_id=g_id ORDER BY p.player_num;


  SELECT b.id, b.player_num, b.health, b.max_health FROM board_buildings b WHERE b.game_id=g_id;


  SELECT bbf.board_building_id,bf.code AS `feature_name`,bbf.param AS `feature_value` FROM board_buildings_features bbf JOIN board_buildings bb ON (bb.id=bbf.board_building_id) JOIN building_features bf ON (bbf.feature_id = bf.id) WHERE bb.game_id=g_id;


  SELECT b.id, b.player_num, b.health, b.max_health, b.attack, b.moves_left, b.moves, b.shield, b.unit_id, b.experience, b.level FROM board_units b WHERE b.game_id=g_id;


  SELECT buf.board_unit_id,uf.code AS `feature_name`,buf.param AS `feature_value` FROM board_units_features buf JOIN board_units bu ON (bu.id=buf.board_unit_id) JOIN unit_features uf ON (buf.feature_id = uf.id) WHERE bu.game_id=g_id;


  SELECT vmulue.unit_id, vmulue.level, vmulue.experience FROM vw_mode_unit_level_up_experience vmulue WHERE vmulue.mode_id = mode_id;


  SELECT b.x, b.y, b.`type`, b.ref FROM board b WHERE b.game_id=g_id;

END$$

DROP FUNCTION IF EXISTS `lords`.`check_unit_can_level_up` $$

CREATE FUNCTION `check_unit_can_level_up`(board_unit_id INT) RETURNS int(11)
BEGIN
	DECLARE unit_id INT;
	DECLARE unit_exp INT;
	DECLARE unit_level INT;
	
	SELECT bu.unit_id, bu.experience, bu.level INTO unit_id, unit_exp, unit_level FROM board_units bu WHERE bu.id = board_unit_id;
	
	IF EXISTS(SELECT 1 FROM unit_level_up_experience l WHERE l.unit_id = unit_id AND l.level = unit_level + 1 AND l.experience <= unit_exp) THEN
		RETURN 1;
	END IF;
	
	RETURN 0;
END$$

DELIMITER ;