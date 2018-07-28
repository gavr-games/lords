use lords;

SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS `replay_games`;
CREATE TABLE `replay_games` (
  `id` int(10) unsigned NOT NULL,
  `title` varchar(45) NOT NULL,
  `owner_id` int(10) unsigned NOT NULL,
  `time_restriction` int(10) unsigned NOT NULL DEFAULT '0',
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `mode_id` int(10) unsigned NOT NULL,
  `type_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `replay_games_features_usage`;
CREATE TABLE `replay_games_features_usage` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `game_id` int(10) unsigned NOT NULL,
  `feature_id` int(10) unsigned NOT NULL,
  `param` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (game_id) REFERENCES replay_games(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `replay_init_players`;
CREATE TABLE `replay_init_players` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned DEFAULT NULL,
  `game_id` int(10) unsigned NOT NULL,
  `player_num` int(10) unsigned NOT NULL,
  `name` varchar(45) NOT NULL,
  `gold` int(10) unsigned NOT NULL DEFAULT '0',
  `owner` int(10) unsigned NOT NULL,
  `team` int(10) unsigned NOT NULL DEFAULT '0',
  `move_order` int(10) unsigned DEFAULT NULL,
  `language_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (game_id) REFERENCES replay_games(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `replay_player_features_usage`;
CREATE TABLE `replay_player_features_usage` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `game_id` int(10) unsigned NOT NULL,
  `player_num` int(10) unsigned NOT NULL,
  `feature_id` int(10) unsigned NOT NULL,
  `param` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (game_id) REFERENCES replay_games(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `replay_init_player_deck`;
CREATE TABLE `replay_init_player_deck` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `game_id` int(10) unsigned NOT NULL,
  `player_num` int(10) unsigned NOT NULL DEFAULT '0',
  `card_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (game_id) REFERENCES replay_games(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `replay_init_board`;
CREATE TABLE `replay_init_board` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `game_id` int(10) unsigned NOT NULL,
  `x` int(11) NOT NULL DEFAULT '0',
  `y` int(11) NOT NULL DEFAULT '0',
  `type` varchar(45) NOT NULL,
  `ref` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (game_id) REFERENCES replay_games(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `replay_init_board_buildings`;
CREATE TABLE `replay_init_board_buildings` (
  `id` int(10) unsigned NOT NULL,
  `game_id` int(10) unsigned NOT NULL,
  `building_id` int(10) unsigned NOT NULL DEFAULT '0',
  `player_num` int(10) unsigned NOT NULL,
  `health` int(10) unsigned NOT NULL DEFAULT '0',
  `max_health` int(10) unsigned NOT NULL DEFAULT '0',
  `radius` int(10) NOT NULL DEFAULT '0',
  `card_id` int(10) unsigned DEFAULT NULL,
  `income` int(10) unsigned NOT NULL DEFAULT '0',
  `rotation` int(10) unsigned NOT NULL DEFAULT '0',
  `flip` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  FOREIGN KEY (game_id) REFERENCES replay_games(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `replay_init_board_buildings_features`;
CREATE TABLE `replay_init_board_buildings_features` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `board_building_id` int(10) unsigned NOT NULL,
  `feature_id` int(10) unsigned NOT NULL,
  `param` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (board_building_id) REFERENCES replay_init_board_buildings(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `replay_init_board_units`;
CREATE TABLE `replay_init_board_units` (
  `id` int(10) unsigned NOT NULL,
  `game_id` int(10) unsigned NOT NULL,
  `player_num` int(10) unsigned NOT NULL,
  `unit_id` int(10) unsigned NOT NULL DEFAULT '0',
  `card_id` int(10) unsigned DEFAULT NULL,
  `health` int(11) NOT NULL DEFAULT '0',
  `max_health` int(11) NOT NULL DEFAULT '0',
  `attack` int(11) NOT NULL DEFAULT '0',
  `moves_left` int(11) NOT NULL DEFAULT '0',
  `moves` int(11) NOT NULL DEFAULT '0',
  `shield` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  FOREIGN KEY (game_id) REFERENCES replay_games(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `replay_init_board_units_features`;
CREATE TABLE `replay_init_board_units_features` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `board_unit_id` int(10) unsigned NOT NULL,
  `feature_id` int(10) unsigned NOT NULL,
  `param` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (board_unit_id) REFERENCES replay_init_board_units(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `replay_statistic_values`;
CREATE TABLE `replay_statistic_values` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `game_id` int(10) unsigned NOT NULL,
  `stat_value_config_id` int(10) unsigned NOT NULL,
  `value` float DEFAULT NULL,
  `name` varchar(500) NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (game_id) REFERENCES replay_games(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `replay_actions`;
CREATE TABLE `replay_actions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `game_id` int(10) unsigned NOT NULL,
  `player_num` int(10) unsigned NOT NULL,
  `action` varchar(1000) NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (game_id) REFERENCES replay_games(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `replay_commands`;
CREATE TABLE `replay_commands` (
    `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
    `action_id` int(10) unsigned NOT NULL,
    `game_id` int(10) unsigned NOT NULL,
    `player_num` int(10) unsigned NOT NULL,
    `command` varchar(1000) NOT NULL,
    `hidden_flag` int(11) NOT NULL DEFAULT '0',
    `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (action_id) REFERENCES replay_actions(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

SET FOREIGN_KEY_CHECKS=1;

