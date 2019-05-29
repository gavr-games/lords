use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`get_all_game_info` $$

CREATE PROCEDURE `get_all_game_info`(g_id INT,  p_num INT)
BEGIN

  SELECT g.title,g.owner_id,g.time_restriction,g.status_id,g.`date` AS `creation_date`,g.mode_id,g.type_id FROM games g WHERE g.id=g_id;
  
  SELECT gfu.feature_id, gfu.param FROM games_features_usage gfu WHERE gfu.game_id=g_id;

  SELECT b.id,MIN(b.x) as `x`,MIN(b.y) as `y`,b.ref,b.`type` FROM board b WHERE b.game_id=g_id AND b.`type`<>'unit' GROUP BY b.ref,b.`type`;

  SELECT b.id,MIN(b.x) as `x`,MIN(b.y) as `y`,b.ref,b.`type` FROM board b WHERE b.game_id=g_id AND b.`type`='unit' GROUP BY b.ref,b.`type`;

  SELECT a.player_num,a.turn,a.subsidy_flag,a.units_moves_flag,a.card_played_flag,UNIX_TIMESTAMP(a.last_end_turn) as `last_end_turn`,n.command_procedure FROM active_players a LEFT JOIN nonfinished_actions_dictionary n ON (a.nonfinished_action_id=n.id) WHERE a.game_id=g_id;

  SELECT p.player_num, p.name, p.gold, p.owner, p.team, p.agree_draw FROM players p WHERE p.game_id=g_id ORDER BY p.player_num;

  SELECT b.id, b.building_id, b.player_num, b.health, b.max_health, b.radius, b.card_id, b.income, b.rotation, b.flip FROM board_buildings b WHERE b.game_id=g_id;

  SELECT bbf.board_building_id,bbf.feature_id,bbf.param FROM board_buildings_features bbf JOIN board_buildings bb ON (bb.id=bbf.board_building_id) WHERE bb.game_id=g_id;

  SELECT b.id, b.player_num, b.unit_id, b.card_id, b.health, b.max_health, b.attack, b.moves_left, b.moves, b.shield, b.experience, b.level FROM board_units b WHERE b.game_id=g_id;

  SELECT buf.board_unit_id,buf.feature_id,buf.param FROM board_units_features buf JOIN board_units bu ON (bu.id=buf.board_unit_id) WHERE bu.game_id=g_id;

  SELECT v.grave_id, v.card_id, v.player_num_when_killed, v.turn_when_killed, v.x, v.y, v.size FROM vw_grave v WHERE v.game_id=g_id;

  SELECT p.id,p.card_id FROM player_deck p WHERE p.game_id=g_id AND p.player_num=p_num;

  select command from log_commands where game_id=g_id AND((hidden_flag=0) OR (player_num = p_num));

END$$

DELIMITER ;