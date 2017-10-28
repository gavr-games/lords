use lords;

ALTER TABLE `procedures_params` DROP COLUMN `description`;

DROP TABLE IF EXISTS `procedures_params_i18n`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `procedures_params_i18n` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `param_id` int(10) unsigned NOT NULL,
  `language_id` int(10) unsigned NOT NULL,
  `description` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

INSERT INTO `procedures_params_i18n` (language_id, `param_id`, description) VALUES
(2,1,'Выберите пустую клетку на поле'),
(2,2,'Выберите место в своей зоне'),
(2,3,'Выберите юнита'),
(2,4,'Выберите зону'),
(2,5,'Выберите здание'),
(2,6,'Выберите игрока'),
(2,7,'Укажите количество'),
(2,8,'Выберите мертвого юнита'),
(2,9,'Выберите карту'),
(2,10,'Каким боком поставить'),
(2,11,'Отразить'),
(2,12,'Выберите, что атаковать'),
(2,14,'Выберите любую клетку'),
(2,15,'Выберите юнита, к которому применить действие'),
(2,16,'Выберите своего юнита'),
(2,17,'Выберите юнита на расстоянии 2 - 4 клетки'),
(2,18,'Выберите здание на расстоянии 2 - 5 клеток');

INSERT INTO `procedures_params_i18n` (language_id, `param_id`, description) VALUES
(1,1,'Pick an empty square'),
(1,2,'Pick an empty square in your zone'),
(1,3,'Pick a unit'),
(1,4,'Pick a zone'),
(1,5,'Pick a building'),
(1,6,'Choose a player'),
(1,7,'Choose amount'),
(1,8,'Pick a unit from the graveyard'),
(1,9,'Pick a card'),
(1,10,'Rotate'),
(1,11,'Flip'),
(1,12,'Pick attack target'),
(1,14,'Pick any square'),
(1,15,'Pick a target unit'),
(1,16,'Pick your own unit'),
(1,17,'Pick a target unit within 2 - 4 squares'),
(1,18,'Pick a target building within 2 - 5 squares');

