use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`init_statistics` $$

CREATE PROCEDURE `init_statistics`(g_id INT)
BEGIN

  INSERT INTO statistic_players(game_id, player_num, player_name)
    SELECT g_id, p.player_num, p.name
      FROM players p
      WHERE p.game_id = g_id AND p.owner <> 0;

END$$

DROP PROCEDURE IF EXISTS `lords`.`delete_game_data` $$

CREATE PROCEDURE `delete_game_data`(g_id INT)
BEGIN
  DECLARE game_status_id INT;
  DECLARE finished_game_status INT DEFAULT 3; 
  DECLARE game_type_id INT;
  DECLARE arena_game_type_id INT DEFAULT 1; 

  SELECT g.status_id INTO game_status_id FROM games g WHERE g.id=g_id LIMIT 1;

  IF(game_status_id=finished_game_status)THEN

    SELECT g.type_id INTO game_type_id FROM games g WHERE g.id=g_id LIMIT 1;
    IF(game_type_id=arena_game_type_id)THEN
      CALL lords_site.arena_game_delete_inner(g_id);
    END IF;

    DELETE FROM active_players WHERE game_id=g_id;
    DELETE FROM board WHERE game_id=g_id;
    DELETE FROM board_buildings_features WHERE board_building_id IN (SELECT id FROM board_buildings WHERE game_id=g_id);
    DELETE FROM board_buildings WHERE game_id=g_id;
    DELETE FROM board_units_features WHERE board_unit_id IN (SELECT id FROM board_units WHERE game_id=g_id);
    DELETE FROM board_units WHERE game_id=g_id;
    DELETE FROM log_commands WHERE game_id=g_id;
    DELETE FROM deck WHERE game_id=g_id;
    DELETE FROM games_features_usage WHERE game_id=g_id;
    DELETE FROM player_deck WHERE game_id=g_id;
    DELETE FROM players WHERE game_id=g_id;
    DELETE FROM games WHERE id=g_id;
    DELETE FROM statistic_game_actions WHERE game_id=g_id;
    DELETE FROM statistic_values WHERE game_id=g_id;
    DELETE FROM statistic_players WHERE game_id=g_id;
    DELETE FROM player_features_usage WHERE game_id=g_id;

  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`reset` $$

CREATE PROCEDURE `reset`()
BEGIN
  SET FOREIGN_KEY_CHECKS=0;
  truncate table active_players;
  truncate table board;
  truncate table board_buildings;
  truncate table board_buildings_features;
  truncate table board_units;
  truncate table board_units_features;
  truncate table log_commands;
  truncate table graves;
  truncate table grave_cells;
  truncate table deck;
  truncate table games_features_usage;
  truncate table games;
  truncate table player_deck;
  truncate table players;
  truncate table statistic_values;
  truncate table statistic_game_actions;
  truncate table statistic_players;
  truncate table player_features_usage;
  SET FOREIGN_KEY_CHECKS=1;
END$$


DROP PROCEDURE IF EXISTS `lords`.`get_game_statistic` $$

CREATE PROCEDURE `get_game_statistic`(g_id INT)
BEGIN

  SELECT
    t.id as `tab_id`,
    t.name as `tab_name`,
    c.id as `chart_id`,
    c.type as `chart_type`,
    c.name as `chart_name`,
    v.id as `value_id`,
    v.value,
    vc.color,
    v.name as `value_name`,
    p.player_name
  FROM
    statistic_tabs t
    JOIN statistic_charts c ON (c.tab_id = t.id)
    JOIN statistic_values_config vc ON (vc.chart_id = c.id)
    JOIN statistic_values v ON (v.stat_value_config_id = vc.id)
    JOIN statistic_players p ON (p.player_num = vc.player_num)
  WHERE v.game_id = g_id AND p.game_id = g_id
  ORDER BY `tab_id`,`chart_id`,`value_id`;

END$$

DROP PROCEDURE IF EXISTS `lords`.`statistic_calculation` $$

CREATE PROCEDURE `statistic_calculation`(g_id INT)
BEGIN
  DECLARE g_mode INT;

  DECLARE stat_value_config_id INT;
  DECLARE p_num INT;
  DECLARE value_name VARCHAR(500) CHARSET utf8;
  DECLARE count_rule VARCHAR(1000) CHARSET utf8;
  DECLARE sql_update_stmt VARCHAR(1000) CHARSET utf8 DEFAULT
    'INSERT INTO statistic_values (game_id, stat_value_config_id, value, name)
       SELECT $g_id, $vc_id, r.value, ''$value_name''
         FROM ($rule) r;';

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR
    SELECT
      vc.id,
      vc.player_num,
      IFNULL(vc.name, p.player_name),
      d.count_rule
    FROM statistic_values_config vc
      JOIN dic_statistic_measures d ON (vc.measure_id=d.id)
      JOIN statistic_players p ON (p.player_num = vc.player_num)
    WHERE vc.mode_id = g_mode AND p.game_id = g_id;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SELECT mode_id INTO g_mode FROM games WHERE id=g_id;

    OPEN cur;
    REPEAT
      FETCH cur INTO stat_value_config_id,p_num,value_name,count_rule;
      IF NOT done THEN
        SET count_rule=REPLACE(count_rule,'$g_id',g_id);
        SET count_rule=REPLACE(count_rule,'$p_num',p_num);
        SET @sql_query=REPLACE(sql_update_stmt,'$rule',count_rule);
        SET @sql_query=REPLACE(@sql_query,'$g_id',g_id);
        SET @sql_query=REPLACE(@sql_query,'$vc_id',stat_value_config_id);
        SET @sql_query=REPLACE(@sql_query,'$value_name',value_name);
        PREPARE stmt FROM @sql_query;
        EXECUTE stmt;
        DROP PREPARE stmt;
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur;

END$$

DELIMITER ;
