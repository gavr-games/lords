use lords;

ALTER TABLE `buildings` DROP COLUMN `name`;
ALTER TABLE `buildings` DROP COLUMN `description`;
ALTER TABLE `buildings` DROP COLUMN `log_short_name`;

DROP TABLE IF EXISTS `buildings_i18n`;
CREATE TABLE `buildings_i18n` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `building_id` int(10) unsigned NOT NULL,
  `language_id` int(10) unsigned NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(1000),
  `log_short_name` varchar(50),
  PRIMARY KEY (`id`),
  FOREIGN KEY (`building_id`) REFERENCES `buildings` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `buildings_i18n` (language_id, `building_id`, name, description, log_short_name) VALUES 
(2,1,'Телепорт','Позволяет перемещать свои юниты и юниты союзника в радиус действия телепорта','Телепорт'),
(2,2,'Магическая башня','Усиливает магию в 3 раза в радиусе своего действия','Маг. баш.'),
(2,3,'Монетный двор','Дополнительный доход за юнитов в радиусе','Мон. двор'),
(2,4,'Храм лечения','Лечит здоровье юнитов и восстанавливает щит магу','Храм леч.'),
(2,5,'Озеро','Из озера появляются 3 жабки, которые бьют ближайших юнитов любых игроков','Озеро'),
(2,6,'Горы','Из гор появляется тролль, который идет бить ближайшее здание','Горы'),
(2,7,'Замок',NULL,'Замок'),
(2,8,'Руины замка','Здесь когда-то жил Лорд...','Руины'),
(2,9,'Телепорт','Позволяет перемещать свои юниты и юниты союзника в радиус действия телепорта','Телепорт'),
(2,10,'Магическая башня','Усиливает магию в 3 раза в радиусе своего действия','Маг. баш.'),
(2,11,'Монетный двор','Дополнительный доход за юнитов в радиусе','Мон. двор'),
(2,12,'Храм лечения','Лечит здоровье юнитов и восстанавливает щит магу','Храм леч.'),
(2,13,'Озеро','Из озера появляются 3 жабки, которые бьют ближайших юнитов любых игроков','Озеро'),
(2,14,'Горы','Из гор появляется тролль, который идет бить ближайшее здание','Горы'),
(2,15,'Замок',NULL,'Замок'),
(2,16,'Руины замка','Здесь когда-то жил Лорд...','Руины'),
(2,17,'Казарма','Появляются два союзных копейщика-NPC. Потом иногда появляются еще копейщики.','Казарма'),
(2,18,'Дерево','Тис ягодный.','Дерево'),
(2,19,'Крепостная Стена','Можно защитить замок.','Стена'),
(2,20,'Крепостная Стена','Можно защитить замок. Если закрыть ворота.','Стена'),
(2,21,'Ров','Окружает остров в середине карты.','Ров'),
(2,22,'Мост','Можно разрушить.','Мост'),
(2,23,'Руины моста','Здесь когда-то стоял мост.','Руины');

INSERT INTO `buildings_i18n` (language_id, `building_id`, name, description, log_short_name) VALUES 
(1,1,'Portal','Allows to teleport owner''s and allied units into its radius',NULL),
(1,2,'Magic tower','Triples magical effects in its radius','M.Tower'),
(1,3,'Coin factory','Extra income for units that stay in its radius','C.Factory'),
(1,4,'Healing temple','Heals owner''s, allied, and mad units','H.Temple'),
(1,5,'Lake','Spawns 3 agessive frogs, may spawn more later',NULL),
(1,6,'Mountains','Spawns a troll that wants to destroy buildings, may spawn more later',NULL),
(1,7,'Castle',NULL,NULL),
(1,8,'Ruins','Once here lived a Lord',NULL),
(1,9,'Portal','Allows to teleport owner''s and allied units into its radius',NULL),
(1,10,'Magic tower','Triples magical effects in its radius','M.Tower'),
(1,11,'Coin factory','Extra income for units that stay in its radius','C.Factory'),
(1,12,'Healing temple','Heals owner''s, allied, and mad units','H.Temple'),
(1,13,'Lake','Spawns 3 agessive frogs, may spawn more later',NULL),
(1,14,'Mountains','Spawns a troll that wants to destroy buildings, may spawn more later',NULL),
(1,15,'Castle',NULL,NULL),
(1,16,'Ruins','Once here lived a Lord',NULL),
(1,17,'Barracks','Spawns two allied NPC Spearmen, may spawn more later',NULL),
(1,18,'Tree',NULL,NULL),
(1,19,'Wall','Can protect a castle',NULL),
(1,20,'Wall','Could protect a castle if closed',NULL),
(1,21,'Moat','Protects from invaders',NULL),
(1,22,'Bridge','Can be destroyed',NULL),
(1,23,'Ruined bridge','Once here stood a bridge',NULL);

