use lords;

DROP TABLE IF EXISTS `shooting_params`;
CREATE TABLE `shooting_params` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `unit_id` int(10) unsigned NOT NULL,
  `distance` int(10) not null,
  `aim_type` varchar(45) not NULL,
  `dice_max` int(10) unsigned NOT NULL,
  `chance` int(10) unsigned NOT NULL,
  `damage_modificator_min` int(11) NOT NULL,
  `damage_modificator_max` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `shooting_params_units` (`unit_id`),
  CONSTRAINT `shooting_params_units_fk` FOREIGN KEY (`unit_id`) REFERENCES `units` (`id`) ON DELETE CASCADE
) DEFAULT CHARSET=utf8;

set @archer_id = (SELECT id from units where ui_code='archer');
set @marksman_id = (SELECT id from units where ui_code='arbalester');
set @catapult_id = (SELECT id from units where ui_code='catapult');

insert into shooting_params (unit_id, distance, aim_type, dice_max, chance, damage_modificator_min, damage_modificator_max) values
(@archer_id, 2, 'unit', 1, 1, 0, 0),
(@archer_id, 3, 'unit', 2, 2, 0, 0),
(@archer_id, 4, 'unit', 6, 6, 0, 0),
(@marksman_id, 2, 'unit', 1, 1, 0, 0),
(@marksman_id, 3, 'unit', 1, 1, -1, 0),
(@marksman_id, 4, 'unit', 2, 2, -1, -1),
(@catapult_id, 2, 'building', 1, 1, 0, 0),
(@catapult_id, 3, 'building', 2, 2, 0, 0),
(@catapult_id, 4, 'building', 3, 3, 0, 0),
(@catapult_id, 5, 'building', 6, 6, 0, 0),
(@catapult_id, 2, 'castle', 1, 1, 0, 0),
(@catapult_id, 3, 'castle', 2, 2, 0, 0),
(@catapult_id, 4, 'castle', 3, 3, 0, 0),
(@catapult_id, 5, 'castle', 6, 6, 0, 0);

