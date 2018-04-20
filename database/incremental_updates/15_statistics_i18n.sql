use lords;

DROP TABLE IF EXISTS `statistic_players`;

CREATE TABLE `statistic_players` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `game_id` int(10) unsigned NOT NULL,
  `player_num` int(10) unsigned NOT NULL,
  `player_name` varchar(500) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `statistics_i18n`;

CREATE TABLE `statistics_i18n` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `language_id` int(10) unsigned NOT NULL,
  `code` varchar(50) NOT NULL,
  `text` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO statistics_i18n(language_id, code, text) VALUES 
(1, '{unit_cards}', 'Units'),
(2, '{unit_cards}', 'Юниты'),
(1, '{building_cards}', 'Buildings'),
(2, '{building_cards}', 'Здания'),
(1, '{magic_cards}', 'Magic'),
(2, '{magic_cards}', 'Магии'),
(1, '{gold_tab}', 'Gold'),
(2, '{gold_tab}', 'Золото'),
(1, '{cards_tab}', 'Cards'),
(2, '{cards_tab}', 'Карты'),
(1, '{damage_tab}', 'Damage'),
(2, '{damage_tab}', 'Урон'),
(1, '{attack_tab}', 'Attack'),
(2, '{attack_tab}', 'Атака'),
(1, '{units_tab}', 'Units'),
(2, '{units_tab}', 'Юниты'),
(1, '{buildings_tab}', 'Buildings'),
(2, '{buildings_tab}', 'Здания'),
(1, '{income_chart}', 'Income'),
(1, '{outgo_chart}', 'Outgo'),
(1, '{bought_cards_chart}', 'Bought'),
(1, '{played_cards_chart}', 'Played'),
(1, '{played_cards_by_type}', '{player_name} played by card type'),
(1, '{played_cards_by_type}', '{player_name} played by card type'),
(1, '{played_cards_by_type}', '{player_name} played by card type'),
(1, '{played_cards_by_type}', '{player_name} played by card type'),
(1, '{caused_damage_chart}', '{player_name} played by card type'),
(1, '{success_rate_chart}', 'Success rate'),
(1, '{critical_hit_chart}', 'Critical hit rate'),
(1, '{played_units_chart}', 'Played units'),
(1, '{killed_units_chart}', 'Killed units'),
(1, '{played_buildings_chart}', 'Played buildings'),
(1, '{destroyed_buildings_chart}', 'Destroyed buildings'),
(1, '{resurrected_units_chart}', 'Resurrected units'),
(2, '{income_chart}', 'Заработал'),
(2, '{outgo_chart}', 'Потратил'),
(2, '{bought_cards_chart}', 'Купил'),
(2, '{played_cards_chart}', 'Сыграл'),
(2, '{played_cards_by_type}', '{player_name} cыграл по типам карт'),
(2, '{played_cards_by_type}', '{player_name} cыграл по типам карт'),
(2, '{played_cards_by_type}', '{player_name} cыграл по типам карт'),
(2, '{played_cards_by_type}', '{player_name} cыграл по типам карт'),
(2, '{caused_damage_chart}', 'Нанес'),
(2, '{success_rate_chart}', 'Процент попаданий'),
(2, '{critical_hit_chart}', 'Процент критических'),
(2, '{played_units_chart}', 'Призванных юнитов'),
(2, '{killed_units_chart}', 'Убитых юнитов'),
(2, '{played_buildings_chart}', 'Призванных зданий'),
(2, '{destroyed_buildings_chart}', 'Разрушенных зданий'),
(2, '{resurrected_units_chart}', 'Воскрешенных юнитов');


UPDATE statistic_values_config SET name = '{unit_cards}' WHERE name = 'Юниты';
UPDATE statistic_values_config SET name = '{building_cards}' WHERE name = 'Здания';
UPDATE statistic_values_config SET name = '{magic_cards}' WHERE name = 'Магии';

UPDATE statistic_tabs SET name = '{gold_tab}' WHERE name = 'Золото';
UPDATE statistic_tabs SET name = '{cards_tab}' WHERE name = 'Карты';
UPDATE statistic_tabs SET name = '{damage_tab}' WHERE name = 'Урон';
UPDATE statistic_tabs SET name = '{attack_tab}' WHERE name = 'Атака';
UPDATE statistic_tabs SET name = '{units_tab}' WHERE name = 'Юниты';
UPDATE statistic_tabs SET name = '{buildings_tab}' WHERE name = 'Здания';

UPDATE statistic_charts SET name = '{income_chart}' WHERE name = 'Заработал';
UPDATE statistic_charts SET name = '{outgo_chart}' WHERE name = 'Потратил';
UPDATE statistic_charts SET name = '{bought_cards_chart}' WHERE name = 'Купил';
UPDATE statistic_charts SET name = '{played_cards_chart}' WHERE name = 'Сыграл';
UPDATE statistic_charts SET name = '{played_cards_by_type}' WHERE name = '$p_name cыграл по типам карт';
UPDATE statistic_charts SET name = '{caused_damage_chart}' WHERE name = 'Нанес';
UPDATE statistic_charts SET name = '{success_rate_chart}' WHERE name = 'Процент попаданий';
UPDATE statistic_charts SET name = '{critical_hit_chart}' WHERE name = 'Процент критических';
UPDATE statistic_charts SET name = '{played_units_chart}' WHERE name = 'Призванных юнитов';
UPDATE statistic_charts SET name = '{killed_units_chart}' WHERE name = 'Убитых юнитов';
UPDATE statistic_charts SET name = '{played_buildings_chart}' WHERE name = 'Призванных зданий';
UPDATE statistic_charts SET name = '{destroyed_buildings_chart}' WHERE name = 'Разрушенных зданий';
UPDATE statistic_charts SET name = '{resurrected_units_chart}' WHERE name = 'Воскрешенных юнитов';

DROP VIEW IF EXISTS `vw_statistic_values`;
DROP TABLE IF EXISTS `statistic_values`;

CREATE TABLE `statistic_values` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `game_id` int(10) unsigned NOT NULL,
  `stat_value_config_id` int(10) unsigned NOT NULL,
  `value` float DEFAULT NULL,
  `name` varchar(500) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

delete from dic_statistic_measures where id not in (select measure_id from statistic_values_config);
update dic_statistic_measures set count_rule = replace(count_rule, 'FROM', 'as value FROM');
update dic_statistic_measures set count_rule = CONCAT(count_rule, ' as value FROM DUAL') where description in ('Процент попаданий', 'Процент критических ударов');

