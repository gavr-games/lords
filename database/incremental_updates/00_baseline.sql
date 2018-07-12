-- MySQL dump 10.13  Distrib 5.5.60, for linux-glibc2.12 (x86_64)
--
-- Host: localhost    Database: lords
-- ------------------------------------------------------
-- Server version	5.5.60

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `lords`
--

/*!40000 DROP DATABASE IF EXISTS `lords`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `lords` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `lords`;

--
-- Table structure for table `active_players`
--

DROP TABLE IF EXISTS `active_players`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `active_players` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `game_id` int(10) unsigned NOT NULL,
  `player_num` int(10) unsigned NOT NULL DEFAULT '0',
  `turn` int(10) unsigned NOT NULL,
  `subsidy_flag` int(10) unsigned NOT NULL DEFAULT '0',
  `units_moves_flag` int(10) unsigned NOT NULL DEFAULT '0',
  `card_played_flag` int(10) unsigned NOT NULL DEFAULT '0',
  `nonfinished_action_id` int(10) unsigned NOT NULL DEFAULT '0',
  `last_end_turn` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `current_procedure` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `active_players`
--

LOCK TABLES `active_players` WRITE;
/*!40000 ALTER TABLE `active_players` DISABLE KEYS */;
/*!40000 ALTER TABLE `active_players` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `allcoords`
--

DROP TABLE IF EXISTS `allcoords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `allcoords` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `x` int(11) NOT NULL DEFAULT '0',
  `y` int(11) NOT NULL DEFAULT '0',
  `mode_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `allcoords_modes` (`mode_id`),
  CONSTRAINT `allcoords_modes` FOREIGN KEY (`mode_id`) REFERENCES `modes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5289 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `allcoords`
--

LOCK TABLES `allcoords` WRITE;
/*!40000 ALTER TABLE `allcoords` DISABLE KEYS */;
INSERT INTO `allcoords` VALUES (4778,0,0,9),(4779,1,0,9),(4780,2,0,9),(4781,3,0,9),(4782,4,0,9),(4783,5,0,9),(4784,6,0,9),(4785,7,0,9),(4786,8,0,9),(4787,9,0,9),(4788,10,0,9),(4789,11,0,9),(4790,12,0,9),(4791,13,0,9),(4792,14,0,9),(4793,15,0,9),(4794,16,0,9),(4795,17,0,9),(4796,18,0,9),(4797,19,0,9),(4798,0,1,9),(4799,1,1,9),(4800,2,1,9),(4801,3,1,9),(4802,4,1,9),(4803,5,1,9),(4804,6,1,9),(4805,7,1,9),(4806,8,1,9),(4807,9,1,9),(4808,10,1,9),(4809,11,1,9),(4810,12,1,9),(4811,13,1,9),(4812,14,1,9),(4813,15,1,9),(4814,16,1,9),(4815,17,1,9),(4816,18,1,9),(4817,19,1,9),(4818,0,2,9),(4819,1,2,9),(4820,2,2,9),(4821,3,2,9),(4822,4,2,9),(4823,5,2,9),(4824,6,2,9),(4825,7,2,9),(4826,8,2,9),(4827,9,2,9),(4828,10,2,9),(4829,11,2,9),(4830,12,2,9),(4831,13,2,9),(4832,14,2,9),(4833,15,2,9),(4834,16,2,9),(4835,17,2,9),(4836,18,2,9),(4837,19,2,9),(4838,0,3,9),(4839,1,3,9),(4840,2,3,9),(4841,3,3,9),(4842,4,3,9),(4843,5,3,9),(4844,6,3,9),(4845,7,3,9),(4846,8,3,9),(4847,9,3,9),(4848,10,3,9),(4849,11,3,9),(4850,12,3,9),(4851,13,3,9),(4852,14,3,9),(4853,15,3,9),(4854,16,3,9),(4855,17,3,9),(4856,18,3,9),(4857,19,3,9),(4858,0,4,9),(4859,1,4,9),(4860,2,4,9),(4861,3,4,9),(4862,4,4,9),(4863,5,4,9),(4864,6,4,9),(4865,7,4,9),(4866,8,4,9),(4867,9,4,9),(4868,10,4,9),(4869,11,4,9),(4870,12,4,9),(4871,13,4,9),(4872,14,4,9),(4873,15,4,9),(4874,16,4,9),(4875,17,4,9),(4876,18,4,9),(4877,19,4,9),(4878,0,5,9),(4879,1,5,9),(4880,2,5,9),(4881,3,5,9),(4882,4,5,9),(4883,5,5,9),(4884,6,5,9),(4885,7,5,9),(4886,8,5,9),(4887,9,5,9),(4888,10,5,9),(4889,11,5,9),(4890,12,5,9),(4891,13,5,9),(4892,14,5,9),(4893,15,5,9),(4894,16,5,9),(4895,17,5,9),(4896,18,5,9),(4897,19,5,9),(4898,0,6,9),(4899,1,6,9),(4900,2,6,9),(4901,3,6,9),(4902,4,6,9),(4903,5,6,9),(4904,6,6,9),(4905,7,6,9),(4906,8,6,9),(4907,9,6,9),(4908,10,6,9),(4909,11,6,9),(4910,12,6,9),(4911,13,6,9),(4912,14,6,9),(4913,15,6,9),(4914,16,6,9),(4915,17,6,9),(4916,18,6,9),(4917,19,6,9),(4918,0,7,9),(4919,1,7,9),(4920,2,7,9),(4921,3,7,9),(4922,4,7,9),(4923,5,7,9),(4924,6,7,9),(4925,7,7,9),(4926,8,7,9),(4927,9,7,9),(4928,10,7,9),(4929,11,7,9),(4930,12,7,9),(4931,13,7,9),(4932,14,7,9),(4933,15,7,9),(4934,16,7,9),(4935,17,7,9),(4936,18,7,9),(4937,19,7,9),(4938,0,8,9),(4939,1,8,9),(4940,2,8,9),(4941,3,8,9),(4942,4,8,9),(4943,5,8,9),(4944,6,8,9),(4945,7,8,9),(4946,8,8,9),(4947,9,8,9),(4948,10,8,9),(4949,11,8,9),(4950,12,8,9),(4951,13,8,9),(4952,14,8,9),(4953,15,8,9),(4954,16,8,9),(4955,17,8,9),(4956,18,8,9),(4957,19,8,9),(4958,0,9,9),(4959,1,9,9),(4960,2,9,9),(4961,3,9,9),(4962,4,9,9),(4963,5,9,9),(4964,6,9,9),(4965,7,9,9),(4966,8,9,9),(4967,9,9,9),(4968,10,9,9),(4969,11,9,9),(4970,12,9,9),(4971,13,9,9),(4972,14,9,9),(4973,15,9,9),(4974,16,9,9),(4975,17,9,9),(4976,18,9,9),(4977,19,9,9),(4978,0,10,9),(4979,1,10,9),(4980,2,10,9),(4981,3,10,9),(4982,4,10,9),(4983,5,10,9),(4984,6,10,9),(4985,7,10,9),(4986,8,10,9),(4987,9,10,9),(4988,10,10,9),(4989,11,10,9),(4990,12,10,9),(4991,13,10,9),(4992,14,10,9),(4993,15,10,9),(4994,16,10,9),(4995,17,10,9),(4996,18,10,9),(4997,19,10,9),(4998,0,11,9),(4999,1,11,9),(5000,2,11,9),(5001,3,11,9),(5002,4,11,9),(5003,5,11,9),(5004,6,11,9),(5005,7,11,9),(5006,8,11,9),(5007,9,11,9),(5008,10,11,9),(5009,11,11,9),(5010,12,11,9),(5011,13,11,9),(5012,14,11,9),(5013,15,11,9),(5014,16,11,9),(5015,17,11,9),(5016,18,11,9),(5017,19,11,9),(5018,0,12,9),(5019,1,12,9),(5020,2,12,9),(5021,3,12,9),(5022,4,12,9),(5023,5,12,9),(5024,6,12,9),(5025,7,12,9),(5026,8,12,9),(5027,9,12,9),(5028,10,12,9),(5029,11,12,9),(5030,12,12,9),(5031,13,12,9),(5032,14,12,9),(5033,15,12,9),(5034,16,12,9),(5035,17,12,9),(5036,18,12,9),(5037,19,12,9),(5038,0,13,9),(5039,1,13,9),(5040,2,13,9),(5041,3,13,9),(5042,4,13,9),(5043,5,13,9),(5044,6,13,9),(5045,7,13,9),(5046,8,13,9),(5047,9,13,9),(5048,10,13,9),(5049,11,13,9),(5050,12,13,9),(5051,13,13,9),(5052,14,13,9),(5053,15,13,9),(5054,16,13,9),(5055,17,13,9),(5056,18,13,9),(5057,19,13,9),(5058,0,14,9),(5059,1,14,9),(5060,2,14,9),(5061,3,14,9),(5062,4,14,9),(5063,5,14,9),(5064,6,14,9),(5065,7,14,9),(5066,8,14,9),(5067,9,14,9),(5068,10,14,9),(5069,11,14,9),(5070,12,14,9),(5071,13,14,9),(5072,14,14,9),(5073,15,14,9),(5074,16,14,9),(5075,17,14,9),(5076,18,14,9),(5077,19,14,9),(5078,0,15,9),(5079,1,15,9),(5080,2,15,9),(5081,3,15,9),(5082,4,15,9),(5083,5,15,9),(5084,6,15,9),(5085,7,15,9),(5086,8,15,9),(5087,9,15,9),(5088,10,15,9),(5089,11,15,9),(5090,12,15,9),(5091,13,15,9),(5092,14,15,9),(5093,15,15,9),(5094,16,15,9),(5095,17,15,9),(5096,18,15,9),(5097,19,15,9),(5098,0,16,9),(5099,1,16,9),(5100,2,16,9),(5101,3,16,9),(5102,4,16,9),(5103,5,16,9),(5104,6,16,9),(5105,7,16,9),(5106,8,16,9),(5107,9,16,9),(5108,10,16,9),(5109,11,16,9),(5110,12,16,9),(5111,13,16,9),(5112,14,16,9),(5113,15,16,9),(5114,16,16,9),(5115,17,16,9),(5116,18,16,9),(5117,19,16,9),(5118,0,17,9),(5119,1,17,9),(5120,2,17,9),(5121,3,17,9),(5122,4,17,9),(5123,5,17,9),(5124,6,17,9),(5125,7,17,9),(5126,8,17,9),(5127,9,17,9),(5128,10,17,9),(5129,11,17,9),(5130,12,17,9),(5131,13,17,9),(5132,14,17,9),(5133,15,17,9),(5134,16,17,9),(5135,17,17,9),(5136,18,17,9),(5137,19,17,9),(5138,0,18,9),(5139,1,18,9),(5140,2,18,9),(5141,3,18,9),(5142,4,18,9),(5143,5,18,9),(5144,6,18,9),(5145,7,18,9),(5146,8,18,9),(5147,9,18,9),(5148,10,18,9),(5149,11,18,9),(5150,12,18,9),(5151,13,18,9),(5152,14,18,9),(5153,15,18,9),(5154,16,18,9),(5155,17,18,9),(5156,18,18,9),(5157,19,18,9),(5158,0,19,9),(5159,1,19,9),(5160,2,19,9),(5161,3,19,9),(5162,4,19,9),(5163,5,19,9),(5164,6,19,9),(5165,7,19,9),(5166,8,19,9),(5167,9,19,9),(5168,10,19,9),(5169,11,19,9),(5170,12,19,9),(5171,13,19,9),(5172,14,19,9),(5173,15,19,9),(5174,16,19,9),(5175,17,19,9),(5176,18,19,9),(5177,19,19,9);
/*!40000 ALTER TABLE `allcoords` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `appear_points`
--

DROP TABLE IF EXISTS `appear_points`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `appear_points` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `player_num` int(10) unsigned NOT NULL,
  `x` int(11) NOT NULL DEFAULT '0',
  `y` int(11) NOT NULL DEFAULT '0',
  `direction_into_board_x` int(11) NOT NULL DEFAULT '0',
  `direction_into_board_y` int(11) NOT NULL DEFAULT '0',
  `mode_id` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `appear_points_modes` (`mode_id`),
  CONSTRAINT `appear_points_modes` FOREIGN KEY (`mode_id`) REFERENCES `modes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appear_points`
--

LOCK TABLES `appear_points` WRITE;
/*!40000 ALTER TABLE `appear_points` DISABLE KEYS */;
INSERT INTO `appear_points` VALUES (48,0,1,1,1,1,9),(49,1,18,1,-1,1,9),(50,2,18,18,-1,-1,9),(51,3,1,18,1,-1,9);
/*!40000 ALTER TABLE `appear_points` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attack_bonus`
--

DROP TABLE IF EXISTS `attack_bonus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attack_bonus` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `mode_id` int(10) unsigned NOT NULL,
  `unit_id` int(11) DEFAULT NULL,
  `aim_type` varchar(45) DEFAULT NULL,
  `aim_id` int(10) unsigned DEFAULT NULL,
  `dice_max` int(10) unsigned NOT NULL DEFAULT '6',
  `chance` int(10) unsigned NOT NULL DEFAULT '4',
  `critical_chance` int(10) unsigned NOT NULL DEFAULT '6',
  `damage_bonus` int(11) NOT NULL DEFAULT '0',
  `critical_bonus` int(11) NOT NULL DEFAULT '1',
  `priority` int(11) NOT NULL DEFAULT '0',
  `comment` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `attack_bonus_modes` (`mode_id`),
  CONSTRAINT `attack_bonus_modes` FOREIGN KEY (`mode_id`) REFERENCES `modes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attack_bonus`
--

LOCK TABLES `attack_bonus` WRITE;
/*!40000 ALTER TABLE `attack_bonus` DISABLE KEYS */;
INSERT INTO `attack_bonus` VALUES (42,9,NULL,NULL,NULL,6,1,6,0,1,0,'Обычная атака всех на всех - попадание 100%, крит 1/3'),(43,9,NULL,'unit',18,12,4,12,0,1,5,'Попадание в ниндзю - 1/2, крит 1/6'),(44,9,20,'unit',NULL,3,1,4,-100,-100,10,'Таран не атакует юнитов'),(45,9,14,'unit',17,6,1,6,0,2,15,'Копейщик критическим на конного +1'),(46,9,16,'unit',23,6,1,6,0,3,15,'Рыцарь +2 критическим против дракона'),(47,9,17,'unit',23,6,1,6,0,3,15,'Конный рыцарь +2 критическим против дракона'),(48,9,NULL,'unit',19,6,1,6,-1,0,5,'По голему -1 урона');
/*!40000 ALTER TABLE `attack_bonus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `board`
--

DROP TABLE IF EXISTS `board`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `board` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `game_id` int(10) unsigned NOT NULL,
  `x` int(11) NOT NULL DEFAULT '0',
  `y` int(11) NOT NULL DEFAULT '0',
  `type` varchar(45) NOT NULL,
  `ref` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `board`
--

LOCK TABLES `board` WRITE;
/*!40000 ALTER TABLE `board` DISABLE KEYS */;
/*!40000 ALTER TABLE `board` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `board_buildings`
--

DROP TABLE IF EXISTS `board_buildings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `board_buildings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `game_id` int(10) unsigned NOT NULL,
  `building_id` int(10) unsigned NOT NULL DEFAULT '0',
  `player_num` int(10) unsigned NOT NULL,
  `health` int(10) unsigned NOT NULL DEFAULT '0',
  `max_health` int(10) unsigned NOT NULL DEFAULT '0',
  `radius` int(10) NOT NULL DEFAULT '0',
  `card_id` int(10) unsigned DEFAULT NULL,
  `income` int(10) unsigned NOT NULL DEFAULT '0',
  `rotation` int(10) unsigned NOT NULL DEFAULT '0',
  `flip` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `board_buildings`
--

LOCK TABLES `board_buildings` WRITE;
/*!40000 ALTER TABLE `board_buildings` DISABLE KEYS */;
/*!40000 ALTER TABLE `board_buildings` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `board_buildings_bi` BEFORE INSERT ON `board_buildings`
 FOR EACH ROW BEGIN
  IF (NEW.building_id=0 AND NEW.card_id IS NOT NULL)
  THEN
    SET NEW.building_id=(SELECT cards.ref FROM cards WHERE cards.id=NEW.card_id);
  END IF;
  SET NEW.health=(SELECT buildings.health FROM buildings WHERE buildings.id=NEW.building_id);
  SET NEW.max_health=NEW.health;
  SET NEW.radius=(SELECT buildings.radius FROM buildings WHERE buildings.id=NEW.building_id);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `board_buildings_features`
--

DROP TABLE IF EXISTS `board_buildings_features`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `board_buildings_features` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `board_building_id` int(10) unsigned NOT NULL,
  `feature_id` int(10) unsigned NOT NULL,
  `param` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `board_buildings_features_board_buildings` (`board_building_id`),
  KEY `board_buildings_features_building_features` (`feature_id`),
  CONSTRAINT `board_buildings_features_building_features` FOREIGN KEY (`feature_id`) REFERENCES `building_features` (`id`) ON DELETE CASCADE,
  CONSTRAINT `board_buildings_features_board_buildings` FOREIGN KEY (`board_building_id`) REFERENCES `board_buildings` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `board_buildings_features`
--

LOCK TABLES `board_buildings_features` WRITE;
/*!40000 ALTER TABLE `board_buildings_features` DISABLE KEYS */;
/*!40000 ALTER TABLE `board_buildings_features` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `board_units`
--

DROP TABLE IF EXISTS `board_units`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `board_units` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `game_id` int(10) unsigned NOT NULL,
  `player_num` int(10) unsigned NOT NULL,
  `unit_id` int(10) unsigned NOT NULL DEFAULT '0',
  `card_id` int(10) unsigned DEFAULT NULL,
  `health` int(11) NOT NULL DEFAULT '0',
  `max_health` int(11) NOT NULL DEFAULT '0',
  `attack` int(11) NOT NULL DEFAULT '0',
  `moves_left` int(11) NOT NULL DEFAULT '0',
  `moves` int(11) NOT NULL DEFAULT '0',
  `shield` int(11) NOT NULL DEFAULT '0',
  `experience` int(11) NOT NULL DEFAULT '0',
  `level` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `board_units`
--

LOCK TABLES `board_units` WRITE;
/*!40000 ALTER TABLE `board_units` DISABLE KEYS */;
/*!40000 ALTER TABLE `board_units` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `board_units_bi` BEFORE INSERT ON `board_units`
 FOR EACH ROW BEGIN
  IF (NEW.unit_id=0 AND NEW.card_id IS NOT NULL)
  THEN
    SET NEW.unit_id=(SELECT cards.ref FROM cards WHERE cards.id=NEW.card_id);
  END IF;
  SET NEW.health=(SELECT units.health FROM units WHERE units.id=NEW.unit_id);
  SET NEW.max_health=NEW.health;
  SET NEW.attack=(SELECT units.attack FROM units WHERE units.id=NEW.unit_id);
  SET NEW.moves=(SELECT units.moves FROM units WHERE units.id=NEW.unit_id);
  SET NEW.moves_left=NEW.moves;
  SET NEW.shield=(SELECT units.shield FROM units WHERE units.id=NEW.unit_id);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `board_units_features`
--

DROP TABLE IF EXISTS `board_units_features`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `board_units_features` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `board_unit_id` int(10) unsigned NOT NULL,
  `feature_id` int(10) unsigned NOT NULL,
  `param` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `board_units_features_board_units` (`board_unit_id`),
  KEY `board_units_features_unit_features` (`feature_id`),
  CONSTRAINT `board_units_features_unit_features` FOREIGN KEY (`feature_id`) REFERENCES `unit_features` (`id`) ON DELETE CASCADE,
  CONSTRAINT `board_units_features_board_units` FOREIGN KEY (`board_unit_id`) REFERENCES `board_units` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `board_units_features`
--

LOCK TABLES `board_units_features` WRITE;
/*!40000 ALTER TABLE `board_units_features` DISABLE KEYS */;
/*!40000 ALTER TABLE `board_units_features` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `building_default_features`
--

DROP TABLE IF EXISTS `building_default_features`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `building_default_features` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `building_id` int(10) unsigned NOT NULL,
  `feature_id` int(10) unsigned NOT NULL,
  `param` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `building_default_features_buildings` (`building_id`),
  KEY `building_default_features_features` (`feature_id`),
  CONSTRAINT `building_default_features_buildings` FOREIGN KEY (`building_id`) REFERENCES `buildings` (`id`) ON DELETE CASCADE,
  CONSTRAINT `building_default_features_features` FOREIGN KEY (`feature_id`) REFERENCES `building_features` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=88 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `building_default_features`
--

LOCK TABLES `building_default_features` WRITE;
/*!40000 ALTER TABLE `building_default_features` DISABLE KEYS */;
INSERT INTO `building_default_features` VALUES (59,9,1,NULL),(60,10,3,3),(61,11,7,NULL),(62,12,2,NULL),(63,13,4,NULL),(64,13,6,NULL),(65,13,8,NULL),(66,14,5,NULL),(67,14,6,NULL),(68,17,9,NULL),(69,17,10,NULL),(70,18,11,4),(71,20,13,NULL),(72,19,14,NULL),(74,16,16,NULL),(75,21,8,NULL),(76,21,12,NULL),(77,22,17,NULL),(78,22,12,NULL),(79,23,18,NULL),(80,23,8,NULL),(81,23,12,NULL),(82,22,19,NULL),(83,22,20,30),(84,18,20,0),(85,18,19,NULL),(86,18,21,NULL),(87,22,21,NULL);
/*!40000 ALTER TABLE `building_default_features` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `building_features`
--

DROP TABLE IF EXISTS `building_features`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `building_features` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `building_features`
--

LOCK TABLES `building_features` WRITE;
/*!40000 ALTER TABLE `building_features` DISABLE KEYS */;
INSERT INTO `building_features` VALUES (1,'teleport'),(2,'healing'),(3,'magic_increase'),(4,'frog_factory'),(5,'troll_factory'),(6,'summon_team'),(7,'coin_factory'),(8,'water'),(9,'ally'),(10,'barracks'),(11,'for_initialization'),(12,'not_movable'),(13,'wall_opened'),(14,'wall_closed'),(15,'turn_when_changed'),(16,'ruins'),(17,'destroyable_bridge'),(18,'destroyed_bridge'),(19,'not_interesting_for_npc'),(20,'destroy_reward'),(21,'no_exp');
/*!40000 ALTER TABLE `building_features` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `building_features_i18n`
--

DROP TABLE IF EXISTS `building_features_i18n`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `building_features_i18n` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `feature_id` int(10) unsigned NOT NULL,
  `language_id` int(10) unsigned NOT NULL,
  `description` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `feature_id` (`feature_id`),
  CONSTRAINT `building_features_i18n_ibfk_1` FOREIGN KEY (`feature_id`) REFERENCES `building_features` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `building_features_i18n`
--

LOCK TABLES `building_features_i18n` WRITE;
/*!40000 ALTER TABLE `building_features_i18n` DISABLE KEYS */;
INSERT INTO `building_features_i18n` VALUES (1,1,2,'Позволяет телепортировать союзных юнитов в свой радиус'),(2,2,2,'Лечит союзных и сумасшедших юнитов в своем радиусе'),(3,3,2,'Увеличивает эффект от магии в своем радиусе'),(4,4,2,'Плодит Жабок'),(5,5,2,'Плодит Троллей'),(6,6,2,'Номер команды плодимых юнитов'),(7,7,2,'Монетный двор'),(8,8,2,'Можно утонуть'),(9,9,2,'Плодит союзников'),(10,10,2,'Казарма'),(11,11,2,'Изначальный объект на доске'),(12,12,2,'Здание нельзя переместить картами'),(13,13,2,'Открытая стена'),(14,14,2,'Закрытая стена'),(15,15,2,'Номер хода, когда здание поменялось'),(16,16,2,'Руины замка'),(17,17,2,'Мост, который можно разрушить'),(18,18,2,'Разрушенный мост'),(19,19,2,'NPC в здравом уме это не атакуют'),(20,20,2,'За разрушение здания игрок получает награду в определенном размере'),(21,1,1,'Allows to teleport ally units into its radius'),(22,2,1,'Heals ally and mad units in its radius'),(23,3,1,'Increases effects of magic in its radius'),(24,4,1,'Spawns Frogs'),(25,5,1,'Spawns Trolls'),(26,6,1,'Spawn units team number'),(27,7,1,'Coin factory'),(28,8,1,'Can drown here'),(29,9,1,'Spawns ally NPC units'),(30,10,1,'Barracks'),(31,11,1,'Initial object'),(32,12,1,'Cannot be moved by cards'),(33,13,1,'Open wall'),(34,14,1,'Closed wall'),(35,15,1,'Turn when the building acted'),(36,16,1,'Castle ruins'),(37,17,1,'Bridge that can be destroyed'),(38,18,1,'Destroyed bridge'),(39,19,1,'Sane NPCs do not attack this'),(40,20,1,'There is a reward for destroying this building'),(41,21,2,'Не приносит опыта'),(42,21,1,'Gives no experience');
/*!40000 ALTER TABLE `building_features_i18n` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `buildings`
--

DROP TABLE IF EXISTS `buildings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `buildings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `health` int(10) unsigned NOT NULL,
  `radius` int(10) DEFAULT NULL,
  `x_len` int(10) unsigned NOT NULL,
  `y_len` int(10) unsigned NOT NULL,
  `shape` varchar(400) DEFAULT NULL,
  `type` varchar(45) NOT NULL DEFAULT '',
  `ui_code` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buildings`
--

LOCK TABLES `buildings` WRITE;
/*!40000 ALTER TABLE `buildings` DISABLE KEYS */;
INSERT INTO `buildings` VALUES (9,3,1,1,1,'1','building','teleport'),(10,3,2,1,1,'1','building','magic_tower'),(11,4,2,1,1,'1','building','coin_factory'),(12,3,1,1,1,'1','building','healing_temple'),(13,0,0,4,3,'011011110110','obstacle','lake'),(14,0,0,5,4,'00011001100110011000','obstacle','mountain'),(15,10,0,2,2,'1110','castle','castle'),(16,0,0,2,2,'1110','obstacle','ruins'),(17,3,1,1,1,'1','building','barracks'),(18,2,0,1,1,'1','building','tree'),(19,100,0,4,4,'0001000100011111','building','wall_closed'),(20,100,0,4,4,'0001000100001100','building','wall_opened'),(21,0,0,8,8,'0011110000000000100000011000000110000001100000010000000000111100','obstacle','moat'),(22,10,0,2,2,'0110','building','bridge'),(23,0,0,2,2,'1110','obstacle','destroyed_bridge');
/*!40000 ALTER TABLE `buildings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `buildings_i18n`
--

DROP TABLE IF EXISTS `buildings_i18n`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `buildings_i18n` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `building_id` int(10) unsigned NOT NULL,
  `language_id` int(10) unsigned NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `log_short_name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `building_id` (`building_id`),
  CONSTRAINT `buildings_i18n_ibfk_1` FOREIGN KEY (`building_id`) REFERENCES `buildings` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buildings_i18n`
--

LOCK TABLES `buildings_i18n` WRITE;
/*!40000 ALTER TABLE `buildings_i18n` DISABLE KEYS */;
INSERT INTO `buildings_i18n` VALUES (9,9,2,'Телепорт','Позволяет перемещать свои юниты и юниты союзника в радиус действия телепорта','Телепорт'),(10,10,2,'Магическая башня','Усиливает магию владельца и союзников в 3 раза в радиусе своего действия.','Маг. баш.'),(11,11,2,'Монетный двор','Дополнительный доход за юнитов в радиусе','Мон. двор'),(12,12,2,'Храм лечения','Лечит здоровье юнитов и восстанавливает щит магу','Храм леч.'),(13,13,2,'Озеро','Из озера появляются 3 жабки, которые бьют ближайших юнитов любых игроков','Озеро'),(14,14,2,'Горы','Из гор появляется тролль, который идет бить ближайшее здание','Горы'),(15,15,2,'Замок',NULL,'Замок'),(16,16,2,'Руины замка','Здесь когда-то жил Лорд...','Руины'),(17,17,2,'Казарма','Появляются союзные NPC копейщик и лучник. Потом иногда появляются еще копейщики или лучники.','Казарма'),(18,18,2,'Дерево','Тис ягодный.','Дерево'),(19,19,2,'Крепостная Стена','Можно защитить замок.','Стена'),(20,20,2,'Крепостная Стена','Можно защитить замок. Если закрыть ворота.','Стена'),(21,21,2,'Ров','Окружает остров в середине карты.','Ров'),(22,22,2,'Мост','Можно разрушить.','Мост'),(23,23,2,'Руины моста','Здесь когда-то стоял мост.','Руины'),(32,9,1,'Portal','Allows to teleport owner\'s and allied units into its radius',NULL),(33,10,1,'Magic tower','Triples magic of the owner and allies in its radius','M.Tower'),(34,11,1,'Coin factory','Extra income for units that stay in its radius','C.Factory'),(35,12,1,'Healing temple','Heals owner\'s, allied, and mad units','H.Temple'),(36,13,1,'Lake','Spawns 3 agessive frogs, may spawn more later',NULL),(37,14,1,'Mountains','Spawns a troll that wants to destroy buildings, may spawn more later',NULL),(38,15,1,'Castle',NULL,NULL),(39,16,1,'Ruins','Once here lived a Lord',NULL),(40,17,1,'Barracks','Spawns allied NPC Spearman and Archer, may spawn more later',NULL),(41,18,1,'Tree',NULL,NULL),(42,19,1,'Wall','Can protect a castle',NULL),(43,20,1,'Wall','Could protect a castle if closed',NULL),(44,21,1,'Moat','Protects from invaders',NULL),(45,22,1,'Bridge','Can be destroyed',NULL),(46,23,1,'Ruined bridge','Once here stood a bridge',NULL);
/*!40000 ALTER TABLE `buildings_i18n` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `buildings_procedures`
--

DROP TABLE IF EXISTS `buildings_procedures`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `buildings_procedures` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `building_id` int(10) unsigned NOT NULL,
  `procedure_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `buildings_procedures_buildings` (`building_id`),
  KEY `buildings_procedures_procedures` (`procedure_id`),
  CONSTRAINT `buildings_procedures_buildings` FOREIGN KEY (`building_id`) REFERENCES `buildings` (`id`) ON DELETE CASCADE,
  CONSTRAINT `buildings_procedures_procedures` FOREIGN KEY (`procedure_id`) REFERENCES `procedures` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buildings_procedures`
--

LOCK TABLES `buildings_procedures` WRITE;
/*!40000 ALTER TABLE `buildings_procedures` DISABLE KEYS */;
INSERT INTO `buildings_procedures` VALUES (1,19,59),(2,20,60);
/*!40000 ALTER TABLE `buildings_procedures` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cards`
--

DROP TABLE IF EXISTS `cards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cards` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `image` varchar(45) NOT NULL,
  `cost` int(10) unsigned NOT NULL,
  `type` varchar(45) NOT NULL,
  `ref` int(10) unsigned NOT NULL,
  `code` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=109 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cards`
--

LOCK TABLES `cards` WRITE;
/*!40000 ALTER TABLE `cards` DISABLE KEYS */;
INSERT INTO `cards` VALUES (61,'teleport_building.png',0,'b',9,'teleport_building'),(62,'magic_tower.png',0,'b',10,'magic_tower'),(63,'coin_factory.png',0,'b',11,'coin_factory'),(64,'healing_temple.png',0,'b',12,'healing_temple'),(65,'lake.png',0,'b',13,'lake'),(66,'mountain.png',0,'b',14,'mountain'),(67,'spearman.png',2,'u',14,'spearman'),(68,'swordsman.png',3,'u',15,'swordsman'),(69,'knight_on_foot.png',10,'u',16,'knight_on_foot'),(70,'knight_with_horse.png',25,'u',17,'knight_with_horse'),(71,'ninja.png',30,'u',18,'ninja'),(72,'golem.png',30,'u',19,'golem'),(73,'taran.png',10,'u',20,'taran'),(74,'wizard.png',35,'u',21,'wizard'),(75,'necromancer.png',35,'u',22,'necromancer'),(76,'dragon.png',100,'u',23,'dragon'),(77,'fireball.png',5,'m',0,'fireball'),(78,'healing.png',5,'m',0,'healing'),(79,'lightening.png',10,'m',0,'lightening'),(80,'od.png',30,'m',0,'od'),(81,'teleport_magic.png',70,'m',0,'teleport_magic'),(82,'paralich.png',20,'m',0,'paralich'),(83,'armageddon.png',100,'m',0,'armageddon'),(84,'meteor.png',50,'m',0,'meteor'),(85,'shield.png',30,'m',0,'shield'),(86,'vred.png',20,'m',0,'vred'),(87,'mind_control.png',80,'m',0,'mind_control'),(89,'madness.png',30,'m',0,'madness'),(90,'open_cards.png',0,'m',0,'open_cards'),(91,'telekinesis.png',20,'m',0,'telekinesis'),(92,'half_money.png',1,'m',0,'half_money'),(93,'pooring.png',20,'m',0,'pooring'),(94,'riching.png',0,'m',0,'riching'),(95,'vampire.png',35,'m',0,'vampire'),(96,'fastening.png',10,'m',0,'fastening'),(98,'polza.png',20,'m',0,'polza'),(99,'upgrade.png',25,'m',0,'upgrade'),(100,'repair.png',0,'m',0,'repair'),(101,'archer.png',20,'u',27,'archer'),(102,'arbalester.png',30,'u',28,'arbalester'),(103,'catapult.png',15,'u',29,'catapult'),(104,'barracks.png',0,'b',17,'barracks'),(105,'wall.png',0,'b',19,'wall'),(106,'iron_skin.png',10,'m',0,'iron_skin'),(107,'berserk.png',10,'m',0,'berserk'),(108,'horseshoe.png',10,'m',0,'horseshoe');
/*!40000 ALTER TABLE `cards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cards_i18n`
--

DROP TABLE IF EXISTS `cards_i18n`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cards_i18n` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `card_id` int(10) unsigned NOT NULL,
  `language_id` int(10) unsigned NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `card_id` (`card_id`),
  CONSTRAINT `cards_i18n_ibfk_1` FOREIGN KEY (`card_id`) REFERENCES `cards` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=177 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cards_i18n`
--

LOCK TABLES `cards_i18n` WRITE;
/*!40000 ALTER TABLE `cards_i18n` DISABLE KEYS */;
INSERT INTO `cards_i18n` VALUES (41,61,2,'Телепорт',NULL),(42,62,2,'Магическая башня',NULL),(43,63,2,'Монетный двор',NULL),(44,64,2,'Храм лечения',NULL),(45,65,2,'Озеро',NULL),(46,66,2,'Горы',NULL),(47,67,2,'Копейщик',NULL),(48,68,2,'Мечник',NULL),(49,69,2,'Рыцарь',NULL),(50,70,2,'Конный рыцарь',NULL),(51,71,2,'Ниндзя',NULL),(52,72,2,'Голем',NULL),(53,73,2,'Таран',NULL),(54,74,2,'Маг',NULL),(55,75,2,'Некромант',NULL),(56,76,2,'Дракон',NULL),(57,77,2,'Огненный шар','Наносит 1 ед. урона по выбранному юниту.'),(58,78,2,'Лечение','Восстанавливает 1 ед. здоровья или снимает паралич или бешенство. Восстанавливает 1 щит магу.'),(59,79,2,'Молния','Слабая молния наносит 2 ед. урона по юнитам. Сильная молния наносит 3 ед. урона с вероятностью 2/3.'),(60,80,2,'Отделение души','С вероятностью 5/6 убивает юнит или 1/6 повергает в бешенство.'),(61,81,2,'Телепорт','Переместить любой юнит в свободную клетку.'),(62,82,2,'Паралич','Парализует любой юнит.'),(63,83,2,'Армагеддон','С вероятностью 5/6 уничтожает каждый объект на карте кроме замков'),(64,84,2,'Метеоритный дождь','Наносит 2ед урона зданиям и юнитам. Площадь атаки 2 на 2.'),(65,85,2,'Щит','+1 щит любому юниту.'),(66,86,2,'Вред','С вероятностью 1/6: -60 золота любому игроку; убить любого юнита; разрушить любое здание; переместить юнитов в случайную зону; вытянуть у всех остальных по карте; переместить чужое здание.'),(67,87,2,'Контроль разума','Дает контроль над выбранным юнитом.'),(69,89,2,'Бешенство','Повергает выбранного юнита в бешенство.'),(70,90,2,'Открыть карты выбранного игрока','1 раз открывает все карты выбранного игрока.'),(71,91,2,'Телекинез','Вытянуть у любого игрока 1 карту.'),(72,92,2,'Сокращение денег в два раза у всех игроков','Сокращает деньги в 2 раза у всех игроков.'),(73,93,2,'Обеднение','-50 золота у выбраного игрока.'),(74,94,2,'Обогащение','+50 золота.'),(75,95,2,'Вампир','Призывает Вампира, который действует сам по себе - бьет ближайших юнитов и здания.'),(76,96,2,'Ускорение','+2 хода выбранному юниту.'),(78,98,2,'Польза','С вероятностью 1/6: починка всех своих зданий включая Замок и исцеление всех своих юнитов; воскресить любого юнита; +60 золота; взять 2 карты; переместить всех юнитов из выбранной зоны; переместить и присвоить здание.'),(79,99,2,'Улучшение','На выбор игрока +1 к атаке, здоровью и ходьбе; или с вероятностью 1/3 +3 к атаке, здоровью или ходьбе.'),(80,100,2,'Починить здания','Починка всех своих здания включая Замок.'),(81,101,2,'Лучник',NULL),(82,102,2,'Арбалетчик',NULL),(83,103,2,'Катапульта',NULL),(84,104,2,'Казарма',NULL),(85,105,2,'Стена',NULL),(126,61,1,'Portal',NULL),(127,62,1,'Magic tower',NULL),(128,63,1,'Coin factory',NULL),(129,64,1,'Healing temple',NULL),(130,65,1,'Lake',NULL),(131,66,1,'Mountains',NULL),(132,67,1,'Spearman',NULL),(133,68,1,'Swordsman',NULL),(134,69,1,'Knight',NULL),(135,70,1,'Chevalier',NULL),(136,71,1,'Ninja',NULL),(137,72,1,'Golem',NULL),(138,73,1,'Ram',NULL),(139,74,1,'Wizard',NULL),(140,75,1,'Necromancer',NULL),(141,76,1,'Dragon',NULL),(142,77,1,'Fireball','Causes 1 damage to a chosen unit'),(143,78,1,'Healing','Restores 1 health to a chosen unit or removes madness/paralysis or restores wizard\'s shield'),(144,79,1,'Lightning','Causes 2 damage to units (weak lightning) or 3 damage with probability 2/3 (strong lightning)'),(145,80,1,'Soul detachment','Kills a unit with probability 5/6 or makes mad with probability 1/6'),(146,81,1,'Teleportation','Move any unit to any free square'),(147,82,1,'Paralysis','Paralyse any unit. Unit remains inactive until healed or attacked'),(148,83,1,'Armageddon','Destroys each object on board (except castles) with probability 5/6'),(149,84,1,'Meteor shower','Causes 2 damage to units and buildings (except castles) in area 2 x 2 squares'),(150,85,1,'Shield','Give a magical shield to any unit'),(151,86,1,'Black dice','One of the following events randomly: -60 gold to a chosen player; kill a chosen unit; destroy a chosen building (except castles); teleport someone else\'s building (except castles); move all units to a random zone; steal a card from every other player'),(152,87,1,'Mind control','Gives control over a chosen unit'),(154,89,1,'Madness','Makes a chosen unit mad. Mad units move to and attack the closest unit'),(155,90,1,'Reveal cards','Chosen player reveals cards'),(156,91,1,'Telekinesis','Steal a random card from a chosen player'),(157,92,1,'Crysis','All players loose half of their gold'),(158,93,1,'Empty chest','-50 gold to a chosen player'),(159,94,1,'Chest of gold','+50 gold'),(160,95,1,'Vampire','Summon a vampire in your zone. Vampire attacks closest units and buildings'),(161,96,1,'Acceleration','+2 movement points to any unit'),(163,98,1,'White dice','One of the following events randomly: repair all your buildings including the castle and heal all your units; resurrect any unit (if there are any); +60 gold; pick 2 cards from the deck; move all units out of a chosen zone; steal someone else\'s building and move it anywhere'),(164,99,1,'Enhancement','Either +1 attack, +1 move, +1 health to a chosen unit (uniform enhancement) or +3 to a random parameter (random enhancement)'),(165,100,1,'Repair','Repair all your buildings including the castle'),(166,101,1,'Archer',NULL),(167,102,1,'Marksman',NULL),(168,103,1,'Catapult',NULL),(169,104,1,'Barracks',NULL),(170,105,1,'Wall',NULL),(171,106,1,'Iron skin','+2 health to any unit'),(172,106,2,'Железная кожа','+2 здоровья выбранному юниту.'),(173,107,1,'Berserk','+2 attack to any unit'),(174,107,2,'Берсерк','+2 атаки выбранному юниту.'),(175,108,1,'Horseshoe','Chosen unit starts to move as a chess knight'),(176,108,2,'Подкова','Выбранный юнит начинает ходить шахматным конем.');
/*!40000 ALTER TABLE `cards_i18n` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cards_procedures`
--

DROP TABLE IF EXISTS `cards_procedures`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cards_procedures` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `card_id` int(10) unsigned NOT NULL,
  `procedure_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `cards_procedures_cards` (`card_id`),
  KEY `cards_procedures_procedures` (`procedure_id`),
  CONSTRAINT `cards_procedures_cards` FOREIGN KEY (`card_id`) REFERENCES `cards` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cards_procedures_procedures` FOREIGN KEY (`procedure_id`) REFERENCES `procedures` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=383 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cards_procedures`
--

LOCK TABLES `cards_procedures` WRITE;
/*!40000 ALTER TABLE `cards_procedures` DISABLE KEYS */;
INSERT INTO `cards_procedures` VALUES (331,61,6),(332,62,6),(333,63,6),(334,64,6),(335,65,6),(336,66,6),(337,67,10),(338,68,10),(339,69,10),(340,70,10),(341,71,10),(342,72,10),(343,73,10),(344,74,10),(345,75,10),(346,76,10),(347,77,11),(348,78,24),(349,79,12),(350,79,13),(352,80,26),(353,81,27),(354,82,19),(355,83,35),(356,84,36),(357,85,23),(358,86,42),(359,87,28),(361,89,22),(362,90,29),(363,91,30),(364,92,9),(365,93,7),(366,94,8),(367,95,51),(368,96,32),(370,98,38),(371,99,33),(372,99,34),(374,100,37),(375,101,10),(376,102,10),(377,103,10),(378,104,6),(379,105,6),(380,106,62),(381,107,63),(382,108,64);
/*!40000 ALTER TABLE `cards_procedures` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `deck`
--

DROP TABLE IF EXISTS `deck`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `deck` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `game_id` int(10) unsigned NOT NULL,
  `card_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `deck`
--

LOCK TABLES `deck` WRITE;
/*!40000 ALTER TABLE `deck` DISABLE KEYS */;
/*!40000 ALTER TABLE `deck` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dic_colors`
--

DROP TABLE IF EXISTS `dic_colors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dic_colors` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(45) NOT NULL,
  `color` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dic_colors`
--

LOCK TABLES `dic_colors` WRITE;
/*!40000 ALTER TABLE `dic_colors` DISABLE KEYS */;
INSERT INTO `dic_colors` VALUES (1,'p0','#fcff00'),(2,'p1','#f000ff'),(3,'p2','#0006ff'),(4,'p3','#00e4ff'),(5,'magic','#000099'),(6,'event','#cc6600'),(7,'unit','#66cc33'),(8,'building','#993300'),(9,'chat_p0','#fcff00'),(10,'chat_p1','#f000ff'),(11,'chat_p2','#5c5ccf'),(12,'chat_p3','#00e4ff'),(13,'chat_spectator','#ffffff');
/*!40000 ALTER TABLE `dic_colors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dic_game_status`
--

DROP TABLE IF EXISTS `dic_game_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dic_game_status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dic_game_status`
--

LOCK TABLES `dic_game_status` WRITE;
/*!40000 ALTER TABLE `dic_game_status` DISABLE KEYS */;
INSERT INTO `dic_game_status` VALUES (1,'created'),(2,'started'),(3,'finished');
/*!40000 ALTER TABLE `dic_game_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dic_owner`
--

DROP TABLE IF EXISTS `dic_owner`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dic_owner` (
  `id` int(11) NOT NULL,
  `description` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dic_owner`
--

LOCK TABLES `dic_owner` WRITE;
/*!40000 ALTER TABLE `dic_owner` DISABLE KEYS */;
INSERT INTO `dic_owner` VALUES (0,'Spectator'),(1,'Человек'),(2,'Жабка'),(3,'Тролль'),(4,'Вампир');
/*!40000 ALTER TABLE `dic_owner` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dic_statistic_measures`
--

DROP TABLE IF EXISTS `dic_statistic_measures`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dic_statistic_measures` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(100) NOT NULL,
  `count_rule` varchar(1000) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dic_statistic_measures`
--

LOCK TABLES `dic_statistic_measures` WRITE;
/*!40000 ALTER TABLE `dic_statistic_measures` DISABLE KEYS */;
INSERT INTO `dic_statistic_measures` VALUES (1,'Заработал золота','SELECT IFNULL(SUM(sga.`value`),0) as value FROM statistic_game_actions sga WHERE sga.game_id=$g_id AND sga.player_num=$p_num AND sga.`action`=\'change_gold\' AND sga.`value`>0'),(2,'Потратил золота','SELECT IFNULL(ABS(SUM(sga.`value`)),0) as value FROM statistic_game_actions sga WHERE sga.game_id=$g_id AND sga.player_num=$p_num AND sga.`action`=\'change_gold\' AND sga.`value`<0'),(3,'Купил карт','SELECT COUNT(*) as value FROM statistic_game_actions sga WHERE sga.game_id=$g_id AND sga.player_num=$p_num AND sga.`action`=\'buy_card\''),(4,'Сыграл карт','SELECT COUNT(*) as value FROM statistic_game_actions sga WHERE sga.game_id=$g_id AND sga.player_num=$p_num AND sga.`action`=\'play_card\''),(5,'Сыграл магий','SELECT COUNT(*) as value FROM statistic_game_actions sga JOIN cards c ON (sga.`value`=c.id) WHERE sga.game_id=$g_id AND sga.player_num=$p_num AND sga.`action`=\'play_card\' AND c.`type`=\'m\''),(7,'Сыграл юнитов','SELECT COUNT(*) as value FROM statistic_game_actions sga JOIN cards c ON (sga.`value`=c.id) WHERE sga.game_id=$g_id AND sga.player_num=$p_num AND sga.`action`=\'play_card\' AND c.`type`=\'u\''),(8,'Сыграл зданий','SELECT COUNT(*) as value FROM statistic_game_actions sga JOIN cards c ON (sga.`value`=c.id) WHERE sga.game_id=$g_id AND sga.player_num=$p_num AND sga.`action`=\'play_card\' AND c.`type`=\'b\''),(9,'Нанес урона','SELECT IFNULL(SUM(sga.`value`),0) as value FROM statistic_game_actions sga WHERE sga.game_id=$g_id AND sga.player_num=$p_num AND sga.`action`=\'make_damage\''),(14,'Убил юнитов','SELECT COUNT(*) as value FROM statistic_game_actions sga WHERE sga.game_id=$g_id AND sga.player_num=$p_num AND sga.`action`=\'kill_unit\''),(16,'Разрушил зданий','SELECT COUNT(*) as value FROM statistic_game_actions sga WHERE sga.game_id=$g_id AND sga.player_num=$p_num AND sga.`action`=\'destroy_building\''),(18,'Процент попаданий','SELECT 1-IFNULL(((SELECT COUNT(*) as value FROM statistic_game_actions sga WHERE sga.game_id=$g_id AND sga.player_num=$p_num AND sga.`action`=\'miss_attack\')/(SELECT COUNT(*) as value FROM statistic_game_actions sga WHERE sga.game_id=$g_id AND sga.player_num=$p_num AND sga.`action` IN (\'unit_attack\',\'magical_attack\'))),1) as value FROM DUAL'),(19,'Процент критических ударов','SELECT IFNULL((SELECT COUNT(*) as value FROM statistic_game_actions sga WHERE sga.game_id=$g_id AND sga.player_num=$p_num AND sga.`action`=\'critical_hit\')/(SELECT COUNT(*) as value FROM statistic_game_actions sga WHERE sga.game_id=$g_id AND sga.player_num=$p_num AND sga.`action`=\'unit_attack\'),0) as value FROM DUAL'),(20,'Призвал юнитов','SELECT COUNT(*) as value FROM statistic_game_actions sga JOIN cards c ON (sga.`value`=c.id) WHERE sga.game_id=$g_id AND sga.player_num=$p_num AND sga.`action`=\'play_card\' AND c.`type`=\'u\''),(21,'Призвал зданий','SELECT COUNT(*) as value FROM statistic_game_actions sga JOIN cards c ON (sga.`value`=c.id) WHERE sga.game_id=$g_id AND sga.player_num=$p_num AND sga.`action`=\'play_card\' AND c.`type`=\'b\''),(22,'Воскрешенных юнитов','SELECT COUNT(*) as value FROM statistic_game_actions sga WHERE sga.game_id=$g_id AND sga.player_num=$p_num AND sga.`action`=\'resurrect_unit\''),(23,'Initial cards','SELECT sga.value as value FROM statistic_game_actions sga WHERE sga.game_id=$g_id AND sga.player_num=$p_num AND sga.`action`=\'initial_card\'');
/*!40000 ALTER TABLE `dic_statistic_measures` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dic_unit_phrases`
--

DROP TABLE IF EXISTS `dic_unit_phrases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dic_unit_phrases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `unit_id` int(10) unsigned NOT NULL,
  `language_id` int(10) unsigned NOT NULL,
  `phrase` varchar(1000) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `dic_unit_phrases_units` (`unit_id`),
  CONSTRAINT `dic_unit_phrases_units` FOREIGN KEY (`unit_id`) REFERENCES `units` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=210 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dic_unit_phrases`
--

LOCK TABLES `dic_unit_phrases` WRITE;
/*!40000 ALTER TABLE `dic_unit_phrases` DISABLE KEYS */;
INSERT INTO `dic_unit_phrases` VALUES (1,14,2,'Зато мы самые дешевые!'),(2,14,2,'Зато нас больше'),(3,14,2,'У меня копье не того калибра'),(4,14,2,'Я тоже хотел стать Лордом, пока стрела не попала мне в колено'),(5,14,2,'И почему я завалил сессию в институте...'),(6,14,2,'Я должен быть на 20% круче!'),(7,14,2,'Даже тарану платят больше, чем мне'),(8,14,2,'Хорошо хоть не стройбат'),(9,14,2,'Когда уже можно будет сдаться?'),(10,14,2,'Скоро уже обед?'),(11,14,2,'Пора уже на копье новый прицел поставить'),(12,14,2,'Вернусь с войны - поступлю в консерваторию'),(13,14,2,'Плох тот копейщик, который не мечтает стать драконом!'),(14,14,2,'Плох тот копейщик, который не мечтает стать Лордом'),(15,14,2,'Мне сказали, что если я дойду то того края доски, меня посвятят в рыцари и дадут коня'),(16,14,2,'Мне сказали, что если я дойду то того края доски, меня посвятят в дамки'),(17,14,2,'Примкнуть штыки!'),(18,14,2,'Когда нечего делать, я занимаюсь прыжками с копьем'),(19,14,2,'И когда уже световое копье изобретут?'),(20,14,2,'У меня есть копье.А чего добился ты?'),(21,14,2,'И какого копья я тут делаю?'),(22,14,2,'Ночью я натираю копьё до блеска'),(23,14,2,'Да одно мое копье стоит 10 золотых!'),(24,15,2,'Порыбачить бы в озере'),(25,15,2,'Кажется, где-то тут был трактир'),(26,15,2,'Чем выше в горы, тем толще тролли'),(27,15,2,'Стрела — дура, штык — молодец!'),(28,15,2,'Моя жизнь за Аиур! Простите, вырвалось'),(29,15,2,'Тьфу, опять в драконью лепешку вступил'),(30,15,2,'Смотрите, тут кто-то недоел шашлык'),(31,15,2,'Сдать бы доспех на металлолом, купить дачу да выращивать картошку...'),(32,15,2,'Если бы я был Лордом, я бы построил тут трактир.'),(33,15,2,'Если бы я был Лордом, я бы построил тут баню.'),(34,16,2,'Где мой оруженосец? Я что сам это все таскать должен?'),(35,16,2,'Везет же некоторым!'),(36,16,2,'Убить принцессу, спасти дракона'),(37,16,2,'Коня пропил :('),(38,16,2,'Крест на моей броне - железный!'),(39,16,2,'Убей с трех ударов'),(40,16,2,'Я защитник слабых и обездоленных, карающий меч правосудия, несущий свет и добро в мир...дайте поесть, а?'),(41,16,2,'Маги постоянно говорят о каком-то 42, чтобы это значило?'),(42,16,2,'Мы воюем не за деньги, за идею! за дивный новый мир!'),(43,16,2,'Полцарства за коня!'),(44,16,2,'Плох тот рыцарь, который не мечтает стать конным рыцарем'),(45,17,2,'Слава подковам!'),(46,17,2,'Не смеши мои подковы'),(47,17,2,'Конный рыцарь - он почти как рыцарь. Только с конем'),(48,17,2,'И после смерти мне не обрести покой'),(49,17,2,'Эх, прокачусь!'),(50,17,2,'Когда турнир?'),(51,17,2,'Когда-нибудь я эволюционирую в танк'),(52,17,2,'В прошлой жизни у меня был конь'),(53,17,2,'Вчера затонировал коня и поставил литые копыта'),(54,17,2,'Только мы с конем, по полю идем...'),(55,17,2,'Товарищ инспектор, ну не заметил я светофора, и превысил скорость совсем чуть-чуть'),(56,17,2,'Сдам бока и круп лошади под рекламу'),(57,17,2,'Хочешь, прокачу?'),(58,17,2,'Жизнь - череда смертей и воскрешений'),(59,18,2,'Дзя. Нин Дзя'),(60,18,2,'Видишь ниндзю? и я не вижу, а он есть'),(61,18,2,'Это Я украл твой сладкий рулет'),(62,18,2,'Воруй, убивай'),(63,18,2,'Прихожу в трактир, а он не работает. И так каждый раз!'),(64,18,2,'Они зовут меня \"Борис хрен попадешь\"'),(65,18,2,'Думаешь, мои услуги тебе по-карману?'),(66,18,2,'Ага, так вот где ты хранишь золото...'),(67,18,2,'Кладбища забиты дураками, которые полагаются на доспехи и большие мечи'),(68,18,2,'Я на 20% круче Джеки Чана'),(69,18,2,'Почему всегда, когда я подхожу к трактиру, там закрыто?'),(70,19,2,'Мир, братья!'),(71,19,2,'Хоть голова моя пуста...'),(72,19,2,'Мне приснилось, что я бабочка'),(73,19,2,'Много форм я сменил, пока не обрел свободу'),(74,19,2,'Я был рогами оленя и юго-западным ветром'),(75,19,2,'Стой! Куда идешь?'),(76,19,2,'Я работаю в библиотеке...'),(77,19,2,'Монахи, цемента мне на лечение!'),(78,19,2,'Ненавижу строителей, из моего брата сделали сарай'),(79,19,2,'Иногда так хочется чуда!'),(80,19,2,'Там, где копейщик не пройдет и конный рыцарь не промчится...'),(81,19,2,'Поспешишь - людей насмешишь'),(82,19,2,'Когда-то из меня рос укроп'),(83,19,2,'Люблю смотреть на дождь. Особенно метеоритный'),(84,19,2,'Таран, я - твой отец'),(85,19,2,'Я хочу жить в мире без войн и зла, но кого это интересует'),(86,20,2,'Иду на таран!'),(87,20,2,'Цепляюсь.Дорого'),(88,20,2,'Ты не смотри, что я дубовый...'),(89,20,2,'Учу плавать. Запись возле озера'),(90,20,2,'Нужно бооольше древесины'),(91,20,2,'Я тоже хотел бы стать искателем приключений, если бы у меня были колени'),(92,20,2,'Буратино вырос, буратино возмужал'),(93,20,2,'Я хочу быть настоящим мальчиком'),(94,20,2,'Скрип-скрип'),(95,21,2,'Дружба - это магия'),(96,21,2,'Эх, щас колдону!'),(97,21,2,'Я всегда ношу с собой револьвер. На всякий случай'),(98,21,2,'Думаешь, ты умнее меня?'),(99,21,2,'Еще полгода, и я буду командовать тобой'),(100,21,2,'Еще несколько повышений, и я буду командовать тобой'),(101,21,2,'Я из древнего и уважаемого рода, а ты еще кто такой?'),(102,21,2,'Ай, опять руку об фаербол обжег'),(103,21,2,'Кастую C2H5OH на всех'),(104,21,2,'Это заклинание запатентовано'),(105,21,2,'Все надоело, хочу в отпуск'),(106,21,2,'Оставьте свою Аваду-Кедавру при себе!'),(107,22,2,'Я не гот!'),(108,22,2,'Я не гот, просто не выспался!'),(109,22,2,'Ты говоришь я Демон? Так и есть'),(110,22,2,'Я требую сатанинские похороны!'),(111,22,2,'Воскрешу таран и завоюю мир'),(112,22,2,'Воскрешал таран - все руки в мозолях'),(113,22,2,'Отвороты, порчи, проклятия недорого'),(114,22,2,'Зомби совсем уже обнаглели, организовали свой профсоюз'),(115,22,2,'Просто у меня было тяжелое детство'),(116,22,2,'Кто хочет печенек?'),(117,22,2,'Вообще-то я пишу стихи, но кого это интересует..'),(118,22,2,'Кого бы воскресить?'),(119,22,2,'Не кочегары мы, не плотники... Мы воскрешаем каждый день! А мы могильников работники! Да воцариться тьма везде!!!'),(120,23,2,'Кто просил шашлычок?'),(121,23,2,'Вы меня полюбите!'),(122,23,2,'Дяденьки, не бейте!'),(123,23,2,'Что-то горит?'),(124,23,2,'Прикурить не найдется?'),(125,23,2,'Есть че?'),(126,23,2,'Я тучка-тучка-тучка, а вовсе не Дракон'),(127,23,2,'Есть что-нибудь от изжоги?'),(128,23,2,'Дракон с хвостом похож на дракона без хвоста, но с хвостом'),(129,23,2,'О! а вот и завтрак'),(130,23,2,'Кажется, у меня опять температура'),(131,23,2,'С тобой все в порядке, сахарок?'),(132,23,2,'Давайте играть в квача'),(133,23,2,'Не люблю овсяную кашу и рыцарей'),(134,23,2,'Хорошо, что пулеметов еще не изобрели'),(135,23,2,'Магнитные бури на солнце. Слыхали?'),(136,24,2,'Вы у меня ещё поквакаете!'),(137,24,2,'Поцелуй меня, и я превращусь в рыцаря'),(138,24,2,'Да-да, говорящая жаба'),(139,24,2,'Ква!'),(140,24,2,'Убить дракона? вы серьезно?'),(141,24,2,'Жизнь - жестокая вещь'),(142,24,2,'И почему я не дракон?'),(143,24,2,'Почему меня никто не любит?'),(144,24,2,'Кабы я была драконом...'),(145,24,2,'Попробуй поймай!'),(146,25,2,'Лучше гор могут быть только горы'),(147,25,2,'Не кормите тролля'),(148,25,2,'Покормите тролля'),(149,25,2,'Где тут у вас мост?'),(150,25,2,'Я только посмотреть, пропустите, пожалуйста'),(151,25,2,'Моя голова большой и умный, а еще я туда ем'),(152,25,2,'Ну ладно, здания сами себя не развалят'),(153,25,2,'Люблю архитектуру'),(154,26,2,'Хватит уже пить вино'),(155,26,2,'Мммм... человечинка в собственной крови! А что? Вкуснецки!'),(156,26,2,'Мечтаю побриться'),(157,26,2,'Пункт приема донорской крови'),(158,26,2,'Осторожно, я кусаюсь'),(159,26,2,'Я тоже в вампиров раньше не верил...'),(160,26,2,'Ненавижу комаров'),(161,26,2,'От вида крови падаю в обморок'),(162,26,2,'Ай, порезался!!'),(163,26,2,'Вы думаете, это земляничный сок?'),(164,26,2,'Не бойся, как комарик укусит, и все'),(165,14,1,'Is there an afterlife?'),(166,14,1,'I also wanted to become a lord, but then I took an arrow in the knee'),(167,14,1,'Is it lunchtime yet?'),(168,14,1,'I\'ve been told I can become a dragon if I reach the othes side of the board'),(169,15,1,'Wasn\'t there a tavern somewhere around here?'),(170,15,1,'My life for Aiur! Sorry, slip of the tongue'),(171,16,1,'I am saving for a horse'),(172,16,1,'Kill a dragon? Seriously?'),(173,17,1,'Life is a circle of deaths and resurrections'),(174,17,1,'Delivery service'),(175,18,1,'Every time I come to a tavern it is closed!'),(176,19,1,'One step at a time'),(177,19,1,'No need to hurry'),(178,19,1,'I like watching rain. Expecially meteor rain'),(179,20,1,'Swimming lessons. Enquire by the lake'),(180,21,1,'Ouch, I burnt my hand'),(181,21,1,'You think you are safe over there?'),(182,21,1,'Look, I found a four-leaf clover!'),(183,22,1,'Anybody wants cookies?'),(184,23,1,'I think I have fever'),(185,23,1,'I love crunchy knight flakes'),(186,23,1,'Anyone up for a barbecue?'),(187,24,1,'Yes, a talking frog'),(188,24,1,'Life is so cruel'),(189,25,1,'I love architecture!'),(190,25,1,'I just want to have a look'),(191,26,1,'I hate mosquitoes'),(192,26,1,'I will build an empire, yes, a vampire empire'),(193,26,1,'I will become the first Vemperor of this land'),(194,26,1,'I am thirsty'),(195,27,1,'Will you stand still, I am trying to aim!'),(196,27,1,'I think I lost an arrow'),(197,28,1,'Could you please come a bit closer?'),(198,16,1,'I left my horse at home'),(199,22,1,'Don\'t worry, this knife is just for making salads'),(200,29,1,'Drive me closer, I want to hit them with my sword'),(201,29,1,'Do you want a quick journey?'),(202,24,1,'Croak Croak. What else did you expect?'),(203,14,1,'I have a bad feeling about this'),(204,21,1,'Do you want to see some street magic?'),(205,23,1,'Do you really think you can buy me?'),(206,23,1,'Dragon is here. Just type \"gg\" and surrender'),(207,18,1,'Do you know why a knight doesn\'t have a horse? I stole it'),(208,25,1,'Trolling time!'),(209,19,1,'Me smash');
/*!40000 ALTER TABLE `dic_unit_phrases` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `error_dictionary`
--

DROP TABLE IF EXISTS `error_dictionary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `error_dictionary` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `error_dictionary`
--

LOCK TABLES `error_dictionary` WRITE;
/*!40000 ALTER TABLE `error_dictionary` DISABLE KEYS */;
INSERT INTO `error_dictionary` VALUES (1,'not_your_turn'),(2,'not_enough_gold'),(3,'no_more_cards'),(4,'incorrect_sum'),(5,'subsidy_already_taken'),(6,'not_enough_castle_hp'),(7,'already_started_moving_units'),(8,'no_such_dead_unit'),(9,'spawn_point_occupued'),(10,'you_dont_have_this_card'),(11,'building_outside_zone'),(12,'place_occupied'),(13,'invalid_player'),(14,'unit_not_selected'),(15,'invalid_card_action'),(16,'not_own_unit_selected'),(17,'unit_has_no_more_moves'),(18,'unit_is_paralyzed'),(19,'cant_step_on_cell'),(20,'cant_attack_cell'),(21,'no_valid_target'),(22,'player_doesnt_have_cards'),(23,'target_should_be_inside_board'),(24,'cant_finish_card_action'),(25,'invalid_zone'),(26,'building_not_selected'),(27,'you_should_select_other_players_building'),(28,'need_to_finish_card_action'),(29,'target_out_of_reach'),(30,'unit_doesnt_have_this_ability'),(31,'ram_can_be_attached_only_to_another_unit'),(32,'can_heal_only_other_unit'),(33,'can_cast_fireball_only_into_other_unit'),(34,'grave_out_of_reach'),(35,'vampire_not_in_own_zone'),(36,'cant_send_money_to_self'),(37,'sacrifice_not_chosen'),(38,'can_sacrifice_only_own_unit'),(39,'sacrifice_target_not_set'),(40,'sacrifice_target_is_not_unit'),(41,'unit_cannot_levelup'),(42,'can_play_card_or_resurrect_only_once_per_turn'),(43,'moving_this_building_disallowed'),(44,'not_own_building'),(45,'building_blocked'),(46,'building_doesnt_have_this_ability'),(47,'building_already_moved_this_turn'),(48,'send_money_invalid_player'),(49,'invalid_target_for_this_unit'),(50,'target_too_close'),(51,'target_too_far'),(52,'cant_resurrect_same_turn');
/*!40000 ALTER TABLE `error_dictionary` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `error_dictionary_i18n`
--

DROP TABLE IF EXISTS `error_dictionary_i18n`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `error_dictionary_i18n` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `error_id` int(10) unsigned NOT NULL,
  `language_id` int(10) unsigned NOT NULL,
  `description` varchar(200) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `error_id` (`error_id`),
  CONSTRAINT `error_dictionary_i18n_ibfk_1` FOREIGN KEY (`error_id`) REFERENCES `error_dictionary` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=105 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `error_dictionary_i18n`
--

LOCK TABLES `error_dictionary_i18n` WRITE;
/*!40000 ALTER TABLE `error_dictionary_i18n` DISABLE KEYS */;
INSERT INTO `error_dictionary_i18n` VALUES (1,1,2,'Не ваш ход'),(2,2,2,'Недостаточно золота'),(3,3,2,'Карт больше нет'),(4,4,2,'Неправильная сумма'),(5,5,2,'Вы уже взяли субсидию в этом ходу'),(6,6,2,'Недостаточно хитов замка'),(7,7,2,'Вы уже начали ходить юнитами'),(8,8,2,'Нет такого мертвого юнита'),(9,9,2,'Место появления занято'),(10,10,2,'У вас нет такой карты'),(11,11,2,'Здание выходит за рамки вашей зоны'),(12,12,2,'Место занято'),(13,13,2,'Нет такого игрока'),(14,14,2,'Юнит не выбран'),(15,15,2,'Этой картой нельзя этого сделать :-P'),(16,16,2,'Выбран чужой юнит'),(17,17,2,'У юнита не осталось ходов'),(18,18,2,'Юнит парализован'),(19,19,2,'На эту клетку нельзя походить'),(20,20,2,'Эту клетку нельзя атаковать'),(21,21,2,'Здесь нечего атаковать'),(22,22,2,'У этого игрока нет карт'),(23,23,2,'Цель не может выходить за карту'),(24,24,2,'Нельзя доиграть пользу/вред'),(25,25,2,'Неправильная зона'),(26,26,2,'Здание не выбрано'),(27,27,2,'Нужно выбрать чужое здание'),(28,28,2,'Нужно доиграть пользу/вред'),(29,29,2,'Цель вне досягаемости'),(30,30,2,'Юнит это не умеет :-P'),(31,31,2,'Можно прицепить таран только к другому юниту'),(32,32,2,'Можно лечить только другого юнита'),(33,33,2,'Можно пустить огненный шар только в другого юнита'),(34,34,2,'Могила вне досягаемости'),(35,35,2,'Можно призвать вампира только в своей зоне'),(36,36,2,'Вы хотите отправить деньги себе. Они уже тут'),(37,37,2,'Жертва не выбрана'),(38,38,2,'Можно принести в жертву только своего юнита'),(39,39,2,'Цель для жертвоприношения не выбрана'),(40,40,2,'Нужно выбрать юнита в качестве цели'),(41,41,2,'Юнит не может перейти на следующий уровень'),(42,42,2,'Сыграть карту либо воскресить юнита можно только один раз за ход'),(43,43,2,'Извините, создатель мода не хотел, чтобы вы перемещали это здание'),(44,44,2,'Это не ваше здание'),(45,45,2,'Здание заблокировано'),(46,46,2,'Здание это не умеет :-P'),(47,47,2,'Здание уже действовало в этот ход'),(48,1,1,'Not your turn'),(49,2,1,'Not enough gold'),(50,3,1,'No more cards'),(51,4,1,'Invalid sum'),(52,5,1,'You can sell rocks only once per turn'),(53,6,1,'Not enough castle health points'),(54,7,1,'You already started moving units'),(55,8,1,'No such dead unit'),(56,9,1,'Spawn point occupied'),(57,10,1,'You don\'t have this card'),(58,11,1,'Building should be completely in your zone'),(59,12,1,'Place is occupied'),(60,13,1,'Invalid player'),(61,14,1,'Unit is not selected'),(62,15,1,'This card cannot do this :-P'),(63,16,1,'You need to select your own unit'),(64,17,1,'Unit has no more moves'),(65,18,1,'Unit is paralyzed'),(66,19,1,'Destination out of reach'),(67,20,1,'Attack destination out of reach'),(68,21,1,'Nothing to attack here'),(69,22,1,'This player has no cards'),(70,23,1,'Target should be on the board completely'),(71,24,1,'Invalid card action'),(72,25,1,'Invalid zone'),(73,26,1,'Building is not chosen'),(74,27,1,'You need to choose someone else\'s building'),(75,28,1,'You need to finish card action'),(76,29,1,'Target out of reach'),(77,30,1,'This unit cannot do this :-P'),(78,31,1,'You can only attach ram to another unit'),(79,32,1,'You can only heal another unit'),(80,33,1,'You can only cast fireball into another unit'),(81,34,1,'Grave out of reach'),(82,35,1,'You can only summon a vampire in your own zone'),(83,36,1,'You want to send money to yourself. It is already here'),(84,37,1,'Please choose someone to sacrifice'),(85,38,1,'You can sacrifice only your own unit'),(86,39,1,'Sacrifice target not chosen'),(87,40,1,'Sacrifice target should be another unit'),(88,41,1,'Unit cannot levelup'),(89,42,1,'You can play a card or resurrect only once per turn'),(90,43,1,'Sorry, the author of the mode didn\'t want you to move this'),(91,44,1,'This is not your building'),(92,45,1,'Building is blocked'),(93,46,1,'This building cannot do it :-P'),(94,47,1,'A building can act only once per turn'),(95,48,1,'Transaction cancelled, the recipient could not sign'),(96,48,2,'Перевод отменен, адресат не смог расписаться о получении'),(97,49,1,'Invalid target for this unit'),(98,49,2,'Юнит не может в это стрелять'),(99,50,1,'Target is too close'),(100,50,2,'Цель слишком близко'),(101,51,1,'Target is too far'),(102,51,2,'Цель слишком далеко'),(103,52,1,'Unit cannot be killed and resurrected within the same player\'s turn'),(104,52,2,'Юнит не может быть воскрешен в том же ходу, когда был убит');
/*!40000 ALTER TABLE `error_dictionary_i18n` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `games`
--

DROP TABLE IF EXISTS `games`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `games` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(45) NOT NULL,
  `owner_id` int(10) unsigned NOT NULL,
  `time_restriction` int(10) unsigned NOT NULL DEFAULT '0',
  `status_id` int(10) unsigned NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `mode_id` int(10) unsigned NOT NULL,
  `type_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `games`
--

LOCK TABLES `games` WRITE;
/*!40000 ALTER TABLE `games` DISABLE KEYS */;
/*!40000 ALTER TABLE `games` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `games_features`
--

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

--
-- Dumping data for table `games_features`
--

LOCK TABLES `games_features` WRITE;
/*!40000 ALTER TABLE `games_features` DISABLE KEYS */;
INSERT INTO `games_features` VALUES (1,'random_teams',0,'bool'),(2,'all_versus_all',0,'bool'),(3,'number_of_teams',2,'int'),(4,'teammates_in_random_castles',0,'bool');
/*!40000 ALTER TABLE `games_features` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `games_features_i18n`
--

DROP TABLE IF EXISTS `games_features_i18n`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `games_features_i18n` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `feature_id` int(10) unsigned NOT NULL,
  `language_id` int(10) unsigned NOT NULL,
  `description` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `feature_id` (`feature_id`),
  CONSTRAINT `games_features_i18n_ibfk_1` FOREIGN KEY (`feature_id`) REFERENCES `games_features` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `games_features_i18n`
--

LOCK TABLES `games_features_i18n` WRITE;
/*!40000 ALTER TABLE `games_features_i18n` DISABLE KEYS */;
INSERT INTO `games_features_i18n` VALUES (1,1,2,'Случайные союзы'),(2,2,2,'Каждый сам за себя'),(3,3,2,'Количество команд'),(4,4,2,'Союзники не напротив, а случайным образом'),(5,1,1,'Random teams'),(6,2,1,'No teams (free-for-all)'),(7,3,1,'Number of teams'),(8,4,1,'Allies are placed randomly instead of opposite');
/*!40000 ALTER TABLE `games_features_i18n` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `games_features_usage`
--

DROP TABLE IF EXISTS `games_features_usage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `games_features_usage` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `game_id` int(10) unsigned NOT NULL,
  `feature_id` int(10) unsigned NOT NULL,
  `param` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `games_features_usage`
--

LOCK TABLES `games_features_usage` WRITE;
/*!40000 ALTER TABLE `games_features_usage` DISABLE KEYS */;
/*!40000 ALTER TABLE `games_features_usage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `grave_cells`
--

DROP TABLE IF EXISTS `grave_cells`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `grave_cells` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `grave_id` int(10) unsigned NOT NULL,
  `x` int(11) NOT NULL,
  `y` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `grave_cells_graves` (`grave_id`),
  CONSTRAINT `grave_cells_graves` FOREIGN KEY (`grave_id`) REFERENCES `graves` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `grave_cells`
--

LOCK TABLES `grave_cells` WRITE;
/*!40000 ALTER TABLE `grave_cells` DISABLE KEYS */;
/*!40000 ALTER TABLE `grave_cells` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `graves`
--

DROP TABLE IF EXISTS `graves`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `graves` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `game_id` int(10) unsigned NOT NULL,
  `card_id` int(10) unsigned NOT NULL,
  `player_num_when_killed` int(11) NOT NULL,
  `turn_when_killed` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `graves_games` (`game_id`),
  KEY `graves_cards` (`card_id`),
  CONSTRAINT `graves_cards` FOREIGN KEY (`card_id`) REFERENCES `cards` (`id`) ON DELETE CASCADE,
  CONSTRAINT `graves_games` FOREIGN KEY (`game_id`) REFERENCES `games` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `graves`
--

LOCK TABLES `graves` WRITE;
/*!40000 ALTER TABLE `graves` DISABLE KEYS */;
/*!40000 ALTER TABLE `graves` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_commands`
--

DROP TABLE IF EXISTS `log_commands`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log_commands` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `game_id` int(10) unsigned NOT NULL,
  `player_num` int(10) unsigned NOT NULL DEFAULT '0',
  `command` varchar(1000) NOT NULL,
  `hidden_flag` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_commands`
--

LOCK TABLES `log_commands` WRITE;
/*!40000 ALTER TABLE `log_commands` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_commands` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_message_text_i18n`
--

DROP TABLE IF EXISTS `log_message_text_i18n`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log_message_text_i18n` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL,
  `language_id` int(10) unsigned NOT NULL,
  `message` varchar(500) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=165 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_message_text_i18n`
--

LOCK TABLES `log_message_text_i18n` WRITE;
/*!40000 ALTER TABLE `log_message_text_i18n` DISABLE KEYS */;
INSERT INTO `log_message_text_i18n` VALUES (1,'agrees_to_draw',2,'Согласен на ничью'),(2,'agrees_to_draw',1,'Agrees to draw'),(3,'disagrees_to_draw',2,'Не согласен на ничью'),(4,'disagrees_to_draw',1,'Disagrees to draw'),(5,'unit_shoots_unit',2,'{unit0} стреляет в {unitakk1} {damage2}'),(6,'unit_shoots_unit',1,'{unit0} shoots at {unit1} {damage2}'),(7,'unit_shoots_unit_miss',2,'{unit0} стреляет в {unitakk1} (Промах)'),(8,'unit_shoots_unit_miss',1,'{unit0} shoots at {unit1} (Miss)'),(9,'buys_card',2,'Купил карту'),(10,'buys_card',1,'Buys a card'),(11,'building_repair',2,'{building0} восстанавливает {health1}'),(12,'building_repair',1,'{building0} is repaired {health1}'),(13,'mind_control',2,'{unit0} начинает подчиняться игроку {player1}'),(14,'mind_control',1,'{player1} now controls {unit0}'),(15,'mind_control_own_unit',2,'{unit0} продолжает подчиняться игроку {player1}'),(16,'mind_control_own_unit',1,'{player1} continues to controls {unit0}'),(17,'polza_repair_and_heal',2,'Польза: Починить все здания и исцелить юнитов'),(18,'polza_repair_and_heal',1,'White dice: Repair all buildings and heal units'),(19,'polza_gold',2,'Польза: +60 золота'),(20,'polza_gold',1,'White dice: +60 gold'),(21,'polza_cards',2,'Польза: Взять 2 карты'),(22,'polza_cards',1,'White dice: take 2 cards'),(23,'polza_resurrect',2,'Польза: Воскресить любого юнита'),(24,'polza_resurrect',1,'White dice: Resurrect any unit'),(25,'polza_move_from_zone',2,'Польза: Переместить всех юнитов из выбранной зоны'),(26,'polza_move_from_zone',1,'White dice: Move all units out of a chosen zone'),(27,'polza_steal_move_building',2,'Польза: Переместить и присвоить чужое здание'),(28,'polza_steal_move_building',1,'White dice: Steal and move someone else\'s building'),(29,'new_card',2,'Новая карта {card0}'),(30,'new_card',1,'New card {card0}'),(31,'no_more_cards',2,'Карт больше нет'),(32,'no_more_cards',1,'No more cards in the deck'),(33,'player_loses_gold',2,'{player0} теряет {gold1}'),(34,'player_loses_gold',1,'{player0} loses {gold1}'),(35,'players_cards',2,'Карты игрока {player0}:'),(36,'players_cards',1,'{player0}\'s cards:'),(37,'card_name',2,'{card0}'),(38,'card_name',1,'{card0}'),(39,'card_stolen',2,'Похищена карта {card0}'),(40,'card_stolen',1,'{card0} is stolen'),(41,'unit_appears_in_cell',2,'В клетке {cell1} появляется {unit0}'),(42,'unit_appears_in_cell',1,'{unit0} appears in {cell1}'),(43,'vred_gold',2,'Вред: -60 золота выбранному игроку'),(44,'vred_gold',1,'Black dice: Chosen player loses 60 gold'),(45,'vred_kill',2,'Вред: Убить любого юнита'),(46,'vred_kill',1,'Black dice: Kill any unit'),(47,'vred_destroy_building',2,'Вред: Разрушить любое здание'),(48,'vred_destroy_building',1,'Black dice: Destroy any building (except castles)'),(49,'vred_move_units_to_random_zone',2,'Вред: Переместить всех юнитов в случайную зону'),(50,'vred_move_units_to_random_zone',1,'Black dice: Move all units to a random zone'),(51,'vred_player_takes_card_from_everyone',2,'Вред: Вытянуть у всех по карте'),(52,'vred_player_takes_card_from_everyone',1,'Black dice: Steal a card from each other player'),(53,'vred_move_building',2,'Вред: Переместить чужое здание'),(54,'vred_move_building',1,'Black dice: Move someone else\'s building'),(55,'unit_shoots_building',2,'{unit0} стреляет в {building1} {damage2}'),(56,'unit_shoots_building',1,'{unit0} shoots at {building1} {damage2}'),(57,'unit_shoots_building_miss',2,'{unit0} стреляет в {building1} (Промах)'),(58,'unit_shoots_building_miss',1,'{unit0} shoots at {building1} (Miss)'),(59,'unit_magic_resistance',2,'На {unitakk0} не действует магия'),(60,'unit_magic_resistance',1,'{unit0} resists magic'),(61,'unit_mechanical',2,'Механический {unit0} ничего не почувствовал'),(62,'unit_mechanical',1,'Mechanical {unit0} does not feel anything'),(63,'miss_unit',2,'Промах: {unit0}'),(64,'miss_unit',1,'Miss: {unit0}'),(65,'miss_building',2,'Промах: {building0}'),(66,'miss_building',1,'Miss: {building0}'),(67,'miss_rus_rul',2,'{unit0} отделался легким испугом'),(68,'miss_rus_rul',1,'{unit0} has a narrow escape'),(69,'end_turn',2,'{player0} завершил ход'),(70,'end_turn',1,'{player0} ends turn'),(71,'end_turn_timeout',2,'У игрока {player0} закончилось время хода'),(72,'end_turn_timeout',1,'{player0} has run out of time'),(73,'resurrect',2,'{player0} воскресил {unitakk1}'),(74,'resurrect',1,'{player0} resurrects {unit1}'),(75,'unit_goes_mad',2,'{unit0} сошел с ума'),(76,'unit_goes_mad',1,'{unit0} goes mad'),(77,'unit_becomes_not_mad',2,'{unit0} больше не сошел с ума'),(78,'unit_becomes_not_mad',1,'{unit0} restores sanity'),(79,'unit_chess_knight',2,'{unit0} начинает ходить шахматным конем'),(80,'unit_chess_knight',1,'{unit0} now moves as a chess knight'),(81,'unit_paralyzed',2,'{unit0} парализован'),(82,'unit_paralyzed',1,'{unit0} is paralyzed'),(83,'unit_unparalyzed',2,'{unit0} больше не парализован'),(84,'unit_unparalyzed',1,'{unit0} is not paralyzed anymore'),(85,'building_destroyed',2,'Здание {building0} разрушено'),(86,'building_destroyed',1,'{building0} is destroyed'),(87,'castle_destroyed',2,'{building0} разрушен'),(88,'castle_destroyed',1,'{building0} is destroyed'),(89,'unit_drinks_health',2,'{unit0} выпивает {health1}'),(90,'unit_drinks_health',1,'{unit0} drinks {health1}'),(91,'npc_turn',2,'Ход NPC'),(92,'npc_turn',1,'NPC turn'),(93,'unit_restores_health',2,'{unit0} восстанавливает {health1}'),(94,'unit_restores_health',1,'{unit0} restores {health1}'),(95,'unit_killed',2,'{unit0} убит'),(96,'unit_killed',1,'{unit0} is dead'),(97,'unit_damage',2,'{unit0} {damage1}'),(98,'unit_damage',1,'{unit0} {damage1}'),(99,'building_damage',2,'{building0} {damage1}'),(100,'building_damage',1,'{building0} {damage1}'),(101,'unit_already_mad',2,'{unit0} уже сошел с ума'),(102,'unit_already_mad',1,'{unit0} is already pretty mad'),(103,'unit_resurrects',2,'{unit0} воскрешает {unitakk1}'),(104,'unit_resurrects',1,'{unit0} resurrects {unit1}'),(105,'sacrifice',2,'{unit0} жертвует {unitakk1} за {unitakk2}'),(106,'sacrifice',1,'{unit0} sacrifices {unit1} for {unit2}'),(107,'unit_is_such_a_unit',2,'{unit0} такой {unit0}'),(108,'unit_is_such_a_unit',1,'{unit0} is such a {unit0}'),(109,'player_exit',2,'{player0} вышел из игры'),(110,'player_exit',1,'{player0} left the game'),(111,'plays_card',2,'Сыграл карту {card0}'),(112,'plays_card',1,'Plays {card0}'),(113,'building_completely_repaired',2,'Здание {building0} починено'),(114,'building_completely_repaired',1,'{building0} is repaired'),(115,'send_money',2,'Отправил игроку {player0} {gold1}'),(116,'send_money',1,'Sends {player0} {gold1}'),(117,'restore_magic_shield',2,'{unit0} восстанавливает магический щит'),(118,'restore_magic_shield',1,'{unit0} restores magical shield'),(119,'loses_magic_shield',2,'{unit0} теряет магический щит'),(120,'loses_magic_shield',1,'{unit0} loses magical shield'),(121,'gets_magic_shield',2,'{unit0} получает магический щит'),(122,'gets_magic_shield',1,'{unit0} gets magical shield'),(123,'building_sinks',2,'{building0} тонет в воде'),(124,'building_sinks',1,'{building0} sinks'),(125,'unit_drowns',2,'{unit0} тонет в воде'),(126,'unit_drowns',1,'{unit0} drowns'),(127,'moves_units',2,'Походил юнитами'),(128,'moves_units',1,'Moves units'),(129,'take_subsidy',2,'Взял субсидию: {building0} {health1}'),(130,'take_subsidy',1,'Sells stones: {building0} {health1}'),(131,'unit_attaches',2,'{unit0} цепляется к юниту {unit1}'),(132,'unit_attaches',1,'{unit0} is attached to {unit1}'),(133,'unit_healed',2,'{unit0} исцелен'),(134,'unit_healed',1,'{unit0} is healed'),(135,'unit_gets_attack',2,'{unit0} получает {attack1}'),(136,'unit_gets_attack',1,'{unit0} gets {attack1}'),(137,'unit_gets_moves',2,'{unit0} получает {moves1}'),(138,'unit_gets_moves',1,'{unit0} gets {moves1}'),(139,'unit_gets_health',2,'{unit0} получает {health1}'),(140,'unit_gets_health',1,'{unit0} gets {health1}'),(141,'unit_levelup_health',2,'{unit0} получает уровень и {health1}'),(142,'unit_levelup_health',1,'{unit0} achieves next level and gets {health1}'),(143,'unit_levelup_attack',2,'{unit0} получает уровень и {attack1}'),(144,'unit_levelup_attack',1,'{unit0} achieves next level and gets {attack1}'),(145,'unit_levelup_moves',2,'{unit0} получает уровень и {moves1}'),(146,'unit_levelup_moves',1,'{unit0} achieves next level and gets {moves1}'),(147,'unit_pushes',2,'{unit0} пихает {unitakk1}'),(148,'unit_pushes',1,'{unit0} pushes {unit1}'),(149,'unit_becomes_vampire',2,'{unitname0} становится вампиром'),(150,'unit_becomes_vampire',1,'{unitname0} turns into a vampire'),(151,'vred_got_card_from',2,'Новая карта {card1} от игрока {player0}'),(152,'vred_got_card_from',1,'Got {card1} from {player0}'),(153,'vred_gave_card_to',2,'{player0} вытянул карту {card1}'),(154,'vred_gave_card_to',1,'{player0} takes card {card1}'),(155,'building_opens',2,'{building0} открывается'),(156,'building_opens',1,'{building0} opens'),(157,'building_closes',2,'{building0} закрывается'),(158,'building_closes',1,'{building0} closes'),(159,'unit_casts_fb',2,'{unit0} колдует огненный шар на {unitakk1}'),(160,'unit_casts_fb',1,'{unit0} casts Fireball on {unit1}'),(161,'cast_unsuccessful',2,'Колдовство не удалось'),(162,'cast_unsuccessful',1,'Cast failed'),(163,'unit_heals',2,'{unit0} лечит {unitakk1}'),(164,'unit_heals',1,'{unit0} heals {unit1}');
/*!40000 ALTER TABLE `log_message_text_i18n` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mode_config`
--

DROP TABLE IF EXISTS `mode_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mode_config` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `param` varchar(45) NOT NULL,
  `value` varchar(45) NOT NULL,
  `mode_id` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `mode_config_modes` (`mode_id`),
  CONSTRAINT `mode_config_modes` FOREIGN KEY (`mode_id`) REFERENCES `modes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=133 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mode_config`
--

LOCK TABLES `mode_config` WRITE;
/*!40000 ALTER TABLE `mode_config` DISABLE KEYS */;
INSERT INTO `mode_config` VALUES (117,'unit income','2',9),(118,'building income','1',9),(119,'card cost','10',9),(120,'subsidy amount','15',9),(121,'subsidy castle damage','1',9),(122,'resurrection cost coefficient','2',9),(123,'frog count','3',9),(124,'troll count','1',9),(125,'castle hit reward','10',9),(126,'max_unit_level','3',9),(132,'two_phase_turn','1',9);
/*!40000 ALTER TABLE `mode_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `modes`
--

DROP TABLE IF EXISTS `modes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `modes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `min_players` int(10) unsigned NOT NULL,
  `max_players` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `modes`
--

LOCK TABLES `modes` WRITE;
/*!40000 ALTER TABLE `modes` DISABLE KEYS */;
INSERT INTO `modes` VALUES (9,'Double Turns',2,4);
/*!40000 ALTER TABLE `modes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `modes_cardless_buildings`
--

DROP TABLE IF EXISTS `modes_cardless_buildings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `modes_cardless_buildings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `mode_id` int(10) unsigned NOT NULL,
  `building_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `modes_cardless_buildings_modes` (`mode_id`),
  KEY `modes_cardless_buildings_buildings` (`building_id`),
  CONSTRAINT `modes_cardless_buildings_buildings` FOREIGN KEY (`building_id`) REFERENCES `buildings` (`id`) ON DELETE CASCADE,
  CONSTRAINT `modes_cardless_buildings_modes` FOREIGN KEY (`mode_id`) REFERENCES `modes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `modes_cardless_buildings`
--

LOCK TABLES `modes_cardless_buildings` WRITE;
/*!40000 ALTER TABLE `modes_cardless_buildings` DISABLE KEYS */;
INSERT INTO `modes_cardless_buildings` VALUES (17,9,15),(18,9,16),(19,9,18),(20,9,20),(24,9,21),(25,9,22),(26,9,23);
/*!40000 ALTER TABLE `modes_cardless_buildings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `modes_cardless_units`
--

DROP TABLE IF EXISTS `modes_cardless_units`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `modes_cardless_units` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `mode_id` int(10) unsigned NOT NULL,
  `unit_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `modes_cardless_units_modes` (`mode_id`),
  KEY `modes_cardless_units_units` (`unit_id`),
  CONSTRAINT `modes_cardless_units_modes` FOREIGN KEY (`mode_id`) REFERENCES `modes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `modes_cardless_units_units` FOREIGN KEY (`unit_id`) REFERENCES `units` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `modes_cardless_units`
--

LOCK TABLES `modes_cardless_units` WRITE;
/*!40000 ALTER TABLE `modes_cardless_units` DISABLE KEYS */;
INSERT INTO `modes_cardless_units` VALUES (19,9,24),(20,9,25),(21,9,26);
/*!40000 ALTER TABLE `modes_cardless_units` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `modes_cards`
--

DROP TABLE IF EXISTS `modes_cards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `modes_cards` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `mode_id` int(10) unsigned NOT NULL,
  `card_id` int(10) unsigned NOT NULL,
  `quantity` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `modes_cards_modes` (`mode_id`),
  KEY `modes_cards_cards` (`card_id`),
  CONSTRAINT `modes_cards_cards` FOREIGN KEY (`card_id`) REFERENCES `cards` (`id`) ON DELETE CASCADE,
  CONSTRAINT `modes_cards_modes` FOREIGN KEY (`mode_id`) REFERENCES `modes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=639 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `modes_cards`
--

LOCK TABLES `modes_cards` WRITE;
/*!40000 ALTER TABLE `modes_cards` DISABLE KEYS */;
INSERT INTO `modes_cards` VALUES (573,9,61,3),(574,9,62,3),(575,9,63,3),(576,9,64,3),(577,9,65,3),(578,9,66,3),(579,9,67,5),(580,9,68,4),(581,9,69,3),(582,9,70,2),(583,9,71,1),(584,9,72,1),(585,9,73,1),(586,9,74,1),(587,9,75,1),(588,9,76,1),(589,9,77,5),(590,9,78,4),(591,9,79,3),(592,9,80,2),(593,9,81,1),(594,9,82,1),(595,9,83,1),(596,9,84,1),(597,9,85,1),(598,9,86,1),(599,9,87,1),(601,9,89,1),(602,9,90,1),(603,9,91,1),(604,9,92,1),(605,9,93,1),(606,9,94,1),(607,9,95,1),(608,9,96,1),(610,9,98,1),(611,9,99,1),(612,9,100,1),(613,9,101,3),(614,9,102,2),(615,9,103,1),(616,9,104,3),(617,9,105,3),(636,9,106,1),(637,9,107,1),(638,9,108,1);
/*!40000 ALTER TABLE `modes_cards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `modes_other_procedures`
--

DROP TABLE IF EXISTS `modes_other_procedures`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `modes_other_procedures` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `mode_id` int(10) unsigned NOT NULL,
  `procedure_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `modes_other_procedures_modes` (`mode_id`),
  KEY `modes_other_procedures_procedures` (`procedure_id`),
  CONSTRAINT `modes_other_procedures_modes` FOREIGN KEY (`mode_id`) REFERENCES `modes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `modes_other_procedures_procedures` FOREIGN KEY (`procedure_id`) REFERENCES `procedures` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=309 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `modes_other_procedures`
--

LOCK TABLES `modes_other_procedures` WRITE;
/*!40000 ALTER TABLE `modes_other_procedures` DISABLE KEYS */;
INSERT INTO `modes_other_procedures` VALUES (278,9,1),(279,9,2),(280,9,3),(281,9,4),(282,9,5),(283,9,16),(284,9,17),(285,9,18),(286,9,39),(287,9,40),(288,9,41),(289,9,43),(290,9,44),(291,9,45),(292,9,46),(293,9,56),(294,9,57),(295,9,58);
/*!40000 ALTER TABLE `modes_other_procedures` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nonfinished_actions_dictionary`
--

DROP TABLE IF EXISTS `nonfinished_actions_dictionary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nonfinished_actions_dictionary` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(200) NOT NULL,
  `command_procedure` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nonfinished_actions_dictionary`
--

LOCK TABLES `nonfinished_actions_dictionary` WRITE;
/*!40000 ALTER TABLE `nonfinished_actions_dictionary` DISABLE KEYS */;
INSERT INTO `nonfinished_actions_dictionary` VALUES (1,'Польза - воскресить юнита','cast_polza_resurrect'),(2,'Польза - юнитов из любой зоны','cast_polza_units_from_zone'),(3,'Польза - переместить и присвоить здание','cast_polza_move_building'),(4,'Вред - -60 любому игроку','cast_vred_pooring'),(5,'Вред - убить любого юнита','cast_vred_kill_unit'),(6,'Вред - разрушить любое здание','cast_vred_destroy_building'),(7,'Вред - переместить чужое здание','cast_vred_move_building');
/*!40000 ALTER TABLE `nonfinished_actions_dictionary` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `npc_player_name_modificators_i18n`
--

DROP TABLE IF EXISTS `npc_player_name_modificators_i18n`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `npc_player_name_modificators_i18n` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL,
  `language_id` int(10) unsigned NOT NULL,
  `text` varchar(500) NOT NULL,
  `log_text` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `npc_player_name_modificators_i18n`
--

LOCK TABLES `npc_player_name_modificators_i18n` WRITE;
/*!40000 ALTER TABLE `npc_player_name_modificators_i18n` DISABLE KEYS */;
INSERT INTO `npc_player_name_modificators_i18n` VALUES (1,'{mad}',2,'Безумный','Безум.'),(2,'{mad}',1,'Mad',NULL),(3,'{zombie}',2,'Зомби',NULL),(4,'{zombie}',1,'Zombie',NULL),(5,'{vampire}',2,'Вампир','Вамп.'),(6,'{vampire}',1,'Vampire',NULL);
/*!40000 ALTER TABLE `npc_player_name_modificators_i18n` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_deck`
--

DROP TABLE IF EXISTS `player_deck`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_deck` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `game_id` int(10) unsigned NOT NULL,
  `player_num` int(10) unsigned NOT NULL DEFAULT '0',
  `card_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_deck`
--

LOCK TABLES `player_deck` WRITE;
/*!40000 ALTER TABLE `player_deck` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_deck` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_features`
--

DROP TABLE IF EXISTS `player_features`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_features` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(45) NOT NULL,
  `name` varchar(45) NOT NULL,
  `default_param` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_features`
--

LOCK TABLES `player_features` WRITE;
/*!40000 ALTER TABLE `player_features` DISABLE KEYS */;
INSERT INTO `player_features` VALUES (1,'end_turn','Игрок пропустил ход',NULL);
/*!40000 ALTER TABLE `player_features` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_features_usage`
--

DROP TABLE IF EXISTS `player_features_usage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_features_usage` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `game_id` int(10) unsigned NOT NULL,
  `player_num` int(10) unsigned NOT NULL,
  `feature_id` int(10) unsigned NOT NULL,
  `param` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_features_usage`
--

LOCK TABLES `player_features_usage` WRITE;
/*!40000 ALTER TABLE `player_features_usage` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_features_usage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_start_deck_config`
--

DROP TABLE IF EXISTS `player_start_deck_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_start_deck_config` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `player_num` int(10) unsigned NOT NULL,
  `quantity` int(10) unsigned NOT NULL,
  `type` varchar(200) NOT NULL,
  `mode_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `player_start_deck_config_modes` (`mode_id`),
  CONSTRAINT `player_start_deck_config_modes` FOREIGN KEY (`mode_id`) REFERENCES `modes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=157 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_start_deck_config`
--

LOCK TABLES `player_start_deck_config` WRITE;
/*!40000 ALTER TABLE `player_start_deck_config` DISABLE KEYS */;
INSERT INTO `player_start_deck_config` VALUES (142,0,2,'m',9),(143,0,2,'u',9),(144,0,1,'b',9),(145,1,2,'m',9),(146,1,2,'u',9),(147,1,1,'b',9),(148,2,2,'m',9),(149,2,2,'u',9),(150,2,1,'b',9),(151,3,2,'m',9),(152,3,2,'u',9),(153,3,1,'b',9);
/*!40000 ALTER TABLE `player_start_deck_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_start_gold_config`
--

DROP TABLE IF EXISTS `player_start_gold_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_start_gold_config` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `player_num` int(10) unsigned NOT NULL,
  `quantity` int(10) unsigned NOT NULL,
  `mode_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `player_start_gold_config_modes` (`mode_id`),
  CONSTRAINT `player_start_gold_config_modes` FOREIGN KEY (`mode_id`) REFERENCES `modes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_start_gold_config`
--

LOCK TABLES `player_start_gold_config` WRITE;
/*!40000 ALTER TABLE `player_start_gold_config` DISABLE KEYS */;
INSERT INTO `player_start_gold_config` VALUES (62,0,100,9),(63,1,100,9),(64,2,100,9),(65,3,100,9);
/*!40000 ALTER TABLE `player_start_gold_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `players`
--

DROP TABLE IF EXISTS `players`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `players` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned DEFAULT NULL,
  `game_id` int(10) unsigned NOT NULL,
  `player_num` int(10) unsigned NOT NULL,
  `name` varchar(45) NOT NULL,
  `gold` int(10) unsigned NOT NULL DEFAULT '0',
  `owner` int(10) unsigned NOT NULL,
  `team` int(10) unsigned NOT NULL DEFAULT '0',
  `agree_draw` int(10) unsigned NOT NULL DEFAULT '0',
  `move_order` int(10) unsigned DEFAULT NULL,
  `language_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `players`
--

LOCK TABLES `players` WRITE;
/*!40000 ALTER TABLE `players` DISABLE KEYS */;
/*!40000 ALTER TABLE `players` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `players_bu` BEFORE UPDATE ON `players`
 FOR EACH ROW BEGIN
  IF(OLD.gold<>NEW.gold)THEN
  BEGIN
    DECLARE og,d INT;
    SET og=OLD.gold;
    SET d=NEW.gold;
    SET d=d-og;
    INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(NEW.game_id,NEW.player_num,'change_gold',d);
  END;
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `procedures`
--

DROP TABLE IF EXISTS `procedures`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `procedures` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `params` varchar(100) NOT NULL DEFAULT '',
  `ui_action_name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `procedures`
--

LOCK TABLES `procedures` WRITE;
/*!40000 ALTER TABLE `procedures` DISABLE KEYS */;
INSERT INTO `procedures` VALUES (1,'player_end_turn','',NULL),(2,'send_money','player,amount',NULL),(3,'buy_card','',NULL),(4,'take_subsidy','',NULL),(5,'player_resurrect','dead_unit',NULL),(6,'put_building','card,empty_coord_my_zone,rotation,flip',NULL),(7,'cast_pooring','card,player',NULL),(8,'cast_riching','card',NULL),(9,'cast_half_money','card',NULL),(10,'summon_unit','card',NULL),(11,'cast_fireball','card,unit',NULL),(12,'cast_lightening_min','card,unit','lightening_min'),(13,'cast_lightening_max','card,unit','lightening_max'),(14,'player_move_unit','unit,empty_coord','move'),(15,'attack','unit,attack_coord','attack'),(16,'player_exit','',NULL),(17,'agree_draw','',NULL),(18,'disagree_draw','',NULL),(19,'cast_paralich','card,unit',NULL),(22,'cast_madness','card,unit',NULL),(23,'cast_shield','card,unit',NULL),(24,'cast_healing','card,unit',NULL),(26,'cast_o_d','card,unit',NULL),(27,'cast_teleport','card,unit,empty_coord',NULL),(28,'cast_mind_control','card,unit',NULL),(29,'cast_show_cards','card,player',NULL),(30,'cast_telekinesis','card,player',NULL),(32,'cast_speeding','card,unit',NULL),(33,'cast_unit_upgrade_all','card,unit','upgrade_all'),(34,'cast_unit_upgrade_random','card,unit','upgrade_random'),(35,'cast_armageddon','card',NULL),(36,'cast_meteor_shower','card,any_coord',NULL),(37,'cast_repair_buildings','card',NULL),(38,'cast_polza_main','card',NULL),(39,'cast_polza_resurrect','dead_unit',NULL),(40,'cast_polza_units_from_zone','zone',NULL),(41,'cast_polza_move_building','building,empty_coord,rotation,flip',NULL),(42,'cast_vred_main','card',NULL),(43,'cast_vred_pooring','player',NULL),(44,'cast_vred_kill_unit','unit',NULL),(45,'cast_vred_destroy_building','building',NULL),(46,'cast_vred_move_building','building,empty_coord,rotation,flip',NULL),(47,'taran_bind','unit,target_unit','taran_bind'),(48,'wizard_heal','unit,target_unit','wizard_heal'),(49,'wizard_fireball','unit,target_unit','wizard_fireball'),(50,'necromancer_resurrect','unit,dead_unit','necromancer_resurrect'),(51,'cast_vampire','card,empty_coord_my_zone',NULL),(52,'necromancer_sacrifice','unit,my_unit,target_unit','necromancer_sacrifice'),(56,'unit_level_up_attack','unit',NULL),(57,'unit_level_up_health','unit',NULL),(58,'unit_level_up_moves','unit',NULL),(59,'wall_open','building','wall_open'),(60,'wall_close','building','wall_close'),(61,'unit_shoot','unit,shoot_target','shoot'),(62,'cast_iron_skin','card,unit',NULL),(63,'cast_berserk','card,unit',NULL),(64,'cast_horseshoe','card,unit',NULL);
/*!40000 ALTER TABLE `procedures` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `procedures_params`
--

DROP TABLE IF EXISTS `procedures_params`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `procedures_params` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `procedures_params`
--

LOCK TABLES `procedures_params` WRITE;
/*!40000 ALTER TABLE `procedures_params` DISABLE KEYS */;
INSERT INTO `procedures_params` VALUES (1,'empty_coord'),(2,'empty_coord_my_zone'),(3,'unit'),(4,'zone'),(5,'building'),(6,'player'),(7,'amount'),(8,'dead_unit'),(9,'card'),(10,'rotation'),(11,'flip'),(12,'attack_coord'),(14,'any_coord'),(15,'target_unit'),(16,'my_unit'),(19,'shoot_target');
/*!40000 ALTER TABLE `procedures_params` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `procedures_params_i18n`
--

DROP TABLE IF EXISTS `procedures_params_i18n`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `procedures_params_i18n` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `param_id` int(10) unsigned NOT NULL,
  `language_id` int(10) unsigned NOT NULL,
  `description` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `procedures_params_i18n_params_fk` (`param_id`),
  CONSTRAINT `procedures_params_i18n_params_fk` FOREIGN KEY (`param_id`) REFERENCES `procedures_params` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `procedures_params_i18n`
--

LOCK TABLES `procedures_params_i18n` WRITE;
/*!40000 ALTER TABLE `procedures_params_i18n` DISABLE KEYS */;
INSERT INTO `procedures_params_i18n` VALUES (1,1,2,'Выберите пустую клетку на поле'),(2,2,2,'Выберите место в своей зоне'),(3,3,2,'Выберите юнита'),(4,4,2,'Выберите зону'),(5,5,2,'Выберите здание'),(6,6,2,'Выберите игрока'),(7,7,2,'Укажите количество'),(8,8,2,'Выберите мертвого юнита'),(9,9,2,'Выберите карту'),(10,10,2,'Каким боком поставить'),(11,11,2,'Отразить'),(12,12,2,'Выберите, что атаковать'),(13,14,2,'Выберите любую клетку'),(14,15,2,'Выберите юнита, к которому применить действие'),(15,16,2,'Выберите своего юнита'),(18,1,1,'Pick an empty square'),(19,2,1,'Pick an empty square in your zone'),(20,3,1,'Pick a unit'),(21,4,1,'Pick a zone'),(22,5,1,'Pick a building'),(23,6,1,'Choose a player'),(24,7,1,'Choose amount'),(25,8,1,'Pick a unit from the graveyard'),(26,9,1,'Pick a card'),(27,10,1,'Rotate'),(28,11,1,'Flip'),(29,12,1,'Pick attack target'),(30,14,1,'Pick any square'),(31,15,1,'Pick a target unit'),(32,16,1,'Pick your own unit'),(35,19,1,'Pick a target'),(36,19,2,'Выберите цель');
/*!40000 ALTER TABLE `procedures_params_i18n` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `put_start_buildings_config`
--

DROP TABLE IF EXISTS `put_start_buildings_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `put_start_buildings_config` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `player_num` int(10) unsigned NOT NULL,
  `x` int(10) unsigned NOT NULL,
  `y` int(10) unsigned NOT NULL,
  `rotation` int(10) unsigned NOT NULL,
  `flip` int(10) unsigned NOT NULL DEFAULT '0',
  `building_id` int(10) unsigned NOT NULL,
  `mode_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `put_start_buildings_config_buildings` (`building_id`),
  KEY `put_start_buildings_config_modes` (`mode_id`),
  CONSTRAINT `put_start_buildings_config_buildings` FOREIGN KEY (`building_id`) REFERENCES `buildings` (`id`) ON DELETE CASCADE,
  CONSTRAINT `put_start_buildings_config_modes` FOREIGN KEY (`mode_id`) REFERENCES `modes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `put_start_buildings_config`
--

LOCK TABLES `put_start_buildings_config` WRITE;
/*!40000 ALTER TABLE `put_start_buildings_config` DISABLE KEYS */;
INSERT INTO `put_start_buildings_config` VALUES (41,0,0,0,0,0,15,9),(42,1,18,0,1,0,15,9),(43,2,18,18,2,0,15,9),(44,3,0,18,3,0,15,9),(48,9,6,6,0,0,21,9),(49,9,7,7,0,0,22,9),(50,9,11,7,1,0,22,9),(51,9,11,11,2,0,22,9),(52,9,7,11,3,0,22,9);
/*!40000 ALTER TABLE `put_start_buildings_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `put_start_units_config`
--

DROP TABLE IF EXISTS `put_start_units_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `put_start_units_config` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `player_num` int(10) unsigned NOT NULL,
  `x` int(10) unsigned NOT NULL,
  `y` int(10) unsigned NOT NULL,
  `unit_id` int(10) unsigned NOT NULL,
  `mode_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `put_start_units_config_units` (`unit_id`),
  KEY `put_start_units_config_modes` (`mode_id`),
  CONSTRAINT `put_start_units_config_modes` FOREIGN KEY (`mode_id`) REFERENCES `modes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `put_start_units_config_units` FOREIGN KEY (`unit_id`) REFERENCES `units` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `put_start_units_config`
--

LOCK TABLES `put_start_units_config` WRITE;
/*!40000 ALTER TABLE `put_start_units_config` DISABLE KEYS */;
INSERT INTO `put_start_units_config` VALUES (70,0,2,0,14,9),(71,0,0,2,14,9),(72,1,17,0,14,9),(73,1,19,2,14,9),(74,2,17,19,14,9),(75,2,19,17,14,9),(76,3,0,17,14,9),(77,3,2,19,14,9);
/*!40000 ALTER TABLE `put_start_units_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shooting_params`
--

DROP TABLE IF EXISTS `shooting_params`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `shooting_params` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `unit_id` int(10) unsigned NOT NULL,
  `distance` int(10) NOT NULL,
  `aim_type` varchar(45) NOT NULL,
  `dice_max` int(10) unsigned NOT NULL,
  `chance` int(10) unsigned NOT NULL,
  `damage_modificator_min` int(11) NOT NULL,
  `damage_modificator_max` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `shooting_params_units` (`unit_id`),
  CONSTRAINT `shooting_params_units_fk` FOREIGN KEY (`unit_id`) REFERENCES `units` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shooting_params`
--

LOCK TABLES `shooting_params` WRITE;
/*!40000 ALTER TABLE `shooting_params` DISABLE KEYS */;
INSERT INTO `shooting_params` VALUES (1,27,2,'unit',1,1,0,0),(2,27,3,'unit',2,2,0,0),(3,27,4,'unit',6,6,0,0),(4,28,2,'unit',1,1,0,0),(5,28,3,'unit',1,1,-1,0),(6,28,4,'unit',2,2,-1,-1),(7,29,2,'building',1,1,0,0),(8,29,3,'building',2,2,0,0),(9,29,4,'building',3,3,0,0),(10,29,5,'building',6,6,0,0),(11,29,2,'castle',1,1,0,0),(12,29,3,'castle',2,2,0,0),(13,29,4,'castle',3,3,0,0),(14,29,5,'castle',6,6,0,0);
/*!40000 ALTER TABLE `shooting_params` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `statistic_charts`
--

DROP TABLE IF EXISTS `statistic_charts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `statistic_charts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tab_id` int(10) unsigned NOT NULL,
  `type` varchar(45) NOT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `statistic_charts_tabs` (`tab_id`),
  CONSTRAINT `statistic_charts_tabs` FOREIGN KEY (`tab_id`) REFERENCES `statistic_tabs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `statistic_charts`
--

LOCK TABLES `statistic_charts` WRITE;
/*!40000 ALTER TABLE `statistic_charts` DISABLE KEYS */;
INSERT INTO `statistic_charts` VALUES (1,1,'bar','{income_chart}'),(2,1,'bar','{outgo_chart}'),(3,2,'bar','{bought_cards_chart}'),(4,2,'bar','{played_cards_chart}'),(5,2,'pie','{played_cards_by_type}'),(6,2,'pie','{played_cards_by_type}'),(7,2,'pie','{played_cards_by_type}'),(8,2,'pie','{played_cards_by_type}'),(9,3,'bar','{caused_damage_chart}'),(10,4,'bar','{success_rate_chart}'),(11,4,'bar','{critical_hit_chart}'),(12,5,'bar','{played_units_chart}'),(13,5,'bar','{killed_units_chart}'),(14,6,'bar','{played_buildings_chart}'),(15,6,'bar','{destroyed_buildings_chart}'),(16,5,'bar','{resurrected_units_chart}'),(17,2,'cardlist','{initial_cards_chart}'),(18,2,'cardlist','{initial_cards_chart}'),(19,2,'cardlist','{initial_cards_chart}'),(20,2,'cardlist','{initial_cards_chart}');
/*!40000 ALTER TABLE `statistic_charts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `statistic_game_actions`
--

DROP TABLE IF EXISTS `statistic_game_actions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `statistic_game_actions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `game_id` int(10) unsigned NOT NULL,
  `player_num` int(10) unsigned NOT NULL,
  `action` enum('change_gold','initial_card','buy_card','play_card','unit_attack','magical_attack','miss_attack','critical_hit','kill_unit','destroy_building','make_damage','resurrect_unit','unit_ability','start_game','end_game') NOT NULL,
  `value` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `statistic_game_actions`
--

LOCK TABLES `statistic_game_actions` WRITE;
/*!40000 ALTER TABLE `statistic_game_actions` DISABLE KEYS */;
/*!40000 ALTER TABLE `statistic_game_actions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `statistic_players`
--

DROP TABLE IF EXISTS `statistic_players`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `statistic_players` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `game_id` int(10) unsigned NOT NULL,
  `player_num` int(10) unsigned NOT NULL,
  `player_name` varchar(500) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `statistic_players`
--

LOCK TABLES `statistic_players` WRITE;
/*!40000 ALTER TABLE `statistic_players` DISABLE KEYS */;
/*!40000 ALTER TABLE `statistic_players` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `statistic_tabs`
--

DROP TABLE IF EXISTS `statistic_tabs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `statistic_tabs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `statistic_tabs`
--

LOCK TABLES `statistic_tabs` WRITE;
/*!40000 ALTER TABLE `statistic_tabs` DISABLE KEYS */;
INSERT INTO `statistic_tabs` VALUES (1,'{gold_tab}'),(2,'{cards_tab}'),(3,'{damage_tab}'),(4,'{attack_tab}'),(5,'{units_tab}'),(6,'{buildings_tab}');
/*!40000 ALTER TABLE `statistic_tabs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `statistic_values`
--

DROP TABLE IF EXISTS `statistic_values`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `statistic_values` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `game_id` int(10) unsigned NOT NULL,
  `stat_value_config_id` int(10) unsigned NOT NULL,
  `value` float DEFAULT NULL,
  `name` varchar(500) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `statistic_values`
--

LOCK TABLES `statistic_values` WRITE;
/*!40000 ALTER TABLE `statistic_values` DISABLE KEYS */;
/*!40000 ALTER TABLE `statistic_values` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `statistic_values_config`
--

DROP TABLE IF EXISTS `statistic_values_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `statistic_values_config` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `player_num` int(10) unsigned NOT NULL,
  `chart_id` int(10) unsigned NOT NULL,
  `measure_id` int(10) unsigned NOT NULL,
  `color` varchar(45) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `mode_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `statistic_values_config_charts` (`chart_id`),
  KEY `statistic_values_config_measures` (`measure_id`),
  KEY `statistic_values_config_modes` (`mode_id`),
  CONSTRAINT `statistic_values_config_charts` FOREIGN KEY (`chart_id`) REFERENCES `statistic_charts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `statistic_values_config_measures` FOREIGN KEY (`measure_id`) REFERENCES `dic_statistic_measures` (`id`) ON DELETE CASCADE,
  CONSTRAINT `statistic_values_config_modes` FOREIGN KEY (`mode_id`) REFERENCES `modes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=255 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `statistic_values_config`
--

LOCK TABLES `statistic_values_config` WRITE;
/*!40000 ALTER TABLE `statistic_values_config` DISABLE KEYS */;
INSERT INTO `statistic_values_config` VALUES (184,0,1,1,'p0',NULL,9),(185,1,1,1,'p1',NULL,9),(186,2,1,1,'p2',NULL,9),(187,3,1,1,'p3',NULL,9),(188,0,2,2,'p0',NULL,9),(189,1,2,2,'p1',NULL,9),(190,2,2,2,'p2',NULL,9),(191,3,2,2,'p3',NULL,9),(192,0,3,3,'p0',NULL,9),(193,1,3,3,'p1',NULL,9),(194,2,3,3,'p2',NULL,9),(195,3,3,3,'p3',NULL,9),(196,0,4,4,'p0',NULL,9),(197,1,4,4,'p1',NULL,9),(198,2,4,4,'p2',NULL,9),(199,3,4,4,'p3',NULL,9),(200,0,9,9,'p0',NULL,9),(201,1,9,9,'p1',NULL,9),(202,2,9,9,'p2',NULL,9),(203,3,9,9,'p3',NULL,9),(204,0,10,18,'p0',NULL,9),(205,1,10,18,'p1',NULL,9),(206,2,10,18,'p2',NULL,9),(207,3,10,18,'p3',NULL,9),(208,0,11,19,'p0',NULL,9),(209,1,11,19,'p1',NULL,9),(210,2,11,19,'p2',NULL,9),(211,3,11,19,'p3',NULL,9),(212,0,12,20,'p0',NULL,9),(213,1,12,20,'p1',NULL,9),(214,2,12,20,'p2',NULL,9),(215,3,12,20,'p3',NULL,9),(216,0,13,14,'p0',NULL,9),(217,1,13,14,'p1',NULL,9),(218,2,13,14,'p2',NULL,9),(219,3,13,14,'p3',NULL,9),(220,0,14,21,'p0',NULL,9),(221,1,14,21,'p1',NULL,9),(222,2,14,21,'p2',NULL,9),(223,3,14,21,'p3',NULL,9),(224,0,15,16,'p0',NULL,9),(225,1,15,16,'p1',NULL,9),(226,2,15,16,'p2',NULL,9),(227,3,15,16,'p3',NULL,9),(228,0,5,5,'magic','{magic_cards}',9),(230,0,5,7,'unit','{unit_cards}',9),(231,0,5,8,'building','{building_cards}',9),(232,1,6,5,'magic','{magic_cards}',9),(234,1,6,7,'unit','{unit_cards}',9),(235,1,6,8,'building','{building_cards}',9),(236,2,7,5,'magic','{magic_cards}',9),(238,2,7,7,'unit','{unit_cards}',9),(239,2,7,8,'building','{building_cards}',9),(240,3,8,5,'magic','{magic_cards}',9),(242,3,8,7,'unit','{unit_cards}',9),(243,3,8,8,'building','{building_cards}',9),(247,0,16,22,'p0',NULL,9),(248,1,16,22,'p1',NULL,9),(249,2,16,22,'p2',NULL,9),(250,3,16,22,'p3',NULL,9),(251,0,17,23,'card_color','card_name',9),(252,1,18,23,'card_color','card_name',9),(253,2,19,23,'card_color','card_name',9),(254,3,20,23,'card_color','card_name',9);
/*!40000 ALTER TABLE `statistic_values_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `statistics_i18n`
--

DROP TABLE IF EXISTS `statistics_i18n`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `statistics_i18n` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `language_id` int(10) unsigned NOT NULL,
  `code` varchar(50) NOT NULL,
  `text` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `statistics_i18n`
--

LOCK TABLES `statistics_i18n` WRITE;
/*!40000 ALTER TABLE `statistics_i18n` DISABLE KEYS */;
INSERT INTO `statistics_i18n` VALUES (1,1,'{unit_cards}','Units'),(2,2,'{unit_cards}','Юниты'),(3,1,'{building_cards}','Buildings'),(4,2,'{building_cards}','Здания'),(5,1,'{magic_cards}','Magic'),(6,2,'{magic_cards}','Магии'),(7,1,'{gold_tab}','Gold'),(8,2,'{gold_tab}','Золото'),(9,1,'{cards_tab}','Cards'),(10,2,'{cards_tab}','Карты'),(11,1,'{damage_tab}','Damage'),(12,2,'{damage_tab}','Урон'),(13,1,'{attack_tab}','Attack'),(14,2,'{attack_tab}','Атака'),(15,1,'{units_tab}','Units'),(16,2,'{units_tab}','Юниты'),(17,1,'{buildings_tab}','Buildings'),(18,2,'{buildings_tab}','Здания'),(19,1,'{income_chart}','Income'),(20,1,'{outgo_chart}','Outgo'),(21,1,'{bought_cards_chart}','Bought'),(22,1,'{played_cards_chart}','Played'),(23,1,'{played_cards_by_type}','{player_name} played by card type'),(24,1,'{played_cards_by_type}','{player_name} played by card type'),(25,1,'{played_cards_by_type}','{player_name} played by card type'),(26,1,'{played_cards_by_type}','{player_name} played by card type'),(27,1,'{caused_damage_chart}','Caused'),(28,1,'{success_rate_chart}','Success rate'),(29,1,'{critical_hit_chart}','Critical hit rate'),(30,1,'{played_units_chart}','Played units'),(31,1,'{killed_units_chart}','Killed units'),(32,1,'{played_buildings_chart}','Played buildings'),(33,1,'{destroyed_buildings_chart}','Destroyed buildings'),(34,1,'{resurrected_units_chart}','Resurrected units'),(35,2,'{income_chart}','Заработал'),(36,2,'{outgo_chart}','Потратил'),(37,2,'{bought_cards_chart}','Купил'),(38,2,'{played_cards_chart}','Сыграл'),(39,2,'{played_cards_by_type}','{player_name} cыграл по типам карт'),(40,2,'{played_cards_by_type}','{player_name} cыграл по типам карт'),(41,2,'{played_cards_by_type}','{player_name} cыграл по типам карт'),(42,2,'{played_cards_by_type}','{player_name} cыграл по типам карт'),(43,2,'{caused_damage_chart}','Нанес'),(44,2,'{success_rate_chart}','Процент попаданий'),(45,2,'{critical_hit_chart}','Процент критических'),(46,2,'{played_units_chart}','Призванных юнитов'),(47,2,'{killed_units_chart}','Убитых юнитов'),(48,2,'{played_buildings_chart}','Призванных зданий'),(49,2,'{destroyed_buildings_chart}','Разрушенных зданий'),(50,2,'{resurrected_units_chart}','Воскрешенных юнитов'),(51,1,'{initial_cards_chart}','Initial cards of {player_name}'),(52,2,'{initial_cards_chart}','Начальные карты игрока {player_name}');
/*!40000 ALTER TABLE `statistics_i18n` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `summon_cfg`
--

DROP TABLE IF EXISTS `summon_cfg`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `summon_cfg` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `building_id` int(10) unsigned NOT NULL,
  `unit_id` int(10) unsigned NOT NULL,
  `count` int(10) unsigned NOT NULL,
  `owner` int(10) unsigned NOT NULL,
  `mode_id` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `summon_cfg_buildings` (`building_id`),
  KEY `summon_cfg_units` (`unit_id`),
  KEY `summon_cfg_modes` (`mode_id`),
  CONSTRAINT `summon_cfg_buildings` FOREIGN KEY (`building_id`) REFERENCES `buildings` (`id`) ON DELETE CASCADE,
  CONSTRAINT `summon_cfg_modes` FOREIGN KEY (`mode_id`) REFERENCES `modes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `summon_cfg_units` FOREIGN KEY (`unit_id`) REFERENCES `units` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `summon_cfg`
--

LOCK TABLES `summon_cfg` WRITE;
/*!40000 ALTER TABLE `summon_cfg` DISABLE KEYS */;
INSERT INTO `summon_cfg` VALUES (17,13,24,3,2,9),(18,14,25,1,3,9),(19,17,14,1,4,9),(20,17,27,1,4,9);
/*!40000 ALTER TABLE `summon_cfg` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `unit_default_features`
--

DROP TABLE IF EXISTS `unit_default_features`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `unit_default_features` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `unit_id` int(10) unsigned NOT NULL,
  `feature_id` int(10) unsigned NOT NULL,
  `param` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `unit_default_features_units` (`unit_id`),
  KEY `unit_default_features_features` (`feature_id`),
  CONSTRAINT `unit_default_features_features` FOREIGN KEY (`feature_id`) REFERENCES `unit_features` (`id`) ON DELETE CASCADE,
  CONSTRAINT `unit_default_features_units` FOREIGN KEY (`unit_id`) REFERENCES `units` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=107 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `unit_default_features`
--

LOCK TABLES `unit_default_features` WRITE;
/*!40000 ALTER TABLE `unit_default_features` DISABLE KEYS */;
INSERT INTO `unit_default_features` VALUES (86,18,3,NULL),(87,19,1,NULL),(88,19,18,NULL),(90,20,2,NULL),(91,20,16,NULL),(92,20,17,NULL),(93,20,18,NULL),(97,24,14,NULL),(98,25,4,NULL),(99,25,14,NULL),(101,26,11,NULL),(102,26,13,NULL),(103,26,14,NULL),(104,29,2,NULL),(105,29,17,NULL),(106,29,18,NULL);
/*!40000 ALTER TABLE `unit_default_features` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `unit_features`
--

DROP TABLE IF EXISTS `unit_features`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `unit_features` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(45) NOT NULL,
  `log_key_add` varchar(50) DEFAULT NULL,
  `log_key_remove` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `unit_features`
--

LOCK TABLES `unit_features` WRITE;
/*!40000 ALTER TABLE `unit_features` DISABLE KEYS */;
INSERT INTO `unit_features` VALUES (1,'magic_immunity',NULL,NULL),(2,'bindable',NULL,NULL),(3,'blocks_buildings',NULL,NULL),(4,'agressive',NULL,NULL),(5,'madness','unit_goes_mad','unit_becomes_not_mad'),(6,'knight','unit_chess_knight',NULL),(7,'paralich','unit_paralyzed','unit_unparalyzed'),(8,'zombie',NULL,NULL),(9,'bind_target',NULL,NULL),(10,'attack_target',NULL,NULL),(11,'vamp',NULL,NULL),(12,'under_control',NULL,NULL),(13,'drink_health',NULL,NULL),(14,'no_card',NULL,NULL),(15,'parent_building',NULL,NULL),(16,'pushes',NULL,NULL),(17,'mechanical',NULL,NULL),(18,'goes_to_deck_on_death',NULL,NULL);
/*!40000 ALTER TABLE `unit_features` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `unit_features_i18n`
--

DROP TABLE IF EXISTS `unit_features_i18n`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `unit_features_i18n` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `feature_id` int(10) unsigned NOT NULL,
  `language_id` int(10) unsigned NOT NULL,
  `description` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `feature_id` (`feature_id`),
  CONSTRAINT `unit_features_i18n_ibfk_1` FOREIGN KEY (`feature_id`) REFERENCES `unit_features` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `unit_features_i18n`
--

LOCK TABLES `unit_features_i18n` WRITE;
/*!40000 ALTER TABLE `unit_features_i18n` DISABLE KEYS */;
INSERT INTO `unit_features_i18n` VALUES (1,1,2,'Юнит невосприимчив к магии'),(2,2,2,'Юнит можно цеплять к другим юнитам'),(3,3,2,'Юнит блокирует здания, находясь в их радиусе'),(4,4,2,'Юнит начинает бить ударившего его юнита'),(5,5,2,'Юнит сошел с ума'),(6,6,2,'Юнит ходит конем'),(7,7,2,'Юнит парализован'),(8,8,2,'Юнит - зомби'),(9,9,2,'Юнит, к которому прицеплен'),(10,10,2,'Юнит, которого атаковать'),(11,11,2,'Юнит - вампир'),(12,12,2,'Юнит под контролем другого юнита'),(13,13,2,'Юнит при ударе пьет жизнь противника'),(14,14,2,'Непризванный юнит'),(15,15,2,'Плодится из здания'),(16,16,2,'Толкается при атаке'),(17,17,2,'Механический'),(18,18,2,'При уничтожении идет не в мертвятник, а в колоду'),(19,1,1,'Unit is immune to magic'),(20,2,1,'Unit can be attached to and towed by another unit'),(21,3,1,'Unit blocks buildings when in their radius'),(22,4,1,'Unit fights back if attacked'),(23,5,1,'This unit is MAD'),(24,6,1,'Unit moves as a chess knight'),(25,7,1,'Unit is paralyzed'),(26,8,1,'This is a Zombie'),(27,9,1,'Unit, to which something is attached'),(28,10,1,'Attack target unit'),(29,11,1,'Vampire unit'),(30,12,1,'Unit is controlled by another unit'),(31,13,1,'Unit drains health on successful attack'),(32,14,1,'Unit is not played by card'),(33,15,1,'Is spawned from a building'),(34,16,1,'Pushes on attack'),(35,17,1,'Mechanical'),(36,18,1,'If killed, goes to the deck instead of the graveyard');
/*!40000 ALTER TABLE `unit_features_i18n` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `unit_level_up_experience`
--

DROP TABLE IF EXISTS `unit_level_up_experience`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `unit_level_up_experience` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `unit_id` int(10) unsigned NOT NULL,
  `level` int(11) NOT NULL,
  `experience` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `unit_level_up_experience_units` (`unit_id`),
  CONSTRAINT `unit_level_up_experience_units` FOREIGN KEY (`unit_id`) REFERENCES `units` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=94 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `unit_level_up_experience`
--

LOCK TABLES `unit_level_up_experience` WRITE;
/*!40000 ALTER TABLE `unit_level_up_experience` DISABLE KEYS */;
INSERT INTO `unit_level_up_experience` VALUES (14,14,1,2),(15,15,1,3),(16,16,1,5),(17,17,1,5),(18,18,1,4),(19,19,1,6),(20,20,1,7),(21,21,1,3),(22,22,1,3),(23,23,1,10),(24,24,1,2),(25,25,1,6),(26,26,1,5),(27,27,1,2),(28,28,1,4),(29,29,1,5),(45,14,2,5),(46,15,2,7),(47,16,2,11),(48,17,2,11),(49,18,2,9),(50,19,2,13),(51,20,2,15),(52,21,2,7),(53,22,2,7),(54,23,2,21),(55,24,2,5),(56,25,2,13),(57,26,2,11),(58,27,2,5),(59,28,2,9),(60,29,2,11),(76,14,3,9),(77,15,3,12),(78,16,3,18),(79,17,3,18),(80,18,3,15),(81,19,3,21),(82,20,3,24),(83,21,3,12),(84,22,3,12),(85,23,3,33),(86,24,3,9),(87,25,3,21),(88,26,3,18),(89,27,3,9),(90,28,3,15),(91,29,3,18);
/*!40000 ALTER TABLE `unit_level_up_experience` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `units`
--

DROP TABLE IF EXISTS `units`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `units` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `moves` int(10) unsigned NOT NULL,
  `health` int(10) unsigned NOT NULL,
  `attack` int(10) unsigned NOT NULL,
  `size` int(10) unsigned NOT NULL DEFAULT '1',
  `shield` int(11) NOT NULL DEFAULT '0',
  `ui_code` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `units`
--

LOCK TABLES `units` WRITE;
/*!40000 ALTER TABLE `units` DISABLE KEYS */;
INSERT INTO `units` VALUES (14,2,1,1,1,0,'spearman'),(15,2,1,2,1,0,'swordsman'),(16,2,3,2,1,0,'knight_on_foot'),(17,4,3,2,1,0,'knight_with_horse'),(18,3,2,2,1,0,'ninja'),(19,1,3,3,1,0,'golem'),(20,1,2,5,1,0,'taran'),(21,3,1,1,1,1,'wizard'),(22,3,2,1,1,0,'necromancer'),(23,6,5,5,2,0,'dragon'),(24,3,1,1,1,0,'frog'),(25,3,3,3,1,0,'troll'),(26,3,3,2,1,0,'vampire'),(27,2,1,1,1,0,'archer'),(28,2,2,2,1,0,'arbalester'),(29,1,2,3,1,0,'catapult');
/*!40000 ALTER TABLE `units` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `units_i18n`
--

DROP TABLE IF EXISTS `units_i18n`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `units_i18n` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `unit_id` int(10) unsigned NOT NULL,
  `language_id` int(10) unsigned NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `log_short_name` varchar(50) DEFAULT NULL,
  `log_name_accusative` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `unit_id` (`unit_id`),
  CONSTRAINT `units_i18n_ibfk_1` FOREIGN KEY (`unit_id`) REFERENCES `units` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `units_i18n`
--

LOCK TABLES `units_i18n` WRITE;
/*!40000 ALTER TABLE `units_i18n` DISABLE KEYS */;
INSERT INTO `units_i18n` VALUES (14,14,2,'Копейщик','При критическом ударе на конного рыцаря +1 атаки','Копейщик','Копейщика'),(15,15,2,'Мечник',NULL,'Мечник','Мечника'),(16,16,2,'Рыцарь','При критическом ударе дракона +2 атаки','Рыцарь','Рыцаря'),(17,17,2,'Конный рыцарь','При критическом ударе дракона +2 атаки','Кон. рыц.','Кон. рыц.'),(18,18,2,'Ниндзя','Вероятность попадания в ниндзю 1/2. Блокирует здания противника, если находится в их радиусе.','Ниндзя','Ниндзю'),(19,19,2,'Голем','Неуязвим к магии. При атаке урон по голему уменьшается на 1','Голем','Голема'),(20,20,2,'Таран','Наносит урон только зданиям. Юнитов отпихивает при атаке. Можно прицеплять к юнитам.','Таран','Таран'),(21,21,2,'Маг','Имеет собственный 1 щит. Может лечить других юнитов. Колдует Огненный Шар с вероятностью 2/9, при этом с вероятностью 1/36 убивает себя (либо теряет щит) из-за ошибки в заклинании','Маг','Мага'),(22,22,2,'Некромант','Воскрешает юнитов из могильника за их обычную цену, если стоит возле могилы, даже сразу после того, как юнит убит; может повреждать юнитов на любом расстоянии, принося в жертву своего юнита','Некромант','Некроманта'),(23,23,2,'Дракон','Атакует несколько целей рядом одновременно','Дракон','Дракона'),(24,24,2,'Жабка','Атакует ближайшего юнита любого игрока','Жабка','Жабку'),(25,25,2,'Тролль','Атакует ближайшее здание, пока его не тронут','Тролль','Тролля'),(26,26,2,'Вампир','Заражает вампиризмом, выпивает здоровье','Вампир','Вампира'),(27,27,2,'Лучник','Не бьет в ближнем бою. Стреляет только по юнитам. Через клетку - попадает всегда, через две клетки - 1/2, через три клетки - 1/6','Лучник','Лучника'),(28,28,2,'Арбалетчик','Не бьет в ближнем бою. Стреляет только по юнитам. Через клетку на 2 урона, через две - 1 или 2, через три - вероятность попадания 1/2 и 1 урона','Арбалетчик','Арбалетчика'),(29,29,2,'Катапульта','Стреляет по зданиям. Через клетку всегда попадает, через две 1/2, через три 1/3, через четыре 1/6','Катапульта','Катапульту'),(43,14,1,'Spearman','+1 damage on critical hit against Chevalier',NULL,NULL),(44,15,1,'Swordsman',NULL,NULL,NULL),(45,16,1,'Knight','+2 damage on critical hit against Dragon',NULL,NULL),(46,17,1,'Chevalier','+2 damage on critical hit against Dragon',NULL,NULL),(47,18,1,'Ninja','Dodges melee and range attacks with probability 1/2. Blocks opponent\'s buildings when stays in their radius',NULL,NULL),(48,19,1,'Golem','Resistant to magic. All attack damage on Golem is reduced by 1',NULL,NULL),(49,20,1,'Ram','Can only damage buildings. When attacks a unit, pushes it one square without damage. Can be attached to another unit for towing',NULL,NULL),(50,21,1,'Wizard','Has a magical shield. Can heal other units. Can cast Fireball with probability 2/9, but with probability 1/36 kills himself (or loses shield) because of misspelling',NULL,NULL),(51,22,1,'Necromancer','Can resurrect a unit for a normal price when near its grave, even immediately after it was killed. Can sacrifice a neighbouring own unit and cause damage to any other unit on the board',NULL,NULL),(52,23,1,'Dragon','Attacks multiple targets simultaneously',NULL,NULL),(53,24,1,'Frog','Attacks the nearest unit apart from fellow frogs',NULL,NULL),(54,25,1,'Troll','Attacks the nearest building (except castles). If attacked, fights back',NULL,NULL),(55,26,1,'Vampire','Attacks closest units and buildings. Can turn into vampire when kills a unit. Can drink health if hurts a unit',NULL,NULL),(56,27,1,'Archer','No melee attack. Attacks only units. Hits a targed at distance 2 always, at distance 3 with probability 1/2, at distance 4 with probability 1/6',NULL,NULL),(57,28,1,'Marksman','No melee attack. Attacks only units. Hits a targed at distance 2 for 2 damage, at distance 3 for 1 or 2 damage, at distance 4 for 1 damage with probability 1/2',NULL,NULL),(58,29,1,'Catapult','No melee attack. Attacks only buildings. Hits a targed at distance 2 always, at distance 3 with probability 1/2, at distance 4 with probability 1/3, at distance 5 with probability 1/6. Can be attached to another unit for towing',NULL,NULL);
/*!40000 ALTER TABLE `units_i18n` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `units_procedures`
--

DROP TABLE IF EXISTS `units_procedures`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `units_procedures` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `unit_id` int(10) unsigned NOT NULL,
  `procedure_id` int(10) unsigned NOT NULL,
  `default` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `units_procedures_units` (`unit_id`),
  KEY `units_procedures_procedures` (`procedure_id`),
  CONSTRAINT `units_procedures_procedures` FOREIGN KEY (`procedure_id`) REFERENCES `procedures` (`id`) ON DELETE CASCADE,
  CONSTRAINT `units_procedures_units` FOREIGN KEY (`unit_id`) REFERENCES `units` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=281 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `units_procedures`
--

LOCK TABLES `units_procedures` WRITE;
/*!40000 ALTER TABLE `units_procedures` DISABLE KEYS */;
INSERT INTO `units_procedures` VALUES (222,14,14,1),(223,14,15,0),(225,15,14,1),(226,15,15,0),(228,16,14,1),(229,16,15,0),(231,17,14,1),(232,17,15,0),(234,18,14,1),(235,18,15,0),(237,19,14,1),(238,19,15,0),(240,20,14,1),(241,20,15,0),(242,20,47,0),(243,21,14,1),(244,21,15,0),(245,21,48,0),(246,21,49,0),(250,22,14,1),(251,22,15,0),(252,22,50,0),(253,22,52,0),(257,23,14,1),(258,23,15,0),(260,24,14,1),(261,24,15,0),(263,25,14,1),(264,25,15,0),(266,26,14,1),(267,26,15,0),(268,27,14,1),(271,28,14,1),(274,29,14,1),(277,29,47,0),(278,27,61,0),(279,28,61,0),(280,29,61,0);
/*!40000 ALTER TABLE `units_procedures` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `videos`
--

DROP TABLE IF EXISTS `videos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `videos` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL,
  `filename` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `videos`
--

LOCK TABLES `videos` WRITE;
/*!40000 ALTER TABLE `videos` DISABLE KEYS */;
INSERT INTO `videos` VALUES (1,'destroyed_castle','destroyed_castle.mp4'),(2,'draw','draw.mp4'),(3,'win','win.mp4'),(4,'armageddon','armageddon.mp4');
/*!40000 ALTER TABLE `videos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `videos_i18n`
--

DROP TABLE IF EXISTS `videos_i18n`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `videos_i18n` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL,
  `language_id` int(10) unsigned NOT NULL,
  `title` varchar(500) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `videos_i18n`
--

LOCK TABLES `videos_i18n` WRITE;
/*!40000 ALTER TABLE `videos_i18n` DISABLE KEYS */;
INSERT INTO `videos_i18n` VALUES (1,'destroyed_castle',2,'Поражение'),(2,'destroyed_castle',1,'Defeat'),(3,'draw',2,'Ничья'),(4,'draw',1,'Draw'),(5,'win',2,'Победа!'),(6,'win',1,'Victory!'),(7,'armageddon',1,'Armageddon'),(8,'armageddon',2,'Армагеддон');
/*!40000 ALTER TABLE `videos_i18n` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `vw_grave`
--

DROP TABLE IF EXISTS `vw_grave`;
/*!50001 DROP VIEW IF EXISTS `vw_grave`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `vw_grave` (
  `game_id` tinyint NOT NULL,
  `grave_id` tinyint NOT NULL,
  `card_id` tinyint NOT NULL,
  `player_num_when_killed` tinyint NOT NULL,
  `turn_when_killed` tinyint NOT NULL,
  `x` tinyint NOT NULL,
  `y` tinyint NOT NULL,
  `size` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vw_mode_all_procedures`
--

DROP TABLE IF EXISTS `vw_mode_all_procedures`;
/*!50001 DROP VIEW IF EXISTS `vw_mode_all_procedures`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `vw_mode_all_procedures` (
  `mode_id` tinyint NOT NULL,
  `id` tinyint NOT NULL,
  `name` tinyint NOT NULL,
  `params` tinyint NOT NULL,
  `ui_action_name` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vw_mode_all_procedures_ids`
--

DROP TABLE IF EXISTS `vw_mode_all_procedures_ids`;
/*!50001 DROP VIEW IF EXISTS `vw_mode_all_procedures_ids`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `vw_mode_all_procedures_ids` (
  `mode_id` tinyint NOT NULL,
  `procedure_id` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vw_mode_building_default_features`
--

DROP TABLE IF EXISTS `vw_mode_building_default_features`;
/*!50001 DROP VIEW IF EXISTS `vw_mode_building_default_features`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `vw_mode_building_default_features` (
  `mode_id` tinyint NOT NULL,
  `id` tinyint NOT NULL,
  `building_id` tinyint NOT NULL,
  `feature_id` tinyint NOT NULL,
  `param` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vw_mode_buildings`
--

DROP TABLE IF EXISTS `vw_mode_buildings`;
/*!50001 DROP VIEW IF EXISTS `vw_mode_buildings`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `vw_mode_buildings` (
  `mode_id` tinyint NOT NULL,
  `id` tinyint NOT NULL,
  `health` tinyint NOT NULL,
  `radius` tinyint NOT NULL,
  `x_len` tinyint NOT NULL,
  `y_len` tinyint NOT NULL,
  `shape` tinyint NOT NULL,
  `type` tinyint NOT NULL,
  `ui_code` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vw_mode_buildings_procedures`
--

DROP TABLE IF EXISTS `vw_mode_buildings_procedures`;
/*!50001 DROP VIEW IF EXISTS `vw_mode_buildings_procedures`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `vw_mode_buildings_procedures` (
  `mode_id` tinyint NOT NULL,
  `building_id` tinyint NOT NULL,
  `procedure_id` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vw_mode_cards`
--

DROP TABLE IF EXISTS `vw_mode_cards`;
/*!50001 DROP VIEW IF EXISTS `vw_mode_cards`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `vw_mode_cards` (
  `mode_id` tinyint NOT NULL,
  `id` tinyint NOT NULL,
  `image` tinyint NOT NULL,
  `cost` tinyint NOT NULL,
  `type` tinyint NOT NULL,
  `ref` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vw_mode_cards_procedures`
--

DROP TABLE IF EXISTS `vw_mode_cards_procedures`;
/*!50001 DROP VIEW IF EXISTS `vw_mode_cards_procedures`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `vw_mode_cards_procedures` (
  `mode_id` tinyint NOT NULL,
  `card_id` tinyint NOT NULL,
  `procedure_id` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vw_mode_unit_default_features`
--

DROP TABLE IF EXISTS `vw_mode_unit_default_features`;
/*!50001 DROP VIEW IF EXISTS `vw_mode_unit_default_features`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `vw_mode_unit_default_features` (
  `mode_id` tinyint NOT NULL,
  `id` tinyint NOT NULL,
  `unit_id` tinyint NOT NULL,
  `feature_id` tinyint NOT NULL,
  `param` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vw_mode_unit_level_up_experience`
--

DROP TABLE IF EXISTS `vw_mode_unit_level_up_experience`;
/*!50001 DROP VIEW IF EXISTS `vw_mode_unit_level_up_experience`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `vw_mode_unit_level_up_experience` (
  `mode_id` tinyint NOT NULL,
  `unit_id` tinyint NOT NULL,
  `level` tinyint NOT NULL,
  `experience` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vw_mode_unit_phrases`
--

DROP TABLE IF EXISTS `vw_mode_unit_phrases`;
/*!50001 DROP VIEW IF EXISTS `vw_mode_unit_phrases`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `vw_mode_unit_phrases` (
  `mode_id` tinyint NOT NULL,
  `id` tinyint NOT NULL,
  `unit_id` tinyint NOT NULL,
  `phrase` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vw_mode_units`
--

DROP TABLE IF EXISTS `vw_mode_units`;
/*!50001 DROP VIEW IF EXISTS `vw_mode_units`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `vw_mode_units` (
  `mode_id` tinyint NOT NULL,
  `id` tinyint NOT NULL,
  `moves` tinyint NOT NULL,
  `health` tinyint NOT NULL,
  `attack` tinyint NOT NULL,
  `size` tinyint NOT NULL,
  `shield` tinyint NOT NULL,
  `ui_code` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vw_mode_units_procedures`
--

DROP TABLE IF EXISTS `vw_mode_units_procedures`;
/*!50001 DROP VIEW IF EXISTS `vw_mode_units_procedures`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `vw_mode_units_procedures` (
  `mode_id` tinyint NOT NULL,
  `unit_id` tinyint NOT NULL,
  `default` tinyint NOT NULL,
  `procedure_id` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Dumping events for database 'lords'
--

--
-- Dumping routines for database 'lords'
--
/*!50003 DROP FUNCTION IF EXISTS `building_feature_check` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `building_feature_check`(board_building_id INT, feature_code VARCHAR(45)) RETURNS int(11)
BEGIN
  IF EXISTS(SELECT bbf.id FROM board_buildings_features bbf JOIN building_features bf ON (bbf.feature_id=bf.id) WHERE bbf.board_building_id=board_building_id AND bf.code=feature_code LIMIT 1)
  THEN RETURN 1;
  ELSE RETURN 0;
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `building_feature_get_id_by_code` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `building_feature_get_id_by_code`(feature_code VARCHAR(45)) RETURNS int(11)
    DETERMINISTIC
BEGIN
  DECLARE result INT;
  SELECT bf.id INTO result FROM building_features bf WHERE bf.code=feature_code;
  RETURN result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `building_feature_get_param` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `building_feature_get_param`(board_building_id INT, feature_code VARCHAR(45)) RETURNS int(11)
BEGIN
  DECLARE result INT;
  SELECT bbf.param INTO result FROM board_buildings_features bbf JOIN building_features bf ON (bbf.feature_id=bf.id) WHERE bbf.board_building_id=board_building_id AND bf.code=feature_code LIMIT 1;
  RETURN result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `check_all_units_moved` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `check_all_units_moved`(g_id INT,p_num INT) RETURNS int(11)
BEGIN
	IF NOT EXISTS(SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id AND bu.player_num=p_num AND ((moves_left>0 AND unit_feature_check(bu.id,'paralich')=0) OR (check_unit_can_level_up(bu.id) = 1)) LIMIT 1) THEN
		RETURN 1;
	END IF;
	
	RETURN 0;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `check_building_can_do_action` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `check_building_can_do_action`(g_id INT,p_num INT,x INT,y INT,action_procedure VARCHAR(30)) RETURNS int(11)
BEGIN
  DECLARE board_building_id INT;
  DECLARE p_num_building_owner INT;
  DECLARE b_id INT;
  DECLARE current_turn INT;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id LIMIT 1) THEN RETURN 1; END IF;
  IF (SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id LIMIT 1)<>0 THEN RETURN 28; END IF;

  SELECT b.ref INTO board_building_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`<>'unit' LIMIT 1;
  IF board_building_id IS NULL THEN RETURN 26; END IF;

  SELECT bb.player_num,bb.building_id INTO p_num_building_owner,b_id FROM board_buildings bb WHERE bb.id=board_building_id LIMIT 1;

  IF p_num_building_owner<>p_num THEN RETURN 44; END IF;
  IF (check_building_deactivated(board_building_id)=1) THEN RETURN 45; END IF;

  IF(building_feature_check(board_building_id,'turn_when_changed')=1)THEN
    SELECT turn INTO current_turn FROM active_players WHERE game_id=g_id;
    IF(building_feature_get_param(board_building_id,'turn_when_changed') = current_turn)THEN
      RETURN 47;
    END IF;
  END IF;

  IF NOT EXISTS(SELECT bp.id FROM buildings_procedures bp JOIN procedures pm ON bp.procedure_id=pm.id WHERE bp.building_id=b_id AND pm.name=action_procedure LIMIT 1) THEN RETURN 46; END IF;

  UPDATE active_players SET current_procedure=action_procedure WHERE game_id=g_id;

  RETURN 0;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `check_building_deactivated` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `check_building_deactivated`(board_building_id INT) RETURNS int(11)
BEGIN

  IF EXISTS(SELECT b_n.id FROM board_units bu,board b_n,board_buildings bb, board b
    WHERE bb.id=board_building_id AND b.`type`<>'unit' AND b.ref=board_building_id
       AND bu.game_id=bb.game_id AND unit_feature_check(bu.id,'blocks_buildings')=1 AND b_n.`type`='unit' AND b_n.ref=bu.id
       AND b_n.x BETWEEN b.x-bb.radius AND b.x+bb.radius AND b_n.y BETWEEN b.y-bb.radius AND b.y+bb.radius
       AND get_unit_team(bu.id) <> get_building_team(bb.id) LIMIT 1)
  THEN RETURN 1;
  ELSE RETURN 0;
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `check_one_step_from_unit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `check_one_step_from_unit`(g_id INT,x INT,y INT,x2 INT,y2 INT) RETURNS int(11)
BEGIN
  DECLARE board_unit_id INT;
  DECLARE x0,y0 INT;

  SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;
  SELECT MIN(b.x),MIN(b.y) INTO x0,y0 FROM board b WHERE b.game_id=g_id AND b.ref=board_unit_id AND b.`type`='unit';

  IF (unit_feature_check(board_unit_id,'knight')=1) THEN 
    IF (ABS(x0-x2)=1 AND ABS(y0-y2)=2)OR(ABS(x0-x2)=2 AND ABS(y0-y2)=1) THEN RETURN 1; END IF;
  ELSE 
    IF (ABS(x0-x2)<=1 AND ABS(y0-y2)<=1)AND NOT(x0=x2 AND y0=y2) THEN RETURN 1; END IF;
  END IF;

  RETURN 0;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `check_play_card` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `check_play_card`(g_id INT,p_num INT,player_deck_id INT,sender VARCHAR(30)) RETURNS int(11)
BEGIN
  DECLARE crd_id INT;
  
  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id LIMIT 1) THEN RETURN 1; END IF;
  IF (SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id LIMIT 1)<>0 THEN RETURN 28; END IF;
  IF (SELECT card_played_flag FROM active_players WHERE game_id=g_id LIMIT 1)=1 THEN RETURN 42; END IF;
  IF NOT EXISTS(SELECT id FROM player_deck WHERE game_id=g_id AND player_num=p_num AND id=player_deck_id) THEN RETURN 10; END IF;
  
  SELECT card_id INTO crd_id FROM player_deck WHERE id=player_deck_id;
  IF (SELECT gold FROM players WHERE game_id=g_id AND player_num=p_num LIMIT 1)<(SELECT cost FROM cards WHERE id=crd_id LIMIT 1) THEN RETURN 2; END IF;
  IF NOT EXISTS(SELECT cp.id FROM player_deck pd JOIN cards_procedures cp ON pd.card_id=cp.card_id JOIN procedures pm ON cp.procedure_id=pm.id WHERE pd.id=player_deck_id AND pm.name=sender LIMIT 1) THEN RETURN 15; END IF;

  UPDATE active_players SET current_procedure=sender WHERE game_id=g_id;

  RETURN 0;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `check_unit_can_do_action` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `check_unit_can_do_action`(g_id INT,p_num INT,x INT,y INT,action_procedure VARCHAR(30)) RETURNS int(11)
BEGIN
  DECLARE board_unit_id INT;
  DECLARE p_num_unit_owner INT;
  DECLARE moves_left INT;
  DECLARE u_id INT;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id LIMIT 1) THEN RETURN 1; END IF;
  IF (SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id LIMIT 1)<>0 THEN RETURN 28; END IF;

  SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;
  IF board_unit_id IS NULL THEN RETURN 14; END IF;

  SELECT bu.player_num,bu.moves_left,bu.unit_id INTO p_num_unit_owner,moves_left,u_id FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

  IF p_num_unit_owner<>p_num THEN RETURN 16; END IF;
  IF moves_left<=0 THEN RETURN 17; END IF;
  IF (unit_feature_check(board_unit_id,'paralich')=1) THEN RETURN 18; END IF;

  IF NOT EXISTS(SELECT up.id FROM units_procedures up JOIN procedures pm ON up.procedure_id=pm.id WHERE up.unit_id=u_id AND pm.name=action_procedure LIMIT 1) THEN RETURN 30; END IF;

  UPDATE active_players SET current_procedure=action_procedure WHERE game_id=g_id;

  RETURN 0;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `check_unit_can_level_up` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `check_unit_can_level_up`(board_unit_id INT) RETURNS int(11)
BEGIN
	DECLARE unit_id INT;
	DECLARE unit_exp INT;
	DECLARE unit_level INT;
	
	SELECT bu.unit_id, bu.experience, bu.level INTO unit_id, unit_exp, unit_level FROM board_units bu WHERE bu.id = board_unit_id;
	
	IF EXISTS(SELECT 1 FROM unit_level_up_experience l WHERE l.unit_id = unit_id AND l.level = unit_level + 1 AND l.experience <= unit_exp) THEN
		RETURN 1;
	END IF;
	
	RETURN 0;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `free_cell_near_building_exists` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `free_cell_near_building_exists`(board_building_id INT) RETURNS int(11)
BEGIN
  DECLARE x, y INT;
  CALL get_random_free_cell_near_building(board_building_id, x, y);
  RETURN IF(x IS NOT NULL, 1, 0);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `game_feature_get_id_by_code` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `game_feature_get_id_by_code`(feature_code VARCHAR(45)) RETURNS int(11)
    DETERMINISTIC
BEGIN
  DECLARE result INT;
  SELECT gf.id INTO result FROM games_features gf WHERE gf.code=feature_code;
  RETURN result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `game_feature_get_param` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `game_feature_get_param`(game_id INT, feature_code VARCHAR(45)) RETURNS int(11)
BEGIN
  DECLARE result INT;
  SELECT gfu.param INTO result FROM games_features_usage gfu JOIN games_features gf ON (gfu.feature_id=gf.id) WHERE gfu.game_id=game_id AND gf.code=feature_code LIMIT 1;
  RETURN result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `get_building_team` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `get_building_team`(board_building_id INT) RETURNS int(11)
BEGIN
  RETURN
    (SELECT p.team
      FROM board_buildings b
        JOIN players p ON (b.game_id = p.game_id AND b.player_num = p.player_num)
      WHERE b.id = board_building_id
      LIMIT 1);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `get_current_p_num` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `get_current_p_num`(g_id INT) RETURNS int(11)
BEGIN
  RETURN (SELECT player_num FROM active_players WHERE game_id = g_id LIMIT 1);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `get_current_turn` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `get_current_turn`(g_id INT) RETURNS int(11)
BEGIN
  RETURN (SELECT turn FROM active_players WHERE game_id = g_id LIMIT 1);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `get_distance_between_units` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `get_distance_between_units`(board_unit_id_1 INT, board_unit_id_2 INT) RETURNS int(11)
BEGIN
  RETURN get_distance_from_unit_to_object(board_unit_id_1, 'unit', board_unit_id_2);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `get_distance_from_unit_to_object` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `get_distance_from_unit_to_object`(board_unit_id INT, obj_type VARCHAR(45), obj_id INT) RETURNS int(11)
    COMMENT 'obj_type can be either a type from board or ''grave'''
BEGIN
  RETURN
    (SELECT MIN(GREATEST(ABS(unit.x - obj.x),ABS(unit.y - obj.y)))
    FROM
      (SELECT b.x,b.y FROM board b WHERE b.`type`='unit' AND b.ref=board_unit_id) unit,
      (SELECT b.x,b.y FROM board b WHERE b.`type`=obj_type AND b.ref=obj_id
       UNION
       SELECT g.x,g.y FROM grave_cells g WHERE obj_type = 'grave' AND obj_id = g.grave_id) obj);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `get_experience_for_hitting` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `get_experience_for_hitting`(aim_board_id INT, aim_type VARCHAR(45), health_before_hit INT) RETURNS int(11)
BEGIN
  DECLARE experience INT;
  DECLARE health_after_hit INT;

  SET health_after_hit = get_health_after_hit(aim_board_id, aim_type);

  SET experience = health_before_hit - health_after_hit;
  IF(health_after_hit = 0)THEN
    SET experience = experience + 1;
  END IF;

  RETURN experience;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `get_health_after_hit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `get_health_after_hit`(aim_board_id INT, aim_type VARCHAR(45)) RETURNS int(11)
BEGIN
  DECLARE health_after_hit INT;

  IF (aim_type='unit') THEN
    SELECT bu.health INTO health_after_hit FROM board_units bu WHERE bu.id=aim_board_id LIMIT 1;
  ELSE
    SELECT bb.health INTO health_after_hit FROM board_buildings bb WHERE bb.id=aim_board_id LIMIT 1;
  END IF;
  IF (health_after_hit IS NULL) THEN
    SET health_after_hit = 0;
  END IF;

  RETURN health_after_hit;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `get_magic_field_factor` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `get_magic_field_factor`(g_id INT, p_num INT, x INT, y INT) RETURNS int(11)
BEGIN
  DECLARE result INT DEFAULT 1;
  DECLARE magic_tower_board_id INT;

  SELECT bb.id INTO magic_tower_board_id
    FROM board b_mt
      JOIN board_buildings bb ON (b_mt.ref=bb.id)
    WHERE bb.game_id=g_id AND b_mt.`type`<>'unit' AND building_feature_check(bb.id,'magic_increase')=1 AND check_building_deactivated(bb.id)=0
      AND x BETWEEN b_mt.x-bb.radius AND b_mt.x+bb.radius AND y BETWEEN b_mt.y-bb.radius AND b_mt.y+bb.radius
      AND NOT(x=b_mt.x AND y=b_mt.y)
      AND get_building_team(bb.id) = get_player_team(g_id, p_num) LIMIT 1;

  IF (magic_tower_board_id IS NOT NULL) THEN
    SET result = result * building_feature_get_param(magic_tower_board_id, 'magic_increase');
  END IF;

    RETURN result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `get_move_order_for_new_npc` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `get_move_order_for_new_npc`(g_id INT, p_num INT) RETURNS int(11)
BEGIN
  DECLARE move_order_p INT;
  DECLARE move_order_new_npc INT;
  
  SELECT p.move_order INTO move_order_p FROM players p WHERE p.game_id = g_id AND p.player_num = p_num LIMIT 1;
  
  SELECT MIN(p.move_order) INTO move_order_new_npc FROM players p WHERE p.game_id = g_id AND p.owner = 1 AND p.move_order > move_order_p;

  IF move_order_new_npc IS NULL THEN
    SELECT MAX(p.move_order) + 1 INTO move_order_new_npc FROM players p WHERE p.game_id = g_id;
  END IF;

  RETURN move_order_new_npc;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `get_new_team_number` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `get_new_team_number`(g_id INT) RETURNS int(11)
BEGIN
  DECLARE result INT;

  SELECT MAX(a.team)+1 INTO result
    FROM
      (SELECT p.team as `team` FROM players p WHERE p.game_id=g_id
      UNION
      SELECT building_feature_get_param(bb.id,'summon_team')
        FROM board_buildings bb
          WHERE bb.game_id=g_id AND building_feature_check(bb.id,'summon_team')=1) a;

  RETURN result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `get_npc_board_unit_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `get_npc_board_unit_id`(g_id INT, p_num INT) RETURNS int(11)
BEGIN
  DECLARE result INT;
  SELECT bu.id INTO result FROM board_units bu WHERE bu.game_id = g_id AND bu.player_num = p_num LIMIT 1;
  RETURN result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `get_number_of_spawned_creatures` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `get_number_of_spawned_creatures`(board_building_id INT) RETURNS int(11)
BEGIN
  DECLARE g_id INT;

  SELECT game_id INTO g_id FROM board_buildings WHERE id=board_building_id LIMIT 1;

  RETURN (SELECT COUNT(*) FROM board_units bu
    WHERE bu.game_id = g_id
      AND unit_feature_check(bu.id, 'parent_building') = 1
      AND unit_feature_get_param(bu.id, 'parent_building') = board_building_id);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `get_player_language_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `get_player_language_id`(g_id INT, p_num INT) RETURNS int(11)
BEGIN
  DECLARE result INT;

  SELECT language_id INTO result FROM players WHERE game_id = g_id AND player_num = p_num;

  RETURN result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `get_player_team` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `get_player_team`(g_id INT, p_num INT) RETURNS int(11)
BEGIN
  RETURN (SELECT team FROM players WHERE game_id = g_id AND player_num = p_num LIMIT 1);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `get_random_int_between` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `get_random_int_between`(min_value INT, max_value INT) RETURNS int(11)
BEGIN
  RETURN FLOOR(RAND()*(max_value - min_value + 1) + min_value);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `get_random_others_moveable_building_or_obstacle` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `get_random_others_moveable_building_or_obstacle`(g_id INT, p_num INT) RETURNS int(11)
BEGIN
  DECLARE big_dice INT;
  DECLARE rand_building_id INT;

  CREATE TEMPORARY TABLE tmp_buildings (id_rand INT AUTO_INCREMENT PRIMARY KEY)AUTO_INCREMENT=1
    SELECT DISTINCT b.ref AS `board_building_id`
    FROM board b
    JOIN board_buildings bb ON (b.ref=bb.id)
    WHERE b.game_id=g_id AND b.`type` IN ('building','obstacle') AND bb.player_num<>p_num AND building_feature_check(bb.id,'not_movable')=0;
  IF (SELECT COUNT(*) FROM tmp_buildings) = 0 THEN
    RETURN NULL;
  ELSE
    SET big_dice = get_random_int_between(1, (SELECT MAX(id_rand) FROM tmp_buildings));
    SELECT `board_building_id` INTO rand_building_id FROM tmp_buildings WHERE id_rand=big_dice LIMIT 1;
    DROP TEMPORARY TABLE tmp_buildings;
    RETURN rand_building_id;
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `get_unit_team` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `get_unit_team`(board_unit_id INT) RETURNS int(11)
BEGIN
  RETURN
    (SELECT p.team
      FROM board_units b
        JOIN players p ON (b.game_id = p.game_id AND b.player_num = p.player_num)
      WHERE b.id = board_unit_id
      LIMIT 1);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `log_building` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `log_building`(board_building_id INT) RETURNS varchar(200) CHARSET utf8
BEGIN
  DECLARE b_id INT;
  DECLARE p_num INT;
  DECLARE x INT;
  DECLARE y INT;
  DECLARE obj_type VARCHAR(45) CHARSET utf8;
  
  SELECT building_id, player_num INTO b_id, p_num FROM board_buildings bb WHERE bb.id = board_building_id;
  SELECT b.x, b.y, b.type INTO x, y, obj_type FROM board b WHERE b.type != 'unit' AND b.ref = board_building_id LIMIT 1;
  RETURN CONCAT('{"type":"', obj_type, '","board_id":', board_building_id, ',"player_num":', p_num, ',"building_id":', b_id, ',"x":', x, ',"y":', y, '}');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `log_cell` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `log_cell`(x INT,  y INT) RETURNS varchar(50) CHARSET utf8
BEGIN
  RETURN CONCAT('{"type":"cell","x":', x, ',"y":', y, '}');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `log_player` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `log_player`(g_id INT, p_num INT) RETURNS varchar(200) CHARSET utf8
BEGIN
  DECLARE p_name VARCHAR(45) CHARSET utf8;
  SELECT p.name INTO p_name FROM players p WHERE p.game_id = g_id AND p.player_num = p_num LIMIT 1;
  RETURN CONCAT('{"player_num":', p_num, ',"name":"', p_name, '"',
                CASE WHEN p_num >= 10 THEN CONCAT(',"unit":', log_unit(get_npc_board_unit_id(g_id, p_num))) ELSE '' END, '}');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `log_unit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `log_unit`(board_unit_id INT) RETURNS varchar(200) CHARSET utf8
BEGIN
  DECLARE u_id INT;
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE x INT;
  DECLARE y INT;
  DECLARE p_name VARCHAR(45);
  
  SELECT unit_id, game_id, player_num INTO u_id, g_id, p_num FROM board_units bu WHERE bu.id = board_unit_id;
  SELECT b.x, b.y INTO x, y FROM board b WHERE b.type = 'unit' AND b.ref = board_unit_id LIMIT 1;
  SELECT p.name INTO p_name FROM players p WHERE p.game_id = g_id AND p.player_num = p_num LIMIT 1;
  RETURN CONCAT('{"type":"unit","board_id":', board_unit_id, ',"player_num":', p_num, ',"unit_id":', u_id, ',"x":', x, ',"y":', y,
                CASE WHEN p_num >= 10 THEN CONCAT(',"npc_player_name":"', p_name, '"') ELSE '' END, '}');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `player_feature_get_id_by_code` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `player_feature_get_id_by_code`(feature_code VARCHAR(45)) RETURNS int(11)
    DETERMINISTIC
BEGIN
  DECLARE result INT;
  SELECT pf.id INTO result FROM player_features pf WHERE pf.code=feature_code;
  RETURN result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `quart` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `quart`(x INT,y INT) RETURNS int(11)
    DETERMINISTIC
BEGIN

  IF (x>19) OR (x<0) OR (y>19) OR (y<0) THEN RETURN 5; 
  END IF;

  IF (x<10)AND(y<10) THEN RETURN 0;
  END IF;
  IF (x>9)AND(y<10) THEN RETURN 1;
  END IF;
  IF (x>9)AND(y>9) THEN RETURN 2;
  END IF;
  IF (x<10)AND(y>9) THEN RETURN 3;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `unit_feature_check` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `unit_feature_check`(board_unit_id INT, feature_code VARCHAR(45)) RETURNS int(11)
BEGIN
  IF EXISTS(SELECT buf.id FROM board_units_features buf JOIN unit_features uf ON (buf.feature_id=uf.id) WHERE buf.board_unit_id=board_unit_id AND uf.code=feature_code LIMIT 1)
  THEN RETURN 1;
  ELSE RETURN 0;
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `unit_feature_get_id_by_code` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `unit_feature_get_id_by_code`(feature_code VARCHAR(45)) RETURNS int(11)
    DETERMINISTIC
BEGIN
  DECLARE result INT;
  SELECT uf.id INTO result FROM unit_features uf WHERE uf.code=feature_code;
  RETURN result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `unit_feature_get_param` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `unit_feature_get_param`(board_unit_id INT, feature_code VARCHAR(45)) RETURNS int(11)
BEGIN
  DECLARE result INT DEFAULT NULL;
  IF unit_feature_check(board_unit_id,feature_code)=1 THEN
    SELECT buf.param INTO result FROM board_units_features buf JOIN unit_features uf ON (buf.feature_id=uf.id) WHERE buf.board_unit_id=board_unit_id AND uf.code=feature_code LIMIT 1;
  END IF;
  RETURN result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `agree_draw` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `agree_draw`(g_id INT, p_num INT)
BEGIN
  CALL user_action_begin();

  UPDATE players SET agree_draw=1 WHERE game_id=g_id AND player_num=p_num;

  CALL cmd_log_add_independent_message(g_id, p_num, 'agrees_to_draw', NULL);

  IF NOT EXISTS(SELECT p.id FROM players p WHERE p.game_id=g_id AND p.owner=1 AND p.agree_draw=0) THEN
    CALL end_game(g_id);
  END IF;

  CALL user_action_end();

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `attack` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `attack`(g_id INT, p_num INT, x INT, y INT,  x2 INT,  y2 INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE size INT;
  DECLARE aim_type VARCHAR(45);
  DECLARE aim_id INT;

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT DISTINCT b.`type`,b.ref FROM board b WHERE b.game_id=g_id AND b.`type`<>'obstacle' AND b.x BETWEEN x2 AND x2+size-1 AND b.y BETWEEN y2 AND y2+size-1 AND NOT(b.`type`='unit' AND b.ref=board_unit_id);
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'attack'); 
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF check_one_step_from_unit(g_id,x,y,x2,y2)=0 THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=20;
    ELSE

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;
      SELECT u.size INTO size FROM board_units bu JOIN units u ON (bu.unit_id=u.id) WHERE bu.id=board_unit_id LIMIT 1;

      IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.`type`<>'obstacle' AND b.x BETWEEN x2 AND x2+size-1 AND b.y BETWEEN y2 AND y2+size-1 AND NOT(b.`type`='unit' AND b.ref=board_unit_id) LIMIT 1)
      THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=21;
      ELSE

                CALL unit_action_begin(g_id, p_num);

                IF (unit_feature_get_param(board_unit_id,'bind_target') IS NOT NULL) THEN 
                  CALL unit_feature_remove(board_unit_id,'bind_target');
                END IF; 

                UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
                CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

                IF size=1 THEN
                  SELECT b.`type`,b.ref INTO aim_type,aim_id FROM board b WHERE b.game_id=g_id AND b.x=x2 AND b.y=y2 LIMIT 1;
                  CALL attack_actions(board_unit_id,aim_type,aim_id);
                  INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'unit_attack');
                ELSE 
                  OPEN cur;
                  REPEAT
                    FETCH cur INTO aim_type,aim_id;
                    IF NOT done AND EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.`type`=aim_type AND b.ref=aim_id LIMIT 1) THEN
                      CALL attack_actions(board_unit_id,aim_type,aim_id);
                      INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'unit_attack');
                    END IF;
                  UNTIL done END REPEAT;
                  CLOSE cur;
                END IF;

                CALL unit_action_end(g_id, p_num);
      END IF;
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `attack_actions` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `attack_actions`(board_unit_id INT,   aim_type VARCHAR(45),   aim_board_id INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT; 
  DECLARE p2_num INT; 
  DECLARE u_id,aim_object_id INT;
  DECLARE health_before_hit,health_after_hit,experience INT;
  DECLARE aim_card_id INT;
  DECLARE aim_x,aim_y INT;
  DECLARE aim_shield INT DEFAULT 0;
  DECLARE aim_goes_to_deck INT;
  DECLARE aim_cannot_be_vampired INT;
  DECLARE grave_id INT;
  DECLARE aim_no_exp INT DEFAULT 0;

  DECLARE damage INT;
  DECLARE attack_success,critical INT;

  DECLARE cmd_log_unit VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_attack_unit_message($x,$y,$x2,$y2,$p_num,$unit_id,$p2_num,$aim_unit_id,$attack_success,$critical,$damage,"$npc_name","$npc2_name")';
  DECLARE cmd_log_building VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_attack_building_message($x,$y,$x2,$y2,$p_num,$unit_id,$p2_num,$aim_building_id,$attack_success,$critical,$damage,"$npc_name")';
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8;

  SET cmd_log='log_add_attack_unit_message($x,$y,$x2,$y2,$p_num,$p2_num,$attack_success,$critical,$damage)';

  SELECT bu.game_id,bu.player_num,bu.unit_id INTO g_id,p_num,u_id FROM board_units bu JOIN games g ON (bu.game_id=g.id) WHERE bu.id=board_unit_id LIMIT 1;

  CASE
    WHEN aim_type='unit' THEN
    BEGIN
      SELECT bu.player_num,bu.unit_id,bu.health,bu.card_id,shield INTO p2_num,aim_object_id,health_before_hit,aim_card_id,aim_shield FROM board_units bu WHERE bu.id=aim_board_id LIMIT 1;
      SET aim_goes_to_deck = unit_feature_check(aim_board_id,'goes_to_deck_on_death');
      SET aim_cannot_be_vampired = unit_feature_check(aim_board_id,'mechanical') + unit_feature_check(aim_board_id,'magic_immunity');
      SELECT MIN(b.x),MIN(b.y) INTO aim_x,aim_y FROM board b WHERE b.game_id=g_id AND b.`type`=aim_type AND b.ref=aim_board_id;
      SET cmd_log = REPLACE(cmd_log_unit, '$aim_unit_id', aim_object_id);
      IF ((SELECT p.owner FROM players p WHERE p.game_id = g_id AND p.player_num = p2_num LIMIT 1) <> 1) THEN
        SET cmd_log=REPLACE(cmd_log,'$npc2_name', (SELECT p.name FROM players p WHERE p.game_id = g_id AND p.player_num = p2_num LIMIT 1));
      ELSE
        SET cmd_log=REPLACE(cmd_log,'$npc2_name', '');
      END IF;
    END;
    WHEN aim_type='building' OR aim_type='castle' THEN
    BEGIN
      SELECT bb.player_num,bb.building_id,bb.health INTO p2_num,aim_object_id,health_before_hit FROM board_buildings bb WHERE bb.id=aim_board_id LIMIT 1;
      SELECT b.x,b.y INTO aim_x,aim_y FROM board b WHERE b.game_id=g_id AND b.`type`=aim_type AND b.ref=aim_board_id LIMIT 1;
      SET cmd_log = REPLACE(cmd_log_building, '$aim_building_id', aim_object_id);
    END;
  END CASE;

  CALL calculate_attack_damage(board_unit_id,aim_type,aim_board_id,attack_success,damage,critical);

      SET cmd_log=REPLACE(cmd_log,'$unit_id',u_id);
      SET cmd_log=REPLACE(cmd_log,'$x,$y',(SELECT CONCAT(b.x,',',b.y) FROM board b WHERE b.`type`='unit' AND b.ref=board_unit_id LIMIT 1));
      SET cmd_log=REPLACE(cmd_log,'$x2,$y2',(SELECT CONCAT(aim_x,',',aim_y) FROM DUAL));

      SET cmd_log=REPLACE(cmd_log,'$p_num',p_num);
      SET cmd_log=REPLACE(cmd_log,'$p2_num',p2_num);

      SET cmd_log=REPLACE(cmd_log,'$attack_success',attack_success);
      SET cmd_log=REPLACE(cmd_log,'$critical',critical);
      SET cmd_log=REPLACE(cmd_log,'$damage',CASE WHEN aim_shield=0 THEN damage ELSE 0 END);
      IF ((SELECT p.owner FROM players p WHERE p.game_id = g_id AND p.player_num = p_num LIMIT 1) <> 1) THEN
        SET cmd_log=REPLACE(cmd_log,'$npc_name', (SELECT p.name FROM players p WHERE p.game_id = g_id AND p.player_num = p_num LIMIT 1));
      ELSE
        SET cmd_log=REPLACE(cmd_log,'$npc_name', '');
      END IF;

      INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

  IF critical=1 THEN
    INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'critical_hit');
  END IF;

      IF attack_success=1 THEN 

        
        IF(aim_type='unit' AND unit_feature_check(aim_board_id,'agressive')=1) THEN 
          CALL unit_feature_set(aim_board_id,'attack_target',board_unit_id);
        END IF;

        IF(aim_type='building' AND building_feature_check(aim_board_id,'no_exp')=1) THEN 
          SET aim_no_exp = 1;
        END IF;

        CASE aim_type
          WHEN 'unit' THEN CALL hit_unit(aim_board_id,p_num,damage);
          WHEN 'building' THEN CALL hit_building(aim_board_id,p_num,damage);
          WHEN 'castle' THEN CALL hit_castle(aim_board_id,p_num,damage);
        END CASE;

        SET health_after_hit = get_health_after_hit(aim_board_id, aim_type);

        SET experience = get_experience_for_hitting(aim_board_id, aim_type, health_before_hit);
        IF(experience > 0 AND aim_no_exp = 0 AND EXISTS(SELECT id FROM board_units WHERE id=board_unit_id))THEN
          CALL unit_add_exp(board_unit_id, experience);
        END IF;

        IF (aim_type='unit') THEN

          IF (unit_feature_check(board_unit_id,'drink_health')=1) AND (health_after_hit<health_before_hit)THEN
            CALL drink_health(board_unit_id);
          END IF;


          IF (unit_feature_check(board_unit_id,'vamp')=1) AND (health_after_hit = 0) AND (aim_cannot_be_vampired = 0) THEN
            IF (aim_card_id IS NOT NULL AND aim_goes_to_deck=0) THEN
              SELECT gc.grave_id INTO grave_id FROM graves g JOIN grave_cells gc ON g.id=gc.grave_id WHERE g.game_id=g_id AND g.card_id=aim_card_id AND gc.x=aim_x AND gc.y=aim_y LIMIT 1;
              CALL vampire_resurrect_by_card(board_unit_id,grave_id);
            ELSE
              CALL vampire_resurrect_by_u_id(board_unit_id,aim_object_id,aim_x,aim_y);
            END IF;
          END IF;
          
          IF(unit_feature_check(board_unit_id,'pushes')=1 AND aim_type='unit') THEN 
            CALL unit_push(board_unit_id,aim_board_id);
          END IF;

        END IF;

      ELSE 
        INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'miss_attack');
      END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `barracks_summon` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `barracks_summon`(g_id INT,  board_building_id INT)
BEGIN
  DECLARE spawned_count INT;
  DECLARE dice INT;

  SET spawned_count = get_number_of_spawned_creatures(board_building_id);
  SET dice = POW(6, CASE WHEN spawned_count IN(0,1,2,3) THEN 1 ELSE spawned_count-2 END);
  IF (get_random_int_between(1, dice) = 1) THEN
    CALL summon_one_creature_by_config(board_building_id);
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `bridge_destroy` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `bridge_destroy`(g_id INT,p_num INT,x INT,y INT,rotation INT,flip INT)
BEGIN
  DECLARE g_mode INT;
  DECLARE x_sink,y_sink INT;
  DECLARE type_sink VARCHAR(45);
  DECLARE ref_sink INT;
  DECLARE destroyed_bridge_building_id INT;
  DECLARE neutral_p_num INT DEFAULT 9;
  DECLARE new_board_building_id INT;
  
  SELECT g.mode_id INTO g_mode FROM games g WHERE g.id=g_id LIMIT 1;

  IF(rotation = 0)THEN
    SET x_sink = x;
    SET y_sink = y;
  END IF;
  IF(rotation = 1)THEN
    SET x_sink = x+1;
    SET y_sink = y;
  END IF;
  IF(rotation = 2)THEN
    SET x_sink = x+1;
    SET y_sink = y+1;
  END IF;
  IF(rotation = 3)THEN
    SET x_sink = x;
    SET y_sink = y+1;
  END IF;
  

  SELECT b.type, b.ref INTO type_sink,ref_sink FROM board b WHERE b.game_id = g_id AND b.x = x_sink AND b.y = y_sink;
  IF(type_sink IS NOT NULL)THEN
    IF(type_sink = 'unit') THEN
      CALL sink_unit(ref_sink,p_num);
    ELSE
      CALL sink_building(ref_sink,p_num);
    END IF;
  END IF;
  
  SELECT v.building_id INTO destroyed_bridge_building_id FROM  vw_mode_building_default_features v WHERE v.mode_id=g_mode AND v.feature_id=building_feature_get_id_by_code('destroyed_bridge');
  
  INSERT INTO board_buildings(game_id,player_num,building_id,rotation,flip)VALUES (g_id,neutral_p_num,destroyed_bridge_building_id,rotation,flip);
  SET new_board_building_id=@@last_insert_id;

  CALL place_building_on_board(new_board_building_id,x,y,rotation,flip);

  INSERT INTO board_buildings_features(board_building_id,feature_id,param) SELECT new_board_building_id,bf.feature_id,bf.param FROM building_default_features bf WHERE bf.building_id=destroyed_bridge_building_id;
  
  CALL cmd_put_building_by_id(g_id,neutral_p_num,new_board_building_id);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `building_feature_set` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `building_feature_set`(board_building_id INT, feature_code VARCHAR(45),param_value INT)
BEGIN
  IF(building_feature_check(board_building_id,feature_code)=0)THEN 
    INSERT INTO board_buildings_features(board_building_id,feature_id,param) SELECT board_building_id,bf.id,param_value FROM building_features bf WHERE bf.code=feature_code;
  ELSE 
    UPDATE board_buildings_features bbf
      SET bbf.param=param_value
      WHERE bbf.board_building_id=board_building_id AND bbf.feature_id=building_feature_get_id_by_code(feature_code);
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `buy_card` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `buy_card`(g_id INT, p_num INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE card_cost INT;
  DECLARE new_card INT;
  DECLARE first_card_id INT;
  DECLARE player_deck_id INT;

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
  SELECT cfg.`value` INTO card_cost FROM mode_config cfg WHERE cfg.param='card cost' AND cfg.mode_id=mode_id;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;
  ELSE
    IF (SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id LIMIT 1)<>0 THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=28;
    ELSE
      IF (SELECT card_played_flag FROM active_players WHERE game_id=g_id)=1 THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=42;
      ELSE
        IF (SELECT gold FROM players WHERE game_id=g_id AND player_num=p_num)<card_cost THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=2;
        ELSE
          IF NOT EXISTS (SELECT id FROM deck WHERE game_id=g_id) THEN
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=3;
          ELSE

            CALL user_action_begin();

            UPDATE players SET gold=gold-card_cost WHERE game_id=g_id AND player_num=p_num;
            SELECT MIN(id) INTO first_card_id FROM deck WHERE game_id=g_id;
            SELECT card_id INTO new_card FROM deck WHERE game_id=g_id AND id=first_card_id;
            INSERT INTO player_deck (game_id,player_num,card_id) VALUES (g_id,p_num,new_card);
            SET player_deck_id=@@last_insert_id;

            DELETE FROM deck WHERE game_id=g_id AND id=first_card_id;

            CALL cmd_player_set_gold(g_id,p_num);
            CALL cmd_add_card(g_id,p_num,player_deck_id);

            CALL cmd_log_add_independent_message(g_id, p_num, 'buys_card', NULL);
            CALL cmd_log_add_independent_message_hidden(g_id, p_num, 'card_name', new_card);

            INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'buy_card',new_card);
            CALL end_cards_phase(g_id,p_num);

            CALL user_action_end();
          END IF;
        END IF;
      END IF;
    END IF;
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `calculate_attack_damage` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `calculate_attack_damage`(board_unit_id INT, aim_type VARCHAR(45), aim_board_id INT,  OUT attack_success INT,  OUT damage INT,  OUT critical INT)
BEGIN
  DECLARE g_mode INT;
  DECLARE u_id,aim_object_id INT;
  DECLARE base_damage,damage_bonus,critical_bonus INT;
  DECLARE dice_max,chance,critical_chance,dice INT;

  SELECT bu.attack,bu.unit_id,g.mode_id INTO base_damage,u_id,g_mode FROM board_units bu JOIN games g ON (bu.game_id=g.id) WHERE bu.id=board_unit_id LIMIT 1;

  CASE
    WHEN aim_type='unit' THEN SELECT bu.unit_id INTO aim_object_id FROM board_units bu WHERE bu.id=aim_board_id LIMIT 1;
    WHEN aim_type='building' OR aim_type='castle' THEN SELECT bb.building_id INTO aim_object_id FROM board_buildings bb WHERE bb.id=aim_board_id LIMIT 1;
  END CASE;


  SELECT ab.dice_max,ab.chance,ab.critical_chance,ab.damage_bonus,ab.critical_bonus
    INTO dice_max,chance,critical_chance,damage_bonus,critical_bonus
    FROM attack_bonus ab
    WHERE ab.mode_id=g_mode
      AND (ab.unit_id=u_id OR ab.unit_id IS NULL)
      AND (ab.aim_type=aim_type OR ab.aim_type IS NULL)
      AND (ab.aim_id=aim_object_id OR ab.aim_id IS NULL)
    ORDER BY ab.priority DESC
    LIMIT 1;

  SELECT get_random_int_between(1, dice_max) INTO dice FROM DUAL;

  IF dice>=critical_chance THEN 
    SET attack_success=1;
    SET critical=1;
    SET damage=CASE WHEN base_damage+critical_bonus>0 THEN base_damage+critical_bonus ELSE 0 END;
  ELSE
    IF dice>=chance THEN 
      SET attack_success=1;
      SET critical=0;
      SET damage=CASE WHEN base_damage+damage_bonus>0 THEN base_damage+damage_bonus ELSE 0 END;
    ELSE 
      SET attack_success=0;
      SET critical=0;
      SET damage=0;
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `castle_auto_repair` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `castle_auto_repair`(g_id INT, p_num INT)
BEGIN
  DECLARE board_building_id INT;
  DECLARE health_repair INT DEFAULT 1;
  DECLARE delta_health INT;

  SELECT bb.id,bb.max_health-bb.health INTO board_building_id,delta_health FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.game_id=g_id AND bb.player_num=p_num AND b.`type`='castle' LIMIT 1;

  IF(delta_health>0)THEN
    SET health_repair=LEAST(health_repair,delta_health);

    UPDATE board_buildings SET health=health+health_repair WHERE id=board_building_id;
    CALL cmd_building_set_health(g_id,p_num,board_building_id);

    CALL cmd_log_add_independent_message(g_id, p_num, 'building_repair', CONCAT_WS(';', log_building(board_building_id), health_repair));

  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cast_armageddon` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_armageddon`(g_id INT,   p_num INT,   player_deck_id INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE board_building_id INT;
  DECLARE chance INT DEFAULT 1;

  DECLARE done INT DEFAULT 0;
  
  DECLARE cur CURSOR FOR SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id;
  
  DECLARE cur2 CURSOR FOR SELECT bb.id FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.game_id=g_id AND b.`type`<>'castle';
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;


  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_armageddon');
  IF err_code<>0 THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    CALL user_action_begin();

    CALL play_card_actions(g_id,p_num,player_deck_id); 

    CALL cmd_play_video(g_id,p_num,'armageddon',0,0);

    OPEN cur;
    REPEAT
      FETCH cur INTO board_unit_id;
      IF NOT done THEN
        IF get_random_int_between(1, 6) > chance THEN
          CALL magic_kill_unit(board_unit_id,p_num);
        END IF;
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur;

    SET done=0;

    OPEN cur2;
    REPEAT
      FETCH cur2 INTO board_building_id;
      IF NOT done THEN
        IF get_random_int_between(1, 6) > chance THEN
          CALL destroy_building(board_building_id,p_num);
        END IF;
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur2;

    CALL finish_playing_card(g_id,p_num);
    CALL end_cards_phase(g_id,p_num);

    CALL user_action_end();
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cast_berserk` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_berserk`(g_id INT, p_num INT, player_deck_id INT, x INT, y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE bonus INT DEFAULT 2;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_berserk');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;

      IF (unit_feature_check(board_unit_id,'magic_immunity')=0) THEN 
        CALL unit_add_attack(board_unit_id, bonus * get_magic_field_factor(g_id, p_num, x, y));
      ELSE
        CALL cmd_magic_resistance_log(g_id,p_num,board_unit_id);
      END IF;

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cast_fireball` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_fireball`(g_id INT,  p_num INT,  player_deck_id INT,  x INT,  y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE fb_damage INT DEFAULT 1;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_fireball');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      CALL magical_damage(g_id,p_num,x,y,fb_damage);

      INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'magical_attack');

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cast_half_money` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_half_money`(g_id INT,p_num INT,player_deck_id INT)
BEGIN
  DECLARE err_code INT;
  DECLARE p_num_cur INT;

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT p.player_num FROM players p WHERE p.game_id=g_id AND owner<>0 AND gold>0;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_half_money');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    CALL user_action_begin();

    CALL play_card_actions(g_id,p_num,player_deck_id); 


    UPDATE players SET gold=gold/2 WHERE game_id=g_id AND owner<>0 AND gold>0;

    OPEN cur;
    REPEAT
      FETCH cur INTO p_num_cur;
      IF NOT done THEN
        CALL cmd_player_set_gold(g_id,p_num_cur);
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur;


    CALL finish_playing_card(g_id,p_num);
    CALL end_cards_phase(g_id,p_num);

    CALL user_action_end();
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cast_healing` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_healing`(g_id INT,p_num INT,player_deck_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE hp_heal INT DEFAULT 1;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_healing');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      CALL magical_heal(g_id,p_num,x,y,hp_heal);

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cast_horseshoe` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_horseshoe`(g_id INT, p_num INT, player_deck_id INT, x INT, y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE bonus INT DEFAULT 2;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_horseshoe');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;

      IF (unit_feature_check(board_unit_id,'magic_immunity')=0) THEN 
        UPDATE board_units SET moves = 1, moves_left = LEAST(moves_left, 1) WHERE id=board_unit_id;
        CALL unit_feature_set(board_unit_id,'knight',null);
        CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);
        CALL cmd_unit_add_effect(g_id,board_unit_id,'knight');
      ELSE
        CALL cmd_magic_resistance_log(g_id,p_num,board_unit_id);
      END IF;

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cast_iron_skin` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_iron_skin`(g_id INT, p_num INT, player_deck_id INT, x INT, y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE bonus INT DEFAULT 2;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_iron_skin');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;

      IF (unit_feature_check(board_unit_id,'magic_immunity')=0) THEN 
        CALL unit_add_health(board_unit_id, bonus * get_magic_field_factor(g_id, p_num, x, y));
      ELSE
        CALL cmd_magic_resistance_log(g_id,p_num,board_unit_id);
      END IF;

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cast_lightening_max` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_lightening_max`(g_id INT,  p_num INT,  player_deck_id INT,  x INT,  y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE li_damage INT DEFAULT 3;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_lightening_max');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      IF get_random_int_between(1, 6) < 3 THEN
        CALL cmd_miss_game_log(g_id,x,y);
      ELSE
        CALL magical_damage(g_id,p_num,x,y,li_damage);
      END IF;

      INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'magical_attack');

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cast_lightening_min` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_lightening_min`(g_id INT,  p_num INT,  player_deck_id INT,  x INT,  y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE li_damage INT DEFAULT 2;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_lightening_min');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      CALL magical_damage(g_id,p_num,x,y,li_damage);

      INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'magical_attack');

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cast_madness` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_madness`(g_id INT, p_num INT, player_deck_id INT, x INT, y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE shield INT;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_madness');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;
      SELECT bu.shield INTO shield FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

      IF (unit_feature_check(board_unit_id,'magic_immunity')=0) THEN 
        IF shield>0 THEN
          CALL shield_off(board_unit_id);
        ELSE
          CALL make_mad(board_unit_id);
        END IF;
      ELSE
        CALL cmd_magic_resistance_log(g_id,p_num,board_unit_id);
      END IF;

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cast_meteor_shower` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_meteor_shower`(g_id INT,p_num INT,player_deck_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE x1,y1 INT;
  DECLARE meteor_damage INT DEFAULT 2;
  DECLARE meteor_size INT DEFAULT 2;

  DECLARE aim_id INT;
  DECLARE aim_type VARCHAR(45);

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT b.x,b.y,b.`type`,b.ref FROM board b WHERE b.game_id=g_id AND b.`type` IN ('unit','building') AND b.x BETWEEN x AND x+meteor_size-1 AND b.y BETWEEN y AND y+meteor_size-1;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_meteor_shower');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF (x<0 OR x>(20-meteor_size) OR y<0 OR y>(20-meteor_size)) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=23;
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      OPEN cur;
      REPEAT
        FETCH cur INTO x1,y1,aim_type,aim_id;
        IF NOT done THEN
          
          IF((aim_type='unit' AND EXISTS(SELECT bu.id FROM board_units bu WHERE bu.id=aim_id LIMIT 1))
            OR(aim_type='building' AND EXISTS(SELECT bb.id FROM board_buildings bb WHERE bb.id=aim_id LIMIT 1)))THEN
            CALL magical_damage(g_id,p_num,x1,y1,meteor_damage);
          END IF;
        END IF;
      UNTIL done END REPEAT;
      CLOSE cur;

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cast_mind_control` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_mind_control`(g_id INT, p_num INT, player_deck_id INT, x INT, y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE p2_num INT;
  DECLARE shield INT;
  DECLARE npc_gold INT;
  DECLARE log_msg_code VARCHAR(50) CHARSET utf8 DEFAULT 'mind_control';

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_mind_control');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;
      SELECT bu.player_num INTO p2_num FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;
      SELECT bu.shield INTO shield FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

      IF (unit_feature_check(board_unit_id,'magic_immunity')=0) THEN

        IF shield>0 THEN
          CALL shield_off(board_unit_id);
        ELSE

          IF(unit_feature_check(board_unit_id,'under_control')=1)THEN
            CALL unit_feature_remove(board_unit_id,'under_control');
          END IF;

          IF(unit_feature_check(board_unit_id,'madness')=1)THEN
            CALL unit_feature_set(board_unit_id,'madness',p_num);
            CALL make_not_mad(board_unit_id);
          END IF;

          IF(p_num<>p2_num)THEN
            UPDATE board_units SET player_num=p_num,moves_left=0 WHERE id=board_unit_id;
            CALL cmd_unit_set_owner(g_id,p_num,board_unit_id);
            CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

            IF (((SELECT owner FROM players WHERE game_id=g_id AND player_num=p2_num LIMIT 1)<>1)
              AND NOT EXISTS (SELECT id FROM board_units WHERE game_id=g_id AND player_num=p2_num)
              AND NOT EXISTS (SELECT id FROM board_buildings WHERE game_id=g_id AND player_num=p2_num))
            THEN
              SELECT gold INTO npc_gold FROM players WHERE game_id=g_id AND player_num=p2_num LIMIT 1; 
              IF(npc_gold>0)THEN
                UPDATE players SET gold=gold+npc_gold WHERE game_id=g_id AND player_num=p_num;
                CALL cmd_player_set_gold(g_id,p_num);
              END IF;

              DELETE FROM players WHERE game_id=g_id AND player_num=p2_num; 
              CALL cmd_delete_player(g_id,p2_num);
            END IF;

          ELSE
            SET log_msg_code = 'mind_control_own_unit';
          END IF;


          IF EXISTS(SELECT id FROM board_units_features WHERE feature_id=unit_feature_get_id_by_code('under_control') AND param=board_unit_id LIMIT 1)THEN
            CALL zombies_change_player_to_nec(board_unit_id);
          END IF;

          CALL cmd_log_add_message(g_id, p_num, log_msg_code, CONCAT_WS(';', log_unit(board_unit_id), log_player(g_id, p_num)));

        END IF;
      ELSE
        CALL cmd_magic_resistance_log(g_id,p_num,board_unit_id);
      END IF;

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cast_o_d` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_o_d`(g_id INT,  p_num INT,  player_deck_id INT,  x INT,  y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE shield INT;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_o_d');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;
      SELECT bu.shield INTO shield FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

      IF (unit_feature_check(board_unit_id,'magic_immunity')=0) THEN 

        IF shield>0 THEN
          CALL shield_off(board_unit_id);
        ELSE
          IF get_random_int_between(1, 6) = 6 THEN 
            CALL make_mad(board_unit_id);
          ELSE 
            CALL kill_unit(board_unit_id,p_num);
          END IF;
        END IF;
      ELSE
        CALL cmd_magic_resistance_log(g_id,p_num,board_unit_id);
      END IF;

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cast_paralich` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_paralich`(g_id INT,p_num INT,player_deck_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE shield INT;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_paralich');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;
      SELECT bu.shield INTO shield FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

      IF (unit_feature_check(board_unit_id,'magic_immunity')=0) THEN 
        IF shield>0 THEN
          CALL shield_off(board_unit_id);
        ELSE
          CALL unit_feature_set(board_unit_id,'paralich',null);
          CALL cmd_unit_add_effect(g_id,board_unit_id,'paralich');
        END IF;
      ELSE
        CALL cmd_magic_resistance_log(g_id,p_num,board_unit_id);
      END IF;

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cast_polza_main` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_polza_main`(g_id INT,   p_num INT,   player_deck_id INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE err_code INT;
  DECLARE dice INT;
  DECLARE nonfinished_action INT DEFAULT 0;
  DECLARE riching_sum INT DEFAULT 60;
  DECLARE take_cards_qty INT DEFAULT 2;
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'execute_procedure("$cmd_name")';

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_polza_main');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    CALL user_action_begin();

    CALL play_card_actions(g_id,p_num,player_deck_id); 

    SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
    SET dice = get_random_int_between(1, 6);

    CASE dice

      WHEN 1 THEN
        CALL cmd_log_add_message(g_id, p_num, 'polza_repair_and_heal', NULL);
        CALL magic_total_heal_all_units_of_player(g_id, p_num);
        CALL repair_buildings(g_id,p_num);
      WHEN 2 THEN 
      BEGIN
        DECLARE x_appear,y_appear,x_dir,y_dir INT;
        DECLARE size INT;

        CALL cmd_log_add_message(g_id, p_num, 'polza_resurrect', NULL);
        SELECT MIN(g.size) INTO size FROM vw_grave g WHERE g.game_id=g_id;
        IF size IS NOT NULL THEN
          SELECT ap.x,ap.y,ap.direction_into_board_x,ap.direction_into_board_y INTO x_appear,y_appear,x_dir,y_dir FROM appear_points ap WHERE ap.mode_id=mode_id AND ap.player_num=p_num;
          IF NOT EXISTS(SELECT id FROM board WHERE game_id=g_id AND x BETWEEN LEAST(x_appear,x_appear+x_dir*(size-1)) AND GREATEST(x_appear,x_appear+x_dir*(size-1)) AND y BETWEEN LEAST(y_appear,y_appear+y_dir*(size-1)) AND GREATEST(y_appear,y_appear+y_dir*(size-1)) LIMIT 1) THEN
            SET nonfinished_action=1;
          END IF;
        END IF;
      END;

      WHEN 3 THEN 
        CALL cmd_log_add_message(g_id, p_num, 'polza_gold', NULL);
        UPDATE players SET gold=gold+riching_sum WHERE game_id=g_id AND player_num=p_num;
        CALL cmd_player_set_gold(g_id,p_num);

      WHEN 4 THEN 
        CALL cmd_log_add_message(g_id, p_num, 'polza_cards', NULL);
        BEGIN
          DECLARE new_card INT;
          DECLARE first_card_id INT;
          DECLARE player_deck_id INT;

          WHILE take_cards_qty>0 AND EXISTS(SELECT id FROM deck WHERE game_id=g_id LIMIT 1) DO
            SET take_cards_qty=take_cards_qty-1;

            SELECT MIN(id) INTO first_card_id FROM deck WHERE game_id=g_id;
            SELECT card_id INTO new_card FROM deck WHERE game_id=g_id AND id=first_card_id;
            INSERT INTO player_deck (game_id,player_num,card_id) VALUES (g_id,p_num,new_card);
            SET player_deck_id=@@last_insert_id;
            DELETE FROM deck WHERE game_id=g_id AND id=first_card_id;

            CALL cmd_add_card(g_id,p_num,player_deck_id);

            CALL cmd_log_add_message(g_id, p_num, 'new_card', new_card);
            
            IF (take_cards_qty>0) AND NOT EXISTS (SELECT id FROM deck WHERE game_id=g_id LIMIT 1) THEN
              CALL cmd_log_add_message(g_id, p_num, 'no_more_cards', NULL);
            END IF;
          END WHILE;
        END;

      WHEN 5 THEN
        CALL cmd_log_add_message(g_id, p_num, 'polza_move_from_zone', NULL);
        IF EXISTS(SELECT id FROM board_units WHERE game_id=g_id LIMIT 1) THEN
          SET nonfinished_action=2;
        END IF;

      WHEN 6 THEN 
        CALL cmd_log_add_message(g_id, p_num, 'polza_steal_move_building', NULL);
        IF EXISTS(SELECT bb.id FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.game_id=g_id AND bb.player_num<>p_num AND b.`type`<>'castle' AND building_feature_check(bb.id,'not_movable')=0 LIMIT 1) THEN
          SET nonfinished_action=3;
        END IF;
    END CASE;

    IF(nonfinished_action=0)THEN
      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);
    ELSE
      UPDATE active_players SET nonfinished_action_id=nonfinished_action WHERE game_id=g_id AND player_num=p_num;
      SET cmd=REPLACE(cmd,'$cmd_name',(SELECT command_procedure FROM nonfinished_actions_dictionary WHERE id=nonfinished_action LIMIT 1));
      INSERT INTO command (game_id,player_num,command,hidden_flag) VALUES (g_id,p_num,cmd,1);
    END IF;

    CALL user_action_end();
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cast_polza_move_building` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_polza_move_building`(g_id INT, p_num INT, b_x INT, b_y INT, x INT, y INT, rot INT, flp INT)
BEGIN
  DECLARE nonfinished_action INT DEFAULT 3;
  DECLARE board_building_id INT;
  DECLARE p2_num INT;
  DECLARE building_id INT;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;
  ELSE
    IF NOT nonfinished_action=(SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=24;
    ELSE
      SELECT b.ref INTO board_building_id FROM board b WHERE b.game_id=g_id AND b.`type` IN ('building','obstacle') AND b.x=b_x AND b.y=b_y LIMIT 1;
      IF board_building_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=26;
      ELSE
        SELECT bb.player_num INTO p2_num FROM board_buildings bb WHERE bb.id=board_building_id LIMIT 1;
        IF p2_num=p_num THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=27;
        ELSE
          IF building_feature_check(board_building_id,'not_movable')=1 THEN
            SELECT bb.building_id INTO building_id FROM board_buildings bb WHERE bb.id=board_building_id;
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=43;
          ELSE
            CALL user_action_begin();


            UPDATE board SET ref=0 WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=board_building_id;

            CALL place_building_on_board(board_building_id,x,y,rot,flp);

            IF NOT EXISTS(SELECT id FROM board WHERE game_id=g_id AND `type`<>'unit' AND ref=board_building_id) THEN 
              UPDATE board SET ref=board_building_id WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0;
              SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=12;
            ELSE
            
              DELETE FROM board WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0; 

              UPDATE board_buildings SET player_num=p_num,rotation=rot,flip=flp WHERE id=board_building_id;

              CALL count_income(board_building_id);

              CALL cmd_move_building(g_id,p_num,b_x,b_y,board_building_id);
              CALL cmd_building_set_owner(g_id,p_num,board_building_id);


              UPDATE active_players SET nonfinished_action_id=0 WHERE game_id=g_id AND player_num=p_num;

              CALL finish_playing_card(g_id,p_num);
              CALL end_cards_phase(g_id,p_num);

              CALL user_action_end();
            END IF;
          END IF;
        END IF;
      END IF;
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cast_polza_resurrect` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_polza_resurrect`(g_id INT, p_num INT, grave_id INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE nonfinished_action INT DEFAULT 1;
  DECLARE x_appear,y_appear,x_dir,y_dir INT;
  DECLARE size INT;
  DECLARE u_id INT;
  DECLARE dead_card_id INT;

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;
  ELSE
    IF NOT nonfinished_action=(SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=24;
    ELSE
      IF NOT EXISTS(SELECT id FROM graves WHERE game_id=g_id AND id=grave_id LIMIT 1) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=8;
      ELSE
          CALL user_action_begin();

          SELECT g.card_id INTO dead_card_id FROM graves g WHERE id=grave_id;
          SELECT ap.x,ap.y,ap.direction_into_board_x,ap.direction_into_board_y INTO x_appear,y_appear,x_dir,y_dir FROM appear_points ap WHERE ap.mode_id=mode_id AND ap.player_num=p_num;
          SELECT u.id,u.size INTO u_id,size FROM cards c JOIN units u ON c.ref=u.id WHERE c.id=dead_card_id LIMIT 1;
          IF EXISTS(SELECT id FROM board WHERE game_id=g_id AND x BETWEEN LEAST(x_appear,x_appear+x_dir*(size-1)) AND GREATEST(x_appear,x_appear+x_dir*(size-1)) AND y BETWEEN LEAST(y_appear,y_appear+y_dir*(size-1)) AND GREATEST(y_appear,y_appear+y_dir*(size-1)) LIMIT 1) THEN
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=9;
          ELSE

            CALL resurrect(g_id,p_num,grave_id);
            CALL cmd_resurrect_by_card_log(g_id,p_num,dead_card_id);

            UPDATE active_players SET nonfinished_action_id=0 WHERE game_id=g_id AND player_num=p_num;

            CALL finish_playing_card(g_id,p_num);
            CALL end_cards_phase(g_id,p_num);

            CALL user_action_end();
          END IF;
      END IF;
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cast_polza_units_from_zone` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_polza_units_from_zone`(g_id INT, p_num INT, zone INT)
BEGIN
  DECLARE nonfinished_action INT DEFAULT 2;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;
  ELSE
    IF NOT nonfinished_action=(SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=24;
    ELSE
      IF zone NOT IN(0,1,2,3) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=25;
      ELSE
            CALL user_action_begin();

            CALL units_from_zone(g_id, p_num, zone);

            UPDATE active_players SET nonfinished_action_id=0 WHERE game_id=g_id AND player_num=p_num;

            CALL finish_playing_card(g_id,p_num);
            CALL end_cards_phase(g_id,p_num);

            CALL user_action_end();
      END IF;
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cast_pooring` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_pooring`(g_id INT, p_num INT, player_deck_id INT, p2_num INT)
BEGIN
  DECLARE err_code INT;
  DECLARE pooring_sum INT DEFAULT 50;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_pooring');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT id FROM players WHERE game_id=g_id AND player_num=p2_num) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=13;
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); 


      UPDATE players SET gold=CASE WHEN gold<pooring_sum THEN 0 ELSE gold-pooring_sum END WHERE game_id=g_id AND player_num=p2_num;
      CALL cmd_player_set_gold(g_id,p2_num);

      CALL cmd_log_add_message(g_id, p_num, 'player_loses_gold', CONCAT_WS(';', log_player(g_id, p2_num), pooring_sum));

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cast_repair_buildings` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_repair_buildings`(g_id INT,p_num INT,player_deck_id INT)
BEGIN
  DECLARE err_code INT;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_repair_buildings');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    CALL user_action_begin();

    CALL play_card_actions(g_id,p_num,player_deck_id); 

    CALL repair_buildings(g_id,p_num);

    CALL finish_playing_card(g_id,p_num);
    CALL end_cards_phase(g_id,p_num);

    CALL user_action_end();
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cast_riching` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_riching`(g_id INT,p_num INT,player_deck_id INT)
BEGIN
  DECLARE err_code INT;
  DECLARE riching_sum INT DEFAULT 50;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_riching');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    CALL user_action_begin();

    CALL play_card_actions(g_id,p_num,player_deck_id); 


    UPDATE players SET gold=gold+riching_sum WHERE game_id=g_id AND player_num=p_num;
    CALL cmd_player_set_gold(g_id,p_num);

    CALL finish_playing_card(g_id,p_num);
    CALL end_cards_phase(g_id,p_num);

    CALL user_action_end();
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cast_shield` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_shield`(g_id INT,p_num INT,player_deck_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_shield');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;

      CALL magical_shield_on(g_id,p_num,x,y);

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cast_show_cards` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_show_cards`(g_id INT, p_num INT, player_deck_id INT, p2_num INT)
BEGIN
  DECLARE err_code INT;
  DECLARE card_id INT;

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT pd.card_id FROM player_deck pd WHERE pd.game_id=g_id AND pd.player_num=p2_num;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;


  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_show_cards');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT id FROM players WHERE game_id=g_id AND player_num=p2_num) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=13;
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      CALL cmd_log_add_message(g_id, p_num, 'players_cards', log_player(g_id, p2_num));

      OPEN cur;
      REPEAT
        FETCH cur INTO card_id;
        IF NOT done THEN
          CALL cmd_log_add_message(g_id, p_num, 'card_name', card_id);
        END IF;
      UNTIL done END REPEAT;
      CLOSE cur;

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cast_speeding` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_speeding`(g_id INT, p_num INT, player_deck_id INT, x INT, y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE speed_bonus INT DEFAULT 2;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_speeding');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;

      IF (unit_feature_check(board_unit_id,'magic_immunity')=0) THEN 
        CALL unit_add_moves(board_unit_id, speed_bonus * get_magic_field_factor(g_id, p_num, x, y));
      ELSE
        CALL cmd_magic_resistance_log(g_id,p_num,board_unit_id);
      END IF;

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cast_telekinesis` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_telekinesis`(g_id INT,  p_num INT,  player_deck_id INT,  p2_num INT)
BEGIN
  DECLARE err_code INT;
  DECLARE rand_card INT;
  DECLARE big_dice INT;
  DECLARE stolen_card_id INT;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_telekinesis');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT id FROM players WHERE game_id=g_id AND player_num=p2_num) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=13;
    ELSE
      IF NOT EXISTS(SELECT id FROM player_deck WHERE game_id=g_id AND player_num=p2_num LIMIT 1) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=22;
      ELSE
        CALL user_action_begin();

        CALL play_card_actions(g_id,p_num,player_deck_id); 

        CREATE TEMPORARY TABLE pl_cards (id_rand INT AUTO_INCREMENT PRIMARY KEY)AUTO_INCREMENT=1 SELECT id AS `pd_id` FROM player_deck WHERE game_id=g_id AND player_num=p2_num;
        SELECT get_random_int_between(1, MAX(id_rand)) INTO big_dice FROM pl_cards;
        SELECT pd_id INTO rand_card FROM pl_cards WHERE id_rand=big_dice LIMIT 1;
        DROP TEMPORARY TABLE pl_cards;

        SELECT card_id INTO stolen_card_id FROM player_deck WHERE id=rand_card;
        UPDATE player_deck SET player_num=p_num WHERE id=rand_card;
        CALL cmd_remove_card(g_id,p2_num,rand_card);
        CALL cmd_add_card(g_id,p_num,rand_card);

        CALL cmd_log_add_message_hidden(g_id, p_num, 'new_card', stolen_card_id);
        CALL cmd_log_add_message_hidden(g_id, p2_num, 'card_stolen', stolen_card_id);

        CALL finish_playing_card(g_id,p_num);
        CALL end_cards_phase(g_id,p_num);

        CALL user_action_end();
      END IF;
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cast_teleport` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_teleport`(g_id INT,p_num INT,player_deck_id INT,x INT,y INT, x2 INT, y2 INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE u_id INT;
  DECLARE size INT;
  DECLARE target INT;
  DECLARE binded_unit_id INT;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_teleport');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;
      SELECT bu.unit_id,u.size INTO u_id,size FROM board_units bu JOIN units u ON (bu.unit_id=u.id) WHERE bu.id=board_unit_id LIMIT 1;

      IF EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x BETWEEN x2 AND x2+size-1 AND b.y BETWEEN y2 AND y2+size-1 AND NOT(b.`type`='unit' AND b.ref=board_unit_id) LIMIT 1) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=12;
      ELSE
        CALL user_action_begin();

        CALL play_card_actions(g_id,p_num,player_deck_id); 

        IF (unit_feature_check(board_unit_id,'magic_immunity')=0) THEN 

          IF (unit_feature_get_param(board_unit_id,'bind_target') IS NOT NULL) THEN 
            CALL unit_feature_remove(board_unit_id,'bind_target');
          END IF; 

          CALL move_unit(board_unit_id,x2,y2);
          UPDATE board_units SET moves_left=0 WHERE id=board_unit_id;
          CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

          
          DELETE FROM board_units_features WHERE feature_id=unit_feature_get_id_by_code('bind_target') AND param=board_unit_id;

        ELSE
          CALL cmd_magic_resistance_log(g_id,p_num,board_unit_id);
        END IF;

        CALL finish_playing_card(g_id,p_num);
        CALL end_cards_phase(g_id,p_num);

        CALL user_action_end();
      END IF;
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cast_unit_upgrade_all` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_unit_upgrade_all`(g_id INT, p_num INT, player_deck_id INT, x INT, y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE speed_bonus INT DEFAULT 1;
  DECLARE health_bonus INT DEFAULT 1;
  DECLARE attack_bonus INT DEFAULT 1;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_unit_upgrade_all');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;

      IF (unit_feature_check(board_unit_id,'magic_immunity')=0) THEN 
        CALL unit_add_moves(board_unit_id, speed_bonus * get_magic_field_factor(g_id, p_num, x, y));
        CALL unit_add_health(board_unit_id, health_bonus * get_magic_field_factor(g_id, p_num, x, y));
        CALL unit_add_attack(board_unit_id, attack_bonus * get_magic_field_factor(g_id, p_num, x, y));
      ELSE
        CALL cmd_magic_resistance_log(g_id,p_num,board_unit_id);
      END IF;

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cast_unit_upgrade_random` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_unit_upgrade_random`(g_id INT, p_num INT, player_deck_id INT, x INT, y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE dice INT;
  DECLARE speed_bonus INT DEFAULT 3;
  DECLARE health_bonus INT DEFAULT 3;
  DECLARE attack_bonus INT DEFAULT 3;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_unit_upgrade_random');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;

      IF (unit_feature_check(board_unit_id,'magic_immunity')=0) THEN 
        SET dice = get_random_int_between(1, 3);
        IF dice=1 THEN
          CALL unit_add_moves(board_unit_id, speed_bonus * get_magic_field_factor(g_id, p_num, x, y));
        END IF;
        IF dice=2 THEN
          CALL unit_add_health(board_unit_id, health_bonus * get_magic_field_factor(g_id, p_num, x, y));
        END IF;
        IF dice=3 THEN
          CALL unit_add_attack(board_unit_id, attack_bonus * get_magic_field_factor(g_id, p_num, x, y));
        END IF;
      ELSE
        CALL cmd_magic_resistance_log(g_id,p_num,board_unit_id);
      END IF;

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cast_vampire` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_vampire`(g_id INT,   p_num INT,   player_deck_id INT,   x INT,   y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE mode_id INT;
  DECLARE vamp_ui_code VARCHAR(45) CHARSET utf8 DEFAULT 'vampire'; 
  DECLARE vamp_u_id INT;
  DECLARE vamp_owner INT DEFAULT 4;
  DECLARE vamp_move_order INT;
  DECLARE team INT;
  DECLARE new_player INT;
  DECLARE vamp_name VARCHAR(45) CHARSET utf8;
  DECLARE new_unit_id INT;

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_vampire');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF (quart(x,y)<>p_num) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=35;
    ELSE
      IF EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y LIMIT 1) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=9;
      ELSE

        CALL user_action_begin();

        CALL play_card_actions(g_id,p_num,player_deck_id); 

        SET team = get_new_team_number(g_id);
        SELECT CASE WHEN MAX(p.player_num)<10 THEN 10 ELSE MAX(p.player_num)+1 END INTO new_player FROM players p WHERE p.game_id=g_id;

        SELECT vu.id INTO vamp_u_id FROM vw_mode_units vu WHERE vu.mode_id=mode_id AND vu.ui_code=vamp_ui_code;
        SET vamp_name = CONCAT('{', vamp_u_id, '}');
        SET vamp_move_order = get_move_order_for_new_npc(g_id, p_num);
        
        UPDATE players SET move_order = move_order + 1 WHERE game_id = g_id AND move_order >= vamp_move_order;
        INSERT INTO players(game_id,player_num,name,gold,owner,team,move_order,language_id) VALUES(g_id,new_player,vamp_name,0,vamp_owner,team,vamp_move_order,get_player_language_id(g_id,p_num));
        CALL cmd_add_player(g_id,new_player);

        INSERT INTO board_units(game_id,player_num,unit_id) VALUES(g_id,new_player,vamp_u_id);
        SET new_unit_id=@@last_insert_id;
        INSERT INTO board_units_features(board_unit_id,feature_id,param) SELECT new_unit_id,ufu.feature_id,ufu.param FROM unit_default_features ufu WHERE ufu.unit_id=vamp_u_id;

        INSERT INTO board(game_id,x,y,`type`,ref) VALUES (g_id,x,y,'unit',new_unit_id);

        CALL cmd_add_unit_by_id(g_id,new_player,new_unit_id);
        
        CALL cmd_log_add_message(g_id, p_num, 'unit_appears_in_cell', CONCAT_WS(';', log_unit(new_unit_id), log_cell(x,y)));

        CALL finish_playing_card(g_id,p_num);
        CALL end_cards_phase(g_id,p_num);

        CALL user_action_end();
      END IF;
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cast_vred_destroy_building` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_vred_destroy_building`(g_id INT, p_num INT, x INT, y INT)
BEGIN
  DECLARE nonfinished_action INT DEFAULT 6;
  DECLARE board_building_id INT;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;
  ELSE
    IF NOT nonfinished_action=(SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=24;
    ELSE
      SELECT b.ref INTO board_building_id FROM board b WHERE b.game_id=g_id AND b.`type` IN ('building','obstacle') AND b.x=x AND b.y=y LIMIT 1;
      IF board_building_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=26;
      ELSE
        CALL user_action_begin();

        CALL destroy_building(board_building_id,p_num);

        UPDATE active_players SET nonfinished_action_id=0 WHERE game_id=g_id AND player_num=p_num;

        CALL finish_playing_card(g_id,p_num);
        CALL end_cards_phase(g_id,p_num);

        CALL user_action_end();
      END IF;
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cast_vred_kill_unit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_vred_kill_unit`(g_id INT, p_num INT, x INT, y INT)
BEGIN
  DECLARE nonfinished_action INT DEFAULT 5;
  DECLARE board_unit_id INT;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;
  ELSE
    IF NOT nonfinished_action=(SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=24;
    ELSE
      IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
      ELSE
        CALL user_action_begin();

        SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;

        CALL magic_kill_unit(board_unit_id,p_num);

        UPDATE active_players SET nonfinished_action_id=0 WHERE game_id=g_id AND player_num=p_num;

        CALL finish_playing_card(g_id,p_num);
        CALL end_cards_phase(g_id,p_num);

        CALL user_action_end();
      END IF;
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cast_vred_main` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_vred_main`(g_id INT,   p_num INT,   player_deck_id INT)
BEGIN
  DECLARE err_code INT;
  DECLARE dice INT;
  DECLARE nonfinished_action INT DEFAULT 0;
  DECLARE pooring_sum INT DEFAULT 60;
  DECLARE take_cards_qty INT DEFAULT 1;
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'execute_procedure("$cmd_name")';

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_vred_main');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    CALL user_action_begin();

    CALL play_card_actions(g_id,p_num,player_deck_id); 

    SET dice = get_random_int_between(1, 6);

    CASE dice

      WHEN 1 THEN 
        CALL cmd_log_add_message(g_id, p_num, 'vred_gold', NULL);
        SET nonfinished_action=4;

      WHEN 2 THEN 
        CALL cmd_log_add_message(g_id, p_num, 'vred_kill', NULL);
        IF EXISTS(SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id AND unit_feature_check(bu.id,'magic_immunity')=0 LIMIT 1) THEN
          SET nonfinished_action=5;
        END IF;

      WHEN 3 THEN 
        CALL cmd_log_add_message(g_id, p_num, 'vred_destroy_building', NULL);
        IF EXISTS(SELECT bb.id FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.game_id=g_id AND b.`type`<>'castle' LIMIT 1) THEN
          SET nonfinished_action=6;
        END IF;

      WHEN 4 THEN 
      BEGIN
        DECLARE zone INT;

        CALL cmd_log_add_message(g_id, p_num, 'vred_move_units_to_random_zone', NULL);
        SET zone = get_random_int_between(0, 3);
        CALL units_to_zone(g_id, p_num, zone);
      END;

      WHEN 5 THEN 
      BEGIN
        CALL cmd_log_add_message(g_id, p_num, 'vred_player_takes_card_from_everyone', NULL);
        CALL vred_player_takes_card_from_everyone(g_id,p_num);
      END;

      WHEN 6 THEN 
        CALL cmd_log_add_message(g_id, p_num, 'vred_move_building', NULL);
        IF EXISTS(SELECT bb.id FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.game_id=g_id AND bb.player_num<>p_num AND b.`type`<>'castle' AND building_feature_check(bb.id,'not_movable')=0 LIMIT 1) THEN
          SET nonfinished_action=7;
        END IF;

    END CASE;

    IF(nonfinished_action=0)THEN
      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);
    ELSE
      UPDATE active_players SET nonfinished_action_id=nonfinished_action WHERE game_id=g_id AND player_num=p_num;
      SET cmd=REPLACE(cmd,'$cmd_name',(SELECT command_procedure FROM nonfinished_actions_dictionary WHERE id=nonfinished_action LIMIT 1));
      INSERT INTO command (game_id,player_num,command,hidden_flag) VALUES (g_id,p_num,cmd,1);
    END IF;

    CALL user_action_end();
  END IF;


END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cast_vred_move_building` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_vred_move_building`(g_id INT, p_num INT, b_x INT, b_y INT, x INT, y INT, rot INT, flp INT)
BEGIN
  DECLARE nonfinished_action INT DEFAULT 7;
  DECLARE board_building_id INT;
  DECLARE p2_num INT;
  DECLARE building_id INT;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;
  ELSE
    IF NOT nonfinished_action=(SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=24;
    ELSE
      SELECT b.ref INTO board_building_id FROM board b WHERE b.game_id=g_id AND b.`type` IN ('building','obstacle') AND b.x=b_x AND b.y=b_y LIMIT 1;
      IF board_building_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=26;
      ELSE
        SELECT bb.player_num INTO p2_num FROM board_buildings bb WHERE bb.id=board_building_id LIMIT 1;
        IF p2_num=p_num THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=27;
        ELSE
          IF building_feature_check(board_building_id,'not_movable')=1 THEN
            SELECT bb.building_id INTO building_id FROM board_buildings bb WHERE bb.id=board_building_id;
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=43;
          ELSE
            CALL user_action_begin();


            UPDATE board SET ref=0 WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=board_building_id;

            CALL place_building_on_board(board_building_id,x,y,rot,flp);

            IF NOT EXISTS(SELECT id FROM board WHERE game_id=g_id AND `type`<>'unit' AND ref=board_building_id) THEN 
              UPDATE board SET ref=board_building_id WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0;
              SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=12;
            ELSE
            
              DELETE FROM board WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0; 

              UPDATE board_buildings SET rotation=rot,flip=flp WHERE id=board_building_id;

              CALL count_income(board_building_id);

              CALL cmd_move_building(g_id,p_num,b_x,b_y,board_building_id);

              UPDATE active_players SET nonfinished_action_id=0 WHERE game_id=g_id AND player_num=p_num;

              CALL finish_playing_card(g_id,p_num);
              CALL end_cards_phase(g_id,p_num);

              CALL user_action_end();
            END IF;
          END IF;
        END IF;
      END IF;
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cast_vred_pooring` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_vred_pooring`(g_id INT, p_num INT, p2_num INT)
BEGIN
  DECLARE nonfinished_action INT DEFAULT 4;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;
  ELSE
    IF NOT nonfinished_action=(SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=24;
    ELSE
      IF NOT EXISTS(SELECT id FROM players WHERE game_id=g_id AND player_num=p2_num AND owner<>0) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=13;
      ELSE
        CALL user_action_begin();

        CALL vred_pooring(g_id,p2_num);

        UPDATE active_players SET nonfinished_action_id=0 WHERE game_id=g_id AND player_num=p_num;

        CALL finish_playing_card(g_id,p_num);
        CALL end_cards_phase(g_id,p_num);

        CALL user_action_end();
      END IF;
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cmd_add_card` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_add_card`(g_id INT,p_num INT,player_deck_id INT)
BEGIN
  DECLARE new_card_id INT;
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'add_card($player_deck_id,$card_id)';

  SELECT card_id INTO new_card_id FROM player_deck WHERE id=player_deck_id;

  SET cmd=REPLACE(cmd,'$player_deck_id',player_deck_id);
  SET cmd=REPLACE(cmd,'$card_id',new_card_id);
  INSERT INTO command (game_id,player_num,command,hidden_flag) VALUES (g_id,p_num,cmd,1);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cmd_add_player` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_add_player`(g_id INT,p_num INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'add_player($p_num,"$p_name",$p_gold,$p_owner,$p_team)';
  DECLARE p_name VARCHAR(45) CHARSET utf8;
  DECLARE p_gold INT;
  DECLARE p_owner INT;
  DECLARE p_team INT;

  SELECT name,gold,owner,team INTO p_name,p_gold,p_owner,p_team FROM players WHERE game_id=g_id AND player_num=p_num LIMIT 1;
  SET cmd=REPLACE(cmd,'$p_num',p_num);
  SET cmd=REPLACE(cmd,'$p_name',p_name);
  SET cmd=REPLACE(cmd,'$p_gold',p_gold);
  SET cmd=REPLACE(cmd,'$p_owner',p_owner);
  SET cmd=REPLACE(cmd,'$p_team',p_team);
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cmd_add_spectator` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_add_spectator`(g_id INT,p_num INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'add_spectator($p_num,"$name")';

  SET cmd=REPLACE(cmd,'$p_num',p_num);
  SET cmd=REPLACE(cmd,'$name',(SELECT name FROM players WHERE game_id=g_id AND player_num=p_num));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cmd_add_to_grave` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_add_to_grave`(g_id INT,p_num INT,grave_id INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'add_to_grave($grave_id,$dead_card_id,$x,$y,$size)';

  SET cmd=REPLACE(cmd,'$grave_id',grave_id);
  SET cmd=REPLACE(cmd,'$dead_card_id,$x,$y,$size',(SELECT CONCAT(g.card_id,',',g.x,',',g.y,',',g.size) FROM vw_grave g WHERE g.game_id=g_id AND g.grave_id=grave_id LIMIT 1));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cmd_add_unit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_add_unit`(g_id INT,p_num INT,board_unit_id INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'add_unit($board_unit_id,$p_num,$x,$y,$card_id)';
  DECLARE x,y INT;

  SELECT MIN(b.x),MIN(b.y) INTO x,y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=board_unit_id;
  SET cmd=REPLACE(cmd,'$board_unit_id',board_unit_id);
  SET cmd=REPLACE(cmd,'$p_num',p_num);
  SET cmd=REPLACE(cmd,'$x',x);
  SET cmd=REPLACE(cmd,'$y',y);
  SET cmd=REPLACE(cmd,'$card_id',(SELECT card_id FROM board_units WHERE id=board_unit_id LIMIT 1));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cmd_add_unit_by_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_add_unit_by_id`(g_id INT,p_num INT,board_unit_id INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'add_unit_by_id($board_unit_id,$p_num,$x,$y,$unit_id)';
  DECLARE x,y INT;

  SELECT MIN(b.x),MIN(b.y) INTO x,y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=board_unit_id;
  SET cmd=REPLACE(cmd,'$board_unit_id',board_unit_id);
  SET cmd=REPLACE(cmd,'$p_num',p_num);
  SET cmd=REPLACE(cmd,'$x',x);
  SET cmd=REPLACE(cmd,'$y',y);
  SET cmd=REPLACE(cmd,'$unit_id',(SELECT unit_id FROM board_units WHERE id=board_unit_id LIMIT 1));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cmd_building_set_health` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_building_set_health`(g_id INT,p_num INT,board_building_id INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'building_set_health($x,$y,$health)';
  DECLARE x,y INT;

  SELECT b.x,b.y INTO x,y FROM board b WHERE b.game_id=g_id AND b.`type`<>'unit' AND b.ref=board_building_id LIMIT 1;
  SET cmd=REPLACE(cmd,'$x',x);
  SET cmd=REPLACE(cmd,'$y',y);
  SET cmd=REPLACE(cmd,'$health',(SELECT health FROM board_buildings WHERE id=board_building_id LIMIT 1));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cmd_building_set_owner` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_building_set_owner`(g_id INT,p_num INT,board_building_id INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'building_set_owner($x,$y,$p_num)';
  DECLARE x,y INT;

  SELECT b.x,b.y INTO x,y FROM board b WHERE b.game_id=g_id AND b.`type`<>'unit' AND b.ref=board_building_id LIMIT 1;
  SET cmd=REPLACE(cmd,'$x',x);
  SET cmd=REPLACE(cmd,'$y',y);
  SET cmd=REPLACE(cmd,'$p_num',(SELECT player_num FROM board_buildings WHERE id=board_building_id LIMIT 1));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cmd_delete_player` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_delete_player`(g_id INT,p_num INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'delete_player($p_num)';

  SET cmd=REPLACE(cmd,'$p_num',p_num);
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cmd_destroy_building` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_destroy_building`(g_id INT,p_num INT,board_building_id INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'destroy_building($x,$y)';
  DECLARE x,y INT;

  SELECT b.x,b.y INTO x,y FROM board b WHERE b.game_id=g_id AND b.`type`<>'unit' AND b.ref=board_building_id LIMIT 1;
  SET cmd=REPLACE(cmd,'$x',x);
  SET cmd=REPLACE(cmd,'$y',y);
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cmd_end_game` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_end_game`(g_id INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'end_game()';
  DECLARE p_num INT;

  SELECT a.player_num INTO p_num FROM active_players a WHERE a.game_id=g_id;
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cmd_kill_unit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_kill_unit`(g_id INT,p_num INT,board_unit_id INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'kill_unit($x,$y)';
  DECLARE x,y INT;

  SELECT b.x,b.y INTO x,y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=board_unit_id LIMIT 1;
  SET cmd=REPLACE(cmd,'$x',x);
  SET cmd=REPLACE(cmd,'$y',y);
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cmd_log_add_container` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_log_add_container`(g_id INT, p_num INT, log_msg_code VARCHAR(50) CHARSET utf8, params VARCHAR(900) CHARSET utf8)
BEGIN
  CALL cmd_log_general_message(g_id, p_num, p_num, 'log_add_container', log_msg_code, params, 0);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cmd_log_add_independent_message` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_log_add_independent_message`(g_id INT, p_num INT, log_msg_code VARCHAR(50) CHARSET utf8, params VARCHAR(900) CHARSET utf8)
BEGIN
  CALL cmd_log_general_message(g_id, p_num, p_num, 'log_add_independent_message', log_msg_code, params, 0);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cmd_log_add_independent_message_hidden` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_log_add_independent_message_hidden`(g_id INT, p_num INT, log_msg_code VARCHAR(50) CHARSET utf8, params VARCHAR(900) CHARSET utf8)
BEGIN
  CALL cmd_log_general_message(g_id, p_num, p_num, 'log_add_independent_message', log_msg_code, params, 1);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cmd_log_add_message` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_log_add_message`(g_id INT, p_num INT, log_msg_code VARCHAR(50) CHARSET utf8, params VARCHAR(900) CHARSET utf8)
BEGIN
  CALL cmd_log_general_message(g_id, p_num, NULL, 'log_add_message', log_msg_code, params, 0);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cmd_log_add_message_hidden` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_log_add_message_hidden`(g_id INT, p_num INT, log_msg_code VARCHAR(50) CHARSET utf8, params VARCHAR(900) CHARSET utf8)
BEGIN
  CALL cmd_log_general_message(g_id, p_num, NULL, 'log_add_message', log_msg_code, params, 1);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cmd_log_general_message` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_log_general_message`(g_id INT, p_num INT, p2_num INT, log_msg_type VARCHAR(50) CHARSET utf8, log_msg_code VARCHAR(50) CHARSET utf8, params VARCHAR(900) CHARSET utf8, hidden_flg INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8;
  SET cmd = CONCAT(log_msg_type, '(', IFNULL(CONCAT(p2_num, ','), ''), '''', log_msg_code, ''',''', IFNULL(params, ''), ''')');
  INSERT INTO command (game_id, player_num, command, hidden_flag) VALUES (g_id, p_num, cmd, hidden_flg);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cmd_magic_resistance_log` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_magic_resistance_log`(g_id INT, p_num INT,  board_unit_id INT)
BEGIN
  IF((SELECT current_procedure FROM active_players WHERE game_id=g_id LIMIT 1)='end_turn')THEN
    CALL cmd_log_add_independent_message(g_id, p_num, 'unit_magic_resistance', log_unit(board_unit_id));
  ELSE
    CALL cmd_log_add_message(g_id, p_num, 'unit_magic_resistance', log_unit(board_unit_id));
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cmd_mechanical_log` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_mechanical_log`(g_id INT, p_num INT,  board_unit_id INT)
BEGIN
  IF((SELECT current_procedure FROM active_players WHERE game_id=g_id LIMIT 1)='end_turn')THEN
    CALL cmd_log_add_independent_message(g_id, p_num, 'unit_mechanical', log_unit(board_unit_id));
  ELSE
    CALL cmd_log_add_message(g_id, p_num, 'unit_mechanical', log_unit(board_unit_id));
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cmd_miss_game_log` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_miss_game_log`(g_id INT, x INT, y INT)
BEGIN
  DECLARE obj_type VARCHAR(45);
  DECLARE obj_id INT;
  DECLARE p_num INT;

  SELECT b.`type`,b.ref INTO obj_type,obj_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y LIMIT 1;
  SELECT player_num INTO p_num FROM active_players WHERE game_id=g_id LIMIT 1;

  IF (obj_type='unit') THEN
    CALL cmd_log_add_message(g_id, p_num, 'miss_unit', log_unit(obj_id));
  ELSE
    CALL cmd_log_add_message(g_id, p_num, 'miss_building', log_building(obj_id));
  END IF;

  INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'miss_attack');

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cmd_move_building` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_move_building`(g_id INT,p_num INT,old_x INT,old_y INT,board_building_id INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'move_building($old_x,$old_y,$new_x,$new_y,$rotation,$flip,$income)';
  DECLARE new_x,new_y INT;
  DECLARE rotation INT;
  DECLARE flip INT;
  DECLARE income INT;

  SELECT MIN(b.x),MIN(b.y) INTO new_x,new_y FROM board b WHERE b.game_id=g_id AND b.`type`<>'unit' AND b.ref=board_building_id;
  SELECT bb.rotation,bb.flip,bb.income INTO rotation,flip,income FROM board_buildings bb WHERE bb.id=board_building_id LIMIT 1;
  SET cmd=REPLACE(cmd,'$old_x',old_x);
  SET cmd=REPLACE(cmd,'$old_y',old_y);
  SET cmd=REPLACE(cmd,'$new_x',new_x);
  SET cmd=REPLACE(cmd,'$new_y',new_y);
  SET cmd=REPLACE(cmd,'$rotation',rotation);
  SET cmd=REPLACE(cmd,'$flip',flip);
  SET cmd=REPLACE(cmd,'$income',income);
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cmd_move_unit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_move_unit`(g_id INT,p_num INT,x1 INT,y1 INT,x2 INT,y2 INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'move_unit($x1,$y1,$x2,$y2)';

  SET cmd=REPLACE(cmd,'$x1',x1);
  SET cmd=REPLACE(cmd,'$y1',y1);
  SET cmd=REPLACE(cmd,'$x2',x2);
  SET cmd=REPLACE(cmd,'$y2',y2);
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cmd_player_set_gold` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_player_set_gold`(g_id INT,p_num INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'player_set_gold($p_num,$amt)';

  SET cmd=REPLACE(cmd,'$p_num',p_num);
  SET cmd=REPLACE(cmd,'$amt',(SELECT gold FROM players WHERE game_id=g_id AND player_num=p_num LIMIT 1));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cmd_play_video` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_play_video`(g_id INT, p_num INT, video_code VARCHAR(45), hidden INT, looping INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'play_video("$code","$filename",$looping)';

  SET cmd=REPLACE(cmd,'$code',(SELECT v.code FROM videos v WHERE v.code=video_code LIMIT 1));
  SET cmd=REPLACE(cmd,'$filename',(SELECT v.filename FROM videos v WHERE v.code=video_code LIMIT 1));
  SET cmd=REPLACE(cmd,'$looping',looping);
  INSERT INTO command (game_id,player_num,command,hidden_flag) VALUES (g_id,p_num,cmd,hidden);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cmd_put_building_by_card` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_put_building_by_card`(g_id INT,p_num INT,board_building_id INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'put_building($board_building_id,$p_num,$x,$y,$rotation,$flip,$card_id,$income)';
  DECLARE x,y INT;
  DECLARE rotation INT;
  DECLARE flip INT;
  DECLARE income INT;
  DECLARE card_id INT;

  SELECT MIN(b.x),MIN(b.y) INTO x,y FROM board b WHERE b.game_id=g_id AND b.`type`<>'unit' AND b.ref=board_building_id;
  SELECT bb.rotation,bb.flip,bb.card_id,bb.income INTO rotation,flip,card_id,income FROM board_buildings bb WHERE bb.id=board_building_id LIMIT 1;

  SET cmd=REPLACE(cmd,'$board_building_id',board_building_id);
  SET cmd=REPLACE(cmd,'$p_num',p_num);
  SET cmd=REPLACE(cmd,'$x',x);
  SET cmd=REPLACE(cmd,'$y',y);
  SET cmd=REPLACE(cmd,'$rotation',rotation);
  SET cmd=REPLACE(cmd,'$flip',flip);
  SET cmd=REPLACE(cmd,'$card_id',card_id);
  SET cmd=REPLACE(cmd,'$income',income);
  
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cmd_put_building_by_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_put_building_by_id`(g_id INT,p_num INT,board_building_id INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'put_building_by_id($board_building_id,$p_num,$x,$y,$rotation,$flip,$building_id,$income)';
  DECLARE x,y INT;
  DECLARE rotation INT;
  DECLARE flip INT;
  DECLARE income INT;
  DECLARE building_id INT;

  SELECT MIN(b.x),MIN(b.y) INTO x,y FROM board b WHERE b.game_id=g_id AND b.`type`<>'unit' AND b.ref=board_building_id;
  SELECT bb.rotation,bb.flip,bb.income,bb.building_id INTO rotation,flip,income,building_id FROM board_buildings bb WHERE bb.id=board_building_id LIMIT 1;

  SET cmd=REPLACE(cmd,'$board_building_id',board_building_id);
  SET cmd=REPLACE(cmd,'$p_num',p_num);
  SET cmd=REPLACE(cmd,'$x',x);
  SET cmd=REPLACE(cmd,'$y',y);
  SET cmd=REPLACE(cmd,'$rotation',rotation);
  SET cmd=REPLACE(cmd,'$flip',flip);
  SET cmd=REPLACE(cmd,'$building_id',building_id);
  SET cmd=REPLACE(cmd,'$income',income);
  
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cmd_remove_card` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_remove_card`(g_id INT,p_num INT,player_deck_id INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'remove_card($player_deck_id)';

  SET cmd=REPLACE(cmd,'$player_deck_id',player_deck_id);
  INSERT INTO command (game_id,player_num,command,hidden_flag) VALUES (g_id,p_num,cmd,1);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cmd_remove_from_grave` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_remove_from_grave`(g_id INT,p_num INT,grave_id INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'remove_from_grave($grave_id)';

  SET cmd=REPLACE(cmd,'$grave_id',grave_id);
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cmd_remove_spectator` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_remove_spectator`(g_id INT,p_num INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'remove_spectator($p_num)';

  SET cmd=REPLACE(cmd,'$p_num',p_num);
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cmd_resurrect_by_card_log` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_resurrect_by_card_log`(g_id INT, p_num INT, crd_id INT)
BEGIN
  DECLARE board_unit_id INT;

  SELECT MAX(bu.id) INTO board_unit_id FROM board_units bu WHERE bu.game_id=g_id AND bu.player_num=p_num AND bu.card_id=crd_id;
  CALL cmd_log_add_message(g_id, p_num, 'resurrect', CONCAT_WS(';', log_player(g_id, p_num), log_unit(board_unit_id)));

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cmd_set_active_player` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_set_active_player`(g_id INT,p_num INT,last_turn INT,turn INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'set_active_player($p_num,$last_turn,$turn_num,$npc_flag)';
  DECLARE cmd_npc VARCHAR(1000) CHARSET utf8 DEFAULT 'NPC($p_num)';
  DECLARE owner INT;

  SET cmd=REPLACE(cmd,'$p_num',p_num);
  SET cmd=REPLACE(cmd,'$last_turn',last_turn);
  SET cmd=REPLACE(cmd,'$turn_num',turn);
  SET cmd=REPLACE(cmd,'$npc_flag',(SELECT CASE WHEN p.owner IN (0,1) THEN 0 ELSE 1 END FROM players p WHERE p.game_id=g_id AND p.player_num=p_num LIMIT 1));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

  
  SELECT p.owner INTO owner FROM players p WHERE p.game_id=g_id AND p.player_num=p_num LIMIT 1;

  IF(owner NOT IN(0,1)) THEN
	SET cmd_npc=REPLACE(cmd_npc,'$p_num',p_num);
    INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_npc);
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cmd_unit_add_effect` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_unit_add_effect`(g_id INT, board_unit_id INT, eff VARCHAR(30))
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'unit_add_effect($x,$y,"$effect","$param")';
  DECLARE log_key_add_effect VARCHAR(50) CHARSET utf8;
  DECLARE x,y INT;
  DECLARE p2_num INT; 

  SELECT b.x,b.y INTO x,y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=board_unit_id LIMIT 1;
  SELECT bu.player_num INTO p2_num FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;
  SET cmd=REPLACE(cmd,'$x',x);
  SET cmd=REPLACE(cmd,'$y',y);
  SET cmd=REPLACE(cmd,'$effect',eff);
  SET cmd=REPLACE(cmd,'$param',IFNULL(unit_feature_get_param(board_unit_id,eff),''));

  SELECT uf.log_key_add INTO log_key_add_effect FROM unit_features uf WHERE uf.code = eff LIMIT 1;
  CALL cmd_log_add_message(g_id, p2_num, log_key_add_effect, log_unit(board_unit_id));
    
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p2_num,cmd);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cmd_unit_remove_effect` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_unit_remove_effect`(g_id INT, board_unit_id INT, eff VARCHAR(30))
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'unit_remove_effect($x,$y,"$effect")';
  DECLARE log_key_remove_effect VARCHAR(50) CHARSET utf8;
  DECLARE x,y INT;
  DECLARE p2_num INT; 

  SELECT b.x,b.y INTO x,y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=board_unit_id LIMIT 1;
  SELECT bu.player_num INTO p2_num FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;
  SET cmd=REPLACE(cmd,'$x',x);
  SET cmd=REPLACE(cmd,'$y',y);
  SET cmd=REPLACE(cmd,'$effect',eff);

  SELECT uf.log_key_remove INTO log_key_remove_effect FROM unit_features uf WHERE uf.code = eff LIMIT 1;

  IF((SELECT current_procedure FROM active_players WHERE game_id=g_id LIMIT 1)='end_turn')THEN
    CALL cmd_log_add_independent_message(g_id, p2_num, log_key_remove_effect, log_unit(board_unit_id));
  ELSE
    CALL cmd_log_add_message(g_id, p2_num, log_key_remove_effect, log_unit(board_unit_id));
  END IF;

  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p2_num,cmd);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cmd_unit_set_attack` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_unit_set_attack`(g_id INT,p_num INT,board_unit_id INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'unit_set_attack($x,$y,$attack)';
  DECLARE x,y INT;

  SELECT b.x,b.y INTO x,y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=board_unit_id LIMIT 1;
  SET cmd=REPLACE(cmd,'$x',x);
  SET cmd=REPLACE(cmd,'$y',y);
  SET cmd=REPLACE(cmd,'$attack',(SELECT attack FROM board_units WHERE id=board_unit_id LIMIT 1));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cmd_unit_set_health` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_unit_set_health`(g_id INT,p_num INT,board_unit_id INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'unit_set_health($x,$y,$health)';
  DECLARE x,y INT;

  SELECT b.x,b.y INTO x,y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=board_unit_id LIMIT 1;
  SET cmd=REPLACE(cmd,'$x',x);
  SET cmd=REPLACE(cmd,'$y',y);
  SET cmd=REPLACE(cmd,'$health',(SELECT health FROM board_units WHERE id=board_unit_id LIMIT 1));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cmd_unit_set_max_health` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_unit_set_max_health`(g_id INT,p_num INT,board_unit_id INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'unit_set_max_health($x,$y,$health)';
  DECLARE x,y INT;

  SELECT b.x,b.y INTO x,y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=board_unit_id LIMIT 1;
  SET cmd=REPLACE(cmd,'$x',x);
  SET cmd=REPLACE(cmd,'$y',y);
  SET cmd=REPLACE(cmd,'$health',(SELECT max_health FROM board_units WHERE id=board_unit_id LIMIT 1));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cmd_unit_set_moves` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_unit_set_moves`(g_id INT,p_num INT,board_unit_id INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'unit_set_moves($x,$y,$m)';
  DECLARE x,y INT;

  SELECT b.x,b.y INTO x,y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=board_unit_id LIMIT 1;
  SET cmd=REPLACE(cmd,'$x',x);
  SET cmd=REPLACE(cmd,'$y',y);
  SET cmd=REPLACE(cmd,'$m',(SELECT moves FROM board_units WHERE id=board_unit_id LIMIT 1));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cmd_unit_set_moves_left` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_unit_set_moves_left`(g_id INT,p_num INT,board_unit_id INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'unit_set_moves_left($x,$y,$m_left)';
  DECLARE x,y INT;

  SELECT b.x,b.y INTO x,y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=board_unit_id LIMIT 1;
  SET cmd=REPLACE(cmd,'$x',x);
  SET cmd=REPLACE(cmd,'$y',y);
  SET cmd=REPLACE(cmd,'$m_left',(SELECT moves_left FROM board_units WHERE id=board_unit_id LIMIT 1));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cmd_unit_set_owner` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_unit_set_owner`(g_id INT,p_num INT,board_unit_id INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'unit_set_owner($x,$y,$p_num)';
  DECLARE x,y INT;

  SELECT b.x,b.y INTO x,y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=board_unit_id LIMIT 1;
  SET cmd=REPLACE(cmd,'$x',x);
  SET cmd=REPLACE(cmd,'$y',y);
  SET cmd=REPLACE(cmd,'$p_num',(SELECT player_num FROM board_units WHERE id=board_unit_id LIMIT 1));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `cmd_unit_set_shield` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_unit_set_shield`(g_id INT,p_num INT,board_unit_id INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'unit_set_shield($x,$y,$shield)';
  DECLARE x,y INT;

  SELECT b.x,b.y INTO x,y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=board_unit_id LIMIT 1;
  SET cmd=REPLACE(cmd,'$x',x);
  SET cmd=REPLACE(cmd,'$y',y);
  SET cmd=REPLACE(cmd,'$shield',(SELECT shield FROM board_units WHERE id=board_unit_id LIMIT 1));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `coin_factory_income` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `coin_factory_income`(g_id INT, board_building_id INT)
BEGIN
  DECLARE p_num INT;
  DECLARE board_unit_id INT;

  DECLARE radius INT;
  DECLARE x,y INT;

  DECLARE units_in_radius_count INT;
  DECLARE enemy_p_num INT;
  DECLARE enemies_in_radius_count INT;

  DECLARE done INT DEFAULT 0;


  DECLARE cur CURSOR FOR
    SELECT bu.player_num,COUNT(*)
      FROM board b
      JOIN board_units bu ON (b.ref=bu.id)
    WHERE
      b.game_id=g_id
      AND b.`type`='unit'
      AND b.x BETWEEN x-radius AND x+radius
      AND b.y BETWEEN y-radius AND y+radius
      AND (get_unit_team(bu.id) <> get_player_team(g_id, p_num))
    GROUP BY bu.player_num;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SELECT bb.radius,bb.player_num INTO radius,p_num FROM board_buildings bb WHERE bb.id=board_building_id LIMIT 1;
  SELECT b.x,b.y INTO x,y FROM board b WHERE b.game_id=g_id AND b.ref=board_building_id AND b.`type`<>'unit' LIMIT 1;

  SELECT COUNT(*) INTO units_in_radius_count FROM board b WHERE b.game_id=g_id AND b.type='unit'
    AND b.x BETWEEN x-radius AND x+radius 
    AND b.y BETWEEN y-radius AND y+radius;

  UPDATE players SET gold=gold+units_in_radius_count WHERE game_id=g_id AND player_num=p_num;
  CALL cmd_player_set_gold(g_id,p_num);

  OPEN cur;
  REPEAT
    FETCH cur INTO enemy_p_num,enemies_in_radius_count;
    IF NOT done THEN
      UPDATE players SET gold=CASE WHEN gold<enemies_in_radius_count THEN 0 ELSE gold-enemies_in_radius_count END WHERE game_id=g_id AND player_num=enemy_p_num;
      CALL cmd_player_set_gold(g_id,enemy_p_num);
    END IF;
  UNTIL done END REPEAT;
  CLOSE cur;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `count_income` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `count_income`(board_building_id INT)
BEGIN
  DECLARE x,y,x1,y1 INT;
  DECLARE g_id INT;
  DECLARE mode_id INT;
  DECLARE p_num INT;
  DECLARE building_income INT;
  DECLARE income INT DEFAULT 0;

  DECLARE radius INT;
  DECLARE shape VARCHAR(400);

  SELECT bb.game_id,bb.player_num,b.radius,b.shape INTO g_id,p_num,radius,shape FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.id=board_building_id LIMIT 1;

        IF(shape='1' AND radius>0)THEN
        BEGIN
          SELECT MIN(b.x),MIN(b.y) INTO x,y FROM board b WHERE b.game_id=g_id AND b.`type`<>'unit' AND b.ref=board_building_id;

          SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
          SELECT cfg.`value` INTO building_income FROM mode_config cfg WHERE cfg.param='building income' AND cfg.mode_id=mode_id;

          SET x1=x-radius;
          WHILE x1<=x+radius DO
            SET y1=y-radius;
            WHILE y1<=y+radius DO
              IF(quart(x1,y1)<>5 AND quart(x1,y1)<>p_num AND NOT (x1=x AND y1=y) )THEN
                SET income=income+building_income;
              END IF;
              SET y1=y1+1;
            END WHILE;
            SET x1=x1+1;
          END WHILE;
          UPDATE board_buildings b SET b.income=income WHERE b.id=board_building_id;
        END;
        END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_game_data` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_game_data`(g_id INT)
BEGIN
  DECLARE game_status_id INT;
  DECLARE finished_game_status INT DEFAULT 3; 
  DECLARE game_type_id INT;
  DECLARE arena_game_type_id INT DEFAULT 1; 

  SELECT g.status_id INTO game_status_id FROM games g WHERE g.id=g_id LIMIT 1;

  IF(game_status_id=finished_game_status)THEN

    SELECT g.type_id INTO game_type_id FROM games g WHERE g.id=g_id LIMIT 1;
    IF(game_type_id=arena_game_type_id)THEN
      CALL lords_site.arena_game_delete_inner(g_id);
    END IF;

    DELETE FROM active_players WHERE game_id=g_id;
    DELETE FROM board WHERE game_id=g_id;
    DELETE FROM board_buildings_features WHERE board_building_id IN (SELECT id FROM board_buildings WHERE game_id=g_id);
    DELETE FROM board_buildings WHERE game_id=g_id;
    DELETE FROM board_units_features WHERE board_unit_id IN (SELECT id FROM board_units WHERE game_id=g_id);
    DELETE FROM board_units WHERE game_id=g_id;
    DELETE FROM log_commands WHERE game_id=g_id;
    DELETE FROM deck WHERE game_id=g_id;
    DELETE FROM games_features_usage WHERE game_id=g_id;
    DELETE FROM player_deck WHERE game_id=g_id;
    DELETE FROM players WHERE game_id=g_id;
    DELETE FROM games WHERE id=g_id;
    DELETE FROM statistic_game_actions WHERE game_id=g_id;
    DELETE FROM statistic_values WHERE game_id=g_id;
    DELETE FROM statistic_players WHERE game_id=g_id;
    DELETE FROM player_features_usage WHERE game_id=g_id;

  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_player_objects` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_player_objects`(g_id INT, p_num INT)
BEGIN

  DECLARE player_deck_id INT;
  DECLARE crd_id INT;
  DECLARE board_unit_id INT;
  DECLARE board_building_id INT;
  DECLARE grave_id INT;

  DECLARE done INT DEFAULT 0;
  DECLARE cur1 CURSOR FOR SELECT pd.id FROM player_deck pd WHERE pd.game_id=g_id AND pd.player_num=p_num;
  DECLARE cur2 CURSOR FOR SELECT bu.id,bu.card_id FROM board_units bu WHERE bu.game_id=g_id AND bu.player_num=p_num;
  DECLARE cur3 CURSOR FOR SELECT bb.id FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.game_id=g_id AND bb.player_num=p_num AND b.`type`<>'obstacle';
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;


    OPEN cur1;
    REPEAT
      FETCH cur1 INTO player_deck_id;
      IF NOT done THEN
        CALL cmd_remove_card(g_id,p_num,player_deck_id);
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur1;

  INSERT INTO deck(game_id,card_id) SELECT g_id,pd.card_id FROM player_deck pd WHERE pd.game_id=g_id AND pd.player_num=p_num;
  DELETE FROM player_deck WHERE game_id=g_id AND player_num=p_num;

  SET done=0;


    OPEN cur2;
    REPEAT
      FETCH cur2 INTO board_unit_id,crd_id;
      IF NOT done THEN
        IF crd_id IS NOT NULL THEN
      INSERT INTO graves(game_id, card_id, player_num_when_killed, turn_when_killed)
          VALUES(g_id, crd_id, get_current_p_num(g_id), get_current_turn(g_id));
      SET grave_id=@@last_insert_id;
      INSERT INTO grave_cells(grave_id,x,y) SELECT grave_id,b.x,b.y FROM board b WHERE game_id=g_id AND b.`type`='unit' AND b.ref=board_unit_id;
          CALL cmd_add_to_grave(g_id,p_num,grave_id);
        END IF;

        CALL cmd_kill_unit(g_id,p_num,board_unit_id);
        DELETE FROM board WHERE game_id=g_id AND `type`='unit' AND ref=board_unit_id;
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur2;

  DELETE board_units_features FROM board_units_features JOIN board_units ON (board_units_features.board_unit_id=board_units.id)
    WHERE board_units.game_id=g_id AND board_units.player_num=p_num;
  DELETE FROM board_units WHERE game_id=g_id AND player_num=p_num;

  SET done=0;


    OPEN cur3;
    REPEAT
      FETCH cur3 INTO board_building_id;
      IF NOT done THEN
        CALL cmd_destroy_building(g_id,p_num,board_building_id);
        DELETE FROM board WHERE game_id=g_id AND `type`<>'unit' AND ref=board_building_id;
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur3;

  INSERT INTO deck(game_id,card_id) SELECT g_id,bb.card_id FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.game_id=g_id AND bb.player_num=p_num AND b.`type`<>'obstacle' AND bb.card_id IS NOT NULL;

  DELETE board_buildings_features FROM board_buildings_features JOIN board_buildings ON (board_buildings_features.board_building_id=board_buildings.id)
    WHERE board_buildings.game_id=g_id AND board_buildings.player_num=p_num;
  DELETE FROM board_buildings WHERE game_id=g_id AND player_num=p_num AND (SELECT b.`type` FROM buildings b WHERE b.id=building_id)<>'obstacle';

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `destroy_building` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `destroy_building`(board_b_id INT, p_num INT)
BEGIN
  DECLARE g_id INT;
  DECLARE reward INT DEFAULT 50;
  DECLARE old_x,old_y,old_rotation,old_flip INT;
  DECLARE destroy_bridge INT DEFAULT 0;

  SELECT game_id INTO g_id FROM board_buildings WHERE id=board_b_id LIMIT 1;

  CALL cmd_log_add_message(g_id, p_num, 'building_destroyed', log_building(board_b_id));

  IF EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.`type`='obstacle' AND b.ref=board_b_id) THEN
    SET reward=0; 
  END IF;

  IF(building_feature_check(board_b_id,'destroy_reward'))THEN
    SET reward=building_feature_get_param(board_b_id,'destroy_reward');
  END IF;

  IF(building_feature_check(board_b_id,'destroyable_bridge'))THEN
    SELECT MIN(b.x),MIN(b.y) INTO old_x,old_y FROM board b WHERE b.game_id=g_id AND b.`type`<>'unit' AND b.ref=board_b_id;
    SELECT bb.rotation,bb.flip INTO old_rotation,old_flip FROM board_buildings bb WHERE bb.id=board_b_id LIMIT 1;
    SET destroy_bridge=1;
  END IF;

  CALL remove_building_from_board(board_b_id,p_num);

  IF reward>0 THEN
    UPDATE players SET gold=gold+reward WHERE game_id=g_id AND player_num=p_num;
    CALL cmd_player_set_gold(g_id,p_num);
  END IF;

  IF(destroy_bridge=1)THEN
   CALL bridge_destroy(g_id,p_num,old_x,old_y,old_rotation,old_flip);
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `destroy_castle` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `destroy_castle`(board_castle_id INT,   p_num INT)
BEGIN
  DECLARE g_id INT;
  DECLARE g_mode INT;
  DECLARE p2_num INT; 
  DECLARE destroyed_castle_x INT;
  DECLARE destroyed_castle_y INT;
  DECLARE destroyed_castle_rotation INT;
  DECLARE destroyed_castle_flip INT;
  DECLARE ruins_building_id INT;
  DECLARE ruins_board_building_id INT;
  DECLARE user_id INT;
  DECLARE mode_id INT;
  DECLARE game_type_id INT;

  SELECT game_id,player_num INTO g_id,p2_num FROM board_buildings WHERE id=board_castle_id LIMIT 1;
  SELECT g.mode_id INTO g_mode FROM games g WHERE g.id=g_id LIMIT 1;

  CALL cmd_log_add_independent_message(g_id, p2_num, 'castle_destroyed', log_building(board_castle_id));

  INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'destroy_building',p2_num);

  SELECT bb.rotation,bb.flip INTO destroyed_castle_rotation,destroyed_castle_flip FROM board_buildings bb WHERE bb.id=board_castle_id LIMIT 1;
  SELECT MIN(b.x),MIN(b.y) INTO destroyed_castle_x,destroyed_castle_y FROM board b WHERE game_id=g_id AND `type`<>'unit' AND ref=board_castle_id;

  CALL delete_player_objects(g_id,p2_num);


  SELECT v.building_id INTO ruins_building_id FROM vw_mode_building_default_features v WHERE v.mode_id=g_mode AND v.feature_id=building_feature_get_id_by_code('ruins');

  INSERT INTO board_buildings(game_id,player_num,building_id,rotation,flip)VALUES (g_id,p2_num,ruins_building_id,destroyed_castle_rotation,destroyed_castle_flip);
  SET ruins_board_building_id=@@last_insert_id;

  CALL place_building_on_board(ruins_board_building_id,destroyed_castle_x,destroyed_castle_y,destroyed_castle_rotation,destroyed_castle_flip);

  CALL cmd_put_building_by_id(g_id,p2_num,ruins_board_building_id);


  IF (SELECT player_num FROM active_players WHERE game_id=g_id LIMIT 1)=p2_num THEN
    CALL end_turn(g_id,p2_num);
  END IF;

  UPDATE players SET owner=0, move_order = NULL WHERE game_id=g_id AND player_num=p2_num;

  SELECT p.user_id INTO user_id FROM players p WHERE game_id=g_id AND player_num=p2_num;
  UPDATE lords_site.arena_game_players agp SET agp.spectator_flag=1 WHERE agp.user_id=user_id;

  CALL cmd_delete_player(g_id,p2_num);
  CALL cmd_add_spectator(g_id,p2_num);
  CALL cmd_play_video(g_id,p2_num,'destroyed_castle',1,1);

  SELECT g.mode_id, g.type_id INTO mode_id, game_type_id FROM games g WHERE g.id = g_id;

  INSERT INTO lords_site.user_statistics_games(user_id,game_type_id,mode_id,game_result)
  VALUES(user_id,game_type_id,mode_id,'lose');

  IF (SELECT COUNT(DISTINCT p.team) FROM players p WHERE game_id=g_id AND owner=1)=1 THEN
    CALL end_game(g_id);
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `disagree_draw` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `disagree_draw`(g_id INT, p_num INT)
BEGIN
  CALL user_action_begin();

  UPDATE players SET agree_draw=0 WHERE game_id=g_id AND player_num=p_num;
  CALL cmd_log_add_independent_message(g_id, p_num, 'disagrees_to_draw', NULL);

  CALL user_action_end();

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `drink_health` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `drink_health`(board_unit_id INT)
BEGIN
  DECLARE dice_max INT DEFAULT 2;
  DECLARE chance INT DEFAULT 1;
  DECLARE drink_health_amt INT DEFAULT 1;
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE health,max_health INT;

  IF get_random_int_between(1, dice_max) > chance THEN 
    SELECT bu.game_id,bu.player_num,bu.health,bu.max_health INTO g_id,p_num,health,max_health FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

    IF(health+drink_health_amt>max_health)THEN
      UPDATE board_units SET max_health=health+drink_health_amt, health=health+drink_health_amt WHERE id=board_unit_id;
      CALL cmd_unit_set_max_health(g_id,p_num,board_unit_id);
      CALL cmd_unit_set_health(g_id,p_num,board_unit_id);
    ELSE 
      UPDATE board_units SET health=health+drink_health_amt WHERE id=board_unit_id;
      CALL cmd_unit_set_health(g_id,p_num,board_unit_id);
    END IF;

    CALL cmd_log_add_message(g_id, p_num, 'unit_drinks_health', CONCAT_WS(';', log_unit(board_unit_id), drink_health_amt));

  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `end_cards_phase` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `end_cards_phase`(g_id INT,p_num INT)
BEGIN
  DECLARE g_mode INT;
  DECLARE two_phase_turn INT;

  SELECT g.mode_id INTO g_mode FROM games g WHERE g.id=g_id LIMIT 1;
  SELECT cfg.`value` INTO two_phase_turn FROM mode_config cfg WHERE cfg.param='two_phase_turn' AND cfg.mode_id=g_mode;

  IF(two_phase_turn IS NULL OR two_phase_turn=0)THEN
    CALL end_turn(g_id,p_num);
  ELSE
    UPDATE active_players SET card_played_flag=1 WHERE game_id=g_id AND player_num=p_num;
    IF (check_all_units_moved(g_id,p_num) = 1) THEN
      CALL end_turn(g_id,p_num);
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `end_game` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `end_game`(g_id INT)
BEGIN
  DECLARE p_num INT;
  DECLARE finished_game_status INT DEFAULT 3; 
  DECLARE user_id INT;
  DECLARE mode_id INT;
  DECLARE game_type_id INT;

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT p.player_num,p.user_id FROM players p WHERE p.game_id=g_id AND owner=1;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SELECT g.mode_id, g.type_id INTO mode_id, game_type_id FROM games g WHERE g.id = g_id;

  IF (SELECT COUNT(DISTINCT p.team) FROM players p WHERE game_id=g_id AND owner=1)=1 THEN

    OPEN cur;
    REPEAT
      FETCH cur INTO p_num,user_id;
      IF NOT done THEN
        CALL cmd_play_video(g_id,p_num,'win',1,1);

        INSERT INTO lords_site.user_statistics_games(user_id,game_type_id,mode_id,game_result)
        VALUES(user_id,game_type_id,mode_id,'win');
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur;
  ELSE

    SELECT player_num INTO p_num FROM active_players WHERE game_id=g_id LIMIT 1;
    CALL cmd_play_video(g_id,p_num,'draw',0,1);

    INSERT INTO lords_site.user_statistics_games(user_id,game_type_id,mode_id,game_result)
    SELECT p.user_id,game_type_id,mode_id,'draw'
    FROM players p WHERE p.game_id=g_id AND owner=1;

  END IF;

  CALL cmd_end_game(g_id);

  UPDATE games SET status_id=finished_game_status,time_restriction=0 WHERE id=g_id;

  UPDATE lords_site.arena_games SET status_id=finished_game_status,time_restriction=0 WHERE id=g_id;


  CALL statistic_calculation(g_id);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `end_turn` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `end_turn`(g_id INT,  p_num INT)
BEGIN
  DECLARE board_unit_id INT;
  DECLARE p_num2 INT;
  DECLARE move_order_p1 INT;
  DECLARE move_order_p2 INT;
  DECLARE owner_p1 INT;
  DECLARE owner_p2 INT;
  DECLARE last_turn INT;
  DECLARE turn,new_turn INT;
  DECLARE mode_id INT;

  DECLARE nonfinished_action INT;

  DECLARE board_building_id INT;


  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id AND bu.player_num=p_num AND bu.moves_left<ABS(bu.moves);

  DECLARE cur_building_features CURSOR FOR
    SELECT bb.id FROM board_buildings bb WHERE bb.game_id=g_id AND bb.player_num=p_num2 AND check_building_deactivated(bb.id)=0;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    SELECT a.turn,a.nonfinished_action_id INTO turn,nonfinished_action FROM active_players a WHERE a.game_id=g_id LIMIT 1;
    SELECT p.owner, p.move_order INTO owner_p1, move_order_p1 FROM players p WHERE p.game_id=g_id AND p.player_num=p_num LIMIT 1;

    IF(nonfinished_action<>0)THEN
      CALL finish_nonfinished_action(g_id,p_num,nonfinished_action);
    END IF;

    IF move_order_p1 = (SELECT MAX(move_order) FROM players WHERE game_id=g_id) THEN
      SET new_turn=turn+1;
      SELECT MIN(move_order) INTO move_order_p2 FROM players WHERE game_id=g_id;
    ELSE
      SET new_turn=turn;
      SELECT MIN(move_order) INTO move_order_p2 FROM players WHERE game_id=g_id AND move_order > move_order_p1;
    END IF;

    SELECT player_num INTO p_num2 FROM players WHERE game_id = g_id AND move_order = move_order_p2 LIMIT 1;

    UPDATE active_players SET turn=new_turn, player_num=p_num2, subsidy_flag=0, units_moves_flag=0, card_played_flag=0, nonfinished_action_id=0, last_end_turn=CURRENT_TIMESTAMP, current_procedure='end_turn' WHERE game_id=g_id;

    SELECT UNIX_TIMESTAMP(a.last_end_turn) INTO last_turn FROM active_players a WHERE a.game_id=g_id;

    CALL cmd_set_active_player(g_id,p_num2,last_turn,new_turn);

    OPEN cur;
    REPEAT
      FETCH cur INTO board_unit_id;
      IF NOT done THEN
        UPDATE board_units SET moves_left=moves WHERE id=board_unit_id;
        CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur;


  IF @player_end_turn IS NULL THEN
    DELETE FROM player_features_usage WHERE game_id=g_id AND player_num=p_num AND feature_id=player_feature_get_id_by_code('end_turn');
  END IF;

  SELECT p.owner INTO owner_p2 FROM players p WHERE p.game_id=g_id AND p.player_num=p_num2 LIMIT 1;

  IF owner_p2=1 THEN 
  BEGIN
    DECLARE cmd_log_close_container VARCHAR(1000) CHARSET utf8 DEFAULT 'log_close_container()';


    DECLARE income INT;
    DECLARE u_income INT;


    IF (owner_p1 NOT IN(0,1)) THEN
      INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log_close_container);
    END IF;


    SELECT IFNULL(SUM(bb.income),0) INTO income FROM board_buildings bb WHERE bb.game_id=g_id AND bb.player_num=p_num2 AND bb.income<>0 AND check_building_deactivated(bb.id)=0;

    SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
    SELECT cfg.`value` INTO u_income FROM mode_config cfg WHERE cfg.param='unit income' AND cfg.mode_id=mode_id;
    SET income=income+(SELECT IFNULL((COUNT(*))*u_income,0) FROM board b JOIN board_units bu ON (b.ref=bu.id) WHERE b.game_id=g_id AND b.`type`='unit' AND bu.player_num=p_num2 AND quart(b.x,b.y)<>p_num2);

    IF income>0 THEN
      UPDATE players SET gold=gold+income WHERE game_id=g_id AND player_num=p_num2;
      CALL cmd_player_set_gold(g_id,p_num2);
    END IF;

    SET done=0;

    OPEN cur_building_features;
    REPEAT
      FETCH cur_building_features INTO board_building_id;
      IF NOT done THEN

        IF(building_feature_check(board_building_id,'healing'))=1 THEN
          CALL healing_tower_heal(g_id,board_building_id);
        END IF;

        IF(building_feature_check(board_building_id,'frog_factory'))=1 THEN
          CALL lake_summon_frogs(g_id,board_building_id);
        END IF;

        IF(building_feature_check(board_building_id,'troll_factory'))=1 THEN
          CALL mountains_summon_troll(g_id,board_building_id);
        END IF;

        IF(building_feature_check(board_building_id,'coin_factory'))=1 THEN
          CALL coin_factory_income(g_id,board_building_id);
        END IF;

        IF(building_feature_check(board_building_id,'barracks'))=1 THEN
          CALL barracks_summon(g_id,board_building_id);
        END IF;

      END IF;
    UNTIL done END REPEAT;
    CLOSE cur_building_features;

  END;
  ELSE

  BEGIN
    IF (owner_p1 = 1 AND owner_p2 NOT IN(0,1)) THEN
      CALL cmd_log_add_container(g_id, p_num2, 'npc_turn', NULL);
    END IF;
  END;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `end_units_phase` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `end_units_phase`(g_id INT,p_num INT)
BEGIN
  DECLARE g_mode INT;
  DECLARE two_phase_turn INT;

  SELECT g.mode_id INTO g_mode FROM games g WHERE g.id=g_id LIMIT 1;
  SELECT cfg.`value` INTO two_phase_turn FROM mode_config cfg WHERE cfg.param='two_phase_turn' AND cfg.mode_id=g_mode;

  IF(two_phase_turn IS NULL OR two_phase_turn=0)THEN
    CALL end_turn(g_id,p_num);
  ELSE
    IF ((SELECT card_played_flag FROM active_players WHERE game_id=g_id AND player_num=p_num) = 1 OR (p_num >= 10)) THEN
      CALL end_turn(g_id,p_num);
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `finish_moving_units` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `finish_moving_units`(g_id INT,p_num INT)
BEGIN
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_close_container()';

  IF((SELECT owner FROM players p WHERE p.game_id=g_id AND p.player_num=p_num LIMIT 1)=1)THEN

    INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `finish_nonfinished_action` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `finish_nonfinished_action`(g_id INT,   p_num INT,   nonfinished_action INT)
BEGIN
  DECLARE mode_id INT;

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;

  CASE nonfinished_action

    WHEN 1 THEN 
    BEGIN
      DECLARE big_dice INT;
      DECLARE x_appear,y_appear INT;
      DECLARE max_size INT;
      DECLARE random_grave INT;
      DECLARE random_dead_card INT;

      SELECT ap.x,ap.y INTO x_appear,y_appear FROM appear_points ap WHERE ap.mode_id=mode_id AND ap.player_num=p_num;
      
      SELECT IFNULL(MIN(GREATEST(ABS(b.x-18),ABS(b.y-18))),18) INTO max_size FROM board b
      WHERE b.x NOT IN(0,19) AND b.y NOT IN(0,19);
      
        CREATE TEMPORARY TABLE tmp_dead_units (id_rand INT AUTO_INCREMENT PRIMARY KEY)AUTO_INCREMENT=1
          SELECT g.grave_id AS `grave_id`,g.card_id AS `card_id`
          FROM vw_grave g
          WHERE g.game_id=g_id AND g.size<=max_size;
        SET big_dice = get_random_int_between(1, (SELECT MAX(id_rand) FROM tmp_dead_units));
        SELECT `grave_id`,`card_id` INTO random_grave,random_dead_card FROM tmp_dead_units WHERE id_rand=big_dice LIMIT 1;
        DROP TEMPORARY TABLE tmp_dead_units;

        CALL resurrect(g_id,p_num,random_grave);
        CALL cmd_resurrect_by_card_log(g_id,p_num,random_dead_card);
    END;

    WHEN 2 THEN 
    BEGIN
      DECLARE zone INT;

      SET zone = get_random_int_between(0, 3);

      CALL units_from_zone(g_id, p_num, zone);
    END;

    WHEN 3 THEN 
    BEGIN
      DECLARE rand_building_id INT;
      SET rand_building_id = get_random_others_moveable_building_or_obstacle(g_id, p_num);
      UPDATE board_buildings bb SET bb.player_num = p_num WHERE bb.id = rand_building_id;
      CALL cmd_building_set_owner(g_id,p_num,rand_building_id);
      CALL move_building_randomly(rand_building_id);
    END;

    WHEN 4 THEN 
    BEGIN
      DECLARE random_player INT;

      SELECT player_num INTO random_player FROM players WHERE game_id=g_id AND owner <> 0 ORDER BY RAND() LIMIT 1;
      CALL vred_pooring(g_id,random_player);
    END;

    WHEN 5 THEN 
    BEGIN
      DECLARE random_bu_id,u_id INT;
      DECLARE shield INT;

      SELECT bu.id,bu.unit_id,bu.shield INTO random_bu_id,u_id,shield FROM board_units bu WHERE bu.game_id=g_id ORDER BY RAND() LIMIT 1;

      CALL magic_kill_unit(random_bu_id,p_num);
    END;

    WHEN 6 THEN 
    BEGIN
      DECLARE random_bb_id,b_id INT;

      SELECT bb.id INTO random_bb_id FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.game_id=g_id AND b.`type`<>'castle' ORDER BY RAND() LIMIT 1;
      CALL destroy_building(random_bb_id,p_num);
    END;

    WHEN 7 THEN 
    BEGIN
      DECLARE rand_building_id INT;
      SET rand_building_id = get_random_others_moveable_building_or_obstacle(g_id, p_num);
      CALL move_building_randomly(rand_building_id);
    END;

  END CASE;

  UPDATE active_players SET nonfinished_action_id=0 WHERE game_id=g_id AND player_num=p_num;

  CALL finish_playing_card(g_id,p_num);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `finish_playing_card` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `finish_playing_card`(g_id INT,p_num INT)
BEGIN
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_close_container()';

  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_all_game_info` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_game_info`(g_id INT,  p_num INT)
BEGIN

  SELECT g.title,g.owner_id,g.time_restriction,g.status_id,g.`date` AS `creation_date`,g.mode_id,g.type_id FROM games g WHERE g.id=g_id;

  SELECT b.id,MIN(b.x) as `x`,MIN(b.y) as `y`,b.ref,b.`type` FROM board b WHERE b.game_id=g_id AND b.`type`<>'unit' GROUP BY b.ref,b.`type`;

  SELECT b.id,MIN(b.x) as `x`,MIN(b.y) as `y`,b.ref,b.`type` FROM board b WHERE b.game_id=g_id AND b.`type`='unit' GROUP BY b.ref,b.`type`;

  SELECT a.player_num,a.turn,a.subsidy_flag,a.units_moves_flag,a.card_played_flag,UNIX_TIMESTAMP(a.last_end_turn) as `last_end_turn`,n.command_procedure FROM active_players a LEFT JOIN nonfinished_actions_dictionary n ON (a.nonfinished_action_id=n.id) WHERE a.game_id=g_id;

  SELECT p.player_num, p.name, p.gold, p.owner, p.team, p.agree_draw FROM players p WHERE p.game_id=g_id ORDER BY p.player_num;

  SELECT b.id, b.building_id, b.player_num, b.health, b.max_health, b.radius, b.card_id, b.income, b.rotation, b.flip FROM board_buildings b WHERE b.game_id=g_id;

  SELECT bbf.board_building_id,bbf.feature_id,bbf.param FROM board_buildings_features bbf JOIN board_buildings bb ON (bb.id=bbf.board_building_id) WHERE bb.game_id=g_id;

  SELECT b.id, b.player_num, b.unit_id, b.card_id, b.health, b.max_health, b.attack, b.moves_left, b.moves, b.shield, b.experience, b.level FROM board_units b WHERE b.game_id=g_id;

  SELECT buf.board_unit_id,buf.feature_id,buf.param FROM board_units_features buf JOIN board_units bu ON (bu.id=buf.board_unit_id) WHERE bu.game_id=g_id;

  SELECT v.grave_id, v.card_id, v.player_num_when_killed, v.turn_when_killed, v.x, v.y, v.size FROM vw_grave v WHERE v.game_id=g_id;

  SELECT p.id,p.card_id FROM player_deck p WHERE p.game_id=g_id AND p.player_num=p_num;

  select command from log_commands where game_id=g_id AND((hidden_flag=0) OR (player_num = p_num));

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_all_game_info_ai` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_game_info_ai`(g_id INT, p_num INT)
BEGIN

  SELECT p.player_num, p.owner, p.team FROM players p WHERE p.game_id=g_id ORDER BY p.player_num;

  SELECT b.id, b.player_num, b.health, b.max_health FROM board_buildings b WHERE b.game_id=g_id;

  SELECT bbf.board_building_id,bf.code AS `feature_name`,bbf.param AS `feature_value` FROM board_buildings_features bbf JOIN board_buildings bb ON (bb.id=bbf.board_building_id) JOIN building_features bf ON (bbf.feature_id = bf.id) WHERE bb.game_id=g_id;

  SELECT
    u.id,
    u.player_num,
    u.health,
    u.max_health,
    u.attack,
    u.moves_left,
    u.moves,
    u.shield,
    check_unit_can_level_up(u.id) AS `can_levelup`,
    s.min_range,
    s.max_range,
    s.shoots_units,
    s.shoots_buildings,
    s.shoots_castles
    FROM board_units u
    LEFT JOIN (SELECT
      sp.unit_id,
      MIN(sp.distance) as `min_range`,
      MAX(sp.distance) as `max_range`,
      MAX(CASE aim_type WHEN 'unit' THEN 1 ELSE 0 END) as `shoots_units`,
      MAX(CASE aim_type WHEN 'building' THEN 1 ELSE 0 END) as `shoots_buildings`,
      MAX(CASE aim_type WHEN 'castle' THEN 1 ELSE 0 END) as `shoots_castles`
      FROM shooting_params sp
      GROUP BY sp.unit_id) s ON u.unit_id = s.unit_id
    WHERE u.game_id=g_id;

  SELECT buf.board_unit_id,uf.code AS `feature_name`,buf.param AS `feature_value` FROM board_units_features buf JOIN board_units bu ON (bu.id=buf.board_unit_id) JOIN unit_features uf ON (buf.feature_id = uf.id) WHERE bu.game_id=g_id;

  SELECT b.x, b.y, b.`type`, b.ref FROM board b WHERE b.game_id=g_id;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_games_info` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_games_info`()
BEGIN

  SELECT
    g.id AS `game_id`,
    g.mode_id,
    g.time_restriction,
    g.status_id,
    p.player_num AS `active_player_num`,
    p.owner AS `active_player_owner`
  FROM games g
  JOIN active_players ap ON (g.id=ap.game_id)
  LEFT JOIN players p ON (ap.game_id=p.game_id AND ap.player_num=p.player_num);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_game_info` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_game_info`(g_id INT)
BEGIN

  SELECT
    g.id AS `game_id`,
    g.mode_id,
    g.time_restriction,
    g.status_id,
    p.player_num AS `active_player_num`,
    p.owner AS `active_player_owner`
  FROM games g
  JOIN active_players ap ON (g.id=ap.game_id)
  JOIN players p ON (ap.game_id=p.game_id AND ap.player_num=p.player_num)
  WHERE g.id=g_id;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_game_statistic` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_game_statistic`(g_id INT)
BEGIN

  SELECT
    t.id as `tab_id`,
    t.name as `tab_name`,
    c.id as `chart_id`,
    c.type as `chart_type`,
    c.name as `chart_name`,
    v.id as `value_id`,
    v.value,
    CASE vc.color
      WHEN 'card_color' THEN
        CASE (SELECT type FROM cards WHERE id = v.value)
          WHEN 'u' THEN 'unit'
          WHEN 'b' THEN 'building'
          WHEN 'm' THEN 'magic'
		END
      ELSE vc.color
	END as color,
    v.name as `value_name`,
    p.player_name
  FROM
    statistic_tabs t
    JOIN statistic_charts c ON (c.tab_id = t.id)
    JOIN statistic_values_config vc ON (vc.chart_id = c.id)
    JOIN statistic_values v ON (v.stat_value_config_id = vc.id)
    JOIN statistic_players p ON (p.player_num = vc.player_num)
  WHERE v.game_id = g_id AND p.game_id = g_id
  ORDER BY `tab_id`,`chart_id`,`value_id`;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_random_free_cell_near_building` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_random_free_cell_near_building`(board_building_id INT, OUT x INT, OUT y INT)
BEGIN
  DECLARE g_id INT;
  DECLARE g_mode INT;

  SELECT game_id INTO g_id FROM board_buildings WHERE id=board_building_id LIMIT 1;
  SELECT mode_id INTO g_mode FROM games WHERE id=g_id LIMIT 1;

  SELECT DISTINCT a.x,a.y INTO x,y 
    FROM allcoords a, board b
    WHERE b.game_id=g_id
      AND b.`type`<>'unit'
      AND b.ref=board_building_id
      AND a.mode_id=g_mode
      AND (ABS(b.x-a.x)<=1 AND ABS(b.y-a.y)<=1)
      AND NOT EXISTS (SELECT b2.id FROM board b2 WHERE b2.x=a.x AND b2.y=a.y)
    ORDER BY RAND() LIMIT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_unit_phrase` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_unit_phrase`(g_id INT)
BEGIN
  DECLARE random_row INT;
  DECLARE board_unit_id INT;
  DECLARE unit_id INT;
  DECLARE phrase_id INT;
  DECLARE p_num INT;
  DECLARE lang_id INT;

  IF EXISTS(SELECT 1 FROM board_units bu WHERE bu.game_id=g_id LIMIT 1)THEN
    CREATE TEMPORARY TABLE tmp_units (id_rand INT AUTO_INCREMENT PRIMARY KEY)AUTO_INCREMENT=1
      SELECT
        bu.id AS `board_unit_id`,
        bu.unit_id AS `unit_id`,
        bu.player_num
      FROM board_units bu
      WHERE bu.game_id=g_id;

    SET random_row = get_random_int_between(1, (SELECT MAX(id_rand) FROM tmp_units));
    SELECT t.board_unit_id,t.unit_id,t.player_num INTO board_unit_id,unit_id,p_num FROM tmp_units t WHERE t.id_rand=random_row LIMIT 1;
    SET lang_id = get_player_language_id(g_id,p_num);
    DROP TEMPORARY TABLE tmp_units;

    IF EXISTS(SELECT 1 FROM dic_unit_phrases d WHERE d.unit_id=unit_id AND d.language_id = lang_id LIMIT 1)THEN
      CREATE TEMPORARY TABLE tmp_unit_phrases (id_rand INT AUTO_INCREMENT PRIMARY KEY)AUTO_INCREMENT=1
        SELECT
          d.id
        FROM dic_unit_phrases d
        WHERE d.unit_id=unit_id AND d.language_id = lang_id;

      SET random_row = get_random_int_between(1, (SELECT MAX(id_rand) FROM tmp_unit_phrases));
      SELECT t.id INTO phrase_id FROM tmp_unit_phrases t WHERE t.id_rand=random_row LIMIT 1;
      DROP TEMPORARY TABLE tmp_unit_phrases;

      SELECT board_unit_id,phrase_id FROM DUAL;

    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `healing_tower_heal` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `healing_tower_heal`(g_id INT, board_building_id INT)
BEGIN
  DECLARE p_num INT;
  DECLARE board_unit_id INT;
  DECLARE obj_x,obj_y INT;

  DECLARE ht_radius INT;
  DECLARE ht_x,ht_y INT;


  DECLARE done INT DEFAULT 0;

  DECLARE cur CURSOR FOR
    SELECT bu.id, b.x, b.y
      FROM board b
      JOIN board_units bu ON (b.ref=bu.id)
    WHERE
      b.game_id=g_id
      AND b.`type`='unit'
      AND b.x BETWEEN ht_x-ht_radius AND ht_x+ht_radius
      AND b.y BETWEEN ht_y-ht_radius AND ht_y+ht_radius
      AND (get_unit_team(bu.id) = get_player_team(g_id, p_num) OR (unit_feature_check(bu.id,'madness')=1 AND unit_feature_get_param(bu.id,'madness') IN
          (SELECT pl.player_num FROM players pl WHERE pl.game_id = g_id AND pl.team = get_player_team(g_id, p_num))));

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SELECT bb.radius,bb.player_num INTO ht_radius,p_num FROM board_buildings bb WHERE bb.id=board_building_id LIMIT 1;
  SELECT b.x,b.y INTO ht_x,ht_y FROM board b WHERE b.game_id=g_id AND b.ref=board_building_id AND b.`type`<>'unit' LIMIT 1;

  OPEN cur;
  REPEAT
    FETCH cur INTO board_unit_id,obj_x,obj_y;
    IF NOT done THEN
      CALL magical_heal(g_id,p_num,obj_x,obj_y,1);
    END IF;
  UNTIL done END REPEAT;
  CLOSE cur;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `heal_unit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `heal_unit`(board_unit_id INT,hp INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE hp_minus INT;
  DECLARE shield_minus INT;

  SELECT bu.game_id,bu.player_num,bu.max_health-bu.health,u.shield-bu.shield INTO g_id,p_num,hp_minus,shield_minus
  FROM board_units bu JOIN units u ON (bu.unit_id=u.id) WHERE bu.id=board_unit_id LIMIT 1;

  IF (unit_feature_check(board_unit_id,'paralich')=1) THEN

    CALL unit_feature_remove(board_unit_id,'paralich');
    CALL cmd_unit_remove_effect(g_id,board_unit_id,'paralich');
  ELSE
    IF (unit_feature_check(board_unit_id,'madness')=1) THEN

      CALL make_not_mad(board_unit_id);
    ELSE
      IF hp_minus>0 THEN

        CALL heal_unit_health(board_unit_id,(SELECT LEAST(hp_minus,hp) FROM DUAL));
      ELSE
        IF shield_minus>0 THEN

          CALL shield_on(board_unit_id);
        END IF;
      END IF;
    END IF;
  END IF;


END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `heal_unit_health` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `heal_unit_health`(board_unit_id INT, hp INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;

  SELECT bu.game_id,bu.player_num INTO g_id,p_num FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

  UPDATE board_units SET health=health+hp WHERE id=board_unit_id;
  CALL cmd_unit_set_health(g_id,p_num,board_unit_id);

  IF((SELECT current_procedure FROM active_players WHERE game_id=g_id LIMIT 1)='end_turn')THEN
    CALL cmd_log_add_independent_message(g_id, p_num, 'unit_restores_health', CONCAT_WS(';', log_unit(board_unit_id), hp));
  ELSE
    CALL cmd_log_add_message(g_id, p_num, 'unit_restores_health', CONCAT_WS(';', log_unit(board_unit_id), hp));
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `hit_building` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `hit_building`(board_building_id INT,p_num INT,damage INT)
BEGIN
  DECLARE g_id INT;
  DECLARE hp INT;

  SELECT bb.game_id,bb.health INTO g_id,hp FROM board_buildings bb WHERE bb.id=board_building_id LIMIT 1;

    IF damage>=hp THEN

      INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'make_damage',hp);
      CALL destroy_building(board_building_id,p_num);
    ELSE

      UPDATE board_buildings SET health=health-damage WHERE id=board_building_id;
      CALL cmd_building_set_health(g_id,p_num,board_building_id);

      INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'make_damage',damage);

    END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `hit_castle` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `hit_castle`(board_castle_id INT,p_num INT,damage INT)
BEGIN
  DECLARE g_id INT;
  DECLARE hp INT;
  DECLARE hp_reward INT;
  DECLARE mode_id INT;

  SELECT bb.game_id,bb.health INTO g_id,hp FROM board_buildings bb WHERE bb.id=board_castle_id LIMIT 1;
  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
  SELECT cfg.`value` INTO hp_reward FROM mode_config cfg WHERE cfg.param='castle hit reward' AND cfg.mode_id=mode_id;

    IF damage>=hp THEN

      UPDATE players SET gold=gold+hp*hp_reward WHERE game_id=g_id AND player_num=p_num;
      CALL cmd_player_set_gold(g_id,p_num);

      INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'make_damage',hp);
      CALL destroy_castle(board_castle_id,p_num);
    ELSE

      UPDATE board_buildings SET health=health-damage WHERE id=board_castle_id;
      CALL cmd_building_set_health(g_id,p_num,board_castle_id);

      UPDATE players SET gold=gold+damage*hp_reward WHERE game_id=g_id AND player_num=p_num;
      CALL cmd_player_set_gold(g_id,p_num);

      INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'make_damage',damage);

    END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `hit_unit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `hit_unit`(board_unit_id INT,p_num INT,damage INT)
BEGIN
  DECLARE g_id INT;
  DECLARE hp INT;
  DECLARE shld INT;

  SELECT bu.game_id,bu.health,bu.shield INTO g_id,hp,shld FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;


  IF shld>0 THEN
    CALL shield_off(board_unit_id);

    IF (unit_feature_check(board_unit_id,'paralich')=1) THEN
      CALL unit_feature_remove(board_unit_id,'paralich');
      CALL cmd_unit_remove_effect(g_id,board_unit_id,'paralich');
    END IF;
  ELSE
    IF damage>=hp THEN

      INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'make_damage',hp);
      CALL kill_unit(board_unit_id,p_num);
    ELSE

      UPDATE board_units SET health=health-damage WHERE id=board_unit_id;
      CALL cmd_unit_set_health(g_id,p_num,board_unit_id);

      IF (unit_feature_check(board_unit_id,'paralich')=1) THEN
        CALL unit_feature_remove(board_unit_id,'paralich');
        CALL cmd_unit_remove_effect(g_id,board_unit_id,'paralich');
      END IF;

      INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'make_damage',damage);

    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `initialization` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `initialization`(g_id INT)
BEGIN
  DECLARE started_game_status INT DEFAULT 2; 

  CALL init_player_num_teams(g_id);
  CALL init_player_gold(g_id);
  CALL init_decks(g_id);
  CALL init_buildings(g_id);
  CALL init_units(g_id);
  CALL init_landscape(g_id);
  CALL init_statistics(g_id);

  INSERT INTO active_players(game_id,player_num,turn,last_end_turn) SELECT g_id,MIN(player_num),0,CURRENT_TIMESTAMP FROM players WHERE game_id=g_id AND owner<>0; 
  UPDATE games SET `status_id`=started_game_status WHERE id=g_id;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `init_buildings` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `init_buildings`(g_id INT)
BEGIN
  DECLARE g_mode INT;

  DECLARE p_num INT;
  DECLARE x INT;
  DECLARE y INT;
  DECLARE rotation INT;
  DECLARE flip INT;
  DECLARE building_id INT;
  DECLARE board_building_id INT;
  DECLARE neutral_p_num INT DEFAULT 9;

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT cfg.player_num,cfg.x,cfg.y,cfg.rotation,cfg.flip,cfg.building_id FROM put_start_buildings_config cfg JOIN players p ON cfg.player_num=p.player_num WHERE p.game_id=g_id AND p.owner<>0 AND cfg.mode_id=g_mode;
  DECLARE cur_neutral CURSOR FOR SELECT cfg.player_num,cfg.x,cfg.y,cfg.rotation,cfg.flip,cfg.building_id FROM put_start_buildings_config cfg WHERE cfg.mode_id=g_mode AND cfg.player_num=neutral_p_num;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SELECT g.mode_id INTO g_mode FROM games g WHERE g.id=g_id LIMIT 1;

  OPEN cur;
  REPEAT
    FETCH cur INTO p_num,x,y,rotation,flip,building_id;
    IF NOT done THEN
      INSERT INTO board_buildings(game_id,player_num,building_id,rotation,flip)VALUES (g_id,p_num,building_id,rotation,flip);
      SET board_building_id=@@last_insert_id;

      CALL place_building_on_board(board_building_id,x,y,rotation,flip);

      INSERT INTO board_buildings_features(board_building_id,feature_id,param) SELECT board_building_id,bf.feature_id,bf.param FROM building_default_features bf WHERE bf.building_id=building_id;

      CALL count_income(board_building_id);
    END IF;
  UNTIL done END REPEAT;
  CLOSE cur;

  SET done=0;
  OPEN cur_neutral;
  REPEAT
    FETCH cur_neutral INTO p_num,x,y,rotation,flip,building_id;
    IF NOT done THEN
      INSERT INTO board_buildings(game_id,player_num,building_id,rotation,flip)VALUES (g_id,p_num,building_id,rotation,flip);
      SET board_building_id=@@last_insert_id;

      CALL place_building_on_board(board_building_id,x,y,rotation,flip);

      INSERT INTO board_buildings_features(board_building_id,feature_id,param) SELECT board_building_id,bf.feature_id,bf.param FROM building_default_features bf WHERE bf.building_id=building_id;
    END IF;
  UNTIL done END REPEAT;
  CLOSE cur_neutral;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `init_decks` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `init_decks`(g_id INT)
BEGIN
  DECLARE g_mode INT;

  DECLARE p_num INT;
  DECLARE crd_id INT;
  DECLARE qty INT; 
  DECLARE card_type VARCHAR(45) CHARSET utf8;

  DECLARE done INT DEFAULT 0;
  DECLARE cur_modes_cards CURSOR FOR SELECT cfg.card_id,cfg.quantity,c.`type` FROM modes_cards cfg JOIN cards c ON (cfg.card_id=c.id) WHERE cfg.mode_id=g_mode;
  DECLARE cur_player_deck CURSOR FOR SELECT cfg.player_num,cfg.quantity,cfg.`type` FROM player_start_deck_config cfg JOIN players p ON cfg.player_num=p.player_num WHERE p.game_id=g_id AND p.owner<>0 AND cfg.mode_id=g_mode;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SELECT g.mode_id INTO g_mode FROM games g WHERE g.id=g_id LIMIT 1;

  CREATE TEMPORARY TABLE tmp_deck_ordered (id INT AUTO_INCREMENT PRIMARY KEY, card_id INT, `type` varchar(45), player_num int null);
  CREATE TEMPORARY TABLE tmp_deck_shuffled (id INT AUTO_INCREMENT PRIMARY KEY, card_id INT, `type` varchar(45), player_num int null);

  OPEN cur_modes_cards;
  REPEAT
    FETCH cur_modes_cards INTO crd_id, qty, card_type;
    IF NOT done THEN
      WHILE qty > 0 DO
        INSERT INTO tmp_deck_ordered(card_id,`type`) VALUES(crd_id, card_type);
        SET qty = qty - 1;
      END WHILE;
    END IF;
  UNTIL done END REPEAT;
  CLOSE cur_modes_cards;

  SET done=0;

  INSERT INTO tmp_deck_shuffled(card_id,`type`) SELECT card_id,`type` FROM tmp_deck_ordered ORDER BY RAND();

  OPEN cur_player_deck;
  REPEAT
    FETCH cur_player_deck INTO p_num, qty, card_type;
    IF NOT done THEN
      IF(g_mode = 1)THEN 
        UPDATE tmp_deck_shuffled SET player_num=p_num WHERE `type`=card_type AND player_num IS NULL LIMIT qty;
      ELSE 
        UPDATE tmp_deck_shuffled SET player_num=p_num WHERE `type`=card_type AND player_num IS NULL
          AND card_id NOT IN
            (SELECT c.id FROM cards c JOIN buildings b ON (c.ref = b.id)
              WHERE c.`type`='b' AND b.`type`='obstacle')
          LIMIT qty;
      END IF;
    END IF;
  UNTIL done END REPEAT;
  CLOSE cur_player_deck;

  INSERT INTO player_deck(game_id,player_num,card_id)
  SELECT g_id,player_num,card_id FROM tmp_deck_shuffled WHERE player_num IS NOT NULL;

  INSERT INTO deck(game_id,card_id)
  SELECT g_id,card_id FROM tmp_deck_shuffled WHERE player_num IS NULL;

  INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`)
  SELECT g_id,pd.player_num,'initial_card',pd.card_id FROM player_deck pd WHERE pd.game_id = g_id;

  DROP TEMPORARY TABLE tmp_deck_ordered;
  DROP TEMPORARY TABLE tmp_deck_shuffled;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `init_landscape` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `init_landscape`(g_id INT)
BEGIN
  DECLARE g_mode INT;
  DECLARE building_id INT;
  DECLARE qty INT;
  DECLARE neutral_p_num INT DEFAULT 9;

  SELECT g.mode_id INTO g_mode FROM games g WHERE g.id=g_id LIMIT 1;

  SELECT b.id,bdf.param INTO building_id,qty
    FROM modes_cardless_buildings m
    JOIN buildings b ON m.building_id=b.id
    JOIN building_default_features bdf ON bdf.building_id=b.id
    JOIN building_features bf ON bdf.feature_id=bf.id
    WHERE m.mode_id=g_mode AND bf.code='for_initialization';

  IF(building_id IS NOT NULL)THEN
  BEGIN
    DECLARE i INT;
    DECLARE tree_x,tree_y INT;
    DECLARE board_building_id INT;
    DECLARE quart INT DEFAULT 0;

    CREATE TEMPORARY TABLE available_cells_for_trees (x INT, y INT);

    INSERT INTO available_cells_for_trees(x,y)
    SELECT x,y FROM allcoords a WHERE
      mode_id=g_mode
      AND NOT (
        (x<=3 AND y<=3) 
        OR (x>=16 AND y<=3) 
        OR (x>=16 AND y>=16) 
        OR (x<=3 AND y>=16) 
        OR (x BETWEEN 8 AND 11) 
        OR (y BETWEEN 8 AND 11)
        OR ((x BETWEEN 7 AND 12) AND (y BETWEEN 7 AND 12)));
    
    DELETE ac
        FROM available_cells_for_trees ac
        JOIN board b ON (ac.x = b.x) AND (ac.y = b.y)
        WHERE b.game_id = g_id;
    
    WHILE quart<4 DO
      SET i=qty;
      WHILE i>0 DO
        SELECT a.x,a.y INTO tree_x,tree_y
        FROM available_cells_for_trees a
        WHERE quart(a.x,a.y)=quart
        ORDER BY RAND()
        LIMIT 1;

        INSERT INTO board_buildings(game_id,player_num,building_id,rotation,flip)VALUES (g_id,neutral_p_num,building_id,0,0);
        SET board_building_id=@@last_insert_id;

        CALL place_building_on_board(board_building_id,tree_x,tree_y,0,0);

        IF NOT EXISTS(SELECT id FROM board WHERE game_id=g_id AND `type`<>'unit' AND ref=board_building_id) THEN 
          DELETE FROM board_buildings WHERE id=board_building_id;
          SET i=i+1;
        ELSE
          INSERT INTO board_buildings_features(board_building_id,feature_id,param) SELECT board_building_id,bf.feature_id,bf.param FROM building_default_features bf WHERE bf.building_id=building_id;

          DELETE ac
              FROM available_cells_for_trees ac
              JOIN board b ON (ac.x = b.x) AND (ac.y = b.y)
              WHERE b.game_id = g_id AND `type`<>'unit' AND ref=board_building_id;

        END IF;

        SET i=i-1;
      END WHILE;
      SET quart = quart+1;
    END WHILE;

    DROP TEMPORARY TABLE available_cells_for_trees;
  END;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `init_player_gold` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `init_player_gold`(g_id INT)
BEGIN
  DECLARE g_mode INT;

  SELECT mode_id INTO g_mode FROM games WHERE id=g_id;

  UPDATE players p,player_start_gold_config cfg SET p.gold=cfg.quantity
  WHERE p.game_id=g_id AND p.owner<>0 AND p.player_num=cfg.player_num AND cfg.mode_id=g_mode;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `init_player_num_teams` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `init_player_num_teams`(g_id INT)
BEGIN
  DECLARE player_count INT;
  DECLARE teams_count INT;
  DECLARE castles_count INT;

  DECLARE all_versus_all,random_teams,teammates_in_random_castles INT;

  SELECT COUNT(*) INTO player_count FROM players WHERE game_id=g_id AND owner<>0;
  SELECT m.max_players INTO castles_count FROM games g JOIN modes m ON (g.mode_id=m.id) WHERE g.id=g_id LIMIT 1;

  SET all_versus_all=game_feature_get_param(g_id,'all_versus_all');
  SET random_teams=game_feature_get_param(g_id,'random_teams');
  SET teammates_in_random_castles=game_feature_get_param(g_id,'teammates_in_random_castles');


  IF(all_versus_all=1)THEN
    SET teams_count=player_count;
  END IF;

  IF(random_teams=1)THEN
    SET teams_count=game_feature_get_param(g_id,'number_of_teams');
  END IF;

  IF((all_versus_all=1)OR(random_teams=1))THEN

    CREATE TEMPORARY TABLE player_teams (num INT AUTO_INCREMENT PRIMARY KEY)AUTO_INCREMENT=1 SELECT id FROM players WHERE game_id=g_id AND owner<>0 ORDER BY RAND();

    UPDATE players p,player_teams t SET p.team=(t.num-1) % teams_count
    WHERE p.id=t.id;

    DROP TEMPORARY TABLE player_teams;
  END IF;


  IF(teammates_in_random_castles=1)THEN
  BEGIN
    DECLARE i INT DEFAULT 0;
    CREATE TEMPORARY TABLE castles (castle_id INT PRIMARY KEY);

    WHILE i<castles_count DO
      INSERT INTO castles(castle_id) VALUES(i);
      SET i=i+1;
    END WHILE;

    CREATE TEMPORARY TABLE player_shuffled (num INT AUTO_INCREMENT PRIMARY KEY)AUTO_INCREMENT=1 SELECT id FROM players WHERE game_id=g_id AND owner<>0 ORDER BY RAND();
    CREATE TEMPORARY TABLE castles_shuffled (num INT AUTO_INCREMENT PRIMARY KEY)AUTO_INCREMENT=1 SELECT castle_id FROM castles ORDER BY RAND();

    UPDATE players p,player_shuffled ps,castles_shuffled cs SET p.player_num=cs.castle_id
    WHERE p.id=ps.id AND ps.num=cs.num;

    DROP TEMPORARY TABLE castles;
    DROP TEMPORARY TABLE player_shuffled;
    DROP TEMPORARY TABLE castles_shuffled;
  END;
  ELSE
  BEGIN

    DECLARE i INT DEFAULT 0;

    
    CREATE TEMPORARY TABLE cycle_castles (castle_id INT PRIMARY KEY);

    CREATE TEMPORARY TABLE cycle_castles_with_number (num INT AUTO_INCREMENT PRIMARY KEY,castle_id INT);

    CREATE TEMPORARY TABLE free_players (num INT AUTO_INCREMENT PRIMARY KEY)AUTO_INCREMENT=1 SELECT id,player_num,team FROM players WHERE game_id=g_id AND owner<>0 ORDER BY RAND();

    WHILE i<player_count DO
      INSERT INTO cycle_castles(castle_id) VALUES(FLOOR((castles_count/player_count)*i));
      SET i=i+1;
    END WHILE;

    WHILE (SELECT COUNT(*) FROM free_players)>0 DO
    BEGIN
      DECLARE current_team INT;
      DECLARE team_player_count INT;
      DECLARE cur_player_id INT;
      DECLARE cur_castle_id INT;
      DECLARE castles_count INT;
      DECLARE cur_castle_number INT;

      DECLARE done INT DEFAULT 0;
      DECLARE cur CURSOR FOR SELECT fp.id FROM free_players fp WHERE fp.team=current_team;
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

      SELECT f.team,COUNT(*) INTO current_team,team_player_count FROM free_players f
      GROUP BY f.team
      ORDER BY COUNT(*) DESC, RAND() LIMIT 1;

      SET i=0;
      SELECT COUNT(*) INTO castles_count FROM cycle_castles;

      TRUNCATE TABLE cycle_castles_with_number;
      INSERT INTO cycle_castles_with_number (castle_id) SELECT castle_id FROM cycle_castles;

      OPEN cur;
      REPEAT
        FETCH cur INTO cur_player_id;
        IF NOT done THEN
          
          SET cur_castle_number=FLOOR(castles_count/team_player_count*i)+1;

          SELECT castle_id INTO cur_castle_id FROM cycle_castles_with_number WHERE num=cur_castle_number;

          UPDATE free_players SET player_num=cur_castle_id WHERE id=cur_player_id;
          SET i=i+1;
        END IF;
      UNTIL done END REPEAT;
      CLOSE cur;

      UPDATE players p,free_players fp SET p.player_num=fp.player_num
      WHERE p.id=fp.id AND fp.team=current_team;

      DELETE FROM cycle_castles WHERE castle_id IN (SELECT player_num FROM free_players WHERE team=current_team);
      DELETE FROM free_players WHERE team=current_team;

    END;
    END WHILE;

    DROP TEMPORARY TABLE cycle_castles;
    DROP TEMPORARY TABLE cycle_castles_with_number;
    DROP TEMPORARY TABLE free_players;

  END;
  END IF;

  UPDATE players SET move_order = player_num WHERE game_id = g_id AND owner<>0;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `init_statistics` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `init_statistics`(g_id INT)
BEGIN

  INSERT INTO statistic_players(game_id, player_num, player_name)
    SELECT g_id, p.player_num, p.name
      FROM players p
      WHERE p.game_id = g_id AND p.owner <> 0;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `init_units` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `init_units`(g_id INT)
BEGIN
  DECLARE g_mode INT;

  DECLARE p_num INT;
  DECLARE x INT;
  DECLARE y INT;
  DECLARE unit_id INT;
  DECLARE size INT;
  DECLARE board_unit_id INT;
  DECLARE no_card_feature_id INT;

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT cfg.player_num,cfg.x,cfg.y,cfg.unit_id,u.size FROM put_start_units_config cfg JOIN units u ON cfg.unit_id=u.id JOIN players p ON cfg.player_num=p.player_num WHERE p.game_id=g_id AND p.owner<>0 AND cfg.mode_id=g_mode;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SELECT mode_id INTO g_mode FROM games WHERE id=g_id LIMIT 1;

  OPEN cur;
  REPEAT
    FETCH cur INTO p_num,x,y,unit_id,size;
    IF NOT done THEN
      INSERT INTO board_units(game_id,player_num,unit_id) VALUES (g_id,p_num,unit_id);
      SET board_unit_id=@@last_insert_id;

      INSERT INTO board_units_features(board_unit_id,feature_id,param)
      SELECT board_unit_id,uf.feature_id,uf.param FROM unit_default_features uf WHERE uf.unit_id=unit_id;

      INSERT INTO board(game_id,x,y,`type`,ref)
      SELECT g_id,a.x,a.y,'unit',board_unit_id
      FROM allcoords a
      WHERE a.mode_id=g_mode
      AND a.x BETWEEN x AND x+size-1
      AND a.y BETWEEN y AND y+size-1;

    END IF;
  UNTIL done END REPEAT;
  CLOSE cur;


  SET no_card_feature_id=unit_feature_get_id_by_code('no_card');
  INSERT INTO board_units_features(board_unit_id,feature_id)
  SELECT bu.id,no_card_feature_id FROM board_units bu WHERE bu.game_id=g_id;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `kill_unit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `kill_unit`(bu_id INT, p_num INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p2_num INT; 
  DECLARE crd_id INT;
  DECLARE grave_id INT;
  DECLARE u_id INT;
  DECLARE reward INT DEFAULT 0;
  DECLARE kill_reward_divisor INT DEFAULT 2; 
  DECLARE binded_unit_id INT;

  SELECT game_id,player_num,card_id,unit_id INTO g_id,p2_num,crd_id,u_id FROM board_units WHERE id=bu_id LIMIT 1;

  CALL cmd_log_add_message(g_id, p_num, 'unit_killed', log_unit(bu_id));

  IF crd_id IS NOT NULL THEN
    IF unit_feature_check(bu_id,'goes_to_deck_on_death') = 1 THEN
      INSERT INTO deck(game_id,card_id) VALUES(g_id,crd_id);
    ELSE 
      INSERT INTO graves(game_id, card_id, player_num_when_killed, turn_when_killed)
          VALUES(g_id, crd_id, get_current_p_num(g_id), get_current_turn(g_id));
      SET grave_id=@@last_insert_id;
      INSERT INTO grave_cells(grave_id,x,y) SELECT grave_id,b.x,b.y FROM board b WHERE game_id=g_id AND b.`type`='unit' AND b.ref=bu_id;
      CALL cmd_add_to_grave(g_id,p_num,grave_id);
    END IF;
  END IF;

  CALL cmd_kill_unit(g_id,p_num,bu_id);

  DELETE FROM board WHERE game_id=g_id AND `type`='unit' AND ref=bu_id;
  DELETE FROM board_units_features WHERE board_unit_id=bu_id;
  DELETE FROM board_units WHERE id=bu_id;


  SELECT IFNULL(cost/kill_reward_divisor,0) INTO reward FROM cards WHERE `type`='u' AND ref=u_id LIMIT 1;


  IF ((SELECT owner FROM players WHERE game_id=g_id AND player_num=p2_num LIMIT 1)<>1)
    AND NOT EXISTS (SELECT id FROM board_units WHERE game_id=g_id AND player_num=p2_num)
    AND NOT EXISTS (SELECT id FROM board_buildings WHERE game_id=g_id AND player_num=p2_num)
  THEN 
    SET reward=reward+(SELECT gold FROM players WHERE game_id=g_id AND player_num=p2_num LIMIT 1);
    DELETE FROM players WHERE game_id=g_id AND player_num=p2_num;
    CALL cmd_delete_player(g_id,p2_num);
  END IF;

  IF(reward>0 AND EXISTS (SELECT id FROM players p WHERE p.game_id=g_id AND p.player_num=p_num))THEN
    UPDATE players SET gold=gold+reward WHERE game_id=g_id AND player_num=p_num;
    CALL cmd_player_set_gold(g_id,p_num);
  END IF;


  DELETE FROM board_units_features WHERE feature_id IN(unit_feature_get_id_by_code('bind_target'),unit_feature_get_id_by_code('attack_target')) AND param=bu_id;


  IF EXISTS(SELECT id FROM board_units_features WHERE feature_id=unit_feature_get_id_by_code('under_control') AND param=bu_id LIMIT 1)THEN
    CALL zombies_make_mad(g_id,bu_id);
  END IF;

  INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'kill_unit',p2_num);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `lake_summon_frogs` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `lake_summon_frogs`(g_id INT,  board_building_id INT)
BEGIN
  DECLARE spawned_count INT;
  DECLARE dice INT;

  IF EXISTS(SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id AND (unit_feature_check(bu.id,'parent_building')=0 OR unit_feature_get_param(bu.id,'parent_building')<>board_building_id) LIMIT 1) THEN
    SET spawned_count = get_number_of_spawned_creatures(board_building_id);
    SET dice = POW(6, CASE WHEN spawned_count IN(0,1,2,3) THEN 1 ELSE spawned_count-2 END);
    IF (get_random_int_between(1, dice) = 1) THEN
      CALL summon_one_creature_by_config(board_building_id);
    END IF;
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `magical_damage` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `magical_damage`(g_id INT,   p_num INT,   x INT,   y INT,   damage INT)
BEGIN
  DECLARE aim_id INT;
  DECLARE aim_type VARCHAR(45);
  DECLARE damage_final INT;
  DECLARE aim_health INT;
  DECLARE aim_shield INT DEFAULT 0;

  SET damage_final=damage * get_magic_field_factor(g_id, p_num, x, y);

  SELECT b.`type`,b.ref INTO aim_type,aim_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y LIMIT 1;

  CASE
    WHEN aim_type='unit' THEN
    BEGIN
      SELECT shield,health INTO aim_shield,aim_health FROM board_units bu WHERE bu.id=aim_id LIMIT 1;
    END;
    WHEN aim_type='building' OR aim_type='castle' THEN
    BEGIN
      SELECT bb.health INTO aim_health FROM board_buildings bb WHERE bb.id=aim_id LIMIT 1;
    END;
  END CASE;

  IF(aim_shield=0 AND damage_final<aim_health AND NOT(aim_type='unit' AND unit_feature_check(aim_id,'magic_immunity')=1))THEN

    CASE aim_type
      WHEN 'building' THEN
        CALL cmd_log_add_message(g_id, p_num, 'building_damage', CONCAT_WS(';', log_building(aim_id), damage_final));
      WHEN 'unit' THEN
        CALL cmd_log_add_message(g_id, p_num, 'unit_damage', CONCAT_WS(';', log_unit(aim_id), damage_final));
    END CASE;

  END IF;

  CASE aim_type
    WHEN 'building' THEN CALL hit_building(aim_id,p_num,damage_final);
    WHEN 'unit' THEN
      IF (unit_feature_check(aim_id,'magic_immunity')=0) THEN 
        CALL hit_unit(aim_id,p_num,damage_final);
      ELSE
        CALL cmd_magic_resistance_log(g_id,p_num,aim_id);
      END IF;
  END CASE;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `magical_heal` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `magical_heal`(g_id INT, p_num INT, x INT, y INT, hp INT)
BEGIN
  DECLARE aim_id INT;
  DECLARE hp_final INT;
  DECLARE is_hurt INT DEFAULT 1;
  DECLARE hp_minus INT;
  DECLARE shield_minus INT;

  SET hp_final=hp * get_magic_field_factor(g_id, p_num, x, y);

  SELECT b.ref INTO aim_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y LIMIT 1;

    SELECT bu.max_health-bu.health,u.shield-bu.shield INTO hp_minus,shield_minus
    FROM board_units bu JOIN units u ON (bu.unit_id=u.id) WHERE bu.id=aim_id LIMIT 1;

    IF(unit_feature_check(aim_id,'paralich')=0 AND unit_feature_check(aim_id,'madness')=0 AND hp_minus=0 AND shield_minus=0)THEN
      SET is_hurt=0;
    END IF;

    IF (unit_feature_check(aim_id,'magic_immunity')=1 AND is_hurt=1) THEN 
      CALL cmd_magic_resistance_log(g_id,p_num,aim_id);
    ELSE
      IF (unit_feature_check(aim_id,'mechanical')=1 AND is_hurt=1) THEN 
        CALL cmd_mechanical_log(g_id,p_num,aim_id);
      ELSE
        CALL heal_unit(aim_id,hp_final);
      END IF;
    END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `magical_shield_on` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `magical_shield_on`(g_id INT,  p_num INT,  x INT,  y INT)
BEGIN
  DECLARE aim_id INT;
  DECLARE shields INT;

  SET shields= 1 * get_magic_field_factor(g_id, p_num, x, y);

  SELECT b.ref INTO aim_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y LIMIT 1;

    IF (unit_feature_check(aim_id,'magic_immunity')=0) THEN 
      WHILE shields>0 DO
        CALL shield_on(aim_id);
        SET shields=shields-1;
      END WHILE;
    ELSE
      CALL cmd_magic_resistance_log(g_id,p_num,aim_id);
    END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `magic_kill_unit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `magic_kill_unit`(board_unit_id INT,p_num INT)
BEGIN
  DECLARE g_id INT;
  DECLARE shield INT;

  SELECT bu.game_id,bu.shield INTO g_id,shield FROM board_units bu WHERE id=board_unit_id LIMIT 1;

          IF (unit_feature_check(board_unit_id,'magic_immunity')=0) THEN 
            IF shield>0 THEN
              CALL shield_off(board_unit_id);
            ELSE
              CALL kill_unit(board_unit_id,p_num);
            END IF;
          ELSE
            CALL cmd_magic_resistance_log(g_id,p_num,board_unit_id);
          END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `magic_total_heal` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `magic_total_heal`(board_unit_id INT, p_num INT)
BEGIN
  DECLARE g_id INT;

  SELECT bu.game_id INTO g_id FROM board_units bu WHERE id=board_unit_id LIMIT 1;

  IF (unit_feature_check(board_unit_id,'magic_immunity')=0) THEN 
    CALL total_heal(board_unit_id);
  ELSE
    CALL cmd_magic_resistance_log(g_id,p_num,board_unit_id);
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `magic_total_heal_all_units_of_player` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `magic_total_heal_all_units_of_player`(g_id INT,  p_num INT)
BEGIN
  DECLARE board_unit_id INT;

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT bu.id FROM board_units bu WHERE
    bu.game_id=g_id
    AND (
      bu.player_num = p_num 
      OR (
        unit_feature_check(bu.id,'madness')=1
        AND unit_feature_get_param(bu.id,'madness')=p_num));
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  OPEN cur;
  REPEAT
    FETCH cur INTO board_unit_id;
    IF NOT done THEN
      CALL magic_total_heal(board_unit_id,p_num);
    END IF;
  UNTIL done END REPEAT;
  CLOSE cur;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `make_mad` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `make_mad`(board_unit_id INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE u_id INT;

  SELECT bu.game_id,bu.player_num,bu.unit_id INTO g_id,p_num,u_id FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

  IF (unit_feature_check(board_unit_id,'madness')=0) THEN 
    CALL unit_feature_set(board_unit_id,'madness',p_num);
    CALL cmd_unit_add_effect(g_id,board_unit_id,'madness');

    IF EXISTS(SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id AND bu.player_num=p_num AND bu.id<>board_unit_id LIMIT 1)
      OR EXISTS(SELECT bb.id FROM board_buildings bb WHERE bb.game_id=g_id AND bb.player_num=p_num LIMIT 1) THEN

    BEGIN
      DECLARE new_player,team,mad_move_order INT;
      DECLARE mad_name VARCHAR(45) CHARSET utf8 DEFAULT '{mad} {$u_id}';

      SET mad_name=REPLACE(mad_name,'$u_id', u_id);
      SET team = get_new_team_number(g_id);
      SELECT CASE WHEN MAX(p.player_num)<10 THEN 10 ELSE MAX(p.player_num)+1 END INTO new_player FROM players p WHERE p.game_id=g_id;
      SET mad_move_order = get_move_order_for_new_npc(g_id, (SELECT player_num FROM active_players WHERE game_id=g_id LIMIT 1));

      UPDATE players SET move_order = move_order + 1 WHERE game_id = g_id AND move_order >= mad_move_order;
      INSERT INTO players(game_id,player_num,name,gold,owner,team,move_order,language_id) VALUES(g_id,new_player,mad_name,0,2,team,mad_move_order,get_player_language_id(g_id,p_num));
      CALL cmd_add_player(g_id,new_player);

      UPDATE board_units SET player_num=new_player WHERE id=board_unit_id;
      CALL cmd_unit_set_owner(g_id,p_num,board_unit_id);

      IF EXISTS(SELECT id FROM board_units_features WHERE feature_id=unit_feature_get_id_by_code('under_control') AND param=board_unit_id LIMIT 1)THEN
        CALL zombies_make_mad(g_id,board_unit_id);
      END IF;
    END;
    END IF;
  ELSE
    CALL cmd_log_add_message(g_id, p_num, 'unit_already_mad', log_unit(board_unit_id));
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `make_not_mad` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `make_not_mad`(board_unit_id INT)
BEGIN
  DECLARE g_id INT;
  DECLARE mad_p_num,normal_p_num INT;

  SELECT bu.game_id,bu.player_num,unit_feature_get_param(board_unit_id,'madness') INTO g_id,mad_p_num,normal_p_num FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

  IF (normal_p_num IS NOT NULL) THEN 

    CALL unit_feature_remove(board_unit_id,'madness');
    CALL cmd_unit_remove_effect(g_id,board_unit_id,'madness');

    IF (mad_p_num<>normal_p_num) THEN
    BEGIN

      DECLARE mad_gold INT;

      UPDATE board_units SET player_num=normal_p_num WHERE id=board_unit_id;
      CALL cmd_unit_set_owner(g_id,normal_p_num,board_unit_id);

      SELECT p.gold INTO mad_gold FROM players p WHERE p.game_id=g_id AND p.player_num=mad_p_num LIMIT 1;
      IF (mad_gold>0) THEN
        UPDATE players SET gold=gold+mad_gold WHERE game_id=g_id AND player_num=normal_p_num;
        CALL cmd_player_set_gold(g_id,normal_p_num);
      END IF;

      DELETE FROM players WHERE game_id=g_id AND player_num=mad_p_num;
      CALL cmd_delete_player(g_id,mad_p_num);


      IF EXISTS(SELECT id FROM board_units_features WHERE feature_id=unit_feature_get_id_by_code('under_control') AND param=board_unit_id LIMIT 1)THEN
        CALL zombies_change_player_to_nec(board_unit_id);
      END IF;

    END;
    END IF;

  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `mode_copy` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `mode_copy`(old_mode_id INT,  mode_name VARCHAR(45) CHARSET utf8,  copy_cards_units_buildings INT)
BEGIN
    DECLARE new_mode_id INT;

    INSERT INTO modes(name,min_players,max_players)
    SELECT mode_name,m.min_players,m.max_players FROM modes m WHERE m.id = old_mode_id;
    SET new_mode_id = @@last_insert_id;

    INSERT INTO player_start_gold_config(player_num,quantity,mode_id)
    SELECT c.player_num,c.quantity,new_mode_id FROM player_start_gold_config c WHERE c.mode_id = old_mode_id;

    INSERT INTO player_start_deck_config(player_num,quantity,`type`,mode_id)
    SELECT c.player_num,c.quantity,c.`type`,new_mode_id FROM player_start_deck_config c WHERE c.mode_id = old_mode_id;

    INSERT INTO modes_other_procedures(mode_id,procedure_id)
    SELECT new_mode_id,m.procedure_id FROM modes_other_procedures m WHERE m.mode_id = old_mode_id;

    INSERT INTO allcoords(x,y,mode_id)
    SELECT a.x,a.y,new_mode_id FROM allcoords a WHERE a.mode_id = old_mode_id;

    INSERT INTO appear_points(player_num,x,y,direction_into_board_x,direction_into_board_y,mode_id)
    SELECT a.player_num,a.x,a.y,a.direction_into_board_x,a.direction_into_board_y,new_mode_id FROM appear_points a WHERE a.mode_id = old_mode_id;

    INSERT INTO mode_config(param,`value`,mode_id)
    SELECT c.param,c.`value`,new_mode_id FROM mode_config c WHERE c.mode_id = old_mode_id;

    INSERT INTO statistic_values_config(player_num,chart_id,measure_id,color,name,mode_id)
    SELECT c.player_num,c.chart_id,c.measure_id,c.color,c.name,new_mode_id FROM statistic_values_config c WHERE c.mode_id = old_mode_id;

    IF(copy_cards_units_buildings = 0)THEN
        INSERT INTO modes_cards(mode_id,card_id,quantity)
        SELECT new_mode_id,mc.card_id,mc.quantity FROM modes_cards mc WHERE mc.mode_id=old_mode_id;

        INSERT INTO put_start_buildings_config(player_num,x,y,rotation,flip,building_id,mode_id)
        SELECT c.player_num,c.x,c.y,c.rotation,c.flip,c.building_id,new_mode_id FROM put_start_buildings_config c WHERE c.mode_id=old_mode_id;

        INSERT INTO modes_cardless_buildings(mode_id,building_id)
        SELECT new_mode_id,cb.building_id FROM modes_cardless_buildings cb WHERE cb.mode_id=old_mode_id;

        INSERT INTO put_start_units_config(player_num,x,y,unit_id,mode_id)
        SELECT c.player_num,c.x,c.y,c.unit_id,new_mode_id FROM put_start_units_config c WHERE c.mode_id=old_mode_id;

        INSERT INTO modes_cardless_units(mode_id,unit_id)
        SELECT new_mode_id,cu.unit_id FROM modes_cardless_units cu WHERE cu.mode_id=old_mode_id;

        INSERT INTO summon_cfg(building_id,unit_id,`count`,owner,mode_id)
        SELECT c.building_id,c.unit_id,c.`count`,c.owner,new_mode_id FROM summon_cfg c WHERE c.mode_id=old_mode_id;

        INSERT INTO attack_bonus(mode_id,unit_id,aim_type,aim_id,dice_max,chance,critical_chance,damage_bonus,critical_bonus,priority,`comment`)
        SELECT new_mode_id,ab.unit_id,ab.aim_type,ab.aim_id,ab.dice_max,ab.chance,ab.critical_chance,ab.damage_bonus,ab.critical_bonus,ab.priority,ab.`comment` FROM attack_bonus ab WHERE ab.mode_id = old_mode_id;

    ELSE
    BEGIN
        DECLARE card_id_old INT;
        DECLARE card_id_new INT;
        DECLARE card_image VARCHAR(45) CHARSET utf8;
        DECLARE card_cost INT;
        DECLARE card_type VARCHAR(45) CHARSET utf8;
        DECLARE card_ref INT;

        DECLARE building_id_old INT;
        DECLARE building_id_new INT;
        DECLARE building_health INT;
        DECLARE building_radius INT;
        DECLARE building_x_len INT;
        DECLARE building_y_len INT;
        DECLARE building_shape VARCHAR(400) CHARSET utf8;
        DECLARE building_type VARCHAR(45) CHARSET utf8;
        DECLARE building_ui_code VARCHAR(45) CHARSET utf8;

        DECLARE unit_id_old INT;
        DECLARE unit_id_new INT;
        DECLARE unit_moves INT;
        DECLARE unit_health INT;
        DECLARE unit_attack INT;
        DECLARE unit_size INT;
        DECLARE unit_shield INT;
        DECLARE unit_ui_code VARCHAR(45) CHARSET utf8;

        DECLARE done INT DEFAULT 0;
        DECLARE cur_cards CURSOR FOR SELECT c.id,c.image,c.cost,c.`type`,c.ref FROM vw_mode_cards c WHERE c.mode_id=old_mode_id;
        DECLARE cur_buildings CURSOR FOR SELECT b.id,b.health,b.radius,b.x_len,b.y_len,b.shape, b.`type`,b.ui_code FROM vw_mode_buildings b WHERE b.mode_id=old_mode_id;
        DECLARE cur_units CURSOR FOR SELECT u.id,u.moves,u.health,u.attack,u.size,u.shield,u.ui_code FROM vw_mode_units u WHERE u.mode_id=old_mode_id;
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

        CREATE TEMPORARY TABLE cards_ids (id_old INT,id_new INT);
        CREATE TEMPORARY TABLE buildings_ids (id_old INT,id_new INT);
        CREATE TEMPORARY TABLE units_ids (id_old INT,id_new INT);

        OPEN cur_cards;
        REPEAT
            FETCH cur_cards INTO card_id_old,card_image,card_cost,card_type,card_ref;
            IF NOT done THEN
                INSERT INTO cards(image,cost,`type`,ref,name,description)
                VALUES(card_image,card_cost,card_type,card_ref,card_name,card_description);
                SET card_id_new = @@last_insert_id;

                INSERT INTO cards_ids(id_old,id_new) VALUES(card_id_old,card_id_new);

                INSERT INTO cards_procedures(card_id,procedure_id)
                SELECT card_id_new,cp.procedure_id FROM cards_procedures cp WHERE cp.card_id=card_id_old;

                INSERT INTO modes_cards(mode_id,card_id,quantity)
                SELECT new_mode_id,card_id_new,mc.quantity FROM modes_cards mc WHERE mc.mode_id=old_mode_id AND mc.card_id=card_id_old;
                
                INSERT INTO cards_i18n(card_id,language_id,name,description)
                SELECT card_id_new, ci.language_id, ci.name, ci.description FROM cards_i18n ci WHERE ci.card_id = card_id_old;
            END IF;
        UNTIL done END REPEAT;
        CLOSE cur_cards;
        SET done=0;

        OPEN cur_buildings;
        REPEAT
            FETCH cur_buildings INTO building_id_old,building_health,building_radius,building_x_len,building_y_len,building_shape,building_type,building_ui_code;
            IF NOT done THEN
                INSERT INTO buildings(health,radius,x_len,y_len,shape,`type`,ui_code)
                VALUES(building_health,building_radius,building_x_len,building_y_len,building_shape,building_type,building_ui_code);
                SET building_id_new = @@last_insert_id;

                INSERT INTO buildings_ids(id_old,id_new) VALUES(building_id_old,building_id_new);

                INSERT INTO buildings_procedures(building_id,procedure_id)
                SELECT building_id_new,bp.procedure_id FROM buildings_procedures bp WHERE bp.building_id=building_id_old;

                INSERT INTO building_default_features(building_id,feature_id,param)
                SELECT building_id_new,f.feature_id,f.param FROM building_default_features f WHERE f.building_id=building_id_old;

                INSERT INTO put_start_buildings_config(player_num,x,y,rotation,flip,building_id,mode_id)
                SELECT c.player_num,c.x,c.y,c.rotation,c.flip,building_id_new,new_mode_id FROM put_start_buildings_config c WHERE c.mode_id=old_mode_id AND c.building_id=building_id_old;

                INSERT INTO modes_cardless_buildings(mode_id,building_id)
                SELECT new_mode_id,building_id_new FROM modes_cardless_buildings cb WHERE cb.mode_id=old_mode_id AND cb.building_id=building_id_old;

                INSERT INTO buildings_i18n(building_id, language_id, name, description, log_short_name)
                SELECT building_id_new, bi.language_id, bi.name, bi.description, bi.log_short_name FROM buildings_i18n bi WHERE bi.building_id = building_id_old;
            END IF;
        UNTIL done END REPEAT;
        CLOSE cur_buildings;
        SET done=0;

        OPEN cur_units;
        REPEAT
            FETCH cur_units INTO unit_id_old,unit_moves,unit_health,unit_attack,unit_size,unit_shield,unit_ui_code;
            IF NOT done THEN
                INSERT INTO units(moves,health,attack,size,shield,ui_code)
                VALUES(unit_moves,unit_health,unit_attack,unit_size,unit_shield,unit_ui_code);
                SET unit_id_new = @@last_insert_id;

                INSERT INTO units_ids(id_old,id_new) VALUES(unit_id_old,unit_id_new);

                INSERT INTO units_procedures(unit_id,procedure_id,`default`)
                SELECT unit_id_new,up.procedure_id,up.`default` FROM units_procedures up WHERE up.unit_id=unit_id_old;

                INSERT INTO unit_default_features(unit_id,feature_id,param)
                SELECT unit_id_new,f.feature_id,f.param FROM unit_default_features f WHERE f.unit_id=unit_id_old;

                INSERT INTO put_start_units_config(player_num,x,y,unit_id,mode_id)
                SELECT c.player_num,c.x,c.y,unit_id_new,new_mode_id FROM put_start_units_config c WHERE c.mode_id=old_mode_id AND c.unit_id=unit_id_old;

                INSERT INTO modes_cardless_units(mode_id,unit_id)
                SELECT new_mode_id,unit_id_new FROM modes_cardless_units cu WHERE cu.mode_id=old_mode_id AND cu.unit_id=unit_id_old;

                INSERT INTO dic_unit_phrases(unit_id,phrase,language_id)
                SELECT unit_id_new,p.phrase,p.language_id FROM dic_unit_phrases p WHERE p.unit_id=unit_id_old;

                INSERT INTO unit_level_up_experience(unit_id,level,experience)
                SELECT unit_id_new,l.level,l.experience FROM unit_level_up_experience l WHERE l.unit_id=unit_id_old;

                INSERT INTO units_i18n(unit_id, language_id, name, description, log_short_name, log_name_accusative)
                SELECT unit_id_new, ui.language_id, ui.name, ui.description, ui.log_short_name, ui.log_name_accusative FROM units_i18n ui WHERE ui.unit_id = unit_id_old;
            END IF;
        UNTIL done END REPEAT;
        CLOSE cur_units;

        UPDATE cards,cards_ids,buildings_ids
        SET cards.ref=buildings_ids.id_new
        WHERE cards.id=cards_ids.id_new AND cards.`type`='b' AND cards.ref=buildings_ids.id_old;

        UPDATE cards,cards_ids,units_ids
        SET cards.ref=units_ids.id_new
        WHERE cards.id=cards_ids.id_new AND cards.`type`='u' AND cards.ref=units_ids.id_old;

        INSERT INTO summon_cfg(building_id,unit_id,`count`,owner,mode_id)
        SELECT b.id_new,u.id_new,c.`count`,c.owner,new_mode_id
        FROM summon_cfg c
        JOIN buildings_ids b ON c.building_id=b.id_old
        JOIN units_ids u ON c.unit_id=u.id_old
        WHERE c.mode_id=old_mode_id;

        INSERT INTO attack_bonus(mode_id,unit_id,aim_type,aim_id,dice_max,chance,critical_chance,damage_bonus,critical_bonus,priority,`comment`)
        SELECT new_mode_id,u.id_new,a.aim_type,a.aim_id,a.dice_max,a.chance,a.critical_chance,a.damage_bonus,a.critical_bonus,a.priority,a.`comment`
        FROM attack_bonus a
        LEFT JOIN units_ids u ON a.unit_id=u.id_old
        WHERE a.mode_id=old_mode_id AND a.aim_type IS NULL;

        INSERT INTO attack_bonus(mode_id,unit_id,aim_type,aim_id,dice_max,chance,critical_chance,damage_bonus,critical_bonus,priority,`comment`)
        SELECT new_mode_id,u.id_new,a.aim_type,a.aim_id,a.dice_max,a.chance,a.critical_chance,a.damage_bonus,a.critical_bonus,a.priority,a.`comment`
        FROM attack_bonus a
        LEFT JOIN units_ids u ON a.unit_id=u.id_old
        WHERE a.mode_id=old_mode_id AND a.aim_type='unit';

        UPDATE attack_bonus,units_ids
        SET aim_id=units_ids.id_new
        WHERE mode_id=new_mode_id AND aim_type='unit' AND attack_bonus.aim_id=units_ids.id_old;

        INSERT INTO attack_bonus(mode_id,unit_id,aim_type,aim_id,dice_max,chance,critical_chance,damage_bonus,critical_bonus,priority,`comment`)
        SELECT new_mode_id,u.id_new,a.aim_type,aim_b.id_new,a.dice_max,a.chance,a.critical_chance,a.damage_bonus,a.critical_bonus,a.priority,a.`comment`
        FROM attack_bonus a
        LEFT JOIN units_ids u ON a.unit_id=u.id_old
        JOIN buildings_ids aim_b ON a.aim_id=aim_b.id_old
        WHERE a.mode_id=old_mode_id AND a.aim_type IS NOT NULL AND a.aim_type<>'unit';

        DROP TEMPORARY TABLE cards_ids;
        DROP TEMPORARY TABLE buildings_ids;
        DROP TEMPORARY TABLE units_ids;

    END;
    END IF;


END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `mode_delete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `mode_delete`(mode_id INT, delete_not_used_cards_units_buildings INT)
BEGIN
  DELETE FROM modes WHERE id=mode_id;

  IF(delete_not_used_cards_units_buildings = 1)THEN
    DELETE FROM cards WHERE id NOT IN (SELECT card_id FROM modes_cards);
    
    CREATE TEMPORARY TABLE tmp_buildings_to_delete (id INT);
    CREATE TEMPORARY TABLE tmp_units_to_delete (id INT);

    INSERT INTO tmp_buildings_to_delete (id)
      SELECT id FROM buildings WHERE id NOT IN (SELECT id FROM vw_mode_buildings);

    INSERT INTO tmp_units_to_delete (id)
      SELECT id FROM units WHERE id NOT IN (SELECT id FROM vw_mode_units);

    DELETE FROM buildings WHERE id IN (SELECT id FROM tmp_buildings_to_delete);
    DELETE FROM units WHERE id IN (SELECT id FROM tmp_units_to_delete);

    DROP TEMPORARY TABLE tmp_buildings_to_delete;
    DROP TEMPORARY TABLE tmp_units_to_delete;

  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `mountains_summon_troll` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `mountains_summon_troll`(g_id INT,  board_building_id INT)
BEGIN
  DECLARE spawned_count INT;
  DECLARE dice INT;

  IF EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.`type`='building' LIMIT 1) THEN
    SET spawned_count = get_number_of_spawned_creatures(board_building_id);
    SET dice = POW(6, spawned_count + 1);
    IF (get_random_int_between(1, dice) = 1) THEN
      CALL summon_one_creature_by_config(board_building_id);
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `move_building_randomly` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `move_building_randomly`(board_building_id INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE x_len,y_len INT;
  DECLARE shape VARCHAR(400);
  DECLARE rotation INT DEFAULT 0;
  DECLARE flip INT DEFAULT 0;
  DECLARE x,y,b_x,b_y INT;

  SELECT b.x_len, b.y_len, b.shape, bb.game_id, bb.player_num INTO x_len, y_len, shape, g_id, p_num FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.id=board_building_id LIMIT 1;

  SELECT b.x,b.y INTO b_x,b_y FROM board b WHERE b.game_id=g_id AND b.`type` IN ('building','obstacle') AND b.ref=board_building_id LIMIT 1;

  UPDATE board SET ref=0 WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=board_building_id;

  WHILE NOT EXISTS (SELECT id FROM board WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=board_building_id LIMIT 1) DO
    IF shape='1' THEN
      SET x = get_random_int_between(0, 19);
      SET y = get_random_int_between(0, 19);
    ELSE
      SET rotation = get_random_int_between(0, 3);
      SET flip = get_random_int_between(0, 1);

      SET x = get_random_int_between(0, (20 - CASE WHEN rotation IN(0,2) THEN x_len ELSE y_len END));
      SET x = get_random_int_between(0, (20 - CASE WHEN rotation IN(0,2) THEN y_len ELSE x_len END));
    END IF;

    CALL place_building_on_board(board_building_id,x,y,rotation,flip);
  END WHILE;

  DELETE FROM board WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0; 
  UPDATE board_buildings bb SET bb.rotation=rotation,bb.flip=flip WHERE bb.id=board_building_id;

  CALL count_income(board_building_id);
  CALL cmd_move_building(g_id,p_num,b_x,b_y,board_building_id);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `move_unit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `move_unit`(board_unit_id INT, x2 INT, y2 INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE x,y INT;
  DECLARE delta_x,delta_y INT;
  DECLARE u_id INT;

  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_move_message($x,$y,$x2,$y2,$p_num,$unit_id,"$npc_name")';

  SELECT bu.game_id,bu.player_num,bu.unit_id INTO g_id,p_num,u_id FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;
  SELECT MIN(b.x),MIN(b.y) INTO x,y FROM board b WHERE b.`type`='unit' AND b.ref=board_unit_id;
  SET delta_x=x2-x;
  SET delta_y=y2-y;
  UPDATE board b SET b.x=b.x+delta_x,b.y=b.y+delta_y WHERE b.`type`='unit' AND b.ref=board_unit_id;

  CALL cmd_move_unit(g_id,p_num,x,y,x2,y2);

  SET cmd_log=REPLACE(cmd_log,'$p_num',p_num);
  SET cmd_log=REPLACE(cmd_log,'$unit_id',u_id);
  SET cmd_log=REPLACE(cmd_log,'$x,$y',CONCAT(x,',',y));
  SET cmd_log=REPLACE(cmd_log,'$x2,$y2',CONCAT(x2,',',y2));
  IF ((SELECT p.owner FROM players p WHERE p.game_id = g_id AND p.player_num = p_num LIMIT 1) <> 1) THEN
    SET cmd_log=REPLACE(cmd_log,'$npc_name', (SELECT p.name FROM players p WHERE p.game_id = g_id AND p.player_num = p_num LIMIT 1));
  ELSE
    SET cmd_log=REPLACE(cmd_log,'$npc_name', '');
  END IF;
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `necromancer_resurrect` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `necromancer_resurrect`(g_id INT,   p_num INT,   x INT,   y INT,   grave_id INT)
BEGIN
  DECLARE dead_card_id INT;
  DECLARE err_code INT;
  DECLARE u2_id INT;
  DECLARE board_unit_id INT;
  DECLARE new_unit_id INT;
  DECLARE resur_cost INT;

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'necromancer_resurrect'); 
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT id FROM graves WHERE game_id=g_id AND id=grave_id LIMIT 1) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=8;
    ELSE
      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;
      IF get_distance_from_unit_to_object(board_unit_id, 'grave', grave_id) <> 1 THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=34;
      ELSE
        IF EXISTS (SELECT b.id FROM board b JOIN grave_cells gc ON (b.x=gc.x AND b.y=gc.y) WHERE b.game_id=g_id AND gc.grave_id=grave_id LIMIT 1) THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=12;
        ELSE
          SELECT g.card_id INTO dead_card_id FROM graves g WHERE id=grave_id;
          SELECT c.cost INTO resur_cost FROM cards c WHERE c.id=dead_card_id LIMIT 1;
          IF (SELECT gold FROM players WHERE game_id=g_id AND player_num=p_num LIMIT 1)<resur_cost THEN
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=2;
          ELSE

            CALL unit_action_begin(g_id, p_num);

            UPDATE players SET gold=gold-resur_cost WHERE game_id=g_id AND player_num=p_num;
            CALL cmd_player_set_gold(g_id,p_num);

            SELECT c.ref INTO u2_id FROM cards c WHERE c.id=dead_card_id LIMIT 1;

            UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
            CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);


            INSERT INTO board_units(game_id,player_num,card_id) VALUES (g_id,p_num,dead_card_id);
            SET new_unit_id=@@last_insert_id;
            INSERT INTO board_units_features(board_unit_id,feature_id,param) SELECT new_unit_id,ufu.feature_id,ufu.param FROM unit_default_features ufu WHERE ufu.unit_id=u2_id;
            UPDATE board_units SET moves_left=0 WHERE id=new_unit_id;

            INSERT INTO board_units_features(board_unit_id,feature_id,param) SELECT new_unit_id,unit_feature_get_id_by_code('under_control'),board_unit_id;

            INSERT INTO board(game_id,x,y,`type`,ref) SELECT g_id,gc.x,gc.y,'unit',new_unit_id FROM grave_cells gc WHERE gc.grave_id=grave_id;
            DELETE FROM graves WHERE game_id=g_id AND id=grave_id;

            CALL cmd_add_unit(g_id,p_num,new_unit_id);
            CALL cmd_remove_from_grave(g_id,p_num,grave_id);
            CALL cmd_unit_set_moves_left(g_id,p_num,new_unit_id);


            CALL unit_add_exp(board_unit_id, 1);

            INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'resurrect_unit',u2_id);

            CALL cmd_log_add_message(g_id, p_num, 'unit_resurrects', CONCAT_WS(';', log_unit(board_unit_id), log_unit(new_unit_id)));

            CALL unit_action_end(g_id, p_num);

          END IF;
        END IF;
      END IF;
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `necromancer_sacrifice` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `necromancer_sacrifice`(g_id INT,  p_num INT,  x INT,  y INT,  x_sacr INT,  y_sacr INT,   x_target INT,   y_target INT)
BEGIN
  DECLARE err_code INT;
  DECLARE sacr_bu_id INT;
  DECLARE target_bu_id INT;
  DECLARE board_unit_id INT;
  DECLARE sacr_health INT;
  DECLARE damage_bonus INT DEFAULT 1;

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'necromancer_sacrifice'); 
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    SELECT b.ref INTO sacr_bu_id FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.x=x_sacr AND b.y=y_sacr LIMIT 1;
    IF sacr_bu_id IS NULL THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=37;
    ELSE
      IF (SELECT player_num FROM board_units WHERE id=sacr_bu_id)<>p_num THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=38;
      ELSE
        SELECT b.ref INTO target_bu_id FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.x=x_target AND b.y=y_target LIMIT 1;
        IF target_bu_id IS NULL THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=39;
        ELSE

          CALL unit_action_begin(g_id, p_num);

          SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;

          UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
          CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);


          CALL cmd_log_add_message(g_id, p_num, 'sacrifice', CONCAT_WS(';', log_unit(board_unit_id), log_unit(sacr_bu_id), log_unit(target_bu_id)));
          IF(sacr_bu_id=target_bu_id) THEN
            CALL cmd_log_add_message(g_id, p_num, 'unit_is_such_a_unit', log_unit(board_unit_id));
          END IF;

          IF (unit_feature_check(sacr_bu_id,'magic_immunity')=1) THEN 
            CALL cmd_magic_resistance_log(g_id,p_num,board_unit_id);
          ELSE

            SELECT bu.health INTO sacr_health FROM board_units bu WHERE bu.id=sacr_bu_id;

            CALL unit_feature_set(sacr_bu_id,'goes_to_deck_on_death',null);
            CALL kill_unit(sacr_bu_id,p_num);
            
            IF(sacr_bu_id<>target_bu_id)THEN
              CALL magical_damage(g_id,p_num,x_target,y_target,sacr_health+damage_bonus);
            END IF;

          END IF;

          CALL unit_action_end(g_id, p_num);

        END IF;
      END IF;
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `place_building_on_board` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `place_building_on_board`(board_building_id INT,x INT,y INT,rotation INT,flip INT)
BEGIN
  DECLARE g_id INT;
  DECLARE b_id INT;
  DECLARE b_type VARCHAR(45);
  DECLARE x_len,y_len INT;
  DECLARE shape VARCHAR(400);
  DECLARE x_0,y_0 INT;
  DECLARE flip_sign INT;
  DECLARE x_put,y_put INT;

  SELECT game_id,building_id INTO g_id,b_id FROM board_buildings WHERE id=board_building_id LIMIT 1;
  SELECT b.`type`,b.x_len,b.y_len,b.shape INTO b_type,x_len,y_len,shape FROM buildings b WHERE b.id=b_id LIMIT 1;

  CREATE TEMPORARY TABLE put_coords (id INT AUTO_INCREMENT PRIMARY KEY,x INT,y INT);

  IF shape='1' THEN
    INSERT INTO put_coords(x,y) VALUES(x,y);
  ELSE
    SET flip_sign= CASE flip WHEN 0 THEN 1 ELSE -1 END;
    SET x_0=x;
    SET y_0=y;

    IF rotation=0 THEN
    BEGIN
      DECLARE i INT DEFAULT 0;
      SET x_0=CASE flip_sign WHEN 1 THEN x_0 ELSE x_0+x_len-1 END;
      WHILE i<x_len*y_len DO
        IF SUBSTRING(shape,i+1,1)='1' THEN
          SET x_put=x_0+flip_sign*(i % x_len);
          SET y_put=y_0+(i DIV x_len);
          INSERT INTO put_coords(x,y) VALUES(x_put,y_put);
        END IF;
        SET i=i+1;
      END WHILE;
    END;
    END IF;
    IF rotation=1 THEN
    BEGIN
      DECLARE i INT DEFAULT 0;
      SET x_0=CASE flip_sign WHEN 1 THEN x_0+y_len-1 ELSE x_0 END;
      WHILE i<x_len*y_len DO
        IF SUBSTRING(shape,i+1,1)='1' THEN
          SET x_put=x_0-flip_sign*(i DIV x_len);
          SET y_put=y_0+(i % x_len);
          INSERT INTO put_coords(x,y) VALUES(x_put,y_put);
        END IF;
        SET i=i+1;
      END WHILE;
    END;
    END IF;
    IF rotation=2 THEN
    BEGIN
      DECLARE i INT DEFAULT 0;
      SET x_0=CASE flip_sign WHEN 1 THEN x_0+x_len-1 ELSE x_0 END;
      SET y_0=y_0+y_len-1;
      WHILE i<x_len*y_len DO
        IF SUBSTRING(shape,i+1,1)='1' THEN
          SET x_put=x_0-flip_sign*(i % x_len);
          SET y_put=y_0-(i DIV x_len);
          INSERT INTO put_coords(x,y) VALUES(x_put,y_put);
        END IF;
        SET i=i+1;
      END WHILE;
    END;
    END IF;
    IF rotation=3 THEN
    BEGIN
      DECLARE i INT DEFAULT 0;
      SET x_0=CASE flip_sign WHEN 1 THEN x_0 ELSE x_0+y_len-1 END;
      SET y_0=y_0+x_len-1;
      WHILE i<x_len*y_len DO
        IF SUBSTRING(shape,i+1,1)='1' THEN
          SET x_put=x_0+flip_sign*(i DIV x_len);
          SET y_put=y_0-(i % x_len);
          INSERT INTO put_coords(x,y) VALUES(x_put,y_put);
        END IF;
        SET i=i+1;
      END WHILE;
    END;
    END IF;
  END IF;

  CREATE TEMPORARY TABLE busy_coords (id INT AUTO_INCREMENT PRIMARY KEY,x INT,y INT);
  INSERT INTO busy_coords (x,y) SELECT b.x,b.y FROM board b WHERE b.game_id=g_id AND NOT(b.`type` IN('building','obstacle') AND b.ref=0); 
  INSERT INTO busy_coords (x,y) SELECT b.x+IF(b.x=0,1,-1),b.y+IF(b.y=0,1,-1) FROM board b WHERE b.game_id=g_id AND (b.x=0 OR b.x=19) AND (b.y=0 OR b.y=19) AND b.`type`='castle';

  IF NOT EXISTS(SELECT b.id FROM busy_coords b JOIN put_coords p ON (b.x=p.x AND b.y=p.y)) THEN 
    INSERT INTO board(game_id,x,y,`type`,ref) SELECT g_id,p_c.x,p_c.y,b_type,board_building_id FROM put_coords p_c;
  END IF;
  DROP TEMPORARY TABLE put_coords;
  DROP TEMPORARY TABLE busy_coords;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `player_end_turn` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `player_end_turn`(g_id INT, p_num INT)
BEGIN
  DECLARE moved_units INT;
  DECLARE moves_to_auto_repair INT DEFAULT 2;
  DECLARE moves_ended INT DEFAULT 2;
  DECLARE end_turn_feature_id INT;
  DECLARE owner INT;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;
  ELSE
    CALL user_action_begin();

    SELECT units_moves_flag INTO moved_units FROM active_players WHERE game_id=g_id LIMIT 1;
    SELECT p.owner INTO owner FROM players p WHERE p.game_id=g_id AND p.player_num=p_num LIMIT 1;

    IF moved_units=1 OR owner<>1 THEN
      CALL cmd_log_add_message(g_id, p_num, 'end_turn', log_player(g_id, p_num));
      CALL finish_moving_units(g_id,p_num);
    ELSE
      CALL cmd_log_add_independent_message(g_id, p_num, 'end_turn', log_player(g_id, p_num));
    END IF;

    
    IF moved_units=0 THEN
      SET end_turn_feature_id=player_feature_get_id_by_code('end_turn');

      IF EXISTS(SELECT pfu.id FROM player_features_usage pfu WHERE pfu.game_id=g_id AND pfu.player_num=p_num AND feature_id=end_turn_feature_id LIMIT 1)THEN
        SELECT pfu.param INTO moves_ended FROM player_features_usage pfu WHERE pfu.game_id=g_id AND pfu.player_num=p_num AND feature_id=end_turn_feature_id LIMIT 1;

        IF(moves_ended+1=moves_to_auto_repair)THEN
          DELETE FROM player_features_usage WHERE game_id=g_id AND player_num=p_num AND feature_id=end_turn_feature_id;
          CALL castle_auto_repair(g_id,p_num);
        ELSE
          SET @player_end_turn=1;
          UPDATE player_features_usage pfu SET param=param+1 WHERE pfu.game_id=g_id AND pfu.player_num=p_num AND feature_id=end_turn_feature_id;
        END IF;

      ELSE
        IF (moves_to_auto_repair=1) THEN
          CALL castle_auto_repair(g_id,p_num);
        ELSE
          SET @player_end_turn=1;
          INSERT INTO player_features_usage(game_id,player_num,feature_id,param) VALUES(g_id,p_num,end_turn_feature_id,1);
        END IF;
      END IF;
    END IF;

    CALL end_turn(g_id,p_num);

    CALL user_action_end();
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `player_end_turn_by_timeout` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `player_end_turn_by_timeout`(g_id INT, p_num INT)
BEGIN

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;
  ELSE
    CALL user_action_begin();

    IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=1 THEN
      CALL cmd_log_add_message(g_id, p_num, 'end_turn_timeout', log_player(g_id, p_num));
      CALL finish_moving_units(g_id,p_num);
    ELSE
      CALL cmd_log_add_independent_message(g_id, p_num, 'end_turn_timeout', log_player(g_id, p_num));
    END IF;

    CALL end_turn(g_id,p_num);

    CALL user_action_end();
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `player_exit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `player_exit`(g_id INT,   p_num INT)
BEGIN
  DECLARE p_id INT;
  DECLARE finished_game_status INT DEFAULT 3; 
  DECLARE user_id INT;
  DECLARE owner INT;
  DECLARE player_online_status_id INT DEFAULT 1; 
  DECLARE mode_id INT;
  DECLARE game_type_id INT;

  CALL user_action_begin();

  SELECT g.mode_id, g.type_id INTO mode_id, game_type_id FROM games g WHERE g.id = g_id;

  SELECT p.id,p.owner,p.user_id INTO p_id,owner,user_id FROM players p WHERE game_id=g_id AND player_num=p_num;

  IF (SELECT g.status_id FROM games g WHERE g.id=g_id LIMIT 1)<>finished_game_status AND (owner=1) THEN
    CALL cmd_log_add_independent_message(g_id, p_num, 'player_exit', log_player(g_id, p_num));

    CALL delete_player_objects(g_id,p_num);

    IF (SELECT player_num FROM active_players WHERE game_id=g_id LIMIT 1)=p_num THEN
      CALL end_turn(g_id,p_num);
    END IF;

    CALL cmd_delete_player(g_id,p_num);

    UPDATE players SET owner=0, move_order = NULL WHERE game_id=g_id AND player_num=p_num;

    INSERT INTO lords_site.user_statistics_games(user_id,game_type_id,mode_id,game_result)
    VALUES(user_id,game_type_id,mode_id,'exit');

    IF ((SELECT COUNT(DISTINCT p.team) FROM players p WHERE p.game_id=g_id AND p.owner=1)=1) OR (NOT EXISTS(SELECT p.id FROM players p WHERE p.game_id=g_id AND p.owner=1 AND p.agree_draw=0)) THEN
      CALL end_game(g_id);
    END IF;
  END IF;

  IF(owner=0)THEN
    CALL cmd_remove_spectator(g_id,p_num);
  END IF;

  DELETE agp FROM lords_site.arena_game_players agp WHERE agp.user_id=user_id;

  UPDATE lords_site.arena_users au SET au.status_id=player_online_status_id
    WHERE au.user_id=user_id;


  IF (SELECT COUNT(*) FROM players p WHERE p.game_id=g_id AND p.player_num<>p_num AND p.owner IN(0,1))=0 THEN
    CALL delete_game_data(g_id);
  END IF;

  CALL user_action_end();
  
  DELETE FROM players WHERE game_id=g_id AND player_num=p_num;  
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `player_move_unit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `player_move_unit`(g_id INT, p_num INT, x INT, y INT, x2 INT, y2 INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE size INT;
  DECLARE moveable INT DEFAULT 0;
  DECLARE teleportable INT DEFAULT 0;
  DECLARE taran_unit_id INT;
  DECLARE taran_x,taran_y,taran_prev_x,taran_prev_y INT;
  DECLARE x0,y0 INT;

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'player_move_unit'); 
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
    SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;
    SELECT u.size INTO size FROM board_units bu JOIN units u ON (bu.unit_id=u.id) WHERE bu.id=board_unit_id LIMIT 1;

    SET moveable=check_one_step_from_unit(g_id,x,y,x2,y2);

    IF (moveable=0)AND(unit_feature_check(board_unit_id,'magic_immunity')=0) AND EXISTS
    (SELECT a.id FROM board_buildings bb,board b,allcoords a
      WHERE bb.game_id=g_id AND building_feature_check(bb.id,'teleport')=1 AND check_building_deactivated(bb.id)=0
      AND b.`type`<>'unit' AND b.ref=bb.id
      AND get_building_team(bb.id) = get_unit_team(board_unit_id)
      AND a.mode_id=mode_id
      AND a.x BETWEEN b.x-bb.radius AND b.x+bb.radius AND a.y BETWEEN b.y-bb.radius AND b.y+bb.radius
      AND a.x BETWEEN x2 AND x2+size-1 AND a.y BETWEEN y2 AND y2+size-1 LIMIT 1)
    THEN
      SET teleportable=1;
    END IF;
    IF moveable=0 AND teleportable=0
    THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=19;
    ELSE
      IF EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x BETWEEN x2 AND x2+size-1 AND b.y BETWEEN y2 AND y2+size-1 AND NOT(b.`type`='unit' AND b.ref=board_unit_id) LIMIT 1) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=12;
      ELSE

                CALL unit_action_begin(g_id, p_num);

                IF (unit_feature_get_param(board_unit_id,'bind_target') IS NOT NULL) THEN
                  CALL unit_feature_remove(board_unit_id,'bind_target');
                END IF; 

                SELECT MIN(b.x),MIN(b.y) INTO x0,y0 FROM board b WHERE b.game_id=g_id AND b.ref=board_unit_id AND b.`type`='unit';

                CALL move_unit(board_unit_id,x2,y2);
                UPDATE board_units bu SET bu.moves_left=CASE WHEN teleportable=1 THEN 0 ELSE bu.moves_left-1 END WHERE bu.id=board_unit_id;
                CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);


                SELECT bu.id INTO taran_unit_id FROM board_units bu WHERE unit_feature_get_param(bu.id,'bind_target')=board_unit_id LIMIT 1;
                IF taran_unit_id IS NOT NULL THEN
                  IF teleportable=1 THEN
                    CALL unit_feature_remove(taran_unit_id,'bind_target');
                  ELSE
                    IF (size=1) THEN
                      SET taran_x=x;
                      SET taran_y=y;
                    ELSE 
                      SELECT b.x,b.y INTO taran_prev_x,taran_prev_y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=taran_unit_id LIMIT 1;
                      SELECT a.x,a.y INTO taran_x,taran_y FROM allcoords a WHERE a.mode_id=mode_id AND a.x BETWEEN x0 AND x0+size-1 AND a.y BETWEEN y0 AND y0+size-1 AND a.x BETWEEN x2-1 AND x2+size AND a.y BETWEEN y2-1 AND y2+size AND NOT (a.x BETWEEN x2 AND x2+size-1 AND a.y BETWEEN y2 AND y2+size-1) ORDER BY ((taran_prev_x-a.x)*(taran_prev_x-a.x)+(taran_prev_y-a.y)*(taran_prev_y-a.y)) LIMIT 1;
                    END IF;
                    CALL move_unit(taran_unit_id,taran_x,taran_y);
                  END IF;
                END IF;

                CALL unit_action_end(g_id, p_num);
      END IF;
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `player_resurrect` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `player_resurrect`(g_id INT,  p_num INT,  grave_id INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE dead_card_id INT;
  DECLARE resurrection_cost_coefficient INT;
  DECLARE resur_cost INT;
  DECLARE x_appear,y_appear,x_dir,y_dir INT;
  DECLARE new_unit_id INT;
  DECLARE size INT;
  DECLARE u_id INT;
  DECLARE new_bu_id INT;

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
  SELECT cfg.`value` INTO resurrection_cost_coefficient FROM mode_config cfg WHERE cfg.param='resurrection cost coefficient' AND cfg.mode_id=mode_id;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'not_your_turn';
  ELSE
    IF (SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id LIMIT 1)<>0 THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'need_to_finish_card_action';
    ELSE
      IF (SELECT card_played_flag FROM active_players WHERE game_id=g_id)=1 THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'can_play_card_or_resurrect_only_once_per_turn';
      ELSE
        IF NOT EXISTS(SELECT id FROM graves WHERE game_id=g_id AND id=grave_id LIMIT 1) THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'no_such_dead_unit';
        ELSE
          IF EXISTS (SELECT id FROM graves
                        WHERE game_id = g_id
                          AND id=grave_id
                          AND player_num_when_killed = get_current_p_num(g_id)
                          AND turn_when_killed = get_current_turn(g_id))
          THEN
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'cant_resurrect_same_turn';
          ELSE
            SELECT g.card_id INTO dead_card_id FROM graves g WHERE id=grave_id;
            SELECT cost*resurrection_cost_coefficient INTO resur_cost FROM cards WHERE id=dead_card_id LIMIT 1;
            IF (SELECT gold FROM players WHERE game_id=g_id AND player_num=p_num LIMIT 1)<resur_cost THEN
              SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'not_enough_gold';
            ELSE
              SELECT ap.x,ap.y,ap.direction_into_board_x,ap.direction_into_board_y INTO x_appear,y_appear,x_dir,y_dir FROM appear_points ap WHERE ap.mode_id=mode_id AND ap.player_num=p_num;
              SELECT u.id,u.size INTO u_id,size FROM cards c JOIN units u ON c.ref=u.id WHERE c.id=dead_card_id LIMIT 1;
              IF EXISTS(SELECT id FROM board WHERE game_id=g_id AND x BETWEEN LEAST(x_appear,x_appear+x_dir*(size-1)) AND GREATEST(x_appear,x_appear+x_dir*(size-1)) AND y BETWEEN LEAST(y_appear,y_appear+y_dir*(size-1)) AND GREATEST(y_appear,y_appear+y_dir*(size-1)) LIMIT 1) THEN
                SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'spawn_point_occupued';
              ELSE
                CALL user_action_begin();

                UPDATE players SET gold=gold-resur_cost WHERE game_id=g_id AND player_num=p_num;
                CALL cmd_player_set_gold(g_id,p_num);

                CALL resurrect(g_id,p_num,grave_id);

                SELECT MAX(id) INTO new_bu_id FROM board_units bu WHERE bu.game_id=g_id AND bu.player_num=p_num;
                CALL cmd_log_add_independent_message(g_id, p_num, 'resurrect', CONCAT_WS(';', log_player(g_id, p_num), log_unit(new_bu_id)));

                CALL end_cards_phase(g_id,p_num);

                CALL user_action_end();
              END IF;
            END IF;
          END IF;
        END IF;
      END IF;
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `play_card_actions` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `play_card_actions`(g_id INT,  p_num INT,  player_deck_id INT)
BEGIN

  DECLARE crd_id INT;
  DECLARE card_cost INT;
  DECLARE card_type VARCHAR(5);

  SELECT card_id INTO crd_id FROM player_deck WHERE id=player_deck_id;


  SELECT cost,`type` INTO card_cost,card_type FROM cards WHERE id=crd_id LIMIT 1;
  IF card_cost>0 THEN
    UPDATE players SET gold=gold-card_cost WHERE game_id=g_id AND player_num=p_num;
    CALL cmd_player_set_gold(g_id,p_num);
  END IF;

  DELETE FROM player_deck WHERE id=player_deck_id;
  CALL cmd_remove_card(g_id,p_num,player_deck_id);
  IF card_type = 'm' THEN
    INSERT INTO deck(game_id,card_id) VALUES(g_id,crd_id);
  END IF;

  CALL cmd_log_add_container(g_id, p_num, 'plays_card', crd_id);
  INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'play_card',crd_id);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `put_building` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `put_building`(g_id INT, p_num INT, player_deck_id INT, x INT, y INT, rotation INT, flip INT)
BEGIN
  DECLARE crd_id INT;
  DECLARE err_code INT;
  DECLARE x_len,y_len INT;
  DECLARE x2,y2 INT; 
  DECLARE new_building_id INT;
  DECLARE card_cost INT;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'put_building');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    SELECT card_id INTO crd_id FROM player_deck WHERE id=player_deck_id;
    SELECT b.x_len,b.y_len INTO x_len,y_len FROM cards c JOIN buildings b ON (c.ref=b.id) WHERE c.`type`='b' AND c.id=crd_id LIMIT 1;
    IF rotation=0 OR rotation=2 THEN
      SET x2=x+x_len-1;
      SET y2=y+y_len-1;
    ELSE
      SET x2=x+y_len-1;
      SET y2=y+x_len-1;
    END IF;
    IF (quart(x,y)<>p_num) OR (quart(x2,y2)<>p_num) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=11;
    ELSE
      CALL user_action_begin();

      INSERT INTO board_buildings(game_id,player_num,card_id,rotation,flip)VALUES (g_id,p_num,crd_id,rotation,flip);
      SET new_building_id=@@last_insert_id;

      CALL place_building_on_board(new_building_id,x,y,rotation,flip);

      IF NOT EXISTS(SELECT id FROM board WHERE game_id=g_id AND `type`<>'unit' AND ref=new_building_id) THEN 
        DELETE FROM board_buildings WHERE id=new_building_id;
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=12;
      ELSE

        INSERT INTO board_buildings_features(board_building_id,feature_id,param) SELECT new_building_id,bfu.feature_id,bfu.param FROM board_buildings bb JOIN building_default_features bfu ON (bb.building_id=bfu.building_id) WHERE bb.id=new_building_id;

        UPDATE board_buildings_features bbf
        SET param=get_new_team_number(g_id)
        WHERE bbf.board_building_id=new_building_id AND bbf.feature_id=building_feature_get_id_by_code('summon_team');

        IF(building_feature_check(new_building_id,'ally') = 1)THEN
          CALL building_feature_set(new_building_id,'summon_team',get_player_team(g_id, p_num));
        END IF;

        CALL count_income(new_building_id);

        CALL play_card_actions(g_id,p_num,player_deck_id); 


        CALL cmd_put_building_by_card(g_id,p_num,new_building_id);


        IF EXISTS(SELECT sc.id FROM summon_cfg sc WHERE sc.building_id=(SELECT bb.building_id FROM board_buildings bb WHERE id=new_building_id)) THEN
          CALL summon_creatures(new_building_id);
        END IF;

        CALL finish_playing_card(g_id,p_num);
        CALL end_cards_phase(g_id,p_num);

        CALL user_action_end();
      END IF;
    END IF;
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `recreate_exp_table` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `recreate_exp_table`()
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

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `remove_building_from_board` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `remove_building_from_board`(board_b_id INT,p_num INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p2_num INT; 
  DECLARE crd_id INT;

  SELECT game_id,player_num,card_id INTO g_id,p2_num,crd_id FROM board_buildings WHERE id=board_b_id LIMIT 1;


  IF(crd_id IS NOT NULL)THEN INSERT INTO deck(game_id,card_id) VALUES(g_id,crd_id); END IF;

  CALL cmd_destroy_building(g_id,p_num,board_b_id);
  DELETE FROM board WHERE game_id=g_id AND `type`<>'unit' AND ref=board_b_id;
  DELETE FROM board_buildings_features WHERE board_building_id=board_b_id;
  DELETE FROM board_buildings WHERE id=board_b_id;

  INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'destroy_building',p2_num);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `repair_buildings` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `repair_buildings`(g_id INT, p_num INT)
BEGIN
  DECLARE board_building_id INT;
  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT bb.id FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.game_id=g_id AND bb.player_num=p_num AND bb.health<bb.max_health;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  OPEN cur;
  REPEAT
    FETCH cur INTO board_building_id;
    IF NOT done THEN
      CALL cmd_log_add_message(g_id, p_num, 'building_completely_repaired', log_building(board_building_id));
      UPDATE board_buildings SET health=max_health WHERE id=board_building_id;
      CALL cmd_building_set_health(g_id,p_num,board_building_id);
    END IF;
  UNTIL done END REPEAT;
  CLOSE cur;


END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `reset` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `reset`()
BEGIN
  SET FOREIGN_KEY_CHECKS=0;
  truncate table active_players;
  truncate table board;
  truncate table board_buildings;
  truncate table board_buildings_features;
  truncate table board_units;
  truncate table board_units_features;
  truncate table log_commands;
  truncate table graves;
  truncate table grave_cells;
  truncate table deck;
  truncate table games_features_usage;
  truncate table games;
  truncate table player_deck;
  truncate table players;
  truncate table statistic_values;
  truncate table statistic_game_actions;
  truncate table statistic_players;
  truncate table player_features_usage;
  SET FOREIGN_KEY_CHECKS=1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `resurrect` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `resurrect`(g_id INT,p_num INT,grave_id INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE dead_card_id INT;
  DECLARE new_unit_id INT;
  DECLARE x_appear,y_appear,x_dir,y_dir INT;
  DECLARE size INT;
  DECLARE u_id INT;

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
  SELECT ap.x,ap.y,ap.direction_into_board_x,ap.direction_into_board_y INTO x_appear,y_appear,x_dir,y_dir FROM appear_points ap WHERE ap.mode_id=mode_id AND ap.player_num=p_num;
  SELECT g.card_id INTO dead_card_id FROM graves g WHERE id=grave_id;
  SELECT u.id,u.size INTO u_id,size FROM cards c JOIN units u ON c.ref=u.id WHERE c.id=dead_card_id LIMIT 1;

            INSERT INTO board_units(game_id,player_num,card_id) VALUES (g_id,p_num,dead_card_id);
            SET new_unit_id=@@last_insert_id;
            INSERT INTO board_units_features(board_unit_id,feature_id,param) SELECT new_unit_id,ufu.feature_id,ufu.param FROM unit_default_features ufu WHERE ufu.unit_id=u_id;

            INSERT INTO board(game_id,x,y,`type`,ref) SELECT g_id,a.x,a.y,'unit',new_unit_id FROM allcoords a WHERE a.mode_id=mode_id AND a.x BETWEEN LEAST(x_appear,x_appear+x_dir*(size-1)) AND GREATEST(x_appear,x_appear+x_dir*(size-1)) AND a.y BETWEEN LEAST(y_appear,y_appear+y_dir*(size-1)) AND GREATEST(y_appear,y_appear+y_dir*(size-1));
            DELETE FROM graves WHERE game_id=g_id AND id=grave_id;

            UPDATE board_units SET moves_left=0 WHERE id=new_unit_id;

            CALL cmd_add_unit(g_id,p_num,new_unit_id);
            CALL cmd_remove_from_grave(g_id,p_num,grave_id);
            CALL cmd_unit_set_moves_left(g_id,p_num,new_unit_id);

            INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'resurrect_unit',u_id);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `send_money` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `send_money`(g_id INT,  p_num INT,  p2_num INT,  amount_input_str VARCHAR(100) CHARSET utf8)
BEGIN
  DECLARE amount INT;

  DECLARE conversion_error INT DEFAULT 0;
  DECLARE CONTINUE HANDLER FOR SQLSTATE '22007' SET conversion_error = 1;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='not_your_turn';
  ELSE
  SET amount=CAST(amount_input_str AS SIGNED INTEGER);

  IF (conversion_error=1 OR amount<=0) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='incorrect_sum';
  ELSE

    IF (p_num=p2_num) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='cant_send_money_to_self';
    ELSE

      IF (SELECT gold FROM players WHERE game_id=g_id AND player_num=p_num)<amount THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='not_enough_gold';
      ELSE

        IF NOT EXISTS(SELECT id FROM players WHERE game_id=g_id AND player_num=p2_num) THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='send_money_invalid_player';
        ELSE

          CALL user_action_begin();

          UPDATE players SET gold=gold-amount WHERE game_id=g_id AND player_num=p_num;
          UPDATE players SET gold=gold+amount WHERE game_id=g_id AND player_num=p2_num;

          CALL cmd_player_set_gold(g_id,p_num);
          CALL cmd_player_set_gold(g_id,p2_num);

          CALL cmd_log_add_independent_message(g_id, p_num, 'send_money', CONCAT_WS(';', log_player(g_id, p2_num), amount));

          CALL user_action_end();
        END IF;
      END IF;
    END IF;
  END IF;
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `shields_restore` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `shields_restore`(board_unit_id INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE u_id INT;

  SELECT bu.game_id, bu.player_num, bu.unit_id INTO g_id, p_num, u_id FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

  UPDATE board_units SET shield=(SELECT shield FROM units u WHERE u.id=u_id LIMIT 1) WHERE id=board_unit_id;
  CALL cmd_unit_set_shield(g_id,p_num,board_unit_id);

  CALL cmd_log_add_message(g_id, p_num, 'restore_magic_shield', log_unit(board_unit_id));

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `shield_off` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `shield_off`(board_unit_id INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;

  SELECT bu.game_id,bu.player_num INTO g_id,p_num FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

  UPDATE board_units SET shield=shield-1 WHERE id=board_unit_id;
  CALL cmd_unit_set_shield(g_id,p_num,board_unit_id);

  CALL cmd_log_add_message(g_id, p_num, 'loses_magic_shield', log_unit(board_unit_id));

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `shield_on` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `shield_on`(board_unit_id INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;

  SELECT bu.game_id,bu.player_num INTO g_id,p_num FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

  UPDATE board_units SET shield=shield+1 WHERE id=board_unit_id;
  CALL cmd_unit_set_shield(g_id,p_num,board_unit_id);

  IF((SELECT current_procedure FROM active_players WHERE game_id=g_id LIMIT 1)='end_turn')THEN
    CALL cmd_log_add_independent_message(g_id, p_num, 'gets_magic_shield', log_unit(board_unit_id));
  ELSE
    CALL cmd_log_add_message(g_id, p_num, 'gets_magic_shield', log_unit(board_unit_id));
  END IF;


END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sink_building` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sink_building`(bb_id INT, p_num INT)
BEGIN
  DECLARE g_id INT;

  SELECT game_id INTO g_id FROM board_buildings WHERE id=bb_id LIMIT 1;

  CALL cmd_log_add_message(g_id, p_num, 'building_sinks', log_building(bb_id));

  CALL remove_building_from_board(bb_id,p_num);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sink_unit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sink_unit`(bu_id INT, p_num INT)
BEGIN
  DECLARE g_id INT;

  SELECT game_id INTO g_id FROM board_units WHERE id=bu_id LIMIT 1;

  CALL cmd_log_add_message(g_id, p_num, 'unit_drowns', log_unit(bu_id));

  CALL unit_feature_set(bu_id,'goes_to_deck_on_death',null);
  CALL kill_unit(bu_id,p_num);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `start_moving_units` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `start_moving_units`(g_id INT, p_num INT)
BEGIN
  UPDATE active_players SET units_moves_flag=1 WHERE game_id=g_id AND player_num=p_num;

  IF((SELECT owner FROM players p WHERE p.game_id=g_id AND p.player_num=p_num LIMIT 1)=1)THEN
    CALL cmd_log_add_container(g_id, p_num, 'moves_units', NULL);
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `statistic_calculation` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `statistic_calculation`(g_id INT)
BEGIN
  DECLARE g_mode INT;

  DECLARE stat_value_config_id INT;
  DECLARE p_num INT;
  DECLARE value_name VARCHAR(500) CHARSET utf8;
  DECLARE count_rule VARCHAR(1000) CHARSET utf8;
  DECLARE sql_update_stmt VARCHAR(1000) CHARSET utf8 DEFAULT
    'INSERT INTO statistic_values (game_id, stat_value_config_id, value, name)
       SELECT $g_id, $vc_id, r.value, ''$value_name''
         FROM ($rule) r;';

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR
    SELECT
      vc.id,
      vc.player_num,
      IFNULL(vc.name, p.player_name),
      d.count_rule
    FROM statistic_values_config vc
      JOIN dic_statistic_measures d ON (vc.measure_id=d.id)
      JOIN statistic_players p ON (p.player_num = vc.player_num)
    WHERE vc.mode_id = g_mode AND p.game_id = g_id;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SELECT mode_id INTO g_mode FROM games WHERE id=g_id;

    OPEN cur;
    REPEAT
      FETCH cur INTO stat_value_config_id,p_num,value_name,count_rule;
      IF NOT done THEN
        SET count_rule=REPLACE(count_rule,'$g_id',g_id);
        SET count_rule=REPLACE(count_rule,'$p_num',p_num);
        SET @sql_query=REPLACE(sql_update_stmt,'$rule',count_rule);
        SET @sql_query=REPLACE(@sql_query,'$g_id',g_id);
        SET @sql_query=REPLACE(@sql_query,'$vc_id',stat_value_config_id);
        SET @sql_query=REPLACE(@sql_query,'$value_name',value_name);
        PREPARE stmt FROM @sql_query;
        EXECUTE stmt;
        DROP PREPARE stmt;
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `summon_creature` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `summon_creature`(g_id INT,   cr_owner INT ,  cr_unit_id INT ,  x INT ,  y INT,   parent_building_id INT)
BEGIN
  DECLARE new_player,team INT;
  DECLARE new_unit_id INT;
  DECLARE new_move_order INT;
  DECLARE cr_player_name VARCHAR(45) CHARSET utf8;
  DECLARE current_p_num INT;

    SELECT CASE WHEN MAX(p.player_num)<10 THEN 10 ELSE MAX(p.player_num)+1 END INTO new_player FROM players p WHERE p.game_id=g_id;
    SET team=building_feature_get_param(parent_building_id,'summon_team');
    SET cr_player_name = CONCAT('{', cr_unit_id, '}');
    SELECT player_num INTO current_p_num FROM active_players WHERE game_id=g_id LIMIT 1;
    SET new_move_order = get_move_order_for_new_npc(g_id, current_p_num);

    UPDATE players SET move_order = move_order + 1 WHERE game_id = g_id AND move_order >= new_move_order;
    INSERT INTO players(game_id,player_num,name,gold,owner,team,move_order,language_id) VALUES(g_id,new_player,cr_player_name,0,cr_owner,team,new_move_order,get_player_language_id(g_id,current_p_num));

    INSERT INTO board_units(game_id,player_num,unit_id) VALUES(g_id,new_player,cr_unit_id);
    SET new_unit_id=@@last_insert_id;
    INSERT INTO board_units_features(board_unit_id,feature_id,param) SELECT new_unit_id,ufu.feature_id,ufu.param FROM unit_default_features ufu WHERE ufu.unit_id=cr_unit_id;
    INSERT INTO board_units_features(board_unit_id,feature_id,param) VALUES(new_unit_id,unit_feature_get_id_by_code('parent_building'),parent_building_id);

    INSERT INTO board(game_id,x,y,`type`,ref) VALUES (g_id,x,y,'unit',new_unit_id);

    CALL cmd_add_player(g_id,new_player);
    CALL cmd_add_unit_by_id(g_id,new_player,new_unit_id);

    IF((SELECT current_procedure FROM active_players WHERE game_id=g_id LIMIT 1)='end_turn')THEN
      CALL cmd_log_add_independent_message(g_id, new_player, 'unit_appears_in_cell', CONCAT_WS(';', log_unit(new_unit_id), log_cell(x,y)));
    ELSE
      CALL cmd_log_add_message(g_id, new_player, 'unit_appears_in_cell', CONCAT_WS(';', log_unit(new_unit_id), log_cell(x,y)));
    END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `summon_creatures` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `summon_creatures`(board_building_id INT)
BEGIN
  DECLARE g_id INT;
  DECLARE g_mode INT;
  DECLARE bld_id INT;
  DECLARE cr_count INT;
  DECLARE x, y INT;
  DECLARE cr_owner INT;
  DECLARE cr_unit_id INT;

  DECLARE done INT DEFAULT 0;

  DECLARE cur CURSOR FOR
    SELECT sc.unit_id,sc.`count`,sc.owner
      FROM summon_cfg sc
      WHERE building_id = bld_id AND mode_id = g_mode;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SELECT game_id,building_id INTO g_id,bld_id FROM board_buildings WHERE id=board_building_id LIMIT 1;

  SELECT mode_id INTO g_mode FROM games WHERE id=g_id LIMIT 1;

  OPEN cur;
  REPEAT
    FETCH cur INTO cr_unit_id, cr_count, cr_owner;
    IF NOT done THEN
      WHILE (cr_count>0 AND free_cell_near_building_exists(board_building_id)) DO
        CALL get_random_free_cell_near_building(board_building_id, x, y);
        SET cr_count = cr_count - 1;
        CALL summon_creature(g_id, cr_owner, cr_unit_id, x, y, board_building_id);
      END WHILE;
    END IF;
  UNTIL done END REPEAT;
  CLOSE cur;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `summon_one_creature_by_config` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `summon_one_creature_by_config`(board_building_id INT)
BEGIN
  DECLARE g_id INT;
  DECLARE g_mode INT;
  DECLARE bld_id INT;
  DECLARE x, y INT;
  DECLARE cr_owner INT;
  DECLARE cr_unit_id INT;

  SELECT game_id,building_id INTO g_id,bld_id FROM board_buildings WHERE id=board_building_id LIMIT 1;

  SELECT mode_id INTO g_mode FROM games WHERE id=g_id LIMIT 1;

  SELECT sc.unit_id,sc.owner INTO cr_unit_id,cr_owner
    FROM summon_cfg sc
    WHERE building_id = bld_id AND mode_id = g_mode ORDER BY RAND() LIMIT 1;

  CALL get_random_free_cell_near_building(board_building_id, x, y);
  IF x IS NOT NULL THEN
    CALL summon_creature(g_id,cr_owner,cr_unit_id,x,y,board_building_id);
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `summon_unit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `summon_unit`(g_id INT,p_num INT,player_deck_id INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE crd_id INT;
  DECLARE err_code INT;
  DECLARE x_appear,y_appear,x_dir,y_dir INT;
  DECLARE size INT;
  DECLARE new_unit_id INT;
  DECLARE u_id INT;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'summon_unit');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
    SELECT card_id INTO crd_id FROM player_deck WHERE id=player_deck_id;
    SELECT ap.x,ap.y,ap.direction_into_board_x,ap.direction_into_board_y INTO x_appear,y_appear,x_dir,y_dir FROM appear_points ap WHERE ap.mode_id=mode_id AND ap.player_num=p_num;
    SELECT u.size,u.id INTO size,u_id FROM cards c JOIN units u ON c.ref=u.id WHERE c.id=crd_id LIMIT 1;
    IF EXISTS(SELECT id FROM board WHERE game_id=g_id AND x BETWEEN LEAST(x_appear,x_appear+x_dir*(size-1)) AND GREATEST(x_appear,x_appear+x_dir*(size-1)) AND y BETWEEN LEAST(y_appear,y_appear+y_dir*(size-1)) AND GREATEST(y_appear,y_appear+y_dir*(size-1)) LIMIT 1) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=9;
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      INSERT INTO board_units(game_id,player_num,card_id) VALUES (g_id,p_num,crd_id);
      SET new_unit_id=@@last_insert_id;
      INSERT INTO board_units_features(board_unit_id,feature_id,param) SELECT new_unit_id,ufu.feature_id,ufu.param FROM unit_default_features ufu WHERE ufu.unit_id=u_id;

      INSERT INTO board(game_id,x,y,`type`,ref) SELECT g_id,a.x,a.y,'unit',new_unit_id FROM allcoords a WHERE a.mode_id=mode_id AND a.x BETWEEN LEAST(x_appear,x_appear+x_dir*(size-1)) AND GREATEST(x_appear,x_appear+x_dir*(size-1)) AND a.y BETWEEN LEAST(y_appear,y_appear+y_dir*(size-1)) AND GREATEST(y_appear,y_appear+y_dir*(size-1));

      UPDATE board_units SET moves_left=0 WHERE id=new_unit_id;

      CALL cmd_add_unit(g_id,p_num,new_unit_id);
      CALL cmd_unit_set_moves_left(g_id,p_num,new_unit_id);

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `take_subsidy` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `take_subsidy`(g_id INT, p_num INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE subsidy_amt INT;
  DECLARE subsidy_damage INT;
  DECLARE board_castle_id INT;
  DECLARE health_remaining INT;

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
  SELECT cfg.`value` INTO subsidy_amt FROM mode_config cfg WHERE cfg.param='subsidy amount' AND cfg.mode_id=mode_id;
  SELECT cfg.`value` INTO subsidy_damage FROM mode_config cfg WHERE cfg.param='subsidy castle damage' AND cfg.mode_id=mode_id;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;
  ELSE
    IF (SELECT subsidy_flag FROM active_players WHERE game_id=g_id)=1 THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=5;
    ELSE
      IF (SELECT bb.health FROM board_buildings bb JOIN buildings b ON bb.building_id=b.id WHERE bb.game_id=g_id AND bb.player_num=p_num AND b.`type`='castle' LIMIT 1)<=subsidy_damage THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=6;
      ELSE
        CALL user_action_begin();

        SELECT bb.id INTO board_castle_id FROM board_buildings bb JOIN board b ON bb.id=b.ref WHERE b.`type`='castle' AND b.game_id=g_id AND bb.player_num=p_num LIMIT 1;
        UPDATE players SET gold=gold+subsidy_amt WHERE game_id=g_id AND player_num=p_num;
        UPDATE board_buildings SET health=health-subsidy_damage WHERE id=board_castle_id;
        UPDATE active_players SET subsidy_flag=1 WHERE game_id=g_id;
        
        SELECT health INTO health_remaining FROM board_buildings WHERE id=board_castle_id;

        CALL cmd_player_set_gold(g_id,p_num);
        CALL cmd_building_set_health(g_id,p_num,board_castle_id);

        CALL cmd_log_add_independent_message(g_id, p_num, 'take_subsidy', CONCAT_WS(';', log_building(board_castle_id), health_remaining));

        CALL user_action_end();
      END IF;
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `taran_bind` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `taran_bind`(g_id INT,   p_num INT,   x INT,   y INT,    x2 INT,    y2 INT)
BEGIN
  DECLARE err_code INT;
  DECLARE aim_bu_id INT;
  DECLARE board_unit_id INT;

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'taran_bind'); 
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;
    SELECT b.ref INTO aim_bu_id FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.x=x2 AND b.y=y2 LIMIT 1;
    IF aim_bu_id IS NULL THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=31;
    ELSE
      IF get_distance_between_units(board_unit_id, aim_bu_id) <> 1 THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=29;
      ELSE
        CALL unit_action_begin(g_id, p_num);

        UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
        CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

        CALL unit_feature_set(board_unit_id,'bind_target',aim_bu_id);

        CALL cmd_log_add_message(g_id, p_num, 'unit_attaches', CONCAT_WS(';', log_unit(board_unit_id), log_unit(aim_bu_id)));

        CALL unit_action_end(g_id, p_num);

      END IF;
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `total_heal` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `total_heal`(board_unit_id INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE hp_minus INT;
  DECLARE shield_minus INT;

  SELECT bu.game_id,bu.player_num,bu.max_health-bu.health,u.shield-bu.shield INTO g_id,p_num,hp_minus,shield_minus
  FROM board_units bu JOIN units u ON (bu.unit_id=u.id) WHERE bu.id=board_unit_id LIMIT 1;

  IF((unit_feature_check(board_unit_id,'paralich')=0)AND(unit_feature_check(board_unit_id,'madness')=0)AND(hp_minus<=0)AND(shield_minus<=0))THEN
      CALL cmd_log_add_message(g_id, p_num, 'unit_healed', log_unit(board_unit_id));
  END IF;

  IF (unit_feature_check(board_unit_id,'paralich')=1) THEN
    CALL unit_feature_remove(board_unit_id,'paralich');
    CALL cmd_unit_remove_effect(g_id,board_unit_id,'paralich');
  END IF;

  IF (unit_feature_check(board_unit_id,'madness')=1) THEN
    CALL make_not_mad(board_unit_id);
  END IF;

  IF hp_minus>0 THEN
    CALL heal_unit_health(board_unit_id,hp_minus);
  END IF;

  IF shield_minus>0 THEN
    CALL shields_restore(board_unit_id);
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `units_from_zone` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `units_from_zone`(g_id INT,  p_num INT,  zone INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE u_x,u_y,new_x,new_y INT;
  DECLARE board_unit_id INT;
  DECLARE bu_p_num INT;
  DECLARE size INT;

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR
    SELECT b.ref,MIN(b.x),MIN(b.y),u.size,bu.player_num
    FROM board b
    JOIN board_units bu ON (b.ref=bu.id)
    JOIN units u ON (bu.unit_id=u.id)
    WHERE b.`type`='unit' AND b.game_id=g_id AND unit_feature_check(bu.id,'magic_immunity')=0
    AND quart(b.x,b.y)=zone
    GROUP BY b.ref,u.size;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;

    OPEN cur;
    REPEAT
      FETCH cur INTO board_unit_id,u_x,u_y,size,bu_p_num;
      IF NOT done THEN
        IF size=1 THEN 
          SELECT a.x,a.y INTO new_x,new_y FROM allcoords a
          LEFT JOIN board b ON (a.x=b.x AND a.y=b.y AND b.game_id=g_id)
          WHERE a.mode_id=mode_id AND quart(a.x,a.y)<>zone AND b.id IS NULL
          ORDER BY ((u_x-a.x)*(u_x-a.x)+(u_y-a.y)*(u_y-a.y)) LIMIT 1;
        ELSE 
          SELECT a.x,a.y INTO new_x,new_y FROM allcoords a
          WHERE a.mode_id=mode_id AND quart(a.x,a.y)<>zone AND quart(a.x+size-1,a.y+size-1)<>zone AND quart(a.x,a.y+size-1)<>zone AND quart(a.x+size-1,a.y)<>zone
          AND NOT EXISTS
              (SELECT b.id FROM board b
                  WHERE b.game_id=g_id
                    AND NOT (b.`type`='unit' AND b.ref = board_unit_id)
                    AND b.x BETWEEN a.x AND a.x+size-1
                    AND b.y BETWEEN a.y AND a.y+size-1 LIMIT 1)
          ORDER BY ((u_x-a.x)*(u_x-a.x)+(u_y-a.y)*(u_y-a.y)) LIMIT 1;
        END IF;
        CALL move_unit(board_unit_id,new_x,new_y);
        IF bu_p_num = p_num THEN
          UPDATE board_units SET moves_left=0 WHERE id=board_unit_id;
          CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);
        END IF;
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `units_to_zone` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `units_to_zone`(g_id INT, p_num INT, zone INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE u_x,u_y,new_x,new_y INT;
  DECLARE board_unit_id INT;
  DECLARE bu_p_num INT;
  DECLARE size INT;

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR
    SELECT b.ref,MIN(b.x),MIN(b.y),u.size,bu.player_num
    FROM board b
    JOIN board_units bu ON (b.ref=bu.id)
    JOIN units u ON (bu.unit_id=u.id)
    WHERE b.`type`='unit' AND b.game_id=g_id AND unit_feature_check(bu.id,'magic_immunity')=0
    AND quart(b.x,b.y)<>zone
    GROUP BY b.ref,u.size;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;

    OPEN cur;
    REPEAT
      FETCH cur INTO board_unit_id,u_x,u_y,size,bu_p_num;
      IF NOT done THEN
        IF size=1 THEN 
          SELECT a.x,a.y INTO new_x,new_y FROM allcoords a
          LEFT JOIN board b ON (a.x=b.x AND a.y=b.y AND b.game_id=g_id)
          WHERE a.mode_id=mode_id AND quart(a.x,a.y)=zone AND b.id IS NULL
          ORDER BY ((u_x-a.x)*(u_x-a.x)+(u_y-a.y)*(u_y-a.y)) LIMIT 1;
        ELSE 
          SELECT a.x,a.y INTO new_x,new_y FROM allcoords a
          WHERE a.mode_id=mode_id AND quart(a.x,a.y)=zone AND quart(a.x+size-1,a.y+size-1)=zone AND quart(a.x,a.y+size-1)=zone AND quart(a.x+size-1,a.y)=zone
          AND NOT EXISTS
              (SELECT b.id FROM board b
                  WHERE b.game_id=g_id
                    AND NOT (b.`type`='unit' AND b.ref = board_unit_id)
                    AND b.x BETWEEN a.x AND a.x+size-1
                    AND b.y BETWEEN a.y AND a.y+size-1 LIMIT 1)
          ORDER BY ((u_x-a.x)*(u_x-a.x)+(u_y-a.y)*(u_y-a.y)) LIMIT 1;
        END IF;
        CALL move_unit(board_unit_id,new_x,new_y);
        IF bu_p_num = p_num THEN
          UPDATE board_units SET moves_left=0 WHERE id=board_unit_id;
          CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);
        END IF;
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `unit_action_begin` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `unit_action_begin`(g_id INT, p_num INT)
BEGIN
  CALL user_action_begin();
  IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
    CALL start_moving_units(g_id,p_num);
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `unit_action_end` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `unit_action_end`(g_id INT,  p_num INT)
BEGIN
  IF (check_all_units_moved(g_id,p_num) = 1)
    AND (SELECT player_num FROM active_players WHERE game_id=g_id)=p_num 
  THEN
    CALL finish_moving_units(g_id,p_num);
    CALL end_units_phase(g_id,p_num);
  END IF;

  CALL user_action_end();
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `unit_add_attack` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `unit_add_attack`(board_unit_id INT,  qty INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;

  SELECT bu.game_id,bu.player_num INTO g_id,p_num FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

  UPDATE board_units SET attack=attack+qty WHERE id=board_unit_id;
  CALL cmd_unit_set_attack(g_id,p_num,board_unit_id);
  CALL cmd_log_add_message(g_id, p_num, 'unit_gets_attack', CONCAT_WS(';', log_unit(board_unit_id), qty));

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `unit_add_exp` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `unit_add_exp`(board_unit_id INT, qty INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE x,y INT;

  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'unit_add_exp($x,$y,$qty)';

  SELECT bu.game_id,bu.player_num INTO g_id,p_num FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;
  SELECT b.x,b.y INTO x,y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=board_unit_id LIMIT 1;

  UPDATE board_units SET experience = experience + qty WHERE id=board_unit_id;

  SET cmd=REPLACE(cmd,'$x',x);
  SET cmd=REPLACE(cmd,'$y',y);
  SET cmd=REPLACE(cmd,'$qty',qty);
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `unit_add_health` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `unit_add_health`(board_unit_id INT,  qty INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;

  SELECT bu.game_id,bu.player_num INTO g_id,p_num FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

  UPDATE board_units SET max_health=max_health+qty, health=health+qty WHERE id=board_unit_id;
  CALL cmd_unit_set_max_health(g_id,p_num,board_unit_id);
  CALL cmd_unit_set_health(g_id,p_num,board_unit_id);

  CALL cmd_log_add_message(g_id, p_num, 'unit_gets_health', CONCAT_WS(';', log_unit(board_unit_id), qty));

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `unit_add_moves` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `unit_add_moves`(board_unit_id INT,  qty INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;

  SELECT bu.game_id,bu.player_num INTO g_id,p_num FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

  UPDATE board_units SET moves=moves+qty, moves_left=moves_left+qty WHERE id=board_unit_id;
  CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);
  CALL cmd_unit_set_moves(g_id,p_num,board_unit_id);

  CALL cmd_log_add_message(g_id, p_num, 'unit_gets_moves', CONCAT_WS(';', log_unit(board_unit_id), qty));
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `unit_feature_remove` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `unit_feature_remove`(board_u_id INT, feature_code VARCHAR(45))
BEGIN
  DELETE FROM board_units_features
    WHERE board_unit_id=board_u_id AND feature_id=unit_feature_get_id_by_code(feature_code);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `unit_feature_set` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `unit_feature_set`(board_unit_id INT, feature_code VARCHAR(45),param_value INT)
BEGIN
  IF(unit_feature_check(board_unit_id,feature_code)=0)THEN 
    INSERT INTO board_units_features(board_unit_id,feature_id,param) SELECT board_unit_id,uf.id,param_value FROM unit_features uf WHERE uf.code=feature_code;
  ELSE 
    UPDATE board_units_features buf
      SET buf.param=param_value
      WHERE buf.board_unit_id=board_unit_id AND buf.feature_id=unit_feature_get_id_by_code(feature_code);
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `unit_level_up` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `unit_level_up`(g_id INT, p_num INT, x INT, y INT,  stat VARCHAR(10))
BEGIN
  DECLARE board_unit_id INT;
  DECLARE level_up_bonus INT DEFAULT 1;
  DECLARE log_msg_code_part VARCHAR(50) CHARSET utf8 DEFAULT 'unit_levelup_';
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'unit_level_up_$stat($x,$y)';
  
  
  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id LIMIT 1) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;
  ELSE
    IF (SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id LIMIT 1)<>0 THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=28;
    ELSE
      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;
      IF board_unit_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
      ELSE
        IF NOT p_num=(SELECT bu.player_num FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1) THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=16;
        ELSE
          IF check_unit_can_level_up(board_unit_id) = 0 THEN
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=41;
          ELSE

            CALL user_action_begin();
            IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
              CALL start_moving_units(g_id,p_num);
            END IF;

            UPDATE board_units bu SET level = level + 1 WHERE bu.id=board_unit_id;
            
            CASE stat
              WHEN 'attack' THEN
              BEGIN
                UPDATE board_units bu SET attack = attack + level_up_bonus WHERE bu.id=board_unit_id;
              END;
              WHEN 'moves' THEN
              BEGIN
                UPDATE board_units bu SET moves = moves + level_up_bonus WHERE bu.id=board_unit_id;
              END;
              WHEN 'health' THEN
              BEGIN
                UPDATE board_units bu SET health = health + level_up_bonus, max_health = max_health + level_up_bonus WHERE bu.id=board_unit_id;
              END;
            END CASE;
            
            CALL cmd_log_add_message(g_id, p_num, CONCAT(log_msg_code_part, stat), CONCAT_WS(';', log_unit(board_unit_id), level_up_bonus));
            
            SET cmd=REPLACE(cmd,'$stat',stat);
            SET cmd=REPLACE(cmd,'$x',x);
            SET cmd=REPLACE(cmd,'$y',y);
            INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);
            
            IF (check_all_units_moved(g_id,p_num) = 1) THEN
              CALL finish_moving_units(g_id,p_num);
              CALL end_units_phase(g_id,p_num);
            END IF;

            CALL user_action_end();
          END IF;
        END IF;
      END IF;
    END IF;
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `unit_level_up_attack` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `unit_level_up_attack`(g_id INT,p_num INT,x INT,y INT)
BEGIN
	CALL unit_level_up(g_id,p_num,x,y,'attack');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `unit_level_up_health` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `unit_level_up_health`(g_id INT,p_num INT,x INT,y INT)
BEGIN
	CALL unit_level_up(g_id,p_num,x,y,'health');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `unit_level_up_moves` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `unit_level_up_moves`(g_id INT,p_num INT,x INT,y INT)
BEGIN
	CALL unit_level_up(g_id,p_num,x,y,'moves');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `unit_push` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `unit_push`(board_unit_id_1 INT,  board_unit_id_2 INT)
BEGIN

  DECLARE g_id INT;
  DECLARE mode_id INT;
  DECLARE p_num INT; 
  DECLARE cur_unit1_id,cur_unit2_id INT;
  DECLARE cur_push_id INT;
  DECLARE x_min_1, x_max_1, y_min_1, y_max_1, x_min_2, x_max_2, y_min_2, y_max_2 INT; 
  DECLARE push_x,push_y INT DEFAULT 0;
  DECLARE unit_to_move_id INT;
  DECLARE move_x,move_y INT;
  DECLARE cur_sink_flag INT;

  DECLARE success INT;

  DECLARE done INT DEFAULT 0;

  DECLARE cur CURSOR FOR
    SELECT unit_id,x,y,sink_flag FROM move_queue ORDER BY id DESC;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SET success=1;

  CREATE TEMPORARY TABLE pushing_queue(
    id INT AUTO_INCREMENT PRIMARY KEY,
    `unit1_id` INT NOT NULL,
    `unit2_id` INT NOT NULL) ENGINE=MEMORY;

  CREATE TEMPORARY TABLE move_queue(
    id INT AUTO_INCREMENT PRIMARY KEY,
    `unit_id` INT NOT NULL,
    `x` INT NOT NULL,
    `y` INT NOT NULL,
    `sink_flag` INT NULL) ENGINE=MEMORY;

  SELECT bu.game_id INTO g_id FROM board_units bu WHERE bu.id=board_unit_id_1 LIMIT 1;
  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;

  INSERT INTO pushing_queue(unit1_id,unit2_id) VALUES (board_unit_id_1,board_unit_id_2);

  REPEAT

    SELECT q.unit1_id,q.unit2_id,q.id INTO cur_unit1_id,cur_unit2_id,cur_push_id FROM pushing_queue q ORDER BY q.id LIMIT 1;
    DELETE FROM pushing_queue WHERE id=cur_push_id;

    SELECT MIN(x),MAX(x),MIN(y),MAX(y)
      INTO x_min_1, x_max_1, y_min_1, y_max_1
      FROM board b
      WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=cur_unit1_id;

    SELECT MIN(x),MAX(x),MIN(y),MAX(y)
      INTO x_min_2, x_max_2, y_min_2, y_max_2
      FROM board b
      WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=cur_unit2_id;

    
    SET push_x=0;
    SET push_y=0;
    IF(x_max_2<x_min_1)THEN 
      SET push_x=-1;
    END IF;
    IF(x_min_2>x_max_1)THEN 
      SET push_x=1;
    END IF;
    IF(y_max_2<y_min_1)THEN 
      SET push_y=-1;
    END IF;
    IF(y_min_2>y_max_1)THEN 
      SET push_y=1;
    END IF;

    IF 
    (SELECT COUNT(*) FROM allcoords a
        WHERE a.mode_id=mode_id
          AND a.x BETWEEN x_min_2+push_x AND x_max_2+push_x
          AND a.y BETWEEN y_min_2+push_y AND y_max_2+push_y)<>((x_max_2-x_min_2+1) * (y_max_2-y_min_2+1))
    THEN
      SET success=0;
    ELSE
      IF 
      EXISTS
      (
        SELECT 1 FROM board b
          WHERE b.game_id=g_id AND b.`type`<>'unit'
            AND b.x BETWEEN x_min_2+push_x AND x_max_2+push_x
            AND b.y BETWEEN y_min_2+push_y AND y_max_2+push_y
      )
      THEN
        IF 
          NOT EXISTS
          (SELECT 1 FROM board b
            WHERE b.game_id=g_id AND b.`type`<>'unit'
              AND b.x BETWEEN x_min_2+push_x AND x_max_2+push_x
              AND b.y BETWEEN y_min_2+push_y AND y_max_2+push_y
              AND building_feature_check(b.ref,'water')=0 
          )
        THEN
          
          INSERT INTO move_queue(unit_id,x,y,sink_flag) VALUES(cur_unit2_id,x_min_2+push_x,y_min_2+push_y,1);
        ELSE
          SET success=0;
        END IF;
      ELSE

        INSERT INTO move_queue(unit_id,x,y) VALUES(cur_unit2_id,x_min_2+push_x,y_min_2+push_y);

        
        INSERT INTO pushing_queue(unit1_id,unit2_id)
        SELECT cur_unit2_id,b.ref FROM board b
          WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref<>cur_unit2_id
            AND b.x BETWEEN x_min_2+push_x AND x_max_2+push_x
            AND b.y BETWEEN y_min_2+push_y AND y_max_2+push_y;

      END IF;
    END IF;

  UNTIL success=0 OR NOT EXISTS(SELECT 1 FROM pushing_queue LIMIT 1) END REPEAT;

  IF(success=1)THEN

    SELECT bu.player_num INTO p_num FROM board_units bu WHERE bu.id=board_unit_id_1 LIMIT 1;
    CALL cmd_log_add_message(g_id, p_num, 'unit_pushes', CONCAT_WS(';', log_unit(board_unit_id_1), log_unit(board_unit_id_2)));
    
    OPEN cur;
    REPEAT
      FETCH cur INTO unit_to_move_id,move_x,move_y,cur_sink_flag;
      IF NOT done THEN
        CALL move_unit(unit_to_move_id,move_x,move_y);
        IF(cur_sink_flag IS NOT NULL)THEN
          CALL sink_unit(unit_to_move_id,p_num);
        END IF;
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur;

  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `unit_shoot` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `unit_shoot`(g_id INT,   p_num INT,   x INT,   y INT,   x2 INT,   y2 INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE shooting_unit_id INT;
  DECLARE aim_type VARCHAR(45);
  DECLARE aim_board_id INT;
  DECLARE aim_unit_id INT;
  DECLARE distance INT;
  DECLARE dice INT;
  DECLARE chance INT;
  DECLARE damage_modificator INT DEFAULT 0;
  DECLARE damage INT;
  DECLARE miss INT DEFAULT 0;
  DECLARE health_before_hit,experience INT;
  DECLARE aim_no_exp INT DEFAULT 0;

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id = g_id LIMIT 1;
  SET err_code = check_unit_can_do_action(g_id,p_num,x,y,'unit_shoot'); 
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;
    SELECT bu.unit_id INTO shooting_unit_id FROM board_units bu WHERE bu.id = board_unit_id;
    SELECT b.type, b.ref INTO aim_type, aim_board_id FROM board b WHERE b.game_id = g_id AND b.x = x2 AND b.y = y2 LIMIT 1;
    IF aim_board_id IS NULL THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='no_valid_target';
    ELSE
      IF NOT EXISTS (SELECT id FROM shooting_params sp WHERE sp.unit_id = shooting_unit_id AND sp.aim_type = aim_type LIMIT 1) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='invalid_target_for_this_unit';
      ELSE
        SET distance = get_distance_from_unit_to_object(board_unit_id, aim_type, aim_board_id);
        IF distance < (SELECT MIN(sp.distance) FROM shooting_params sp WHERE sp.unit_id = shooting_unit_id AND sp.aim_type = aim_type) THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='target_too_close';
        ELSE
          IF distance > (SELECT MAX(sp.distance) FROM shooting_params sp WHERE sp.unit_id = shooting_unit_id AND sp.aim_type = aim_type) THEN
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='target_too_far';
          ELSE

            CALL unit_action_begin(g_id, p_num);

            UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
            CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);
            
            IF aim_type = 'unit' THEN
              SELECT bu.unit_id INTO aim_unit_id FROM board_units bu WHERE bu.id = aim_board_id LIMIT 1;
              IF EXISTS (SELECT 1 FROM attack_bonus ab WHERE ab.mode_id=mode_id AND ab.unit_id IS NULL AND ab.aim_type='unit' AND ab.aim_id=aim_unit_id) THEN
                SELECT ab.dice_max, ab.chance, ab.damage_bonus INTO dice, chance, damage_modificator FROM attack_bonus ab WHERE ab.mode_id=mode_id AND ab.unit_id IS NULL AND ab.aim_type='unit' AND ab.aim_id=aim_unit_id LIMIT 1;
                IF get_random_int_between(1, dice) < chance THEN
                  SET miss=1;
                END IF;
              END IF;
              SELECT bu.health INTO health_before_hit FROM board_units bu WHERE bu.id=aim_board_id LIMIT 1;
            ELSE
              IF(building_feature_check(aim_board_id,'no_exp')=1) THEN 
                SET aim_no_exp = 1;
              END IF;
              SELECT bb.health INTO health_before_hit FROM board_buildings bb WHERE bb.id=aim_board_id LIMIT 1;
            END IF;

            IF miss=0 THEN
              SELECT sp.dice_max, sp.chance, get_random_int_between(sp.damage_modificator_min, sp.damage_modificator_max) + damage_modificator
                INTO dice, chance, damage_modificator
                FROM shooting_params sp WHERE sp.unit_id = shooting_unit_id AND sp.aim_type = aim_type AND sp.distance = distance LIMIT 1;

              IF get_random_int_between(1, dice) < chance THEN
                SET miss=1;
              END IF;
            END IF;

            INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'unit_attack');
            IF miss=1 THEN
              INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'miss_attack');
              IF aim_type = 'unit' THEN
                CALL cmd_log_add_message(g_id, p_num, 'unit_shoots_unit_miss', CONCAT_WS(';', log_unit(board_unit_id), log_unit(aim_board_id)));
              ELSE
                CALL cmd_log_add_message(g_id, p_num, 'unit_shoots_building_miss', CONCAT_WS(';', log_unit(board_unit_id), log_building(aim_board_id)));
              END IF;
            ELSE
              SELECT bu.attack + damage_modificator INTO damage FROM board_units bu WHERE bu.id=board_unit_id;

              CASE aim_type
                WHEN 'unit' THEN CALL cmd_log_add_message(g_id, p_num, 'unit_shoots_unit', CONCAT_WS(';', log_unit(board_unit_id), log_unit(aim_board_id), damage));
                ELSE CALL cmd_log_add_message(g_id, p_num, 'unit_shoots_building', CONCAT_WS(';', log_unit(board_unit_id), log_building(aim_board_id), damage));
              END CASE;

              IF (aim_type = 'unit' AND unit_feature_check(aim_board_id, 'agressive') = 1) THEN
                CALL unit_feature_set(aim_board_id,'attack_target',board_unit_id);
              END IF;

              CASE aim_type
                WHEN 'unit' THEN CALL hit_unit(aim_board_id, p_num, damage);
                WHEN 'building' THEN CALL hit_building(aim_board_id, p_num, damage);
                WHEN 'castle' THEN CALL hit_castle(aim_board_id, p_num, damage);
              END CASE;

              SET experience = get_experience_for_hitting(aim_board_id, aim_type, health_before_hit);
              IF (experience > 0 AND aim_no_exp = 0) THEN
                CALL unit_add_exp(board_unit_id, experience);
              END IF;
            END IF;

            CALL unit_action_end(g_id, p_num);

          END IF;
        END IF;
      END IF;
    END IF;
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `user_action_begin` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `user_action_begin`()
BEGIN

  CREATE TEMPORARY TABLE IF NOT EXISTS `lords`.`command` (
    `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
    `game_id` int(10) unsigned NOT NULL,
    `player_num` int(10) unsigned NOT NULL DEFAULT '0',
    `command` varchar(1000) NOT NULL,
    `hidden_flag` int(11) NOT NULL DEFAULT '0',
    PRIMARY KEY (`id`)
  ) DEFAULT CHARSET=utf8;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `user_action_end` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `user_action_end`()
BEGIN

  INSERT INTO log_commands(game_id,player_num,command,hidden_flag)
  SELECT
    command.game_id,
    command.player_num,
    command.command,
    command.hidden_flag
  FROM command WHERE
    command.command LIKE 'log_add_message%'
    OR
    command.command LIKE 'log_add_independent_message%'
    OR
    command.command LIKE 'log_add_container%'
    OR
    command.command LIKE 'log_close_container%'
    OR
    command.command LIKE 'log_add_move_message%'
    OR
    command.command LIKE 'log_add_attack_unit_message%'
    OR
    command.command LIKE 'log_add_attack_building_message%';

  SELECT p.user_id, command, hidden_flag
  FROM command c LEFT JOIN players p ON (c.game_id=p.game_id AND c.player_num=p.player_num);

  DROP TEMPORARY TABLE `lords`.`command`;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `vampire_resurrect_by_card` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `vampire_resurrect_by_card`(vamp_board_id INT, grave_id INT)
BEGIN
  DECLARE dead_card_id INT;
  DECLARE dice_max INT DEFAULT 2;
  DECLARE chance INT DEFAULT 1;
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE vamp_owner INT DEFAULT 4;
  DECLARE new_player INT;
  DECLARE new_unit_id INT;
  DECLARE new_move_order INT;
  DECLARE u_id INT;
  DECLARE vamp_name VARCHAR(45) CHARSET utf8 DEFAULT '{vampire} {$u_id}';

  IF get_random_int_between(1, dice_max) > chance THEN 
    SELECT bu.game_id, bu.player_num INTO g_id, p_num FROM board_units bu WHERE bu.id=vamp_board_id LIMIT 1;

    SELECT CASE WHEN MAX(p.player_num)<10 THEN 10 ELSE MAX(p.player_num)+1 END INTO new_player FROM players p WHERE p.game_id=g_id;

    SELECT g.card_id INTO dead_card_id FROM graves g WHERE id=grave_id;
    SELECT c.ref INTO u_id FROM cards c WHERE c.id=dead_card_id LIMIT 1;

    SET vamp_name=REPLACE(vamp_name,'$u_id', u_id);
    SET new_move_order = get_move_order_for_new_npc(g_id, p_num);

    UPDATE players SET move_order = move_order + 1 WHERE game_id = g_id AND move_order >= new_move_order;
    INSERT INTO players(game_id,player_num,name,gold,owner,team,move_order,language_id) VALUES(g_id,new_player,vamp_name,0,vamp_owner,get_unit_team(vamp_board_id),new_move_order,get_player_language_id(g_id,p_num));

    INSERT INTO board_units(game_id,player_num,card_id) VALUES (g_id,new_player,dead_card_id);
    SET new_unit_id=@@last_insert_id;
    INSERT INTO board_units_features(board_unit_id,feature_id,param) SELECT new_unit_id,ufu.feature_id,ufu.param FROM unit_default_features ufu WHERE ufu.unit_id=u_id;

    INSERT INTO board(game_id,x,y,`type`,ref) SELECT g_id,gc.x,gc.y,'unit',new_unit_id FROM grave_cells gc WHERE gc.grave_id=grave_id;
    DELETE FROM graves WHERE game_id=g_id AND id=grave_id;

    CALL unit_feature_set(new_unit_id,'vamp',NULL);

    CALL cmd_add_player(g_id,new_player);
    CALL cmd_add_unit(g_id,new_player,new_unit_id);
    CALL cmd_remove_from_grave(g_id,p_num,grave_id);

    CALL cmd_log_add_message(g_id, p_num, 'unit_becomes_vampire', log_unit(new_unit_id));

  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `vampire_resurrect_by_u_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `vampire_resurrect_by_u_id`(vamp_board_id INT, u_id INT, x INT, y INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE dice_max INT DEFAULT 2;
  DECLARE chance INT DEFAULT 1;
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE vamp_owner INT DEFAULT 4;
  DECLARE new_player INT;
  DECLARE new_unit_id INT;
  DECLARE new_move_order INT;
  DECLARE size INT;
  DECLARE vamp_name VARCHAR(45) CHARSET utf8 DEFAULT '{vampire} {$u_id}';

  IF get_random_int_between(1, dice_max) > chance THEN 
    SELECT bu.game_id, bu.player_num INTO g_id, p_num FROM board_units bu WHERE bu.id=vamp_board_id LIMIT 1;
    SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;

    SELECT CASE WHEN MAX(p.player_num)<10 THEN 10 ELSE MAX(p.player_num)+1 END INTO new_player FROM players p WHERE p.game_id=g_id;

    SET vamp_name=REPLACE(vamp_name,'$u_id', u_id);
    SET new_move_order = get_move_order_for_new_npc(g_id, p_num);

    UPDATE players SET move_order = move_order + 1 WHERE game_id = g_id AND move_order >= new_move_order;
    INSERT INTO players(game_id,player_num,name,gold,owner,team,move_order,language_id) VALUES(g_id,new_player,vamp_name,0,vamp_owner,get_unit_team(vamp_board_id),new_move_order,get_player_language_id(g_id,p_num));

    INSERT INTO board_units(game_id,player_num,unit_id) VALUES(g_id,new_player,u_id);
    SET new_unit_id=@@last_insert_id;
    INSERT INTO board_units_features(board_unit_id,feature_id,param) SELECT new_unit_id,ufu.feature_id,ufu.param FROM unit_default_features ufu WHERE ufu.unit_id=u_id;

    SELECT u.size INTO size FROM units u WHERE u.id=u_id LIMIT 1;

    INSERT INTO board(game_id,x,y,`type`,ref) SELECT g_id,a.x,a.y,'unit',new_unit_id FROM allcoords a WHERE a.mode_id=mode_id AND a.x BETWEEN x AND x+size-1 AND a.y BETWEEN y AND y+size-1;

    CALL unit_feature_set(new_unit_id,'vamp',NULL);

    CALL cmd_add_player(g_id,new_player);
    CALL cmd_add_unit_by_id(g_id,new_player,new_unit_id);

    CALL cmd_log_add_message(g_id, p_num, 'unit_becomes_vampire', log_unit(new_unit_id));

  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `vred_player_takes_card_from_everyone` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `vred_player_takes_card_from_everyone`(g_id INT, p_num INT)
BEGIN
  DECLARE p2_num INT; 
  DECLARE random_card INT;
  DECLARE player_deck_id INT;

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT DISTINCT p.player_num FROM player_deck p WHERE p.game_id=g_id AND p.player_num<>p_num;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;
    REPEAT
      FETCH cur INTO p2_num;
      IF NOT done THEN
        SELECT id,card_id INTO player_deck_id,random_card FROM player_deck p WHERE p.game_id=g_id AND p.player_num=p2_num ORDER BY RAND() LIMIT 1;
        UPDATE player_deck SET player_num=p_num WHERE id=player_deck_id;

        CALL cmd_add_card(g_id,p_num,player_deck_id);
        CALL cmd_remove_card(g_id,p2_num,player_deck_id);

        CALL cmd_log_add_message_hidden(g_id, p_num, 'vred_got_card_from', CONCAT_WS(';', log_player(g_id, p2_num), random_card));
        CALL cmd_log_add_message_hidden(g_id, p2_num, 'vred_gave_card_to', CONCAT_WS(';', log_player(g_id, p_num), random_card));
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `vred_pooring` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `vred_pooring`(g_id INT, p_num INT)
BEGIN
  DECLARE pooring_sum INT DEFAULT 60;

  UPDATE players SET gold=CASE WHEN gold<pooring_sum THEN 0 ELSE gold-pooring_sum END WHERE game_id=g_id AND player_num=p_num;
  CALL cmd_player_set_gold(g_id,p_num);
  CALL cmd_log_add_message(g_id, p_num, 'player_loses_gold', CONCAT_WS(';', log_player(g_id, p_num), pooring_sum));

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wall_close` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `wall_close`(g_id INT, p_num INT, x INT, y INT)
BEGIN
  DECLARE g_mode INT;
  DECLARE err_code INT;
  DECLARE board_building_id INT;
  DECLARE current_turn INT;
  DECLARE old_wall_building_id INT;
  DECLARE new_wall_building_id INT;
  DECLARE rotation,flip,x_min,y_min INT;

  SELECT g.mode_id INTO g_mode FROM games g WHERE g.id=g_id LIMIT 1;

  SET err_code=check_building_can_do_action(g_id,p_num,x,y,'wall_close'); 
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    SELECT b.ref INTO board_building_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`<>'unit' LIMIT 1;
    SELECT turn INTO current_turn FROM active_players WHERE game_id=g_id;

    SELECT MIN(b.x),MIN(b.y) INTO x_min,y_min FROM board b WHERE b.game_id=g_id AND b.`type`<>'unit' AND b.ref=board_building_id;
    SELECT bb.rotation,bb.flip,bb.building_id INTO rotation,flip,old_wall_building_id FROM board_buildings bb WHERE bb.id=board_building_id LIMIT 1;

    SELECT v.building_id INTO new_wall_building_id FROM  vw_mode_building_default_features v WHERE v.mode_id=g_mode AND v.feature_id=building_feature_get_id_by_code('wall_closed');

    UPDATE board_buildings SET building_id=new_wall_building_id WHERE id=board_building_id;

    
    UPDATE board SET ref=0 WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=board_building_id;

    CALL place_building_on_board(board_building_id,x_min,y_min,rotation,flip);

    IF NOT EXISTS(SELECT id FROM board WHERE game_id=g_id AND `type`<>'unit' AND ref=board_building_id) THEN 
      UPDATE board SET ref=board_building_id WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0;
      UPDATE board_buildings SET building_id=old_wall_building_id WHERE id=board_building_id;
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=12;
    ELSE
      CALL user_action_begin();

      DELETE FROM board WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0; 

      IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
        CALL start_moving_units(g_id,p_num);
      END IF;

      CALL cmd_destroy_building(g_id,p_num,board_building_id);
      CALL cmd_put_building_by_id(g_id,p_num,board_building_id);
      CALL cmd_building_set_health(g_id,p_num,board_building_id);

      CALL building_feature_set(board_building_id,'turn_when_changed',current_turn);

      CALL cmd_log_add_message(g_id, p_num, 'building_closes', log_building(board_building_id));

      CALL user_action_end();
    END IF;
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wall_open` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `wall_open`(g_id INT, p_num INT, x INT, y INT)
BEGIN
  DECLARE g_mode INT;
  DECLARE err_code INT;
  DECLARE board_building_id INT;
  DECLARE current_turn INT;
  DECLARE old_wall_building_id INT;
  DECLARE new_wall_building_id INT;
  DECLARE rotation,flip,x_min,y_min INT;

  SELECT g.mode_id INTO g_mode FROM games g WHERE g.id=g_id LIMIT 1;

  SET err_code=check_building_can_do_action(g_id,p_num,x,y,'wall_open'); 
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    SELECT b.ref INTO board_building_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`<>'unit' LIMIT 1;
    SELECT turn INTO current_turn FROM active_players WHERE game_id=g_id;

    SELECT MIN(b.x),MIN(b.y) INTO x_min,y_min FROM board b WHERE b.game_id=g_id AND b.`type`<>'unit' AND b.ref=board_building_id;
    SELECT bb.rotation,bb.flip,bb.building_id INTO rotation,flip,old_wall_building_id FROM board_buildings bb WHERE bb.id=board_building_id LIMIT 1;

    SELECT v.building_id INTO new_wall_building_id FROM  vw_mode_building_default_features v WHERE v.mode_id=g_mode AND v.feature_id=building_feature_get_id_by_code('wall_opened');

    UPDATE board_buildings SET building_id=new_wall_building_id WHERE id=board_building_id;

    
    UPDATE board SET ref=0 WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=board_building_id;

    CALL place_building_on_board(board_building_id,x_min,y_min,rotation,flip);

    IF NOT EXISTS(SELECT id FROM board WHERE game_id=g_id AND `type`<>'unit' AND ref=board_building_id) THEN 
      UPDATE board SET ref=board_building_id WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0;
      UPDATE board_buildings SET building_id=old_wall_building_id WHERE id=board_building_id;
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=12;
    ELSE
      CALL user_action_begin();

      DELETE FROM board WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0; 

      IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
        CALL start_moving_units(g_id,p_num);
      END IF;

      CALL cmd_destroy_building(g_id,p_num,board_building_id);
      CALL cmd_put_building_by_id(g_id,p_num,board_building_id);
      CALL cmd_building_set_health(g_id,p_num,board_building_id);

      CALL building_feature_set(board_building_id,'turn_when_changed',current_turn);

      CALL cmd_log_add_message(g_id, p_num, 'building_opens', log_building(board_building_id));

      CALL user_action_end();
    END IF;
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wizard_fireball` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `wizard_fireball`(g_id INT,    p_num INT,    x INT,    y INT,     x2 INT,     y2 INT)
BEGIN
  DECLARE err_code INT;
  DECLARE aim_bu_id INT;
  DECLARE board_unit_id INT;
  DECLARE dice INT;
  DECLARE fb_damage INT DEFAULT 1;
  DECLARE health_before_hit,experience INT;

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'wizard_fireball'); 
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
      SELECT b.ref INTO aim_bu_id FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.x=x2 AND b.y=y2 LIMIT 1;
      IF aim_bu_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=33;
      ELSE
        CALL unit_action_begin(g_id, p_num);

        SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;
        SELECT bu.health INTO health_before_hit FROM board_units bu WHERE bu.id=aim_bu_id LIMIT 1;

        UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
        CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

        CALL cmd_log_add_message(g_id, p_num, 'unit_casts_fb', CONCAT_WS(';', log_unit(board_unit_id), log_unit(aim_bu_id)));

        SET dice = get_random_int_between(1, 6);

        IF dice=1 THEN 
          IF get_random_int_between(1, 6) < 6 THEN
            CALL cmd_log_add_message(g_id, p_num, 'miss_rus_rul', log_unit(board_unit_id));
          ELSE
            CALL magic_kill_unit(board_unit_id,p_num);
          END IF;
        ELSE
          IF dice IN (5,6) THEN 
            IF get_random_int_between(1, 6) < 3 THEN
              CALL cmd_miss_game_log(g_id,x2,y2);
            ELSE
              CALL magical_damage(g_id,p_num,x2,y2,fb_damage);
              
              SET experience = get_experience_for_hitting(aim_bu_id, 'unit', health_before_hit);
              IF(experience > 0)THEN
                CALL unit_add_exp(board_unit_id, experience);
              END IF;
            END IF;
          ELSE 
            CALL cmd_log_add_message(g_id, p_num, 'cast_unsuccessful', NULL);
          END IF;
        END IF;

        INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'magical_attack');

        CALL unit_action_end(g_id, p_num);
      END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `wizard_heal` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `wizard_heal`(g_id INT,   p_num INT,   x INT,   y INT,    x2 INT,    y2 INT)
BEGIN
  DECLARE err_code INT;
  DECLARE aim_bu_id INT;
  DECLARE board_unit_id INT;
  DECLARE hp_heal INT DEFAULT 1;

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'wizard_heal'); 
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;
    SELECT b.ref INTO aim_bu_id FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.x=x2 AND b.y=y2 LIMIT 1;
    IF aim_bu_id IS NULL THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=32;
    ELSE
      IF get_distance_between_units(board_unit_id, aim_bu_id) <> 1 THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=29;
      ELSE
        CALL unit_action_begin(g_id, p_num);

        UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
        CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

        CALL cmd_log_add_message(g_id, p_num, 'unit_heals', CONCAT_WS(';', log_unit(board_unit_id), log_unit(aim_bu_id)));

        CALL magical_heal(g_id,p_num,x2,y2,hp_heal);

        CALL unit_action_end(g_id, p_num);
      END IF;
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `zombies_change_player_to_nec` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `zombies_change_player_to_nec`(nec_board_id INT)
BEGIN
  DECLARE g_id INT;
  DECLARE zombie_board_id INT;
  DECLARE nec_p_num,zombie_p_num INT;
  DECLARE npc_gold INT;

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR
    SELECT buf.board_unit_id,bu.player_num
    FROM board_units_features buf JOIN board_units bu ON (buf.board_unit_id=bu.id)
    WHERE buf.feature_id=unit_feature_get_id_by_code('under_control') AND buf.param=nec_board_id AND bu.player_num<>nec_p_num;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SELECT bu.game_id,bu.player_num INTO g_id,nec_p_num FROM board_units bu WHERE bu.id=nec_board_id LIMIT 1;

    OPEN cur;
    REPEAT
      FETCH cur INTO zombie_board_id,zombie_p_num;
      IF NOT done THEN

          UPDATE board_units SET player_num=nec_p_num,moves_left=0 WHERE id=zombie_board_id;
          CALL cmd_unit_set_owner(g_id,nec_p_num,zombie_board_id);
          CALL cmd_unit_set_moves_left(g_id,nec_p_num,zombie_board_id);

          IF ((SELECT owner FROM players WHERE game_id=g_id AND player_num=zombie_p_num LIMIT 1)<>1)
            AND NOT EXISTS (SELECT id FROM board_units WHERE game_id=g_id AND player_num=zombie_p_num)
            AND NOT EXISTS (SELECT id FROM board_buildings WHERE game_id=g_id AND player_num=zombie_p_num)
          THEN
            SELECT gold INTO npc_gold FROM players WHERE game_id=g_id AND player_num=zombie_p_num LIMIT 1; 
            IF(npc_gold>0)THEN
              UPDATE players SET gold=gold+riching_sum WHERE game_id=g_id AND player_num=nec_p_num;
              CALL cmd_player_set_gold(g_id,nec_p_num);
            END IF;

            DELETE FROM players WHERE game_id=g_id AND player_num=zombie_p_num; 
            CALL cmd_delete_player(g_id,zombie_p_num);
          END IF;

      END IF;
    UNTIL done END REPEAT;
    CLOSE cur;


END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `zombies_make_mad` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `zombies_make_mad`(g_id INT, nec_board_id INT)
BEGIN
  DECLARE zombie_board_id INT;
  DECLARE zombie_u_id INT;
  DECLARE zombie_p_num INT;
  DECLARE new_move_order INT;
  DECLARE new_player, team INT;
  DECLARE zombie_name_template VARCHAR(45) CHARSET utf8 DEFAULT '{zombie} {$u_id}';
  DECLARE zombie_name VARCHAR(45) CHARSET utf8;

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR
    SELECT buf.board_unit_id,bu.player_num,bu.unit_id
    FROM board_units_features buf JOIN board_units bu ON (buf.board_unit_id=bu.id)
    WHERE buf.feature_id=unit_feature_get_id_by_code('under_control') AND buf.param=nec_board_id;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  IF EXISTS (SELECT bu.id FROM board_units bu WHERE bu.id=nec_board_id LIMIT 1) THEN
    SET team = get_unit_team(nec_board_id);
  ELSE
    SET team = get_new_team_number(g_id);
  END IF;

  SET done=0;
  OPEN cur;
  REPEAT
    FETCH cur INTO zombie_board_id,zombie_p_num,zombie_u_id;
    IF NOT done THEN

      IF EXISTS(SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id AND bu.player_num=zombie_p_num AND bu.id<>zombie_board_id LIMIT 1)
        OR EXISTS(SELECT bb.id FROM board_buildings bb WHERE bb.game_id=g_id AND bb.player_num=zombie_p_num LIMIT 1)
      THEN

        SET zombie_name=REPLACE(zombie_name_template,'$u_id', zombie_u_id);
        SELECT CASE WHEN MAX(p.player_num)<10 THEN 10 ELSE MAX(p.player_num)+1 END INTO new_player FROM players p WHERE p.game_id=g_id;
        SET new_move_order = get_move_order_for_new_npc(g_id, get_current_p_num(g_id));

        UPDATE players SET move_order = move_order + 1 WHERE game_id = g_id AND move_order >= new_move_order;
        INSERT INTO players(game_id,player_num,name,gold,owner,team,move_order,language_id) VALUES(g_id,new_player,zombie_name,0,2,team,new_move_order,get_player_language_id(g_id, zombie_p_num));
        CALL cmd_add_player(g_id,new_player);

        UPDATE board_units SET player_num=new_player WHERE id=zombie_board_id;
        CALL cmd_unit_set_owner(g_id,zombie_p_num,zombie_board_id);

      END IF;
    END IF;
  UNTIL done END REPEAT;
  CLOSE cur;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Current Database: `lords_site`
--

/*!40000 DROP DATABASE IF EXISTS `lords_site`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `lords_site` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `lords_site`;

--
-- Table structure for table `arena_game_players`
--

DROP TABLE IF EXISTS `arena_game_players`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `arena_game_players` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `game_id` int(10) unsigned NOT NULL,
  `spectator_flag` int(11) NOT NULL,
  `team` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `game_id` (`game_id`),
  CONSTRAINT `arena_game_players_ibfk_1` FOREIGN KEY (`game_id`) REFERENCES `arena_games` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `arena_game_players`
--

LOCK TABLES `arena_game_players` WRITE;
/*!40000 ALTER TABLE `arena_game_players` DISABLE KEYS */;
/*!40000 ALTER TABLE `arena_game_players` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `arena_games`
--

DROP TABLE IF EXISTS `arena_games`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `arena_games` (
  `id` int(10) unsigned NOT NULL,
  `title` varchar(45) NOT NULL,
  `pass` varchar(45) DEFAULT NULL,
  `owner_id` int(10) unsigned NOT NULL,
  `time_restriction` int(10) unsigned NOT NULL DEFAULT '0',
  `status_id` int(10) unsigned NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `mode_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `arena_games`
--

LOCK TABLES `arena_games` WRITE;
/*!40000 ALTER TABLE `arena_games` DISABLE KEYS */;
/*!40000 ALTER TABLE `arena_games` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `arena_games_features_usage`
--

DROP TABLE IF EXISTS `arena_games_features_usage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `arena_games_features_usage` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `game_id` int(10) unsigned NOT NULL,
  `feature_id` int(10) unsigned NOT NULL,
  `value` int(11) DEFAULT NULL,
  `feature_type` enum('bool','int') NOT NULL,
  PRIMARY KEY (`id`),
  KEY `game_id` (`game_id`),
  CONSTRAINT `arena_games_features_usage_ibfk_1` FOREIGN KEY (`game_id`) REFERENCES `arena_games` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `arena_games_features_usage`
--

LOCK TABLES `arena_games_features_usage` WRITE;
/*!40000 ALTER TABLE `arena_games_features_usage` DISABLE KEYS */;
/*!40000 ALTER TABLE `arena_games_features_usage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `arena_users`
--

DROP TABLE IF EXISTS `arena_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `arena_users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `status_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `arena_users`
--

LOCK TABLES `arena_users` WRITE;
/*!40000 ALTER TABLE `arena_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `arena_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chat_users`
--

DROP TABLE IF EXISTS `chat_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chat_users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `chat_id` int(10) unsigned NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `chat_id` (`chat_id`),
  CONSTRAINT `chat_users_ibfk_1` FOREIGN KEY (`chat_id`) REFERENCES `chats` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chat_users`
--

LOCK TABLES `chat_users` WRITE;
/*!40000 ALTER TABLE `chat_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `chat_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chats`
--

DROP TABLE IF EXISTS `chats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chats` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `topic` varchar(1000) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chats`
--

LOCK TABLES `chats` WRITE;
/*!40000 ALTER TABLE `chats` DISABLE KEYS */;
/*!40000 ALTER TABLE `chats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dic_game_types`
--

DROP TABLE IF EXISTS `dic_game_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dic_game_types` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dic_game_types`
--

LOCK TABLES `dic_game_types` WRITE;
/*!40000 ALTER TABLE `dic_game_types` DISABLE KEYS */;
INSERT INTO `dic_game_types` VALUES (1,'arena'),(2,'league'),(3,'campaign');
/*!40000 ALTER TABLE `dic_game_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dic_player_status`
--

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

--
-- Table structure for table `dic_player_status_i18n`
--

DROP TABLE IF EXISTS `dic_player_status_i18n`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dic_player_status_i18n` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `player_status_id` int(10) unsigned NOT NULL,
  `language_id` int(10) unsigned NOT NULL,
  `description` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `player_status_id` (`player_status_id`),
  CONSTRAINT `dic_player_status_i18n_ibfk_1` FOREIGN KEY (`player_status_id`) REFERENCES `dic_player_status` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dic_player_status_i18n`
--

LOCK TABLES `dic_player_status_i18n` WRITE;
/*!40000 ALTER TABLE `dic_player_status_i18n` DISABLE KEYS */;
INSERT INTO `dic_player_status_i18n` VALUES (1,1,2,'Онлайн'),(2,2,2,'Ждет старта игры'),(3,3,2,'В игре'),(4,4,2,'Офлайн'),(5,1,1,'Online'),(6,2,1,'Waiting for a game to start'),(7,3,1,'In game'),(8,4,1,'Offline');
/*!40000 ALTER TABLE `dic_player_status_i18n` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `error_dictionary`
--

DROP TABLE IF EXISTS `error_dictionary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `error_dictionary` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `error_dictionary`
--

LOCK TABLES `error_dictionary` WRITE;
/*!40000 ALTER TABLE `error_dictionary` DISABLE KEYS */;
INSERT INTO `error_dictionary` VALUES (1,'login_exists'),(2,'empty_login_or_pass'),(3,'incorrect_login_or_pass'),(4,'incorrect_user_id'),(5,'incorrect_chat_id'),(6,'not_in_chat'),(7,'cant_change_common_chat_topic'),(8,'not_in_arena'),(9,'time_limit_not_positive'),(10,'incorrect_mode'),(11,'no_right_to_modify_game_features'),(12,'incorrect_feature_for_game'),(13,'incorrect_game_pass'),(14,'in_another_game'),(15,'cant_modify_game_features_after_start'),(16,'incorrect_game'),(17,'cant_enter_game_after_start'),(18,'incorrect_spectator_flag'),(19,'no_right_to_modify_teams'),(20,'cant_modify_teams_after_start'),(21,'player_not_in_game'),(22,'no_right_to_remove_player'),(23,'cant_remove_player_after_start'),(24,'cant_leave_common_chat'),(25,'incorrect_team'),(26,'no_right_to_start_game'),(27,'game_already_started'),(28,'incorrect_number_of_players'),(29,'game_not_started'),(30,'already_created_another_game'),(31,'cant_exit_arena_while_in_game'),(32,'already_in_chat'),(33,'incorrect_game_feature_value'),(34,'self_chat'),(35,'incorrect_language_code'),(36,'unavailable_for_guest_users'),(37,'incorrect_bot_id'),(38,'bot_is_not_in_this_game'),(39,'everyone_is_in_the_same_team');
/*!40000 ALTER TABLE `error_dictionary` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `error_dictionary_i18n`
--

DROP TABLE IF EXISTS `error_dictionary_i18n`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `error_dictionary_i18n` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `error_id` int(10) unsigned NOT NULL,
  `language_id` int(10) unsigned NOT NULL,
  `description` varchar(200) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `error_id` (`error_id`),
  CONSTRAINT `error_dictionary_i18n_ibfk_1` FOREIGN KEY (`error_id`) REFERENCES `error_dictionary` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=79 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `error_dictionary_i18n`
--

LOCK TABLES `error_dictionary_i18n` WRITE;
/*!40000 ALTER TABLE `error_dictionary_i18n` DISABLE KEYS */;
INSERT INTO `error_dictionary_i18n` VALUES (1,1,2,'Логин {0} существует'),(2,2,2,'Пустой логин или пароль'),(3,3,2,'Неверный логин или пароль'),(4,4,2,'Неправильный user_id'),(5,5,2,'Неправильный chat_id'),(6,6,2,'Вас нет в этом чате'),(7,7,2,'Нельзя изменить тему общего чата'),(8,8,2,'Вас нет в арене'),(9,9,2,'Ограничение по времени должно быть положительным'),(10,10,2,'Нет такого мода'),(11,11,2,'Только создатель игры может добавлять и удалять фичи'),(12,12,2,'Для этой игры нет такой фичи'),(13,13,2,'Неправильный пароль к игре'),(14,14,2,'Вы уже находитесь в другой игре'),(15,15,2,'Нельзя добавлять и удалять фичи после начала игры'),(16,16,2,'Нет такой игры'),(17,17,2,'Нельзя войти в игру после начала игры'),(18,18,2,'Неправильный spectator_flag'),(19,19,2,'Только создатель игры может менять команды игроков'),(20,20,2,'Нельзя менять команды после начала игры'),(21,21,2,'Этого игрока нет в этой игре'),(22,22,2,'Только создатель игры может удалить игрока'),(23,23,2,'Нельзя удалить игрока после начала игры'),(24,24,2,'Нельзя выйти из общего чата'),(25,25,2,'Неправильная команда'),(26,26,2,'Только создатель игры может начать игру'),(27,27,2,'Игра уже начата'),(28,28,2,'Недопустимое количество игроков'),(29,29,2,'Игра еще не начата'),(30,30,2,'Пользователь уже создал игру в арене'),(31,31,2,'Нельзя выйти из арены, пока вы в игре {0}'),(32,32,2,'Вы уже в этом чате'),(33,33,2,'Недопустимое значение для фичи game_feature_id={0}'),(34,34,2,'Невозможно открыть чат с самим собой'),(35,35,2,'Неизвестный код языка: {0}'),(36,1,1,'Login {0} already exists'),(37,2,1,'Blank login or password'),(38,3,1,'Incorrect login or password'),(39,4,1,'Incorrect user_id'),(40,5,1,'Incorrect chat_id'),(41,6,1,'You are not in this chat'),(42,7,1,'You cannot change the topic of the common chat'),(43,8,1,'You are not in the Arena'),(44,9,1,'Time restriction should be positive'),(45,10,1,'Mode does not exist'),(46,11,1,'Only game creator can add or remove game features'),(47,12,1,'There is no such game feachure for this game'),(48,13,1,'Incorrect game password'),(49,14,1,'You are already in another game'),(50,15,1,'You cannot add or remove game features after the game has started'),(51,16,1,'Game does not exist'),(52,17,1,'You cannot enter the game after its start'),(53,18,1,'Incorrect spectator_flag'),(54,19,1,'Only game creator can modify teams'),(55,20,1,'You cannot modify teams after the game has started'),(56,21,1,'This player is not in this game'),(57,22,1,'Only game creator can remove a player'),(58,23,1,'You cannot remove a player after the game has started'),(59,24,1,'You cannot leave the common chat'),(60,25,1,'Incorrect team'),(61,26,1,'Only game creator can start the game'),(62,27,1,'The game is already started'),(63,28,1,'Incorrect number of players'),(64,29,1,'The game is not started yet'),(65,30,1,'The user has already started a game in Arena'),(66,31,1,'You cannot leave Arena while you are in game {0}'),(67,32,1,'You are already in this chat'),(68,33,1,'Incorrect value for game feature game_feature_id={0}'),(69,34,1,'You cannot open a chat with yourself'),(70,35,1,'Unknown language code: {0}'),(71,36,1,'This is not available for guest users'),(72,36,2,'Эта операция недоступна гостевым пользователям'),(73,37,1,'Incorrect bot ID'),(74,37,2,'Неправильный ID бота'),(75,38,1,'Bot is not in this game'),(76,38,2,'Бот не в этой игре'),(77,39,1,'Players should be distributed into at least two teams'),(78,39,2,'Должно быть минимум две команды');
/*!40000 ALTER TABLE `error_dictionary_i18n` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `languages`
--

DROP TABLE IF EXISTS `languages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `languages` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(2) NOT NULL,
  `name` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `languages`
--

LOCK TABLES `languages` WRITE;
/*!40000 ALTER TABLE `languages` DISABLE KEYS */;
INSERT INTO `languages` VALUES (1,'EN','English'),(2,'RU','Русский');
/*!40000 ALTER TABLE `languages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `performance_statistics`
--

DROP TABLE IF EXISTS `performance_statistics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `performance_statistics` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `request_name` varchar(1000) NOT NULL,
  `js_time` decimal(8,3) DEFAULT NULL,
  `ape_time` decimal(8,3) DEFAULT NULL,
  `php_time` decimal(8,3) DEFAULT NULL,
  `insert_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `game_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `performance_statistics`
--

LOCK TABLES `performance_statistics` WRITE;
/*!40000 ALTER TABLE `performance_statistics` DISABLE KEYS */;
/*!40000 ALTER TABLE `performance_statistics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_statistics_games`
--

DROP TABLE IF EXISTS `user_statistics_games`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_statistics_games` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `game_type_id` int(10) unsigned NOT NULL,
  `mode_id` int(10) unsigned NOT NULL,
  `game_result` enum('win','lose','draw','exit','kicked') NOT NULL,
  `insert_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_statistics_games_users` (`user_id`),
  KEY `user_statistics_games_game_types` (`game_type_id`),
  CONSTRAINT `user_statistics_games_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `user_statistics_games_game_types` FOREIGN KEY (`game_type_id`) REFERENCES `dic_game_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_statistics_games`
--

LOCK TABLES `user_statistics_games` WRITE;
/*!40000 ALTER TABLE `user_statistics_games` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_statistics_games` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `login` varchar(200) NOT NULL,
  `pass_hash` varchar(255) DEFAULT NULL,
  `game_type_id` int(11) NOT NULL DEFAULT '0',
  `email` varchar(500) DEFAULT NULL,
  `avatar_filename` varchar(100) DEFAULT NULL,
  `insert_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `language_id` int(11) NOT NULL DEFAULT '1',
  `last_login` timestamp NULL DEFAULT NULL,
  `is_bot` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'1','$2y$10$nR4UfAaOfSSibnUd05EY4u2Lcs6Vk/WrvPUkmG2qzb7ri.c9S0NgS',0,NULL,NULL,'2018-04-04 17:32:29',1,'2018-04-04 17:35:19',0),(2,'2','$2y$10$8kpaqpUTv/VuyjQrCt3qiONgJ0/JFjy2D2VvBykA0435mYnsUEwMu',0,NULL,NULL,'2018-04-04 17:32:52',2,'2018-04-04 17:36:14',0),(3,'3','$2y$10$EtpJV7QW9w7RO5tvP449eOdEDJMUlW6wkCUkybeiFKqmEGEn8pSUG',0,NULL,NULL,'2018-04-04 17:33:16',2,'2018-04-04 17:33:17',0),(4,'4','$2y$10$SeRq6NB5FN2E.QQngSddf.hRVU4DhuKx004wJeW4XG2POP2vxmSvW',0,NULL,NULL,'2018-04-04 17:33:42',1,'2018-04-04 17:33:43',0);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'lords_site'
--

--
-- Dumping routines for database 'lords_site'
--
/*!50003 DROP FUNCTION IF EXISTS `is_bot_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `is_bot_user`(user_id INT) RETURNS int(11)
BEGIN
  RETURN (SELECT u.is_bot FROM users u WHERE u.id=user_id LIMIT 1);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `is_guest_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `is_guest_user`(user_id INT) RETURNS int(11)
BEGIN
  RETURN (SELECT CASE WHEN u.pass_hash IS NULL THEN 1 ELSE 0 END FROM users u WHERE u.id=user_id LIMIT 1);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `user_language` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `user_language`(user_id INT) RETURNS int(11)
BEGIN
  RETURN (SELECT u.language_id FROM users u WHERE u.id=user_id LIMIT 1);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `user_nick` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `user_nick`(user_id INT) RETURNS varchar(200) CHARSET utf8
BEGIN
 RETURN (SELECT u.login FROM users u WHERE u.id=user_id LIMIT 1);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `arena_enter` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `arena_enter`(user_id INT)
BEGIN
  DECLARE arena_game_type_id INT DEFAULT 1; 
  DECLARE player_online_status_id INT DEFAULT 1; 
  DECLARE game_type_id INT;
  DECLARE avatar_filename VARCHAR(100) CHARSET utf8;

  SELECT u.game_type_id, u.avatar_filename INTO game_type_id, avatar_filename FROM users u WHERE u.id=user_id LIMIT 1;
  IF game_type_id IS NULL THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=4;
  ELSE
    IF game_type_id=arena_game_type_id THEN
      
      SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;
    ELSE
      UPDATE users SET game_type_id=arena_game_type_id WHERE id=user_id;
      INSERT INTO arena_users(user_id,status_id) VALUES (user_id,player_online_status_id);

      SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;

      SELECT 'nick' AS `name`, user_nick(user_id) as `value` FROM DUAL
      UNION
      SELECT 'avatar_filename' AS `name`, avatar_filename as `value` FROM DUAL;
    END IF;
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `arena_exit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `arena_exit`(user_id INT)
BEGIN
  DECLARE g_id INT;
  DECLARE g_name VARCHAR(200) CHARSET utf8;
  DECLARE g_status INT;
  DECLARE playing_game_status INT DEFAULT 2; 
  DECLARE chats_ids VARCHAR(1000);
  DECLARE was_owner INT;
  DECLARE was_spectator INT;

  IF NOT EXISTS(SELECT id FROM arena_users au WHERE au.user_id=user_id LIMIT 1) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=8;
  ELSE

    SELECT agp.game_id,ag.title,ag.status_id,CASE WHEN ag.owner_id=user_id THEN 1 ELSE 0 END,agp.spectator_flag
      INTO g_id,g_name,g_status,was_owner,was_spectator
      FROM arena_game_players agp
      JOIN arena_games ag ON (agp.game_id=ag.id)
      WHERE agp.user_id=user_id LIMIT 1;
    IF(g_status=playing_game_status) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, CONCAT('"',REPLACE(g_name,'\"','\\\"'),'"') as `error_params` FROM error_dictionary ed WHERE id=31;
    ELSE

      UPDATE users SET game_type_id=0 WHERE id=user_id;
      DELETE au FROM arena_users au WHERE au.user_id=user_id;

      CREATE TEMPORARY TABLE variables_resultset (name VARCHAR(50), `value` VARCHAR(1000));


      SELECT GROUP_CONCAT(CAST(cu.chat_id AS CHAR(10)))
      INTO chats_ids
      FROM chat_users cu
      WHERE cu.user_id=user_id
      GROUP BY cu.user_id;

      IF(chats_ids IS NOT NULL) THEN

        INSERT INTO variables_resultset(name,`value`) VALUES('chats_ids',chats_ids);
        DELETE cu FROM chat_users cu WHERE cu.user_id=user_id;
        DELETE c FROM chats c LEFT JOIN chat_users cu ON (c.id=cu.chat_id) WHERE cu.id IS NULL;
      END IF;

      IF((g_id IS NOT NULL)AND(was_owner = 1))THEN

        CALL arena_game_delete_inner(g_id);

        INSERT INTO variables_resultset(name,`value`) VALUES('game_id',CAST(g_id AS CHAR(10)));
        INSERT INTO variables_resultset(name,`value`) VALUES('was_owner',CAST(was_owner AS CHAR(10)));
      END IF;

      IF((g_id IS NOT NULL)AND(was_owner = 0))THEN

        DELETE agp FROM arena_game_players agp WHERE agp.user_id=user_id;
        INSERT INTO variables_resultset(name,`value`) VALUES('game_id',CAST(g_id AS CHAR(10)));
        INSERT INTO variables_resultset(name,`value`) VALUES('was_spectator',CAST(was_spectator AS CHAR(10)));
      END IF;

      SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;

      IF EXISTS(SELECT 1 FROM variables_resultset LIMIT 1) THEN
        SELECT * FROM variables_resultset;
      END IF;

      DROP TEMPORARY TABLE variables_resultset;

    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `arena_game_bot_add` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `arena_game_bot_add`(user_id INT,  game_id INT)
BEGIN
  DECLARE created_game_status INT DEFAULT 1; 
  DECLARE owner_id INT;
  DECLARE status_id INT;
  DECLARE bot_nickname VARCHAR(200) CHARSET utf8 DEFAULT 'Bot';
  DECLARE bot_avatar VARCHAR(100) CHARSET utf8 DEFAULT 'bot_user.png';
  DECLARE bot_user_id INT;

  SELECT ag.owner_id, ag.status_id INTO owner_id, status_id FROM arena_games ag WHERE ag.id = game_id LIMIT 1;

  IF (owner_id IS NULL) OR (owner_id<>user_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'no_right_to_modify_game_features';
  ELSE
    IF status_id<>created_game_status THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'cant_modify_game_features_after_start';
    ELSE

      IF EXISTS (SELECT id FROM arena_game_players agp WHERE agp.game_id = game_id AND is_bot_user(agp.user_id)) THEN
        SET bot_nickname = CONCAT(bot_nickname, (SELECT COUNT(*) + 1 FROM arena_game_players agp WHERE agp.game_id = game_id AND is_bot_user(agp.user_id)));
      END IF;

      INSERT INTO users (login, avatar_filename, is_bot) VALUES (bot_nickname, bot_avatar, 1);
      SET bot_user_id = @@last_insert_id;
      INSERT INTO arena_game_players(user_id, game_id, spectator_flag)
        VALUES(bot_user_id, game_id, 1);

      SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;
      SELECT 'bot_user_id' AS `name`, bot_user_id as `value` FROM DUAL;
    END IF;
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `arena_game_bot_remove` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `arena_game_bot_remove`(user_id INT, game_id INT, bot_user_id INT)
BEGIN
  DECLARE created_game_status INT DEFAULT 1; 
  DECLARE owner_id INT;
  DECLARE status_id INT;
  DECLARE was_spectator INT;

  SELECT ag.owner_id, ag.status_id INTO owner_id, status_id FROM arena_games ag WHERE ag.id = game_id LIMIT 1;

  IF (owner_id IS NULL) OR (owner_id<>user_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'no_right_to_modify_game_features';
  ELSE
    IF status_id<>created_game_status THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'cant_modify_game_features_after_start';
    ELSE
      IF NOT IFNULL(is_bot_user(bot_user_id), 0) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'incorrect_bot_id';
      ELSE
        IF NOT EXISTS (SELECT id FROM arena_game_players agp WHERE agp.game_id = game_id AND agp.user_id = bot_user_id) THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'bot_is_not_in_this_game';
        ELSE
          SELECT agp.spectator_flag INTO was_spectator FROM arena_game_players agp WHERE agp.user_id = bot_user_id;
          DELETE FROM users WHERE id = bot_user_id;
          DELETE FROM arena_game_players WHERE user_id = bot_user_id;

          SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;
          SELECT 'was_spectator' AS `name`, was_spectator as `value` FROM DUAL;
        END IF;
      END IF;
    END IF;
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `arena_game_create` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `arena_game_create`(user_id INT, title VARCHAR(45) CHARSET utf8, pass VARCHAR(45) CHARSET utf8, time_restriction_seconds INT, mode_id INT)
BEGIN
  DECLARE arena_game_type_id INT DEFAULT 1; 
  DECLARE created_game_status INT DEFAULT 1; 
  DECLARE game_id INT;

  IF NOT EXISTS(SELECT au.id FROM arena_users au WHERE au.user_id=user_id LIMIT 1)THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=8;
  ELSE
    IF (time_restriction_seconds<0) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=9;
    ELSE
      IF EXISTS(SELECT 1 FROM arena_games ag WHERE ag.owner_id=user_id AND ag.status_id=created_game_status LIMIT 1) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=30;
      ELSE
        IF NOT EXISTS (SELECT m.id FROM lords.modes m WHERE m.id=mode_id LIMIT 1) THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=10;
        ELSE

          INSERT INTO lords.games(title,owner_id,time_restriction,status_id,mode_id,type_id)VALUES(title,user_id,time_restriction_seconds,created_game_status,mode_id,arena_game_type_id);
          SET game_id=@@last_insert_id;

          INSERT INTO arena_games(id,title,pass,owner_id,time_restriction,status_id,mode_id)VALUES(game_id,title,MD5(pass),user_id,time_restriction_seconds,created_game_status,mode_id);


          INSERT INTO arena_games_features_usage(game_id,feature_id,`value`,feature_type)
          SELECT game_id,id,default_param,feature_type FROM lords.games_features;

          SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;

          SELECT 'game_id' AS `name`, game_id as `value` FROM DUAL;

        END IF;
      END IF;
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `arena_game_delete_inner` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `arena_game_delete_inner`(g_id INT)
BEGIN
  DECLARE player_online_status_id INT DEFAULT 1; 
  DECLARE player_ingame_status_id INT DEFAULT 2; 

  UPDATE arena_users au, arena_game_players agp SET au.status_id=player_online_status_id
    WHERE au.user_id=agp.user_id AND agp.game_id=g_id AND au.status_id=player_ingame_status_id;

  DELETE FROM users 
    WHERE id IN (SELECT user_id FROM arena_game_players WHERE game_id = g_id)
      AND is_bot = 1;

  DELETE FROM arena_games WHERE id=g_id;
  DELETE FROM lords.games WHERE id=g_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `arena_game_enter` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `arena_game_enter`(user_id INT, game_id INT,  pass VARCHAR(45) CHARSET utf8)
BEGIN
  DECLARE created_game_status INT DEFAULT 1; 
  DECLARE player_ingame_status_id INT DEFAULT 2; 
  DECLARE game_status_id INT;
  DECLARE md5_game_pass VARCHAR(45) CHARSET utf8;

  SELECT ag.status_id, ag.pass INTO game_status_id, md5_game_pass FROM arena_games ag WHERE ag.id=game_id LIMIT 1;

  IF NOT EXISTS(SELECT au.id FROM arena_users au WHERE au.user_id=user_id LIMIT 1)THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=8;
  ELSE
    IF EXISTS(SELECT p.id FROM arena_game_players p WHERE p.user_id=user_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      IF game_status_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=16;
      ELSE
        IF IFNULL(md5_game_pass,'')<>IFNULL(MD5(pass),'') THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=13;
        ELSE
          IF (game_status_id<>created_game_status) THEN
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=17;
          ELSE

            INSERT INTO arena_game_players(user_id,game_id,spectator_flag)VALUES(user_id,game_id,1); 

            UPDATE arena_users au SET au.status_id=player_ingame_status_id WHERE au.user_id=user_id;

            SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;

          END IF;
        END IF;
      END IF;
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `arena_game_feature_set` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `arena_game_feature_set`(user_id INT, game_id INT, feature_id INT, param INT)
BEGIN
  DECLARE created_game_status INT DEFAULT 1; 
  DECLARE owner_id INT;
  DECLARE status_id INT;
  DECLARE feature_type ENUM('bool','int');

  DECLARE new_player_count INT;
  DECLARE new_spectator_count INT;

  SELECT ag.owner_id, ag.status_id INTO owner_id,status_id FROM arena_games ag WHERE ag.id=game_id LIMIT 1;

  IF (owner_id IS NULL) OR (owner_id<>user_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=11;
  ELSE
    IF status_id<>created_game_status THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=15;
    ELSE
      SELECT f.feature_type INTO feature_type FROM arena_games_features_usage f WHERE f.game_id=game_id AND f.feature_id=feature_id;
      IF (feature_type IS NULL) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=12;
      ELSE
        IF (feature_type='bool' AND NOT param IN (0,1)) THEN
          SELECT 0 AS `success`, ed.id as `error_code`, CONCAT('"',feature_id,'"') as `error_params` FROM error_dictionary ed WHERE id=33;
        ELSE

          
          IF feature_id=lords.game_feature_get_id_by_code('number_of_teams') THEN

            UPDATE arena_game_players agp SET spectator_flag=1 WHERE agp.game_id=game_id AND agp.team>=param;

            SELECT IFNULL(COUNT(*)-SUM(spectator_flag),0),IFNULL(SUM(spectator_flag),0) INTO new_player_count,new_spectator_count FROM arena_game_players ap WHERE ap.game_id=game_id;
          END IF;
          

          UPDATE arena_games_features_usage f SET `value`=param WHERE f.game_id=game_id AND f.feature_id=feature_id;

          SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;

          IF(new_player_count IS NOT NULL)THEN
            SELECT 'player_count' AS `name`, new_player_count as `value` FROM DUAL
            UNION
            SELECT 'spectator_count' AS `name`, new_spectator_count as `value` FROM DUAL;
          END IF;

        END IF;
      END IF;
    END IF;
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `arena_game_player_remove` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `arena_game_player_remove`(user_id INT, game_id INT, user2_id INT)
BEGIN
  DECLARE created_game_status INT DEFAULT 1; 
  DECLARE owner_id INT;
  DECLARE game_status_id INT;
  DECLARE player_online_status_id INT DEFAULT 1; 
  DECLARE player_ingame_status_id INT DEFAULT 2; 
  DECLARE was_spectator INT;

  SELECT ag.owner_id, ag.status_id INTO owner_id,game_status_id FROM arena_games ag WHERE ag.id=game_id LIMIT 1;

  IF (SELECT ap.game_id FROM arena_game_players ap WHERE ap.user_id=user2_id)<>game_id THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=21;
  ELSE
    IF (user_id<>user2_id) AND (user_id<>owner_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=22;
    ELSE
      IF game_status_id<>created_game_status THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=23;
      ELSE

        IF(user2_id=owner_id)THEN

          CALL arena_game_delete_inner(game_id);

          SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;

          SELECT 'owner' AS `name`, 1 as `value` FROM DUAL;

        ELSE
          SELECT agp.spectator_flag INTO was_spectator FROM arena_game_players agp WHERE agp.user_id=user2_id;
          DELETE agp FROM arena_game_players agp WHERE agp.user_id=user2_id;

          UPDATE arena_users au SET au.status_id=player_online_status_id
            WHERE au.user_id=user2_id AND au.status_id=player_ingame_status_id;

          SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;

          SELECT 'was_spectator' AS `name`, was_spectator as `value` FROM DUAL;

        END IF;
      END IF;
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `arena_game_player_spectator_move` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `arena_game_player_spectator_move`(user_id INT,game_id INT,user2_id INT)
BEGIN
  DECLARE created_game_status INT DEFAULT 1; 
  DECLARE owner_id INT;
  DECLARE status_id INT;

  SELECT ag.owner_id, ag.status_id INTO owner_id,status_id FROM arena_games ag WHERE ag.id=game_id LIMIT 1;

  IF owner_id<>user_id THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=19;
  ELSE
    IF status_id<>created_game_status THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=20;
    ELSE
      IF NOT EXISTS(SELECT agp.id FROM arena_game_players agp WHERE agp.user_id=user2_id AND agp.game_id=game_id LIMIT 1) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=21;
      ELSE

        UPDATE arena_game_players agp SET agp.spectator_flag=1 WHERE agp.user_id=user2_id;
          
        SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;

      END IF;
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `arena_game_player_team_set` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `arena_game_player_team_set`(user_id INT,game_id INT,user2_id INT,team INT)
BEGIN
  DECLARE created_game_status INT DEFAULT 1; 
  DECLARE number_of_teams_feature_id INT DEFAULT 3; 
  DECLARE owner_id INT;
  DECLARE status_id INT;
  DECLARE was_spectator INT;

  SELECT ag.owner_id, ag.status_id INTO owner_id,status_id FROM arena_games ag WHERE ag.id=game_id LIMIT 1;

  IF owner_id<>user_id THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=19;
  ELSE
    IF status_id<>created_game_status THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=20;
    ELSE
      SELECT agp.spectator_flag INTO was_spectator FROM arena_game_players agp WHERE agp.user_id=user2_id AND agp.game_id=game_id LIMIT 1;
      IF (was_spectator IS NULL) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=21;
      ELSE
        IF (team>=(SELECT f.value FROM arena_games_features_usage f WHERE f.game_id=game_id AND f.feature_id=number_of_teams_feature_id LIMIT 1))THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=25;
        ELSE

          UPDATE arena_game_players agp SET agp.spectator_flag=0,agp.team=team WHERE agp.user_id=user2_id;
          
          SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;

          SELECT 'was_spectator' AS `name`, was_spectator as `value` FROM DUAL;
          
        END IF;
      END IF;
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `arena_game_spectator_enter` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `arena_game_spectator_enter`(user_id INT,  game_id INT,   pass VARCHAR(45) CHARSET utf8)
BEGIN
  DECLARE created_game_status INT DEFAULT 1; 
  DECLARE player_playing_status_id INT DEFAULT 3; 
  DECLARE game_status_id INT;
  DECLARE md5_game_pass VARCHAR(45) CHARSET utf8;
  DECLARE p_num INT;
  DECLARE p_name VARCHAR(200) CHARSET utf8;

  SELECT ag.status_id, ag.pass INTO game_status_id, md5_game_pass FROM arena_games ag WHERE ag.id=game_id LIMIT 1;

  IF NOT EXISTS(SELECT au.id FROM arena_users au WHERE au.user_id=user_id LIMIT 1)THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=8;
  ELSE
    IF EXISTS(SELECT p.id FROM arena_game_players p WHERE p.user_id=user_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      IF game_status_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=16;
      ELSE
        IF IFNULL(md5_game_pass,'')<>IFNULL(MD5(pass),'') THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=13;
        ELSE
          IF (game_status_id=created_game_status) THEN
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=29;
          ELSE

            INSERT INTO arena_game_players(user_id,game_id,spectator_flag)VALUES(user_id,game_id,1); 

            UPDATE arena_users au SET au.status_id=player_playing_status_id WHERE au.user_id=user_id;

            SET p_num=100+user_id;
            SET p_name=user_nick(user_id);

            INSERT INTO lords.players(user_id,game_id,player_num,name,owner,team,language_id)
            VALUES(user_id,game_id,p_num,p_name,0,0,user_language(user_id));

            SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;

            SELECT 'player_num' AS `name`, p_num as `value` FROM DUAL
            UNION
            SELECT 'player_name' AS `name`, p_name as `value` FROM DUAL;

          END IF;
        END IF;
      END IF;
    END IF;
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `arena_game_start` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `arena_game_start`(user_id INT, game_id INT)
BEGIN
  DECLARE created_game_status INT DEFAULT 1; 
  DECLARE playing_game_status INT DEFAULT 2; 
  DECLARE player_ingame_status_id INT DEFAULT 2; 
  DECLARE player_playing_status_id INT DEFAULT 3; 
  DECLARE arena_game_type_id INT DEFAULT 1; 
  DECLARE owner_id INT;
  DECLARE status_id INT;
  DECLARE player_count INT;
  DECLARE mode_id INT;

  SELECT ag.owner_id, ag.status_id, ag.mode_id INTO owner_id,status_id,mode_id FROM arena_games ag WHERE ag.id=game_id LIMIT 1;

  IF (owner_id IS NULL) OR (owner_id<>user_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'no_right_to_start_game';
  ELSE
    IF status_id<>created_game_status THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'game_already_started';
    ELSE
      SELECT COUNT(*) INTO player_count FROM arena_game_players agp WHERE agp.game_id=game_id AND spectator_flag=0;
      IF NOT EXISTS(SELECT lm.id FROM lords.modes lm WHERE lm.id=mode_id AND player_count BETWEEN lm.min_players AND lm.max_players LIMIT 1) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'incorrect_number_of_players';
      ELSE
        IF (SELECT COUNT(DISTINCT agp.team) FROM arena_game_players agp WHERE agp.game_id=game_id AND spectator_flag=0) = 1
          AND NOT EXISTS 
            (SELECT f.id FROM arena_games_features_usage f JOIN lords.games_features fd ON f.feature_id = fd.id
            WHERE f.game_id = game_id AND f.value = 1 AND fd.code IN ('all_versus_all', 'random_teams'))
        THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'everyone_is_in_the_same_team';
        ELSE
          UPDATE arena_games ag SET ag.status_id=playing_game_status WHERE ag.id=game_id;

          UPDATE arena_users au, arena_game_players agp SET au.status_id=player_playing_status_id
            WHERE au.user_id=agp.user_id AND agp.game_id=game_id AND au.status_id=player_ingame_status_id;

          INSERT INTO lords.players(user_id,game_id,player_num,name,owner,team,language_id)
            SELECT
              agp.user_id,
              game_id,
              CASE WHEN agp.spectator_flag=0 THEN 0 ELSE 100+agp.user_id END,
              u.login,
              CASE WHEN agp.spectator_flag=1 THEN 0 ELSE 1 END,
              IFNULL(agp.team,0),
              user_language(agp.user_id)
            FROM arena_game_players agp JOIN users u ON agp.user_id = u.id WHERE agp.game_id=game_id;

          INSERT INTO lords.games_features_usage(game_id,feature_id,param)
            SELECT f.game_id,f.feature_id,f.`value` FROM arena_games_features_usage f WHERE f.game_id=game_id;

          CALL lords.initialization(game_id);

          SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;
        END IF;
      END IF;
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `chat_create_private` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `chat_create_private`(user_id INT,user2_id INT)
BEGIN
  DECLARE chat_id INT;

  IF NOT EXISTS(SELECT 1 FROM users u WHERE u.id=user_id) OR NOT EXISTS(SELECT 1 FROM users u WHERE u.id=user2_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=4;
  ELSE
    IF(user_id=user2_id)THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=34;
    ELSE
      INSERT INTO chats() VALUES();
      SET chat_id=@@last_insert_id;

      INSERT INTO chat_users(chat_id,user_id) VALUES(chat_id,user_id);
      INSERT INTO chat_users(chat_id,user_id) VALUES(chat_id,user2_id);

      SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;

      SELECT 'chat_id' AS `name`, chat_id as `value` FROM DUAL;
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `chat_exit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `chat_exit`(user_id INT,chat_id INT)
BEGIN

  IF NOT EXISTS(SELECT id FROM chat_users cu WHERE cu.chat_id=chat_id AND cu.user_id=user_id LIMIT 1) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=4;
  ELSE

    DELETE FROM chat_users WHERE chat_users.user_id=user_id AND chat_users.chat_id=chat_id;

    IF NOT EXISTS(SELECT cu.id FROM chat_users cu WHERE cu.chat_id=chat_id) THEN 
      DELETE FROM chats WHERE id=chat_id;
    END IF;

    SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;

  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `chat_topic_change` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `chat_topic_change`(user_id INT,chat_id INT,new_topic VARCHAR(1000) CHARSET utf8)
BEGIN

  IF NOT EXISTS(SELECT id FROM chat_users cu WHERE cu.chat_id=chat_id AND cu.user_id=user_id LIMIT 1) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=4;
  ELSE

    UPDATE chats SET topic=new_topic WHERE id=chat_id;

    SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `chat_user_add` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `chat_user_add`(user_id INT,user2_id INT,chat_id INT)
BEGIN

  IF(SELECT COUNT(*) FROM users u WHERE u.id IN(user_id,user2_id))<>2 THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=4;
  ELSE
      IF EXISTS(SELECT id FROM chat_users cu WHERE cu.chat_id=chat_id AND cu.user_id=user2_id LIMIT 1)THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=32;
      ELSE
        IF NOT EXISTS(SELECT id FROM chat_users cu WHERE cu.chat_id=chat_id AND cu.user_id=user_id LIMIT 1) THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=6;
        ELSE

          INSERT INTO chat_users(chat_id,user_id) VALUES(chat_id,user2_id);

          SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;

        END IF;
      END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_all_arena_bots` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_arena_bots`()
BEGIN
  SELECT
    agp.user_id,
    agp.game_id,
    agp.spectator_flag,
    p.player_num
  FROM arena_game_players agp LEFT JOIN lords.players p ON agp.user_id = p.user_id
  WHERE is_bot_user(agp.user_id) = 1;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_all_arena_info` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_arena_info`(user_id INT)
BEGIN
  
  SELECT
    au.user_id AS `user_id`,
    user_nick(au.user_id) AS `nick`,
    au.status_id AS `status_id`,
    u.avatar_filename,
    is_guest_user(u.id) as `guest_user`
  FROM arena_users au JOIN users u ON (au.user_id=u.id);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_all_chat_info` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_chat_info`(user_id INT)
BEGIN
  
  CREATE TEMPORARY TABLE chats_for_user
  SELECT c.id,c.topic FROM chats c JOIN chat_users cu ON c.id=cu.chat_id WHERE cu.user_id=user_id;

  
  SELECT cu.id AS `chat_id`,cu.topic AS `topic` FROM chats_for_user cu;

  
  SELECT cfu.id AS `chat_id`,cu.user_id,user_nick(cu.user_id) as `nick` FROM
  chats_for_user cfu JOIN chat_users cu ON (cu.chat_id=cfu.id);

  DROP TEMPORARY TABLE chats_for_user;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_arena_games_info` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_arena_games_info`(user_id INT)
BEGIN

 
   SELECT
     ag.id AS `game_id`,
     title AS `title`,
     `date` AS `date`,
     owner_id AS `owner_id`,
     user_nick(owner_id) AS `owner_name`,
     time_restriction AS `time_restriction`,
     mode_id AS `mode_id`,
     lm.name AS `mode_name`,
     CASE WHEN pass IS NULL THEN 0 ELSE 1 END AS `pass_flag`,
     (SELECT COUNT(*) FROM arena_game_players ap WHERE ap.game_id=ag.id AND ap.spectator_flag=0) AS `player_count`,
     (SELECT COUNT(*) FROM arena_game_players ap WHERE ap.game_id=ag.id AND ap.spectator_flag=1) AS `spectator_count`,
      ag.status_id AS `status_id`
   FROM arena_games ag
   JOIN lords.modes lm ON (ag.mode_id=lm.id);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_bots_for_game` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_bots_for_game`(game_id INT)
BEGIN
  SELECT
    agp.user_id,
    agp.game_id,
    p.player_num
  FROM arena_game_players agp LEFT JOIN lords.players p ON agp.user_id = p.user_id
  WHERE is_bot_user(agp.user_id) = 1 AND agp.game_id = game_id AND agp.spectator_flag = 0;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_chat_users` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_chat_users`(user_id INT,chat_id INT)
BEGIN
  IF NOT EXISTS(SELECT u.id FROM users u WHERE u.id=user_id LIMIT 1) THEN
    SELECT NULL AS `user_id`,NULL AS `user_nick` FROM DUAL;
  ELSE
      IF NOT EXISTS(SELECT id FROM chat_users cu WHERE cu.chat_id=chat_id AND cu.user_id=user_id) THEN
        SELECT NULL AS `user_id`,NULL AS `user_nick` FROM DUAL;
      ELSE

        SELECT cu.user_id,user_nick(cu.user_id) FROM chat_users cu WHERE cu.chat_id=chat_id;
      END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_create_game_features` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_create_game_features`(user_id INT)
BEGIN
  SELECT id,code as name,default_param,feature_type FROM lords.games_features;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_create_game_modes` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_create_game_modes`(user_id INT)
BEGIN
  SELECT id,name FROM lords.modes ORDER BY id DESC; 
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_current_game_info` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_current_game_info`(user_id INT)
BEGIN
  DECLARE arena_game_type_id INT DEFAULT 1; 
  DECLARE game_type_id INT;
  DECLARE game_id INT;

  SELECT u.game_type_id INTO game_type_id FROM users u WHERE u.id=user_id LIMIT 1;

  IF game_type_id=arena_game_type_id THEN
    SELECT ap.game_id INTO game_id FROM arena_game_players ap WHERE ap.user_id=user_id LIMIT 1;

    SELECT
      ag.id AS `game_id`,
      title AS `title`,
      owner_id AS `owner_id`,
      u.login AS `owner_name`,
      time_restriction AS `time_restriction`,
      mode_id AS `mode_id`,
      lm.name AS `mode_name`
    FROM arena_games ag
    JOIN arena_game_players ap ON (ap.user_id = ag.owner_id)
    JOIN users u ON (ap.user_id = u.id)
    JOIN lords.modes lm ON (ag.mode_id = lm.id)
    WHERE ag.id=game_id;

    SELECT feature_id,`value`,feature_type FROM arena_games_features_usage f WHERE f.game_id=game_id;

    SELECT
      u.login AS `name`,
      ap.user_id AS `user_id`,
      ap.spectator_flag AS `spectator_flag`,
      ap.team AS `team`,
      u.avatar_filename,
      is_guest_user(u.id) AS `guest_user`,
      u.is_bot AS `bot`
    FROM arena_game_players ap
    JOIN users u ON (ap.user_id = u.id)
    WHERE ap.game_id=game_id;

  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_my_location` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_my_location`(user_id INT)
BEGIN
  DECLARE game_type_id INT;
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE mode_id INT;

  CALL get_my_location_inner(user_id,game_type_id,g_id,p_num,mode_id);
  SELECT game_type_id AS `game_type_id`, g_id as `game_id`, p_num as `player_num`, mode_id as `mode_id` FROM DUAL;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_my_location_inner` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_my_location_inner`(user_id INT, OUT game_type_id INT, OUT game_id INT, OUT player_num INT, OUT mode_id INT)
BEGIN
  DECLARE arena_game_type_id INT DEFAULT 1; 

  DECLARE p_id INT;

  SELECT u.game_type_id INTO game_type_id FROM users u WHERE u.id=user_id LIMIT 1;

  IF (game_type_id<>0) THEN

    SELECT p.game_id,p.player_num,g.mode_id INTO game_id,player_num,mode_id FROM lords.players p JOIN lords.games g ON (p.game_id=g.id) WHERE p.user_id=user_id LIMIT 1;

    IF(game_id IS NULL)THEN


      CASE game_type_id
        WHEN arena_game_type_id THEN
          SELECT
            p.game_id,
            g.mode_id
          INTO game_id,mode_id
          FROM arena_game_players p
          JOIN arena_games g ON (p.game_id=g.id)
          WHERE p.user_id=user_id;


      END CASE;

    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_my_profile` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_my_profile`(user_id INT)
BEGIN
  
  SELECT email FROM users u WHERE u.id=user_id LIMIT 1;

  
  CALL get_user_profile(user_id);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_user_profile` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_user_profile`(user_id_whose_profile_to_get INT)
BEGIN
  DECLARE last_played_game TIMESTAMP;

  SELECT MAX(insert_timestamp) INTO last_played_game FROM user_statistics_games WHERE user_id = user_id_whose_profile_to_get;

  SELECT login, avatar_filename,last_played_game FROM users u WHERE u.id=user_id_whose_profile_to_get LIMIT 1;

  SELECT
    m.name AS `mode_name`,
    COUNT(*) AS `games_played`,
    SUM(CASE WHEN game_result = 'win' THEN 1 ELSE 0 END) AS `win`,
    SUM(CASE WHEN game_result = 'lose' THEN 1 ELSE 0 END) AS `lose`,
    SUM(CASE WHEN game_result = 'draw' THEN 1 ELSE 0 END) AS `draw`,
    SUM(CASE WHEN game_result = 'exit' THEN 1 ELSE 0 END) AS `exit`
  FROM user_statistics_games u
  JOIN lords.modes m ON (u.mode_id = m.id)
  WHERE user_id = user_id_whose_profile_to_get
  GROUP BY m.name;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `guest_user_add` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `guest_user_add`(nickname VARCHAR(200) CHARSET utf8, language_code VARCHAR(2) CHARSET utf8)
BEGIN
  DECLARE language_id INT;
  DECLARE guest_avatar VARCHAR(100) CHARSET utf8 DEFAULT 'guest_user.png';
  DECLARE user_id INT;

  SELECT l.id INTO language_id FROM languages l WHERE l.code = language_code;
  IF language_id IS NULL THEN
    SELECT 0 AS `success`, ed.id as `error_code`, CONCAT('"',REPLACE(language_code,'\\\\"','\\\\\\\\\\\\"'),'"') as `error_params` FROM error_dictionary ed WHERE ed.code = 'incorrect_language_code';
  ELSE
    INSERT INTO users (login, language_id, avatar_filename) VALUES (nickname, language_id, guest_avatar);
    SET user_id = @@last_insert_id;
    SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;
    CALL user_info_select(user_id);
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `performance_statistics_add` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `performance_statistics_add`(name VARCHAR(1000) CHARSET utf8, js_time NUMERIC(8,3), ape_time NUMERIC(8,3), php_time NUMERIC(8,3), game_id INT)
BEGIN
  INSERT INTO performance_statistics(request_name,js_time,ape_time,php_time,game_id)
  VALUES(name,js_time,ape_time,php_time,game_id);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `player_online_offline` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `player_online_offline`(user_id INT, online_flag INT)
BEGIN
  DECLARE player_online_status_id INT DEFAULT 1; 
  DECLARE player_ingame_status_id INT DEFAULT 2; 
  DECLARE player_playing_status_id INT DEFAULT 3; 
  DECLARE player_offline_status_id INT DEFAULT 4; 
  DECLARE new_status INT;

  DECLARE game_type_id INT;
  DECLARE arena_game_type_id INT DEFAULT 1; 

  IF(online_flag=0)THEN

    SET new_status=player_offline_status_id;
  ELSE


    IF EXISTS(SELECT id FROM lords.players p WHERE p.user_id=user_id LIMIT 1) THEN
      SET new_status=player_playing_status_id;
    ELSE

      SELECT u.game_type_id INTO game_type_id FROM users u WHERE u.id=user_id LIMIT 1;

      CASE game_type_id
        WHEN arena_game_type_id THEN
          IF EXISTS (SELECT id FROM arena_game_players agp WHERE agp.user_id=user_id) THEN
            SET new_status=player_ingame_status_id;
          ELSE
            SET new_status=player_online_status_id;
          END IF;

      END CASE;

    END IF;
  END IF;

  UPDATE arena_users au SET au.status_id=new_status WHERE au.user_id=user_id;

  SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;

  SELECT 'player_status_id' AS `name`, new_status as `value` FROM DUAL;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `reset` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `reset`()
BEGIN
  SET FOREIGN_KEY_CHECKS=0;
  truncate table arena_users;
  truncate table arena_games;
  truncate table arena_games_features_usage;
  truncate table arena_game_players;
  truncate table chat_users;
  truncate table chats;
  delete from users where pass_hash IS NULL;
  update users set game_type_id=0;
  SET FOREIGN_KEY_CHECKS=1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `user_add` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `user_add`(login VARCHAR(200) CHARSET utf8,  pass_hash VARCHAR(255) CHARSET utf8,  email VARCHAR(500) CHARSET utf8,  language_code VARCHAR(2) CHARSET utf8)
BEGIN
  DECLARE language_id INT;

  IF EXISTS(SELECT u.id FROM users u WHERE u.login=login AND u.pass_hash IS NOT NULL LIMIT 1) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, CONCAT('"',REPLACE(login,'\\\\"','\\\\\\\\\\\\"'),'"') as `error_params` FROM error_dictionary ed WHERE ed.code = 'login_exists';
  ELSE
    IF((IFNULL(login,'')='')OR(IFNULL(pass_hash,'')='')) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'empty_login_or_pass';
    ELSE
      SELECT l.id INTO language_id FROM languages l WHERE l.code = language_code;
      IF language_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, CONCAT('"',REPLACE(language_code,'\\\\"','\\\\\\\\\\\\"'),'"') as `error_params` FROM error_dictionary ed WHERE ed.code = 'incorrect_language_code';
      ELSE
        INSERT INTO users (login,pass_hash,email,language_id) VALUES (login,pass_hash,email,language_id);

        SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;
      END IF;
    END IF;
  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `user_get_info` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `user_get_info`(login VARCHAR(200) CHARSET utf8)
BEGIN
  DECLARE user_id INT;
  DECLARE user_language_id INT;
  DECLARE user_language_code VARCHAR(2) CHARSET utf8;
  DECLARE game_type_id INT;
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE mode_id INT;

  SELECT u.id INTO user_id FROM users u WHERE u.login=login AND u.pass_hash IS NOT NULL LIMIT 1;
  IF user_id IS NULL THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='incorrect_login_or_pass';
  ELSE
    UPDATE users SET last_login = CURRENT_TIMESTAMP WHERE id = user_id;

    SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;
    CALL user_info_select(user_id);
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `user_get_pass_hash` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `user_get_pass_hash`(login VARCHAR(200) CHARSET utf8)
BEGIN
  DECLARE pass_hash VARCHAR(255) CHARSET utf8;

  SELECT u.pass_hash INTO pass_hash FROM users u WHERE u.login=login AND u.pass_hash IS NOT NULL LIMIT 1;
  IF pass_hash IS NULL THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='incorrect_login_or_pass';
  ELSE
    SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;
    SELECT 'pass_hash' AS `name`, pass_hash as `value` FROM DUAL;
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `user_info_select` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `user_info_select`(user_id INT)
BEGIN
  DECLARE game_type_id INT;
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE mode_id INT;
  DECLARE user_language_id INT;
  DECLARE user_language_code VARCHAR(2) CHARSET utf8;

  CALL get_my_location_inner(user_id, game_type_id, g_id, p_num, mode_id);

  SELECT u.language_id INTO user_language_id FROM users u WHERE u.id = user_id LIMIT 1;
  SELECT l.code INTO user_language_code FROM languages l WHERE l.id = user_language_id LIMIT 1;

    SELECT 'user_id' AS `name`, user_id as `value` FROM DUAL
    UNION
    SELECT 'user_language_code' AS `name`, user_language_code as `value` FROM DUAL
    UNION
    SELECT 'game_type_id' AS `name`, game_type_id as `value` FROM DUAL
    UNION
    SELECT 'game_id' AS `name`, g_id as `value` FROM DUAL
    UNION
    SELECT 'player_num' AS `name`, p_num as `value` FROM DUAL
    UNION
    SELECT 'mode_id' AS `name`, mode_id as `value` FROM DUAL;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `user_language_change` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `user_language_change`(user_id INT, language_code VARCHAR(2) CHARSET utf8)
BEGIN
  DECLARE language_id INT;

  IF NOT EXISTS(SELECT id FROM users u WHERE u.id=user_id LIMIT 1) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=4;
  ELSE
    SELECT l.id INTO language_id FROM languages l WHERE l.code = language_code;
    IF language_id IS NULL THEN
      SELECT 0 AS `success`, ed.id as `error_code`, CONCAT('"',REPLACE(language_code,'\"','\\\"'),'"') as `error_params` FROM error_dictionary ed WHERE id=35;
    ELSE
      UPDATE users u SET u.language_id = language_id WHERE u.id=user_id;	
      SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;
    END IF;
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `user_profile_update` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `user_profile_update`(user_id INT,  avatar_filename VARCHAR(100) CHARSET utf8)
BEGIN
  IF NOT EXISTS(SELECT id FROM users u WHERE u.id=user_id LIMIT 1) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='incorrect_user_id';
  ELSE
    IF is_guest_user(user_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='unavailable_for_guest_users';
    ELSE
      UPDATE users u SET u.avatar_filename = avatar_filename WHERE u.id=user_id;
      SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;
    END IF;
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Current Database: `lords`
--

USE `lords`;

--
-- Final view structure for view `vw_grave`
--

/*!50001 DROP TABLE IF EXISTS `vw_grave`*/;
/*!50001 DROP VIEW IF EXISTS `vw_grave`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_grave` AS select `g`.`game_id` AS `game_id`,`g`.`id` AS `grave_id`,`g`.`card_id` AS `card_id`,`g`.`player_num_when_killed` AS `player_num_when_killed`,`g`.`turn_when_killed` AS `turn_when_killed`,min(`gc`.`x`) AS `x`,min(`gc`.`y`) AS `y`,sqrt(count(0)) AS `size` from (`graves` `g` join `grave_cells` `gc` on((`g`.`id` = `gc`.`grave_id`))) group by `g`.`game_id`,`g`.`id`,`g`.`card_id`,`g`.`player_num_when_killed`,`g`.`turn_when_killed` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_mode_all_procedures`
--

/*!50001 DROP TABLE IF EXISTS `vw_mode_all_procedures`*/;
/*!50001 DROP VIEW IF EXISTS `vw_mode_all_procedures`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_mode_all_procedures` AS select `mp`.`mode_id` AS `mode_id`,`p`.`id` AS `id`,`p`.`name` AS `name`,`p`.`params` AS `params`,`p`.`ui_action_name` AS `ui_action_name` from (`vw_mode_all_procedures_ids` `mp` join `procedures` `p` on((`mp`.`procedure_id` = `p`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_mode_all_procedures_ids`
--

/*!50001 DROP TABLE IF EXISTS `vw_mode_all_procedures_ids`*/;
/*!50001 DROP VIEW IF EXISTS `vw_mode_all_procedures_ids`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_mode_all_procedures_ids` AS select `vw_mode_cards_procedures`.`mode_id` AS `mode_id`,`vw_mode_cards_procedures`.`procedure_id` AS `procedure_id` from `vw_mode_cards_procedures` union select `vw_mode_buildings_procedures`.`mode_id` AS `mode_id`,`vw_mode_buildings_procedures`.`procedure_id` AS `procedure_id` from `vw_mode_buildings_procedures` union select `vw_mode_units_procedures`.`mode_id` AS `mode_id`,`vw_mode_units_procedures`.`procedure_id` AS `procedure_id` from `vw_mode_units_procedures` union select `modes_other_procedures`.`mode_id` AS `mode_id`,`modes_other_procedures`.`procedure_id` AS `procedure_id` from `modes_other_procedures` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_mode_building_default_features`
--

/*!50001 DROP TABLE IF EXISTS `vw_mode_building_default_features`*/;
/*!50001 DROP VIEW IF EXISTS `vw_mode_building_default_features`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_mode_building_default_features` AS select `b`.`mode_id` AS `mode_id`,`f`.`id` AS `id`,`f`.`building_id` AS `building_id`,`f`.`feature_id` AS `feature_id`,`f`.`param` AS `param` from (`vw_mode_buildings` `b` join `building_default_features` `f` on((`b`.`id` = `f`.`building_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_mode_buildings`
--

/*!50001 DROP TABLE IF EXISTS `vw_mode_buildings`*/;
/*!50001 DROP VIEW IF EXISTS `vw_mode_buildings`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_mode_buildings` AS select `c`.`mode_id` AS `mode_id`,`b`.`id` AS `id`,`b`.`health` AS `health`,`b`.`radius` AS `radius`,`b`.`x_len` AS `x_len`,`b`.`y_len` AS `y_len`,`b`.`shape` AS `shape`,`b`.`type` AS `type`,`b`.`ui_code` AS `ui_code` from (`vw_mode_cards` `c` join `buildings` `b` on((`c`.`ref` = `b`.`id`))) where (`c`.`type` = 'b') union select `c`.`mode_id` AS `mode_id`,`b`.`id` AS `id`,`b`.`health` AS `health`,`b`.`radius` AS `radius`,`b`.`x_len` AS `x_len`,`b`.`y_len` AS `y_len`,`b`.`shape` AS `shape`,`b`.`type` AS `type`,`b`.`ui_code` AS `ui_code` from (`modes_cardless_buildings` `c` join `buildings` `b` on((`c`.`building_id` = `b`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_mode_buildings_procedures`
--

/*!50001 DROP TABLE IF EXISTS `vw_mode_buildings_procedures`*/;
/*!50001 DROP VIEW IF EXISTS `vw_mode_buildings_procedures`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_mode_buildings_procedures` AS select distinct `b`.`mode_id` AS `mode_id`,`bp`.`building_id` AS `building_id`,`bp`.`procedure_id` AS `procedure_id` from (`vw_mode_buildings` `b` join `buildings_procedures` `bp` on((`b`.`id` = `bp`.`building_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_mode_cards`
--

/*!50001 DROP TABLE IF EXISTS `vw_mode_cards`*/;
/*!50001 DROP VIEW IF EXISTS `vw_mode_cards`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_mode_cards` AS select `m`.`mode_id` AS `mode_id`,`c`.`id` AS `id`,`c`.`image` AS `image`,`c`.`cost` AS `cost`,`c`.`type` AS `type`,`c`.`ref` AS `ref` from (`modes_cards` `m` join `cards` `c` on((`m`.`card_id` = `c`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_mode_cards_procedures`
--

/*!50001 DROP TABLE IF EXISTS `vw_mode_cards_procedures`*/;
/*!50001 DROP VIEW IF EXISTS `vw_mode_cards_procedures`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_mode_cards_procedures` AS select distinct `c`.`mode_id` AS `mode_id`,`cp`.`card_id` AS `card_id`,`cp`.`procedure_id` AS `procedure_id` from (`vw_mode_cards` `c` join `cards_procedures` `cp` on((`c`.`id` = `cp`.`card_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_mode_unit_default_features`
--

/*!50001 DROP TABLE IF EXISTS `vw_mode_unit_default_features`*/;
/*!50001 DROP VIEW IF EXISTS `vw_mode_unit_default_features`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_mode_unit_default_features` AS select `u`.`mode_id` AS `mode_id`,`f`.`id` AS `id`,`f`.`unit_id` AS `unit_id`,`f`.`feature_id` AS `feature_id`,`f`.`param` AS `param` from (`vw_mode_units` `u` join `unit_default_features` `f` on((`u`.`id` = `f`.`unit_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_mode_unit_level_up_experience`
--

/*!50001 DROP TABLE IF EXISTS `vw_mode_unit_level_up_experience`*/;
/*!50001 DROP VIEW IF EXISTS `vw_mode_unit_level_up_experience`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_mode_unit_level_up_experience` AS select `u`.`mode_id` AS `mode_id`,`e`.`unit_id` AS `unit_id`,`e`.`level` AS `level`,`e`.`experience` AS `experience` from (`vw_mode_units` `u` join `unit_level_up_experience` `e` on((`u`.`id` = `e`.`unit_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_mode_unit_phrases`
--

/*!50001 DROP TABLE IF EXISTS `vw_mode_unit_phrases`*/;
/*!50001 DROP VIEW IF EXISTS `vw_mode_unit_phrases`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_mode_unit_phrases` AS select `mu`.`mode_id` AS `mode_id`,`dup`.`id` AS `id`,`dup`.`unit_id` AS `unit_id`,`dup`.`phrase` AS `phrase` from (`vw_mode_units` `mu` join `dic_unit_phrases` `dup` on((`mu`.`id` = `dup`.`unit_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_mode_units`
--

/*!50001 DROP TABLE IF EXISTS `vw_mode_units`*/;
/*!50001 DROP VIEW IF EXISTS `vw_mode_units`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_mode_units` AS select `c`.`mode_id` AS `mode_id`,`u`.`id` AS `id`,`u`.`moves` AS `moves`,`u`.`health` AS `health`,`u`.`attack` AS `attack`,`u`.`size` AS `size`,`u`.`shield` AS `shield`,`u`.`ui_code` AS `ui_code` from (`vw_mode_cards` `c` join `units` `u` on((`c`.`ref` = `u`.`id`))) where (`c`.`type` = 'u') union select `c`.`mode_id` AS `mode_id`,`u`.`id` AS `id`,`u`.`moves` AS `moves`,`u`.`health` AS `health`,`u`.`attack` AS `attack`,`u`.`size` AS `size`,`u`.`shield` AS `shield`,`u`.`ui_code` AS `ui_code` from (`modes_cardless_units` `c` join `units` `u` on((`c`.`unit_id` = `u`.`id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_mode_units_procedures`
--

/*!50001 DROP TABLE IF EXISTS `vw_mode_units_procedures`*/;
/*!50001 DROP VIEW IF EXISTS `vw_mode_units_procedures`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_mode_units_procedures` AS select distinct `u`.`mode_id` AS `mode_id`,`up`.`unit_id` AS `unit_id`,`up`.`default` AS `default`,`up`.`procedure_id` AS `procedure_id` from (`vw_mode_units` `u` join `units_procedures` `up` on((`u`.`id` = `up`.`unit_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Current Database: `lords_site`
--

USE `lords_site`;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-07-12 18:38:34
