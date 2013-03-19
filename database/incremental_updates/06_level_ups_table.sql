USE lords;

DROP TABLE IF EXISTS `unit_level_up_experience`;
CREATE TABLE `unit_level_up_experience` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `unit_id` int(10) unsigned NOT NULL,
  `level` int NOT NULL,
  `experience` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `unit_level_up_experience_units` (`unit_id`),
  CONSTRAINT `unit_level_up_experience_units` FOREIGN KEY (`unit_id`) REFERENCES `units` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO unit_level_up_experience(unit_id,level,experience)
SELECT u.id,1,u.attack + u.health FROM units u;

INSERT INTO unit_level_up_experience(unit_id,level,experience)
SELECT u.id,2,u.attack + u.health + 1 FROM units u;

INSERT INTO unit_level_up_experience(unit_id,level,experience)
SELECT u.id,3,u.attack + u.health + 2 FROM units u;