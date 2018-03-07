use lords_site;

ALTER TABLE `arena_game_players` DROP COLUMN `name`;

ALTER TABLE `lords_site`.`users` CHANGE COLUMN `pass` `pass_hash` VARCHAR(255) NOT NULL ;

ALTER TABLE `lords_site`.`users` ADD COLUMN last_login TIMESTAMP NULL;

ALTER TABLE `lords`.`games` DROP COLUMN `pass`;

