use lords;

DELIMITER $$

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
  
  truncate table replay_games;
  truncate table replay_games_features_usage;
  truncate table replay_init_players;
  truncate table replay_player_features_usage;
  truncate table replay_init_player_deck;
  truncate table replay_init_board;
  truncate table replay_init_board_buildings;
  truncate table replay_init_board_buildings_features;
  truncate table replay_init_board_units;
  truncate table replay_init_board_units_features;
  truncate table replay_statistic_values;
  truncate table replay_actions;
  truncate table replay_commands;

  SET FOREIGN_KEY_CHECKS=1;
END$$

