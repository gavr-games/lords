use lords;

ALTER TABLE `lords`.`active_players` ADD COLUMN `card_played_flag` INTEGER UNSIGNED NOT NULL DEFAULT 0 AFTER `units_moves_flag`;
