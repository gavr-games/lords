use lords;

ALTER TABLE `unit_features` DROP COLUMN `description`;
ALTER TABLE `unit_features` DROP COLUMN `log_description`;

ALTER TABLE `unit_features` ADD COLUMN `log_key_add` varchar(50) DEFAULT NULL;
ALTER TABLE `unit_features` ADD COLUMN `log_key_remove` varchar(50) DEFAULT NULL;

UPDATE unit_features SET log_key_add = 'unit_chess_knight' WHERE id = 6 AND `code` = 'knight';
UPDATE unit_features SET log_key_add = 'unit_paralyzed', log_key_remove = 'unit_unparalyzed' WHERE id = 7 AND `code` = 'paralich';
UPDATE unit_features SET log_key_add = 'unit_goes_mad', log_key_remove = 'unit_becomes_not_mad' WHERE id = 5 AND `code` = 'madness';

DROP TABLE IF EXISTS `unit_features_i18n`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `unit_features_i18n` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `feature_id` int(10) unsigned NOT NULL,
  `language_id` int(10) unsigned NOT NULL,
  `description` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

INSERT INTO `unit_features_i18n` (language_id, `feature_id`, description) VALUES
(2,1,'Юнит невосприимчив к магии'),
(2,2,'Юнит можно цеплять к другим юнитам'),
(2,3,'Юнит блокирует здания, находясь в их радиусе'),
(2,4,'Юнит начинает бить ударившего его юнита'),
(2,5,'Юнит сошел с ума'),
(2,6,'Юнит ходит конем'),
(2,7,'Юнит парализован'),
(2,8,'Юнит - зомби'),
(2,9,'Юнит, к которому прицеплен'),
(2,10,'Юнит, которого атаковать'),
(2,11,'Юнит - вампир'),
(2,12,'Юнит под контролем другого юнита'),
(2,13,'Юнит при ударе пьет жизнь противника'),
(2,14,'Непризванный юнит'),
(2,15,'Плодится из здания'),
(2,16,'Толкается при атаке'),
(2,17,'Механический'),
(2,18,'При уничтожении идет не в мертвятник, а в колоду');

INSERT INTO `unit_features_i18n` (language_id, `feature_id`, description) VALUES
(1,1,'Unit is immune to magic'),
(1,2,'Unit can be attached to and towed by another unit'),
(1,3,'Unit blocks buildings when in their radius'),
(1,4,'Unit fights back if attacked'),
(1,5,'This unit is MAD'),
(1,6,'Unit moves as a chess knight'),
(1,7,'Unit is paralyzed'),
(1,8,'This is a Zombie'),
(1,9,'Unit, to which something is attached'),
(1,10,'Attack target unit'),
(1,11,'Vampire unit'),
(1,12,'Unit is controlled by another unit'),
(1,13,'Unit drains health on successful attack'),
(1,14,'Unit is not played by card'),
(1,15,'Is spawned from a building'),
(1,16,'Pushes on attack'),
(1,17,'Mechanical'),
(1,18,'If killed, goes to the deck instead of the graveyard');

