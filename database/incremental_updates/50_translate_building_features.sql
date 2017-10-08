use lords;

ALTER TABLE `building_features` DROP COLUMN `description`;

DROP TABLE IF EXISTS `building_features_i18n`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `building_features_i18n` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `feature_id` int(10) unsigned NOT NULL,
  `language_id` int(10) unsigned NOT NULL,
  `description` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

INSERT INTO `building_features_i18n` (language_id, `feature_id`, description) VALUES
(2,1,'Позволяет телепортировать союзных юнитов в свой радиус'),
(2,2,'Лечит союзных и сумасшедших юнитов в своем радиусе'),
(2,3,'Увеличивает эффект от магии в своем радиусе'),
(2,4,'Плодит Жабок'),
(2,5,'Плодит Троллей'),
(2,6,'Номер команды плодимых юнитов'),
(2,7,'Монетный двор'),
(2,8,'Можно утонуть'),
(2,9,'Плодит союзников'),
(2,10,'Казарма'),
(2,11,'Изначальный объект на доске'),
(2,12,'Здание нельзя переместить картами'),
(2,13,'Открытая стена'),
(2,14,'Закрытая стена'),
(2,15,'Номер хода, когда здание поменялось'),
(2,16,'Руины замка'),
(2,17,'Мост, который можно разрушить'),
(2,18,'Разрушенный мост'),
(2,19,'NPC в здравом уме это не атакуют'),
(2,20,'За разрушение здания игрок получает награду в определенном размере');

INSERT INTO `building_features_i18n` (language_id, `feature_id`, description) VALUES
(1,1,'Allows to teleport ally units into its radius'),
(1,2,'Heals ally and mad units in its radius'),
(1,3,'Increases effects of magic in its radius'),
(1,4,'Spawns Frogs'),
(1,5,'Spawns Trolls'),
(1,6,'Spawn units team number'),
(1,7,'Coin factory'),
(1,8,'Can drown here'),
(1,9,'Spawns ally NPC units'),
(1,10,'Barracks'),
(1,11,'Initial object'),
(1,12,'Cannot be moved by cards'),
(1,13,'Open wall'),
(1,14,'Closed wall'),
(1,15,'Turn when the building acted'),
(1,16,'Castle ruins'),
(1,17,'Bridge that can be destroyed'),
(1,18,'Destroyed bridge'),
(1,19,'Sane NPCs do not attack this'),
(1,20,'There is a reward for destroying this building');

