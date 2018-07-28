use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`init_replay_data` $$

CREATE PROCEDURE `init_replay_data`(g_id INT)
BEGIN

  INSERT INTO `replay_games` (`id`, `title`, `owner_id`, `time_restriction`, `mode_id`, `type_id`)
    SELECT `id`, `title`, `owner_id`, `time_restriction`, `mode_id`, `type_id` FROM games WHERE id = g_id;

  INSERT INTO `replay_games_features_usage` (`game_id`, `feature_id`, `param`)
    SELECT `game_id`, `feature_id`, `param` FROM games_features_usage WHERE game_id = g_id;

  INSERT INTO `replay_init_players` (`user_id`, `game_id`, `player_num`, `name`, `gold`, `owner`, `team`, `move_order`, `language_id`)
    SELECT `user_id`, `game_id`, `player_num`, `name`, `gold`, `owner`, `team`, `move_order`, `language_id` FROM players WHERE game_id = g_id;

  INSERT INTO `replay_player_features_usage` (`game_id`, `player_num`, `feature_id`, `param`)
    SELECT `game_id`, `player_num`, `feature_id`, `param` FROM player_features_usage WHERE game_id = g_id;

  INSERT INTO `replay_init_player_deck` (`game_id`, `player_num`, `card_id`)
    SELECT `game_id`, `player_num`, `card_id` FROM player_deck WHERE game_id = g_id;

  INSERT INTO `replay_init_board` (`game_id`, `x`, `y`, `type`, `ref`)
    SELECT `game_id`, `x`, `y`, `type`, `ref` FROM board WHERE game_id = g_id;

  INSERT INTO `replay_init_board_buildings` (`id`, `game_id`, `building_id`, `player_num`, `health`, `max_health`, `radius`, `card_id`, `income`, `rotation`, `flip`)
    SELECT `id`, `game_id`, `building_id`, `player_num`, `health`, `max_health`, `radius`, `card_id`, `income`, `rotation`, `flip`
      FROM board_buildings WHERE game_id = g_id;

  INSERT INTO `replay_init_board_buildings_features` (`board_building_id`, `feature_id`, `param`)
    SELECT `board_building_id`, `feature_id`, `param` FROM board_buildings_features
      WHERE board_building_id IN (SELECT id FROM board_buildings WHERE game_id = g_id);

  INSERT INTO `replay_init_board_units` (`id`, `game_id`, `player_num`, `unit_id`, `card_id`, `health`, `max_health`, `attack`, `moves_left`, `moves`, `shield`)
    SELECT `id`, `game_id`, `player_num`, `unit_id`, `card_id`, `health`, `max_health`, `attack`, `moves_left`, `moves`, `shield`
      FROM board_units WHERE game_id = g_id;

  INSERT INTO `replay_init_board_units_features` (`board_unit_id`, `feature_id`, `param`)
    SELECT `board_unit_id`, `feature_id`, `param` FROM board_units_features
      WHERE board_unit_id IN (SELECT id FROM board_units WHERE game_id = g_id);

END$$


DROP PROCEDURE IF EXISTS `lords`.`initialization` $$

CREATE PROCEDURE `initialization`(g_id INT)
BEGIN
  DECLARE started_game_status INT DEFAULT 2; 

  CALL init_player_num_teams(g_id);
  CALL init_player_gold(g_id);
  CALL init_decks(g_id);
  CALL init_buildings(g_id);
  CALL init_units(g_id);
  CALL init_landscape(g_id);
  CALL init_statistics(g_id);
  CALL init_replay_data(g_id);

  INSERT INTO active_players(game_id,player_num,turn,last_end_turn) SELECT g_id,MIN(player_num),0,CURRENT_TIMESTAMP FROM players WHERE game_id=g_id AND owner<>0; 
  UPDATE games SET `status_id`=started_game_status WHERE id=g_id;

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

  INSERT INTO replay_statistic_values (game_id, stat_value_config_id, value, name)
    SELECT game_id, stat_value_config_id, value, name FROM statistic_values WHERE game_id = g_id;

END$$


