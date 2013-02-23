-- MySQL Administrator dump 1.4
--
-- ------------------------------------------------------
-- Server version	5.5.28


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


--
-- Create schema lords
--

CREATE DATABASE IF NOT EXISTS lords;
USE lords;

--
-- Temporary table structure for view `vw_grave`
--
DROP TABLE IF EXISTS `vw_grave`;
DROP VIEW IF EXISTS `vw_grave`;
CREATE TABLE `vw_grave` (
  `game_id` int(10) unsigned,
  `grave_id` int(10) unsigned,
  `card_id` int(10) unsigned,
  `x` int(11),
  `y` int(11),
  `size` double
);

--
-- Temporary table structure for view `vw_mode_all_procedures`
--
DROP TABLE IF EXISTS `vw_mode_all_procedures`;
DROP VIEW IF EXISTS `vw_mode_all_procedures`;
CREATE TABLE `vw_mode_all_procedures` (
  `mode_id` int(11) unsigned,
  `id` int(10) unsigned,
  `name` varchar(45),
  `params` varchar(100),
  `ui_action_name` varchar(45)
);

--
-- Temporary table structure for view `vw_mode_all_procedures_ids`
--
DROP TABLE IF EXISTS `vw_mode_all_procedures_ids`;
DROP VIEW IF EXISTS `vw_mode_all_procedures_ids`;
CREATE TABLE `vw_mode_all_procedures_ids` (
  `mode_id` int(11) unsigned,
  `procedure_id` int(11) unsigned
);

--
-- Temporary table structure for view `vw_mode_building_default_features`
--
DROP TABLE IF EXISTS `vw_mode_building_default_features`;
DROP VIEW IF EXISTS `vw_mode_building_default_features`;
CREATE TABLE `vw_mode_building_default_features` (
  `mode_id` int(11) unsigned,
  `id` int(10) unsigned,
  `building_id` int(10) unsigned,
  `feature_id` int(10) unsigned,
  `param` int(10) unsigned
);

--
-- Temporary table structure for view `vw_mode_buildings`
--
DROP TABLE IF EXISTS `vw_mode_buildings`;
DROP VIEW IF EXISTS `vw_mode_buildings`;
CREATE TABLE `vw_mode_buildings` (
  `mode_id` int(11) unsigned,
  `id` int(11) unsigned,
  `name` varchar(45),
  `health` int(11) unsigned,
  `radius` int(11),
  `x_len` int(11) unsigned,
  `y_len` int(11) unsigned,
  `shape` varchar(45),
  `type` varchar(45),
  `description` text,
  `log_short_name` varchar(45),
  `ui_code` varchar(45)
);

--
-- Temporary table structure for view `vw_mode_buildings_procedures`
--
DROP TABLE IF EXISTS `vw_mode_buildings_procedures`;
DROP VIEW IF EXISTS `vw_mode_buildings_procedures`;
CREATE TABLE `vw_mode_buildings_procedures` (
  `mode_id` int(11) unsigned,
  `building_id` int(10) unsigned,
  `procedure_id` int(10) unsigned
);

--
-- Temporary table structure for view `vw_mode_cards`
--
DROP TABLE IF EXISTS `vw_mode_cards`;
DROP VIEW IF EXISTS `vw_mode_cards`;
CREATE TABLE `vw_mode_cards` (
  `mode_id` int(10) unsigned,
  `id` int(10) unsigned,
  `image` varchar(45),
  `cost` int(10) unsigned,
  `type` varchar(45),
  `ref` int(10) unsigned,
  `name` varchar(45),
  `description` varchar(1000)
);

--
-- Temporary table structure for view `vw_mode_cards_procedures`
--
DROP TABLE IF EXISTS `vw_mode_cards_procedures`;
DROP VIEW IF EXISTS `vw_mode_cards_procedures`;
CREATE TABLE `vw_mode_cards_procedures` (
  `mode_id` int(10) unsigned,
  `card_id` int(10) unsigned,
  `procedure_id` int(10) unsigned
);

--
-- Temporary table structure for view `vw_mode_unit_default_features`
--
DROP TABLE IF EXISTS `vw_mode_unit_default_features`;
DROP VIEW IF EXISTS `vw_mode_unit_default_features`;
CREATE TABLE `vw_mode_unit_default_features` (
  `mode_id` int(11) unsigned,
  `id` int(10) unsigned,
  `unit_id` int(10) unsigned,
  `feature_id` int(10) unsigned,
  `param` int(10) unsigned
);

--
-- Temporary table structure for view `vw_mode_unit_phrases`
--
DROP TABLE IF EXISTS `vw_mode_unit_phrases`;
DROP VIEW IF EXISTS `vw_mode_unit_phrases`;
CREATE TABLE `vw_mode_unit_phrases` (
  `mode_id` int(11) unsigned,
  `id` int(11),
  `unit_id` int(10) unsigned,
  `phrase` varchar(1000)
);

--
-- Temporary table structure for view `vw_mode_units`
--
DROP TABLE IF EXISTS `vw_mode_units`;
DROP VIEW IF EXISTS `vw_mode_units`;
CREATE TABLE `vw_mode_units` (
  `mode_id` int(11) unsigned,
  `id` int(11) unsigned,
  `name` varchar(45),
  `moves` int(11) unsigned,
  `health` int(11) unsigned,
  `attack` int(11) unsigned,
  `size` int(11) unsigned,
  `shield` int(11),
  `description` text,
  `log_short_name` varchar(45),
  `log_name_rod_pad` varchar(45),
  `ui_code` varchar(45)
);

--
-- Temporary table structure for view `vw_mode_units_procedures`
--
DROP TABLE IF EXISTS `vw_mode_units_procedures`;
DROP VIEW IF EXISTS `vw_mode_units_procedures`;
CREATE TABLE `vw_mode_units_procedures` (
  `mode_id` int(11) unsigned,
  `unit_id` int(10) unsigned,
  `default` int(11),
  `procedure_id` int(10) unsigned
);

--
-- Temporary table structure for view `vw_statistic_values`
--
DROP TABLE IF EXISTS `vw_statistic_values`;
DROP VIEW IF EXISTS `vw_statistic_values`;
CREATE TABLE `vw_statistic_values` (
  `tab_id` int(10) unsigned,
  `tab_name` varchar(45),
  `chart_id` int(10) unsigned,
  `chart_type` varchar(45),
  `chart_name` varchar(100),
  `game_id` int(10) unsigned,
  `value_id` int(10) unsigned,
  `value` float,
  `color` varchar(45),
  `value_name` varchar(100)
);

--
-- Definition of table `active_players`
--

DROP TABLE IF EXISTS `active_players`;
CREATE TABLE `active_players` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `game_id` int(10) unsigned NOT NULL,
  `player_num` int(10) unsigned NOT NULL DEFAULT '0',
  `turn` int(10) unsigned NOT NULL,
  `subsidy_flag` int(10) unsigned NOT NULL DEFAULT '0',
  `units_moves_flag` int(10) unsigned NOT NULL DEFAULT '0',
  `nonfinished_action_id` int(10) unsigned NOT NULL DEFAULT '0',
  `last_end_turn` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `current_procedure` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `active_players`
--

/*!40000 ALTER TABLE `active_players` DISABLE KEYS */;
/*!40000 ALTER TABLE `active_players` ENABLE KEYS */;


--
-- Definition of table `allcoords`
--

DROP TABLE IF EXISTS `allcoords`;
CREATE TABLE `allcoords` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `x` int(11) NOT NULL DEFAULT '0',
  `y` int(11) NOT NULL DEFAULT '0',
  `mode_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `allcoords_modes` (`mode_id`),
  CONSTRAINT `allcoords_modes` FOREIGN KEY (`mode_id`) REFERENCES `modes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4778 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `allcoords`
--

/*!40000 ALTER TABLE `allcoords` DISABLE KEYS */;
INSERT INTO `allcoords` (`id`,`x`,`y`,`mode_id`) VALUES 
 (1,0,0,1),
 (2,1,0,1),
 (3,2,0,1),
 (4,3,0,1),
 (5,4,0,1),
 (6,5,0,1),
 (7,6,0,1),
 (8,7,0,1),
 (9,8,0,1),
 (10,9,0,1),
 (11,10,0,1),
 (12,11,0,1),
 (13,12,0,1),
 (14,13,0,1),
 (15,14,0,1),
 (16,15,0,1),
 (17,16,0,1),
 (18,17,0,1),
 (19,18,0,1),
 (20,19,0,1),
 (21,0,1,1),
 (22,1,1,1),
 (23,2,1,1),
 (24,3,1,1),
 (25,4,1,1),
 (26,5,1,1),
 (27,6,1,1),
 (28,7,1,1),
 (29,8,1,1),
 (30,9,1,1),
 (31,10,1,1),
 (32,11,1,1),
 (33,12,1,1),
 (34,13,1,1),
 (35,14,1,1),
 (36,15,1,1),
 (37,16,1,1),
 (38,17,1,1),
 (39,18,1,1),
 (40,19,1,1),
 (41,0,2,1),
 (42,1,2,1),
 (43,2,2,1),
 (44,3,2,1),
 (45,4,2,1),
 (46,5,2,1),
 (47,6,2,1),
 (48,7,2,1),
 (49,8,2,1),
 (50,9,2,1),
 (51,10,2,1),
 (52,11,2,1),
 (53,12,2,1),
 (54,13,2,1),
 (55,14,2,1),
 (56,15,2,1),
 (57,16,2,1),
 (58,17,2,1),
 (59,18,2,1),
 (60,19,2,1),
 (61,0,3,1),
 (62,1,3,1),
 (63,2,3,1),
 (64,3,3,1),
 (65,4,3,1),
 (66,5,3,1),
 (67,6,3,1),
 (68,7,3,1),
 (69,8,3,1),
 (70,9,3,1),
 (71,10,3,1),
 (72,11,3,1),
 (73,12,3,1),
 (74,13,3,1),
 (75,14,3,1),
 (76,15,3,1),
 (77,16,3,1),
 (78,17,3,1),
 (79,18,3,1),
 (80,19,3,1),
 (81,0,4,1),
 (82,1,4,1),
 (83,2,4,1),
 (84,3,4,1),
 (85,4,4,1),
 (86,5,4,1),
 (87,6,4,1),
 (88,7,4,1),
 (89,8,4,1),
 (90,9,4,1),
 (91,10,4,1),
 (92,11,4,1),
 (93,12,4,1),
 (94,13,4,1),
 (95,14,4,1),
 (96,15,4,1),
 (97,16,4,1),
 (98,17,4,1),
 (99,18,4,1),
 (100,19,4,1),
 (101,0,5,1),
 (102,1,5,1),
 (103,2,5,1),
 (104,3,5,1),
 (105,4,5,1),
 (106,5,5,1),
 (107,6,5,1),
 (108,7,5,1),
 (109,8,5,1),
 (110,9,5,1),
 (111,10,5,1),
 (112,11,5,1),
 (113,12,5,1),
 (114,13,5,1),
 (115,14,5,1),
 (116,15,5,1),
 (117,16,5,1),
 (118,17,5,1),
 (119,18,5,1),
 (120,19,5,1),
 (121,0,6,1),
 (122,1,6,1),
 (123,2,6,1),
 (124,3,6,1),
 (125,4,6,1),
 (126,5,6,1),
 (127,6,6,1),
 (128,7,6,1),
 (129,8,6,1),
 (130,9,6,1),
 (131,10,6,1),
 (132,11,6,1),
 (133,12,6,1),
 (134,13,6,1),
 (135,14,6,1),
 (136,15,6,1),
 (137,16,6,1),
 (138,17,6,1),
 (139,18,6,1),
 (140,19,6,1),
 (141,0,7,1),
 (142,1,7,1),
 (143,2,7,1),
 (144,3,7,1),
 (145,4,7,1),
 (146,5,7,1),
 (147,6,7,1),
 (148,7,7,1),
 (149,8,7,1),
 (150,9,7,1),
 (151,10,7,1),
 (152,11,7,1),
 (153,12,7,1),
 (154,13,7,1),
 (155,14,7,1),
 (156,15,7,1),
 (157,16,7,1),
 (158,17,7,1),
 (159,18,7,1),
 (160,19,7,1),
 (161,0,8,1),
 (162,1,8,1),
 (163,2,8,1),
 (164,3,8,1),
 (165,4,8,1),
 (166,5,8,1),
 (167,6,8,1),
 (168,7,8,1),
 (169,8,8,1),
 (170,9,8,1),
 (171,10,8,1),
 (172,11,8,1),
 (173,12,8,1),
 (174,13,8,1),
 (175,14,8,1),
 (176,15,8,1),
 (177,16,8,1),
 (178,17,8,1),
 (179,18,8,1),
 (180,19,8,1),
 (181,0,9,1),
 (182,1,9,1),
 (183,2,9,1),
 (184,3,9,1),
 (185,4,9,1),
 (186,5,9,1),
 (187,6,9,1),
 (188,7,9,1),
 (189,8,9,1),
 (190,9,9,1),
 (191,10,9,1),
 (192,11,9,1),
 (193,12,9,1),
 (194,13,9,1),
 (195,14,9,1),
 (196,15,9,1),
 (197,16,9,1),
 (198,17,9,1),
 (199,18,9,1),
 (200,19,9,1),
 (201,0,10,1),
 (202,1,10,1),
 (203,2,10,1),
 (204,3,10,1),
 (205,4,10,1),
 (206,5,10,1),
 (207,6,10,1),
 (208,7,10,1),
 (209,8,10,1),
 (210,9,10,1),
 (211,10,10,1),
 (212,11,10,1),
 (213,12,10,1),
 (214,13,10,1),
 (215,14,10,1),
 (216,15,10,1),
 (217,16,10,1),
 (218,17,10,1),
 (219,18,10,1),
 (220,19,10,1),
 (221,0,11,1),
 (222,1,11,1),
 (223,2,11,1),
 (224,3,11,1),
 (225,4,11,1),
 (226,5,11,1),
 (227,6,11,1),
 (228,7,11,1),
 (229,8,11,1),
 (230,9,11,1),
 (231,10,11,1),
 (232,11,11,1),
 (233,12,11,1),
 (234,13,11,1),
 (235,14,11,1),
 (236,15,11,1),
 (237,16,11,1),
 (238,17,11,1),
 (239,18,11,1),
 (240,19,11,1),
 (241,0,12,1),
 (242,1,12,1),
 (243,2,12,1),
 (244,3,12,1),
 (245,4,12,1),
 (246,5,12,1),
 (247,6,12,1),
 (248,7,12,1),
 (249,8,12,1),
 (250,9,12,1),
 (251,10,12,1),
 (252,11,12,1),
 (253,12,12,1),
 (254,13,12,1),
 (255,14,12,1),
 (256,15,12,1),
 (257,16,12,1),
 (258,17,12,1),
 (259,18,12,1),
 (260,19,12,1),
 (261,0,13,1),
 (262,1,13,1),
 (263,2,13,1),
 (264,3,13,1),
 (265,4,13,1),
 (266,5,13,1),
 (267,6,13,1),
 (268,7,13,1),
 (269,8,13,1),
 (270,9,13,1),
 (271,10,13,1),
 (272,11,13,1),
 (273,12,13,1),
 (274,13,13,1),
 (275,14,13,1),
 (276,15,13,1),
 (277,16,13,1),
 (278,17,13,1),
 (279,18,13,1),
 (280,19,13,1),
 (281,0,14,1),
 (282,1,14,1),
 (283,2,14,1),
 (284,3,14,1),
 (285,4,14,1),
 (286,5,14,1),
 (287,6,14,1),
 (288,7,14,1),
 (289,8,14,1),
 (290,9,14,1),
 (291,10,14,1),
 (292,11,14,1),
 (293,12,14,1),
 (294,13,14,1),
 (295,14,14,1),
 (296,15,14,1),
 (297,16,14,1),
 (298,17,14,1),
 (299,18,14,1),
 (300,19,14,1),
 (301,0,15,1),
 (302,1,15,1),
 (303,2,15,1),
 (304,3,15,1),
 (305,4,15,1),
 (306,5,15,1),
 (307,6,15,1),
 (308,7,15,1),
 (309,8,15,1),
 (310,9,15,1),
 (311,10,15,1),
 (312,11,15,1),
 (313,12,15,1),
 (314,13,15,1),
 (315,14,15,1),
 (316,15,15,1),
 (317,16,15,1),
 (318,17,15,1),
 (319,18,15,1),
 (320,19,15,1),
 (321,0,16,1),
 (322,1,16,1),
 (323,2,16,1),
 (324,3,16,1),
 (325,4,16,1),
 (326,5,16,1),
 (327,6,16,1),
 (328,7,16,1),
 (329,8,16,1),
 (330,9,16,1),
 (331,10,16,1),
 (332,11,16,1),
 (333,12,16,1),
 (334,13,16,1),
 (335,14,16,1),
 (336,15,16,1),
 (337,16,16,1),
 (338,17,16,1),
 (339,18,16,1),
 (340,19,16,1),
 (341,0,17,1),
 (342,1,17,1),
 (343,2,17,1),
 (344,3,17,1),
 (345,4,17,1),
 (346,5,17,1),
 (347,6,17,1),
 (348,7,17,1),
 (349,8,17,1),
 (350,9,17,1),
 (351,10,17,1),
 (352,11,17,1),
 (353,12,17,1),
 (354,13,17,1),
 (355,14,17,1),
 (356,15,17,1),
 (357,16,17,1),
 (358,17,17,1),
 (359,18,17,1),
 (360,19,17,1),
 (361,0,18,1),
 (362,1,18,1),
 (363,2,18,1),
 (364,3,18,1),
 (365,4,18,1),
 (366,5,18,1),
 (367,6,18,1),
 (368,7,18,1),
 (369,8,18,1),
 (370,9,18,1),
 (371,10,18,1),
 (372,11,18,1),
 (373,12,18,1),
 (374,13,18,1),
 (375,14,18,1),
 (376,15,18,1),
 (377,16,18,1),
 (378,17,18,1),
 (379,18,18,1),
 (380,19,18,1),
 (381,0,19,1),
 (382,1,19,1),
 (383,2,19,1),
 (384,3,19,1),
 (385,4,19,1),
 (386,5,19,1),
 (387,6,19,1),
 (388,7,19,1),
 (389,8,19,1),
 (390,9,19,1),
 (391,10,19,1),
 (392,11,19,1),
 (393,12,19,1),
 (394,13,19,1),
 (395,14,19,1),
 (396,15,19,1),
 (397,16,19,1),
 (398,17,19,1),
 (399,18,19,1),
 (400,19,19,1),
 (4378,0,0,8),
 (4379,1,0,8),
 (4380,2,0,8),
 (4381,3,0,8),
 (4382,4,0,8),
 (4383,5,0,8),
 (4384,6,0,8),
 (4385,7,0,8),
 (4386,8,0,8),
 (4387,9,0,8),
 (4388,10,0,8),
 (4389,11,0,8),
 (4390,12,0,8),
 (4391,13,0,8),
 (4392,14,0,8),
 (4393,15,0,8),
 (4394,16,0,8),
 (4395,17,0,8),
 (4396,18,0,8),
 (4397,19,0,8),
 (4398,0,1,8),
 (4399,1,1,8),
 (4400,2,1,8),
 (4401,3,1,8),
 (4402,4,1,8),
 (4403,5,1,8),
 (4404,6,1,8),
 (4405,7,1,8),
 (4406,8,1,8),
 (4407,9,1,8),
 (4408,10,1,8),
 (4409,11,1,8),
 (4410,12,1,8),
 (4411,13,1,8),
 (4412,14,1,8),
 (4413,15,1,8),
 (4414,16,1,8),
 (4415,17,1,8),
 (4416,18,1,8),
 (4417,19,1,8),
 (4418,0,2,8),
 (4419,1,2,8),
 (4420,2,2,8),
 (4421,3,2,8),
 (4422,4,2,8),
 (4423,5,2,8),
 (4424,6,2,8),
 (4425,7,2,8),
 (4426,8,2,8),
 (4427,9,2,8),
 (4428,10,2,8),
 (4429,11,2,8),
 (4430,12,2,8),
 (4431,13,2,8),
 (4432,14,2,8),
 (4433,15,2,8),
 (4434,16,2,8),
 (4435,17,2,8),
 (4436,18,2,8),
 (4437,19,2,8),
 (4438,0,3,8),
 (4439,1,3,8),
 (4440,2,3,8),
 (4441,3,3,8),
 (4442,4,3,8),
 (4443,5,3,8),
 (4444,6,3,8),
 (4445,7,3,8),
 (4446,8,3,8),
 (4447,9,3,8),
 (4448,10,3,8),
 (4449,11,3,8),
 (4450,12,3,8),
 (4451,13,3,8),
 (4452,14,3,8),
 (4453,15,3,8),
 (4454,16,3,8),
 (4455,17,3,8),
 (4456,18,3,8),
 (4457,19,3,8),
 (4458,0,4,8),
 (4459,1,4,8),
 (4460,2,4,8),
 (4461,3,4,8),
 (4462,4,4,8),
 (4463,5,4,8),
 (4464,6,4,8),
 (4465,7,4,8),
 (4466,8,4,8),
 (4467,9,4,8),
 (4468,10,4,8),
 (4469,11,4,8),
 (4470,12,4,8),
 (4471,13,4,8),
 (4472,14,4,8),
 (4473,15,4,8),
 (4474,16,4,8),
 (4475,17,4,8),
 (4476,18,4,8),
 (4477,19,4,8),
 (4478,0,5,8),
 (4479,1,5,8),
 (4480,2,5,8),
 (4481,3,5,8),
 (4482,4,5,8),
 (4483,5,5,8),
 (4484,6,5,8),
 (4485,7,5,8),
 (4486,8,5,8),
 (4487,9,5,8),
 (4488,10,5,8),
 (4489,11,5,8),
 (4490,12,5,8),
 (4491,13,5,8),
 (4492,14,5,8),
 (4493,15,5,8),
 (4494,16,5,8),
 (4495,17,5,8),
 (4496,18,5,8),
 (4497,19,5,8),
 (4498,0,6,8),
 (4499,1,6,8),
 (4500,2,6,8),
 (4501,3,6,8),
 (4502,4,6,8),
 (4503,5,6,8),
 (4504,6,6,8),
 (4505,7,6,8),
 (4506,8,6,8),
 (4507,9,6,8),
 (4508,10,6,8),
 (4509,11,6,8),
 (4510,12,6,8),
 (4511,13,6,8),
 (4512,14,6,8),
 (4513,15,6,8),
 (4514,16,6,8),
 (4515,17,6,8),
 (4516,18,6,8),
 (4517,19,6,8),
 (4518,0,7,8),
 (4519,1,7,8),
 (4520,2,7,8),
 (4521,3,7,8),
 (4522,4,7,8),
 (4523,5,7,8),
 (4524,6,7,8),
 (4525,7,7,8),
 (4526,8,7,8),
 (4527,9,7,8),
 (4528,10,7,8),
 (4529,11,7,8),
 (4530,12,7,8),
 (4531,13,7,8),
 (4532,14,7,8),
 (4533,15,7,8),
 (4534,16,7,8),
 (4535,17,7,8),
 (4536,18,7,8),
 (4537,19,7,8),
 (4538,0,8,8),
 (4539,1,8,8),
 (4540,2,8,8),
 (4541,3,8,8),
 (4542,4,8,8),
 (4543,5,8,8),
 (4544,6,8,8),
 (4545,7,8,8),
 (4546,8,8,8),
 (4547,9,8,8),
 (4548,10,8,8),
 (4549,11,8,8),
 (4550,12,8,8),
 (4551,13,8,8),
 (4552,14,8,8),
 (4553,15,8,8),
 (4554,16,8,8),
 (4555,17,8,8),
 (4556,18,8,8),
 (4557,19,8,8),
 (4558,0,9,8),
 (4559,1,9,8),
 (4560,2,9,8),
 (4561,3,9,8),
 (4562,4,9,8),
 (4563,5,9,8),
 (4564,6,9,8),
 (4565,7,9,8),
 (4566,8,9,8),
 (4567,9,9,8),
 (4568,10,9,8),
 (4569,11,9,8),
 (4570,12,9,8),
 (4571,13,9,8),
 (4572,14,9,8),
 (4573,15,9,8),
 (4574,16,9,8),
 (4575,17,9,8),
 (4576,18,9,8),
 (4577,19,9,8),
 (4578,0,10,8),
 (4579,1,10,8),
 (4580,2,10,8),
 (4581,3,10,8),
 (4582,4,10,8),
 (4583,5,10,8),
 (4584,6,10,8),
 (4585,7,10,8),
 (4586,8,10,8),
 (4587,9,10,8),
 (4588,10,10,8),
 (4589,11,10,8),
 (4590,12,10,8),
 (4591,13,10,8),
 (4592,14,10,8),
 (4593,15,10,8),
 (4594,16,10,8),
 (4595,17,10,8),
 (4596,18,10,8),
 (4597,19,10,8),
 (4598,0,11,8),
 (4599,1,11,8),
 (4600,2,11,8),
 (4601,3,11,8),
 (4602,4,11,8),
 (4603,5,11,8),
 (4604,6,11,8),
 (4605,7,11,8),
 (4606,8,11,8),
 (4607,9,11,8),
 (4608,10,11,8),
 (4609,11,11,8),
 (4610,12,11,8),
 (4611,13,11,8),
 (4612,14,11,8),
 (4613,15,11,8),
 (4614,16,11,8),
 (4615,17,11,8),
 (4616,18,11,8),
 (4617,19,11,8),
 (4618,0,12,8),
 (4619,1,12,8),
 (4620,2,12,8),
 (4621,3,12,8),
 (4622,4,12,8),
 (4623,5,12,8),
 (4624,6,12,8),
 (4625,7,12,8),
 (4626,8,12,8),
 (4627,9,12,8),
 (4628,10,12,8),
 (4629,11,12,8),
 (4630,12,12,8),
 (4631,13,12,8),
 (4632,14,12,8),
 (4633,15,12,8),
 (4634,16,12,8),
 (4635,17,12,8),
 (4636,18,12,8),
 (4637,19,12,8),
 (4638,0,13,8),
 (4639,1,13,8),
 (4640,2,13,8),
 (4641,3,13,8),
 (4642,4,13,8),
 (4643,5,13,8),
 (4644,6,13,8),
 (4645,7,13,8),
 (4646,8,13,8),
 (4647,9,13,8),
 (4648,10,13,8),
 (4649,11,13,8),
 (4650,12,13,8),
 (4651,13,13,8),
 (4652,14,13,8),
 (4653,15,13,8),
 (4654,16,13,8),
 (4655,17,13,8),
 (4656,18,13,8),
 (4657,19,13,8),
 (4658,0,14,8),
 (4659,1,14,8),
 (4660,2,14,8),
 (4661,3,14,8),
 (4662,4,14,8),
 (4663,5,14,8),
 (4664,6,14,8),
 (4665,7,14,8),
 (4666,8,14,8),
 (4667,9,14,8),
 (4668,10,14,8),
 (4669,11,14,8),
 (4670,12,14,8),
 (4671,13,14,8),
 (4672,14,14,8),
 (4673,15,14,8),
 (4674,16,14,8),
 (4675,17,14,8),
 (4676,18,14,8),
 (4677,19,14,8),
 (4678,0,15,8),
 (4679,1,15,8),
 (4680,2,15,8),
 (4681,3,15,8),
 (4682,4,15,8),
 (4683,5,15,8),
 (4684,6,15,8),
 (4685,7,15,8),
 (4686,8,15,8),
 (4687,9,15,8),
 (4688,10,15,8),
 (4689,11,15,8),
 (4690,12,15,8),
 (4691,13,15,8),
 (4692,14,15,8),
 (4693,15,15,8),
 (4694,16,15,8),
 (4695,17,15,8),
 (4696,18,15,8),
 (4697,19,15,8),
 (4698,0,16,8),
 (4699,1,16,8),
 (4700,2,16,8),
 (4701,3,16,8),
 (4702,4,16,8),
 (4703,5,16,8),
 (4704,6,16,8),
 (4705,7,16,8),
 (4706,8,16,8),
 (4707,9,16,8),
 (4708,10,16,8),
 (4709,11,16,8),
 (4710,12,16,8),
 (4711,13,16,8),
 (4712,14,16,8),
 (4713,15,16,8),
 (4714,16,16,8),
 (4715,17,16,8),
 (4716,18,16,8),
 (4717,19,16,8),
 (4718,0,17,8),
 (4719,1,17,8),
 (4720,2,17,8),
 (4721,3,17,8),
 (4722,4,17,8),
 (4723,5,17,8),
 (4724,6,17,8),
 (4725,7,17,8),
 (4726,8,17,8),
 (4727,9,17,8),
 (4728,10,17,8),
 (4729,11,17,8),
 (4730,12,17,8),
 (4731,13,17,8),
 (4732,14,17,8),
 (4733,15,17,8),
 (4734,16,17,8),
 (4735,17,17,8),
 (4736,18,17,8),
 (4737,19,17,8),
 (4738,0,18,8),
 (4739,1,18,8),
 (4740,2,18,8),
 (4741,3,18,8),
 (4742,4,18,8),
 (4743,5,18,8),
 (4744,6,18,8),
 (4745,7,18,8),
 (4746,8,18,8),
 (4747,9,18,8),
 (4748,10,18,8),
 (4749,11,18,8),
 (4750,12,18,8),
 (4751,13,18,8),
 (4752,14,18,8),
 (4753,15,18,8),
 (4754,16,18,8),
 (4755,17,18,8),
 (4756,18,18,8),
 (4757,19,18,8),
 (4758,0,19,8),
 (4759,1,19,8),
 (4760,2,19,8),
 (4761,3,19,8),
 (4762,4,19,8),
 (4763,5,19,8),
 (4764,6,19,8),
 (4765,7,19,8),
 (4766,8,19,8),
 (4767,9,19,8),
 (4768,10,19,8),
 (4769,11,19,8),
 (4770,12,19,8),
 (4771,13,19,8),
 (4772,14,19,8),
 (4773,15,19,8),
 (4774,16,19,8),
 (4775,17,19,8),
 (4776,18,19,8),
 (4777,19,19,8);
/*!40000 ALTER TABLE `allcoords` ENABLE KEYS */;


--
-- Definition of table `appear_points`
--

DROP TABLE IF EXISTS `appear_points`;
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
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `appear_points`
--

/*!40000 ALTER TABLE `appear_points` DISABLE KEYS */;
INSERT INTO `appear_points` (`id`,`player_num`,`x`,`y`,`direction_into_board_x`,`direction_into_board_y`,`mode_id`) VALUES 
 (1,0,1,1,1,1,1),
 (2,1,18,1,-1,1,1),
 (3,2,18,18,-1,-1,1),
 (4,3,1,18,1,-1,1),
 (44,0,1,1,1,1,8),
 (45,1,18,1,-1,1,8),
 (46,2,18,18,-1,-1,8),
 (47,3,1,18,1,-1,8);
/*!40000 ALTER TABLE `appear_points` ENABLE KEYS */;


--
-- Definition of table `attack_bonus`
--

DROP TABLE IF EXISTS `attack_bonus`;
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
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `attack_bonus`
--

/*!40000 ALTER TABLE `attack_bonus` DISABLE KEYS */;
INSERT INTO `attack_bonus` (`id`,`mode_id`,`unit_id`,`aim_type`,`aim_id`,`dice_max`,`chance`,`critical_chance`,`damage_bonus`,`critical_bonus`,`priority`,`comment`) VALUES 
 (1,1,NULL,NULL,NULL,6,4,6,0,1,0,'Обычная атака всех на всех'),
 (2,1,NULL,'unit',5,6,5,6,0,1,5,'Попадание в ниндзю - 5,6'),
 (3,1,7,'unit',NULL,6,4,7,-100,-100,10,'Таран не атакует юнитов'),
 (4,1,1,'unit',4,6,4,6,0,2,15,'Копейщик критическим на конного +1'),
 (5,1,3,'unit',10,6,4,6,0,3,15,'Рыцарь +2 критическим против дракона'),
 (6,1,4,'unit',10,6,4,6,0,3,15,'Конный рыцарь +2 критическим против дракона'),
 (7,1,NULL,'unit',6,6,4,6,-1,0,5,'По голему -1 урона'),
 (32,8,NULL,NULL,NULL,3,1,3,0,1,0,'Обычная атака всех на всех - попадание 100%, крит 1/3'),
 (33,8,NULL,'unit',18,6,4,6,0,1,5,'Попадание в ниндзю - 1/2, крит 1/6'),
 (34,8,20,'unit',NULL,3,1,4,-100,-100,10,'Таран не атакует юнитов'),
 (35,8,14,'unit',17,3,1,3,0,2,15,'Копейщик критическим на конного +1'),
 (36,8,16,'unit',23,3,1,3,0,3,15,'Рыцарь +2 критическим против дракона'),
 (37,8,17,'unit',23,3,1,3,0,3,15,'Конный рыцарь +2 критическим против дракона'),
 (38,8,NULL,'unit',19,3,1,3,-1,0,5,'По голему -1 урона'),
 (39,8,27,NULL,NULL,3,1,4,-100,-100,10,'Лучник не бьет в ближнем бою'),
 (40,8,28,NULL,NULL,3,1,4,-100,-100,10,'Лучник не бьет в ближнем бою'),
 (41,8,29,NULL,NULL,3,1,4,-100,-100,10,'Катапульта не бьет в ближнем бою');
/*!40000 ALTER TABLE `attack_bonus` ENABLE KEYS */;


--
-- Definition of table `board`
--

DROP TABLE IF EXISTS `board`;
CREATE TABLE `board` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `game_id` int(10) unsigned NOT NULL,
  `x` int(11) NOT NULL DEFAULT '0',
  `y` int(11) NOT NULL DEFAULT '0',
  `type` varchar(45) NOT NULL,
  `ref` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `board`
--

/*!40000 ALTER TABLE `board` DISABLE KEYS */;
/*!40000 ALTER TABLE `board` ENABLE KEYS */;


--
-- Definition of table `board_buildings`
--

DROP TABLE IF EXISTS `board_buildings`;
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

--
-- Dumping data for table `board_buildings`
--

/*!40000 ALTER TABLE `board_buildings` DISABLE KEYS */;
/*!40000 ALTER TABLE `board_buildings` ENABLE KEYS */;


--
-- Definition of trigger `board_buildings_bi`
--

DROP TRIGGER /*!50030 IF EXISTS */ `board_buildings_bi`;

DELIMITER $$

CREATE DEFINER = `root`@`localhost` TRIGGER `board_buildings_bi` BEFORE INSERT ON `board_buildings` FOR EACH ROW BEGIN
  IF (NEW.building_id=0 AND NEW.card_id IS NOT NULL)
  THEN
    SET NEW.building_id=(SELECT cards.ref FROM cards WHERE cards.id=NEW.card_id);
  END IF;
  SET NEW.health=(SELECT buildings.health FROM buildings WHERE buildings.id=NEW.building_id);
  SET NEW.max_health=NEW.health;
  SET NEW.radius=(SELECT buildings.radius FROM buildings WHERE buildings.id=NEW.building_id);
END $$

DELIMITER ;

--
-- Definition of table `board_buildings_features`
--

DROP TABLE IF EXISTS `board_buildings_features`;
CREATE TABLE `board_buildings_features` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `board_building_id` int(10) unsigned NOT NULL,
  `feature_id` int(10) unsigned NOT NULL,
  `param` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `board_buildings_features`
--

/*!40000 ALTER TABLE `board_buildings_features` DISABLE KEYS */;
/*!40000 ALTER TABLE `board_buildings_features` ENABLE KEYS */;


--
-- Definition of table `board_units`
--

DROP TABLE IF EXISTS `board_units`;
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `board_units`
--

/*!40000 ALTER TABLE `board_units` DISABLE KEYS */;
/*!40000 ALTER TABLE `board_units` ENABLE KEYS */;


--
-- Definition of trigger `board_units_bi`
--

DROP TRIGGER /*!50030 IF EXISTS */ `board_units_bi`;

DELIMITER $$

CREATE DEFINER = `root`@`localhost` TRIGGER `board_units_bi` BEFORE INSERT ON `board_units` FOR EACH ROW BEGIN
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
END $$

DELIMITER ;

--
-- Definition of table `board_units_features`
--

DROP TABLE IF EXISTS `board_units_features`;
CREATE TABLE `board_units_features` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `board_unit_id` int(10) unsigned NOT NULL,
  `feature_id` int(10) unsigned NOT NULL,
  `param` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `board_units_features`
--

/*!40000 ALTER TABLE `board_units_features` DISABLE KEYS */;
/*!40000 ALTER TABLE `board_units_features` ENABLE KEYS */;


--
-- Definition of table `building_default_features`
--

DROP TABLE IF EXISTS `building_default_features`;
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
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `building_default_features`
--

/*!40000 ALTER TABLE `building_default_features` DISABLE KEYS */;
INSERT INTO `building_default_features` (`id`,`building_id`,`feature_id`,`param`) VALUES 
 (1,1,1,NULL),
 (2,2,3,3),
 (3,4,2,NULL),
 (4,5,4,NULL),
 (5,6,5,NULL),
 (6,5,6,NULL),
 (7,6,6,NULL),
 (8,3,7,NULL),
 (9,5,8,NULL),
 (59,9,1,NULL),
 (60,10,3,3),
 (61,11,7,NULL),
 (62,12,2,NULL),
 (63,13,4,NULL),
 (64,13,6,NULL),
 (65,13,8,NULL),
 (66,14,5,NULL),
 (67,14,6,NULL);
/*!40000 ALTER TABLE `building_default_features` ENABLE KEYS */;


--
-- Definition of table `building_features`
--

DROP TABLE IF EXISTS `building_features`;
CREATE TABLE `building_features` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(45) NOT NULL,
  `description` varchar(200) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `building_features`
--

/*!40000 ALTER TABLE `building_features` DISABLE KEYS */;
INSERT INTO `building_features` (`id`,`code`,`description`) VALUES 
 (1,'teleport','Позволяет телепортировать юнитов в свой радиус'),
 (2,'healing','Лечит юнитов в своем радиусе'),
 (3,'magic_increase','Увеличивает эффект от магии в своем радиусе'),
 (4,'frog_factory','Плодит Жабок'),
 (5,'troll_factory','Плодит Троллей'),
 (6,'summon_team','Номер команды плодимых юнитов'),
 (7,'coin_factory','Монетный двор'),
 (8,'water','Можно утонуть');
/*!40000 ALTER TABLE `building_features` ENABLE KEYS */;


--
-- Definition of table `buildings`
--

DROP TABLE IF EXISTS `buildings`;
CREATE TABLE `buildings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL DEFAULT '',
  `health` int(10) unsigned NOT NULL,
  `radius` int(10) DEFAULT NULL,
  `x_len` int(10) unsigned NOT NULL,
  `y_len` int(10) unsigned NOT NULL,
  `shape` varchar(45) NOT NULL DEFAULT '1',
  `type` varchar(45) NOT NULL DEFAULT '',
  `description` varchar(1000) DEFAULT NULL,
  `log_short_name` varchar(45) DEFAULT NULL,
  `ui_code` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `buildings`
--

/*!40000 ALTER TABLE `buildings` DISABLE KEYS */;
INSERT INTO `buildings` (`id`,`name`,`health`,`radius`,`x_len`,`y_len`,`shape`,`type`,`description`,`log_short_name`,`ui_code`) VALUES 
 (1,'Телепорт',3,1,1,1,'1','building','Позволяет перемещать свои юниты и юниты союзника в радиус действия телепорта','Телепорт','teleport'),
 (2,'Магическая башня',3,2,1,1,'1','building','Усиливает магию в 3 раза в радиусе своего действия','Маг. баш.','magic_tower'),
 (3,'Монетный двор',4,2,1,1,'1','building',NULL,'Мон. двор','coin_factory'),
 (4,'Храм лечения',3,1,1,1,'1','building','Лечит здоровье юнитов и восстанавливает щит магу','Храм леч.','healing_temple'),
 (5,'Озеро',0,0,4,3,'011011110110','obstacle','Из озера появляются 3 жабки, которые бьют ближайших юнитов любых игроков','Озеро','lake'),
 (6,'Горы',0,0,5,4,'00011001100110011000','obstacle','Из гор появляется тролль, который идет бить ближайшее здание','Горы','mountain'),
 (7,'Замок',10,0,2,2,'1110','castle',NULL,'Замок','castle'),
 (8,'Руины замка',0,0,2,2,'1110','obstacle','Здесь когда-то жил Лорд...','Руины','ruins'),
 (9,'Телепорт',3,1,1,1,'1','building','Позволяет перемещать свои юниты и юниты союзника в радиус действия телепорта','Телепорт','teleport'),
 (10,'Магическая башня',3,2,1,1,'1','building','Усиливает магию в 3 раза в радиусе своего действия','Маг. баш.','magic_tower'),
 (11,'Монетный двор',4,2,1,1,'1','building',NULL,'Мон. двор','coin_factory'),
 (12,'Храм лечения',3,1,1,1,'1','building','Лечит здоровье юнитов и восстанавливает щит магу','Храм леч.','healing_temple'),
 (13,'Озеро',0,0,4,3,'011011110110','obstacle','Из озера появляются 3 жабки, которые бьют ближайших юнитов любых игроков','Озеро','lake'),
 (14,'Горы',0,0,5,4,'00011001100110011000','obstacle','Из гор появляется тролль, который идет бить ближайшее здание','Горы','mountain'),
 (15,'Замок',10,0,2,2,'1110','castle',NULL,'Замок','castle'),
 (16,'Руины замка',0,0,2,2,'1110','obstacle','Здесь когда-то жил Лорд...','Руины','ruins');
/*!40000 ALTER TABLE `buildings` ENABLE KEYS */;


--
-- Definition of table `buildings_procedures`
--

DROP TABLE IF EXISTS `buildings_procedures`;
CREATE TABLE `buildings_procedures` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `building_id` int(10) unsigned NOT NULL,
  `procedure_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `buildings_procedures_buildings` (`building_id`),
  KEY `buildings_procedures_procedures` (`procedure_id`),
  CONSTRAINT `buildings_procedures_buildings` FOREIGN KEY (`building_id`) REFERENCES `buildings` (`id`) ON DELETE CASCADE,
  CONSTRAINT `buildings_procedures_procedures` FOREIGN KEY (`procedure_id`) REFERENCES `procedures` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `buildings_procedures`
--

/*!40000 ALTER TABLE `buildings_procedures` DISABLE KEYS */;
/*!40000 ALTER TABLE `buildings_procedures` ENABLE KEYS */;


--
-- Definition of table `cards`
--

DROP TABLE IF EXISTS `cards`;
CREATE TABLE `cards` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `image` varchar(45) NOT NULL,
  `cost` int(10) unsigned NOT NULL,
  `type` varchar(45) NOT NULL,
  `ref` int(10) unsigned NOT NULL,
  `name` varchar(45) NOT NULL,
  `description` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=104 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `cards`
--

/*!40000 ALTER TABLE `cards` DISABLE KEYS */;
INSERT INTO `cards` (`id`,`image`,`cost`,`type`,`ref`,`name`,`description`) VALUES 
 (1,'teleport_building.png',0,'b',1,'Телепорт',NULL),
 (2,'magic_tower.png',0,'b',2,'Магическая башня',NULL),
 (3,'coin_factory.png',0,'b',3,'Монетный двор',NULL),
 (4,'healing_temple.png',0,'b',4,'Храм лечения',NULL),
 (5,'lake.png',0,'b',5,'Озеро',NULL),
 (6,'mountain.png',0,'b',6,'Горы',NULL),
 (7,'spearman.png',2,'u',1,'Копейщик',NULL),
 (12,'swordsman.png',3,'u',2,'Мечник',NULL),
 (16,'knight_on_foot.png',5,'u',3,'Рыцарь',NULL),
 (19,'knight_with_horse.png',20,'u',4,'Конный рыцарь',NULL),
 (21,'ninja.png',30,'u',5,'Ниндзя',NULL),
 (22,'golem.png',30,'u',6,'Голем',NULL),
 (23,'taran.png',15,'u',7,'Таран',NULL),
 (24,'wizard.png',35,'u',8,'Маг',NULL),
 (25,'necromancer.png',35,'u',9,'Некромант',NULL),
 (26,'dragon.png',100,'u',10,'Дракон',NULL),
 (27,'fireball.png',5,'m',0,'Fireball','Наносит 1 ед. урона с вероятностью 2/3.'),
 (32,'healing.png',5,'m',0,'Лечение','Восстанавливает 1 ед. здоровья или снимает паралич или бешенство. Восстанавливает 1 щит магу.'),
 (36,'lightening.png',10,'m',0,'Молния','Сильная молния наносит 3 ед. урона с вероятностью 1/2. Слабая молния наносит 2 ед. урона с вероятностью 2/3.'),
 (39,'od.png',30,'m',0,'Отделение души','С вероятностью 2/3 убивает юнит или 1/6 исцеляет или 1/6 повергает в бешенство.'),
 (41,'teleport_magic.png',70,'m',0,'Телепорт','Переместить любой юнит в свободную клетку.'),
 (42,'paralich.png',30,'m',0,'Паралич','Парализует любой юнит.'),
 (43,'armageddon.png',100,'m',0,'Армагеддон','С вероятностью 2/3 уничтожает каждый объект на карте кроме замков'),
 (44,'meteor.png',50,'m',0,'Метеоритный дождь','Наносит 2ед урона зданиям и юнитам. Площадь атаки 2 на 2.'),
 (45,'shield.png',30,'m',0,'Щит','+1 щит любому юниту.'),
 (46,'vred.png',40,'m',0,'Вред','С вероятностью 1/6: -60 золота любому игроку; убить любого юнита; разрушить любое здание; переместить юнитов в случайную зону; случайный игрок тянет у всех по карте; переместить чужое здание.'),
 (47,'mind_control.png',40,'e',0,'Контроль разума','С вероятностью 1/2 повергает юнит в бешенство или дает контроль над юнитом.'),
 (48,'russian_rul.png',1,'e',0,'Русская рулетка','С вероятностью 1/6 убивает любого юнита.'),
 (49,'madness.png',30,'e',0,'Бешенство','Повергает выбранного юнита в бешенство.'),
 (50,'open_cards.png',0,'e',0,'Открыть карты выбранного игрока','1 раз открывает все карты выбранного игрока.'),
 (51,'telekinesis.png',25,'e',0,'Телекинез','Вытянуть у любого игрока 1 карту.'),
 (52,'half_money.png',1,'e',0,'Сокращение денег в два раза у всех игроков','Сокращает деньги в 2 раза у всех игроков.'),
 (53,'pooring.png',20,'e',0,'Обеднение','-50 золота у выбраного игрока.'),
 (54,'riching.png',0,'e',0,'Обогащение','+50 золота.'),
 (55,'vampire.png',35,'e',0,'Вампир','Призывает Вампира.'),
 (56,'fastening.png',10,'e',0,'Ускорение','+2 хода выбранному юниту.'),
 (57,'eagerness.png',0,'e',0,'Рвение','С вероятностью 1/2 юнит ходит шахматным конем или +2 атаки юниту.'),
 (58,'polza.png',0,'e',0,'Польза','С вероятностью 1/6: починка всех своих зданий включая Замок; воскресить любого юнита; +60 золота; взять 2 карты; переместить всех юнитов из выбранной зоны; переместить и присвоить здание.'),
 (59,'upgrade.png',35,'e',0,'Улучшение','На выбор игрока +1 к атаке, здоровью и ходьбе; или с вероятностью 1/3 +3 к атаке, здоровью или ходьбе.'),
 (60,'repair.png',0,'e',0,'Починить здания','Починка всех своих здания включая Замок.'),
 (61,'teleport_building.png',0,'b',9,'Телепорт',NULL),
 (62,'magic_tower.png',0,'b',10,'Магическая башня',NULL),
 (63,'coin_factory.png',0,'b',11,'Монетный двор',NULL),
 (64,'healing_temple.png',0,'b',12,'Храм лечения',NULL),
 (65,'lake.png',0,'b',13,'Озеро',NULL),
 (66,'mountain.png',0,'b',14,'Горы',NULL),
 (67,'spearman.png',2,'u',14,'Копейщик',NULL),
 (68,'swordsman.png',3,'u',15,'Мечник',NULL),
 (69,'knight_on_foot.png',5,'u',16,'Рыцарь',NULL),
 (70,'knight_with_horse.png',20,'u',17,'Конный рыцарь',NULL),
 (71,'ninja.png',30,'u',18,'Ниндзя',NULL),
 (72,'golem.png',30,'u',19,'Голем',NULL),
 (73,'taran.png',15,'u',20,'Таран',NULL),
 (74,'wizard.png',35,'u',21,'Маг',NULL),
 (75,'necromancer.png',35,'u',22,'Некромант',NULL),
 (76,'dragon.png',100,'u',23,'Дракон',NULL),
 (77,'fireball.png',5,'m',0,'Fireball','Наносит 1 ед. урона с вероятностью 2/3.'),
 (78,'healing.png',5,'m',0,'Лечение','Восстанавливает 1 ед. здоровья или снимает паралич или бешенство. Восстанавливает 1 щит магу.'),
 (79,'lightening.png',10,'m',0,'Молния','Сильная молния наносит 3 ед. урона с вероятностью 1/2. Слабая молния наносит 2 ед. урона с вероятностью 2/3.'),
 (80,'od.png',30,'m',0,'Отделение души','С вероятностью 2/3 убивает юнит или 1/6 исцеляет или 1/6 повергает в бешенство.'),
 (81,'teleport_magic.png',70,'m',0,'Телепорт','Переместить любой юнит в свободную клетку.'),
 (82,'paralich.png',30,'m',0,'Паралич','Парализует любой юнит.'),
 (83,'armageddon.png',100,'m',0,'Армагеддон','С вероятностью 2/3 уничтожает каждый объект на карте кроме замков'),
 (84,'meteor.png',50,'m',0,'Метеоритный дождь','Наносит 2ед урона зданиям и юнитам. Площадь атаки 2 на 2.'),
 (85,'shield.png',30,'m',0,'Щит','+1 щит любому юниту.'),
 (86,'vred.png',40,'m',0,'Вред','С вероятностью 1/6: -60 золота любому игроку; убить любого юнита; разрушить любое здание; переместить юнитов в случайную зону; случайный игрок тянет у всех по карте; переместить чужое здание.'),
 (87,'mind_control.png',40,'e',0,'Контроль разума','С вероятностью 1/2 повергает юнит в бешенство или дает контроль над юнитом.'),
 (88,'russian_rul.png',1,'e',0,'Русская рулетка','С вероятностью 1/6 убивает любого юнита.'),
 (89,'madness.png',30,'e',0,'Бешенство','Повергает выбранного юнита в бешенство.'),
 (90,'open_cards.png',0,'e',0,'Открыть карты выбранного игрока','1 раз открывает все карты выбранного игрока.'),
 (91,'telekinesis.png',25,'e',0,'Телекинез','Вытянуть у любого игрока 1 карту.'),
 (92,'half_money.png',1,'e',0,'Сокращение денег в два раза у всех игроков','Сокращает деньги в 2 раза у всех игроков.'),
 (93,'pooring.png',20,'e',0,'Обеднение','-50 золота у выбраного игрока.'),
 (94,'riching.png',0,'e',0,'Обогащение','+50 золота.'),
 (95,'vampire.png',35,'e',0,'Вампир','Призывает Вампира.'),
 (96,'fastening.png',10,'e',0,'Ускорение','+2 хода выбранному юниту.'),
 (97,'eagerness.png',0,'e',0,'Рвение','С вероятностью 1/2 юнит ходит шахматным конем или +2 атаки юниту.'),
 (98,'polza.png',0,'e',0,'Польза','С вероятностью 1/6: починка всех своих зданий включая Замок; воскресить любого юнита; +60 золота; взять 2 карты; переместить всех юнитов из выбранной зоны; переместить и присвоить здание.'),
 (99,'upgrade.png',35,'e',0,'Улучшение','На выбор игрока +1 к атаке, здоровью и ходьбе; или с вероятностью 1/3 +3 к атаке, здоровью или ходьбе.'),
 (100,'repair.png',0,'e',0,'Починить здания','Починка всех своих здания включая Замок.'),
 (101,'archer.png',25,'u',27,'Лучник',NULL),
 (102,'arbalester.png',30,'u',28,'Арбалетчик',NULL),
 (103,'catapult.png',20,'u',29,'Катапульта',NULL);
/*!40000 ALTER TABLE `cards` ENABLE KEYS */;


--
-- Definition of table `cards_procedures`
--

DROP TABLE IF EXISTS `cards_procedures`;
CREATE TABLE `cards_procedures` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `card_id` int(10) unsigned NOT NULL,
  `procedure_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `cards_procedures_cards` (`card_id`),
  KEY `cards_procedures_procedures` (`procedure_id`),
  CONSTRAINT `cards_procedures_cards` FOREIGN KEY (`card_id`) REFERENCES `cards` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cards_procedures_procedures` FOREIGN KEY (`procedure_id`) REFERENCES `procedures` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=378 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `cards_procedures`
--

/*!40000 ALTER TABLE `cards_procedures` DISABLE KEYS */;
INSERT INTO `cards_procedures` (`id`,`card_id`,`procedure_id`) VALUES 
 (1,1,6),
 (2,2,6),
 (3,3,6),
 (4,4,6),
 (5,5,6),
 (6,6,6),
 (7,53,7),
 (8,54,8),
 (9,52,9),
 (10,7,10),
 (15,12,10),
 (19,16,10),
 (22,19,10),
 (24,21,10),
 (25,22,10),
 (26,23,10),
 (27,24,10),
 (28,25,10),
 (29,26,10),
 (30,27,11),
 (37,36,12),
 (38,36,13),
 (43,42,19),
 (44,49,22),
 (45,45,23),
 (46,32,24),
 (50,48,25),
 (51,39,26),
 (53,41,27),
 (54,47,28),
 (55,50,29),
 (56,51,30),
 (57,57,31),
 (58,56,32),
 (59,59,33),
 (60,59,34),
 (61,43,35),
 (62,44,36),
 (63,60,37),
 (64,58,38),
 (65,46,42),
 (66,55,51),
 (331,61,6),
 (332,62,6),
 (333,63,6),
 (334,64,6),
 (335,65,6),
 (336,66,6),
 (337,67,10),
 (338,68,10),
 (339,69,10),
 (340,70,10),
 (341,71,10),
 (342,72,10),
 (343,73,10),
 (344,74,10),
 (345,75,10),
 (346,76,10),
 (347,77,11),
 (348,78,24),
 (349,79,12),
 (350,79,13),
 (352,80,26),
 (353,81,27),
 (354,82,19),
 (355,83,35),
 (356,84,36),
 (357,85,23),
 (358,86,42),
 (359,87,28),
 (360,88,25),
 (361,89,22),
 (362,90,29),
 (363,91,30),
 (364,92,9),
 (365,93,7),
 (366,94,8),
 (367,95,51),
 (368,96,32),
 (369,97,31),
 (370,98,38),
 (371,99,33),
 (372,99,34),
 (374,100,37),
 (375,101,10),
 (376,102,10),
 (377,103,10);
/*!40000 ALTER TABLE `cards_procedures` ENABLE KEYS */;


--
-- Definition of table `deck`
--

DROP TABLE IF EXISTS `deck`;
CREATE TABLE `deck` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `game_id` int(10) unsigned NOT NULL,
  `card_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `deck`
--

/*!40000 ALTER TABLE `deck` DISABLE KEYS */;
/*!40000 ALTER TABLE `deck` ENABLE KEYS */;


--
-- Definition of table `dic_colors`
--

DROP TABLE IF EXISTS `dic_colors`;
CREATE TABLE `dic_colors` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(45) NOT NULL,
  `color` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `dic_colors`
--

/*!40000 ALTER TABLE `dic_colors` DISABLE KEYS */;
INSERT INTO `dic_colors` (`id`,`code`,`color`) VALUES 
 (1,'p0','#fcff00'),
 (2,'p1','#f000ff'),
 (3,'p2','#0006ff'),
 (4,'p3','#00e4ff'),
 (5,'magic','#000099'),
 (6,'event','#cc6600'),
 (7,'unit','#66cc33'),
 (8,'building','#993300'),
 (9,'chat_p0','#fcff00'),
 (10,'chat_p1','#f000ff'),
 (11,'chat_p2','#5c5ccf'),
 (12,'chat_p3','#00e4ff'),
 (13,'chat_spectator','#ffffff');
/*!40000 ALTER TABLE `dic_colors` ENABLE KEYS */;


--
-- Definition of table `dic_game_status`
--

DROP TABLE IF EXISTS `dic_game_status`;
CREATE TABLE `dic_game_status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `dic_game_status`
--

/*!40000 ALTER TABLE `dic_game_status` DISABLE KEYS */;
INSERT INTO `dic_game_status` (`id`,`description`) VALUES 
 (1,'created'),
 (2,'started'),
 (3,'finished');
/*!40000 ALTER TABLE `dic_game_status` ENABLE KEYS */;


--
-- Definition of table `dic_owner`
--

DROP TABLE IF EXISTS `dic_owner`;
CREATE TABLE `dic_owner` (
  `id` int(11) NOT NULL,
  `description` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `dic_owner`
--

/*!40000 ALTER TABLE `dic_owner` DISABLE KEYS */;
INSERT INTO `dic_owner` (`id`,`description`) VALUES 
 (0,'Spectator'),
 (1,'Человек'),
 (2,'Жабка'),
 (3,'Тролль'),
 (4,'Вампир');
/*!40000 ALTER TABLE `dic_owner` ENABLE KEYS */;


--
-- Definition of table `dic_statistic_measures`
--

DROP TABLE IF EXISTS `dic_statistic_measures`;
CREATE TABLE `dic_statistic_measures` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(100) NOT NULL,
  `count_rule` varchar(1000) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `dic_statistic_measures`
--

/*!40000 ALTER TABLE `dic_statistic_measures` DISABLE KEYS */;
INSERT INTO `dic_statistic_measures` (`id`,`description`,`count_rule`) VALUES 
 (1,'Заработал золота','SELECT IFNULL(SUM(sga.`value`),0) FROM statistic_game_actions sga WHERE sga.game_id=$g_id AND sga.player_num=$p_num AND sga.`action`=\'change_gold\' AND sga.`value`>0'),
 (2,'Потратил золота','SELECT IFNULL(ABS(SUM(sga.`value`)),0) FROM statistic_game_actions sga WHERE sga.game_id=$g_id AND sga.player_num=$p_num AND sga.`action`=\'change_gold\' AND sga.`value`<0'),
 (3,'Купил карт','SELECT COUNT(*) FROM statistic_game_actions sga WHERE sga.game_id=$g_id AND sga.player_num=$p_num AND sga.`action`=\'buy_card\''),
 (4,'Сыграл карт','SELECT COUNT(*) FROM statistic_game_actions sga WHERE sga.game_id=$g_id AND sga.player_num=$p_num AND sga.`action`=\'play_card\''),
 (5,'Сыграл магий','SELECT COUNT(*) FROM statistic_game_actions sga JOIN cards c ON (sga.`value`=c.id) WHERE sga.game_id=$g_id AND sga.player_num=$p_num AND sga.`action`=\'play_card\' AND c.`type`=\'m\''),
 (6,'Сыграл событий','SELECT COUNT(*) FROM statistic_game_actions sga JOIN cards c ON (sga.`value`=c.id) WHERE sga.game_id=$g_id AND sga.player_num=$p_num AND sga.`action`=\'play_card\' AND c.`type`=\'e\''),
 (7,'Сыграл юнитов','SELECT COUNT(*) FROM statistic_game_actions sga JOIN cards c ON (sga.`value`=c.id) WHERE sga.game_id=$g_id AND sga.player_num=$p_num AND sga.`action`=\'play_card\' AND c.`type`=\'u\''),
 (8,'Сыграл зданий','SELECT COUNT(*) FROM statistic_game_actions sga JOIN cards c ON (sga.`value`=c.id) WHERE sga.game_id=$g_id AND sga.player_num=$p_num AND sga.`action`=\'play_card\' AND c.`type`=\'b\''),
 (9,'Нанес урона','SELECT IFNULL(SUM(sga.`value`),0) FROM statistic_game_actions sga WHERE sga.game_id=$g_id AND sga.player_num=$p_num AND sga.`action`=\'make_damage\''),
 (10,'Атак юнитами','SELECT null FROM DUAL'),
 (11,'Атак магиями','SELECT null FROM DUAL'),
 (12,'Попаданий','SELECT null FROM DUAL'),
 (13,'Критических ударов','SELECT null FROM DUAL'),
 (14,'Убил юнитов','SELECT COUNT(*) FROM statistic_game_actions sga WHERE sga.game_id=$g_id AND sga.player_num=$p_num AND sga.`action`=\'kill_unit\''),
 (15,'Потерял юнитов','SELECT null FROM DUAL'),
 (16,'Разрушил зданий','SELECT COUNT(*) FROM statistic_game_actions sga WHERE sga.game_id=$g_id AND sga.player_num=$p_num AND sga.`action`=\'destroy_building\''),
 (17,'Потерял зданий','SELECT null FROM DUAL'),
 (18,'Процент попаданий','SELECT 1-IFNULL(((SELECT COUNT(*) FROM statistic_game_actions sga WHERE sga.game_id=$g_id AND sga.player_num=$p_num AND sga.`action`=\'miss_attack\')/(SELECT COUNT(*) FROM statistic_game_actions sga WHERE sga.game_id=$g_id AND sga.player_num=$p_num AND sga.`action` IN (\'unit_attack\',\'magical_attack\'))),1)'),
 (19,'Процент критических ударов','SELECT IFNULL((SELECT COUNT(*) FROM statistic_game_actions sga WHERE sga.game_id=$g_id AND sga.player_num=$p_num AND sga.`action`=\'critical_hit\')/(SELECT COUNT(*) FROM statistic_game_actions sga WHERE sga.game_id=$g_id AND sga.player_num=$p_num AND sga.`action`=\'unit_attack\'),0)'),
 (20,'Призвал юнитов','SELECT COUNT(*) FROM statistic_game_actions sga JOIN cards c ON (sga.`value`=c.id) WHERE sga.game_id=$g_id AND sga.player_num=$p_num AND (sga.`action`=\'play_card\' AND c.`type`=\'u\' OR sga.`action`=\'resurrect_unit\')'),
 (21,'Призвал зданий','SELECT COUNT(*) FROM statistic_game_actions sga JOIN cards c ON (sga.`value`=c.id) WHERE sga.game_id=$g_id AND sga.player_num=$p_num AND sga.`action`=\'play_card\' AND c.`type`=\'b\'');
/*!40000 ALTER TABLE `dic_statistic_measures` ENABLE KEYS */;


--
-- Definition of table `dic_unit_phrases`
--

DROP TABLE IF EXISTS `dic_unit_phrases`;
CREATE TABLE `dic_unit_phrases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `unit_id` int(10) unsigned NOT NULL,
  `phrase` varchar(1000) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `dic_unit_phrases_units` (`unit_id`),
  CONSTRAINT `dic_unit_phrases_units` FOREIGN KEY (`unit_id`) REFERENCES `units` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1550 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `dic_unit_phrases`
--

/*!40000 ALTER TABLE `dic_unit_phrases` DISABLE KEYS */;
INSERT INTO `dic_unit_phrases` (`id`,`unit_id`,`phrase`) VALUES 
 (1,1,'Зато мы самые дешевые!'),
 (2,1,'Зато нас больше'),
 (3,1,'У меня копье не того калибра'),
 (4,1,'Я тоже хотел стать Лордом, пока стрела не попала мне в колено'),
 (5,1,'И почему я завалил сессию в институте...'),
 (6,1,'Я должен быть на 20% круче!'),
 (7,1,'Даже тарану платят больше, чем мне'),
 (8,1,'Хорошо хоть не стройбат'),
 (9,1,'Когда уже можно будет сдаться?'),
 (10,1,'Скоро уже обед?'),
 (11,1,'Пора уже на копье новый прицел поставить'),
 (12,1,'Вернусь с войны - поступлю в консерваторию'),
 (13,1,'Плох тот копейщик, который не мечтает стать драконом!'),
 (14,1,'Плох тот копейщик, который не мечтает стать Лордом'),
 (15,1,'O, du lieber Augustin, Augustin, Augustin, O, du lieber Augustin, alles ist hin.'),
 (16,1,'Мне сказали, что если я дойду то того края доски, меня посвятят в рыцари и дадут коня'),
 (17,1,'Мне сказали, что если я дойду то того края доски, меня посвятят в дамки'),
 (18,1,'Примкнуть штыки!'),
 (19,1,'Когда нечего делать, я занимаюсь прыжками с копьем'),
 (20,1,'И когда уже световое копье изобретут?'),
 (21,1,'У меня есть копье.А чего добился ты?'),
 (22,1,'И какого копья я тут делаю?'),
 (23,1,'Ночью я натираю копьё до блеска'),
 (24,1,'Да одно мое копье стоит 10 золотых!'),
 (25,2,'Порыбачить бы в озере'),
 (26,2,'Кажется, где-то тут был трактир'),
 (27,2,'Чем выше в горы, тем толще тролли'),
 (28,2,'Стрела — дура, штык — молодец!'),
 (29,2,'My life for Aiur! Простите, вырвалось'),
 (30,2,'Тьфу, опять в драконью лепешку вступил'),
 (31,2,'Оки Доки Локи!'),
 (32,2,'Смотрите, тут кто-то недоел шашлык'),
 (33,2,'Сдать бы доспех на металлолом, купить дачу да выращивать картошку...'),
 (34,2,'Если бы я был Лордом, я бы построил тут трактир.'),
 (35,2,'Если бы я был Лордом, я бы построил тут баню.'),
 (36,3,'Где мой оруженосец? Я что сам это все таскать должен?'),
 (37,3,'Везет же некоторым!'),
 (38,3,'I am a cutie mark crusader'),
 (39,3,'За Кайзера!'),
 (40,3,'Убить принцессу, спасти дракона'),
 (41,3,'Коня пропил :('),
 (42,3,'Крест на моей броне - железный!'),
 (43,3,'Однажды сьел я огурца с молоком, а затем одел доспехи - чуть не утонул'),
 (44,3,'Да... в 43-ем и не такое было'),
 (45,3,'Убей с трех ударов'),
 (46,3,'ВДВ!!'),
 (47,3,'Я защитник слабых и обездоленных, карающий меч правосудия, несущий свет и добро в мир...дайте поесть, а?'),
 (48,3,'Маги постоянно говорят о каком-то 42, чтобы это значило?'),
 (49,3,'Мы воюем не за деньги, за идею! за дивный новый мир!'),
 (50,3,'Полцарства за коня!'),
 (51,3,'Плох тот рыцарь, который не мечтает стать конным рыцарем'),
 (52,4,'Слава подковам!'),
 (53,4,'Не смеши мои подковы'),
 (54,4,'Конный рыцарь - он почти как рыцарь. Только с конем'),
 (55,4,'И после смерти мне не обрести покой'),
 (56,4,'Эх, прокачусь!'),
 (57,4,'Когда турнир?'),
 (58,4,'Когда-нибудь я эволюционирую в танк'),
 (59,4,'В прошлой жизни у меня был конь'),
 (60,4,'Вчера затонировал коня и поставил литые копыта'),
 (61,4,'Только мы с конем, по полю идем...'),
 (62,4,'Только мы с конем по полю бежим (мага можно не считать)'),
 (63,4,'Товарищ инспектор, ну не заметил я светофора, и превысил скорость совсем чуть-чуть'),
 (64,4,'Сдам бока и круп лошади под рекламу'),
 (65,4,'Хочешь, прокачу?'),
 (66,4,'Жизнь - череда смертей и воскрешений'),
 (67,4,'Wann ich kumm, wann ich kumm. Wann ich wiedda, wiedda kumm!'),
 (68,7,'Иду на таран!'),
 (69,7,'Цепляюсь.Дорого'),
 (70,7,'Ты не смотри, что я дубовый...'),
 (71,7,'Учу плавать. Запись возле озера'),
 (72,7,'Нужно бооольше древесины'),
 (73,7,'Я тоже хотел бы стать искателем приключений, если бы у меня были колени'),
 (74,7,'Буратино вырос, буратино возмужал'),
 (75,7,'Я хочу быть настоящим мальчиком'),
 (76,7,'Скрип-скрип'),
 (77,5,'Бонд. Джеймс Бонд'),
 (78,5,'Дзя. Нин Дзя'),
 (79,5,'???????'),
 (80,5,'Видишь ниндзю? и я не вижу, а он есть'),
 (81,5,'Это Я украл твой сладкий рулет'),
 (82,5,'Воруй, убивай'),
 (83,5,'Прихожу в трактир, а он не работает. И так каждый раз!'),
 (84,5,'Они зовут меня \"Борис хрен попадешь\"'),
 (85,5,'Думаешь, мои услуги тебе по-карману?'),
 (86,5,'Ага, так вот где ты хранишь золото...'),
 (87,5,'Кладбища забиты дураками, которые полагаются на доспехи и большие мечи'),
 (88,5,'Люк, я - твой отец'),
 (89,5,'Таран, я - твой отец'),
 (90,5,'Я на 20% круче Джеки Чана'),
 (91,5,'Почему всегда, когда я подхожу к трактиру, там закрыто?'),
 (92,8,'Дружба - это магия'),
 (93,8,'Эх, щас колдону!'),
 (94,8,'Я всегда ношу с собой револьвер. На всякий случай'),
 (95,8,'Думаешь, ты умнее меня?'),
 (96,8,'Еще полгода, и я буду командовать тобой'),
 (97,8,'Еще несколько повышений, и я буду командовать тобой'),
 (98,8,'Я из древнего и уважаемого рода, а ты еще кто такой?'),
 (99,8,'Ай, опять руку об фаербол обжег'),
 (100,8,'Кастую C2H5OH на всех'),
 (101,8,'Это заклинание запатентовано'),
 (102,8,'Все надоело, хочу в отпуск'),
 (103,8,'Оставьте свою Аваду-Кедавру при себе!'),
 (104,8,'У меня дядя - Гарри Поттер!'),
 (105,9,'Я не гот!'),
 (106,9,'Я не гот, просто не выспался!'),
 (107,9,'Ты говоришь я Демон? Так и есть'),
 (108,9,'Я требую сатанинские похороны!'),
 (109,9,'Воскрешу таран и завоюю мир'),
 (110,9,'Воскрешал таран - все руки в мозолях'),
 (111,9,'Отвороты, порчи, проклятия недорого'),
 (112,9,'Зомби совсем уже обнаглели, организовали свой профсоюз'),
 (113,9,'Просто у меня было тяжелое детство'),
 (114,9,'Кто хочет печенек?'),
 (115,9,'Вообще-то я пишу стихи, но кого это интересует..'),
 (116,9,'Кого бы воскресить?'),
 (117,9,'Не кочегары мы, не плотники... Мы воскрешаем каждый день! А мы могильников работники! Да воцариться тьма везде!!!'),
 (118,6,'Мир, братья!'),
 (119,6,'Хоть голова моя пуста...'),
 (120,6,'Мне приснилось, что я бабочка'),
 (121,6,'Много форм я сменил, пока не обрел свободу'),
 (122,6,'Я был рогами оленя и юго-западным ветром'),
 (123,6,'Стой! Куда идешь?'),
 (124,6,'Я работаю в библиотеке...'),
 (125,6,'Монахи, цемента мне на лечение!'),
 (126,6,'Ненавижу строителей, из моего брата сделали сарай'),
 (127,6,'Иногда так хочется чуда!'),
 (128,6,'Там, где копейщик не пройдет и конный рыцарь не промчится...'),
 (129,6,'Поспешишь - людей насмешишь'),
 (130,6,'Когда-то из меня рос укроп'),
 (131,6,'Люблю смотреть на дождь. Особенно метеоритный'),
 (132,6,'Таран, я - твой отец'),
 (133,6,'Я хочу жить в мире без войн и зла, но кого это интересует'),
 (134,10,'Кто просил шашлычок?'),
 (135,10,'Вы меня полюбите!'),
 (136,10,'Дяденьки, не бейте!'),
 (137,10,'Что-то горит?'),
 (138,10,'Прикурить не найдется?'),
 (139,10,'Есть че?'),
 (140,10,'Я тучка-тучка-тучка, а вовсе не Дракон'),
 (141,10,'Есть что-нибудь от изжоги?'),
 (142,10,'Дракон с хвостом похож на дракона без хвоста, но с хвостом'),
 (143,10,'О! а вот и завтрак'),
 (144,10,'Кажется, у меня опять температура'),
 (145,10,'С тобой все в порядке, сахарок?'),
 (146,10,'Давайте играть в квача'),
 (147,10,'Не люблю овсяную кашу и рыцарей'),
 (148,10,'Хорошо, что пулеметов еще не изобрели'),
 (149,10,'Магнитные бури на солнце. Слыхали?'),
 (150,11,'Вы у меня ещё поквакаете!'),
 (151,11,'Поцелуй меня, и я превращусь в рыцаря'),
 (152,11,'Да-да, говорящая жаба'),
 (153,11,'Ква!'),
 (154,11,'Убить дракона? вы серьезно?'),
 (155,11,'Жизнь - жестокая вещь'),
 (156,11,'И почему я не дракон?'),
 (157,11,'Почему меня никто не любит?'),
 (158,11,'Кабы я была драконом...'),
 (159,11,'Попробуй поймай!'),
 (160,11,'You shall not pass'),
 (161,12,'Лучше гор могут быть только горы'),
 (162,12,'/facepalm'),
 (163,12,'/faceclub'),
 (164,12,'Не кормите тролля'),
 (165,12,'Покормите тролля'),
 (166,12,'Где тут у вас мост?'),
 (167,12,'Я только посмотреть, пропустите, пожалуйста'),
 (168,12,'Моя голова большой и умный, а еще я туда ем'),
 (169,12,'Агась!'),
 (170,12,'Ну ладно, здания сами себя не развалят'),
 (171,12,'Люблю архитектуру'),
 (172,13,'Хватит уже пить вино'),
 (173,13,'Мммм... человечинка в собственной крови! А что? Вкуснецки!'),
 (174,13,'Мечтаю побриться'),
 (175,13,'Пункт приема донорской крови'),
 (176,13,'Осторожно, я кусаюсь'),
 (177,13,'Я тоже в вампиров раньше не верил...'),
 (178,13,'Ненавижу комаров'),
 (179,13,'От вида крови падаю в обморок'),
 (180,13,'Ай, порезался!!'),
 (181,13,'Вы думаете, это земляничный сок?'),
 (182,13,'Не бойся, как комарик укусит, и все'),
 (1279,14,'Зато мы самые дешевые!'),
 (1280,14,'Зато нас больше'),
 (1281,14,'У меня копье не того калибра'),
 (1282,14,'Я тоже хотел стать Лордом, пока стрела не попала мне в колено'),
 (1283,14,'И почему я завалил сессию в институте...'),
 (1284,14,'Я должен быть на 20% круче!'),
 (1285,14,'Даже тарану платят больше, чем мне'),
 (1286,14,'Хорошо хоть не стройбат'),
 (1287,14,'Когда уже можно будет сдаться?'),
 (1288,14,'Скоро уже обед?'),
 (1289,14,'Пора уже на копье новый прицел поставить'),
 (1290,14,'Вернусь с войны - поступлю в консерваторию'),
 (1291,14,'Плох тот копейщик, который не мечтает стать драконом!'),
 (1292,14,'Плох тот копейщик, который не мечтает стать Лордом'),
 (1293,14,'O, du lieber Augustin, Augustin, Augustin, O, du lieber Augustin, alles ist hin.'),
 (1294,14,'Мне сказали, что если я дойду то того края доски, меня посвятят в рыцари и дадут коня'),
 (1295,14,'Мне сказали, что если я дойду то того края доски, меня посвятят в дамки'),
 (1296,14,'Примкнуть штыки!'),
 (1297,14,'Когда нечего делать, я занимаюсь прыжками с копьем'),
 (1298,14,'И когда уже световое копье изобретут?'),
 (1299,14,'У меня есть копье.А чего добился ты?'),
 (1300,14,'И какого копья я тут делаю?'),
 (1301,14,'Ночью я натираю копьё до блеска'),
 (1302,14,'Да одно мое копье стоит 10 золотых!'),
 (1310,15,'Порыбачить бы в озере'),
 (1311,15,'Кажется, где-то тут был трактир'),
 (1312,15,'Чем выше в горы, тем толще тролли'),
 (1313,15,'Стрела — дура, штык — молодец!'),
 (1314,15,'My life for Aiur! Простите, вырвалось'),
 (1315,15,'Тьфу, опять в драконью лепешку вступил'),
 (1316,15,'Оки Доки Локи!'),
 (1317,15,'Смотрите, тут кто-то недоел шашлык'),
 (1318,15,'Сдать бы доспех на металлолом, купить дачу да выращивать картошку...'),
 (1319,15,'Если бы я был Лордом, я бы построил тут трактир.'),
 (1320,15,'Если бы я был Лордом, я бы построил тут баню.'),
 (1325,16,'Где мой оруженосец? Я что сам это все таскать должен?'),
 (1326,16,'Везет же некоторым!'),
 (1327,16,'I am a cutie mark crusader'),
 (1328,16,'За Кайзера!'),
 (1329,16,'Убить принцессу, спасти дракона'),
 (1330,16,'Коня пропил :('),
 (1331,16,'Крест на моей броне - железный!'),
 (1332,16,'Однажды сьел я огурца с молоком, а затем одел доспехи - чуть не утонул'),
 (1333,16,'Да... в 43-ем и не такое было'),
 (1334,16,'Убей с трех ударов'),
 (1335,16,'ВДВ!!'),
 (1336,16,'Я защитник слабых и обездоленных, карающий меч правосудия, несущий свет и добро в мир...дайте поесть, а?'),
 (1337,16,'Маги постоянно говорят о каком-то 42, чтобы это значило?'),
 (1338,16,'Мы воюем не за деньги, за идею! за дивный новый мир!'),
 (1339,16,'Полцарства за коня!'),
 (1340,16,'Плох тот рыцарь, который не мечтает стать конным рыцарем'),
 (1356,17,'Слава подковам!'),
 (1357,17,'Не смеши мои подковы'),
 (1358,17,'Конный рыцарь - он почти как рыцарь. Только с конем'),
 (1359,17,'И после смерти мне не обрести покой'),
 (1360,17,'Эх, прокачусь!'),
 (1361,17,'Когда турнир?'),
 (1362,17,'Когда-нибудь я эволюционирую в танк'),
 (1363,17,'В прошлой жизни у меня был конь'),
 (1364,17,'Вчера затонировал коня и поставил литые копыта'),
 (1365,17,'Только мы с конем, по полю идем...'),
 (1366,17,'Только мы с конем по полю бежим (мага можно не считать)'),
 (1367,17,'Товарищ инспектор, ну не заметил я светофора, и превысил скорость совсем чуть-чуть'),
 (1368,17,'Сдам бока и круп лошади под рекламу'),
 (1369,17,'Хочешь, прокачу?'),
 (1370,17,'Жизнь - череда смертей и воскрешений'),
 (1371,17,'Wann ich kumm, wann ich kumm. Wann ich wiedda, wiedda kumm!'),
 (1387,18,'Бонд. Джеймс Бонд'),
 (1388,18,'Дзя. Нин Дзя'),
 (1389,18,'???????'),
 (1390,18,'Видишь ниндзю? и я не вижу, а он есть'),
 (1391,18,'Это Я украл твой сладкий рулет'),
 (1392,18,'Воруй, убивай'),
 (1393,18,'Прихожу в трактир, а он не работает. И так каждый раз!'),
 (1394,18,'Они зовут меня \"Борис хрен попадешь\"'),
 (1395,18,'Думаешь, мои услуги тебе по-карману?'),
 (1396,18,'Ага, так вот где ты хранишь золото...'),
 (1397,18,'Кладбища забиты дураками, которые полагаются на доспехи и большие мечи'),
 (1398,18,'Люк, я - твой отец'),
 (1399,18,'Таран, я - твой отец'),
 (1400,18,'Я на 20% круче Джеки Чана'),
 (1401,18,'Почему всегда, когда я подхожу к трактиру, там закрыто?'),
 (1402,19,'Мир, братья!'),
 (1403,19,'Хоть голова моя пуста...'),
 (1404,19,'Мне приснилось, что я бабочка'),
 (1405,19,'Много форм я сменил, пока не обрел свободу'),
 (1406,19,'Я был рогами оленя и юго-западным ветром'),
 (1407,19,'Стой! Куда идешь?'),
 (1408,19,'Я работаю в библиотеке...'),
 (1409,19,'Монахи, цемента мне на лечение!'),
 (1410,19,'Ненавижу строителей, из моего брата сделали сарай'),
 (1411,19,'Иногда так хочется чуда!'),
 (1412,19,'Там, где копейщик не пройдет и конный рыцарь не промчится...'),
 (1413,19,'Поспешишь - людей насмешишь'),
 (1414,19,'Когда-то из меня рос укроп'),
 (1415,19,'Люблю смотреть на дождь. Особенно метеоритный'),
 (1416,19,'Таран, я - твой отец'),
 (1417,19,'Я хочу жить в мире без войн и зла, но кого это интересует'),
 (1433,20,'Иду на таран!'),
 (1434,20,'Цепляюсь.Дорого'),
 (1435,20,'Ты не смотри, что я дубовый...'),
 (1436,20,'Учу плавать. Запись возле озера'),
 (1437,20,'Нужно бооольше древесины'),
 (1438,20,'Я тоже хотел бы стать искателем приключений, если бы у меня были колени'),
 (1439,20,'Буратино вырос, буратино возмужал'),
 (1440,20,'Я хочу быть настоящим мальчиком'),
 (1441,20,'Скрип-скрип'),
 (1448,21,'Дружба - это магия'),
 (1449,21,'Эх, щас колдону!'),
 (1450,21,'Я всегда ношу с собой револьвер. На всякий случай'),
 (1451,21,'Думаешь, ты умнее меня?'),
 (1452,21,'Еще полгода, и я буду командовать тобой'),
 (1453,21,'Еще несколько повышений, и я буду командовать тобой'),
 (1454,21,'Я из древнего и уважаемого рода, а ты еще кто такой?'),
 (1455,21,'Ай, опять руку об фаербол обжег'),
 (1456,21,'Кастую C2H5OH на всех'),
 (1457,21,'Это заклинание запатентовано'),
 (1458,21,'Все надоело, хочу в отпуск'),
 (1459,21,'Оставьте свою Аваду-Кедавру при себе!'),
 (1460,21,'У меня дядя - Гарри Поттер!'),
 (1463,22,'Я не гот!'),
 (1464,22,'Я не гот, просто не выспался!'),
 (1465,22,'Ты говоришь я Демон? Так и есть'),
 (1466,22,'Я требую сатанинские похороны!'),
 (1467,22,'Воскрешу таран и завоюю мир'),
 (1468,22,'Воскрешал таран - все руки в мозолях'),
 (1469,22,'Отвороты, порчи, проклятия недорого'),
 (1470,22,'Зомби совсем уже обнаглели, организовали свой профсоюз'),
 (1471,22,'Просто у меня было тяжелое детство'),
 (1472,22,'Кто хочет печенек?'),
 (1473,22,'Вообще-то я пишу стихи, но кого это интересует..'),
 (1474,22,'Кого бы воскресить?'),
 (1475,22,'Не кочегары мы, не плотники... Мы воскрешаем каждый день! А мы могильников работники! Да воцариться тьма везде!!!'),
 (1478,23,'Кто просил шашлычок?'),
 (1479,23,'Вы меня полюбите!'),
 (1480,23,'Дяденьки, не бейте!'),
 (1481,23,'Что-то горит?'),
 (1482,23,'Прикурить не найдется?'),
 (1483,23,'Есть че?'),
 (1484,23,'Я тучка-тучка-тучка, а вовсе не Дракон'),
 (1485,23,'Есть что-нибудь от изжоги?'),
 (1486,23,'Дракон с хвостом похож на дракона без хвоста, но с хвостом'),
 (1487,23,'О! а вот и завтрак'),
 (1488,23,'Кажется, у меня опять температура'),
 (1489,23,'С тобой все в порядке, сахарок?'),
 (1490,23,'Давайте играть в квача'),
 (1491,23,'Не люблю овсяную кашу и рыцарей'),
 (1492,23,'Хорошо, что пулеметов еще не изобрели'),
 (1493,23,'Магнитные бури на солнце. Слыхали?'),
 (1509,24,'Вы у меня ещё поквакаете!'),
 (1510,24,'Поцелуй меня, и я превращусь в рыцаря'),
 (1511,24,'Да-да, говорящая жаба'),
 (1512,24,'Ква!'),
 (1513,24,'Убить дракона? вы серьезно?'),
 (1514,24,'Жизнь - жестокая вещь'),
 (1515,24,'И почему я не дракон?'),
 (1516,24,'Почему меня никто не любит?'),
 (1517,24,'Кабы я была драконом...'),
 (1518,24,'Попробуй поймай!'),
 (1519,24,'You shall not pass'),
 (1524,25,'Лучше гор могут быть только горы'),
 (1525,25,'/facepalm'),
 (1526,25,'/faceclub'),
 (1527,25,'Не кормите тролля'),
 (1528,25,'Покормите тролля'),
 (1529,25,'Где тут у вас мост?'),
 (1530,25,'Я только посмотреть, пропустите, пожалуйста'),
 (1531,25,'Моя голова большой и умный, а еще я туда ем'),
 (1532,25,'Агась!'),
 (1533,25,'Ну ладно, здания сами себя не развалят'),
 (1534,25,'Люблю архитектуру'),
 (1539,26,'Хватит уже пить вино'),
 (1540,26,'Мммм... человечинка в собственной крови! А что? Вкуснецки!'),
 (1541,26,'Мечтаю побриться'),
 (1542,26,'Пункт приема донорской крови'),
 (1543,26,'Осторожно, я кусаюсь'),
 (1544,26,'Я тоже в вампиров раньше не верил...'),
 (1545,26,'Ненавижу комаров'),
 (1546,26,'От вида крови падаю в обморок'),
 (1547,26,'Ай, порезался!!'),
 (1548,26,'Вы думаете, это земляничный сок?'),
 (1549,26,'Не бойся, как комарик укусит, и все');
/*!40000 ALTER TABLE `dic_unit_phrases` ENABLE KEYS */;


--
-- Definition of table `error_dictionary`
--

DROP TABLE IF EXISTS `error_dictionary`;
CREATE TABLE `error_dictionary` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(200) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `error_dictionary`
--

/*!40000 ALTER TABLE `error_dictionary` DISABLE KEYS */;
INSERT INTO `error_dictionary` (`id`,`description`) VALUES 
 (1,'Не ваш ход'),
 (2,'Недостаточно золота'),
 (3,'Карт больше нет'),
 (4,'Неправильная сумма'),
 (5,'Вы уже взяли субсидию в этом ходу'),
 (6,'Недостаточно хитов замка'),
 (7,'Вы уже начали ходить юнитами'),
 (8,'Нет такого мертвого юнита'),
 (9,'Место появления занято'),
 (10,'У вас нет такой карты'),
 (11,'Здание выходит за рамки вашей зоны'),
 (12,'Место занято'),
 (13,'Нет такого игрока'),
 (14,'Юнит не выбран'),
 (15,'Этой картой нельзя этого сделать :-P'),
 (16,'Выбран чужой юнит'),
 (17,'У юнита не осталось ходов'),
 (18,'Юнит парализован'),
 (19,'На эту клетку нельзя походить'),
 (20,'Эту клетку нельзя атаковать'),
 (21,'Здесь нечего атаковать'),
 (22,'У этого игрока нет карт'),
 (23,'Цель не может выходить за карту'),
 (24,'Нельзя доиграть пользу/вред'),
 (25,'Неправильная зона'),
 (26,'Здание не выбрано'),
 (27,'Нужно выбрать чужое здание'),
 (28,'Нужно доиграть пользу/вред'),
 (29,'Цель вне досягаемости'),
 (30,'Юнит это не умеет :-P'),
 (31,'Можно прицепить таран только к другому юниту'),
 (32,'Можно лечить только другого юнита'),
 (33,'Можно пустить огненный шар только в другого юнита'),
 (34,'Могила вне досягаемости'),
 (35,'Можно призвать вампира только в своей зоне'),
 (36,'Вы хотите отправить деньги себе. Они уже тут'),
 (37,'Жертва не выбрана'),
 (38,'Можно принести в жертву только своего юнита'),
 (39,'Цель для жертвоприношения не выбрана'),
 (40,'Нужно выбрать юнита в качестве цели');
/*!40000 ALTER TABLE `error_dictionary` ENABLE KEYS */;


--
-- Definition of table `games`
--

DROP TABLE IF EXISTS `games`;
CREATE TABLE `games` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(45) NOT NULL,
  `pass` varchar(45) DEFAULT NULL,
  `owner_id` int(10) unsigned NOT NULL,
  `time_restriction` int(10) unsigned NOT NULL DEFAULT '0',
  `status_id` int(10) unsigned NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `mode_id` int(10) unsigned NOT NULL,
  `type_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `games`
--

/*!40000 ALTER TABLE `games` DISABLE KEYS */;
/*!40000 ALTER TABLE `games` ENABLE KEYS */;


--
-- Definition of table `games_features`
--

DROP TABLE IF EXISTS `games_features`;
CREATE TABLE `games_features` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(45) NOT NULL,
  `name` varchar(45) NOT NULL,
  `default_param` int(11) NOT NULL,
  `feature_type` enum('bool','int') NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `games_features`
--

/*!40000 ALTER TABLE `games_features` DISABLE KEYS */;
INSERT INTO `games_features` (`id`,`code`,`name`,`default_param`,`feature_type`) VALUES 
 (1,'random_teams','Случайные союзы',0,'bool'),
 (2,'all_versus_all','Каждый сам за себя',0,'bool'),
 (3,'number_of_teams','Количество команд',2,'int'),
 (4,'teammates_in_random_castles','Союзники не напротив, а случайным образом',0,'bool');
/*!40000 ALTER TABLE `games_features` ENABLE KEYS */;


--
-- Definition of table `games_features_usage`
--

DROP TABLE IF EXISTS `games_features_usage`;
CREATE TABLE `games_features_usage` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `game_id` int(10) unsigned NOT NULL,
  `feature_id` int(10) unsigned NOT NULL,
  `param` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `games_features_usage`
--

/*!40000 ALTER TABLE `games_features_usage` DISABLE KEYS */;
/*!40000 ALTER TABLE `games_features_usage` ENABLE KEYS */;


--
-- Definition of table `grave_cells`
--

DROP TABLE IF EXISTS `grave_cells`;
CREATE TABLE `grave_cells` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `grave_id` int(10) unsigned NOT NULL,
  `x` int(11) NOT NULL,
  `y` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `grave_cells_graves` (`grave_id`),
  CONSTRAINT `grave_cells_graves` FOREIGN KEY (`grave_id`) REFERENCES `graves` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `grave_cells`
--

/*!40000 ALTER TABLE `grave_cells` DISABLE KEYS */;
/*!40000 ALTER TABLE `grave_cells` ENABLE KEYS */;


--
-- Definition of table `graves`
--

DROP TABLE IF EXISTS `graves`;
CREATE TABLE `graves` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `game_id` int(10) unsigned NOT NULL,
  `card_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `graves_games` (`game_id`),
  KEY `graves_cards` (`card_id`),
  CONSTRAINT `graves_cards` FOREIGN KEY (`card_id`) REFERENCES `cards` (`id`) ON DELETE CASCADE,
  CONSTRAINT `graves_games` FOREIGN KEY (`game_id`) REFERENCES `games` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `graves`
--

/*!40000 ALTER TABLE `graves` DISABLE KEYS */;
/*!40000 ALTER TABLE `graves` ENABLE KEYS */;


--
-- Definition of table `log_commands`
--

DROP TABLE IF EXISTS `log_commands`;
CREATE TABLE `log_commands` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `game_id` int(10) unsigned NOT NULL,
  `player_num` int(10) unsigned NOT NULL DEFAULT '0',
  `command` varchar(1000) NOT NULL,
  `hidden_flag` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `log_commands`
--

/*!40000 ALTER TABLE `log_commands` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_commands` ENABLE KEYS */;


--
-- Definition of table `mode_config`
--

DROP TABLE IF EXISTS `mode_config`;
CREATE TABLE `mode_config` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `param` varchar(45) NOT NULL,
  `value` varchar(45) NOT NULL,
  `mode_id` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `mode_config_modes` (`mode_id`),
  CONSTRAINT `mode_config_modes` FOREIGN KEY (`mode_id`) REFERENCES `modes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=114 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `mode_config`
--

/*!40000 ALTER TABLE `mode_config` DISABLE KEYS */;
INSERT INTO `mode_config` (`id`,`param`,`value`,`mode_id`) VALUES 
 (10,'unit income','2',1),
 (11,'building income','1',1),
 (14,'card cost','15',1),
 (15,'subsidy amount','15',1),
 (16,'subsidy castle damage','1',1),
 (17,'resurrection cost coefficient','2',1),
 (18,'frog count','3',1),
 (19,'troll count','1',1),
 (20,'castle hit reward','10',1),
 (105,'unit income','2',8),
 (106,'building income','1',8),
 (107,'card cost','10',8),
 (108,'subsidy amount','15',8),
 (109,'subsidy castle damage','1',8),
 (110,'resurrection cost coefficient','2',8),
 (111,'frog count','3',8),
 (112,'troll count','1',8),
 (113,'castle hit reward','10',8);
/*!40000 ALTER TABLE `mode_config` ENABLE KEYS */;


--
-- Definition of table `modes`
--

DROP TABLE IF EXISTS `modes`;
CREATE TABLE `modes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `min_players` int(10) unsigned NOT NULL,
  `max_players` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `modes`
--

/*!40000 ALTER TABLE `modes` DISABLE KEYS */;
INSERT INTO `modes` (`id`,`name`,`min_players`,`max_players`) VALUES 
 (1,'Lords Classic',2,4),
 (8,'Lords Steam Pack',2,4);
/*!40000 ALTER TABLE `modes` ENABLE KEYS */;


--
-- Definition of table `modes_cardless_buildings`
--

DROP TABLE IF EXISTS `modes_cardless_buildings`;
CREATE TABLE `modes_cardless_buildings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `mode_id` int(10) unsigned NOT NULL,
  `building_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `modes_cardless_buildings_modes` (`mode_id`),
  KEY `modes_cardless_buildings_buildings` (`building_id`),
  CONSTRAINT `modes_cardless_buildings_buildings` FOREIGN KEY (`building_id`) REFERENCES `buildings` (`id`) ON DELETE CASCADE,
  CONSTRAINT `modes_cardless_buildings_modes` FOREIGN KEY (`mode_id`) REFERENCES `modes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `modes_cardless_buildings`
--

/*!40000 ALTER TABLE `modes_cardless_buildings` DISABLE KEYS */;
INSERT INTO `modes_cardless_buildings` (`id`,`mode_id`,`building_id`) VALUES 
 (1,1,7),
 (2,1,8),
 (13,8,15),
 (14,8,16);
/*!40000 ALTER TABLE `modes_cardless_buildings` ENABLE KEYS */;


--
-- Definition of table `modes_cardless_units`
--

DROP TABLE IF EXISTS `modes_cardless_units`;
CREATE TABLE `modes_cardless_units` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `mode_id` int(10) unsigned NOT NULL,
  `unit_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `modes_cardless_units_modes` (`mode_id`),
  KEY `modes_cardless_units_units` (`unit_id`),
  CONSTRAINT `modes_cardless_units_modes` FOREIGN KEY (`mode_id`) REFERENCES `modes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `modes_cardless_units_units` FOREIGN KEY (`unit_id`) REFERENCES `units` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `modes_cardless_units`
--

/*!40000 ALTER TABLE `modes_cardless_units` DISABLE KEYS */;
INSERT INTO `modes_cardless_units` (`id`,`mode_id`,`unit_id`) VALUES 
 (1,1,11),
 (2,1,12),
 (3,1,13),
 (16,8,24),
 (17,8,25),
 (18,8,26);
/*!40000 ALTER TABLE `modes_cardless_units` ENABLE KEYS */;


--
-- Definition of table `modes_cards`
--

DROP TABLE IF EXISTS `modes_cards`;
CREATE TABLE `modes_cards` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `mode_id` int(10) unsigned NOT NULL,
  `card_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `modes_cards_modes` (`mode_id`),
  KEY `modes_cards_cards` (`card_id`),
  CONSTRAINT `modes_cards_cards` FOREIGN KEY (`card_id`) REFERENCES `cards` (`id`) ON DELETE CASCADE,
  CONSTRAINT `modes_cards_modes` FOREIGN KEY (`mode_id`) REFERENCES `modes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=571 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `modes_cards`
--

/*!40000 ALTER TABLE `modes_cards` DISABLE KEYS */;
INSERT INTO `modes_cards` (`id`,`mode_id`,`card_id`) VALUES 
 (1,1,1),
 (2,1,2),
 (3,1,3),
 (4,1,4),
 (5,1,5),
 (6,1,6),
 (7,1,7),
 (8,1,7),
 (9,1,7),
 (10,1,7),
 (11,1,7),
 (12,1,12),
 (13,1,12),
 (14,1,12),
 (15,1,12),
 (16,1,16),
 (17,1,16),
 (18,1,16),
 (19,1,19),
 (20,1,19),
 (21,1,21),
 (22,1,22),
 (23,1,23),
 (24,1,24),
 (25,1,25),
 (26,1,26),
 (27,1,27),
 (28,1,27),
 (29,1,27),
 (30,1,27),
 (31,1,27),
 (32,1,32),
 (33,1,32),
 (34,1,32),
 (35,1,32),
 (36,1,36),
 (37,1,36),
 (38,1,36),
 (39,1,39),
 (40,1,39),
 (41,1,41),
 (42,1,42),
 (43,1,43),
 (44,1,44),
 (45,1,45),
 (46,1,46),
 (47,1,47),
 (48,1,48),
 (49,1,49),
 (50,1,50),
 (51,1,51),
 (52,1,52),
 (53,1,53),
 (54,1,54),
 (55,1,55),
 (56,1,56),
 (57,1,57),
 (58,1,58),
 (59,1,59),
 (60,1,60),
 (493,8,61),
 (494,8,62),
 (495,8,63),
 (496,8,64),
 (497,8,65),
 (498,8,66),
 (499,8,67),
 (500,8,67),
 (501,8,67),
 (502,8,67),
 (503,8,67),
 (506,8,68),
 (507,8,68),
 (508,8,68),
 (509,8,68),
 (513,8,69),
 (514,8,69),
 (515,8,69),
 (516,8,70),
 (517,8,70),
 (519,8,71),
 (520,8,72),
 (521,8,73),
 (522,8,74),
 (523,8,75),
 (524,8,76),
 (525,8,77),
 (526,8,77),
 (527,8,77),
 (528,8,77),
 (529,8,77),
 (532,8,78),
 (533,8,78),
 (534,8,78),
 (535,8,78),
 (539,8,79),
 (540,8,79),
 (541,8,79),
 (542,8,80),
 (543,8,80),
 (545,8,81),
 (546,8,82),
 (547,8,83),
 (548,8,84),
 (549,8,85),
 (550,8,86),
 (551,8,87),
 (552,8,88),
 (553,8,89),
 (554,8,90),
 (555,8,91),
 (556,8,92),
 (557,8,93),
 (558,8,94),
 (559,8,95),
 (560,8,96),
 (561,8,97),
 (562,8,98),
 (563,8,99),
 (564,8,100),
 (565,8,101),
 (566,8,101),
 (567,8,101),
 (568,8,102),
 (569,8,102),
 (570,8,103);
/*!40000 ALTER TABLE `modes_cards` ENABLE KEYS */;


--
-- Definition of table `modes_other_procedures`
--

DROP TABLE IF EXISTS `modes_other_procedures`;
CREATE TABLE `modes_other_procedures` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `mode_id` int(10) unsigned NOT NULL,
  `procedure_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `modes_other_procedures_modes` (`mode_id`),
  KEY `modes_other_procedures_procedures` (`procedure_id`),
  CONSTRAINT `modes_other_procedures_modes` FOREIGN KEY (`mode_id`) REFERENCES `modes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `modes_other_procedures_procedures` FOREIGN KEY (`procedure_id`) REFERENCES `procedures` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=269 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `modes_other_procedures`
--

/*!40000 ALTER TABLE `modes_other_procedures` DISABLE KEYS */;
INSERT INTO `modes_other_procedures` (`id`,`mode_id`,`procedure_id`) VALUES 
 (1,1,1),
 (2,1,2),
 (3,1,3),
 (4,1,4),
 (5,1,5),
 (6,1,16),
 (7,1,17),
 (8,1,18),
 (9,1,20),
 (10,1,21),
 (11,1,39),
 (12,1,40),
 (13,1,41),
 (14,1,43),
 (15,1,44),
 (16,1,45),
 (17,1,46),
 (252,8,1),
 (253,8,2),
 (254,8,3),
 (255,8,4),
 (256,8,5),
 (257,8,16),
 (258,8,17),
 (259,8,18),
 (260,8,20),
 (261,8,21),
 (262,8,39),
 (263,8,40),
 (264,8,41),
 (265,8,43),
 (266,8,44),
 (267,8,45),
 (268,8,46);
/*!40000 ALTER TABLE `modes_other_procedures` ENABLE KEYS */;


--
-- Definition of table `nonfinished_actions_dictionary`
--

DROP TABLE IF EXISTS `nonfinished_actions_dictionary`;
CREATE TABLE `nonfinished_actions_dictionary` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `description` varchar(200) NOT NULL,
  `command_procedure` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `nonfinished_actions_dictionary`
--

/*!40000 ALTER TABLE `nonfinished_actions_dictionary` DISABLE KEYS */;
INSERT INTO `nonfinished_actions_dictionary` (`id`,`description`,`command_procedure`) VALUES 
 (1,'Польза - воскресить юнита','cast_polza_resurrect'),
 (2,'Польза - юнитов из любой зоны','cast_polza_units_from_zone'),
 (3,'Польза - переместить и присвоить здание','cast_polza_move_building'),
 (4,'Вред - -60 любому игроку','cast_vred_pooring'),
 (5,'Вред - убить любого юнита','cast_vred_kill_unit'),
 (6,'Вред - разрушить любое здание','cast_vred_destroy_building'),
 (7,'Вред - переместить чужое здание','cast_vred_move_building');
/*!40000 ALTER TABLE `nonfinished_actions_dictionary` ENABLE KEYS */;


--
-- Definition of table `player_deck`
--

DROP TABLE IF EXISTS `player_deck`;
CREATE TABLE `player_deck` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `game_id` int(10) unsigned NOT NULL,
  `player_num` int(10) unsigned NOT NULL DEFAULT '0',
  `card_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `player_deck`
--

/*!40000 ALTER TABLE `player_deck` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_deck` ENABLE KEYS */;


--
-- Definition of table `player_features`
--

DROP TABLE IF EXISTS `player_features`;
CREATE TABLE `player_features` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(45) NOT NULL,
  `name` varchar(45) NOT NULL,
  `default_param` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `player_features`
--

/*!40000 ALTER TABLE `player_features` DISABLE KEYS */;
INSERT INTO `player_features` (`id`,`code`,`name`,`default_param`) VALUES 
 (1,'end_turn','Игрок пропустил ход',NULL);
/*!40000 ALTER TABLE `player_features` ENABLE KEYS */;


--
-- Definition of table `player_features_usage`
--

DROP TABLE IF EXISTS `player_features_usage`;
CREATE TABLE `player_features_usage` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `game_id` int(10) unsigned NOT NULL,
  `player_num` int(10) unsigned NOT NULL,
  `feature_id` int(10) unsigned NOT NULL,
  `param` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `player_features_usage`
--

/*!40000 ALTER TABLE `player_features_usage` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_features_usage` ENABLE KEYS */;


--
-- Definition of table `player_start_deck_config`
--

DROP TABLE IF EXISTS `player_start_deck_config`;
CREATE TABLE `player_start_deck_config` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `player_num` int(10) unsigned NOT NULL,
  `quantity` int(10) unsigned NOT NULL,
  `type` varchar(200) NOT NULL,
  `mode_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `player_start_deck_config_modes` (`mode_id`),
  CONSTRAINT `player_start_deck_config_modes` FOREIGN KEY (`mode_id`) REFERENCES `modes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=142 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `player_start_deck_config`
--

/*!40000 ALTER TABLE `player_start_deck_config` DISABLE KEYS */;
INSERT INTO `player_start_deck_config` (`id`,`player_num`,`quantity`,`type`,`mode_id`) VALUES 
 (1,0,2,'m',1),
 (2,0,2,'u',1),
 (3,0,1,'b',1),
 (4,1,2,'m',1),
 (5,1,2,'u',1),
 (6,1,1,'b',1),
 (7,2,2,'m',1),
 (8,2,2,'u',1),
 (9,2,1,'b',1),
 (10,3,2,'m',1),
 (11,3,2,'u',1),
 (12,3,1,'b',1),
 (130,0,2,'m',8),
 (131,0,2,'u',8),
 (132,0,1,'b',8),
 (133,1,2,'m',8),
 (134,1,2,'u',8),
 (135,1,1,'b',8),
 (136,2,2,'m',8),
 (137,2,2,'u',8),
 (138,2,1,'b',8),
 (139,3,2,'m',8),
 (140,3,2,'u',8),
 (141,3,1,'b',8);
/*!40000 ALTER TABLE `player_start_deck_config` ENABLE KEYS */;


--
-- Definition of table `player_start_gold_config`
--

DROP TABLE IF EXISTS `player_start_gold_config`;
CREATE TABLE `player_start_gold_config` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `player_num` int(10) unsigned NOT NULL,
  `quantity` int(10) unsigned NOT NULL,
  `mode_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `player_start_gold_config_modes` (`mode_id`),
  CONSTRAINT `player_start_gold_config_modes` FOREIGN KEY (`mode_id`) REFERENCES `modes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `player_start_gold_config`
--

/*!40000 ALTER TABLE `player_start_gold_config` DISABLE KEYS */;
INSERT INTO `player_start_gold_config` (`id`,`player_num`,`quantity`,`mode_id`) VALUES 
 (1,0,100,1),
 (2,1,100,1),
 (3,2,100,1),
 (4,3,100,1),
 (58,0,100,8),
 (59,1,100,8),
 (60,2,100,8),
 (61,3,100,8);
/*!40000 ALTER TABLE `player_start_gold_config` ENABLE KEYS */;


--
-- Definition of table `players`
--

DROP TABLE IF EXISTS `players`;
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `players`
--

/*!40000 ALTER TABLE `players` DISABLE KEYS */;
/*!40000 ALTER TABLE `players` ENABLE KEYS */;


--
-- Definition of trigger `players_bu`
--

DROP TRIGGER /*!50030 IF EXISTS */ `players_bu`;

DELIMITER $$

CREATE DEFINER = `root`@`localhost` TRIGGER `players_bu` BEFORE UPDATE ON `players` FOR EACH ROW BEGIN
  IF(OLD.gold<>NEW.gold)THEN
  BEGIN
    DECLARE og,d INT;
    SET og=OLD.gold;
    SET d=NEW.gold;
    SET d=d-og;
    INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(NEW.game_id,NEW.player_num,'change_gold',d);
  END;
  END IF;
END $$

DELIMITER ;

--
-- Definition of table `procedures`
--

DROP TABLE IF EXISTS `procedures`;
CREATE TABLE `procedures` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `params` varchar(100) NOT NULL DEFAULT '',
  `ui_action_name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `procedures`
--

/*!40000 ALTER TABLE `procedures` DISABLE KEYS */;
INSERT INTO `procedures` (`id`,`name`,`params`,`ui_action_name`) VALUES 
 (1,'player_end_turn','',NULL),
 (2,'send_money','player,amount',NULL),
 (3,'buy_card','',NULL),
 (4,'take_subsidy','',NULL),
 (5,'player_resurrect','dead_unit',NULL),
 (6,'put_building','card,empty_coord_my_zone,rotation,flip',NULL),
 (7,'cast_pooring','card,player',NULL),
 (8,'cast_riching','card',NULL),
 (9,'cast_half_money','card',NULL),
 (10,'summon_unit','card',NULL),
 (11,'cast_fireball','card,unit',NULL),
 (12,'cast_lightening_min','card,unit','lightening_min'),
 (13,'cast_lightening_max','card,unit','lightening_max'),
 (14,'player_move_unit','unit,empty_coord','move'),
 (15,'attack','unit,attack_coord','attack'),
 (16,'player_exit','',NULL),
 (17,'agree_draw','',NULL),
 (18,'disagree_draw','',NULL),
 (19,'cast_paralich','card,unit',NULL),
 (20,'add_chat_message','text',NULL),
 (21,'refresh','',NULL),
 (22,'cast_madness','card,unit',NULL),
 (23,'cast_shield','card,unit',NULL),
 (24,'cast_healing','card,unit',NULL),
 (25,'cast_russian_ruletka','card,unit',NULL),
 (26,'cast_o_d','card,unit',NULL),
 (27,'cast_teleport','card,unit,empty_coord',NULL),
 (28,'cast_mind_control','card,unit',NULL),
 (29,'cast_show_cards','card,player',NULL),
 (30,'cast_telekinesis','card,player',NULL),
 (31,'cast_eagerness','card,unit',NULL),
 (32,'cast_speeding','card,unit',NULL),
 (33,'cast_unit_upgrade_all','card,unit','upgrade_all'),
 (34,'cast_unit_upgrade_random','card,unit','upgrade_random'),
 (35,'cast_armageddon','card',NULL),
 (36,'cast_meteor_shower','card,any_coord',NULL),
 (37,'cast_repair_buildings','card',NULL),
 (38,'cast_polza_main','card',NULL),
 (39,'cast_polza_resurrect','dead_unit',NULL),
 (40,'cast_polza_units_from_zone','zone',NULL),
 (41,'cast_polza_move_building','building,empty_coord,rotation,flip',NULL),
 (42,'cast_vred_main','card',NULL),
 (43,'cast_vred_pooring','player',NULL),
 (44,'cast_vred_kill_unit','unit',NULL),
 (45,'cast_vred_destroy_building','building',NULL),
 (46,'cast_vred_move_building','building,empty_coord,rotation,flip',NULL),
 (47,'taran_bind','unit,target_unit','taran_bind'),
 (48,'wizard_heal','unit,target_unit','wizard_heal'),
 (49,'wizard_fireball','unit,target_unit','wizard_fireball'),
 (50,'necromancer_resurrect','unit,dead_unit','necromancer_resurrect'),
 (51,'cast_vampire','card,empty_coord_my_zone',NULL),
 (52,'necromancer_sacrifice','unit,my_unit,target_unit','necromancer_sacrifice'),
 (53,'archer_shoot','unit,target_unit','shoot'),
 (54,'arbalester_shoot','unit,target_unit','shoot'),
 (55,'catapult_shoot','unit,building','shoot');
/*!40000 ALTER TABLE `procedures` ENABLE KEYS */;


--
-- Definition of table `procedures_params`
--

DROP TABLE IF EXISTS `procedures_params`;
CREATE TABLE `procedures_params` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(45) NOT NULL,
  `description` varchar(200) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `procedures_params`
--

/*!40000 ALTER TABLE `procedures_params` DISABLE KEYS */;
INSERT INTO `procedures_params` (`id`,`code`,`description`) VALUES 
 (1,'empty_coord','Выберите пустую клетку на поле'),
 (2,'empty_coord_my_zone','Выберите место в своей зоне'),
 (3,'unit','Выберите юнита'),
 (4,'zone','Выберите зону'),
 (5,'building','Выберите здание'),
 (6,'player','Выберите игрока'),
 (7,'amount','Укажите количество'),
 (8,'dead_unit','Выберите мертвого юнита'),
 (9,'card','Выберите карту'),
 (10,'rotation','Каким боком поставить'),
 (11,'flip','Отразить'),
 (12,'attack_coord','Выберите, что атаковать'),
 (13,'text','Текст'),
 (14,'any_coord','Выберите любую клетку'),
 (15,'target_unit','Выберите юнита, к которому применить действие'),
 (16,'my_unit','Выберите своего юнита'),
 (17,'target_unit_in_distance_2_4','Выберите юнита на расстоянии 2 - 4 клетки'),
 (18,'target_building_in_distance_2_5','Выберите здание на расстоянии 2 - 4 клетки');
/*!40000 ALTER TABLE `procedures_params` ENABLE KEYS */;


--
-- Definition of table `put_start_buildings_config`
--

DROP TABLE IF EXISTS `put_start_buildings_config`;
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
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `put_start_buildings_config`
--

/*!40000 ALTER TABLE `put_start_buildings_config` DISABLE KEYS */;
INSERT INTO `put_start_buildings_config` (`id`,`player_num`,`x`,`y`,`rotation`,`flip`,`building_id`,`mode_id`) VALUES 
 (1,0,0,0,0,0,7,1),
 (2,1,18,0,1,0,7,1),
 (3,2,18,18,2,0,7,1),
 (4,3,0,18,3,0,7,1),
 (37,0,0,0,0,0,15,8),
 (38,1,18,0,1,0,15,8),
 (39,2,18,18,2,0,15,8),
 (40,3,0,18,3,0,15,8);
/*!40000 ALTER TABLE `put_start_buildings_config` ENABLE KEYS */;


--
-- Definition of table `put_start_units_config`
--

DROP TABLE IF EXISTS `put_start_units_config`;
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
) ENGINE=InnoDB AUTO_INCREMENT=70 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `put_start_units_config`
--

/*!40000 ALTER TABLE `put_start_units_config` DISABLE KEYS */;
INSERT INTO `put_start_units_config` (`id`,`player_num`,`x`,`y`,`unit_id`,`mode_id`) VALUES 
 (1,0,2,0,1,1),
 (2,0,0,2,1,1),
 (3,1,17,0,1,1),
 (4,1,19,2,1,1),
 (5,2,17,19,1,1),
 (6,2,19,17,1,1),
 (7,3,0,17,1,1),
 (8,3,2,19,1,1),
 (62,0,2,0,14,8),
 (63,0,0,2,14,8),
 (64,1,17,0,14,8),
 (65,1,19,2,14,8),
 (66,2,17,19,14,8),
 (67,2,19,17,14,8),
 (68,3,0,17,14,8),
 (69,3,2,19,14,8);
/*!40000 ALTER TABLE `put_start_units_config` ENABLE KEYS */;


--
-- Definition of table `statistic_charts`
--

DROP TABLE IF EXISTS `statistic_charts`;
CREATE TABLE `statistic_charts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tab_id` int(10) unsigned NOT NULL,
  `type` varchar(45) NOT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `statistic_charts_tabs` (`tab_id`),
  CONSTRAINT `statistic_charts_tabs` FOREIGN KEY (`tab_id`) REFERENCES `statistic_tabs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `statistic_charts`
--

/*!40000 ALTER TABLE `statistic_charts` DISABLE KEYS */;
INSERT INTO `statistic_charts` (`id`,`tab_id`,`type`,`name`) VALUES 
 (1,1,'bar','Заработал'),
 (2,1,'bar','Потратил'),
 (3,2,'bar','Купил'),
 (4,2,'bar','Сыграл'),
 (5,2,'pie','$p_name cыграл по типам карт'),
 (6,2,'pie','$p_name cыграл по типам карт'),
 (7,2,'pie','$p_name cыграл по типам карт'),
 (8,2,'pie','$p_name cыграл по типам карт'),
 (9,3,'bar','Нанес'),
 (10,4,'bar','Процент попаданий'),
 (11,4,'bar','Процент критических'),
 (12,5,'bar','Призванных юнитов'),
 (13,5,'bar','Убитых юнитов'),
 (14,6,'bar','Призванных зданий'),
 (15,6,'bar','Разрушенных зданий');
/*!40000 ALTER TABLE `statistic_charts` ENABLE KEYS */;


--
-- Definition of table `statistic_game_actions`
--

DROP TABLE IF EXISTS `statistic_game_actions`;
CREATE TABLE `statistic_game_actions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `game_id` int(10) unsigned NOT NULL,
  `player_num` int(10) unsigned NOT NULL,
  `action` enum('change_gold','buy_card','play_card','unit_attack','magical_attack','miss_attack','critical_hit','kill_unit','destroy_building','make_damage','resurrect_unit','unit_ability','start_game','end_game') NOT NULL,
  `value` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `statistic_game_actions`
--

/*!40000 ALTER TABLE `statistic_game_actions` DISABLE KEYS */;
/*!40000 ALTER TABLE `statistic_game_actions` ENABLE KEYS */;


--
-- Definition of table `statistic_tabs`
--

DROP TABLE IF EXISTS `statistic_tabs`;
CREATE TABLE `statistic_tabs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `statistic_tabs`
--

/*!40000 ALTER TABLE `statistic_tabs` DISABLE KEYS */;
INSERT INTO `statistic_tabs` (`id`,`name`) VALUES 
 (1,'Золото'),
 (2,'Карты'),
 (3,'Урон'),
 (4,'Атака'),
 (5,'Юниты'),
 (6,'Здания');
/*!40000 ALTER TABLE `statistic_tabs` ENABLE KEYS */;


--
-- Definition of table `statistic_values`
--

DROP TABLE IF EXISTS `statistic_values`;
CREATE TABLE `statistic_values` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `game_id` int(10) unsigned NOT NULL,
  `player_num` int(10) unsigned NOT NULL,
  `measure_id` int(10) unsigned NOT NULL,
  `value` float DEFAULT NULL,
  `name` varchar(100) NOT NULL DEFAULT '',
  `chart_name` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `statistic_values`
--

/*!40000 ALTER TABLE `statistic_values` DISABLE KEYS */;
/*!40000 ALTER TABLE `statistic_values` ENABLE KEYS */;


--
-- Definition of table `statistic_values_config`
--

DROP TABLE IF EXISTS `statistic_values_config`;
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
) ENGINE=InnoDB AUTO_INCREMENT=184 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `statistic_values_config`
--

/*!40000 ALTER TABLE `statistic_values_config` DISABLE KEYS */;
INSERT INTO `statistic_values_config` (`id`,`player_num`,`chart_id`,`measure_id`,`color`,`name`,`mode_id`) VALUES 
 (1,0,1,1,'p0',NULL,1),
 (2,1,1,1,'p1',NULL,1),
 (3,2,1,1,'p2',NULL,1),
 (4,3,1,1,'p3',NULL,1),
 (5,0,2,2,'p0',NULL,1),
 (6,1,2,2,'p1',NULL,1),
 (7,2,2,2,'p2',NULL,1),
 (8,3,2,2,'p3',NULL,1),
 (9,0,3,3,'p0',NULL,1),
 (10,1,3,3,'p1',NULL,1),
 (11,2,3,3,'p2',NULL,1),
 (12,3,3,3,'p3',NULL,1),
 (13,0,4,4,'p0',NULL,1),
 (14,1,4,4,'p1',NULL,1),
 (15,2,4,4,'p2',NULL,1),
 (16,3,4,4,'p3',NULL,1),
 (17,0,9,9,'p0',NULL,1),
 (18,1,9,9,'p1',NULL,1),
 (19,2,9,9,'p2',NULL,1),
 (20,3,9,9,'p3',NULL,1),
 (21,0,10,18,'p0',NULL,1),
 (22,1,10,18,'p1',NULL,1),
 (23,2,10,18,'p2',NULL,1),
 (24,3,10,18,'p3',NULL,1),
 (25,0,11,19,'p0',NULL,1),
 (26,1,11,19,'p1',NULL,1),
 (27,2,11,19,'p2',NULL,1),
 (28,3,11,19,'p3',NULL,1),
 (29,0,12,20,'p0',NULL,1),
 (30,1,12,20,'p1',NULL,1),
 (31,2,12,20,'p2',NULL,1),
 (32,3,12,20,'p3',NULL,1),
 (33,0,13,14,'p0',NULL,1),
 (34,1,13,14,'p1',NULL,1),
 (35,2,13,14,'p2',NULL,1),
 (36,3,13,14,'p3',NULL,1),
 (37,0,14,21,'p0',NULL,1),
 (38,1,14,21,'p1',NULL,1),
 (39,2,14,21,'p2',NULL,1),
 (40,3,14,21,'p3',NULL,1),
 (41,0,15,16,'p0',NULL,1),
 (42,1,15,16,'p1',NULL,1),
 (43,2,15,16,'p2',NULL,1),
 (44,3,15,16,'p3',NULL,1),
 (45,0,5,5,'magic','Магии',1),
 (46,0,5,6,'event','События',1),
 (47,0,5,7,'unit','Юниты',1),
 (48,0,5,8,'building','Здания',1),
 (49,1,6,5,'magic','Магии',1),
 (50,1,6,6,'event','События',1),
 (51,1,6,7,'unit','Юниты',1),
 (52,1,6,8,'building','Здания',1),
 (53,2,7,5,'magic','Магии',1),
 (54,2,7,6,'event','События',1),
 (55,2,7,7,'unit','Юниты',1),
 (56,2,7,8,'building','Здания',1),
 (57,3,8,5,'magic','Магии',1),
 (58,3,8,6,'event','События',1),
 (59,3,8,7,'unit','Юниты',1),
 (60,3,8,8,'building','Здания',1),
 (124,0,1,1,'p0',NULL,8),
 (125,1,1,1,'p1',NULL,8),
 (126,2,1,1,'p2',NULL,8),
 (127,3,1,1,'p3',NULL,8),
 (128,0,2,2,'p0',NULL,8),
 (129,1,2,2,'p1',NULL,8),
 (130,2,2,2,'p2',NULL,8),
 (131,3,2,2,'p3',NULL,8),
 (132,0,3,3,'p0',NULL,8),
 (133,1,3,3,'p1',NULL,8),
 (134,2,3,3,'p2',NULL,8),
 (135,3,3,3,'p3',NULL,8),
 (136,0,4,4,'p0',NULL,8),
 (137,1,4,4,'p1',NULL,8),
 (138,2,4,4,'p2',NULL,8),
 (139,3,4,4,'p3',NULL,8),
 (140,0,9,9,'p0',NULL,8),
 (141,1,9,9,'p1',NULL,8),
 (142,2,9,9,'p2',NULL,8),
 (143,3,9,9,'p3',NULL,8),
 (144,0,10,18,'p0',NULL,8),
 (145,1,10,18,'p1',NULL,8),
 (146,2,10,18,'p2',NULL,8),
 (147,3,10,18,'p3',NULL,8),
 (148,0,11,19,'p0',NULL,8),
 (149,1,11,19,'p1',NULL,8),
 (150,2,11,19,'p2',NULL,8),
 (151,3,11,19,'p3',NULL,8),
 (152,0,12,20,'p0',NULL,8),
 (153,1,12,20,'p1',NULL,8),
 (154,2,12,20,'p2',NULL,8),
 (155,3,12,20,'p3',NULL,8),
 (156,0,13,14,'p0',NULL,8),
 (157,1,13,14,'p1',NULL,8),
 (158,2,13,14,'p2',NULL,8),
 (159,3,13,14,'p3',NULL,8),
 (160,0,14,21,'p0',NULL,8),
 (161,1,14,21,'p1',NULL,8),
 (162,2,14,21,'p2',NULL,8),
 (163,3,14,21,'p3',NULL,8),
 (164,0,15,16,'p0',NULL,8),
 (165,1,15,16,'p1',NULL,8),
 (166,2,15,16,'p2',NULL,8),
 (167,3,15,16,'p3',NULL,8),
 (168,0,5,5,'magic','Магии',8),
 (169,0,5,6,'event','События',8),
 (170,0,5,7,'unit','Юниты',8),
 (171,0,5,8,'building','Здания',8),
 (172,1,6,5,'magic','Магии',8),
 (173,1,6,6,'event','События',8),
 (174,1,6,7,'unit','Юниты',8),
 (175,1,6,8,'building','Здания',8),
 (176,2,7,5,'magic','Магии',8),
 (177,2,7,6,'event','События',8),
 (178,2,7,7,'unit','Юниты',8),
 (179,2,7,8,'building','Здания',8),
 (180,3,8,5,'magic','Магии',8),
 (181,3,8,6,'event','События',8),
 (182,3,8,7,'unit','Юниты',8),
 (183,3,8,8,'building','Здания',8);
/*!40000 ALTER TABLE `statistic_values_config` ENABLE KEYS */;


--
-- Definition of table `summon_cfg`
--

DROP TABLE IF EXISTS `summon_cfg`;
CREATE TABLE `summon_cfg` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `player_name` varchar(45) NOT NULL DEFAULT '',
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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `summon_cfg`
--

/*!40000 ALTER TABLE `summon_cfg` DISABLE KEYS */;
INSERT INTO `summon_cfg` (`id`,`player_name`,`building_id`,`unit_id`,`count`,`owner`,`mode_id`) VALUES 
 (1,'Жабка',5,11,3,2,1),
 (2,'Тролль',6,12,1,3,1),
 (14,'Жабка',13,24,3,2,8),
 (15,'Тролль',14,25,1,3,8);
/*!40000 ALTER TABLE `summon_cfg` ENABLE KEYS */;


--
-- Definition of table `unit_default_features`
--

DROP TABLE IF EXISTS `unit_default_features`;
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

--
-- Dumping data for table `unit_default_features`
--

/*!40000 ALTER TABLE `unit_default_features` DISABLE KEYS */;
INSERT INTO `unit_default_features` (`id`,`unit_id`,`feature_id`,`param`) VALUES 
 (1,6,1,NULL),
 (2,7,2,NULL),
 (3,5,3,NULL),
 (4,12,4,NULL),
 (5,13,11,NULL),
 (6,13,13,NULL),
 (7,11,14,NULL),
 (8,12,14,NULL),
 (9,13,14,NULL),
 (10,7,16,NULL),
 (11,7,17,NULL),
 (12,6,18,NULL),
 (13,7,18,NULL),
 (86,18,3,NULL),
 (87,19,1,NULL),
 (88,19,18,NULL),
 (90,20,2,NULL),
 (91,20,16,NULL),
 (92,20,17,NULL),
 (93,20,18,NULL),
 (97,24,14,NULL),
 (98,25,4,NULL),
 (99,25,14,NULL),
 (101,26,11,NULL),
 (102,26,13,NULL),
 (103,26,14,NULL),
 (104,29,2,NULL),
 (105,29,17,NULL),
 (106,29,18,NULL);
/*!40000 ALTER TABLE `unit_default_features` ENABLE KEYS */;


--
-- Definition of table `unit_features`
--

DROP TABLE IF EXISTS `unit_features`;
CREATE TABLE `unit_features` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(45) NOT NULL,
  `description` varchar(200) NOT NULL,
  `log_description` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `unit_features`
--

/*!40000 ALTER TABLE `unit_features` DISABLE KEYS */;
INSERT INTO `unit_features` (`id`,`code`,`description`,`log_description`) VALUES 
 (1,'magic_immunity','Юнит невосприимчив к магии','имеет иммунитет к магии'),
 (2,'bindable','Юнит можно цеплять к другим юнитам','можно цеплять к другим юнитам'),
 (3,'blocks_buildings','Юнит блокирует здания, находясь в их радиусе','блокирует здания, находясь в их радиусе'),
 (4,'agressive','Юнит начинает бить ударившего его юнита','охотится на ударившего его юнита'),
 (5,'madness','Юнит сошел с ума','сошел с ума'),
 (6,'knight','Юнит ходит конем','ходит конем'),
 (7,'paralich','Юнит парализован','парализован'),
 (8,'zombie','Юнит - зомби','зомби'),
 (9,'bind_target','Юнит, к которому прицеплен',''),
 (10,'attack_target','Юнит, которого атаковать',''),
 (11,'vamp','Юнит - вампир','вампир'),
 (12,'under_control','Юнит под контролем другого юнита',NULL),
 (13,'drink_health','Юнит при ударе пьет жизнь противника',NULL),
 (14,'no_card','Непризванный юнит',NULL),
 (15,'parent_building','Плодится из здания',NULL),
 (16,'pushes','Толкается при атаке',NULL),
 (17,'mechanical','Механический',NULL),
 (18,'goes_to_deck_on_death','При уничтожении идет не в мертвятник, а в колоду',NULL);
/*!40000 ALTER TABLE `unit_features` ENABLE KEYS */;


--
-- Definition of table `units`
--

DROP TABLE IF EXISTS `units`;
CREATE TABLE `units` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `moves` int(10) unsigned NOT NULL,
  `health` int(10) unsigned NOT NULL,
  `attack` int(10) unsigned NOT NULL,
  `size` int(10) unsigned NOT NULL DEFAULT '1',
  `shield` int(11) NOT NULL DEFAULT '0',
  `description` varchar(1000) DEFAULT NULL,
  `log_short_name` varchar(45) DEFAULT NULL,
  `log_name_rod_pad` varchar(45) DEFAULT NULL,
  `ui_code` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `units`
--

/*!40000 ALTER TABLE `units` DISABLE KEYS */;
INSERT INTO `units` (`id`,`name`,`moves`,`health`,`attack`,`size`,`shield`,`description`,`log_short_name`,`log_name_rod_pad`,`ui_code`) VALUES 
 (1,'Копейщик',1,1,1,1,0,'При критическом ударе на конного рыцаря +1 атаки','Копейщик','Копейщика','spearman'),
 (2,'Мечник',1,1,2,1,0,NULL,'Мечник','Мечника','swordsman'),
 (3,'Рыцарь',1,3,2,1,0,'При критическом ударе дракона +2 атаки','Рыцарь','Рыцаря','knight_on_foot'),
 (4,'Конный рыцарь',3,3,2,1,0,'При критическом ударе дракона +2 атаки','Кон. рыц.','Кон. рыц.','knight_with_horse'),
 (5,'Ниндзя',2,2,2,1,0,'Вероятность попадания в ниндзю 1/3. Если он находится в радиусе здания, то оно не работает.','Ниндзя','Ниндзю','ninja'),
 (6,'Голем',1,3,3,1,0,'Неуязвим к магии. При атаке урон по голему уменьшается на 1','Голем','Голема','golem'),
 (7,'Таран',1,2,5,1,0,'Атакует только здания. Можно прицеплять к юнитам. Отпихивает юнитов при атаке','Таран','Таран','taran'),
 (8,'Маг',3,1,1,1,1,'Имеет собственный 1 щит. Лечит других юнитов. Колдует Fireball','Маг','Мага','wizard'),
 (9,'Некромант',2,2,1,1,0,'Воскрешает юнитов из могильника за их обычную цену, может повреждать врагов жертвоприношением','Некромант','Некроманта','necromancer'),
 (10,'Дракон',5,5,5,2,0,'Атакует несколько целей рядом оновременно','Дракон','Дракона','dragon'),
 (11,'Жабка',2,1,1,1,0,'Атакует ближайшего юнита любого игрока','Жабка','Жабку','frog'),
 (12,'Тролль',2,3,3,1,0,'Атакует ближайшее здание, пока его не тронут','Тролль','Тролля','troll'),
 (13,'Вампир',2,2,2,1,0,'Заражает вампиризмом, выпивает здоровье','Вампир','Вампира','vampire'),
 (14,'Копейщик',2,1,1,1,0,'При критическом ударе на конного рыцаря +1 атаки','Копейщик','Копейщика','spearman'),
 (15,'Мечник',2,1,2,1,0,NULL,'Мечник','Мечника','swordsman'),
 (16,'Рыцарь',2,3,2,1,0,'При критическом ударе дракона +2 атаки','Рыцарь','Рыцаря','knight_on_foot'),
 (17,'Конный рыцарь',4,3,2,1,0,'При критическом ударе дракона +2 атаки','Кон. рыц.','Кон. рыц.','knight_with_horse'),
 (18,'Ниндзя',3,2,2,1,0,'Вероятность попадания в ниндзю 1/3. Если он находится в радиусе здания, то оно не работает.','Ниндзя','Ниндзю','ninja'),
 (19,'Голем',1,3,3,1,0,'Неуязвим к магии. При атаке урон по голему уменьшается на 1','Голем','Голема','golem'),
 (20,'Таран',1,2,5,1,0,'Атакует только здания. Можно прицеплять к юнитам. Отпихивает юнитов при атаке','Таран','Таран','taran'),
 (21,'Маг',4,1,1,1,1,'Имеет собственный 1 щит. Лечит других юнитов. Колдует Fireball','Маг','Мага','wizard'),
 (22,'Некромант',3,2,1,1,0,'Воскрешает юнитов из могильника за их обычную цену, может повреждать врагов жертвоприношением','Некромант','Некроманта','necromancer'),
 (23,'Дракон',5,5,5,2,0,'Атакует несколько целей рядом оновременно','Дракон','Дракона','dragon'),
 (24,'Жабка',3,1,1,1,0,'Атакует ближайшего юнита любого игрока','Жабка','Жабку','frog'),
 (25,'Тролль',3,3,3,1,0,'Атакует ближайшее здание, пока его не тронут','Тролль','Тролля','troll'),
 (26,'Вампир',3,2,2,1,0,'Заражает вампиризмом, выпивает здоровье','Вампир','Вампира','vampire'),
 (27,'Лучник',3,1,1,1,0,'Стреляет. Через клетку - попадает всегда, через две клетки - 1/2, через три клетки - 1/6','Лучник','Лучника','archer'),
 (28,'Арбалетчик',2,2,2,1,0,'Стреляет. Через клетку на 2 урона, через две - 1 или 2, через три - вероятность попадания 1/2 и 1 урона','Арбалетчик','Арбалетчика','arbalester'),
 (29,'Катапульта',1,2,3,1,0,'Стреляет по зданиям. Через клетку всегда попадает, через две 1/2, через три 1/3, через четыре 1/6','Катапульта','Катапульту','catapult');
/*!40000 ALTER TABLE `units` ENABLE KEYS */;


--
-- Definition of table `units_procedures`
--

DROP TABLE IF EXISTS `units_procedures`;
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
) ENGINE=InnoDB AUTO_INCREMENT=278 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `units_procedures`
--

/*!40000 ALTER TABLE `units_procedures` DISABLE KEYS */;
INSERT INTO `units_procedures` (`id`,`unit_id`,`procedure_id`,`default`) VALUES 
 (1,1,14,1),
 (2,2,14,1),
 (3,3,14,1),
 (4,4,14,1),
 (5,5,14,1),
 (6,6,14,1),
 (7,7,14,1),
 (8,8,14,1),
 (9,9,14,1),
 (10,10,14,1),
 (11,11,14,1),
 (12,12,14,1),
 (16,1,15,0),
 (17,2,15,0),
 (18,3,15,0),
 (19,4,15,0),
 (20,5,15,0),
 (21,6,15,0),
 (22,7,15,0),
 (23,8,15,0),
 (24,9,15,0),
 (25,10,15,0),
 (26,11,15,0),
 (27,12,15,0),
 (28,7,47,0),
 (29,8,48,0),
 (30,8,49,0),
 (31,9,50,0),
 (32,13,14,1),
 (33,13,15,0),
 (34,9,52,0),
 (222,14,14,1),
 (223,14,15,0),
 (225,15,14,1),
 (226,15,15,0),
 (228,16,14,1),
 (229,16,15,0),
 (231,17,14,1),
 (232,17,15,0),
 (234,18,14,1),
 (235,18,15,0),
 (237,19,14,1),
 (238,19,15,0),
 (240,20,14,1),
 (241,20,15,0),
 (242,20,47,0),
 (243,21,14,1),
 (244,21,15,0),
 (245,21,48,0),
 (246,21,49,0),
 (250,22,14,1),
 (251,22,15,0),
 (252,22,50,0),
 (253,22,52,0),
 (257,23,14,1),
 (258,23,15,0),
 (260,24,14,1),
 (261,24,15,0),
 (263,25,14,1),
 (264,25,15,0),
 (266,26,14,1),
 (267,26,15,0),
 (268,27,14,1),
 (269,27,15,0),
 (270,27,53,0),
 (271,28,14,1),
 (272,28,15,0),
 (273,28,54,0),
 (274,29,14,1),
 (275,29,15,0),
 (276,29,55,0),
 (277,29,47,0);
/*!40000 ALTER TABLE `units_procedures` ENABLE KEYS */;


--
-- Definition of table `videos`
--

DROP TABLE IF EXISTS `videos`;
CREATE TABLE `videos` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(45) NOT NULL,
  `filename` varchar(45) NOT NULL,
  `mode_id` int(10) unsigned NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `videos_modes` (`mode_id`),
  CONSTRAINT `videos_modes` FOREIGN KEY (`mode_id`) REFERENCES `modes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `videos`
--

/*!40000 ALTER TABLE `videos` DISABLE KEYS */;
INSERT INTO `videos` (`id`,`code`,`filename`,`mode_id`,`title`) VALUES 
 (1,'destroyed_castle','destroyed_castle001.swf',1,'Поражение'),
 (2,'draw','draw001.swf',1,'Ничья'),
 (3,'win','win001.swf',1,'Победа'),
 (22,'destroyed_castle','destroyed_castle001.swf',8,'Поражение'),
 (23,'draw','draw001.swf',8,'Ничья'),
 (24,'win','win001.swf',8,'Победа');
/*!40000 ALTER TABLE `videos` ENABLE KEYS */;


--
-- Definition of function `building_feature_check`
--

DROP FUNCTION IF EXISTS `building_feature_check`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` FUNCTION `building_feature_check`(board_building_id INT, feature_code VARCHAR(45)) RETURNS int(11)
BEGIN
  IF EXISTS(SELECT bbf.id FROM board_buildings_features bbf JOIN building_features bf ON (bbf.feature_id=bf.id) WHERE bbf.board_building_id=board_building_id AND bf.code=feature_code LIMIT 1)
  THEN RETURN 1;
  ELSE RETURN 0;
  END IF;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of function `building_feature_get_param`
--

DROP FUNCTION IF EXISTS `building_feature_get_param`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` FUNCTION `building_feature_get_param`(board_building_id INT, feature_code VARCHAR(45)) RETURNS int(11)
BEGIN
  DECLARE result INT;
  SELECT bbf.param INTO result FROM board_buildings_features bbf JOIN building_features bf ON (bbf.feature_id=bf.id) WHERE bbf.board_building_id=board_building_id AND bf.code=feature_code LIMIT 1;
  RETURN result;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of function `check_building_deactivated`
--

DROP FUNCTION IF EXISTS `check_building_deactivated`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` FUNCTION `check_building_deactivated`(board_building_id INT) RETURNS int(11)
BEGIN
/*check if ninja in radius*/
  IF EXISTS(SELECT b_n.id FROM board_units bu,board b_n,board_buildings bb, board b
    WHERE bb.id=board_building_id AND b.`type`<>'unit' AND b.ref=board_building_id
       AND bu.game_id=bb.game_id AND unit_feature_check(bu.id,'blocks_buildings')=1 AND b_n.`type`='unit' AND b_n.ref=bu.id
       AND b_n.x BETWEEN b.x-bb.radius AND b.x+bb.radius AND b_n.y BETWEEN b.y-bb.radius AND b.y+bb.radius LIMIT 1)
  THEN RETURN 1;
  ELSE RETURN 0;
  END IF;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of function `check_one_step_from_unit`
--

DROP FUNCTION IF EXISTS `check_one_step_from_unit`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` FUNCTION `check_one_step_from_unit`(g_id INT,x INT,y INT,x2 INT,y2 INT) RETURNS int(11)
BEGIN
  DECLARE board_unit_id INT;
  DECLARE x0,y0 INT;

  SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;
  SELECT MIN(b.x),MIN(b.y) INTO x0,y0 FROM board b WHERE b.game_id=g_id AND b.ref=board_unit_id AND b.`type`='unit';

  IF (unit_feature_check(board_unit_id,'knight')=1) THEN /*knight*/
    IF (ABS(x0-x2)=1 AND ABS(y0-y2)=2)OR(ABS(x0-x2)=2 AND ABS(y0-y2)=1) THEN RETURN 1; END IF;
  ELSE /*not knight*/
    IF (ABS(x0-x2)<=1 AND ABS(y0-y2)<=1)AND NOT(x0=x2 AND y0=y2) THEN RETURN 1; END IF;
  END IF;

  RETURN 0;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of function `check_play_card`
--

DROP FUNCTION IF EXISTS `check_play_card`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` FUNCTION `check_play_card`(g_id INT,p_num INT,player_deck_id INT,sender VARCHAR(30)) RETURNS int(11)
BEGIN
  DECLARE crd_id INT;
  
  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id LIMIT 1) THEN RETURN 1; END IF;/*Not your turn*/
  IF (SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id LIMIT 1)<>0 THEN RETURN 28; END IF;/*polza/vred in progress*/
  IF (SELECT units_moves_flag FROM active_players WHERE game_id=g_id LIMIT 1)=1 THEN RETURN 7; END IF;/*Already moved units*/
  IF NOT EXISTS(SELECT id FROM player_deck WHERE game_id=g_id AND player_num=p_num AND id=player_deck_id) THEN RETURN 10; END IF;/*No such card*/
  
  SELECT card_id INTO crd_id FROM player_deck WHERE id=player_deck_id;
  IF (SELECT gold FROM players WHERE game_id=g_id AND player_num=p_num LIMIT 1)<(SELECT cost FROM cards WHERE id=crd_id LIMIT 1) THEN RETURN 2; END IF;/*Not enough gold*/
  IF NOT EXISTS(SELECT cp.id FROM player_deck pd JOIN cards_procedures cp ON pd.card_id=cp.card_id JOIN procedures pm ON cp.procedure_id=pm.id WHERE pd.id=player_deck_id AND pm.name=sender LIMIT 1) THEN RETURN 15; END IF;/*Cheater - procedure from another card*/

  UPDATE active_players SET current_procedure=sender WHERE game_id=g_id;

  RETURN 0;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of function `check_unit_can_do_action`
--

DROP FUNCTION IF EXISTS `check_unit_can_do_action`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` FUNCTION `check_unit_can_do_action`(g_id INT,p_num INT,x INT,y INT,action_procedure VARCHAR(30)) RETURNS int(11)
BEGIN
  DECLARE board_unit_id INT;
  DECLARE p_num_unit_owner INT;
  DECLARE moves_left INT;
  DECLARE u_id INT;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id LIMIT 1) THEN RETURN 1; END IF;/*Not your turn*/
  IF (SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id LIMIT 1)<>0 THEN RETURN 28; END IF;/*polza/vred in progress*/

  SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;
  IF board_unit_id IS NULL THEN RETURN 14; END IF;/*Not a unit*/

  SELECT bu.player_num,bu.moves_left,bu.unit_id INTO p_num_unit_owner,moves_left,u_id FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

  IF p_num_unit_owner<>p_num THEN RETURN 16; END IF;/*Not my unit*/
  IF moves_left<=0 THEN RETURN 17; END IF;/*No moves left*/
  IF (unit_feature_check(board_unit_id,'paralich')=1) THEN RETURN 18; END IF;/*paralich*/

  IF NOT EXISTS(SELECT up.id FROM units_procedures up JOIN procedures pm ON up.procedure_id=pm.id WHERE up.unit_id=u_id AND pm.name=action_procedure LIMIT 1) THEN RETURN 30; END IF;/*Cheater - procedure from another unit*/

  UPDATE active_players SET current_procedure=action_procedure WHERE game_id=g_id;

  RETURN 0;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of function `game_feature_get_id_by_code`
--

DROP FUNCTION IF EXISTS `game_feature_get_id_by_code`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` FUNCTION `game_feature_get_id_by_code`(feature_code VARCHAR(45)) RETURNS int(11)
    DETERMINISTIC
BEGIN
  DECLARE result INT;
  SELECT gf.id INTO result FROM games_features gf WHERE gf.code=feature_code;
  RETURN result;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of function `game_feature_get_param`
--

DROP FUNCTION IF EXISTS `game_feature_get_param`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` FUNCTION `game_feature_get_param`(game_id INT, feature_code VARCHAR(45)) RETURNS int(11)
BEGIN
  DECLARE result INT;
  SELECT gfu.param INTO result FROM games_features_usage gfu JOIN games_features gf ON (gfu.feature_id=gf.id) WHERE gfu.game_id=game_id AND gf.code=feature_code LIMIT 1;
  RETURN result;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of function `log_attack`
--

DROP FUNCTION IF EXISTS `log_attack`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` FUNCTION `log_attack`(amt INT) RETURNS varchar(200) CHARSET utf8
BEGIN
  RETURN CONCAT('<b>',amt,'</b>','<img src=\'../../design/images/pic_attk.gif\'>');
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of function `log_building`
--

DROP FUNCTION IF EXISTS `log_building`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` FUNCTION `log_building`(board_building_id INT) RETURNS varchar(200) CHARSET utf8
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE b_id INT;

  SELECT game_id,player_num,building_id INTO g_id,p_num,b_id FROM board_buildings WHERE id=board_building_id LIMIT 1;

  RETURN CONCAT('<b class=\'',(SELECT CASE WHEN p.owner=1 THEN CONCAT('p',p.player_num) ELSE 'newtrl' END FROM players p WHERE p.game_id=g_id AND p.player_num=p_num LIMIT 1),'\' title=\'highlight_building(',board_building_id,')|unhighlight_building(',board_building_id,')\'>',(SELECT log_short_name FROM buildings WHERE id=b_id LIMIT 1),'</b>');

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of function `log_cell`
--

DROP FUNCTION IF EXISTS `log_cell`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` FUNCTION `log_cell`(x INT, y INT) RETURNS varchar(200) CHARSET utf8
BEGIN
  RETURN CONCAT('<b title=\'highlight_cell(',x,',',y,')|unhighlight_cell(',x,',',y,')\'>(',x,',',y,')</b>');
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of function `log_damage`
--

DROP FUNCTION IF EXISTS `log_damage`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` FUNCTION `log_damage`(amt INT) RETURNS varchar(200) CHARSET utf8
BEGIN
  IF amt=0 THEN
    RETURN '';
  ELSE
    RETURN CONCAT('<b class=\'damage\'>',amt,'</b>');
  END IF;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of function `log_gold`
--

DROP FUNCTION IF EXISTS `log_gold`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` FUNCTION `log_gold`(amt INT) RETURNS varchar(200) CHARSET utf8
BEGIN
  RETURN CONCAT('<b>',amt,'</b>','<img src=\'../../design/images/coin.png\'>');
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of function `log_health`
--

DROP FUNCTION IF EXISTS `log_health`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` FUNCTION `log_health`(amt INT) RETURNS varchar(200) CHARSET utf8
BEGIN
  RETURN CONCAT('<b>',amt,'</b>','<img src=\'../../design/images/pic_health.gif\'>');
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of function `log_moves`
--

DROP FUNCTION IF EXISTS `log_moves`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` FUNCTION `log_moves`(amt INT) RETURNS varchar(200) CHARSET utf8
BEGIN
  RETURN CONCAT('<b>',amt,'</b>','<img src=\'../../design/images/pic_move.gif\'>');
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of function `log_player`
--

DROP FUNCTION IF EXISTS `log_player`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` FUNCTION `log_player`(g_id INT,p_num INT) RETURNS varchar(200) CHARSET utf8
BEGIN

  RETURN (SELECT CONCAT('<b class=\'',CASE WHEN p.owner=1 THEN p.player_num ELSE 'newtrl' END,'\'>',p.name,'</b>') FROM players p WHERE p.game_id=g_id AND p.player_num=p_num LIMIT 1);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of function `log_unit`
--

DROP FUNCTION IF EXISTS `log_unit`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` FUNCTION `log_unit`(board_unit_id INT) RETURNS varchar(200) CHARSET utf8
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE u_id INT;

  SELECT game_id,player_num,unit_id INTO g_id,p_num,u_id FROM board_units WHERE id=board_unit_id LIMIT 1;

  RETURN CONCAT('<b class=\'',(SELECT CASE WHEN p.owner=1 THEN CONCAT('p',p.player_num) ELSE 'newtrl' END FROM players p WHERE p.game_id=g_id AND p.player_num=p_num LIMIT 1),'\' title=\'highlight_unit(',board_unit_id,')|unhighlight_unit(',board_unit_id,')\'>',(SELECT log_short_name FROM units WHERE id=u_id LIMIT 1),'</b>');

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of function `log_unit_rod_pad`
--

DROP FUNCTION IF EXISTS `log_unit_rod_pad`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` FUNCTION `log_unit_rod_pad`(board_unit_id INT) RETURNS varchar(200) CHARSET utf8
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE u_id INT;

  SELECT game_id,player_num,unit_id INTO g_id,p_num,u_id FROM board_units WHERE id=board_unit_id LIMIT 1;

  RETURN CONCAT('<b class=\'',(SELECT CASE WHEN p.owner=1 THEN CONCAT('p',p.player_num) ELSE 'newtrl' END FROM players p WHERE p.game_id=g_id AND p.player_num=p_num LIMIT 1),'\' title=\'highlight_unit(',board_unit_id,')|unhighlight_unit(',board_unit_id,')\'>',(SELECT log_name_rod_pad FROM units WHERE id=u_id LIMIT 1),'</b>');

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of function `player_feature_get_id_by_code`
--

DROP FUNCTION IF EXISTS `player_feature_get_id_by_code`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` FUNCTION `player_feature_get_id_by_code`(feature_code VARCHAR(45)) RETURNS int(11)
    DETERMINISTIC
BEGIN
  DECLARE result INT;
  SELECT pf.id INTO result FROM player_features pf WHERE pf.code=feature_code;
  RETURN result;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of function `quart`
--

DROP FUNCTION IF EXISTS `quart`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` FUNCTION `quart`(x INT,y INT) RETURNS int(11)
    DETERMINISTIC
BEGIN

  IF (x>19) OR (x<0) OR (y>19) OR (y<0) THEN RETURN 5; /*Error*/
  END IF;

  IF (x<10)AND(y<10) THEN RETURN 0;
  END IF;
  IF (x>9)AND(y<10) THEN RETURN 1;
  END IF;
  IF (x>9)AND(y>9) THEN RETURN 2;
  END IF;
  IF (x<10)AND(y>9) THEN RETURN 3;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of function `unit_feature_check`
--

DROP FUNCTION IF EXISTS `unit_feature_check`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` FUNCTION `unit_feature_check`(board_unit_id INT, feature_code VARCHAR(45)) RETURNS int(11)
BEGIN
  IF EXISTS(SELECT buf.id FROM board_units_features buf JOIN unit_features uf ON (buf.feature_id=uf.id) WHERE buf.board_unit_id=board_unit_id AND uf.code=feature_code LIMIT 1)
  THEN RETURN 1;
  ELSE RETURN 0;
  END IF;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of function `unit_feature_get_id_by_code`
--

DROP FUNCTION IF EXISTS `unit_feature_get_id_by_code`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` FUNCTION `unit_feature_get_id_by_code`(feature_code VARCHAR(45)) RETURNS int(11)
    DETERMINISTIC
BEGIN
  DECLARE result INT;
  SELECT uf.id INTO result FROM unit_features uf WHERE uf.code=feature_code;
  RETURN result;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of function `unit_feature_get_param`
--

DROP FUNCTION IF EXISTS `unit_feature_get_param`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` FUNCTION `unit_feature_get_param`(board_unit_id INT, feature_code VARCHAR(45)) RETURNS int(11)
BEGIN
  DECLARE result INT DEFAULT NULL;
  IF unit_feature_check(board_unit_id,feature_code)=1 THEN
    SELECT buf.param INTO result FROM board_units_features buf JOIN unit_features uf ON (buf.feature_id=uf.id) WHERE buf.board_unit_id=board_unit_id AND uf.code=feature_code LIMIT 1;
  END IF;
  RETURN result;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `agree_draw`
--

DROP PROCEDURE IF EXISTS `agree_draw`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `agree_draw`(g_id INT,p_num INT)
BEGIN
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_independent_message($p_num,"Согласен на ничью")';

  CALL user_action_begin();

  UPDATE players SET agree_draw=1 WHERE game_id=g_id AND player_num=p_num;

  SET cmd_log=REPLACE(cmd_log,'$p_num',p_num);
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

  IF NOT EXISTS(SELECT p.id FROM players p WHERE p.game_id=g_id AND p.owner=1 AND p.agree_draw=0) THEN
    CALL end_game(g_id);
  END IF;

  CALL user_action_end();

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `arbalester_shoot`
--

DROP PROCEDURE IF EXISTS `arbalester_shoot`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `arbalester_shoot`(g_id INT,p_num INT,x INT,y INT, x2 INT, y2 INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE err_code INT;
  DECLARE aim_bu_id INT;
  DECLARE board_unit_id INT;
  DECLARE distance INT;
  DECLARE dice INT;
  DECLARE chance INT;
  DECLARE damage INT;
  DECLARE miss INT DEFAULT 0;

/*for attack bonuses - ninja, golem*/
  DECLARE aim_unit_id INT;
  DECLARE damage_modificator INT DEFAULT 0;
  DECLARE dice_max_modificator INT DEFAULT 0;
  DECLARE chance_modificator INT DEFAULT 0;

  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit1 стреляет в $log_unit2_rod_pad $log_damage")';

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'arbalester_shoot'); /*unit can do it*/
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
      SELECT b.ref INTO aim_bu_id FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.x=x2 AND b.y=y2 LIMIT 1;
      IF aim_bu_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=40;/*Unit to shoot not chosen*/
      ELSE
        SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;

        SELECT MIN(GREATEST(ABS(shooter.x-aim.x),ABS(shooter.y-aim.y))) INTO distance
        FROM
          (SELECT b.x,b.y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=board_unit_id) shooter,
          (SELECT b.x,b.y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=aim_bu_id) aim;

        IF((distance<2)OR(distance>4))THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=29;/*out of rande*/
        ELSE
/*OK*/
          CALL user_action_begin();

          IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
            CALL start_moving_units(g_id,p_num);
          END IF;

          UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
          CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

          SELECT unit_id INTO aim_unit_id FROM board_units WHERE id=aim_bu_id;
          IF EXISTS(SELECT 1 FROM attack_bonus ab WHERE ab.mode_id=mode_id AND ab.unit_id IS NULL AND ab.aim_type='unit' AND ab.aim_id=aim_unit_id)THEN
            SELECT ab.dice_max,ab.chance,ab.damage_bonus INTO dice_max_modificator,chance_modificator,damage_modificator FROM attack_bonus ab WHERE ab.mode_id=mode_id AND ab.unit_id IS NULL AND ab.aim_type='unit' AND ab.aim_id=aim_unit_id LIMIT 1;
          END IF;

          SELECT bu.attack+damage_modificator INTO damage FROM board_units bu WHERE bu.id=board_unit_id;
          IF(dice_max_modificator > 0)THEN
/*miss or success attack*/
            SELECT FLOOR(1 + (RAND() * dice_max_modificator)) INTO dice FROM DUAL;
            IF dice<chance_modificator THEN
              SET miss=1;
            END IF;
          END IF;

          IF miss=0 THEN
            IF distance=2 THEN /* always hit */
              SET chance=1;
            END IF;
            IF distance=3 THEN /* always,but 1/2 - minus 1 damage */
              SET chance=1;
              SET damage=damage-FLOOR(RAND() * 2);
            END IF;
            IF distance=4 THEN /* 1/2, -1 damage */
              SET chance=4;
              SET damage=damage-1;
            END IF;

            SELECT FLOOR(1 + (RAND() * 6)) INTO dice FROM DUAL;
            IF dice<chance THEN
              SET miss=1;
            END IF;
          END IF;

          SET cmd_log=REPLACE(cmd_log,'$log_unit1',log_unit(board_unit_id));
          SET cmd_log=REPLACE(cmd_log,'$log_unit2_rod_pad',log_unit_rod_pad(aim_bu_id));

          INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'unit_attack');
          IF miss=1 THEN
            SET cmd_log=REPLACE(cmd_log,'$log_damage','(Промах)');
            INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'miss_attack');
          ELSE
            SET cmd_log=REPLACE(cmd_log,'$log_damage',log_damage(damage));

            CALL hit_unit(aim_bu_id,p_num,damage);
          END IF;

          INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

          IF NOT EXISTS(SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id AND bu.player_num=p_num AND moves_left>0 AND unit_feature_check(bu.id,'paralich')=0 LIMIT 1) THEN
            CALL finish_moving_units(g_id,p_num);
            CALL end_turn(g_id,p_num);
          END IF;

          CALL user_action_end();
        END IF;
      END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `archer_shoot`
--

DROP PROCEDURE IF EXISTS `archer_shoot`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `archer_shoot`(g_id INT,p_num INT,x INT,y INT, x2 INT, y2 INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE err_code INT;
  DECLARE aim_bu_id INT;
  DECLARE board_unit_id INT;
  DECLARE distance INT;
  DECLARE dice INT;
  DECLARE chance INT;
  DECLARE damage INT;
  DECLARE miss INT DEFAULT 0;

/*for attack bonuses - ninja, golem*/
  DECLARE aim_unit_id INT;
  DECLARE damage_modificator INT DEFAULT 0;
  DECLARE dice_max_modificator INT DEFAULT 0;
  DECLARE chance_modificator INT DEFAULT 0;

  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit1 стреляет в $log_unit2_rod_pad $log_damage")';

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'archer_shoot'); /*unit can do it*/
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
      SELECT b.ref INTO aim_bu_id FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.x=x2 AND b.y=y2 LIMIT 1;
      IF aim_bu_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=40;/*Unit to shoot not chosen*/
      ELSE
        SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;

        SELECT MIN(GREATEST(ABS(shooter.x-aim.x),ABS(shooter.y-aim.y))) INTO distance
        FROM
          (SELECT b.x,b.y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=board_unit_id) shooter,
          (SELECT b.x,b.y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=aim_bu_id) aim;

        IF((distance<2)OR(distance>4))THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=29;/*out of rande*/
        ELSE
/*OK*/
          CALL user_action_begin();

          IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
            CALL start_moving_units(g_id,p_num);
          END IF;

          UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
          CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

          SELECT unit_id INTO aim_unit_id FROM board_units WHERE id=aim_bu_id;
          IF EXISTS(SELECT 1 FROM attack_bonus ab WHERE ab.mode_id=mode_id AND ab.unit_id IS NULL AND ab.aim_type='unit' AND ab.aim_id=aim_unit_id)THEN
            SELECT ab.dice_max,ab.chance,ab.damage_bonus INTO dice_max_modificator,chance_modificator,damage_modificator FROM attack_bonus ab WHERE ab.mode_id=mode_id AND ab.unit_id IS NULL AND ab.aim_type='unit' AND ab.aim_id=aim_unit_id LIMIT 1;
          END IF;

          SELECT bu.attack+damage_modificator INTO damage FROM board_units bu WHERE bu.id=board_unit_id;
          IF(dice_max_modificator > 0)THEN
/*miss or success attack*/
            SELECT FLOOR(1 + (RAND() * dice_max_modificator)) INTO dice FROM DUAL;
            IF dice<chance_modificator THEN
              SET miss=1;
            END IF;
          END IF;

          IF miss=0 THEN
            IF distance=2 THEN /* always hit */
              SET chance=1;
            END IF;
            IF distance=3 THEN /* 1/2 */
              SET chance=4;
            END IF;
            IF distance=4 THEN /* 1/6 */
              SET chance=6;
            END IF;

            SELECT FLOOR(1 + (RAND() * 6)) INTO dice FROM DUAL;
            IF dice<chance THEN
              SET miss=1;
            END IF;
          END IF;

          SET cmd_log=REPLACE(cmd_log,'$log_unit1',log_unit(board_unit_id));
          SET cmd_log=REPLACE(cmd_log,'$log_unit2_rod_pad',log_unit_rod_pad(aim_bu_id));

          INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'unit_attack');
          IF miss=1 THEN
            SET cmd_log=REPLACE(cmd_log,'$log_damage','(Промах)');
            INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'miss_attack');
          ELSE
            SET cmd_log=REPLACE(cmd_log,'$log_damage',log_damage(damage));

            CALL hit_unit(aim_bu_id,p_num,damage);
          END IF;

          INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

          IF NOT EXISTS(SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id AND bu.player_num=p_num AND moves_left>0 AND unit_feature_check(bu.id,'paralich')=0 LIMIT 1) THEN
            CALL finish_moving_units(g_id,p_num);
            CALL end_turn(g_id,p_num);
          END IF;

          CALL user_action_end();
        END IF;
      END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `attack`
--

DROP PROCEDURE IF EXISTS `attack`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `attack`(g_id INT,p_num INT,x INT,y INT, x2 INT, y2 INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE size INT;
  DECLARE aim_type VARCHAR(45);
  DECLARE aim_id INT;
/*cursor for dragon multiattack*/
  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT DISTINCT b.`type`,b.ref FROM board b WHERE b.game_id=g_id AND b.`type`<>'obstacle' AND b.x BETWEEN x2 AND x2+size-1 AND b.y BETWEEN y2 AND y2+size-1 AND NOT(b.`type`='unit' AND b.ref=board_unit_id);
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'attack'); /*unit can do it*/
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF check_one_step_from_unit(g_id,x,y,x2,y2)=0 THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=20;/* attack out of range*/
    ELSE

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;
      SELECT u.size INTO size FROM board_units bu JOIN units u ON (bu.unit_id=u.id) WHERE bu.id=board_unit_id LIMIT 1;

      IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.`type`<>'obstacle' AND b.x BETWEEN x2 AND x2+size-1 AND b.y BETWEEN y2 AND y2+size-1 AND NOT(b.`type`='unit' AND b.ref=board_unit_id) LIMIT 1)
      THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=21;/*Nothing to attack*/
      ELSE
/*OK*/
                CALL user_action_begin();

                IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
                  CALL start_moving_units(g_id,p_num);
                END IF;

                IF (unit_feature_get_param(board_unit_id,'bind_target') IS NOT NULL) THEN /*if taran is binded to another unit - unbind it*/
                  CALL unit_feature_remove(board_unit_id,'bind_target');
                END IF; /*unbind taran*/

                UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
                CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

                IF size=1 THEN
                  SELECT b.`type`,b.ref INTO aim_type,aim_id FROM board b WHERE b.game_id=g_id AND b.x=x2 AND b.y=y2 LIMIT 1;
                  CALL attack_actions(board_unit_id,aim_type,aim_id);
                  INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'unit_attack');
                ELSE /*dragons*/
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

                IF NOT EXISTS(SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id AND bu.player_num=p_num AND moves_left>0 AND unit_feature_check(bu.id,'paralich')=0 LIMIT 1)
                  AND (SELECT player_num FROM active_players WHERE game_id=g_id)=p_num /*and still his turn*/
                THEN
                  CALL finish_moving_units(g_id,p_num);
                  CALL end_turn(g_id,p_num);
                END IF;

                CALL user_action_end();
      END IF;
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `attack_actions`
--

DROP PROCEDURE IF EXISTS `attack_actions`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `attack_actions`(board_unit_id INT,aim_type VARCHAR(45),aim_board_id INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT; /*atacker*/
  DECLARE p2_num INT; /*aim*/
  DECLARE u_id,aim_object_id INT;
  DECLARE aim_short_name VARCHAR(45) CHARSET utf8;
  DECLARE health_before_hit,health_after_hit INT;
  DECLARE aim_card_id INT;
  DECLARE aim_x,aim_y INT;
  DECLARE aim_shield INT DEFAULT 0;
  DECLARE aim_goes_to_deck INT;
  DECLARE grave_id INT;

  DECLARE damage INT;
  DECLARE attack_success,critical INT;

  DECLARE cmd_log VARCHAR(1000) CHARSET utf8;

  SET cmd_log='log_add_attack_message($x,$y,$x2,$y2,$p_num,"$u_short_name",$p2_num,"$aim_short_name",$attack_success,$critical,$damage)';

  SELECT bu.game_id,bu.player_num,bu.unit_id INTO g_id,p_num,u_id FROM board_units bu JOIN games g ON (bu.game_id=g.id) WHERE bu.id=board_unit_id LIMIT 1;

  CASE
    WHEN aim_type='unit' THEN
    BEGIN
      SELECT bu.player_num,bu.unit_id,bu.health,bu.card_id,shield INTO p2_num,aim_object_id,health_before_hit,aim_card_id,aim_shield FROM board_units bu WHERE bu.id=aim_board_id LIMIT 1;
      SET aim_goes_to_deck = unit_feature_check(aim_board_id,'goes_to_deck_on_death');
      SELECT MIN(b.x),MIN(b.y) INTO aim_x,aim_y FROM board b WHERE b.game_id=g_id AND b.`type`=aim_type AND b.ref=aim_board_id;
      SELECT log_short_name INTO aim_short_name FROM units WHERE id=aim_object_id LIMIT 1;
    END;
    WHEN aim_type='building' OR aim_type='castle' THEN
    BEGIN
      SELECT bb.player_num,bb.building_id INTO p2_num,aim_object_id FROM board_buildings bb WHERE bb.id=aim_board_id LIMIT 1;
      SELECT b.x,b.y INTO aim_x,aim_y FROM board b WHERE b.game_id=g_id AND b.`type`=aim_type AND b.ref=aim_board_id LIMIT 1;
      SELECT log_short_name INTO aim_short_name FROM buildings WHERE id=aim_object_id LIMIT 1;
    END;
  END CASE;

  CALL calculate_attack_damage(board_unit_id,aim_type,aim_board_id,attack_success,damage,critical);

/*log*/
      SET cmd_log=REPLACE(cmd_log,'$x,$y',(SELECT CONCAT(b.x,',',b.y) FROM board b WHERE b.`type`='unit' AND b.ref=board_unit_id LIMIT 1));
      SET cmd_log=REPLACE(cmd_log,'$x2,$y2',(SELECT CONCAT(aim_x,',',aim_y) FROM DUAL));

      SET cmd_log=REPLACE(cmd_log,'$p_num',p_num);
      SET cmd_log=REPLACE(cmd_log,'$p2_num',p2_num);

      SET cmd_log=REPLACE(cmd_log,'$u_short_name',(SELECT log_short_name FROM units WHERE id=u_id LIMIT 1));
      SET cmd_log=REPLACE(cmd_log,'$aim_short_name',aim_short_name);

      SET cmd_log=REPLACE(cmd_log,'$attack_success',attack_success);
      SET cmd_log=REPLACE(cmd_log,'$critical',critical);
      SET cmd_log=REPLACE(cmd_log,'$damage',CASE WHEN aim_shield=0 THEN damage ELSE 0 END);

      INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

  IF critical=1 THEN
    INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'critical_hit');
  END IF;

      IF attack_success=1 THEN /*not miss*/

        /*troll agres*/
        IF(aim_type='unit' AND unit_feature_check(aim_board_id,'agressive')=1) THEN /*if agressive - set attack target*/
          CALL unit_feature_set(aim_board_id,'attack_target',board_unit_id);
        END IF;

        CASE aim_type
          WHEN 'unit' THEN CALL hit_unit(aim_board_id,p_num,damage);
          WHEN 'building' THEN CALL hit_building(aim_board_id,p_num,damage);
          WHEN 'castle' THEN CALL hit_castle(aim_board_id,p_num,damage);
        END CASE;

        IF (aim_type='unit') THEN
          SELECT bu.health INTO health_after_hit FROM board_units bu WHERE bu.id=aim_board_id LIMIT 1;
/*drink health*/
          IF (unit_feature_check(board_unit_id,'drink_health')=1) AND ((health_after_hit IS NULL)OR(health_after_hit<health_before_hit))THEN
            CALL drink_health(board_unit_id);
          END IF;

/*vampirism*/
          IF (unit_feature_check(board_unit_id,'vamp')=1) AND (health_after_hit IS NULL) THEN
            IF (aim_card_id IS NOT NULL AND aim_goes_to_deck=0) THEN
              SELECT gc.grave_id INTO grave_id FROM graves g JOIN grave_cells gc ON g.id=gc.grave_id WHERE g.game_id=g_id AND g.card_id=aim_card_id AND gc.x=aim_x AND gc.y=aim_y LIMIT 1;
              CALL vampire_resurrect_by_card(board_unit_id,grave_id);
            ELSE
              CALL vampire_resurrect_by_u_id(board_unit_id,aim_object_id,aim_x,aim_y);
            END IF;
          END IF;

          /*taran pushes*/
          IF(unit_feature_check(board_unit_id,'pushes')=1 AND aim_type='unit') THEN /*if pushes - push*/
            CALL unit_push(board_unit_id,aim_board_id);
          END IF;

        END IF;

      ELSE /*miss*/
        INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'miss_attack');
      END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `buy_card`
--

DROP PROCEDURE IF EXISTS `buy_card`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `buy_card`(g_id INT,p_num INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE card_cost INT;
  DECLARE new_card INT;
  DECLARE first_card_id INT;
  DECLARE player_deck_id INT;
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_independent_message($p_num,"Купил карту")';
  DECLARE cmd_log_buyer VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_independent_message($p_num,"$card_name")';


  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
  SELECT cfg.`value` INTO card_cost FROM mode_config cfg WHERE cfg.param='card cost' AND cfg.mode_id=mode_id;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;/*Not your turn*/
  ELSE
    IF (SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id LIMIT 1)<>0 THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=28;/*polza/vred in progress*/
    ELSE
      IF (SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=1 THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=7;/*Already moved units*/
      ELSE
        IF (SELECT gold FROM players WHERE game_id=g_id AND player_num=p_num)<card_cost THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=2;/*Not enough gold*/
        ELSE
          IF NOT EXISTS (SELECT id FROM deck WHERE game_id=g_id) THEN
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=3;/*No cards left*/
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

            SET cmd_log=REPLACE(cmd_log,'$p_num',p_num);
            /*For all players except byer - without card name*/
            INSERT INTO command (game_id,player_num,command) VALUES(g_id,p_num,cmd_log);

            SET cmd_log_buyer=REPLACE(cmd_log_buyer,'$p_num',p_num);
            INSERT INTO command (game_id,player_num,command,hidden_flag)
              VALUES (g_id,p_num,REPLACE(cmd_log_buyer,'$card_name',(SELECT CONCAT(' (',name,')') FROM cards WHERE id=new_card LIMIT 1)),1);

            INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'buy_card');
            CALL end_turn(g_id,p_num);

            CALL user_action_end();
          END IF;
        END IF;
      END IF;
    END IF;
  END IF;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `calculate_attack_damage`
--

DROP PROCEDURE IF EXISTS `calculate_attack_damage`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `calculate_attack_damage`(board_unit_id INT,aim_type VARCHAR(45),aim_board_id INT, OUT attack_success INT, OUT damage INT, OUT critical INT)
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

/*select variant with highest priority from possible*/
  SELECT ab.dice_max,ab.chance,ab.critical_chance,ab.damage_bonus,ab.critical_bonus
    INTO dice_max,chance,critical_chance,damage_bonus,critical_bonus
    FROM attack_bonus ab
    WHERE ab.mode_id=g_mode
      AND (ab.unit_id=u_id OR ab.unit_id IS NULL)
      AND (ab.aim_type=aim_type OR ab.aim_type IS NULL)
      AND (ab.aim_id=aim_object_id OR ab.aim_id IS NULL)
    ORDER BY ab.priority DESC
    LIMIT 1;

  SELECT FLOOR(1 + (RAND() * dice_max)) INTO dice FROM DUAL;

  IF dice>=critical_chance THEN /*critical hit*/
    SET attack_success=1;
    SET critical=1;
    SET damage=CASE WHEN base_damage+critical_bonus>0 THEN base_damage+critical_bonus ELSE 0 END;
  ELSE
    IF dice>=chance THEN /*usual hit*/
      SET attack_success=1;
      SET critical=0;
      SET damage=CASE WHEN base_damage+damage_bonus>0 THEN base_damage+damage_bonus ELSE 0 END;
    ELSE /*miss*/
      SET attack_success=0;
      SET critical=0;
      SET damage=0;
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `castle_auto_repair`
--

DROP PROCEDURE IF EXISTS `castle_auto_repair`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `castle_auto_repair`(g_id INT,p_num INT)
BEGIN
  DECLARE board_building_id INT;
  DECLARE health_repair INT DEFAULT 1;
  DECLARE delta_health INT;
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_independent_message($p_num,"$log_building восстанавливает $log_health")';

  SELECT bb.id,bb.max_health-bb.health INTO board_building_id,delta_health FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.game_id=g_id AND bb.player_num=p_num AND b.`type`='castle' LIMIT 1;

  IF(delta_health>0)THEN
    SET health_repair=LEAST(health_repair,delta_health);

    UPDATE board_buildings SET health=health+health_repair WHERE id=board_building_id;
    CALL cmd_building_set_health(g_id,p_num,board_building_id);

    SET cmd_log=REPLACE(cmd_log,'$p_num',p_num);
    SET cmd_log=REPLACE(cmd_log,'$log_building',log_building(board_building_id));
    SET cmd_log=REPLACE(cmd_log,'$log_health',log_health(health_repair));
    INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cast_armageddon`
--

DROP PROCEDURE IF EXISTS `cast_armageddon`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_armageddon`(g_id INT,p_num INT,player_deck_id INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE board_building_id INT;
  DECLARE chance INT DEFAULT 2;

  DECLARE done INT DEFAULT 0;
  /*all game units except magic-resistant*/
  DECLARE cur CURSOR FOR SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id;
  /*all game buildings except castles*/
  DECLARE cur2 CURSOR FOR SELECT bb.id FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.game_id=g_id AND b.`type`<>'castle';
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;


  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_armageddon');
  IF err_code<>0 THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    CALL user_action_begin();

    CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card,update log*/

    OPEN cur;
    REPEAT
      FETCH cur INTO board_unit_id;
      IF NOT done THEN
        IF (SELECT FLOOR(1 + (RAND() * 6)) as `dice` FROM DUAL)>chance THEN
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
        IF (SELECT FLOOR(1 + (RAND() * 6)) as `dice` FROM DUAL)>chance THEN
          CALL destroy_building(board_building_id,p_num);
        END IF;
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur2;

    CALL finish_playing_card(g_id,p_num);
    CALL end_turn(g_id,p_num);

    CALL user_action_end();
  END IF;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cast_eagerness`
--

DROP PROCEDURE IF EXISTS `cast_eagerness`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_eagerness`(g_id INT,p_num INT,player_deck_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE attack_bonus INT DEFAULT 2;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_eagerness');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;

      IF (SELECT FLOOR(1 + (RAND() * 6)) as `dice` FROM DUAL)<=3 THEN
        CALL unit_add_attack(board_unit_id,attack_bonus);
      ELSE
      /*knight move*/
        UPDATE board_units SET moves=1,moves_left=1 WHERE id=board_unit_id;
        CALL unit_feature_set(board_unit_id,'knight',null);
        CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);
        CALL cmd_unit_add_effect(g_id,board_unit_id,'knight');
      END IF;

      CALL finish_playing_card(g_id,p_num);
      CALL end_turn(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cast_fireball`
--

DROP PROCEDURE IF EXISTS `cast_fireball`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_fireball`(g_id INT,p_num INT,player_deck_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE fb_damage INT DEFAULT 1;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_fireball');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

      IF (SELECT FLOOR(1 + (RAND() * 6)) as `dice` FROM DUAL)<3 THEN
        CALL cmd_miss_game_log(g_id,x,y);
      ELSE
        CALL magical_damage(g_id,p_num,x,y,fb_damage);
      END IF;

      INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'magical_attack');

      CALL finish_playing_card(g_id,p_num);
      CALL end_turn(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cast_half_money`
--

DROP PROCEDURE IF EXISTS `cast_half_money`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
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

    CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

/*half division*/
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
    CALL end_turn(g_id,p_num);

    CALL user_action_end();
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cast_healing`
--

DROP PROCEDURE IF EXISTS `cast_healing`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_healing`(g_id INT,p_num INT,player_deck_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE hp_heal INT DEFAULT 1;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_healing');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

      CALL magical_heal(g_id,p_num,x,y,hp_heal);

      CALL finish_playing_card(g_id,p_num);
      CALL end_turn(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cast_lightening_max`
--

DROP PROCEDURE IF EXISTS `cast_lightening_max`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_lightening_max`(g_id INT,p_num INT,player_deck_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE li_damage INT DEFAULT 3;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_lightening_max');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

      IF (SELECT FLOOR(1 + (RAND() * 6)) as `dice` FROM DUAL)<4 THEN
        CALL cmd_miss_game_log(g_id,x,y);
      ELSE
        CALL magical_damage(g_id,p_num,x,y,li_damage);
      END IF;

      INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'magical_attack');

      CALL finish_playing_card(g_id,p_num);
      CALL end_turn(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cast_lightening_min`
--

DROP PROCEDURE IF EXISTS `cast_lightening_min`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_lightening_min`(g_id INT,p_num INT,player_deck_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE li_damage INT DEFAULT 2;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_lightening_min');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

      IF (SELECT FLOOR(1 + (RAND() * 6)) as `dice` FROM DUAL)<3 THEN
        CALL cmd_miss_game_log(g_id,x,y);
      ELSE
        CALL magical_damage(g_id,p_num,x,y,li_damage);
      END IF;

      INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'magical_attack');

      CALL finish_playing_card(g_id,p_num);
      CALL end_turn(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cast_madness`
--

DROP PROCEDURE IF EXISTS `cast_madness`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_madness`(g_id INT,p_num INT,player_deck_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_madness');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;

      CALL make_mad(board_unit_id);

      CALL finish_playing_card(g_id,p_num);
      CALL end_turn(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cast_meteor_shower`
--

DROP PROCEDURE IF EXISTS `cast_meteor_shower`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
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
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=23;/*Aim out of deck*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

      OPEN cur;
      REPEAT
        FETCH cur INTO x1,y1,aim_type,aim_id;
        IF NOT done THEN
          /*check whether aim is still alive*/
          IF((aim_type='unit' AND EXISTS(SELECT bu.id FROM board_units bu WHERE bu.id=aim_id LIMIT 1))
            OR(aim_type='building' AND EXISTS(SELECT bb.id FROM board_buildings bb WHERE bb.id=aim_id LIMIT 1)))THEN
            CALL magical_damage(g_id,p_num,x1,y1,meteor_damage);
          END IF;
        END IF;
      UNTIL done END REPEAT;
      CLOSE cur;

      CALL finish_playing_card(g_id,p_num);
      CALL end_turn(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cast_mind_control`
--

DROP PROCEDURE IF EXISTS `cast_mind_control`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_mind_control`(g_id INT,p_num INT,player_deck_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE p2_num INT;
  DECLARE dice INT;
  DECLARE npc_gold INT;
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit начинает подчиняться игроку $log_player")';

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_mind_control');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;
      SELECT bu.player_num INTO p2_num FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

      SELECT FLOOR(1 + (RAND() * 6)) INTO dice FROM DUAL;
      IF (dice<=3) THEN /*make mad*/
        CALL make_mad(board_unit_id);
      ELSE

/*remove necromancer control from unit*/
        IF(unit_feature_check(board_unit_id,'under_control')=1)THEN
          CALL unit_feature_remove(board_unit_id,'under_control');
        END IF;

/*if unit was mad - it becomes not mad*/
        IF(unit_feature_check(board_unit_id,'madness')=1)THEN
          CALL unit_feature_set(board_unit_id,'madness',p_num);
          CALL make_not_mad(board_unit_id);
        END IF;

/*change owner*/
        IF(p_num<>p2_num)THEN
          UPDATE board_units SET player_num=p_num WHERE id=board_unit_id;
          CALL cmd_unit_set_owner(g_id,p_num,board_unit_id);

/*if it was npc*/
          IF (((SELECT owner FROM players WHERE game_id=g_id AND player_num=p2_num LIMIT 1)<>1)
            AND NOT EXISTS (SELECT id FROM board_units WHERE game_id=g_id AND player_num=p2_num)
            AND NOT EXISTS (SELECT id FROM board_buildings WHERE game_id=g_id AND player_num=p2_num))
          THEN
            SELECT gold INTO npc_gold FROM players WHERE game_id=g_id AND player_num=p2_num LIMIT 1; /*take npc gold*/
            IF(npc_gold>0)THEN
              UPDATE players SET gold=gold+npc_gold WHERE game_id=g_id AND player_num=p_num;
              CALL cmd_player_set_gold(g_id,p_num);
            END IF;

            DELETE FROM players WHERE game_id=g_id AND player_num=p2_num; /*delete npc player*/
            CALL cmd_delete_player(g_id,p2_num);
          END IF;

        ELSE
          SET cmd_log=REPLACE(cmd_log,'начинает','продолжает');
        END IF;

/*zombies change player too*/
        IF EXISTS(SELECT id FROM board_units_features WHERE feature_id=unit_feature_get_id_by_code('under_control') AND param=board_unit_id LIMIT 1)THEN
          CALL zombies_change_player_to_nec(board_unit_id);
        END IF;


/*log*/
        SET cmd_log=REPLACE(cmd_log,'$log_unit',log_unit(board_unit_id));
        SET cmd_log=REPLACE(cmd_log,'$log_player',log_player(g_id,p_num));
        INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

      END IF;

      CALL finish_playing_card(g_id,p_num);
      CALL end_turn(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cast_o_d`
--

DROP PROCEDURE IF EXISTS `cast_o_d`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_o_d`(g_id INT,p_num INT,player_deck_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE shield INT;
  DECLARE dice INT;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_o_d');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;
      SELECT bu.shield INTO shield FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

      IF (unit_feature_check(board_unit_id,'magic_immunity')=0) THEN /*if not magic-resistant*/

        SELECT FLOOR(1 + (RAND() * 6)) INTO dice FROM DUAL;

        IF dice=5 THEN /*total heal*/
          CALL total_heal(board_unit_id);
        ELSE
          IF shield>0 THEN
            CALL shield_off(board_unit_id);
          ELSE
            IF dice=6 THEN /*madness*/
              CALL make_mad(board_unit_id);
            ELSE /*kill*/
              CALL kill_unit(board_unit_id,p_num);
            END IF;
          END IF;
        END IF;
      ELSE
        CALL cmd_magic_resistance_log(g_id,p_num,board_unit_id);
      END IF;

      CALL finish_playing_card(g_id,p_num);
      CALL end_turn(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cast_paralich`
--

DROP PROCEDURE IF EXISTS `cast_paralich`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_paralich`(g_id INT,p_num INT,player_deck_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE shield INT;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_paralich');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;
      SELECT bu.shield INTO shield FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

      IF (unit_feature_check(board_unit_id,'magic_immunity')=0) THEN /*if not magic-resistant*/
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
      CALL end_turn(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cast_polza_main`
--

DROP PROCEDURE IF EXISTS `cast_polza_main`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_polza_main`(g_id INT,p_num INT,player_deck_id INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE err_code INT;
  DECLARE dice INT;
  DECLARE nonfinished_action INT DEFAULT 0;
  DECLARE riching_sum INT DEFAULT 60;
  DECLARE take_cards_qty INT DEFAULT 2;
  DECLARE cmd_log_1 VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Польза: Починить здания")';
  DECLARE cmd_log_2 VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Польза: Воскресить любого юнита")';
  DECLARE cmd_log_3 VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Польза: +60 золота")';
  DECLARE cmd_log_4 VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Польза: Взять 2 карты")';
  DECLARE cmd_log_5 VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Польза: Переместить всех юнитов из выбранной зоны")';
  DECLARE cmd_log_6 VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Польза: Переместить и присвоить чужое здание")';
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'execute_procedure("$cmd_name")';

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_polza_main');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    CALL user_action_begin();

    CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

    SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;

    SELECT FLOOR(1 + (RAND() * 6)) INTO dice FROM DUAL;
-- set dice=2;
    CASE dice

      WHEN 1 THEN
        INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log_1);
        CALL repair_buildings(g_id,p_num);

      WHEN 2 THEN /*resurrect*/
      BEGIN
        DECLARE x_appear,y_appear,x_dir,y_dir INT;
        DECLARE size INT;

        INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log_2);
        SELECT MIN(g.size) INTO size FROM vw_grave g WHERE g.game_id=g_id;
        IF size IS NOT NULL THEN
          SELECT ap.x,ap.y,ap.direction_into_board_x,ap.direction_into_board_y INTO x_appear,y_appear,x_dir,y_dir FROM appear_points ap WHERE ap.mode_id=mode_id AND ap.player_num=p_num;
          IF NOT EXISTS(SELECT id FROM board WHERE game_id=g_id AND x BETWEEN LEAST(x_appear,x_appear+x_dir*(size-1)) AND GREATEST(x_appear,x_appear+x_dir*(size-1)) AND y BETWEEN LEAST(y_appear,y_appear+y_dir*(size-1)) AND GREATEST(y_appear,y_appear+y_dir*(size-1)) LIMIT 1) THEN
            SET nonfinished_action=1;
          END IF;
        END IF;
      END;

      WHEN 3 THEN /*+60$*/
        INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log_3);
        UPDATE players SET gold=gold+riching_sum WHERE game_id=g_id AND player_num=p_num;
        CALL cmd_player_set_gold(g_id,p_num);

      WHEN 4 THEN /*take 2 cards*/
        INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log_4);
        BEGIN
          DECLARE new_card INT;
          DECLARE first_card_id INT;
          DECLARE player_deck_id INT;
          DECLARE cmd_log_buyer VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Новая карта <b class=\'logCard\'>$card_name</b>")';
          DECLARE cmd_no_cards VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Карт больше нет")';

          WHILE take_cards_qty>0 AND EXISTS(SELECT id FROM deck WHERE game_id=g_id LIMIT 1) DO
            SET take_cards_qty=take_cards_qty-1;

            SELECT MIN(id) INTO first_card_id FROM deck WHERE game_id=g_id;
            SELECT card_id INTO new_card FROM deck WHERE game_id=g_id AND id=first_card_id;
            INSERT INTO player_deck (game_id,player_num,card_id) VALUES (g_id,p_num,new_card);
            SET player_deck_id=@@last_insert_id;
            DELETE FROM deck WHERE game_id=g_id AND id=first_card_id;

            CALL cmd_add_card(g_id,p_num,player_deck_id);

            INSERT INTO command (game_id,player_num,command,hidden_flag) VALUES (g_id,p_num,REPLACE(cmd_log_buyer,'$card_name',(SELECT name FROM cards WHERE id=new_card LIMIT 1)),1);
            IF (take_cards_qty>0) AND NOT EXISTS (SELECT id FROM deck WHERE game_id=g_id LIMIT 1) THEN
              INSERT INTO command (game_id,player_num,command,hidden_flag) VALUES (g_id,p_num,cmd_no_cards,1);
            END IF;
          END WHILE;
        END;

      WHEN 5 THEN /*units from zone*/
        INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log_5);
        IF EXISTS(SELECT id FROM board_units WHERE game_id=g_id LIMIT 1) THEN
          SET nonfinished_action=2;
        END IF;

      WHEN 6 THEN /*move and own building*/
        INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log_6);
        IF EXISTS(SELECT bb.id FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.game_id=g_id AND bb.player_num<>p_num AND b.`type`<>'castle' LIMIT 1) THEN
          SET nonfinished_action=3;
        END IF;
    END CASE;

    IF(nonfinished_action=0)THEN
      CALL finish_playing_card(g_id,p_num);
      CALL end_turn(g_id,p_num);
    ELSE
      UPDATE active_players SET nonfinished_action_id=nonfinished_action WHERE game_id=g_id AND player_num=p_num;
      SET cmd=REPLACE(cmd,'$cmd_name',(SELECT command_procedure FROM nonfinished_actions_dictionary WHERE id=nonfinished_action LIMIT 1));
      INSERT INTO command (game_id,player_num,command,hidden_flag) VALUES (g_id,p_num,cmd,2);
    END IF;

    CALL user_action_end();
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cast_polza_move_building`
--

DROP PROCEDURE IF EXISTS `cast_polza_move_building`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_polza_move_building`(g_id INT,p_num INT,b_x INT,b_y INT,x INT,y INT,rot INT,flp INT)
BEGIN
  DECLARE nonfinished_action INT DEFAULT 3;
  DECLARE board_building_id INT;
  DECLARE p2_num INT;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;/*Not your turn*/
  ELSE
    IF NOT nonfinished_action=(SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=24;/*Can't finish nonfinished action*/
    ELSE
      SELECT b.ref INTO board_building_id FROM board b WHERE b.game_id=g_id AND b.`type` IN ('building','obstacle') AND b.x=b_x AND b.y=b_y LIMIT 1;
      IF board_building_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=26;/*Not a building*/
      ELSE
        SELECT bb.player_num INTO p2_num FROM board_buildings bb WHERE bb.id=board_building_id LIMIT 1;
        IF p2_num=p_num THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=27;/*Not an enemy building*/
        ELSE
          CALL user_action_begin();

          /*set ref=0 to identify if building has been moved*/
          UPDATE board SET ref=0 WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=board_building_id;

          CALL place_building_on_board(board_building_id,x,y,rot,flp);

          IF NOT EXISTS(SELECT id FROM board WHERE game_id=g_id AND `type`<>'unit' AND ref=board_building_id) THEN /*Building not placed*/
            UPDATE board SET ref=board_building_id WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0;
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=12;/*Place occupied*/
          ELSE
          /*Building has been moved successfully*/
            DELETE FROM board WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0; /*Del old coords*/

            UPDATE board_buildings SET player_num=p_num,rotation=rot,flip=flp WHERE id=board_building_id;

            CALL count_income(board_building_id);

            CALL cmd_move_building(g_id,p_num,b_x,b_y,board_building_id);
            CALL cmd_building_set_owner(g_id,p_num,board_building_id);


            UPDATE command SET hidden_flag=1 WHERE game_id=g_id AND player_num=p_num AND hidden_flag=2;
            UPDATE active_players SET nonfinished_action_id=0 WHERE game_id=g_id AND player_num=p_num;

            CALL finish_playing_card(g_id,p_num);
            CALL end_turn(g_id,p_num);

            CALL user_action_end();
          END IF;
        END IF;
      END IF;
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cast_polza_resurrect`
--

DROP PROCEDURE IF EXISTS `cast_polza_resurrect`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_polza_resurrect`(g_id INT,p_num INT,grave_id INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE nonfinished_action INT DEFAULT 1;
  DECLARE x_appear,y_appear,x_dir,y_dir INT;
  DECLARE size INT;
  DECLARE u_id INT;
  DECLARE dead_card_id INT;

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;/*Not your turn*/
  ELSE
    IF NOT nonfinished_action=(SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=24;/*Can't finish nonfinished action*/
    ELSE
      IF NOT EXISTS(SELECT id FROM graves WHERE game_id=g_id AND id=grave_id LIMIT 1) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=8;/*Card not in grave*/
      ELSE
          CALL user_action_begin();

          SELECT g.card_id INTO dead_card_id FROM graves g WHERE id=grave_id;
          SELECT ap.x,ap.y,ap.direction_into_board_x,ap.direction_into_board_y INTO x_appear,y_appear,x_dir,y_dir FROM appear_points ap WHERE ap.mode_id=mode_id AND ap.player_num=p_num;
          SELECT u.id,u.size INTO u_id,size FROM cards c JOIN units u ON c.ref=u.id WHERE c.id=dead_card_id LIMIT 1;
          IF EXISTS(SELECT id FROM board WHERE game_id=g_id AND x BETWEEN LEAST(x_appear,x_appear+x_dir*(size-1)) AND GREATEST(x_appear,x_appear+x_dir*(size-1)) AND y BETWEEN LEAST(y_appear,y_appear+y_dir*(size-1)) AND GREATEST(y_appear,y_appear+y_dir*(size-1)) LIMIT 1) THEN
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=9;/*Appear point occupied*/
          ELSE

            CALL resurrect(g_id,p_num,grave_id);
            CALL cmd_resurrect_by_card_log(g_id,p_num,dead_card_id);

            UPDATE command SET hidden_flag=1 WHERE game_id=g_id AND player_num=p_num AND hidden_flag=2;
            UPDATE active_players SET nonfinished_action_id=0 WHERE game_id=g_id AND player_num=p_num;

            CALL finish_playing_card(g_id,p_num);
            CALL end_turn(g_id,p_num);

            CALL user_action_end();
          END IF;
      END IF;
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cast_polza_units_from_zone`
--

DROP PROCEDURE IF EXISTS `cast_polza_units_from_zone`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_polza_units_from_zone`(g_id INT,p_num INT,zone INT)
BEGIN
  DECLARE nonfinished_action INT DEFAULT 2;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;/*Not your turn*/
  ELSE
    IF NOT nonfinished_action=(SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=24;/*Can't finish nonfinished action*/
    ELSE
      IF zone NOT IN(0,1,2,3) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=25;/*Invalid zone*/
      ELSE
            CALL user_action_begin();

            CALL units_from_zone(g_id,zone);

            UPDATE command SET hidden_flag=1 WHERE game_id=g_id AND player_num=p_num AND hidden_flag=2;
            UPDATE active_players SET nonfinished_action_id=0 WHERE game_id=g_id AND player_num=p_num;

            CALL finish_playing_card(g_id,p_num);
            CALL end_turn(g_id,p_num);

            CALL user_action_end();
      END IF;
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cast_pooring`
--

DROP PROCEDURE IF EXISTS `cast_pooring`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_pooring`(g_id INT,p_num INT,player_deck_id INT,p2_num INT)
BEGIN
  DECLARE err_code INT;
  DECLARE pooring_sum INT DEFAULT 50;
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_player теряет $log_gold")';

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_pooring');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT id FROM players WHERE game_id=g_id AND player_num=p2_num) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=13;/*Player doesn't exist*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

/*pooring*/
      UPDATE players SET gold=CASE WHEN gold<pooring_sum THEN 0 ELSE gold-pooring_sum END WHERE game_id=g_id AND player_num=p2_num;
      CALL cmd_player_set_gold(g_id,p2_num);

      SET cmd_log=REPLACE(cmd_log,'$log_player',log_player(g_id,p2_num));
      SET cmd_log=REPLACE(cmd_log,'$log_gold',log_gold(pooring_sum));

      INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

      CALL finish_playing_card(g_id,p_num);
      CALL end_turn(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cast_repair_buildings`
--

DROP PROCEDURE IF EXISTS `cast_repair_buildings`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_repair_buildings`(g_id INT,p_num INT,player_deck_id INT)
BEGIN
  DECLARE err_code INT;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_repair_buildings');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    CALL user_action_begin();

    CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

    CALL repair_buildings(g_id,p_num);

    CALL finish_playing_card(g_id,p_num);
    CALL end_turn(g_id,p_num);

    CALL user_action_end();
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cast_riching`
--

DROP PROCEDURE IF EXISTS `cast_riching`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_riching`(g_id INT,p_num INT,player_deck_id INT)
BEGIN
  DECLARE err_code INT;
  DECLARE riching_sum INT DEFAULT 50;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_riching');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    CALL user_action_begin();

    CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

/*player gold*/
    UPDATE players SET gold=gold+riching_sum WHERE game_id=g_id AND player_num=p_num;
    CALL cmd_player_set_gold(g_id,p_num);

    CALL finish_playing_card(g_id,p_num);
    CALL end_turn(g_id,p_num);

    CALL user_action_end();
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cast_russian_ruletka`
--

DROP PROCEDURE IF EXISTS `cast_russian_ruletka`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_russian_ruletka`(g_id INT,p_num INT,player_deck_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_russian_ruletka');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

      SELECT ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;

      IF (SELECT FLOOR(1 + (RAND() * 6)) as `dice` FROM DUAL)<6 THEN
        CALL cmd_miss_russian_rul(board_unit_id);
      ELSE
        CALL kill_unit(board_unit_id,p_num);
      END IF;

      CALL finish_playing_card(g_id,p_num);
      CALL end_turn(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cast_shield`
--

DROP PROCEDURE IF EXISTS `cast_shield`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_shield`(g_id INT,p_num INT,player_deck_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_shield');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;

      CALL magical_shield_on(g_id,p_num,x,y);

      CALL finish_playing_card(g_id,p_num);
      CALL end_turn(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cast_show_cards`
--

DROP PROCEDURE IF EXISTS `cast_show_cards`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_show_cards`(g_id INT,p_num INT,player_deck_id INT,p2_num INT)
BEGIN
  DECLARE err_code INT;
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Карты игрока $log_player:")';
  DECLARE cmd_log_card VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("<b class=\'logCard\'>$card_name</b>")';
  DECLARE card_name VARCHAR(1000) CHARSET utf8;

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT c.name FROM player_deck pd JOIN cards c ON (pd.card_id=c.id) WHERE pd.game_id=g_id AND pd.player_num=p2_num;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;


  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_show_cards');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT id FROM players WHERE game_id=g_id AND player_num=p2_num) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=13;/*Player doesn't exist*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

      SET cmd_log=REPLACE(cmd_log,'$log_player',log_player(g_id,p2_num));
      INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

      OPEN cur;
      REPEAT
        FETCH cur INTO card_name;
        IF NOT done THEN
          INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,REPLACE(cmd_log_card,'$card_name',card_name));
        END IF;
      UNTIL done END REPEAT;
      CLOSE cur;

      CALL finish_playing_card(g_id,p_num);
      CALL end_turn(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cast_speeding`
--

DROP PROCEDURE IF EXISTS `cast_speeding`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_speeding`(g_id INT,p_num INT,player_deck_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE speed_bonus INT DEFAULT 2;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_speeding');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;

      CALL unit_add_moves(board_unit_id,speed_bonus);

      CALL finish_playing_card(g_id,p_num);
      CALL end_turn(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cast_telekinesis`
--

DROP PROCEDURE IF EXISTS `cast_telekinesis`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_telekinesis`(g_id INT,p_num INT,player_deck_id INT,p2_num INT)
BEGIN
  DECLARE err_code INT;
  DECLARE rand_card INT;
  DECLARE big_dice INT;
  DECLARE stolen_card_id INT;
  DECLARE stolen_card_name VARCHAR(45) CHARSET utf8;
  DECLARE cmd_log_p VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Новая карта <b class=\'logCard\'>$card_name</b>")';
  DECLARE cmd_log_p2 VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Похищена карта <b class=\'logCard\'>$card_name</b>")';

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_telekinesis');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT id FROM players WHERE game_id=g_id AND player_num=p2_num) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=13;/*Player doesn't exist*/
    ELSE
      IF NOT EXISTS(SELECT id FROM player_deck WHERE game_id=g_id AND player_num=p2_num LIMIT 1) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=22;/*Player doesn't have cards*/
      ELSE
        CALL user_action_begin();

        CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

        CREATE TEMPORARY TABLE pl_cards (id_rand INT AUTO_INCREMENT PRIMARY KEY)AUTO_INCREMENT=1 SELECT id AS `pd_id` FROM player_deck WHERE game_id=g_id AND player_num=p2_num;
        SELECT FLOOR(1 + (RAND() * MAX(id_rand))) INTO big_dice FROM pl_cards;
        SELECT pd_id INTO rand_card FROM pl_cards WHERE id_rand=big_dice LIMIT 1;
        DROP TEMPORARY TABLE pl_cards;

        SELECT card_id INTO stolen_card_id FROM player_deck WHERE id=rand_card;
        UPDATE player_deck SET player_num=p_num WHERE id=rand_card;
        CALL cmd_remove_card(g_id,p2_num,rand_card);
        CALL cmd_add_card(g_id,p_num,rand_card);

        SELECT name INTO stolen_card_name FROM cards WHERE id=stolen_card_id LIMIT 1;
        SET cmd_log_p=REPLACE(cmd_log_p,'$card_name',stolen_card_name);
        INSERT INTO command (game_id,player_num,command,hidden_flag) VALUES (g_id,p_num,cmd_log_p,1);
        SET cmd_log_p2=REPLACE(cmd_log_p2,'$card_name',stolen_card_name);
        INSERT INTO command (game_id,player_num,command,hidden_flag) VALUES (g_id,p2_num,cmd_log_p2,1);

        CALL finish_playing_card(g_id,p_num);
        CALL end_turn(g_id,p_num);

        CALL user_action_end();
      END IF;
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cast_teleport`
--

DROP PROCEDURE IF EXISTS `cast_teleport`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
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
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
    ELSE
      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;
      SELECT bu.unit_id,u.size INTO u_id,size FROM board_units bu JOIN units u ON (bu.unit_id=u.id) WHERE bu.id=board_unit_id LIMIT 1;

      IF EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x BETWEEN x2 AND x2+size-1 AND b.y BETWEEN y2 AND y2+size-1 AND NOT(b.`type`='unit' AND b.ref=board_unit_id) LIMIT 1) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=12;/*Place occupied*/
      ELSE
        CALL user_action_begin();

        CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

        IF (unit_feature_check(board_unit_id,'magic_immunity')=0) THEN /*if not magic-resistant*/

          IF (unit_feature_get_param(board_unit_id,'bind_target') IS NOT NULL) THEN /*if taran is binded to another unit - unbind it*/
            CALL unit_feature_remove(board_unit_id,'bind_target');
          END IF; /*unbind taran*/

          CALL move_unit(board_unit_id,x2,y2);

          /*unbind all units binded to this unit*/
          DELETE FROM board_units_features WHERE feature_id=unit_feature_get_id_by_code('bind_target') AND param=board_unit_id;

        ELSE
          CALL cmd_magic_resistance_log(g_id,p_num,board_unit_id);
        END IF;

        CALL finish_playing_card(g_id,p_num);
        CALL end_turn(g_id,p_num);

        CALL user_action_end();
      END IF;
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cast_unit_upgrade_all`
--

DROP PROCEDURE IF EXISTS `cast_unit_upgrade_all`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_unit_upgrade_all`(g_id INT,p_num INT,player_deck_id INT,x INT,y INT)
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
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;

      CALL unit_add_moves(board_unit_id,speed_bonus);
      CALL unit_add_health(board_unit_id,health_bonus);
      CALL unit_add_attack(board_unit_id,attack_bonus);

      CALL finish_playing_card(g_id,p_num);
      CALL end_turn(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cast_unit_upgrade_random`
--

DROP PROCEDURE IF EXISTS `cast_unit_upgrade_random`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_unit_upgrade_random`(g_id INT,p_num INT,player_deck_id INT,x INT,y INT)
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
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;

      SELECT FLOOR(1 + (RAND() * 3)) INTO dice FROM DUAL;
      IF dice=1 THEN
        CALL unit_add_moves(board_unit_id,speed_bonus);
      END IF;
      IF dice=2 THEN
        CALL unit_add_health(board_unit_id,health_bonus);
      END IF;
      IF dice=3 THEN
        CALL unit_add_attack(board_unit_id,attack_bonus);
      END IF;

      CALL finish_playing_card(g_id,p_num);
      CALL end_turn(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cast_vampire`
--

DROP PROCEDURE IF EXISTS `cast_vampire`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_vampire`(g_id INT,p_num INT,player_deck_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE mode_id INT;
  DECLARE vamp_ui_code VARCHAR(45) CHARSET utf8 DEFAULT 'vampire'; /*use this to find vampire unit in current mode*/
  DECLARE vamp_u_id INT;
  DECLARE vamp_owner INT DEFAULT 4;
  DECLARE team INT;
  DECLARE new_player INT;
  DECLARE vamp_name VARCHAR(45) CHARSET utf8;
  DECLARE new_unit_id INT;
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("В клетке $log_cell появляется $log_unit")';

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_vampire');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF (quart(x,y)<>p_num) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=35;/*Can summon vampire only in my zone*/
    ELSE
      IF EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y LIMIT 1) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=9;/*Appear point occupied*/
      ELSE
/*OK*/
        CALL user_action_begin();

        CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

        SELECT MAX(p.team)+1 INTO team FROM players p WHERE p.game_id=g_id;
        SELECT CASE WHEN MAX(p.player_num)<10 THEN 10 ELSE MAX(p.player_num)+1 END INTO new_player FROM players p WHERE p.game_id=g_id;

        SELECT vu.id INTO vamp_u_id FROM vw_mode_units vu WHERE vu.mode_id=mode_id AND vu.ui_code=vamp_ui_code;
        SELECT name INTO vamp_name FROM units WHERE id=vamp_u_id LIMIT 1;

        INSERT INTO players(game_id,player_num,name,gold,owner,team) VALUES(g_id,new_player,vamp_name,0,vamp_owner,team);
        CALL cmd_add_player(g_id,new_player);

        INSERT INTO board_units(game_id,player_num,unit_id) VALUES(g_id,new_player,vamp_u_id);
        SET new_unit_id=@@last_insert_id;
        INSERT INTO board_units_features(board_unit_id,feature_id,param) SELECT new_unit_id,ufu.feature_id,ufu.param FROM unit_default_features ufu WHERE ufu.unit_id=vamp_u_id;

        INSERT INTO board(game_id,x,y,`type`,ref) VALUES (g_id,x,y,'unit',new_unit_id);

        CALL cmd_add_unit_by_id(g_id,new_player,new_unit_id);

/*log*/
        SET cmd_log=REPLACE(cmd_log,'$log_unit',log_unit(new_unit_id));
        SET cmd_log=REPLACE(cmd_log,'$log_cell',log_cell(x,y));
        INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

        CALL finish_playing_card(g_id,p_num);
        CALL end_turn(g_id,p_num);

        CALL user_action_end();
      END IF;
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cast_vred_destroy_building`
--

DROP PROCEDURE IF EXISTS `cast_vred_destroy_building`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_vred_destroy_building`(g_id INT,p_num INT,x INT,y INT)
BEGIN
  DECLARE nonfinished_action INT DEFAULT 6;
  DECLARE board_building_id INT;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;/*Not your turn*/
  ELSE
    IF NOT nonfinished_action=(SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=24;/*Can't finish nonfinished action*/
    ELSE
      SELECT b.ref INTO board_building_id FROM board b WHERE b.game_id=g_id AND b.`type` IN ('building','obstacle') AND b.x=x AND b.y=y LIMIT 1;
      IF board_building_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=26;/*Not a building*/
      ELSE
        CALL user_action_begin();

        CALL destroy_building(board_building_id,p_num);

        UPDATE command SET hidden_flag=1 WHERE game_id=g_id AND player_num=p_num AND hidden_flag=2;
        UPDATE active_players SET nonfinished_action_id=0 WHERE game_id=g_id AND player_num=p_num;

        CALL finish_playing_card(g_id,p_num);
        CALL end_turn(g_id,p_num);

        CALL user_action_end();
      END IF;
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cast_vred_kill_unit`
--

DROP PROCEDURE IF EXISTS `cast_vred_kill_unit`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_vred_kill_unit`(g_id INT,p_num INT,x INT,y INT)
BEGIN
  DECLARE nonfinished_action INT DEFAULT 5;
  DECLARE board_unit_id INT;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;/*Not your turn*/
  ELSE
    IF NOT nonfinished_action=(SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=24;/*Can't finish nonfinished action*/
    ELSE
      IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
      ELSE
        CALL user_action_begin();

        SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;

        CALL magic_kill_unit(board_unit_id,p_num);

        UPDATE command SET hidden_flag=1 WHERE game_id=g_id AND player_num=p_num AND hidden_flag=2;
        UPDATE active_players SET nonfinished_action_id=0 WHERE game_id=g_id AND player_num=p_num;

        CALL finish_playing_card(g_id,p_num);
        CALL end_turn(g_id,p_num);

        CALL user_action_end();
      END IF;
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cast_vred_main`
--

DROP PROCEDURE IF EXISTS `cast_vred_main`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_vred_main`(g_id INT,p_num INT,player_deck_id INT)
BEGIN
  DECLARE err_code INT;
  DECLARE dice INT;
  DECLARE nonfinished_action INT DEFAULT 0;
  DECLARE pooring_sum INT DEFAULT 60;
  DECLARE take_cards_qty INT DEFAULT 1;
  DECLARE cmd_log_1 VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Вред: -60 золота выбранному игроку")';
  DECLARE cmd_log_2 VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Вред: Убить любого юнита")';
  DECLARE cmd_log_3 VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Вред: Разрушить любое здание")';
  DECLARE cmd_log_4 VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Вред: Переместить всех юнитов в случайную зону")';
  DECLARE cmd_log_5 VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Вред: Случайный игрок тянет у всех по карте")';
  DECLARE cmd_log_6 VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Вред: Переместить чужое здание")';
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'execute_procedure("$cmd_name")';

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_vred_main');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    CALL user_action_begin();

    CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

    SELECT FLOOR(1 + (RAND() * 6)) INTO dice FROM DUAL;
-- set dice=6;
    CASE dice

      WHEN 1 THEN /* -60$ to player */
        INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log_1);
        SET nonfinished_action=4;

      WHEN 2 THEN /*kill unit*/
        INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log_2);
        IF EXISTS(SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id AND unit_feature_check(bu.id,'magic_immunity')=0 LIMIT 1) THEN
          SET nonfinished_action=5;
        END IF;

      WHEN 3 THEN /*destroy building*/
        INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log_3);
        IF EXISTS(SELECT bb.id FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.game_id=g_id AND b.`type`<>'castle' LIMIT 1) THEN
          SET nonfinished_action=6;
        END IF;

      WHEN 4 THEN /*units to random zone*/
      BEGIN
        DECLARE zone INT;

        INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log_4);
        SELECT FLOOR(RAND() * 4) INTO zone FROM DUAL;
        CALL units_to_zone(g_id,zone);
      END;

      WHEN 5 THEN /*random player takes a card from everyone*/
      BEGIN
        DECLARE random_player INT;

        INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log_5);

        SELECT player_num INTO random_player FROM players WHERE game_id=g_id AND player_num IN(0,1,2,3) AND owner<>0 ORDER BY RAND() LIMIT 1;
        CALL vred_player_takes_card_from_everyone(g_id,random_player);
      END;

      WHEN 6 THEN /*move enemy building*/
        INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log_6);
        IF EXISTS(SELECT bb.id FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.game_id=g_id AND bb.player_num<>p_num AND b.`type`<>'castle' LIMIT 1) THEN
          SET nonfinished_action=7;
        END IF;

    END CASE;

    IF(nonfinished_action=0)THEN
      CALL finish_playing_card(g_id,p_num);
      CALL end_turn(g_id,p_num);
    ELSE
      UPDATE active_players SET nonfinished_action_id=nonfinished_action WHERE game_id=g_id AND player_num=p_num;
      SET cmd=REPLACE(cmd,'$cmd_name',(SELECT command_procedure FROM nonfinished_actions_dictionary WHERE id=nonfinished_action LIMIT 1));
      INSERT INTO command (game_id,player_num,command,hidden_flag) VALUES (g_id,p_num,cmd,2);
    END IF;

    CALL user_action_end();
  END IF;


END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cast_vred_move_building`
--

DROP PROCEDURE IF EXISTS `cast_vred_move_building`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_vred_move_building`(g_id INT,p_num INT,b_x INT,b_y INT,x INT,y INT,rot INT,flp INT)
BEGIN
  DECLARE nonfinished_action INT DEFAULT 7;
  DECLARE board_building_id INT;
  DECLARE p2_num INT;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;/*Not your turn*/
  ELSE
    IF NOT nonfinished_action=(SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=24;/*Can't finish nonfinished action*/
    ELSE
      SELECT b.ref INTO board_building_id FROM board b WHERE b.game_id=g_id AND b.`type` IN ('building','obstacle') AND b.x=b_x AND b.y=b_y LIMIT 1;
      IF board_building_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=26;/*Not a building*/
      ELSE
        SELECT bb.player_num INTO p2_num FROM board_buildings bb WHERE bb.id=board_building_id LIMIT 1;
        IF p2_num=p_num THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=27;/*Not an enemy building*/
        ELSE
          CALL user_action_begin();

          /*set ref=0 to identify if building has been moved*/
          UPDATE board SET ref=0 WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=board_building_id;

          CALL place_building_on_board(board_building_id,x,y,rot,flp);

          IF NOT EXISTS(SELECT id FROM board WHERE game_id=g_id AND `type`<>'unit' AND ref=board_building_id) THEN /*Building not placed*/
            UPDATE board SET ref=board_building_id WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0;
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=12;/*Place occupied*/
          ELSE
          /*Building has been moved successfully*/
            DELETE FROM board WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0; /*Del old coords*/

            UPDATE board_buildings SET rotation=rot,flip=flp WHERE id=board_building_id;

            CALL count_income(board_building_id);

            CALL cmd_move_building(g_id,p_num,b_x,b_y,board_building_id);

            UPDATE command SET hidden_flag=1 WHERE game_id=g_id AND player_num=p_num AND hidden_flag=2;
            UPDATE active_players SET nonfinished_action_id=0 WHERE game_id=g_id AND player_num=p_num;

            CALL finish_playing_card(g_id,p_num);
            CALL end_turn(g_id,p_num);

            CALL user_action_end();
          END IF;
        END IF;
      END IF;
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cast_vred_pooring`
--

DROP PROCEDURE IF EXISTS `cast_vred_pooring`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_vred_pooring`(g_id INT,p_num INT,p2_num INT)
BEGIN
  DECLARE nonfinished_action INT DEFAULT 4;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;/*Not your turn*/
  ELSE
    IF NOT nonfinished_action=(SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=24;/*Can't finish nonfinished action*/
    ELSE
      IF NOT EXISTS(SELECT id FROM players WHERE game_id=g_id AND player_num=p2_num AND owner<>0) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=13;/*Player doesn't exist*/
      ELSE
        CALL user_action_begin();

        CALL vred_pooring(g_id,p2_num);

        UPDATE command SET hidden_flag=1 WHERE game_id=g_id AND player_num=p_num AND hidden_flag=2;
        UPDATE active_players SET nonfinished_action_id=0 WHERE game_id=g_id AND player_num=p_num;

        CALL finish_playing_card(g_id,p_num);
        CALL end_turn(g_id,p_num);

        CALL user_action_end();
      END IF;
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `catapult_shoot`
--

DROP PROCEDURE IF EXISTS `catapult_shoot`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `catapult_shoot`(g_id INT,p_num INT,x INT,y INT, x2 INT, y2 INT)
BEGIN
  DECLARE err_code INT;
  DECLARE aim_bb_id INT;
  DECLARE aim_type VARCHAR(45);
  DECLARE board_unit_id INT;
  DECLARE distance INT;
  DECLARE dice INT;
  DECLARE chance INT;
  DECLARE damage INT;
  DECLARE miss INT DEFAULT 0;

  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit1 стреляет в $log_building $log_damage")';

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'catapult_shoot'); /*unit can do it*/
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
      SELECT b.ref,b.`type` INTO aim_bb_id,aim_type FROM board b WHERE b.game_id=g_id AND (b.`type`='building' OR b.`type`='castle') AND b.x=x2 AND b.y=y2 LIMIT 1;
      IF aim_bb_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=26;/*Building not chosen*/
      ELSE
        SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;

        SELECT MIN(GREATEST(ABS(shooter.x-aim.x),ABS(shooter.y-aim.y))) INTO distance
        FROM
          (SELECT b.x,b.y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=board_unit_id) shooter,
          (SELECT b.x,b.y FROM board b WHERE b.game_id=g_id AND (b.`type`='building' OR b.`type`='castle') AND b.ref=aim_bb_id) aim;

        IF((distance<2)OR(distance>5))THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=29;/*out of rande*/
        ELSE
/*OK*/
          CALL user_action_begin();

          IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
            CALL start_moving_units(g_id,p_num);
          END IF;

          UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
          CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

          IF distance=2 THEN /* always hit */
            SET chance=1;
          END IF;
          IF distance=3 THEN /* 1/2 */
            SET chance=4;
          END IF;
          IF distance=4 THEN /* 1/3 */
            SET chance=5;
          END IF;
          IF distance=5 THEN /* 1/6 */
            SET chance=6;
          END IF;

          SELECT FLOOR(1 + (RAND() * 6)) INTO dice FROM DUAL;
          IF dice<chance THEN
            SET miss=1;
          END IF;

          SELECT bu.attack INTO damage FROM board_units bu WHERE bu.id=board_unit_id;

          SET cmd_log=REPLACE(cmd_log,'$log_unit1',log_unit(board_unit_id));
          SET cmd_log=REPLACE(cmd_log,'$log_building',log_building(aim_bb_id));

          INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'unit_attack');
          IF miss=1 THEN
            SET cmd_log=REPLACE(cmd_log,'$log_damage','(Промах)');
            INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'miss_attack');
          ELSE
            SET cmd_log=REPLACE(cmd_log,'$log_damage',log_damage(damage));

            CASE aim_type
              WHEN 'building' THEN CALL hit_building(aim_bb_id,p_num,damage);
              WHEN 'castle' THEN CALL hit_castle(aim_bb_id,p_num,damage);
            END CASE;
          END IF;

          INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

          IF NOT EXISTS(SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id AND bu.player_num=p_num AND moves_left>0 AND unit_feature_check(bu.id,'paralich')=0 LIMIT 1) THEN
            CALL finish_moving_units(g_id,p_num);
            CALL end_turn(g_id,p_num);
          END IF;

          CALL user_action_end();
        END IF;
      END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cmd_add_card`
--

DROP PROCEDURE IF EXISTS `cmd_add_card`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_add_card`(g_id INT,p_num INT,player_deck_id INT)
BEGIN
  DECLARE new_card_id INT;
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'add_card($player_deck_id,$card_id)';

  SELECT card_id INTO new_card_id FROM player_deck WHERE id=player_deck_id;

  SET cmd=REPLACE(cmd,'$player_deck_id',player_deck_id);
  SET cmd=REPLACE(cmd,'$card_id',new_card_id);
  INSERT INTO command (game_id,player_num,command,hidden_flag) VALUES (g_id,p_num,cmd,1);
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cmd_add_player`
--

DROP PROCEDURE IF EXISTS `cmd_add_player`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
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

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cmd_add_spectator`
--

DROP PROCEDURE IF EXISTS `cmd_add_spectator`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_add_spectator`(g_id INT,p_num INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'add_spectator($p_num,"$name")';

  SET cmd=REPLACE(cmd,'$p_num',p_num);
  SET cmd=REPLACE(cmd,'$name',(SELECT name FROM players WHERE game_id=g_id AND player_num=p_num));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cmd_add_to_grave`
--

DROP PROCEDURE IF EXISTS `cmd_add_to_grave`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_add_to_grave`(g_id INT,p_num INT,grave_id INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'add_to_grave($grave_id,$dead_card_id,$x,$y,$size)';

  SET cmd=REPLACE(cmd,'$grave_id',grave_id);
  SET cmd=REPLACE(cmd,'$dead_card_id,$x,$y,$size',(SELECT CONCAT(g.card_id,',',g.x,',',g.y,',',g.size) FROM vw_grave g WHERE g.game_id=g_id AND g.grave_id=grave_id LIMIT 1));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cmd_add_unit`
--

DROP PROCEDURE IF EXISTS `cmd_add_unit`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
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

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cmd_add_unit_by_id`
--

DROP PROCEDURE IF EXISTS `cmd_add_unit_by_id`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
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

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cmd_building_set_health`
--

DROP PROCEDURE IF EXISTS `cmd_building_set_health`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_building_set_health`(g_id INT,p_num INT,board_building_id INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'building_set_health($x,$y,$health)';
  DECLARE x,y INT;

  SELECT b.x,b.y INTO x,y FROM board b WHERE b.game_id=g_id AND b.`type`<>'unit' AND b.ref=board_building_id LIMIT 1;
  SET cmd=REPLACE(cmd,'$x',x);
  SET cmd=REPLACE(cmd,'$y',y);
  SET cmd=REPLACE(cmd,'$health',(SELECT health FROM board_buildings WHERE id=board_building_id LIMIT 1));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cmd_building_set_owner`
--

DROP PROCEDURE IF EXISTS `cmd_building_set_owner`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_building_set_owner`(g_id INT,p_num INT,board_building_id INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'building_set_owner($x,$y,$p_num)';
  DECLARE x,y INT;

  SELECT b.x,b.y INTO x,y FROM board b WHERE b.game_id=g_id AND b.`type`<>'unit' AND b.ref=board_building_id LIMIT 1;
  SET cmd=REPLACE(cmd,'$x',x);
  SET cmd=REPLACE(cmd,'$y',y);
  SET cmd=REPLACE(cmd,'$p_num',(SELECT player_num FROM board_buildings WHERE id=board_building_id LIMIT 1));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cmd_delete_player`
--

DROP PROCEDURE IF EXISTS `cmd_delete_player`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_delete_player`(g_id INT,p_num INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'delete_player($p_num)';

  SET cmd=REPLACE(cmd,'$p_num',p_num);
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cmd_destroy_building`
--

DROP PROCEDURE IF EXISTS `cmd_destroy_building`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_destroy_building`(g_id INT,p_num INT,board_building_id INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'destroy_building($x,$y)';
  DECLARE x,y INT;

  SELECT b.x,b.y INTO x,y FROM board b WHERE b.game_id=g_id AND b.`type`<>'unit' AND b.ref=board_building_id LIMIT 1;
  SET cmd=REPLACE(cmd,'$x',x);
  SET cmd=REPLACE(cmd,'$y',y);
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cmd_end_game`
--

DROP PROCEDURE IF EXISTS `cmd_end_game`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_end_game`(g_id INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'end_game()';
  DECLARE p_num INT;

  SELECT a.player_num INTO p_num FROM active_players a WHERE a.game_id=g_id;
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cmd_kill_unit`
--

DROP PROCEDURE IF EXISTS `cmd_kill_unit`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_kill_unit`(g_id INT,p_num INT,board_unit_id INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'kill_unit($x,$y)';
  DECLARE x,y INT;

  SELECT b.x,b.y INTO x,y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=board_unit_id LIMIT 1;
  SET cmd=REPLACE(cmd,'$x',x);
  SET cmd=REPLACE(cmd,'$y',y);
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cmd_magic_resistance_log`
--

DROP PROCEDURE IF EXISTS `cmd_magic_resistance_log`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_magic_resistance_log`(g_id INT,p_num INT, board_unit_id INT)
BEGIN
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("На $log_unit_rod_pad не действует магия")';

/*If it's healing tower add independent message*/
  IF((SELECT current_procedure FROM active_players WHERE game_id=g_id LIMIT 1)='end_turn')THEN
    SET cmd_log=REPLACE(cmd_log,'log_add_message(',CONCAT('log_add_independent_message(',p_num,','));
  END IF;

  SET cmd_log=REPLACE(cmd_log,'$log_unit_rod_pad',log_unit_rod_pad(board_unit_id));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cmd_mechanical_log`
--

DROP PROCEDURE IF EXISTS `cmd_mechanical_log`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_mechanical_log`(g_id INT,p_num INT, board_unit_id INT)
BEGIN
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Механический $log_unit ничего не почувствовал")';

/*If it's healing tower add independent message*/
  IF((SELECT current_procedure FROM active_players WHERE game_id=g_id LIMIT 1)='end_turn')THEN
    SET cmd_log=REPLACE(cmd_log,'log_add_message(',CONCAT('log_add_independent_message(',p_num,','));
  END IF;

  SET cmd_log=REPLACE(cmd_log,'$log_unit',log_unit(board_unit_id));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cmd_miss_game_log`
--

DROP PROCEDURE IF EXISTS `cmd_miss_game_log`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_miss_game_log`(g_id INT,x INT,y INT)
BEGIN
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Промах: $log_object")';
  DECLARE obj_type VARCHAR(45);
  DECLARE obj_id INT;
  DECLARE p_num INT;

  SELECT b.`type`,b.ref INTO obj_type,obj_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y LIMIT 1;
  SELECT player_num INTO p_num FROM active_players WHERE game_id=g_id LIMIT 1;

  IF (obj_type='unit') THEN
    SET cmd_log=REPLACE(cmd_log,'$log_object',log_unit(obj_id));
  ELSE
    SET cmd_log=REPLACE(cmd_log,'$log_object',log_building(obj_id));
  END IF;

  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

  INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'miss_attack');

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cmd_miss_russian_rul`
--

DROP PROCEDURE IF EXISTS `cmd_miss_russian_rul`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_miss_russian_rul`(board_unit_id INT)
BEGIN
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit отделался легким испугом")';
  DECLARE g_id INT;
  DECLARE p_num INT;

  SELECT bu.game_id,bu.player_num INTO g_id,p_num FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;
/*log*/
      SET cmd_log=REPLACE(cmd_log,'$log_unit',log_unit(board_unit_id));
      INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cmd_move_building`
--

DROP PROCEDURE IF EXISTS `cmd_move_building`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
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

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cmd_move_unit`
--

DROP PROCEDURE IF EXISTS `cmd_move_unit`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_move_unit`(g_id INT,p_num INT,x1 INT,y1 INT,x2 INT,y2 INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'move_unit($x1,$y1,$x2,$y2)';

  SET cmd=REPLACE(cmd,'$x1',x1);
  SET cmd=REPLACE(cmd,'$y1',y1);
  SET cmd=REPLACE(cmd,'$x2',x2);
  SET cmd=REPLACE(cmd,'$y2',y2);
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cmd_player_end_turn`
--

DROP PROCEDURE IF EXISTS `cmd_player_end_turn`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_player_end_turn`(g_id INT,p_num INT)
BEGIN
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_player завершил ход")';

    SET cmd_log=REPLACE(cmd_log,'$log_player',log_player(g_id,p_num));
    INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cmd_player_end_turn_schedule`
--

DROP PROCEDURE IF EXISTS `cmd_player_end_turn_schedule`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_player_end_turn_schedule`(g_id INT,p_num INT)
BEGIN
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("У игрока $log_player закончилось время хода")';

    SET cmd_log=REPLACE(cmd_log,'$log_player',log_player(g_id,p_num));
    INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cmd_player_set_gold`
--

DROP PROCEDURE IF EXISTS `cmd_player_set_gold`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_player_set_gold`(g_id INT,p_num INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'player_set_gold($p_num,$amt)';

  SET cmd=REPLACE(cmd,'$p_num',p_num);
  SET cmd=REPLACE(cmd,'$amt',(SELECT gold FROM players WHERE game_id=g_id AND player_num=p_num LIMIT 1));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cmd_play_video`
--

DROP PROCEDURE IF EXISTS `cmd_play_video`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_play_video`(g_id INT,p_num INT,video_code VARCHAR(45),hidden INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'play_video("$title","$filename")';
  DECLARE g_mode INT;

  SELECT mode_id INTO g_mode FROM games WHERE id=g_id;

  SET cmd=REPLACE(cmd,'$title',(SELECT v.title FROM videos v WHERE v.code=video_code AND v.mode_id=g_mode));
  SET cmd=REPLACE(cmd,'$filename',(SELECT v.filename FROM videos v WHERE v.code=video_code AND v.mode_id=g_mode));
  INSERT INTO command (game_id,player_num,command,hidden_flag) VALUES (g_id,p_num,cmd,hidden);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cmd_put_building`
--

DROP PROCEDURE IF EXISTS `cmd_put_building`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_put_building`(g_id INT,p_num INT,board_building_id INT)
BEGIN
  DECLARE cmd_by_card_id VARCHAR(1000) CHARSET utf8 DEFAULT 'put_building($board_building_id,$p_num,$x,$y,$rotation,$flip,$card_id,$income)';
  DECLARE cmd_by_building_id VARCHAR(1000) CHARSET utf8 DEFAULT 'put_building_by_id($board_building_id,$p_num,$x,$y,$rotation,$flip,$building_id,$income)';
  DECLARE cmd VARCHAR(1000) CHARSET utf8;
  DECLARE x,y INT;
  DECLARE rotation INT;
  DECLARE flip INT;
  DECLARE income INT;
  DECLARE card_id INT;
  DECLARE building_id INT;

  SELECT MIN(b.x),MIN(b.y) INTO x,y FROM board b WHERE b.game_id=g_id AND b.`type`<>'unit' AND b.ref=board_building_id;
  SELECT bb.rotation,bb.flip,bb.card_id,bb.income,bb.building_id INTO rotation,flip,card_id,income,building_id FROM board_buildings bb WHERE bb.id=board_building_id LIMIT 1;

  IF(card_id IS NULL)THEN
    SET cmd=cmd_by_building_id;
    SET cmd=REPLACE(cmd,'$building_id',building_id);
  ELSE
    SET cmd=cmd_by_card_id;
    SET cmd=REPLACE(cmd,'$card_id',card_id);
  END IF;

  SET cmd=REPLACE(cmd,'$board_building_id',board_building_id);
  SET cmd=REPLACE(cmd,'$p_num',p_num);
  SET cmd=REPLACE(cmd,'$x',x);
  SET cmd=REPLACE(cmd,'$y',y);
  SET cmd=REPLACE(cmd,'$rotation',rotation);
  SET cmd=REPLACE(cmd,'$flip',flip);
  SET cmd=REPLACE(cmd,'$income',income);
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cmd_remove_card`
--

DROP PROCEDURE IF EXISTS `cmd_remove_card`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_remove_card`(g_id INT,p_num INT,player_deck_id INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'remove_card($player_deck_id)';

  SET cmd=REPLACE(cmd,'$player_deck_id',player_deck_id);
  INSERT INTO command (game_id,player_num,command,hidden_flag) VALUES (g_id,p_num,cmd,1);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cmd_remove_from_grave`
--

DROP PROCEDURE IF EXISTS `cmd_remove_from_grave`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_remove_from_grave`(g_id INT,p_num INT,grave_id INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'remove_from_grave($grave_id)';

  SET cmd=REPLACE(cmd,'$grave_id',grave_id);
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cmd_remove_spectator`
--

DROP PROCEDURE IF EXISTS `cmd_remove_spectator`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_remove_spectator`(g_id INT,p_num INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'remove_spectator($p_num)';

  SET cmd=REPLACE(cmd,'$p_num',p_num);
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cmd_resurrect_by_card_log`
--

DROP PROCEDURE IF EXISTS `cmd_resurrect_by_card_log`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_resurrect_by_card_log`(g_id INT,p_num INT,crd_id INT)
BEGIN
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_player воскресил $log_unit_rod_pad")';
  DECLARE board_unit_id INT;

  SELECT MAX(bu.id) INTO board_unit_id FROM board_units bu WHERE bu.game_id=g_id AND bu.player_num=p_num AND bu.card_id=crd_id;

  SET cmd_log=REPLACE(cmd_log,'$log_unit_rod_pad',log_unit_rod_pad(board_unit_id));
  SET cmd_log=REPLACE(cmd_log,'$log_player',log_player(g_id,p_num));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cmd_set_active_player`
--

DROP PROCEDURE IF EXISTS `cmd_set_active_player`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
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

  /*NPC command*/
  SELECT p.owner INTO owner FROM players p WHERE p.game_id=g_id AND p.player_num=p_num LIMIT 1;

  IF(owner NOT IN(0,1)) THEN
	SET cmd_npc=REPLACE(cmd_npc,'$p_num',p_num);
    INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_npc);
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cmd_unit_add_effect`
--

DROP PROCEDURE IF EXISTS `cmd_unit_add_effect`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_unit_add_effect`(g_id INT,board_unit_id INT,eff VARCHAR(30))
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'unit_add_effect($x,$y,"$effect","$param")';
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit <b class=\'unitEffect\'>$effect_desc</b>")';
  DECLARE x,y INT;
  DECLARE p2_num INT; /*unit owner*/

  SELECT b.x,b.y INTO x,y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=board_unit_id LIMIT 1;
  SELECT bu.player_num INTO p2_num FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;
  SET cmd=REPLACE(cmd,'$x',x);
  SET cmd=REPLACE(cmd,'$y',y);
  SET cmd=REPLACE(cmd,'$effect',eff);
  SET cmd=REPLACE(cmd,'$param',IFNULL(unit_feature_get_param(board_unit_id,eff),''));

  SET cmd_log=REPLACE(cmd_log,'$log_unit',log_unit(board_unit_id));
  SET cmd_log=REPLACE(cmd_log,'$effect_desc',(SELECT uf.log_description FROM unit_features uf WHERE uf.code=eff LIMIT 1));

  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p2_num,cmd_log);
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p2_num,cmd);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cmd_unit_remove_effect`
--

DROP PROCEDURE IF EXISTS `cmd_unit_remove_effect`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_unit_remove_effect`(g_id INT,board_unit_id INT,eff VARCHAR(30))
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'unit_remove_effect($x,$y,"$effect")';
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit <b class=\'unitEffect\'>больше не $effect_desc</b>")';
  DECLARE x,y INT;
  DECLARE p2_num INT; /*unit owner*/

  SELECT b.x,b.y INTO x,y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=board_unit_id LIMIT 1;
  SELECT bu.player_num INTO p2_num FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;
  SET cmd=REPLACE(cmd,'$x',x);
  SET cmd=REPLACE(cmd,'$y',y);
  SET cmd=REPLACE(cmd,'$effect',eff);

  SET cmd_log=REPLACE(cmd_log,'$log_unit',log_unit(board_unit_id));
  SET cmd_log=REPLACE(cmd_log,'$effect_desc',(SELECT uf.log_description FROM unit_features uf WHERE uf.code=eff LIMIT 1));

/*If it's healing tower add independent message*/
  IF((SELECT current_procedure FROM active_players WHERE game_id=g_id LIMIT 1)='end_turn')THEN
    SET cmd_log=REPLACE(cmd_log,'log_add_message(',CONCAT('log_add_independent_message(',p2_num,','));
  END IF;

  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p2_num,cmd_log);
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p2_num,cmd);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cmd_unit_set_attack`
--

DROP PROCEDURE IF EXISTS `cmd_unit_set_attack`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_unit_set_attack`(g_id INT,p_num INT,board_unit_id INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'unit_set_attack($x,$y,$attack)';
  DECLARE x,y INT;

  SELECT b.x,b.y INTO x,y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=board_unit_id LIMIT 1;
  SET cmd=REPLACE(cmd,'$x',x);
  SET cmd=REPLACE(cmd,'$y',y);
  SET cmd=REPLACE(cmd,'$attack',(SELECT attack FROM board_units WHERE id=board_unit_id LIMIT 1));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cmd_unit_set_health`
--

DROP PROCEDURE IF EXISTS `cmd_unit_set_health`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_unit_set_health`(g_id INT,p_num INT,board_unit_id INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'unit_set_health($x,$y,$health)';
  DECLARE x,y INT;

  SELECT b.x,b.y INTO x,y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=board_unit_id LIMIT 1;
  SET cmd=REPLACE(cmd,'$x',x);
  SET cmd=REPLACE(cmd,'$y',y);
  SET cmd=REPLACE(cmd,'$health',(SELECT health FROM board_units WHERE id=board_unit_id LIMIT 1));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cmd_unit_set_max_health`
--

DROP PROCEDURE IF EXISTS `cmd_unit_set_max_health`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_unit_set_max_health`(g_id INT,p_num INT,board_unit_id INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'unit_set_max_health($x,$y,$health)';
  DECLARE x,y INT;

  SELECT b.x,b.y INTO x,y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=board_unit_id LIMIT 1;
  SET cmd=REPLACE(cmd,'$x',x);
  SET cmd=REPLACE(cmd,'$y',y);
  SET cmd=REPLACE(cmd,'$health',(SELECT max_health FROM board_units WHERE id=board_unit_id LIMIT 1));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cmd_unit_set_moves`
--

DROP PROCEDURE IF EXISTS `cmd_unit_set_moves`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_unit_set_moves`(g_id INT,p_num INT,board_unit_id INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'unit_set_moves($x,$y,$m)';
  DECLARE x,y INT;

  SELECT b.x,b.y INTO x,y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=board_unit_id LIMIT 1;
  SET cmd=REPLACE(cmd,'$x',x);
  SET cmd=REPLACE(cmd,'$y',y);
  SET cmd=REPLACE(cmd,'$m',(SELECT moves FROM board_units WHERE id=board_unit_id LIMIT 1));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cmd_unit_set_moves_left`
--

DROP PROCEDURE IF EXISTS `cmd_unit_set_moves_left`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_unit_set_moves_left`(g_id INT,p_num INT,board_unit_id INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'unit_set_moves_left($x,$y,$m_left)';
  DECLARE x,y INT;

  SELECT b.x,b.y INTO x,y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=board_unit_id LIMIT 1;
  SET cmd=REPLACE(cmd,'$x',x);
  SET cmd=REPLACE(cmd,'$y',y);
  SET cmd=REPLACE(cmd,'$m_left',(SELECT moves_left FROM board_units WHERE id=board_unit_id LIMIT 1));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cmd_unit_set_owner`
--

DROP PROCEDURE IF EXISTS `cmd_unit_set_owner`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_unit_set_owner`(g_id INT,p_num INT,board_unit_id INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'unit_set_owner($x,$y,$p_num)';
  DECLARE x,y INT;

  SELECT b.x,b.y INTO x,y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=board_unit_id LIMIT 1;
  SET cmd=REPLACE(cmd,'$x',x);
  SET cmd=REPLACE(cmd,'$y',y);
  SET cmd=REPLACE(cmd,'$p_num',(SELECT player_num FROM board_units WHERE id=board_unit_id LIMIT 1));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cmd_unit_set_shield`
--

DROP PROCEDURE IF EXISTS `cmd_unit_set_shield`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_unit_set_shield`(g_id INT,p_num INT,board_unit_id INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'unit_set_shield($x,$y,$shield)';
  DECLARE x,y INT;

  SELECT b.x,b.y INTO x,y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=board_unit_id LIMIT 1;
  SET cmd=REPLACE(cmd,'$x',x);
  SET cmd=REPLACE(cmd,'$y',y);
  SET cmd=REPLACE(cmd,'$shield',(SELECT shield FROM board_units WHERE id=board_unit_id LIMIT 1));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `coin_factory_income`
--

DROP PROCEDURE IF EXISTS `coin_factory_income`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `coin_factory_income`(g_id INT, board_building_id INT)
BEGIN
  DECLARE p_num INT;
  DECLARE team INT;
  DECLARE board_unit_id INT;

  DECLARE radius INT;
  DECLARE x,y INT;

  DECLARE units_in_radius_count INT;
  DECLARE enemy_p_num INT;
  DECLARE enemies_in_radius_count INT;

  DECLARE done INT DEFAULT 0;

/*cursor for enemy units*/
  DECLARE cur CURSOR FOR
    SELECT bu.player_num,COUNT(*)
      FROM board b
      JOIN board_units bu ON (b.ref=bu.id)
      JOIN players p ON (bu.game_id=p.game_id AND bu.player_num=p.player_num)
    WHERE
      b.game_id=g_id
      AND b.`type`='unit'
      AND b.x BETWEEN x-radius AND x+radius
      AND b.y BETWEEN y-radius AND y+radius
      AND (p.team<>team)
    GROUP BY bu.player_num;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SELECT bb.radius,bb.player_num INTO radius,p_num FROM board_buildings bb WHERE bb.id=board_building_id LIMIT 1;
  SELECT b.x,b.y INTO x,y FROM board b WHERE b.game_id=g_id AND b.ref=board_building_id AND b.`type`<>'unit' LIMIT 1;

  SELECT p.team INTO team FROM players p WHERE p.game_id=g_id AND p.player_num=p_num LIMIT 1;

/*each unit in radius gives 1 gold to the owner of the mint*/
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

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `count_income`
--

DROP PROCEDURE IF EXISTS `count_income`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `count_income`(board_building_id INT)
BEGIN
  DECLARE x,y,x1,y1 INT;
  DECLARE g_id INT;
  DECLARE mode_id INT;
  DECLARE p_num INT;
  DECLARE building_income INT;
  DECLARE income INT DEFAULT 0;

  DECLARE radius INT;
  DECLARE shape VARCHAR(45);

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

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `delete_game_data`
--

DROP PROCEDURE IF EXISTS `delete_game_data`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_game_data`(g_id INT)
BEGIN
  DECLARE game_status_id INT;
  DECLARE finished_game_status INT DEFAULT 3; /*NOTE hardcode because this id is unlikely to change*/
  DECLARE game_type_id INT;
  DECLARE arena_game_type_id INT DEFAULT 1; /*NOTE hardcode because this id is unlikely to change*/

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
    DELETE FROM player_features_usage WHERE game_id=g_id;

  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `delete_player_objects`
--

DROP PROCEDURE IF EXISTS `delete_player_objects`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_player_objects`(g_id INT,p_num INT)
BEGIN
/*units, buildings, cards*/
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

/*cards*/
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

/*units*/
    OPEN cur2;
    REPEAT
      FETCH cur2 INTO board_unit_id,crd_id;
      IF NOT done THEN
        IF crd_id IS NOT NULL THEN
		  INSERT INTO graves(game_id,card_id) VALUES(g_id,crd_id);
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

/*buildings*/
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

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `destroy_building`
--

DROP PROCEDURE IF EXISTS `destroy_building`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `destroy_building`(board_b_id INT,p_num INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p2_num INT; /*building owner*/
  DECLARE crd_id INT;
  DECLARE reward INT DEFAULT 50;

  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Здание $log_building разрушено")';

  SELECT game_id,player_num,card_id INTO g_id,p2_num,crd_id FROM board_buildings WHERE id=board_b_id LIMIT 1;

/*log*/
      SET cmd_log=REPLACE(cmd_log,'$log_building',log_building(board_b_id));
      INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

  IF EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.`type`='obstacle' AND b.ref=board_b_id) THEN
    SET reward=0; /*no reward for swamps*/
  END IF;
/*building card back to deck*/
  IF(crd_id IS NOT NULL)THEN INSERT INTO deck(game_id,card_id) VALUES(g_id,crd_id); END IF;

  CALL cmd_destroy_building(g_id,p_num,board_b_id);
  DELETE FROM board WHERE game_id=g_id AND `type`<>'unit' AND ref=board_b_id;
  DELETE FROM board_buildings_features WHERE board_building_id=board_b_id;
  DELETE FROM board_buildings WHERE id=board_b_id;

  IF reward>0 THEN
    UPDATE players SET gold=gold+reward WHERE game_id=g_id AND player_num=p_num;
    CALL cmd_player_set_gold(g_id,p_num);
  END IF;

  INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'destroy_building',p2_num);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `destroy_castle`
--

DROP PROCEDURE IF EXISTS `destroy_castle`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `destroy_castle`(board_castle_id INT,p_num INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p2_num INT; /*castle owner*/
  DECLARE destroyed_castle_x INT;
  DECLARE destroyed_castle_y INT;
  DECLARE destroyed_castle_rotation INT;
  DECLARE destroyed_castle_flip INT;
  DECLARE ruins_building_id INT DEFAULT 8; /*HARDCODE*/
  DECLARE ruins_board_building_id INT;
  DECLARE user_id INT;
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_independent_message($p_num,"$log_building разрушен")';

  SELECT game_id,player_num INTO g_id,p2_num FROM board_buildings WHERE id=board_castle_id LIMIT 1;

/*log*/
      SET cmd_log=REPLACE(cmd_log,'$p_num',p2_num);
      SET cmd_log=REPLACE(cmd_log,'$log_building',log_building(board_castle_id));
      INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

      INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'destroy_building',p2_num);

  SELECT bb.rotation,bb.flip INTO destroyed_castle_rotation,destroyed_castle_flip FROM board_buildings bb WHERE bb.id=board_castle_id LIMIT 1;
  SELECT MIN(b.x),MIN(b.y) INTO destroyed_castle_x,destroyed_castle_y FROM board b WHERE game_id=g_id AND `type`<>'unit' AND ref=board_castle_id;

  CALL delete_player_objects(g_id,p2_num);

/*insert ruins*/
/*
  INSERT INTO board_buildings(game_id,player_num,building_id,rotation,flip)VALUES (g_id,p2_num,ruins_building_id,destroyed_castle_rotation,destroyed_castle_flip);
  SET ruins_board_building_id=@@last_insert_id;

  CALL place_building_on_board(ruins_board_building_id,destroyed_castle_x,destroyed_castle_y,destroyed_castle_rotation,destroyed_castle_flip);

  CALL cmd_put_building(g_id,p2_num,ruins_board_building_id);
*/
/*If his turn - end turn*/
  IF (SELECT player_num FROM active_players WHERE game_id=g_id LIMIT 1)=p2_num THEN
    CALL end_turn(g_id,p2_num);
  END IF;
/*spectator*/
  UPDATE players SET owner=0 WHERE game_id=g_id AND player_num=p2_num;

  SELECT p.user_id INTO user_id FROM players p WHERE game_id=g_id AND player_num=p_num;
  UPDATE lords_site.arena_game_players agp SET agp.spectator_flag=1 WHERE agp.user_id=user_id;

  CALL cmd_delete_player(g_id,p2_num);
  CALL cmd_add_spectator(g_id,p2_num);
  CALL cmd_play_video(g_id,p2_num,'destroyed_castle',1);

  IF (SELECT COUNT(DISTINCT p.team) FROM players p WHERE game_id=g_id AND owner=1)=1 THEN
    CALL end_game(g_id);
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `disagree_draw`
--

DROP PROCEDURE IF EXISTS `disagree_draw`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `disagree_draw`(g_id INT,p_num INT)
BEGIN
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_independent_message($p_num,"Не согласен на ничью")';

  CALL user_action_begin();

  UPDATE players SET agree_draw=0 WHERE game_id=g_id AND player_num=p_num;

  SET cmd_log=REPLACE(cmd_log,'$p_num',p_num);
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

  CALL user_action_end();

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `drink_health`
--

DROP PROCEDURE IF EXISTS `drink_health`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `drink_health`(board_unit_id INT)
BEGIN
  DECLARE dice_max INT DEFAULT 2;
  DECLARE chance INT DEFAULT 1;
  DECLARE drink_health_amt INT DEFAULT 1;
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE health,max_health INT;
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit выпивает $log_health")';

  IF ((SELECT FLOOR(1 + (RAND() * dice_max)) FROM DUAL)>chance) THEN /*drink successfull*/
    SELECT bu.game_id,bu.player_num,bu.health,bu.max_health INTO g_id,p_num,health,max_health FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

    IF(health+drink_health_amt>max_health)THEN
      UPDATE board_units SET max_health=health+drink_health_amt, health=health+drink_health_amt WHERE id=board_unit_id;
      CALL cmd_unit_set_max_health(g_id,p_num,board_unit_id);
      CALL cmd_unit_set_health(g_id,p_num,board_unit_id);
    ELSE /*don't change max_health, only health*/
      UPDATE board_units SET health=health+drink_health_amt WHERE id=board_unit_id;
      CALL cmd_unit_set_health(g_id,p_num,board_unit_id);
    END IF;

/*log*/
    SET cmd_log=REPLACE(cmd_log,'$log_unit',log_unit(board_unit_id));
    SET cmd_log=REPLACE(cmd_log,'$log_health',log_health(drink_health_amt));
    INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `end_game`
--

DROP PROCEDURE IF EXISTS `end_game`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `end_game`(g_id INT)
BEGIN
  DECLARE p_num INT;
  DECLARE finished_game_status INT DEFAULT 3; /*NOTE hardcode because this id is unlikely to change*/

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT p.player_num FROM players p WHERE p.game_id=g_id AND owner=1;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  IF (SELECT COUNT(DISTINCT p.team) FROM players p WHERE game_id=g_id AND owner=1)=1 THEN
/*one team wins*/
    OPEN cur;
    REPEAT
      FETCH cur INTO p_num;
      IF NOT done THEN
        CALL cmd_play_video(g_id,p_num,'win',1);
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur;
  ELSE
/*draw*/
    SELECT player_num INTO p_num FROM active_players WHERE game_id=g_id LIMIT 1;
    CALL cmd_play_video(g_id,p_num,'draw',0);
  END IF;

  CALL cmd_end_game(g_id);

  UPDATE games SET status_id=finished_game_status,time_restriction=0 WHERE id=g_id;

  UPDATE lords_site.arena_games SET status_id=finished_game_status,time_restriction=0 WHERE id=g_id;

/*statisticss*/
  CALL statistic_calculation(g_id);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `end_turn`
--

DROP PROCEDURE IF EXISTS `end_turn`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `end_turn`(g_id INT,p_num INT)
BEGIN
  DECLARE board_unit_id INT;
  DECLARE p_num2 INT;
  DECLARE owner_p2 INT;
  DECLARE last_turn INT;
  DECLARE turn,new_turn INT;
  DECLARE mode_id INT;

  DECLARE nonfinished_action INT;

  DECLARE board_building_id INT;

/*cursor for commands unit_set_moves_left*/
  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id AND bu.player_num=p_num AND bu.moves_left<ABS(bu.moves);

  DECLARE cur_building_features CURSOR FOR
    SELECT bb.id FROM board_buildings bb WHERE bb.game_id=g_id AND bb.player_num=p_num2 AND check_building_deactivated(bb.id)=0;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    SELECT a.turn,a.nonfinished_action_id INTO turn,nonfinished_action FROM active_players a WHERE a.game_id=g_id LIMIT 1;

    IF(nonfinished_action<>0)THEN
      CALL finish_nonfinished_action(g_id,p_num,nonfinished_action);
    END IF;

    IF p_num=(SELECT MAX(player_num) FROM players WHERE game_id=g_id AND owner<>0) THEN
      SET new_turn=turn+1;
      UPDATE active_players SET turn=new_turn,player_num=(SELECT MIN(player_num) FROM players WHERE game_id=g_id AND owner<>0),subsidy_flag=0,units_moves_flag=0,nonfinished_action_id=0,last_end_turn=CURRENT_TIMESTAMP,current_procedure='end_turn' WHERE game_id=g_id;
    ELSE
      SET new_turn=turn;
      UPDATE active_players SET player_num=(SELECT MIN(player_num) FROM players WHERE game_id=g_id AND player_num>p_num AND owner<>0),subsidy_flag=0,units_moves_flag=0,nonfinished_action_id=0,last_end_turn=CURRENT_TIMESTAMP,current_procedure='end_turn' WHERE game_id=g_id;
    END IF;

    SELECT a.player_num,UNIX_TIMESTAMP(a.last_end_turn) INTO p_num2,last_turn FROM active_players a WHERE a.game_id=g_id;

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

/*Delete castle-repairing feature*/
  IF @player_end_turn IS NULL THEN
    DELETE FROM player_features_usage WHERE game_id=g_id AND player_num=p_num AND feature_id=player_feature_get_id_by_code('end_turn');
  END IF;

  SELECT p.owner INTO owner_p2 FROM players p WHERE p.game_id=g_id AND p.player_num=p_num2 LIMIT 1;

  IF owner_p2=1 THEN /*human*/
  BEGIN
    DECLARE cmd_log_close_container VARCHAR(1000) CHARSET utf8 DEFAULT 'log_close_container()';

/*income and healing tower*/
    DECLARE income INT;
    DECLARE u_income INT;

/*npc log close container*/
    IF((SELECT MAX(p.player_num) FROM players p WHERE p.game_id=g_id AND owner NOT IN(0,1))=p_num)THEN
      INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log_close_container);
    END IF;

/*income from buildings*/
    SELECT IFNULL(SUM(bb.income),0) INTO income FROM board_buildings bb WHERE bb.game_id=g_id AND bb.player_num=p_num2 AND bb.income<>0 AND check_building_deactivated(bb.id)=0;
/*income from units*/
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

      END IF;
    UNTIL done END REPEAT;
    CLOSE cur_building_features;

  END;
  ELSE
/*NPC*/
  BEGIN
    DECLARE cmd_log_open_container VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_container($p_num,"Ход NPC")';

    IF((SELECT MIN(p.player_num) FROM players p WHERE p.game_id=g_id AND owner NOT IN(0,1))=p_num2)THEN
      SET cmd_log_open_container=REPLACE(cmd_log_open_container,'$p_num',p_num2);
      INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num2,cmd_log_open_container);
    END IF;

  END;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `finish_moving_units`
--

DROP PROCEDURE IF EXISTS `finish_moving_units`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `finish_moving_units`(g_id INT,p_num INT)
BEGIN
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_close_container()';

  IF((SELECT owner FROM players p WHERE p.game_id=g_id AND p.player_num=p_num LIMIT 1)=1)THEN
/*log container only for human players*/
    INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `finish_nonfinished_action`
--

DROP PROCEDURE IF EXISTS `finish_nonfinished_action`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `finish_nonfinished_action`(g_id INT,p_num INT,nonfinished_action INT)
BEGIN
  DECLARE mode_id INT;

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;

  CASE nonfinished_action

    WHEN 1 THEN /*resurrect*/
    BEGIN
      DECLARE big_dice INT;
      DECLARE x_appear,y_appear INT;
      DECLARE max_size INT;
      DECLARE random_grave INT;
      DECLARE random_dead_card INT;

      SELECT ap.x,ap.y INTO x_appear,y_appear FROM appear_points ap WHERE ap.mode_id=mode_id AND ap.player_num=p_num;
      /*get max resurrectable size*/
      SELECT IFNULL(MIN(GREATEST(ABS(b.x-18),ABS(b.y-18))),18) INTO max_size FROM board b
      WHERE b.x NOT IN(0,19) AND b.y NOT IN(0,19);
      /*get random dead*/
        CREATE TEMPORARY TABLE tmp_dead_units (id_rand INT AUTO_INCREMENT PRIMARY KEY)AUTO_INCREMENT=1
          SELECT g.grave_id AS `grave_id`,g.card_id AS `card_id`
          FROM vw_grave g
          WHERE g.game_id=g_id AND g.size<=max_size;
        SELECT FLOOR(1 + (RAND() * MAX(id_rand))) INTO big_dice FROM tmp_dead_units;
        SELECT `grave_id`,`card_id` INTO random_grave,random_dead_card FROM tmp_dead_units WHERE id_rand=big_dice LIMIT 1;
        DROP TEMPORARY TABLE tmp_dead_units;

        CALL resurrect(g_id,p_num,random_grave);
        CALL cmd_resurrect_by_card_log(g_id,p_num,random_dead_card);
    END;

    WHEN 2 THEN /*units from zone*/
    BEGIN
      DECLARE zone INT;

      SELECT FLOOR(RAND() * 4) INTO zone FROM DUAL;

      CALL units_from_zone(g_id,zone);
    END;

    WHEN 3 THEN /*move and own building*/
    BEGIN
      DECLARE big_dice INT;
      DECLARE rand_building_id INT;
      DECLARE x_len,y_len INT;
      DECLARE shape VARCHAR(45);
      DECLARE radius INT;
      DECLARE rotation INT DEFAULT 0;
      DECLARE flip INT DEFAULT 0;
      DECLARE x,y,b_x,b_y INT;

      /*get random building*/
        CREATE TEMPORARY TABLE tmp_buildings (id_rand INT AUTO_INCREMENT PRIMARY KEY)AUTO_INCREMENT=1
          SELECT DISTINCT b.ref AS `board_building_id`
          FROM board b
          JOIN board_buildings bb ON (b.ref=bb.id)
          WHERE b.game_id=g_id AND b.`type` IN ('building','obstacle') AND bb.player_num<>p_num;
        SELECT FLOOR(1 + (RAND() * MAX(id_rand))) INTO big_dice FROM tmp_buildings;
        SELECT `board_building_id` INTO rand_building_id FROM tmp_buildings WHERE id_rand=big_dice LIMIT 1;
        DROP TEMPORARY TABLE tmp_buildings;

        SELECT b.x_len,b.y_len,b.shape,b.radius INTO x_len,y_len,shape,radius FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.id=rand_building_id LIMIT 1;

        /*select old building coord for building move command*/
        SELECT b.x,b.y INTO b_x,b_y FROM board b WHERE b.game_id=g_id AND b.`type` IN ('building','obstacle') AND b.ref=rand_building_id LIMIT 1;
        /*set ref=0 to identify if building has been moved*/
        UPDATE board SET ref=0 WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=rand_building_id;

        /*try until it will be placed*/
        WHILE NOT EXISTS (SELECT id FROM board WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=rand_building_id LIMIT 1) DO
          IF shape='1' THEN
            SELECT FLOOR(RAND() * 20) INTO x FROM DUAL;
            SELECT FLOOR(RAND() * 20) INTO y FROM DUAL;
          ELSE
            SELECT FLOOR(RAND() * 4) INTO rotation FROM DUAL;
            SELECT FLOOR(RAND() * 2) INTO flip FROM DUAL;
            /*generate top-left X,Y so that the whole building in game area*/
            SELECT FLOOR(RAND() * (21- CASE WHEN rotation IN(0,2) THEN x_len ELSE y_len END)) INTO x FROM DUAL;
            SELECT FLOOR(RAND() * (21- CASE WHEN rotation IN(0,2) THEN y_len ELSE x_len END)) INTO y FROM DUAL;
          END IF;
          /*try to place a building*/
          CALL place_building_on_board(rand_building_id,x,y,rotation,flip);
        END WHILE;

        DELETE FROM board WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0; /*Del old coords*/

        UPDATE board_buildings bb SET bb.player_num=p_num,bb.rotation=rotation,bb.flip=flip WHERE bb.id=rand_building_id;

        CALL count_income(rand_building_id);

        CALL cmd_move_building(g_id,p_num,b_x,b_y,rand_building_id);
        CALL cmd_building_set_owner(g_id,p_num,rand_building_id);
    END;

    WHEN 4 THEN /* -60$ to player */
    BEGIN
      DECLARE random_player INT;

      SELECT player_num INTO random_player FROM players WHERE game_id=g_id ORDER BY RAND() LIMIT 1;
      CALL vred_pooring(g_id,random_player);
    END;

    WHEN 5 THEN /* kill unit */
    BEGIN
      DECLARE random_bu_id,u_id INT;
      DECLARE shield INT;

      SELECT bu.id,bu.unit_id,bu.shield INTO random_bu_id,u_id,shield FROM board_units bu WHERE bu.game_id=g_id ORDER BY RAND() LIMIT 1;

      CALL magic_kill_unit(random_bu_id,p_num);
    END;

    WHEN 6 THEN /* destroy building */
    BEGIN
      DECLARE random_bb_id,b_id INT;

      SELECT bb.id INTO random_bb_id FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.game_id=g_id AND b.`type`<>'castle' ORDER BY RAND() LIMIT 1;
      CALL destroy_building(random_bb_id,p_num);
    END;

    WHEN 7 THEN /*move enemy building*/
    BEGIN
      DECLARE big_dice INT;
      DECLARE rand_building_id INT;
      DECLARE x_len,y_len INT;
      DECLARE shape VARCHAR(45);
      DECLARE radius INT;
      DECLARE rotation INT DEFAULT 0;
      DECLARE flip INT DEFAULT 0;
      DECLARE x,y,b_x,b_y INT;

      /*get random building*/
        CREATE TEMPORARY TABLE tmp_buildings (id_rand INT AUTO_INCREMENT PRIMARY KEY)AUTO_INCREMENT=1
          SELECT DISTINCT b.ref AS `board_building_id`
          FROM board b
          JOIN board_buildings bb ON (b.ref=bb.id)
          WHERE b.game_id=g_id AND b.`type` IN ('building','obstacle') AND bb.player_num<>p_num;
        SELECT FLOOR(1 + (RAND() * MAX(id_rand))) INTO big_dice FROM tmp_buildings;
        SELECT `board_building_id` INTO rand_building_id FROM tmp_buildings WHERE id_rand=big_dice LIMIT 1;
        DROP TEMPORARY TABLE tmp_buildings;

        SELECT b.x_len,b.y_len,b.shape,b.radius INTO x_len,y_len,shape,radius FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.id=rand_building_id LIMIT 1;

        /*select old building coord for building move command*/
        SELECT b.x,b.y INTO b_x,b_y FROM board b WHERE b.game_id=g_id AND b.`type` IN ('building','obstacle') AND b.ref=rand_building_id LIMIT 1;
        /*set ref=0 to identify if building has been moved*/
        UPDATE board SET ref=0 WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=rand_building_id;

        /*try until it will be placed*/
        WHILE NOT EXISTS (SELECT id FROM board WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=rand_building_id LIMIT 1) DO
          IF shape='1' THEN
            SELECT FLOOR(RAND() * 20) INTO x FROM DUAL;
            SELECT FLOOR(RAND() * 20) INTO y FROM DUAL;
          ELSE
            SELECT FLOOR(RAND() * 4) INTO rotation FROM DUAL;
            SELECT FLOOR(RAND() * 2) INTO flip FROM DUAL;
            /*generate top-left X,Y so that the whole building in game area*/
            SELECT FLOOR(RAND() * (21- CASE WHEN rotation IN(0,2) THEN x_len ELSE y_len END)) INTO x FROM DUAL;
            SELECT FLOOR(RAND() * (21- CASE WHEN rotation IN(0,2) THEN y_len ELSE x_len END)) INTO y FROM DUAL;
          END IF;
          /*try to place a building*/
          CALL place_building_on_board(rand_building_id,x,y,rotation,flip);
        END WHILE;

        DELETE FROM board WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0; /*Del old coords*/

        UPDATE board_buildings bb SET bb.rotation=rotation,bb.flip=flip WHERE bb.id=rand_building_id;

        CALL count_income(rand_building_id);

        CALL cmd_move_building(g_id,p_num,b_x,b_y,rand_building_id);
    END;

  END CASE;

  UPDATE command SET hidden_flag=1 WHERE game_id=g_id AND player_num=p_num AND hidden_flag=2;
  UPDATE active_players SET nonfinished_action_id=0 WHERE game_id=g_id AND player_num=p_num;

  CALL finish_playing_card(g_id,p_num);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `finish_playing_card`
--

DROP PROCEDURE IF EXISTS `finish_playing_card`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `finish_playing_card`(g_id INT,p_num INT)
BEGIN
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_close_container()';

  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `get_all_game_info`
--

DROP PROCEDURE IF EXISTS `get_all_game_info`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_game_info`(g_id INT,p_num INT)
BEGIN

/*games*/
  SELECT g.title,CASE WHEN g.pass IS NULL THEN 0 ELSE 1 END AS `pass_flag`,g.owner_id,g.time_restriction,g.status_id,g.`date` AS `creation_date`,g.mode_id,g.type_id FROM games g WHERE g.id=g_id;

/*board (buildings)*/
  SELECT b.id,MIN(b.x) as `x`,MIN(b.y) as `y`,b.ref,b.`type` FROM board b WHERE b.game_id=g_id AND b.`type`<>'unit' GROUP BY b.ref,b.`type`;

/*board (units)*/
  SELECT b.id,MIN(b.x) as `x`,MIN(b.y) as `y`,b.ref,b.`type` FROM board b WHERE b.game_id=g_id AND b.`type`='unit' GROUP BY b.ref,b.`type`;

/*active_player*/
  SELECT a.player_num,a.turn,a.subsidy_flag,a.units_moves_flag,UNIX_TIMESTAMP(a.last_end_turn) as `last_end_turn`,n.command_procedure FROM active_players a LEFT JOIN nonfinished_actions_dictionary n ON (a.nonfinished_action_id=n.id) WHERE a.game_id=g_id;

/*players*/
  SELECT p.player_num, p.name, p.gold, p.owner, p.team, p.agree_draw FROM players p WHERE p.game_id=g_id ORDER BY p.player_num;

/*board buildings*/
  SELECT b.id, b.building_id, b.player_num, b.health, b.max_health, b.radius, b.card_id, b.income, b.rotation, b.flip FROM board_buildings b WHERE b.game_id=g_id;

/*board building features*/
  SELECT bbf.board_building_id,bbf.feature_id,bbf.param FROM board_buildings_features bbf JOIN board_buildings bb ON (bb.id=bbf.board_building_id) WHERE bb.game_id=g_id;

/*board units*/
  SELECT b.id, b.player_num, b.unit_id, b.card_id, b.health, b.max_health, b.attack, b.moves_left, b.moves, b.shield FROM board_units b WHERE b.game_id=g_id;

/*board units features*/
  SELECT buf.board_unit_id,buf.feature_id,buf.param FROM board_units_features buf JOIN board_units bu ON (bu.id=buf.board_unit_id) WHERE bu.game_id=g_id;

/*vw_grave*/
  SELECT v.grave_id,v.card_id, v.x, v.y, v.size FROM vw_grave v WHERE v.game_id=g_id;

/*player_deck*/
  SELECT p.id,p.card_id FROM player_deck p WHERE p.game_id=g_id AND p.player_num=p_num;

/*TODO move log messages to separate table*/
select command from log_commands where game_id=g_id AND((hidden_flag=0) OR (player_num = p_num));

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `get_all_game_info_ai`
--

DROP PROCEDURE IF EXISTS `get_all_game_info_ai`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_game_info_ai`(g_id INT,p_num INT)
BEGIN

/*players*/
  SELECT p.player_num, p.owner, p.team FROM players p WHERE p.game_id=g_id ORDER BY p.player_num;

/*board buildings*/
  SELECT b.id, b.player_num, b.health, b.max_health FROM board_buildings b WHERE b.game_id=g_id;

/*board building features*/
  SELECT bbf.board_building_id,bf.code AS `feature_name`,bbf.param AS `feature_value` FROM board_buildings_features bbf JOIN board_buildings bb ON (bb.id=bbf.board_building_id) JOIN building_features bf ON (bbf.feature_id = bf.id) WHERE bb.game_id=g_id;

/*board units*/
  SELECT b.id, b.player_num, b.health, b.max_health, b.attack, b.moves_left, b.moves, b.shield FROM board_units b WHERE b.game_id=g_id;

/*board units features*/
  SELECT buf.board_unit_id,uf.code AS `feature_name`,buf.param AS `feature_value` FROM board_units_features buf JOIN board_units bu ON (bu.id=buf.board_unit_id) JOIN unit_features uf ON (buf.feature_id = uf.id) WHERE bu.game_id=g_id;

/*board*/
  SELECT b.x, b.y, b.`type`, b.ref FROM board b WHERE b.game_id=g_id;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `get_games_info`
--

DROP PROCEDURE IF EXISTS `get_games_info`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
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
  JOIN players p ON (ap.game_id=p.game_id AND ap.player_num=p.player_num);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `get_game_info`
--

DROP PROCEDURE IF EXISTS `get_game_info`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
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

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `get_game_statistic`
--

DROP PROCEDURE IF EXISTS `get_game_statistic`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_game_statistic`(g_id INT)
BEGIN

  SELECT `tab_id`,`tab_name`,`chart_id`,`chart_type`,`chart_name`,`value_id`,`value`,`color`,`value_name` FROM `vw_statistic_values` WHERE `vw_statistic_values`.`game_id`=g_id ORDER BY `tab_id`,`chart_id`,`value_id`;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `get_unit_phrase`
--

DROP PROCEDURE IF EXISTS `get_unit_phrase`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_unit_phrase`(g_id INT)
BEGIN
  DECLARE random_row INT;
  DECLARE board_unit_id INT;
  DECLARE unit_id INT;
  DECLARE phrase_id INT;

  /*get random unit*/
  IF EXISTS(SELECT 1 FROM board_units bu WHERE bu.game_id=g_id LIMIT 1)THEN
    CREATE TEMPORARY TABLE tmp_units (id_rand INT AUTO_INCREMENT PRIMARY KEY)AUTO_INCREMENT=1
      SELECT
        bu.id AS `board_unit_id`,
        bu.unit_id AS `unit_id`
      FROM board_units bu
      WHERE bu.game_id=g_id;

    SELECT FLOOR(1 + (RAND() * MAX(id_rand))) INTO random_row FROM tmp_units;
    SELECT t.board_unit_id,t.unit_id INTO board_unit_id,unit_id FROM tmp_units t WHERE t.id_rand=random_row LIMIT 1;
    DROP TEMPORARY TABLE tmp_units;

  /*get random phrase for unit_id*/
    IF EXISTS(SELECT 1 FROM dic_unit_phrases d WHERE d.unit_id=unit_id LIMIT 1)THEN
      CREATE TEMPORARY TABLE tmp_unit_phrases (id_rand INT AUTO_INCREMENT PRIMARY KEY)AUTO_INCREMENT=1
        SELECT
          d.id
        FROM dic_unit_phrases d
        WHERE d.unit_id=unit_id;

      SELECT FLOOR(1 + (RAND() * MAX(id_rand))) INTO random_row FROM tmp_unit_phrases;
      SELECT t.id INTO phrase_id FROM tmp_unit_phrases t WHERE t.id_rand=random_row LIMIT 1;
      DROP TEMPORARY TABLE tmp_unit_phrases;

      SELECT board_unit_id,phrase_id FROM DUAL;

    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `healing_tower_heal`
--

DROP PROCEDURE IF EXISTS `healing_tower_heal`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `healing_tower_heal`(g_id INT, board_building_id INT)
BEGIN
  DECLARE p_num INT;
  DECLARE team INT;
  DECLARE board_unit_id INT;
  DECLARE obj_x,obj_y INT;

  DECLARE ht_radius INT;
  DECLARE ht_x,ht_y INT;

/*cursor for healing tower*/
  DECLARE done INT DEFAULT 0;

  DECLARE cur CURSOR FOR
    SELECT bu.id, b.x, b.y
      FROM board b
      JOIN board_units bu ON (b.ref=bu.id)
      JOIN players p ON (bu.game_id=p.game_id AND bu.player_num=p.player_num)
    WHERE
      b.game_id=g_id
      AND b.`type`='unit'
      AND b.x BETWEEN ht_x-ht_radius AND ht_x+ht_radius
      AND b.y BETWEEN ht_y-ht_radius AND ht_y+ht_radius
      AND (p.team=team OR unit_feature_check(bu.id,'madness')=1);

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SELECT bb.radius,bb.player_num INTO ht_radius,p_num FROM board_buildings bb WHERE bb.id=board_building_id LIMIT 1;
  SELECT b.x,b.y INTO ht_x,ht_y FROM board b WHERE b.game_id=g_id AND b.ref=board_building_id AND b.`type`<>'unit' LIMIT 1;

  SELECT p.team INTO team FROM players p WHERE p.game_id=g_id AND p.player_num=p_num LIMIT 1;


  OPEN cur;
  REPEAT
    FETCH cur INTO board_unit_id,obj_x,obj_y;
    IF NOT done THEN
      CALL magical_heal(g_id,p_num,obj_x,obj_y,1);
    END IF;
  UNTIL done END REPEAT;
  CLOSE cur;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `heal_unit`
--

DROP PROCEDURE IF EXISTS `heal_unit`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `heal_unit`(board_unit_id INT,hp INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE hp_minus INT;
  DECLARE shield_minus INT;

  SELECT bu.game_id,bu.player_num,bu.max_health-bu.health,u.shield-bu.shield INTO g_id,p_num,hp_minus,shield_minus
  FROM board_units bu JOIN units u ON (bu.unit_id=u.id) WHERE bu.id=board_unit_id LIMIT 1;

  IF (unit_feature_check(board_unit_id,'paralich')=1) THEN
/*unparalich*/
    CALL unit_feature_remove(board_unit_id,'paralich');
    CALL cmd_unit_remove_effect(g_id,board_unit_id,'paralich');
  ELSE
    IF (unit_feature_check(board_unit_id,'madness')=1) THEN
/*make not mad*/
      CALL make_not_mad(board_unit_id);
    ELSE
      IF hp_minus>0 THEN
/*heal*/
        CALL heal_unit_health(board_unit_id,(SELECT LEAST(hp_minus,hp) FROM DUAL));
      ELSE
        IF shield_minus>0 THEN
/*restore shield*/
          CALL shield_on(board_unit_id);
        END IF;
      END IF;
    END IF;
  END IF;


END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `heal_unit_health`
--

DROP PROCEDURE IF EXISTS `heal_unit_health`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `heal_unit_health`(board_unit_id INT,hp INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;

  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit восстанавливает $log_health")';

  SELECT bu.game_id,bu.player_num INTO g_id,p_num FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

  UPDATE board_units SET health=health+hp WHERE id=board_unit_id;
  CALL cmd_unit_set_health(g_id,p_num,board_unit_id);

/*If it's healing tower add independent message*/
  IF((SELECT current_procedure FROM active_players WHERE game_id=g_id LIMIT 1)='end_turn')THEN
    SET cmd_log=REPLACE(cmd_log,'log_add_message(',CONCAT('log_add_independent_message(',p_num,','));
  END IF;

  SET cmd_log=REPLACE(cmd_log,'$log_unit',log_unit(board_unit_id));
  SET cmd_log=REPLACE(cmd_log,'$log_health',log_health(hp));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `hit_building`
--

DROP PROCEDURE IF EXISTS `hit_building`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `hit_building`(board_building_id INT,p_num INT,damage INT)
BEGIN
  DECLARE g_id INT;
  DECLARE hp INT;

  SELECT bb.game_id,bb.health INTO g_id,hp FROM board_buildings bb WHERE bb.id=board_building_id LIMIT 1;

    IF damage>=hp THEN
/*destroy building*/
      INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'make_damage',hp);
      CALL destroy_building(board_building_id,p_num);
    ELSE
/*damage*/
      UPDATE board_buildings SET health=health-damage WHERE id=board_building_id;
      CALL cmd_building_set_health(g_id,p_num,board_building_id);

      INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'make_damage',damage);

    END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `hit_castle`
--

DROP PROCEDURE IF EXISTS `hit_castle`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
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
/*reward*/
      UPDATE players SET gold=gold+hp*hp_reward WHERE game_id=g_id AND player_num=p_num;
      CALL cmd_player_set_gold(g_id,p_num);
/*destroy castle*/
      INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'make_damage',hp);
      CALL destroy_castle(board_castle_id,p_num);
    ELSE
/*damage*/
      UPDATE board_buildings SET health=health-damage WHERE id=board_castle_id;
      CALL cmd_building_set_health(g_id,p_num,board_castle_id);
/*reward*/
      UPDATE players SET gold=gold+damage*hp_reward WHERE game_id=g_id AND player_num=p_num;
      CALL cmd_player_set_gold(g_id,p_num);

      INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'make_damage',damage);

    END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `hit_unit`
--

DROP PROCEDURE IF EXISTS `hit_unit`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `hit_unit`(board_unit_id INT,p_num INT,damage INT)
BEGIN
  DECLARE g_id INT;
  DECLARE hp INT;
  DECLARE shld INT;

  SELECT bu.game_id,bu.health,bu.shield INTO g_id,hp,shld FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

/*shield*/
  IF shld>0 THEN
    CALL shield_off(board_unit_id);
/*unparalich*/
    IF (unit_feature_check(board_unit_id,'paralich')=1) THEN
      CALL unit_feature_remove(board_unit_id,'paralich');
      CALL cmd_unit_remove_effect(g_id,board_unit_id,'paralich');
    END IF;
  ELSE
    IF damage>=hp THEN
/*kill*/
      INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'make_damage',hp);
      CALL kill_unit(board_unit_id,p_num);
    ELSE
/*damage*/
      UPDATE board_units SET health=health-damage WHERE id=board_unit_id;
      CALL cmd_unit_set_health(g_id,p_num,board_unit_id);
/*unparalich*/
      IF (unit_feature_check(board_unit_id,'paralich')=1) THEN
        CALL unit_feature_remove(board_unit_id,'paralich');
        CALL cmd_unit_remove_effect(g_id,board_unit_id,'paralich');
      END IF;

      INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'make_damage',damage);

    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `initialization`
--

DROP PROCEDURE IF EXISTS `initialization`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `initialization`(g_id INT)
BEGIN
  DECLARE started_game_status INT DEFAULT 2; /*NOTE hardcode because this id is unlikely to change*/

  CALL init_player_num_teams(g_id);
  CALL init_player_gold(g_id);
  CALL init_decks(g_id);
  CALL init_buildings(g_id);
  CALL init_units(g_id);
  CALL init_statistics(g_id);

  INSERT INTO active_players(game_id,player_num,turn,last_end_turn) SELECT g_id,MIN(player_num),0,CURRENT_TIMESTAMP FROM players WHERE game_id=g_id AND owner<>0; /*min player_num(=0) starts*/
  UPDATE games SET `status_id`=started_game_status WHERE id=g_id;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `init_buildings`
--

DROP PROCEDURE IF EXISTS `init_buildings`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
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

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT cfg.player_num,cfg.x,cfg.y,cfg.rotation,cfg.flip,cfg.building_id FROM put_start_buildings_config cfg JOIN players p ON cfg.player_num=p.player_num WHERE p.game_id=g_id AND p.owner<>0 AND cfg.mode_id=g_mode;
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

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `init_decks`
--

DROP PROCEDURE IF EXISTS `init_decks`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `init_decks`(g_id INT)
BEGIN
  DECLARE g_mode INT;

  DECLARE p_num INT;
  DECLARE qty INT; /*Quantity of cards*/
  DECLARE card_type VARCHAR(45) CHARSET utf8;

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT cfg.player_num,cfg.quantity,cfg.`type` FROM player_start_deck_config cfg JOIN players p ON cfg.player_num=p.player_num WHERE p.game_id=g_id AND p.owner<>0 AND cfg.mode_id=g_mode;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SELECT g.mode_id INTO g_mode FROM games g WHERE g.id=g_id LIMIT 1;

  CREATE TEMPORARY TABLE tmp_deck (id INT AUTO_INCREMENT PRIMARY KEY, card_id INT, `type` varchar(45), player_num int null);

  INSERT INTO tmp_deck(card_id,`type`)
  SELECT c.id,c.`type`
  FROM modes_cards mc
  JOIN cards c ON (mc.card_id=c.id)
  WHERE mc.mode_id=g_mode
  ORDER BY RAND();

  OPEN cur;
  REPEAT
    FETCH cur INTO p_num, qty, card_type;
    IF NOT done THEN
      UPDATE tmp_deck SET player_num=p_num WHERE `type`=card_type AND player_num IS NULL LIMIT qty;
    END IF;
  UNTIL done END REPEAT;
  CLOSE cur;

  INSERT INTO player_deck(game_id,player_num,card_id)
  SELECT g_id,player_num,card_id FROM tmp_deck WHERE player_num IS NOT NULL;

  INSERT INTO deck(game_id,card_id)
  SELECT g_id,card_id FROM tmp_deck WHERE player_num IS NULL;

  DROP TEMPORARY TABLE tmp_deck;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `init_player_gold`
--

DROP PROCEDURE IF EXISTS `init_player_gold`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `init_player_gold`(g_id INT)
BEGIN
  DECLARE g_mode INT;

  SELECT mode_id INTO g_mode FROM games WHERE id=g_id;

  UPDATE players p,player_start_gold_config cfg SET p.gold=cfg.quantity
  WHERE p.game_id=g_id AND p.owner<>0 AND p.player_num=cfg.player_num AND cfg.mode_id=g_mode;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `init_player_num_teams`
--

DROP PROCEDURE IF EXISTS `init_player_num_teams`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
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

/*set teams*/
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

/*set player num (castles)*/
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
/*cycle algorythm*/
    DECLARE i INT DEFAULT 0;

    /*all castles to occupy*/
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
          /*apply cycle method to the table*/
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

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `init_statistics`
--

DROP PROCEDURE IF EXISTS `init_statistics`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `init_statistics`(g_id INT)
BEGIN
  DECLARE g_mode INT;

  SELECT mode_id INTO g_mode FROM games WHERE id=g_id;

  INSERT INTO statistic_values(game_id,player_num,measure_id,name,chart_name)
  SELECT g_id,sc.player_num,sc.measure_id,IFNULL(sc.name,p.name),REPLACE(ch.name,'$p_name',p.name)
  FROM statistic_values_config sc INNER JOIN players p ON (sc.player_num=p.player_num)
  INNER JOIN statistic_charts ch ON (sc.chart_id=ch.id)
  WHERE sc.mode_id=g_mode AND p.game_id=g_id AND p.owner<>0;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `init_units`
--

DROP PROCEDURE IF EXISTS `init_units`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
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

/*All units must have no_card feature*/
  SET no_card_feature_id=unit_feature_get_id_by_code('no_card');
  INSERT INTO board_units_features(board_unit_id,feature_id)
  SELECT bu.id,no_card_feature_id FROM board_units bu WHERE bu.game_id=g_id;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `kill_unit`
--

DROP PROCEDURE IF EXISTS `kill_unit`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `kill_unit`(bu_id INT,p_num INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p2_num INT; /*unit owner*/
  DECLARE crd_id INT;
  DECLARE grave_id INT;
  DECLARE u_id INT;
  DECLARE reward INT DEFAULT 0;
  DECLARE kill_reward_divisor INT DEFAULT 2; /*get 1/2 of card cost */
  DECLARE binded_unit_id INT;

  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit убит")';

  SELECT game_id,player_num,card_id,unit_id INTO g_id,p2_num,crd_id,u_id FROM board_units WHERE id=bu_id LIMIT 1;

/*log*/
      SET cmd_log=REPLACE(cmd_log,'$log_unit',log_unit(bu_id));
      INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

/*grave*/
  IF crd_id IS NOT NULL THEN
    IF unit_feature_check(bu_id,'goes_to_deck_on_death') = 1 THEN
      INSERT INTO deck(game_id,card_id) VALUES(g_id,crd_id);
    ELSE /*put to grave*/
      INSERT INTO graves(game_id,card_id) VALUES(g_id,crd_id);
      SET grave_id=@@last_insert_id;
      INSERT INTO grave_cells(grave_id,x,y) SELECT grave_id,b.x,b.y FROM board b WHERE game_id=g_id AND b.`type`='unit' AND b.ref=bu_id;
      CALL cmd_add_to_grave(g_id,p_num,grave_id);
    END IF;
  END IF;

  CALL cmd_kill_unit(g_id,p_num,bu_id);

  DELETE FROM board WHERE game_id=g_id AND `type`='unit' AND ref=bu_id;
  DELETE FROM board_units_features WHERE board_unit_id=bu_id;
  DELETE FROM board_units WHERE id=bu_id;

/*reward*/
  SELECT IFNULL(cost/kill_reward_divisor,0) INTO reward FROM cards WHERE `type`='u' AND ref=u_id LIMIT 1;

/*if npc - take all his money*/
  IF ((SELECT owner FROM players WHERE game_id=g_id AND player_num=p2_num LIMIT 1)<>1)
    AND NOT EXISTS (SELECT id FROM board_units WHERE game_id=g_id AND player_num=p2_num)
    AND NOT EXISTS (SELECT id FROM board_buildings WHERE game_id=g_id AND player_num=p2_num)
  THEN /*if npc defeated*/
    SET reward=reward+(SELECT gold FROM players WHERE game_id=g_id AND player_num=p2_num LIMIT 1);
    DELETE FROM players WHERE game_id=g_id AND player_num=p2_num;
    CALL cmd_delete_player(g_id,p2_num);
  END IF;

  IF reward>0 THEN
    UPDATE players SET gold=gold+reward WHERE game_id=g_id AND player_num=p_num;
    CALL cmd_player_set_gold(g_id,p_num);
  END IF;

/*unbind all units binded to this unit*/
  DELETE FROM board_units_features WHERE feature_id IN(unit_feature_get_id_by_code('bind_target'),unit_feature_get_id_by_code('attack_target')) AND param=bu_id;

/*if necromancer is killed*/
  IF EXISTS(SELECT id FROM board_units_features WHERE feature_id=unit_feature_get_id_by_code('under_control') AND param=bu_id LIMIT 1)THEN
    CALL zombies_make_mad(g_id,bu_id);
  END IF;

  INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'kill_unit',p2_num);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `lake_summon_frogs`
--

DROP PROCEDURE IF EXISTS `lake_summon_frogs`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `lake_summon_frogs`(g_id INT, board_building_id INT)
BEGIN
  DECLARE frogs_count INT;
  DECLARE dice INT;

  IF EXISTS(SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id AND (unit_feature_check(bu.id,'parent_building')=0 OR unit_feature_get_param(bu.id,'parent_building')<>board_building_id) LIMIT 1) THEN
    SELECT COUNT(*) INTO frogs_count FROM board_units bu WHERE bu.game_id=g_id AND unit_feature_check(bu.id,'parent_building')=1 AND unit_feature_get_param(bu.id,'parent_building')=board_building_id;
    SET dice = POW(6,CASE WHEN frogs_count IN(0,1,2,3) THEN 1 ELSE frogs_count-2 END);
    IF(FLOOR(1 + (RAND() * dice))=1)THEN
      CALL summon_one_creature_by_config(board_building_id);
    END IF;
  END IF;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `magical_damage`
--

DROP PROCEDURE IF EXISTS `magical_damage`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `magical_damage`(g_id INT,p_num INT,x INT,y INT,damage INT)
BEGIN
  DECLARE aim_id INT;
  DECLARE aim_type VARCHAR(45);
  DECLARE aim_object_id INT;
  DECLARE damage_final INT;
  DECLARE magic_tower_board_id INT;
  DECLARE aim_health INT;
  DECLARE aim_shield INT DEFAULT 0;
  DECLARE aim_x,aim_y INT;

  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit $log_damage")';

  SET damage_final=damage;

/*Magic Tower*/
    SELECT bb.id INTO magic_tower_board_id FROM board b_mt JOIN board_buildings bb ON (b_mt.ref=bb.id)
      WHERE bb.game_id=g_id AND b_mt.`type`<>'unit' AND building_feature_check(bb.id,'magic_increase')=1 AND check_building_deactivated(bb.id)=0
      AND x BETWEEN b_mt.x-bb.radius AND b_mt.x+bb.radius AND y BETWEEN b_mt.y-bb.radius AND b_mt.y+bb.radius
      AND NOT(x=b_mt.x AND y=b_mt.y) LIMIT 1;
    IF (magic_tower_board_id IS NOT NULL) THEN
      SET damage_final=damage_final*building_feature_get_param(magic_tower_board_id,'magic_increase');
    END IF;

  SELECT b.`type`,b.ref INTO aim_type,aim_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y LIMIT 1;

  CASE
    WHEN aim_type='unit' THEN
    BEGIN
      SELECT bu.unit_id,shield,health INTO aim_object_id,aim_shield,aim_health FROM board_units bu WHERE bu.id=aim_id LIMIT 1;
      SELECT MIN(b.x),MIN(b.y) INTO aim_x,aim_y FROM board b WHERE b.game_id=g_id AND b.`type`=aim_type AND b.ref=aim_id;
    END;
    WHEN aim_type='building' OR aim_type='castle' THEN
    BEGIN
      SELECT bb.building_id INTO aim_object_id FROM board_buildings bb WHERE bb.id=aim_id LIMIT 1;
      SELECT b.x,b.y INTO aim_x,aim_y FROM board b WHERE b.game_id=g_id AND b.`type`=aim_type AND b.ref=aim_id LIMIT 1;
    END;
  END CASE;

  IF(aim_shield=0 AND damage_final<aim_health)THEN
/*log*/
      SET cmd_log=REPLACE(cmd_log,'$log_unit',log_unit(aim_id));
      SET cmd_log=REPLACE(cmd_log,'$log_damage',log_damage(damage));

      INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);
  END IF;

  CASE aim_type
    WHEN 'building' THEN CALL hit_building(aim_id,p_num,damage_final);
    WHEN 'unit' THEN
      IF (unit_feature_check(aim_id,'magic_immunity')=0) THEN /*if not magic-resistant*/
        CALL hit_unit(aim_id,p_num,damage_final);
      ELSE
        CALL cmd_magic_resistance_log(g_id,p_num,aim_id);
      END IF;
  END CASE;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `magical_heal`
--

DROP PROCEDURE IF EXISTS `magical_heal`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `magical_heal`(g_id INT,p_num INT,x INT,y INT,hp INT)
BEGIN
  DECLARE aim_id INT;
  DECLARE hp_final INT;
  DECLARE magic_tower_board_id INT;
  DECLARE is_hurt INT DEFAULT 1;
  DECLARE hp_minus INT;
  DECLARE shield_minus INT;

  SET hp_final=hp;

/*Magic Tower*/
    SELECT bb.id INTO magic_tower_board_id FROM board b_mt JOIN board_buildings bb ON (b_mt.ref=bb.id)
      WHERE bb.game_id=g_id AND b_mt.`type`<>'unit' AND building_feature_check(bb.id,'magic_increase')=1 AND check_building_deactivated(bb.id)=0
      AND x BETWEEN b_mt.x-bb.radius AND b_mt.x+bb.radius AND y BETWEEN b_mt.y-bb.radius AND b_mt.y+bb.radius
      AND NOT(x=b_mt.x AND y=b_mt.y) LIMIT 1;
    IF (magic_tower_board_id IS NOT NULL) THEN
      SET hp_final=hp_final*building_feature_get_param(magic_tower_board_id,'magic_increase');
    END IF;

  SELECT b.ref INTO aim_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y LIMIT 1;

    SELECT bu.max_health-bu.health,u.shield-bu.shield INTO hp_minus,shield_minus
    FROM board_units bu JOIN units u ON (bu.unit_id=u.id) WHERE bu.id=aim_id LIMIT 1;

    IF(unit_feature_check(aim_id,'paralich')=0 AND unit_feature_check(aim_id,'madness')=0 AND hp_minus=0 AND shield_minus=0)THEN
      SET is_hurt=0;
    END IF;

    IF (unit_feature_check(aim_id,'magic_immunity')=1 AND is_hurt=1) THEN /*if magic-resistant*/
      CALL cmd_magic_resistance_log(g_id,p_num,aim_id);
    ELSE
      IF (unit_feature_check(aim_id,'mechanical')=1 AND is_hurt=1) THEN /*if mechanical => magic-resistant*/
        CALL cmd_mechanical_log(g_id,p_num,aim_id);
      ELSE
        CALL heal_unit(aim_id,hp_final);
      END IF;
    END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `magical_shield_on`
--

DROP PROCEDURE IF EXISTS `magical_shield_on`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `magical_shield_on`(g_id INT,p_num INT,x INT,y INT)
BEGIN
  DECLARE aim_id INT;
  DECLARE shields INT;
  DECLARE magic_tower_board_id INT;

  SET shields=1;

/*Magic Tower*/
    SELECT bb.id INTO magic_tower_board_id FROM board b_mt JOIN board_buildings bb ON (b_mt.ref=bb.id)
      WHERE bb.game_id=g_id AND b_mt.`type`<>'unit' AND building_feature_check(bb.id,'magic_increase')=1 AND check_building_deactivated(bb.id)=0
      AND x BETWEEN b_mt.x-bb.radius AND b_mt.x+bb.radius AND y BETWEEN b_mt.y-bb.radius AND b_mt.y+bb.radius
      AND NOT(x=b_mt.x AND y=b_mt.y) LIMIT 1;
    IF (magic_tower_board_id IS NOT NULL) THEN
      SET shields=shields*building_feature_get_param(magic_tower_board_id,'magic_increase');
    END IF;

  SELECT b.ref INTO aim_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y LIMIT 1;

    IF (unit_feature_check(aim_id,'magic_immunity')=0) THEN /*if not magic-resistant*/
      WHILE shields>0 DO
        CALL shield_on(aim_id);
        SET shields=shields-1;
      END WHILE;
    ELSE
      CALL cmd_magic_resistance_log(g_id,p_num,aim_id);
    END IF;


END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `magic_kill_unit`
--

DROP PROCEDURE IF EXISTS `magic_kill_unit`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `magic_kill_unit`(board_unit_id INT,p_num INT)
BEGIN
  DECLARE g_id INT;
  DECLARE shield INT;

  SELECT bu.game_id,bu.shield INTO g_id,shield FROM board_units bu WHERE id=board_unit_id LIMIT 1;

          IF (unit_feature_check(board_unit_id,'magic_immunity')=0) THEN /*if not magic-resistant*/
            IF shield>0 THEN
              CALL shield_off(board_unit_id);
            ELSE
              CALL kill_unit(board_unit_id,p_num);
            END IF;
          ELSE
            CALL cmd_magic_resistance_log(g_id,p_num,board_unit_id);
          END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `make_mad`
--

DROP PROCEDURE IF EXISTS `make_mad`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `make_mad`(board_unit_id INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE u_id INT;
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit уже сошел с ума")';

  SELECT bu.game_id,bu.player_num,bu.unit_id INTO g_id,p_num,u_id FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

  IF (unit_feature_check(board_unit_id,'madness')=0) THEN /*if not mad already*/
    CALL unit_feature_set(board_unit_id,'madness',p_num);
    CALL cmd_unit_add_effect(g_id,board_unit_id,'madness');

    IF EXISTS(SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id AND bu.player_num=p_num AND bu.id<>board_unit_id LIMIT 1)
      OR EXISTS(SELECT bb.id FROM board_buildings bb WHERE bb.game_id=g_id AND bb.player_num=p_num LIMIT 1) THEN
/*player has another unit or building - create new mad player*/
    BEGIN
      DECLARE new_player,team INT;
      DECLARE mad_name VARCHAR(45) CHARSET utf8 DEFAULT 'Сумасшедший $u_name';

      SET mad_name=REPLACE(mad_name,'$u_name',(SELECT name FROM units WHERE id=u_id LIMIT 1));
      SELECT MAX(p.team)+1 INTO team FROM players p WHERE p.game_id=g_id;
      SELECT CASE WHEN MAX(p.player_num)<10 THEN 10 ELSE MAX(p.player_num)+1 END INTO new_player FROM players p WHERE p.game_id=g_id;

      INSERT INTO players(game_id,player_num,name,gold,owner,team) VALUES(g_id,new_player,mad_name,0,2,team); /*owner=2 - frog*/
      CALL cmd_add_player(g_id,new_player);

      UPDATE board_units SET player_num=new_player WHERE id=board_unit_id;
      CALL cmd_unit_set_owner(g_id,p_num,board_unit_id);

/*zombies become MAD*/
      IF EXISTS(SELECT id FROM board_units_features WHERE feature_id=unit_feature_get_id_by_code('under_control') AND param=board_unit_id LIMIT 1)THEN
        CALL zombies_make_mad(g_id,board_unit_id);
      END IF;
    END;
    END IF;
  ELSE
/*already mad*/
    SET cmd_log=REPLACE(cmd_log,'$log_unit',log_unit(board_unit_id));
    INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `make_not_mad`
--

DROP PROCEDURE IF EXISTS `make_not_mad`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `make_not_mad`(board_unit_id INT)
BEGIN
  DECLARE g_id INT;
  DECLARE mad_p_num,normal_p_num INT;

  SELECT bu.game_id,bu.player_num,unit_feature_get_param(board_unit_id,'madness') INTO g_id,mad_p_num,normal_p_num FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

  IF (normal_p_num IS NOT NULL) THEN /*if mad*/

    CALL unit_feature_remove(board_unit_id,'madness');
    CALL cmd_unit_remove_effect(g_id,board_unit_id,'madness');

    IF (mad_p_num<>normal_p_num) THEN
    BEGIN
/*return unit to previous player*/
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

/*zombies change player too*/
      IF EXISTS(SELECT id FROM board_units_features WHERE feature_id=unit_feature_get_id_by_code('under_control') AND param=board_unit_id LIMIT 1)THEN
        CALL zombies_change_player_to_nec(board_unit_id);
      END IF;

    END;
    END IF;

  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `mode_copy`
--

DROP PROCEDURE IF EXISTS `mode_copy`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `mode_copy`(old_mode_id INT, mode_name VARCHAR(45) CHARSET utf8, copy_cards_units_buildings INT)
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

  INSERT INTO videos(code,filename,title,mode_id)
  SELECT v.code,v.filename,v.title,new_mode_id FROM videos v WHERE v.mode_id = old_mode_id;

  INSERT INTO statistic_values_config(player_num,chart_id,measure_id,color,name,mode_id)
  SELECT c.player_num,c.chart_id,c.measure_id,c.color,c.name,new_mode_id FROM statistic_values_config c WHERE c.mode_id = old_mode_id;

  IF(copy_cards_units_buildings = 0)THEN
/*TODO*/
    select 1;
  ELSE
  BEGIN
    DECLARE card_id_old INT;
    DECLARE card_id_new INT;
    DECLARE card_image VARCHAR(45) CHARSET utf8;
    DECLARE card_cost INT;
    DECLARE card_type VARCHAR(45) CHARSET utf8;
    DECLARE card_ref INT;
    DECLARE card_name VARCHAR(45) CHARSET utf8;
    DECLARE card_description VARCHAR(1000) CHARSET utf8;

    DECLARE building_id_old INT;
    DECLARE building_id_new INT;
    DECLARE building_name VARCHAR(45) CHARSET utf8;
    DECLARE building_health INT;
    DECLARE building_radius INT;
    DECLARE building_x_len INT;
    DECLARE building_y_len INT;
    DECLARE building_shape VARCHAR(45) CHARSET utf8;
    DECLARE building_type VARCHAR(45) CHARSET utf8;
    DECLARE building_description VARCHAR(1000) CHARSET utf8;
    DECLARE building_log_short_name VARCHAR(45) CHARSET utf8;
    DECLARE building_ui_code VARCHAR(45) CHARSET utf8;

    DECLARE unit_id_old INT;
    DECLARE unit_id_new INT;
    DECLARE unit_name VARCHAR(45) CHARSET utf8;
    DECLARE unit_moves INT;
    DECLARE unit_health INT;
    DECLARE unit_attack INT;
    DECLARE unit_size INT;
    DECLARE unit_shield INT;
    DECLARE unit_description VARCHAR(1000) CHARSET utf8;
    DECLARE unit_log_short_name VARCHAR(45) CHARSET utf8;
    DECLARE unit_name_rod_pad VARCHAR(45) CHARSET utf8;
    DECLARE unit_ui_code VARCHAR(45) CHARSET utf8;

    DECLARE done INT DEFAULT 0;
    DECLARE cur_cards CURSOR FOR SELECT c.id,c.image,c.cost,c.`type`,c.ref,c.name,c.description FROM vw_mode_cards c WHERE c.mode_id=old_mode_id;
    DECLARE cur_buildings CURSOR FOR SELECT b.id,b.name,b.health,b.radius,b.x_len,b.y_len,b.shape, b.`type`,b.description,b.log_short_name,b.ui_code FROM vw_mode_buildings b WHERE b.mode_id=old_mode_id;
    DECLARE cur_units CURSOR FOR SELECT u.id,u.name,u.moves,u.health,u.attack,u.size,u.shield,u.description,u.log_short_name,u.log_name_rod_pad,u.ui_code FROM vw_mode_units u WHERE u.mode_id=old_mode_id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    CREATE TEMPORARY TABLE cards_ids (id_old INT,id_new INT);
    CREATE TEMPORARY TABLE buildings_ids (id_old INT,id_new INT);
    CREATE TEMPORARY TABLE units_ids (id_old INT,id_new INT);

    OPEN cur_cards;
    REPEAT
      FETCH cur_cards INTO card_id_old,card_image,card_cost,card_type,card_ref,card_name,card_description;
      IF NOT done THEN
        INSERT INTO cards(image,cost,`type`,ref,name,description)
        VALUES(card_image,card_cost,card_type,card_ref,card_name,card_description);
        SET card_id_new = @@last_insert_id;

        INSERT INTO cards_ids(id_old,id_new) VALUES(card_id_old,card_id_new);

        INSERT INTO cards_procedures(card_id,procedure_id)
        SELECT card_id_new,cp.procedure_id FROM cards_procedures cp WHERE cp.card_id=card_id_old;

        INSERT INTO modes_cards(mode_id,card_id)
        SELECT new_mode_id,card_id_new FROM modes_cards mc WHERE mc.mode_id=old_mode_id AND mc.card_id=card_id_old;

      END IF;
    UNTIL done END REPEAT;
    CLOSE cur_cards;
    SET done=0;

    OPEN cur_buildings;
    REPEAT
      FETCH cur_buildings INTO building_id_old,building_name,building_health,building_radius,building_x_len,building_y_len,building_shape,building_type,building_description,building_log_short_name,building_ui_code;
      IF NOT done THEN
        INSERT INTO buildings(name,health,radius,x_len,y_len,shape,`type`,description,log_short_name,ui_code)
        VALUES(building_name,building_health,building_radius,building_x_len,building_y_len,building_shape,building_type,building_description,building_log_short_name,building_ui_code);
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

      END IF;
    UNTIL done END REPEAT;
    CLOSE cur_buildings;
    SET done=0;

    OPEN cur_units;
    REPEAT
      FETCH cur_units INTO unit_id_old,unit_name,unit_moves,unit_health,unit_attack,unit_size,unit_shield,unit_description,unit_log_short_name,unit_name_rod_pad,unit_ui_code;
      IF NOT done THEN
        INSERT INTO units(name,moves,health,attack,size,shield,description,log_short_name,log_name_rod_pad,ui_code)
        VALUES(unit_name,unit_moves,unit_health,unit_attack,unit_size,unit_shield,unit_description,unit_log_short_name,unit_name_rod_pad,unit_ui_code);
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

        INSERT INTO dic_unit_phrases(unit_id,phrase)
        SELECT unit_id_new,p.phrase FROM dic_unit_phrases p WHERE p.unit_id=unit_id_old;

      END IF;
    UNTIL done END REPEAT;
    CLOSE cur_units;

    UPDATE cards,cards_ids,buildings_ids
    SET cards.ref=buildings_ids.id_new
    WHERE cards.id=cards_ids.id_new AND cards.`type`='b' AND cards.ref=buildings_ids.id_old;

    UPDATE cards,cards_ids,units_ids
    SET cards.ref=units_ids.id_new
    WHERE cards.id=cards_ids.id_new AND cards.`type`='u' AND cards.ref=units_ids.id_old;

    INSERT INTO summon_cfg(player_name,building_id,unit_id,`count`,owner,mode_id)
    SELECT c.player_name,b.id_new,u.id_new,c.`count`,c.owner,new_mode_id
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


END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `mode_delete`
--

DROP PROCEDURE IF EXISTS `mode_delete`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `mode_delete`(mode_id INT, delete_not_used_cards_units_buildings INT)
BEGIN
  DELETE FROM modes WHERE id=mode_id;

  IF(delete_not_used_cards_units_buildings = 1)THEN
    DELETE FROM cards WHERE id NOT IN (SELECT id FROM vw_mode_cards);
    DELETE FROM buildings WHERE id NOT IN (SELECT id FROM vw_mode_buildings);
    DELETE FROM units WHERE id NOT IN (SELECT id FROM vw_mode_units);
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `mountains_summon_troll`
--

DROP PROCEDURE IF EXISTS `mountains_summon_troll`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `mountains_summon_troll`(g_id INT, board_building_id INT)
BEGIN
  DECLARE troll_count INT;
  DECLARE dice INT;

  IF EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.`type`='building' LIMIT 1) THEN
    SELECT COUNT(*) INTO troll_count FROM board_units bu WHERE bu.game_id=g_id AND unit_feature_check(bu.id,'parent_building')=1 AND unit_feature_get_param(bu.id,'parent_building')=board_building_id;
    SET dice = POW(6,troll_count+1);
    IF(FLOOR(1 + (RAND() * dice))=1)THEN
      CALL summon_one_creature_by_config(board_building_id);
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `move_unit`
--

DROP PROCEDURE IF EXISTS `move_unit`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `move_unit`(board_unit_id INT,x2 INT,y2 INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE x,y INT;
  DECLARE delta_x,delta_y INT;
  DECLARE u_id INT;

  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_move_message($x,$y,$x2,$y2,$p_num,"$u_short_name")';

  SELECT bu.game_id,bu.player_num,bu.unit_id INTO g_id,p_num,u_id FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;
  SELECT MIN(b.x),MIN(b.y) INTO x,y FROM board b WHERE b.`type`='unit' AND b.ref=board_unit_id;
  SET delta_x=x2-x;
  SET delta_y=y2-y;
  UPDATE board b SET b.x=b.x+delta_x,b.y=b.y+delta_y WHERE b.`type`='unit' AND b.ref=board_unit_id;

  CALL cmd_move_unit(g_id,p_num,x,y,x2,y2);

/*log*/
      SET cmd_log=REPLACE(cmd_log,'$p_num',p_num);
      SET cmd_log=REPLACE(cmd_log,'$u_short_name',(SELECT log_short_name FROM units WHERE id=u_id LIMIT 1));
      SET cmd_log=REPLACE(cmd_log,'$x,$y',CONCAT(x,',',y));
      SET cmd_log=REPLACE(cmd_log,'$x2,$y2',CONCAT(x2,',',y2));
      INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `necromancer_resurrect`
--

DROP PROCEDURE IF EXISTS `necromancer_resurrect`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `necromancer_resurrect`(g_id INT,p_num INT,x INT,y INT,grave_id INT)
BEGIN
  DECLARE dead_card_id INT;
  DECLARE err_code INT;
  DECLARE u2_id INT;
  DECLARE board_unit_id INT;
  DECLARE new_unit_id INT;
  DECLARE resur_cost INT;

  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit1 воскрешает $log_unit2_rod_pad")';

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'necromancer_resurrect'); /*unit can do it*/
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT id FROM graves WHERE game_id=g_id AND id=grave_id LIMIT 1) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=8;/*Card not in grave*/
    ELSE
      IF NOT EXISTS (SELECT id FROM grave_cells gc WHERE grave_id=grave_id AND check_one_step_from_unit(g_id,x,y,gc.x,gc.y)=1 LIMIT 1) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=34;/*grave is out of range*/
      ELSE
        IF EXISTS (SELECT b.id FROM board b JOIN grave_cells gc ON (b.x=gc.x AND b.y=gc.y) WHERE b.game_id=g_id AND gc.grave_id=grave_id LIMIT 1) THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=12;/*place occupied*/
        ELSE
          SELECT g.card_id INTO dead_card_id FROM graves g WHERE id=grave_id;
          SELECT c.cost INTO resur_cost FROM cards c WHERE c.id=dead_card_id LIMIT 1;
          IF (SELECT gold FROM players WHERE game_id=g_id AND player_num=p_num LIMIT 1)<resur_cost THEN
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=2;/*Not enough gold*/
          ELSE
/*OK*/
            CALL user_action_begin();

            IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
              CALL start_moving_units(g_id,p_num);
            END IF;

            UPDATE players SET gold=gold-resur_cost WHERE game_id=g_id AND player_num=p_num;
            CALL cmd_player_set_gold(g_id,p_num);

            SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;
            SELECT c.ref INTO u2_id FROM cards c WHERE c.id=dead_card_id LIMIT 1;

            UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
            CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);


            INSERT INTO board_units(game_id,player_num,card_id) VALUES (g_id,p_num,dead_card_id);
            SET new_unit_id=@@last_insert_id;
            INSERT INTO board_units_features(board_unit_id,feature_id,param) SELECT new_unit_id,ufu.feature_id,ufu.param FROM unit_default_features ufu WHERE ufu.unit_id=u2_id;
            UPDATE board_units SET moves_left=0 WHERE id=new_unit_id;
/*zombie*/
            INSERT INTO board_units_features(board_unit_id,feature_id,param) SELECT new_unit_id,unit_feature_get_id_by_code('under_control'),board_unit_id;

            INSERT INTO board(game_id,x,y,`type`,ref) SELECT g_id,gc.x,gc.y,'unit',new_unit_id FROM grave_cells gc WHERE gc.grave_id=grave_id;
            DELETE FROM graves WHERE game_id=g_id AND id=grave_id;

            CALL cmd_add_unit(g_id,p_num,new_unit_id);
            CALL cmd_remove_from_grave(g_id,p_num,grave_id);
            CALL cmd_unit_set_moves_left(g_id,p_num,new_unit_id);

            INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'resurrect_unit',u2_id);

/*log*/
            SET cmd_log=REPLACE(cmd_log,'$log_unit1',log_unit(board_unit_id));
            SET cmd_log=REPLACE(cmd_log,'$log_unit2_rod_pad',log_unit_rod_pad(new_unit_id));
            INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

            IF NOT EXISTS(SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id AND bu.player_num=p_num AND moves_left>0 AND unit_feature_check(bu.id,'paralich')=0 LIMIT 1) THEN
              CALL finish_moving_units(g_id,p_num);
              CALL end_turn(g_id,p_num);
            END IF;

            CALL user_action_end();

          END IF;
        END IF;
      END IF;
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `necromancer_sacrifice`
--

DROP PROCEDURE IF EXISTS `necromancer_sacrifice`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `necromancer_sacrifice`(g_id INT,p_num INT,x INT,y INT,x_sacr INT,y_sacr INT, x_target INT, y_target INT)
BEGIN
  DECLARE err_code INT;
  DECLARE sacr_bu_id INT;
  DECLARE target_bu_id INT;
  DECLARE board_unit_id INT;
  DECLARE sacr_health INT;
  DECLARE damage_bonus INT DEFAULT 1;

  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit1 жертвует $log_unit2_rod_pad за $log_unit3_rod_pad")';

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'necromancer_sacrifice'); /*unit can do it*/
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    SELECT b.ref INTO sacr_bu_id FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.x=x_sacr AND b.y=y_sacr LIMIT 1;
    IF sacr_bu_id IS NULL THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=37;/*Noone to sacrifice*/
    ELSE
      IF (SELECT player_num FROM board_units WHERE id=sacr_bu_id)<>p_num THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=38;/*Can sacrifice only own unit*/
      ELSE
        SELECT b.ref INTO target_bu_id FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.x=x_target AND b.y=y_target LIMIT 1;
        IF target_bu_id IS NULL THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=39;/*Noone to sacrifice*/
        ELSE
/*OK*/
          CALL user_action_begin();

          IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
            CALL start_moving_units(g_id,p_num);
          END IF;

          SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;

          UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
          CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

/*log*/
          SET cmd_log=REPLACE(cmd_log,'$log_unit1',log_unit(board_unit_id));
          SET cmd_log=REPLACE(cmd_log,'$log_unit2_rod_pad',log_unit_rod_pad(sacr_bu_id));
          SET cmd_log=REPLACE(cmd_log,'$log_unit3_rod_pad',log_unit_rod_pad(target_bu_id));
          IF(sacr_bu_id=target_bu_id) THEN
            SET cmd_log=REPLACE(cmd_log,'")',CONCAT('. ',log_unit(board_unit_id),' такой ',log_unit(board_unit_id),'")'));
          END IF;
          INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

          IF (unit_feature_check(sacr_bu_id,'magic_immunity')=1) THEN /*if magic-resistant*/
            CALL cmd_magic_resistance_log(g_id,p_num,board_unit_id);
          ELSE

/*TODO shields? */

            SELECT bu.health INTO sacr_health FROM board_units bu WHERE bu.id=sacr_bu_id;

            CALL unit_feature_set(sacr_bu_id,'goes_to_deck_on_death',null);
            CALL kill_unit(sacr_bu_id,p_num);
            
            IF(sacr_bu_id<>target_bu_id)THEN
              CALL magical_damage(g_id,p_num,x_target,y_target,sacr_health+damage_bonus);
            END IF;

          END IF;

          IF NOT EXISTS(SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id AND bu.player_num=p_num AND moves_left>0 AND unit_feature_check(bu.id,'paralich')=0 LIMIT 1) THEN
            CALL finish_moving_units(g_id,p_num);
            CALL end_turn(g_id,p_num);
          END IF;

          CALL user_action_end();

        END IF;
      END IF;
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `place_building_on_board`
--

DROP PROCEDURE IF EXISTS `place_building_on_board`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `place_building_on_board`(board_building_id INT,x INT,y INT,rotation INT,flip INT)
BEGIN
  DECLARE g_id INT;
  DECLARE b_id INT;
  DECLARE b_type VARCHAR(45);
  DECLARE x_len,y_len INT;
  DECLARE shape VARCHAR(45);
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
  INSERT INTO busy_coords (x,y) SELECT b.x,b.y FROM board b WHERE b.game_id=g_id AND NOT(b.`type` IN('building','obstacle') AND b.ref=board_building_id); /*don't include coords occupied by building itself if any*/
  INSERT INTO busy_coords (x,y) SELECT b.x+IF(b.x=0,1,-1),b.y+IF(b.y=0,1,-1) FROM board b WHERE b.game_id=g_id AND (b.x=0 OR b.x=19) AND (b.y=0 OR b.y=19) AND b.`type`='castle';

  IF NOT EXISTS(SELECT b.id FROM busy_coords b JOIN put_coords p ON (b.x=p.x AND b.y=p.y)) THEN /*If all points free - insert into board, else don't insert, can't place on appearing point*/
    INSERT INTO board(game_id,x,y,`type`,ref) SELECT g_id,p_c.x,p_c.y,b_type,board_building_id FROM put_coords p_c;
  END IF;
  DROP TEMPORARY TABLE put_coords;
  DROP TEMPORARY TABLE busy_coords;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `player_end_turn`
--

DROP PROCEDURE IF EXISTS `player_end_turn`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `player_end_turn`(g_id INT,p_num INT)
BEGIN
  DECLARE cmd_independent_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_independent_message($p_num,"Завершил ход")';
  DECLARE moved_units INT;
  DECLARE moves_to_auto_repair INT DEFAULT 2;
  DECLARE moves_ended INT DEFAULT 2;
  DECLARE end_turn_feature_id INT;
  DECLARE owner INT;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;/*Not your turn*/
  ELSE
    CALL user_action_begin();

    SELECT units_moves_flag INTO moved_units FROM active_players WHERE game_id=g_id LIMIT 1;
    SELECT p.owner INTO owner FROM players p WHERE p.game_id=g_id AND p.player_num=p_num LIMIT 1;

    IF moved_units=1 OR owner<>1 THEN
      CALL cmd_player_end_turn(g_id,p_num);
      CALL finish_moving_units(g_id,p_num);
    ELSE
      SET cmd_independent_log=REPLACE(cmd_independent_log,'$p_num',p_num);
      INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_independent_log);
    END IF;

    /*castle auto repair*/
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
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `player_end_turn_by_timeout`
--

DROP PROCEDURE IF EXISTS `player_end_turn_by_timeout`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `player_end_turn_by_timeout`(g_id INT,p_num INT)
BEGIN
  DECLARE cmd_independent_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_independent_message($p_num,"У игрока $log_player закончилось время хода")';

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;/*Not your turn*/
  ELSE
    CALL user_action_begin();

    IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=1 THEN
      CALL cmd_player_end_turn_schedule(g_id,p_num);
      CALL finish_moving_units(g_id,p_num);
    ELSE
      SET cmd_independent_log=REPLACE(cmd_independent_log,'$p_num',p_num);
      SET cmd_independent_log=REPLACE(cmd_independent_log,'$log_player',log_player(g_id,p_num));
      INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_independent_log);
    END IF;

    CALL end_turn(g_id,p_num);

    CALL user_action_end();
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `player_exit`
--

DROP PROCEDURE IF EXISTS `player_exit`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `player_exit`(g_id INT,p_num INT)
BEGIN
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_independent_message($p_num,"$log_player вышел из игры")';
  DECLARE p_id INT;
  DECLARE finished_game_status INT DEFAULT 3; /*NOTE hardcode because this id is unlikely to change*/
  DECLARE user_id INT;
  DECLARE owner INT;
  DECLARE player_online_status_id INT DEFAULT 1; /*NOTE hardcode because this id is unlikely to change*/

  CALL user_action_begin();

  SELECT p.id,p.owner,p.user_id INTO p_id,owner,user_id FROM players p WHERE game_id=g_id AND player_num=p_num;

  IF (SELECT g.status_id FROM games g WHERE g.id=g_id LIMIT 1)<>finished_game_status AND (owner=1) THEN
    SET cmd_log=REPLACE(cmd_log,'$p_num',p_num);
    SET cmd_log=REPLACE(cmd_log,'$log_player',log_player(g_id,p_num));
    INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

    CALL delete_player_objects(g_id,p_num);

    IF (SELECT player_num FROM active_players WHERE game_id=g_id LIMIT 1)=p_num THEN
      CALL end_turn(g_id,p_num);
    END IF;

    CALL cmd_delete_player(g_id,p_num);

    UPDATE players SET owner=0 WHERE game_id=g_id AND player_num=p_num;

    IF (SELECT COUNT(DISTINCT p.team) FROM players p WHERE p.game_id=g_id AND p.owner=1)=1 THEN
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
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `player_move_unit`
--

DROP PROCEDURE IF EXISTS `player_move_unit`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `player_move_unit`(g_id INT,p_num INT,x INT,y INT, x2 INT, y2 INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE size INT;
  DECLARE p_team INT;
  DECLARE moveable INT DEFAULT 0;
  DECLARE teleportable INT DEFAULT 0;
  DECLARE taran_unit_id INT;
  DECLARE taran_x,taran_y,taran_prev_x,taran_prev_y INT;
  DECLARE x0,y0 INT;

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'player_move_unit'); /*unit can do it*/
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
    SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;
    SELECT u.size INTO size FROM board_units bu JOIN units u ON (bu.unit_id=u.id) WHERE bu.id=board_unit_id LIMIT 1;

    SET moveable=check_one_step_from_unit(g_id,x,y,x2,y2);

/*if can't step there and not magic resistant and there is a teleport - set teleportable*/
    SELECT p.team INTO p_team FROM players p WHERE p.game_id=g_id AND p.player_num=p_num LIMIT 1;
    IF (moveable=0)AND(unit_feature_check(board_unit_id,'magic_immunity')=0) AND EXISTS
    (SELECT a.id FROM board_buildings bb,board b,allcoords a,players p
      WHERE bb.game_id=g_id AND building_feature_check(bb.id,'teleport')=1 AND check_building_deactivated(bb.id)=0
      AND p.game_id=g_id AND p.player_num=bb.player_num AND p.team=p_team
      AND b.`type`<>'unit' AND b.ref=bb.id
      AND a.mode_id=mode_id
      AND a.x BETWEEN b.x-bb.radius AND b.x+bb.radius AND a.y BETWEEN b.y-bb.radius AND b.y+bb.radius
      AND a.x BETWEEN x2 AND x2+size-1 AND a.y BETWEEN y2 AND y2+size-1 LIMIT 1)
    THEN
      SET teleportable=1;
    END IF;
    IF moveable=0 AND teleportable=0
    THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=19;/*Out of range*/
    ELSE
      IF EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x BETWEEN x2 AND x2+size-1 AND b.y BETWEEN y2 AND y2+size-1 AND NOT(b.`type`='unit' AND b.ref=board_unit_id) LIMIT 1) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=12;/*Place occupied*/
      ELSE
/*OK*/
                CALL user_action_begin();

                IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
                  CALL start_moving_units(g_id,p_num);
                END IF;

                /*if Taran is moving, unbind him*/
                IF (unit_feature_get_param(board_unit_id,'bind_target') IS NOT NULL) THEN
                  CALL unit_feature_remove(board_unit_id,'bind_target');
                END IF; /*unbind taran*/

                SELECT MIN(b.x),MIN(b.y) INTO x0,y0 FROM board b WHERE b.game_id=g_id AND b.ref=board_unit_id AND b.`type`='unit';

                CALL move_unit(board_unit_id,x2,y2);
                UPDATE board_units bu SET bu.moves_left=CASE WHEN teleportable=1 THEN 0 ELSE bu.moves_left-1 END WHERE bu.id=board_unit_id;
                CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

/*if taran is binded to this unit - move taran*/
                SELECT bu.id INTO taran_unit_id FROM board_units bu WHERE unit_feature_get_param(bu.id,'bind_target')=board_unit_id LIMIT 1;
                IF taran_unit_id IS NOT NULL THEN
                  IF teleportable=1 THEN
                    CALL unit_feature_remove(taran_unit_id,'bind_target');
                  ELSE
                    IF (size=1) THEN
                      SET taran_x=x;
                      SET taran_y=y;
                    ELSE /*select place for taran if binded to a dragon*/
                      SELECT b.x,b.y INTO taran_prev_x,taran_prev_y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=taran_unit_id LIMIT 1;
                      SELECT a.x,a.y INTO taran_x,taran_y FROM allcoords a WHERE a.mode_id=mode_id AND a.x BETWEEN x0 AND x0+size-1 AND a.y BETWEEN y0 AND y0+size-1 AND a.x BETWEEN x2-1 AND x2+size AND a.y BETWEEN y2-1 AND y2+size AND NOT (a.x BETWEEN x2 AND x2+size-1 AND a.y BETWEEN y2 AND y2+size-1) ORDER BY ((taran_prev_x-a.x)*(taran_prev_x-a.x)+(taran_prev_y-a.y)*(taran_prev_y-a.y)) LIMIT 1;
                    END IF;
                    CALL move_unit(taran_unit_id,taran_x,taran_y);
                  END IF;
                END IF;


                IF NOT EXISTS(SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id AND bu.player_num=p_num AND moves_left>0 AND unit_feature_check(bu.id,'paralich')=0 LIMIT 1) THEN
                  CALL finish_moving_units(g_id,p_num);
                  CALL end_turn(g_id,p_num);
                END IF;

                CALL user_action_end();
      END IF;
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `player_resurrect`
--

DROP PROCEDURE IF EXISTS `player_resurrect`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `player_resurrect`(g_id INT,p_num INT,grave_id INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE dead_card_id INT;
  DECLARE resurrection_cost_coefficient INT;
  DECLARE resur_cost INT;
  DECLARE x_appear,y_appear,x_dir,y_dir INT;
  DECLARE new_unit_id INT;
  DECLARE size INT;
  DECLARE u_id INT;

  DECLARE cmd_independent_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_independent_message($p_num,"Воскресил $log_unit_rod_pad")';

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
  SELECT cfg.`value` INTO resurrection_cost_coefficient FROM mode_config cfg WHERE cfg.param='resurrection cost coefficient' AND cfg.mode_id=mode_id;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;/*Not your turn*/
  ELSE
    IF (SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id LIMIT 1)<>0 THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=28;/*polza/vred in progress*/
    ELSE
      IF (SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=1 THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=7;/*Already moved units*/
      ELSE
        IF NOT EXISTS(SELECT id FROM graves WHERE game_id=g_id AND id=grave_id LIMIT 1) THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=8;/*Card not in grave*/
        ELSE
          SELECT g.card_id INTO dead_card_id FROM graves g WHERE id=grave_id;
          SELECT cost*resurrection_cost_coefficient INTO resur_cost FROM cards WHERE id=dead_card_id LIMIT 1;
          IF (SELECT gold FROM players WHERE game_id=g_id AND player_num=p_num LIMIT 1)<resur_cost THEN
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=2;/*Not enough gold*/
          ELSE
            SELECT ap.x,ap.y,ap.direction_into_board_x,ap.direction_into_board_y INTO x_appear,y_appear,x_dir,y_dir FROM appear_points ap WHERE ap.mode_id=mode_id AND ap.player_num=p_num;
            SELECT u.id,u.size INTO u_id,size FROM cards c JOIN units u ON c.ref=u.id WHERE c.id=dead_card_id LIMIT 1;
            IF EXISTS(SELECT id FROM board WHERE game_id=g_id AND x BETWEEN LEAST(x_appear,x_appear+x_dir*(size-1)) AND GREATEST(x_appear,x_appear+x_dir*(size-1)) AND y BETWEEN LEAST(y_appear,y_appear+y_dir*(size-1)) AND GREATEST(y_appear,y_appear+y_dir*(size-1)) LIMIT 1) THEN
              SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=9;/*Appear point occupied*/
            ELSE
              CALL user_action_begin();

              UPDATE players SET gold=gold-resur_cost WHERE game_id=g_id AND player_num=p_num;
              CALL cmd_player_set_gold(g_id,p_num);

              CALL resurrect(g_id,p_num,grave_id);
/*log*/
              SET cmd_independent_log=REPLACE(cmd_independent_log,'$p_num',p_num);
              SET cmd_independent_log=REPLACE(cmd_independent_log,'$log_unit_rod_pad',log_unit_rod_pad((SELECT MAX(id) FROM board_units bu WHERE bu.game_id=g_id AND bu.player_num=p_num))); /*hope that resurrected unit has max id*/
              INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_independent_log);

              CALL end_turn(g_id,p_num);

              CALL user_action_end();
            END IF;
          END IF;
        END IF;
      END IF;
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `play_card_actions`
--

DROP PROCEDURE IF EXISTS `play_card_actions`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `play_card_actions`(g_id INT,p_num INT,player_deck_id INT)
BEGIN
/*Set gold, remove card, update log*/
  DECLARE crd_id INT;
  DECLARE card_cost INT;
  DECLARE card_type VARCHAR(5);
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_container($p_num,"Сыграл карту <b class=\'logCard\'>$card_name</b>")';

  SELECT card_id INTO crd_id FROM player_deck WHERE id=player_deck_id;

/*set gold*/
  SELECT cost,`type` INTO card_cost,card_type FROM cards WHERE id=crd_id LIMIT 1;
  IF card_cost>0 THEN
    UPDATE players SET gold=gold-card_cost WHERE game_id=g_id AND player_num=p_num;
    CALL cmd_player_set_gold(g_id,p_num);
  END IF;
/*remove card*/
  DELETE FROM player_deck WHERE id=player_deck_id;
  CALL cmd_remove_card(g_id,p_num,player_deck_id);
  IF(card_type IN ('m','e'))THEN INSERT INTO deck(game_id,card_id) VALUES(g_id,crd_id); END IF;
/*log*/
  SET cmd_log=REPLACE(cmd_log,'$p_num',p_num);
  SET cmd_log=REPLACE(cmd_log,'$card_name',(SELECT name FROM cards WHERE id=crd_id LIMIT 1));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);
  INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'play_card',crd_id);
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `put_building`
--

DROP PROCEDURE IF EXISTS `put_building`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `put_building`(g_id INT,p_num INT,player_deck_id INT,x INT,y INT,rotation INT,flip INT)
BEGIN
  DECLARE crd_id INT;
  DECLARE err_code INT;
  DECLARE x_len,y_len INT;
  DECLARE x2,y2 INT; /*For determining whether whole building is in player's zone, if (x,y) and (x2,y2) are*/
  DECLARE new_building_id INT;
  DECLARE card_cost INT;
  DECLARE cmd VARCHAR(1000) CHARSET utf8;

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
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=11;/*Not whole in player's zone*/
    ELSE
      CALL user_action_begin();

      INSERT INTO board_buildings(game_id,player_num,card_id,rotation,flip)VALUES (g_id,p_num,crd_id,rotation,flip);
      SET new_building_id=@@last_insert_id;

      CALL place_building_on_board(new_building_id,x,y,rotation,flip);

      IF NOT EXISTS(SELECT id FROM board WHERE game_id=g_id AND `type`<>'unit' AND ref=new_building_id) THEN /*Building not placed*/
        DELETE FROM board_buildings WHERE id=new_building_id;
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=12;/*Place occupied*/
      ELSE

        INSERT INTO board_buildings_features(board_building_id,feature_id,param) SELECT new_building_id,bfu.feature_id,bfu.param FROM board_buildings bb JOIN building_default_features bfu ON (bb.building_id=bfu.building_id) WHERE bb.id=new_building_id;
/*frog and troll factory set team*/
        UPDATE board_buildings_features bbf
        SET param=
          (SELECT MAX(a.team)+1
          FROM
          (SELECT p.team as `team` FROM players p WHERE p.game_id=g_id
          UNION
          SELECT building_feature_get_param(bb.id,'summon_team')
          FROM board_buildings bb WHERE bb.game_id=g_id AND building_feature_check(bb.id,'summon_team')=1) a)
        WHERE bbf.board_building_id=new_building_id AND bbf.feature_id=6;

        CALL count_income(new_building_id);

        CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

/*put building*/
        CALL cmd_put_building(g_id,p_num,new_building_id);

/*summon creatures*/
        IF EXISTS(SELECT sc.id FROM summon_cfg sc WHERE sc.building_id=(SELECT bb.building_id FROM board_buildings bb WHERE id=new_building_id)) THEN
          CALL summon_creatures(new_building_id);
        END IF;

        CALL finish_playing_card(g_id,p_num);
        CALL end_turn(g_id,p_num);

        CALL user_action_end();
      END IF;
    END IF;
  END IF;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `repair_buildings`
--

DROP PROCEDURE IF EXISTS `repair_buildings`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `repair_buildings`(g_id INT,p_num INT)
BEGIN
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Здание $log_building починено")';
  DECLARE board_building_id INT;
  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT bb.id FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.game_id=g_id AND bb.player_num=p_num AND bb.health<bb.max_health;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  OPEN cur;
  REPEAT
    FETCH cur INTO board_building_id;
    IF NOT done THEN
      INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,REPLACE(cmd_log,'$log_building',log_building(board_building_id)));
      UPDATE board_buildings SET health=max_health WHERE id=board_building_id;
      CALL cmd_building_set_health(g_id,p_num,board_building_id);
    END IF;
  UNTIL done END REPEAT;
  CLOSE cur;


END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `reset`
--

DROP PROCEDURE IF EXISTS `reset`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
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
  truncate table player_features_usage;
  SET FOREIGN_KEY_CHECKS=1;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `resurrect`
--

DROP PROCEDURE IF EXISTS `resurrect`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
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

            CALL cmd_add_unit(g_id,p_num,new_unit_id);
            CALL cmd_remove_from_grave(g_id,p_num,grave_id);

            INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'resurrect_unit',u_id);
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `send_money`
--

DROP PROCEDURE IF EXISTS `send_money`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `send_money`(g_id INT,p_num INT,p2_num INT,amount_input_str VARCHAR(100) CHARSET utf8)
BEGIN
  DECLARE amount INT;
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_independent_message($p_num,"Отправил игроку $log_player2 $log_gold")';

  DECLARE conversion_error INT DEFAULT 0;
  DECLARE CONTINUE HANDLER FOR SQLSTATE '22007' SET conversion_error = 1;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;/*Not your turn*/
  ELSE
  SET amount=CAST(amount_input_str AS SIGNED INTEGER);
/*Sending non-integer string, 0 or -1 money not allowed*/
  IF (conversion_error=1 OR amount<=0) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=4;/*Incorrect amount*/
  ELSE
/*Sending to himself*/
    IF (p_num=p2_num) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=36;/*Sending money to myself*/
    ELSE
/*Player has not enough money*/
      IF (SELECT gold FROM players WHERE game_id=g_id AND player_num=p_num)<amount THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=2;/*Not enough gold*/
      ELSE
/*Everything is ok*/
        CALL user_action_begin();

        UPDATE players SET gold=gold-amount WHERE game_id=g_id AND player_num=p_num;
        UPDATE players SET gold=gold+amount WHERE game_id=g_id AND player_num=p2_num;

        CALL cmd_player_set_gold(g_id,p_num);
        CALL cmd_player_set_gold(g_id,p2_num);

        SET cmd_log=REPLACE(cmd_log,'$p_num',p_num);
        SET cmd_log=REPLACE(cmd_log,'$log_player2',log_player(g_id,p2_num));
        SET cmd_log=REPLACE(cmd_log,'$log_gold',log_gold(amount));
        INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

        CALL user_action_end();
      END IF;
    END IF;
  END IF;
  END IF;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `shields_restore`
--

DROP PROCEDURE IF EXISTS `shields_restore`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `shields_restore`(board_unit_id INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;

  DECLARE cmd_log_shield_off VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit восстанавливает магические щиты")';

  SELECT bu.game_id,bu.player_num INTO g_id,p_num FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

  UPDATE board_units SET shield=(SELECT shield FROM units u WHERE u.id=u_id LIMIT 1) WHERE id=board_unit_id;
  CALL cmd_unit_set_shield(g_id,p_num,board_unit_id);

  SET cmd_log_shield_off=REPLACE(cmd_log_shield_off,'$log_unit',log_unit(board_unit_id));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log_shield_off);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `shield_off`
--

DROP PROCEDURE IF EXISTS `shield_off`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `shield_off`(board_unit_id INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;

  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit теряет один щит")';

  SELECT bu.game_id,bu.player_num INTO g_id,p_num FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

  UPDATE board_units SET shield=shield-1 WHERE id=board_unit_id;
  CALL cmd_unit_set_shield(g_id,p_num,board_unit_id);

  SET cmd_log=REPLACE(cmd_log,'$log_unit',log_unit(board_unit_id));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `shield_on`
--

DROP PROCEDURE IF EXISTS `shield_on`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `shield_on`(board_unit_id INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;

  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit получает магический щит")';

  SELECT bu.game_id,bu.player_num INTO g_id,p_num FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

  UPDATE board_units SET shield=shield+1 WHERE id=board_unit_id;
  CALL cmd_unit_set_shield(g_id,p_num,board_unit_id);

/*If it's healing tower add independent message*/
  IF((SELECT current_procedure FROM active_players WHERE game_id=g_id LIMIT 1)='end_turn')THEN
    SET cmd_log=REPLACE(cmd_log,'log_add_message(',CONCAT('log_add_independent_message(',p_num,','));
  END IF;

  SET cmd_log=REPLACE(cmd_log,'$log_unit',log_unit(board_unit_id));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `sink_unit`
--

DROP PROCEDURE IF EXISTS `sink_unit`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sink_unit`(bu_id INT,p_num INT)
BEGIN
  DECLARE g_id INT;
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit тонет в воде")';

  SELECT game_id INTO g_id FROM board_units WHERE id=bu_id LIMIT 1;

/*log*/
  SET cmd_log=REPLACE(cmd_log,'$log_unit',log_unit(bu_id));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

  CALL unit_feature_set(bu_id,'goes_to_deck_on_death',null);
  CALL kill_unit(bu_id,p_num);
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `start_moving_units`
--

DROP PROCEDURE IF EXISTS `start_moving_units`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `start_moving_units`(g_id INT,p_num INT)
BEGIN
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_container($p_num,"Походил юнитами")';

  UPDATE active_players SET units_moves_flag=1 WHERE game_id=g_id AND player_num=p_num;

  IF((SELECT owner FROM players p WHERE p.game_id=g_id AND p.player_num=p_num LIMIT 1)=1)THEN
/*add log container only for human players*/
    SET cmd_log=REPLACE(cmd_log,'$p_num',p_num);
    INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `statistic_calculation`
--

DROP PROCEDURE IF EXISTS `statistic_calculation`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `statistic_calculation`(g_id INT)
BEGIN
  DECLARE stat_value_id INT;
  DECLARE p_num INT;
  DECLARE count_rule VARCHAR(1000) CHARSET utf8;
  DECLARE sql_update_stmt VARCHAR(1000) CHARSET utf8 DEFAULT 'UPDATE statistic_values SET `value`=($rule) WHERE id=$id;';

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT s.id,s.player_num,d.count_rule FROM statistic_values s JOIN dic_statistic_measures d ON (s.measure_id=d.id) WHERE s.game_id=g_id;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

/*local statistic*/

    OPEN cur;
    REPEAT
      FETCH cur INTO stat_value_id,p_num,count_rule;
      IF NOT done THEN
        SET count_rule=REPLACE(count_rule,'$g_id',g_id);
        SET count_rule=REPLACE(count_rule,'$p_num',p_num);
        SET @sql_query=REPLACE(sql_update_stmt,'$rule',count_rule);
        SET @sql_query=REPLACE(@sql_query,'$id',stat_value_id);
        PREPARE stmt FROM @sql_query;
        EXECUTE stmt;
        DROP PREPARE stmt;
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `summon_creature`
--

DROP PROCEDURE IF EXISTS `summon_creature`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `summon_creature`(g_id INT, cr_player_name VARCHAR(45) CHARSET utf8, cr_owner INT ,cr_unit_id INT ,x INT ,y INT, parent_building_id INT)
BEGIN
  DECLARE new_player,team INT;
  DECLARE new_unit_id INT;
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Появляется $log_unit")';

    SELECT CASE WHEN MAX(p.player_num)<10 THEN 10 ELSE MAX(p.player_num)+1 END INTO new_player FROM players p WHERE p.game_id=g_id;
    SET team=building_feature_get_param(parent_building_id,'summon_team');

/*Add Player*/
    INSERT INTO players(game_id,player_num,name,gold,owner,team) VALUES(g_id,new_player,cr_player_name,0,cr_owner,team);
/*Add board_unit*/
    INSERT INTO board_units(game_id,player_num,unit_id) VALUES(g_id,new_player,cr_unit_id);
    SET new_unit_id=@@last_insert_id;
    INSERT INTO board_units_features(board_unit_id,feature_id,param) SELECT new_unit_id,ufu.feature_id,ufu.param FROM unit_default_features ufu WHERE ufu.unit_id=cr_unit_id;
    INSERT INTO board_units_features(board_unit_id,feature_id,param) VALUES(new_unit_id,unit_feature_get_id_by_code('parent_building'),parent_building_id);
/*Add board*/
    INSERT INTO board(game_id,x,y,`type`,ref) VALUES (g_id,x,y,'unit',new_unit_id);

    CALL cmd_add_player(g_id,new_player);
    CALL cmd_add_unit_by_id(g_id,new_player,new_unit_id);

    SET cmd_log=REPLACE(cmd_log,'$log_unit',log_unit(new_unit_id));

    IF((SELECT current_procedure FROM active_players WHERE game_id=g_id LIMIT 1)='end_turn')THEN
      SET cmd_log=REPLACE(cmd_log,'log_add_message(',CONCAT('log_add_independent_message(',new_player,','));
    END IF;

    INSERT INTO command (game_id,player_num,command) VALUES (g_id,new_player,cmd_log);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `summon_creatures`
--

DROP PROCEDURE IF EXISTS `summon_creatures`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `summon_creatures`(board_building_id INT)
BEGIN
  DECLARE g_id INT;
  DECLARE g_mode INT;
  DECLARE bld_id INT;
  DECLARE cr_count INT;
  DECLARE x,y INT;
  DECLARE cr_player_name VARCHAR(45) CHARSET utf8;
  DECLARE cr_owner INT;
  DECLARE cr_unit_id INT;

  SELECT game_id,building_id INTO g_id,bld_id FROM board_buildings WHERE id=board_building_id LIMIT 1;

  SELECT mode_id INTO g_mode FROM games WHERE id=g_id LIMIT 1;

  SELECT sc.player_name,sc.unit_id,sc.`count`,sc.owner INTO cr_player_name,cr_unit_id,cr_count,cr_owner FROM summon_cfg sc WHERE building_id=bld_id AND mode_id=g_mode LIMIT 1;

  WHILE (cr_count>0 AND EXISTS(SELECT DISTINCT a.x,a.y FROM allcoords a, board b WHERE b.game_id=g_id AND b.`type`<>'unit' AND b.ref=board_building_id AND a.mode_id=g_mode AND (ABS(b.x-a.x)<=1 AND ABS(b.y-a.y)<=1) AND NOT EXISTS(SELECT b2.id FROM board b2 WHERE b2.x=a.x AND b2.y=a.y) LIMIT 1)) DO
    SELECT DISTINCT a.x,a.y INTO x,y FROM allcoords a, board b WHERE b.game_id=g_id AND b.`type`<>'unit' AND b.ref=board_building_id AND a.mode_id=g_mode AND (ABS(b.x-a.x)<=1 AND ABS(b.y-a.y)<=1) AND NOT EXISTS(SELECT b2.id FROM board b2 WHERE b2.x=a.x AND b2.y=a.y) ORDER BY RAND() LIMIT 1;
    SET cr_count=cr_count-1;
    CALL summon_creature(g_id,cr_player_name,cr_owner,cr_unit_id,x,y,board_building_id);
  END WHILE;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `summon_one_creature_by_config`
--

DROP PROCEDURE IF EXISTS `summon_one_creature_by_config`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `summon_one_creature_by_config`(board_building_id INT)
BEGIN
  DECLARE g_id INT;
  DECLARE g_mode INT;
  DECLARE bld_id INT;
  DECLARE x,y INT;
  DECLARE cr_player_name VARCHAR(45) CHARSET utf8;
  DECLARE cr_owner INT;
  DECLARE cr_unit_id INT;

  SELECT game_id,building_id INTO g_id,bld_id FROM board_buildings WHERE id=board_building_id LIMIT 1;

  SELECT mode_id INTO g_mode FROM games WHERE id=g_id LIMIT 1;

  SELECT sc.player_name,sc.unit_id,sc.owner INTO cr_player_name,cr_unit_id,cr_owner FROM summon_cfg sc WHERE building_id=bld_id AND mode_id=g_mode LIMIT 1;

  IF EXISTS(SELECT DISTINCT a.x,a.y FROM allcoords a, board b WHERE b.game_id=g_id AND b.`type`<>'unit' AND b.ref=board_building_id AND a.mode_id=g_mode AND (ABS(b.x-a.x)<=1 AND ABS(b.y-a.y)<=1) AND NOT EXISTS(SELECT b2.id FROM board b2 WHERE b2.x=a.x AND b2.y=a.y) LIMIT 1) THEN
    SELECT DISTINCT a.x,a.y INTO x,y FROM allcoords a, board b WHERE b.game_id=g_id AND b.`type`<>'unit' AND b.ref=board_building_id AND a.mode_id=g_mode AND (ABS(b.x-a.x)<=1 AND ABS(b.y-a.y)<=1) AND NOT EXISTS(SELECT b2.id FROM board b2 WHERE b2.x=a.x AND b2.y=a.y) ORDER BY RAND() LIMIT 1;
    CALL summon_creature(g_id,cr_player_name,cr_owner,cr_unit_id,x,y,board_building_id);
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `summon_unit`
--

DROP PROCEDURE IF EXISTS `summon_unit`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
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
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=9;/*Appear point occupied*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

      INSERT INTO board_units(game_id,player_num,card_id) VALUES (g_id,p_num,crd_id);
      SET new_unit_id=@@last_insert_id;
      INSERT INTO board_units_features(board_unit_id,feature_id,param) SELECT new_unit_id,ufu.feature_id,ufu.param FROM unit_default_features ufu WHERE ufu.unit_id=u_id;

      INSERT INTO board(game_id,x,y,`type`,ref) SELECT g_id,a.x,a.y,'unit',new_unit_id FROM allcoords a WHERE a.mode_id=mode_id AND a.x BETWEEN LEAST(x_appear,x_appear+x_dir*(size-1)) AND GREATEST(x_appear,x_appear+x_dir*(size-1)) AND a.y BETWEEN LEAST(y_appear,y_appear+y_dir*(size-1)) AND GREATEST(y_appear,y_appear+y_dir*(size-1));

      CALL cmd_add_unit(g_id,p_num,new_unit_id);

      CALL finish_playing_card(g_id,p_num);
      CALL end_turn(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `take_subsidy`
--

DROP PROCEDURE IF EXISTS `take_subsidy`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `take_subsidy`(g_id INT,p_num INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE subsidy_amt INT;
  DECLARE subsidy_damage INT;
  DECLARE board_castle_id INT;
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_independent_message($p_num,"Взял субсидию")';

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
  SELECT cfg.`value` INTO subsidy_amt FROM mode_config cfg WHERE cfg.param='subsidy amount' AND cfg.mode_id=mode_id;
  SELECT cfg.`value` INTO subsidy_damage FROM mode_config cfg WHERE cfg.param='subsidy castle damage' AND cfg.mode_id=mode_id;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;/*Not your turn*/
  ELSE
    IF (SELECT subsidy_flag FROM active_players WHERE game_id=g_id)=1 THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=5;/*Subsidy already taken*/
    ELSE
      IF (SELECT bb.health FROM board_buildings bb JOIN buildings b ON bb.building_id=b.id WHERE bb.game_id=g_id AND bb.player_num=p_num AND b.`type`='castle' LIMIT 1)<=subsidy_damage THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=6;/*Castle has not enough health*/
      ELSE
        CALL user_action_begin();

        SELECT bb.id INTO board_castle_id FROM board_buildings bb JOIN board b ON bb.id=b.ref WHERE b.`type`='castle' AND b.game_id=g_id AND bb.player_num=p_num LIMIT 1;
        UPDATE players SET gold=gold+subsidy_amt WHERE game_id=g_id AND player_num=p_num;
        UPDATE board_buildings SET health=health-subsidy_damage WHERE id=board_castle_id;
        UPDATE active_players SET subsidy_flag=1 WHERE game_id=g_id;

        CALL cmd_player_set_gold(g_id,p_num);
        CALL cmd_building_set_health(g_id,p_num,board_castle_id);

        SET cmd_log=REPLACE(cmd_log,'$p_num',p_num);
        INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

        CALL user_action_end();
      END IF;
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `taran_bind`
--

DROP PROCEDURE IF EXISTS `taran_bind`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `taran_bind`(g_id INT,p_num INT,x INT,y INT, x2 INT, y2 INT)
BEGIN
  DECLARE err_code INT;
  DECLARE aim_bu_id INT;
  DECLARE board_unit_id INT;

  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit1 цепляется к юниту $log_unit2")';

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'taran_bind'); /*unit can do it*/
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF check_one_step_from_unit(g_id,x,y,x2,y2)=0 THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=29;/* out of range*/
    ELSE
      SELECT b.ref INTO aim_bu_id FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.x=x2 AND b.y=y2 LIMIT 1;
      IF aim_bu_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=31;/*Nothing to bind to*/
      ELSE
        CALL user_action_begin();

        IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
          CALL start_moving_units(g_id,p_num);
        END IF;

        SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;

        UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
        CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

        CALL unit_feature_set(board_unit_id,'bind_target',aim_bu_id);

/*log*/
        SET cmd_log=REPLACE(cmd_log,'$log_unit1',log_unit(board_unit_id));
        SET cmd_log=REPLACE(cmd_log,'$log_unit2',log_unit(aim_bu_id));
        INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

        IF NOT EXISTS(SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id AND bu.player_num=p_num AND moves_left>0 AND unit_feature_check(bu.id,'paralich')=0 LIMIT 1) THEN
          CALL finish_moving_units(g_id,p_num);
          CALL end_turn(g_id,p_num);
        END IF;

        CALL user_action_end();

      END IF;
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `total_heal`
--

DROP PROCEDURE IF EXISTS `total_heal`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `total_heal`(board_unit_id INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE hp_minus INT;
  DECLARE shield_minus INT;
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit исцелен")';

  SELECT bu.game_id,bu.player_num,bu.max_health-bu.health,u.shield-bu.shield INTO g_id,p_num,hp_minus,shield_minus
  FROM board_units bu JOIN units u ON (bu.unit_id=u.id) WHERE bu.id=board_unit_id LIMIT 1;

/*write to log only if nothing to heal*/
  IF((unit_feature_check(board_unit_id,'paralich')=0)AND(unit_feature_check(board_unit_id,'madness')=0)AND(hp_minus<=0)AND(shield_minus<=0))THEN
      SET cmd_log=REPLACE(cmd_log,'$log_unit',log_unit(board_unit_id));
      INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);
  END IF;

  IF (unit_feature_check(board_unit_id,'paralich')=1) THEN
/*unparalich*/
    CALL unit_feature_remove(board_unit_id,'paralich');
    CALL cmd_unit_remove_effect(g_id,board_unit_id,'paralich');
  END IF;

  IF (unit_feature_check(board_unit_id,'madness')=1) THEN
/*make not mad*/
    CALL make_not_mad(board_unit_id);
  END IF;

  IF hp_minus>0 THEN
/*heal*/
    CALL heal_unit_health(board_unit_id,hp_minus);
  END IF;

  IF shield_minus>0 THEN
/*restore shield*/
    CALL shields_restore(board_unit_id);
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `units_from_zone`
--

DROP PROCEDURE IF EXISTS `units_from_zone`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `units_from_zone`(g_id INT,zone INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE u_x,u_y,new_x,new_y INT;
  DECLARE board_unit_id INT;
  DECLARE size INT;

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR
    SELECT b.ref,MIN(b.x),MIN(b.y),u.size
    FROM board b
    JOIN board_units bu ON (b.ref=bu.id)
    JOIN units u ON (bu.unit_id=u.id)
    WHERE b.`type`='unit' AND b.game_id=g_id
    GROUP BY b.ref,u.size
    HAVING quart(MIN(b.x),MIN(b.y))=zone;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;

    OPEN cur;
    REPEAT
      FETCH cur INTO board_unit_id,u_x,u_y,size;
      IF NOT done THEN
        IF size=1 THEN /*ordinary units*/
          /*define new coords*/
          SELECT a.x,a.y INTO new_x,new_y FROM allcoords a
          LEFT JOIN board b ON (a.x=b.x AND a.y=b.y AND b.game_id=g_id)
          WHERE a.mode_id=mode_id AND quart(a.x,a.y)<>zone AND b.id IS NULL
          ORDER BY ((u_x-a.x)*(u_x-a.x)+(u_y-a.y)*(u_y-a.y)) LIMIT 1;

          CALL move_unit(board_unit_id,new_x,new_y);
        ELSE /*dragons*/
          /*define new coords*/
          SELECT a.x,a.y INTO new_x,new_y FROM allcoords a
          WHERE a.mode_id=mode_id AND quart(a.x,a.y)<>zone
          AND NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x BETWEEN a.x AND a.x+size-1 AND b.y BETWEEN a.y AND a.y+size-1 LIMIT 1)
          ORDER BY ((u_x-a.x)*(u_x-a.x)+(u_y-a.y)*(u_y-a.y)) LIMIT 1;

          CALL move_unit(board_unit_id,new_x,new_y);
        END IF;
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `units_to_zone`
--

DROP PROCEDURE IF EXISTS `units_to_zone`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `units_to_zone`(g_id INT,zone INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE u_x,u_y,new_x,new_y INT;
  DECLARE board_unit_id INT;
  DECLARE size INT;

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR
    SELECT b.ref,MIN(b.x),MIN(b.y),u.size
    FROM board b
    JOIN board_units bu ON (b.ref=bu.id)
    JOIN units u ON (bu.unit_id=u.id)
    WHERE b.`type`='unit' AND b.game_id=g_id AND unit_feature_check(bu.id,'magic_immunity')=0 /*not golem*/
    GROUP BY b.ref,u.size
    HAVING quart(MIN(b.x),MIN(b.y))<>zone;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;

    OPEN cur;
    REPEAT
      FETCH cur INTO board_unit_id,u_x,u_y,size;
      IF NOT done THEN
        IF size=1 THEN /*ordinary units*/
          /*define new coords*/
          SELECT a.x,a.y INTO new_x,new_y FROM allcoords a
          LEFT JOIN board b ON (a.x=b.x AND a.y=b.y AND b.game_id=g_id)
          WHERE a.mode_id=mode_id AND quart(a.x,a.y)=zone AND b.id IS NULL
          ORDER BY ((u_x-a.x)*(u_x-a.x)+(u_y-a.y)*(u_y-a.y)) LIMIT 1;

          CALL move_unit(board_unit_id,new_x,new_y);
        ELSE /*dragons*/
          /*define new coords*/
          SELECT a.x,a.y INTO new_x,new_y FROM allcoords a
          WHERE a.mode_id=mode_id AND quart(a.x,a.y)=zone
          AND NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x BETWEEN a.x AND a.x+size-1 AND b.y BETWEEN a.y AND a.y+size-1 LIMIT 1)
          ORDER BY ((u_x-a.x)*(u_x-a.x)+(u_y-a.y)*(u_y-a.y)) LIMIT 1;

          CALL move_unit(board_unit_id,new_x,new_y);
        END IF;
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `unit_add_attack`
--

DROP PROCEDURE IF EXISTS `unit_add_attack`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `unit_add_attack`(board_unit_id INT, qty INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;

  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit получает $log_attack")';

  SELECT bu.game_id,bu.player_num INTO g_id,p_num FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

  UPDATE board_units SET attack=attack+qty WHERE id=board_unit_id;
  CALL cmd_unit_set_attack(g_id,p_num,board_unit_id);

  SET cmd_log=REPLACE(cmd_log,'$log_unit',log_unit(board_unit_id));
  SET cmd_log=REPLACE(cmd_log,'$log_attack',log_attack(qty));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `unit_add_health`
--

DROP PROCEDURE IF EXISTS `unit_add_health`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `unit_add_health`(board_unit_id INT, qty INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;

  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit получает $log_health")';

  SELECT bu.game_id,bu.player_num INTO g_id,p_num FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

  UPDATE board_units SET max_health=max_health+qty, health=health+qty WHERE id=board_unit_id;
  CALL cmd_unit_set_max_health(g_id,p_num,board_unit_id);
  CALL cmd_unit_set_health(g_id,p_num,board_unit_id);

  SET cmd_log=REPLACE(cmd_log,'$log_unit',log_unit(board_unit_id));
  SET cmd_log=REPLACE(cmd_log,'$log_health',log_health(qty));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `unit_add_moves`
--

DROP PROCEDURE IF EXISTS `unit_add_moves`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `unit_add_moves`(board_unit_id INT, qty INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;

  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit получает $log_moves")';

  SELECT bu.game_id,bu.player_num INTO g_id,p_num FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

  UPDATE board_units SET moves=moves+qty, moves_left=moves_left+qty WHERE id=board_unit_id;
  CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);
  CALL cmd_unit_set_moves(g_id,p_num,board_unit_id);

  SET cmd_log=REPLACE(cmd_log,'$log_unit',log_unit(board_unit_id));
  SET cmd_log=REPLACE(cmd_log,'$log_moves',log_moves(qty));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `unit_feature_remove`
--

DROP PROCEDURE IF EXISTS `unit_feature_remove`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `unit_feature_remove`(board_u_id INT, feature_code VARCHAR(45))
BEGIN
  DELETE FROM board_units_features
    WHERE board_unit_id=board_u_id AND feature_id=unit_feature_get_id_by_code(feature_code);
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `unit_feature_set`
--

DROP PROCEDURE IF EXISTS `unit_feature_set`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `unit_feature_set`(board_unit_id INT, feature_code VARCHAR(45),param_value INT)
BEGIN
  IF(unit_feature_check(board_unit_id,feature_code)=0)THEN /*feature not set*/
    INSERT INTO board_units_features(board_unit_id,feature_id,param) SELECT board_unit_id,uf.id,param_value FROM unit_features uf WHERE uf.code=feature_code;
  ELSE /*feature is set - update param*/
    UPDATE board_units_features buf
      SET buf.param=param_value
      WHERE buf.board_unit_id=board_unit_id AND buf.feature_id=unit_feature_get_id_by_code(feature_code);
  END IF;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `unit_push`
--

DROP PROCEDURE IF EXISTS `unit_push`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `unit_push`(board_unit_id_1 INT, board_unit_id_2 INT)
BEGIN
/*unit 1 pushes unit 2*/
  DECLARE g_id INT;
  DECLARE mode_id INT;
  DECLARE p_num INT; /*unit 1 owner*/
  DECLARE cur_unit1_id,cur_unit2_id INT;
  DECLARE cur_push_id INT;
  DECLARE x_min_1, x_max_1, y_min_1, y_max_1, x_min_2, x_max_2, y_min_2, y_max_2 INT; /*coordinares of units*/
  DECLARE push_x,push_y INT DEFAULT 0;
  DECLARE unit_to_move_id INT;
  DECLARE move_x,move_y INT;
  DECLARE cur_sink_flag INT;

  DECLARE success INT;

  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit1 пихает $log_unit2_rod_pad")';

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

    /*determine direction*/
    SET push_x=0;
    SET push_y=0;
    IF(x_max_2<x_min_1)THEN /* 2 is on the left from 1*/
      SET push_x=-1;
    END IF;
    IF(x_min_2>x_max_1)THEN /* 2 is on the right from 1*/
      SET push_x=1;
    END IF;
    IF(y_max_2<y_min_1)THEN /* 2 upper than 1*/
      SET push_y=-1;
    END IF;
    IF(y_min_2>y_max_1)THEN /* 2 lower than 1*/
      SET push_y=1;
    END IF;

    IF /*unit is moved out of the board*/
    (SELECT COUNT(*) FROM allcoords a
        WHERE a.mode_id=mode_id
          AND a.x BETWEEN x_min_2+push_x AND x_max_2+push_x
          AND a.y BETWEEN y_min_2+push_y AND y_max_2+push_y)<>((x_max_2-x_min_2+1) * (y_max_2-y_min_2+1))
    THEN
      SET success=0;
    ELSE
      IF /*obstacles on the way*/
      EXISTS
      (
        SELECT 1 FROM board b
          WHERE b.game_id=g_id AND b.`type`<>'unit'
            AND b.x BETWEEN x_min_2+push_x AND x_max_2+push_x
            AND b.y BETWEEN y_min_2+push_y AND y_max_2+push_y
      )
      THEN
        IF /*obstacle is lake - sink unit*/
          NOT EXISTS
          (SELECT 1 FROM board b
            WHERE b.game_id=g_id AND b.`type`<>'unit'
              AND b.x BETWEEN x_min_2+push_x AND x_max_2+push_x
              AND b.y BETWEEN y_min_2+push_y AND y_max_2+push_y
              AND building_feature_check(b.ref,'water')=0 /*if only obstacle is water*/
          )
        THEN
          /*move and sink unit*/
          INSERT INTO move_queue(unit_id,x,y,sink_flag) VALUES(cur_unit2_id,x_min_2+push_x,y_min_2+push_y,1);
        ELSE
          SET success=0;
        END IF;
      ELSE

        INSERT INTO move_queue(unit_id,x,y) VALUES(cur_unit2_id,x_min_2+push_x,y_min_2+push_y);

        /*push next units if any*/
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

    SET cmd_log=REPLACE(cmd_log,'$log_unit1',log_unit(board_unit_id_1));
    SET cmd_log=REPLACE(cmd_log,'$log_unit2_rod_pad',log_unit_rod_pad(board_unit_id_2));
    INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

    /*move units*/
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

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `user_action_begin`
--

DROP PROCEDURE IF EXISTS `user_action_begin`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
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

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `user_action_end`
--

DROP PROCEDURE IF EXISTS `user_action_end`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
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
    command.command LIKE 'log_add_attack_message%';

  SELECT p.user_id, command, CASE WHEN hidden_flag=0 THEN 0 ELSE 1 END AS `hidden_flag`
  FROM command c LEFT JOIN players p ON (c.game_id=p.game_id AND c.player_num=p.player_num);

  DROP TEMPORARY TABLE `lords`.`command`;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `vampire_resurrect_by_card`
--

DROP PROCEDURE IF EXISTS `vampire_resurrect_by_card`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `vampire_resurrect_by_card`(vamp_board_id INT, grave_id INT)
BEGIN
  DECLARE dead_card_id INT;
  DECLARE dice_max INT DEFAULT 2;
  DECLARE chance INT DEFAULT 1;
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE team INT;
  DECLARE vamp_owner INT DEFAULT 4;
  DECLARE new_player INT;
  DECLARE new_unit_id INT;
  DECLARE u_id INT;
  DECLARE vamp_name VARCHAR(45) CHARSET utf8 DEFAULT 'Вампир $u_name';
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit становится вампиром")';


  IF ((SELECT FLOOR(1 + (RAND() * dice_max)) FROM DUAL)>chance) THEN /*vampirism successfull*/
    SELECT bu.game_id,bu.player_num,p.team INTO g_id,p_num,team FROM board_units bu JOIN players p ON (bu.game_id=p.game_id AND bu.player_num=p.player_num) WHERE bu.id=vamp_board_id LIMIT 1;

    SELECT CASE WHEN MAX(p.player_num)<10 THEN 10 ELSE MAX(p.player_num)+1 END INTO new_player FROM players p WHERE p.game_id=g_id;

    SELECT g.card_id INTO dead_card_id FROM graves g WHERE id=grave_id;
    SELECT c.ref INTO u_id FROM cards c WHERE c.id=dead_card_id LIMIT 1;

    SET vamp_name=REPLACE(vamp_name,'$u_name',(SELECT name FROM units WHERE id=u_id LIMIT 1));

    INSERT INTO players(game_id,player_num,name,gold,owner,team) VALUES(g_id,new_player,vamp_name,0,vamp_owner,team);

    INSERT INTO board_units(game_id,player_num,card_id) VALUES (g_id,new_player,dead_card_id);
    SET new_unit_id=@@last_insert_id;
    INSERT INTO board_units_features(board_unit_id,feature_id,param) SELECT new_unit_id,ufu.feature_id,ufu.param FROM unit_default_features ufu WHERE ufu.unit_id=u_id;

    INSERT INTO board(game_id,x,y,`type`,ref) SELECT g_id,gc.x,gc.y,'unit',new_unit_id FROM grave_cells gc WHERE gc.grave_id=grave_id;
    DELETE FROM graves WHERE game_id=g_id AND id=grave_id;

/*vamp*/
    CALL unit_feature_set(new_unit_id,'vamp',NULL);

    CALL cmd_add_player(g_id,new_player);
    CALL cmd_add_unit(g_id,new_player,new_unit_id);
    CALL cmd_remove_from_grave(g_id,p_num,grave_id);

/*log*/
    SET cmd_log=REPLACE(cmd_log,'$log_unit',log_unit(new_unit_id));
    INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `vampire_resurrect_by_u_id`
--

DROP PROCEDURE IF EXISTS `vampire_resurrect_by_u_id`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `vampire_resurrect_by_u_id`(vamp_board_id INT,u_id INT,x INT,y INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE dice_max INT DEFAULT 2;
  DECLARE chance INT DEFAULT 1;
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE team INT;
  DECLARE vamp_owner INT DEFAULT 4;
  DECLARE new_player INT;
  DECLARE new_unit_id INT;
  DECLARE size INT;
  DECLARE vamp_name VARCHAR(45) CHARSET utf8 DEFAULT 'Вампир $u_name';
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit становится вампиром")';


  IF ((SELECT FLOOR(1 + (RAND() * dice_max)) FROM DUAL)>chance) THEN /*vampirism successfull*/
    SELECT bu.game_id,bu.player_num,p.team INTO g_id,p_num,team FROM board_units bu JOIN players p ON (bu.game_id=p.game_id AND bu.player_num=p.player_num) WHERE bu.id=vamp_board_id LIMIT 1;
    SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;

    SELECT CASE WHEN MAX(p.player_num)<10 THEN 10 ELSE MAX(p.player_num)+1 END INTO new_player FROM players p WHERE p.game_id=g_id;

    SET vamp_name=REPLACE(vamp_name,'$u_name',(SELECT name FROM units WHERE id=u_id LIMIT 1));

    INSERT INTO players(game_id,player_num,name,gold,owner,team) VALUES(g_id,new_player,vamp_name,0,vamp_owner,team);

    INSERT INTO board_units(game_id,player_num,unit_id) VALUES(g_id,new_player,u_id);
    SET new_unit_id=@@last_insert_id;
    INSERT INTO board_units_features(board_unit_id,feature_id,param) SELECT new_unit_id,ufu.feature_id,ufu.param FROM unit_default_features ufu WHERE ufu.unit_id=u_id;

    SELECT u.size INTO size FROM units u WHERE u.id=u_id LIMIT 1;

    INSERT INTO board(game_id,x,y,`type`,ref) SELECT g_id,a.x,a.y,'unit',new_unit_id FROM allcoords a WHERE a.mode_id=mode_id AND a.x BETWEEN x AND x+size-1 AND a.y BETWEEN y AND y+size-1;

/*vamp*/
    CALL unit_feature_set(new_unit_id,'vamp',NULL);

    CALL cmd_add_player(g_id,new_player);
    CALL cmd_add_unit_by_id(g_id,new_player,new_unit_id);

/*log*/
    SET cmd_log=REPLACE(cmd_log,'$log_unit',log_unit(new_unit_id));
    INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `vred_player_takes_card_from_everyone`
--

DROP PROCEDURE IF EXISTS `vred_player_takes_card_from_everyone`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `vred_player_takes_card_from_everyone`(g_id INT,p_num INT)
BEGIN
  DECLARE p2_num INT; /*card owner*/
  DECLARE random_card INT;
  DECLARE player_deck_id INT;
  DECLARE cmd_log_winer VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Новая карта <b class=\'logCard\'>$card_name</b>")';
  DECLARE cmd_log_loser VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_player вытянул карту <b class=\'logCard\'>$card_name</b>")';

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT DISTINCT p.player_num FROM player_deck p WHERE p.game_id=g_id AND p.player_num<>p_num;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    SET cmd_log_loser=REPLACE(cmd_log_loser,'$log_player',log_player(g_id,p_num));

    OPEN cur;
    REPEAT
      FETCH cur INTO p2_num;
      IF NOT done THEN
        SELECT id,card_id INTO player_deck_id,random_card FROM player_deck p WHERE p.game_id=g_id AND p.player_num=p2_num ORDER BY RAND() LIMIT 1;
        UPDATE player_deck SET player_num=p_num WHERE id=player_deck_id;

        CALL cmd_add_card(g_id,p_num,player_deck_id);
        CALL cmd_remove_card(g_id,p2_num,player_deck_id);

        INSERT INTO command (game_id,player_num,command,hidden_flag) VALUES (g_id,p2_num,REPLACE(cmd_log_loser,'$card_name',(SELECT name FROM cards WHERE id=random_card LIMIT 1)),1);
        INSERT INTO command (game_id,player_num,command,hidden_flag) VALUES (g_id,p_num,REPLACE(cmd_log_winer,'$card_name',(SELECT name FROM cards WHERE id=random_card LIMIT 1)),1);
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `vred_pooring`
--

DROP PROCEDURE IF EXISTS `vred_pooring`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `vred_pooring`(g_id INT,p_num INT)
BEGIN
  DECLARE pooring_sum INT DEFAULT 60;
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_player теряет $log_gold")';


  UPDATE players SET gold=CASE WHEN gold<pooring_sum THEN 0 ELSE gold-pooring_sum END WHERE game_id=g_id AND player_num=p_num;
  CALL cmd_player_set_gold(g_id,p_num);

  SET cmd_log=REPLACE(cmd_log,'$log_player',log_player(g_id,p_num));
  SET cmd_log=REPLACE(cmd_log,'$log_gold',log_gold(pooring_sum));

  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `wizard_fireball`
--

DROP PROCEDURE IF EXISTS `wizard_fireball`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `wizard_fireball`(g_id INT,p_num INT,x INT,y INT, x2 INT, y2 INT)
BEGIN
  DECLARE err_code INT;
  DECLARE aim_bu_id INT;
  DECLARE board_unit_id INT;
  DECLARE dice INT;
  DECLARE fb_damage INT DEFAULT 1;

  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit1 колдует огненный шар на $log_unit2_rod_pad")';
  DECLARE cmd_log_fail VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Колдовство не удалось")';

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'wizard_fireball'); /*unit can do it*/
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
      SELECT b.ref INTO aim_bu_id FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.x=x2 AND b.y=y2 LIMIT 1;
      IF aim_bu_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=33;/*Noone to shoot*/
      ELSE
        CALL user_action_begin();

        IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
          CALL start_moving_units(g_id,p_num);
        END IF;

        SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;

        UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
        CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

/*log*/
        SET cmd_log=REPLACE(cmd_log,'$log_unit1',log_unit(board_unit_id));
        SET cmd_log=REPLACE(cmd_log,'$log_unit2_rod_pad',log_unit_rod_pad(aim_bu_id));
        INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

        SELECT FLOOR(1 + (RAND() * 6)) INTO dice FROM DUAL;

        IF dice=1 THEN /*russian rul*/
          IF (SELECT FLOOR(1 + (RAND() * 6)) as `dice` FROM DUAL)<6 THEN
            CALL cmd_miss_russian_rul(board_unit_id);
          ELSE
            CALL kill_unit(board_unit_id,p_num);
          END IF;
        ELSE
          IF dice IN (5,6) THEN /*fireball*/
            IF (SELECT FLOOR(1 + (RAND() * 6)) as `dice` FROM DUAL)<3 THEN
              CALL cmd_miss_game_log(g_id,x2,y2);
            ELSE
              CALL magical_damage(g_id,p_num,x2,y2,fb_damage);
            END IF;
          ELSE /*fail*/
            INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log_fail);
          END IF;
        END IF;

        INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'magical_attack');

        IF NOT EXISTS(SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id AND bu.player_num=p_num AND moves_left>0 AND unit_feature_check(bu.id,'paralich')=0 LIMIT 1) THEN
          CALL finish_moving_units(g_id,p_num);
          CALL end_turn(g_id,p_num);
        END IF;

        CALL user_action_end();
      END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `wizard_heal`
--

DROP PROCEDURE IF EXISTS `wizard_heal`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `wizard_heal`(g_id INT,p_num INT,x INT,y INT, x2 INT, y2 INT)
BEGIN
  DECLARE err_code INT;
  DECLARE aim_bu_id INT;
  DECLARE board_unit_id INT;
  DECLARE hp_heal INT DEFAULT 1;

  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit1 лечит $log_unit2_rod_pad")';

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'wizard_heal'); /*unit can do it*/
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF check_one_step_from_unit(g_id,x,y,x2,y2)=0 THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=29;/* out of range*/
    ELSE
      SELECT b.ref INTO aim_bu_id FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.x=x2 AND b.y=y2 LIMIT 1;
      IF aim_bu_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=32;/*Noone to heal*/
      ELSE
        CALL user_action_begin();

        IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
          CALL start_moving_units(g_id,p_num);
        END IF;

        SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;

        UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
        CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

/*log*/
        SET cmd_log=REPLACE(cmd_log,'$log_unit1',log_unit(board_unit_id));
        SET cmd_log=REPLACE(cmd_log,'$log_unit2_rod_pad',log_unit_rod_pad(aim_bu_id));
        INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

        CALL magical_heal(g_id,p_num,x2,y2,hp_heal);

        IF NOT EXISTS(SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id AND bu.player_num=p_num AND moves_left>0 AND unit_feature_check(bu.id,'paralich')=0 LIMIT 1) THEN
          CALL finish_moving_units(g_id,p_num);
          CALL end_turn(g_id,p_num);
        END IF;

        CALL user_action_end();
      END IF;
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `zombies_change_player_to_nec`
--

DROP PROCEDURE IF EXISTS `zombies_change_player_to_nec`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
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

          UPDATE board_units SET player_num=nec_p_num WHERE id=zombie_board_id;
          CALL cmd_unit_set_owner(g_id,nec_p_num,zombie_board_id);

/*if it was npc*/
          IF ((SELECT owner FROM players WHERE game_id=g_id AND player_num=zombie_p_num LIMIT 1)<>1)
            AND NOT EXISTS (SELECT id FROM board_units WHERE game_id=g_id AND player_num=zombie_p_num)
            AND NOT EXISTS (SELECT id FROM board_buildings WHERE game_id=g_id AND player_num=zombie_p_num)
          THEN
            SELECT gold INTO npc_gold FROM players WHERE game_id=g_id AND player_num=zombie_p_num LIMIT 1; /*take npc gold*/
            IF(npc_gold>0)THEN
              UPDATE players SET gold=gold+riching_sum WHERE game_id=g_id AND player_num=nec_p_num;
              CALL cmd_player_set_gold(g_id,nec_p_num);
            END IF;

            DELETE FROM players WHERE game_id=g_id AND player_num=zombie_p_num; /*delete npc player*/
            CALL cmd_delete_player(g_id,zombie_p_num);
          END IF;

      END IF;
    UNTIL done END REPEAT;
    CLOSE cur;


END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `zombies_make_mad`
--

DROP PROCEDURE IF EXISTS `zombies_make_mad`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `zombies_make_mad`(g_id INT,nec_board_id INT)
BEGIN
  DECLARE zombie_board_id INT;
  DECLARE zombie_u_id INT;
  DECLARE zombie_p_num INT;
  DECLARE new_player,team INT;
  DECLARE zombie_name VARCHAR(45) CHARSET utf8 DEFAULT 'Зомби $u_name';

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR
    SELECT buf.board_unit_id,bu.player_num,bu.unit_id
    FROM board_units_features buf JOIN board_units bu ON (buf.board_unit_id=bu.id)
    WHERE buf.feature_id=unit_feature_get_id_by_code('under_control') AND buf.param=nec_board_id;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

/*get necromancer team*/
  SELECT p.team INTO team FROM board_units bu JOIN players p ON (bu.game_id=p.game_id AND bu.player_num=p.player_num) WHERE bu.id=nec_board_id LIMIT 1;

/*if necromancer is dead*/
  IF (team IS NULL) THEN
    SELECT MAX(p.team)+1 INTO team FROM players p WHERE p.game_id=g_id;
    SET done=0; /*done=1 because no rows were in first team query*/
  END IF;

  OPEN cur;
  REPEAT
    FETCH cur INTO zombie_board_id,zombie_p_num,zombie_u_id;
    IF NOT done THEN

/*if zombie is not npc then create new player*/
      IF EXISTS(SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id AND bu.player_num=zombie_p_num AND bu.id<>zombie_board_id LIMIT 1)
        OR EXISTS(SELECT bb.id FROM board_buildings bb WHERE bb.game_id=g_id AND bb.player_num=zombie_p_num LIMIT 1)
      THEN

        SET zombie_name=REPLACE(zombie_name,'$u_name',(SELECT name FROM units WHERE id=zombie_u_id LIMIT 1));
        SELECT CASE WHEN MAX(p.player_num)<10 THEN 10 ELSE MAX(p.player_num)+1 END INTO new_player FROM players p WHERE p.game_id=g_id;

        INSERT INTO players(game_id,player_num,name,gold,owner,team) VALUES(g_id,new_player,zombie_name,0,2,team); /*owner=2 - frog*/
        CALL cmd_add_player(g_id,new_player);

        UPDATE board_units SET player_num=new_player WHERE id=zombie_board_id;
        CALL cmd_unit_set_owner(g_id,zombie_p_num,zombie_board_id);

      END IF;
    END IF;
  UNTIL done END REPEAT;
  CLOSE cur;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of view `vw_grave`
--

DROP TABLE IF EXISTS `vw_grave`;
DROP VIEW IF EXISTS `vw_grave`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_grave` AS select `g`.`game_id` AS `game_id`,`g`.`id` AS `grave_id`,`g`.`card_id` AS `card_id`,min(`gc`.`x`) AS `x`,min(`gc`.`y`) AS `y`,sqrt(count(0)) AS `size` from (`graves` `g` join `grave_cells` `gc` on((`g`.`id` = `gc`.`grave_id`))) group by `g`.`game_id`,`g`.`id`,`g`.`card_id`;

--
-- Definition of view `vw_mode_all_procedures`
--

DROP TABLE IF EXISTS `vw_mode_all_procedures`;
DROP VIEW IF EXISTS `vw_mode_all_procedures`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_mode_all_procedures` AS select `mp`.`mode_id` AS `mode_id`,`p`.`id` AS `id`,`p`.`name` AS `name`,`p`.`params` AS `params`,`p`.`ui_action_name` AS `ui_action_name` from (`vw_mode_all_procedures_ids` `mp` join `procedures` `p` on((`mp`.`procedure_id` = `p`.`id`)));

--
-- Definition of view `vw_mode_all_procedures_ids`
--

DROP TABLE IF EXISTS `vw_mode_all_procedures_ids`;
DROP VIEW IF EXISTS `vw_mode_all_procedures_ids`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_mode_all_procedures_ids` AS select `vw_mode_cards_procedures`.`mode_id` AS `mode_id`,`vw_mode_cards_procedures`.`procedure_id` AS `procedure_id` from `vw_mode_cards_procedures` union select `vw_mode_buildings_procedures`.`mode_id` AS `mode_id`,`vw_mode_buildings_procedures`.`procedure_id` AS `procedure_id` from `vw_mode_buildings_procedures` union select `vw_mode_units_procedures`.`mode_id` AS `mode_id`,`vw_mode_units_procedures`.`procedure_id` AS `procedure_id` from `vw_mode_units_procedures` union select `modes_other_procedures`.`mode_id` AS `mode_id`,`modes_other_procedures`.`procedure_id` AS `procedure_id` from `modes_other_procedures`;

--
-- Definition of view `vw_mode_building_default_features`
--

DROP TABLE IF EXISTS `vw_mode_building_default_features`;
DROP VIEW IF EXISTS `vw_mode_building_default_features`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_mode_building_default_features` AS select `b`.`mode_id` AS `mode_id`,`f`.`id` AS `id`,`f`.`building_id` AS `building_id`,`f`.`feature_id` AS `feature_id`,`f`.`param` AS `param` from (`vw_mode_buildings` `b` join `building_default_features` `f` on((`b`.`id` = `f`.`building_id`)));

--
-- Definition of view `vw_mode_buildings`
--

DROP TABLE IF EXISTS `vw_mode_buildings`;
DROP VIEW IF EXISTS `vw_mode_buildings`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_mode_buildings` AS select `c`.`mode_id` AS `mode_id`,`b`.`id` AS `id`,`b`.`name` AS `name`,`b`.`health` AS `health`,`b`.`radius` AS `radius`,`b`.`x_len` AS `x_len`,`b`.`y_len` AS `y_len`,`b`.`shape` AS `shape`,`b`.`type` AS `type`,`b`.`description` AS `description`,`b`.`log_short_name` AS `log_short_name`,`b`.`ui_code` AS `ui_code` from (`vw_mode_cards` `c` join `buildings` `b` on((`c`.`ref` = `b`.`id`))) where (`c`.`type` = 'b') union select `c`.`mode_id` AS `mode_id`,`b`.`id` AS `id`,`b`.`name` AS `name`,`b`.`health` AS `health`,`b`.`radius` AS `radius`,`b`.`x_len` AS `x_len`,`b`.`y_len` AS `y_len`,`b`.`shape` AS `shape`,`b`.`type` AS `type`,`b`.`description` AS `description`,`b`.`log_short_name` AS `log_short_name`,`b`.`ui_code` AS `ui_code` from (`modes_cardless_buildings` `c` join `buildings` `b` on((`c`.`building_id` = `b`.`id`)));

--
-- Definition of view `vw_mode_buildings_procedures`
--

DROP TABLE IF EXISTS `vw_mode_buildings_procedures`;
DROP VIEW IF EXISTS `vw_mode_buildings_procedures`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_mode_buildings_procedures` AS select distinct `b`.`mode_id` AS `mode_id`,`bp`.`building_id` AS `building_id`,`bp`.`procedure_id` AS `procedure_id` from (`vw_mode_buildings` `b` join `buildings_procedures` `bp` on((`b`.`id` = `bp`.`building_id`)));

--
-- Definition of view `vw_mode_cards`
--

DROP TABLE IF EXISTS `vw_mode_cards`;
DROP VIEW IF EXISTS `vw_mode_cards`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_mode_cards` AS select distinct `m`.`mode_id` AS `mode_id`,`c`.`id` AS `id`,`c`.`image` AS `image`,`c`.`cost` AS `cost`,`c`.`type` AS `type`,`c`.`ref` AS `ref`,`c`.`name` AS `name`,`c`.`description` AS `description` from (`modes_cards` `m` join `cards` `c` on((`m`.`card_id` = `c`.`id`)));

--
-- Definition of view `vw_mode_cards_procedures`
--

DROP TABLE IF EXISTS `vw_mode_cards_procedures`;
DROP VIEW IF EXISTS `vw_mode_cards_procedures`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_mode_cards_procedures` AS select distinct `c`.`mode_id` AS `mode_id`,`cp`.`card_id` AS `card_id`,`cp`.`procedure_id` AS `procedure_id` from (`vw_mode_cards` `c` join `cards_procedures` `cp` on((`c`.`id` = `cp`.`card_id`)));

--
-- Definition of view `vw_mode_unit_default_features`
--

DROP TABLE IF EXISTS `vw_mode_unit_default_features`;
DROP VIEW IF EXISTS `vw_mode_unit_default_features`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_mode_unit_default_features` AS select `u`.`mode_id` AS `mode_id`,`f`.`id` AS `id`,`f`.`unit_id` AS `unit_id`,`f`.`feature_id` AS `feature_id`,`f`.`param` AS `param` from (`vw_mode_units` `u` join `unit_default_features` `f` on((`u`.`id` = `f`.`unit_id`)));

--
-- Definition of view `vw_mode_unit_phrases`
--

DROP TABLE IF EXISTS `vw_mode_unit_phrases`;
DROP VIEW IF EXISTS `vw_mode_unit_phrases`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_mode_unit_phrases` AS select `mu`.`mode_id` AS `mode_id`,`dup`.`id` AS `id`,`dup`.`unit_id` AS `unit_id`,`dup`.`phrase` AS `phrase` from (`vw_mode_units` `mu` join `dic_unit_phrases` `dup` on((`mu`.`id` = `dup`.`unit_id`)));

--
-- Definition of view `vw_mode_units`
--

DROP TABLE IF EXISTS `vw_mode_units`;
DROP VIEW IF EXISTS `vw_mode_units`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_mode_units` AS select `c`.`mode_id` AS `mode_id`,`u`.`id` AS `id`,`u`.`name` AS `name`,`u`.`moves` AS `moves`,`u`.`health` AS `health`,`u`.`attack` AS `attack`,`u`.`size` AS `size`,`u`.`shield` AS `shield`,`u`.`description` AS `description`,`u`.`log_short_name` AS `log_short_name`,`u`.`log_name_rod_pad` AS `log_name_rod_pad`,`u`.`ui_code` AS `ui_code` from (`vw_mode_cards` `c` join `units` `u` on((`c`.`ref` = `u`.`id`))) where (`c`.`type` = 'u') union select `c`.`mode_id` AS `mode_id`,`u`.`id` AS `id`,`u`.`name` AS `name`,`u`.`moves` AS `moves`,`u`.`health` AS `health`,`u`.`attack` AS `attack`,`u`.`size` AS `size`,`u`.`shield` AS `shield`,`u`.`description` AS `description`,`u`.`log_short_name` AS `log_short_name`,`u`.`log_name_rod_pad` AS `log_name_rod_pad`,`u`.`ui_code` AS `ui_code` from (`modes_cardless_units` `c` join `units` `u` on((`c`.`unit_id` = `u`.`id`)));

--
-- Definition of view `vw_mode_units_procedures`
--

DROP TABLE IF EXISTS `vw_mode_units_procedures`;
DROP VIEW IF EXISTS `vw_mode_units_procedures`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_mode_units_procedures` AS select distinct `u`.`mode_id` AS `mode_id`,`up`.`unit_id` AS `unit_id`,`up`.`default` AS `default`,`up`.`procedure_id` AS `procedure_id` from (`vw_mode_units` `u` join `units_procedures` `up` on((`u`.`id` = `up`.`unit_id`)));

--
-- Definition of view `vw_statistic_values`
--

DROP TABLE IF EXISTS `vw_statistic_values`;
DROP VIEW IF EXISTS `vw_statistic_values`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_statistic_values` AS select `t`.`id` AS `tab_id`,`t`.`name` AS `tab_name`,`ch`.`id` AS `chart_id`,`ch`.`type` AS `chart_type`,`s`.`chart_name` AS `chart_name`,`s`.`game_id` AS `game_id`,`s`.`id` AS `value_id`,`s`.`value` AS `value`,`d`.`color` AS `color`,`s`.`name` AS `value_name` from (((((`statistic_values` `s` join `games` `g` on((`s`.`game_id` = `g`.`id`))) join `statistic_values_config` `c` on(((`g`.`mode_id` = `c`.`mode_id`) and (`s`.`player_num` = `c`.`player_num`) and (`s`.`measure_id` = `c`.`measure_id`)))) join `dic_colors` `d` on((`c`.`color` = `d`.`code`))) join `statistic_charts` `ch` on((`ch`.`id` = `c`.`chart_id`))) join `statistic_tabs` `t` on((`ch`.`tab_id` = `t`.`id`)));



/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
