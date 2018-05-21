use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`recreate_exp_table` $$

CREATE PROCEDURE `recreate_exp_table`()
BEGIN

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
  SELECT u.id,1,u.attack + u.health + u.shield FROM units u;

  INSERT INTO unit_level_up_experience(unit_id,level,experience)
  SELECT u.id,2,u.attack + u.health + u.shield + 1 + prev.experience
  FROM units u
  JOIN (SELECT unit_id, experience FROM unit_level_up_experience prev_lvl WHERE prev_lvl.level = 1) prev ON (u.id = prev.unit_id);

  INSERT INTO unit_level_up_experience(unit_id,level,experience)
  SELECT u.id,3,u.attack + u.health + u.shield + 2 + prev.experience
  FROM units u
  JOIN (SELECT unit_id, experience FROM unit_level_up_experience prev_lvl WHERE prev_lvl.level = 2) prev ON (u.id = prev.unit_id);

END$$

DELIMITER ;

