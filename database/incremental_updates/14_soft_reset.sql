use lords_site;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords_site`.`soft_reset` $$

CREATE PROCEDURE `soft_reset`()
BEGIN
  SET FOREIGN_KEY_CHECKS=0;
  delete from lords.active_players;
  delete from lords.board;
  delete from lords.board_buildings;
  delete from lords.board_buildings_features;
  delete from lords.board_units;
  delete from lords.board_units_features;
  delete from lords.log_commands;
  delete from lords.graves;
  delete from lords.grave_cells;
  delete from lords.deck;
  delete from lords.games_features_usage;
  delete from lords.games;
  delete from lords.player_deck;
  delete from lords.players;
  delete from lords.statistic_values;
  delete from lords.statistic_game_actions;
  delete from lords.statistic_players;
  delete from lords.player_features_usage;

  delete from lords_site.arena_users;
  delete from lords_site.arena_games;
  delete from lords_site.arena_games_features_usage;
  delete from lords_site.arena_game_players;
  delete from lords_site.chat_users;
  delete from lords_site.chats;
  delete from users where pass_hash IS NULL;
  update users set game_type_id=0;

  SET FOREIGN_KEY_CHECKS=1;
END$$

DELIMITER ;
