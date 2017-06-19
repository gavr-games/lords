use lords;

DROP TABLE IF EXISTS `games_features`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `games_features` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(45) NOT NULL,
  `default_param` int(11) NOT NULL,
  `feature_type` enum('bool','int') NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `games_features` WRITE;
/*!40000 ALTER TABLE `games_features` DISABLE KEYS */;
INSERT INTO `games_features` VALUES
(1,'random_teams',0,'bool'),
(2,'all_versus_all',0,'bool'),
(3,'number_of_teams',2,'int'),
(4,'teammates_in_random_castles',0,'bool');
/*!40000 ALTER TABLE `games_features` ENABLE KEYS */;
UNLOCK TABLES;


DROP TABLE IF EXISTS `games_features_i18n`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `games_features_i18n` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `feature_id` int(10) unsigned NOT NULL,
  `language_id` int(10) unsigned NOT NULL,
  `description` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

INSERT INTO `games_features_i18n` (language_id, `feature_id`, description) VALUES
(2,1,'Случайные союзы'),
(2,2,'Каждый сам за себя'),
(2,3,'Количество команд'),
(2,4,'Союзники не напротив, а случайным образом');
INSERT INTO `games_features_i18n` (language_id, `feature_id`, description) VALUES
(1,1,'Random teams'),
(1,2,'No teams (free-for-all)'),
(1,3,'Number of teams'),
(1,4,'Allies are placed randomly instead of opposite');

USE `lords_site`;
DROP procedure IF EXISTS `get_create_game_features`;

DELIMITER $$
USE `lords_site`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_create_game_features`(user_id INT)
BEGIN
  SELECT id,code as name,default_param,feature_type FROM lords.games_features;
END$$

DELIMITER ;

