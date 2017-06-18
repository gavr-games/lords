use lords_site;

DROP TABLE IF EXISTS `dic_player_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dic_player_status` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dic_player_status`
--

LOCK TABLES `dic_player_status` WRITE;
/*!40000 ALTER TABLE `dic_player_status` DISABLE KEYS */;
INSERT INTO `dic_player_status` VALUES (1,'online'),(2,'waiting_for_start'),(3,'in_game'),(4,'offline');
/*!40000 ALTER TABLE `dic_player_status` ENABLE KEYS */;
UNLOCK TABLES;


DROP TABLE IF EXISTS `dic_player_status_i18n`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dic_player_status_i18n` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `player_status_id` int(10) unsigned NOT NULL,
  `language_id` int(10) unsigned NOT NULL,
  `description` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

INSERT INTO `dic_player_status_i18n` (language_id, player_status_id, description) VALUES
(2,1,'Онлайн'),
(2,2,'Ждет старта игры'),
(2,3,'В игре'),
(2,4,'Офлайн');
INSERT INTO `dic_player_status_i18n` (language_id, player_status_id, description) VALUES
(1,1,'Online'),
(1,2,'Waiting for a game to start'),
(1,3,'In game'),
(1,4,'Offline');

use lords;


