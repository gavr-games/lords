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
  `card_id` int(10) unsigned,
  `x` int(11),
  `y` int(11),
  `size` double
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
-- Definition of function `building_feature_check`
--

DROP FUNCTION IF EXISTS `building_feature_check`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` FUNCTION `check_play_card`(g_id INT,p_num INT,crd_id INT,sender VARCHAR(30)) RETURNS int(11)
BEGIN
  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id LIMIT 1) THEN RETURN 1; END IF;/*Not your turn*/
  IF (SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id LIMIT 1)<>0 THEN RETURN 28; END IF;/*polza/vred in progress*/
  IF (SELECT units_moves_flag FROM active_players WHERE game_id=g_id LIMIT 1)=1 THEN RETURN 7; END IF;/*Already moved units*/
  IF NOT EXISTS(SELECT id FROM player_deck WHERE game_id=g_id AND player_num=p_num AND card_id=crd_id) THEN RETURN 10; END IF;/*No such card*/
  IF (SELECT gold FROM players WHERE game_id=g_id AND player_num=p_num LIMIT 1)<(SELECT cost FROM cards WHERE id=crd_id LIMIT 1) THEN RETURN 2; END IF;/*Not enough gold*/
  IF NOT EXISTS(SELECT cp.id FROM cards_procedures_1 cp JOIN procedures_mode_1 pm ON cp.procedure_id=pm.id WHERE cp.card_id=crd_id AND pm.name=sender LIMIT 1) THEN RETURN 15; END IF;/*Cheater - procedure from another card*/

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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

  IF NOT EXISTS(SELECT up.id FROM units_procedures_1 up JOIN procedures_mode_1 pm ON up.procedure_id=pm.id WHERE up.unit_id=u_id AND pm.name=action_procedure LIMIT 1) THEN RETURN 30; END IF;/*Cheater - procedure from another unit*/

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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='' */ $$
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
-- Create schema lords_site
--

CREATE DATABASE IF NOT EXISTS lords_site;
USE lords_site;

--
-- Definition of function `user_nick`
--

DROP FUNCTION IF EXISTS `user_nick`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` FUNCTION `user_nick`(user_id INT) RETURNS varchar(200) CHARSET utf8
BEGIN
 RETURN (SELECT u.login FROM users u WHERE u.id=user_id LIMIT 1);
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;
--
-- Create schema lords
--

CREATE DATABASE IF NOT EXISTS lords;
USE lords;

--
-- Definition of procedure `agree_draw`
--

DROP PROCEDURE IF EXISTS `agree_draw`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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
-- Definition of procedure `attack`
--

DROP PROCEDURE IF EXISTS `attack`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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
              CALL vampire_resurrect_by_card(board_unit_id,aim_card_id);
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `buy_card`(g_id INT,p_num INT)
BEGIN
  DECLARE card_cost INT;
  DECLARE new_card INT;
  DECLARE first_card_id INT;
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_independent_message($p_num,"Купил карту")';
  DECLARE cmd_log_buyer VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_independent_message($p_num,"$card_name")';

  SELECT `value` INTO card_cost FROM mode_config_1 WHERE param='card cost';

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
            DELETE FROM deck WHERE game_id=g_id AND id=first_card_id;

            CALL cmd_player_set_gold(g_id,p_num);
            CALL cmd_add_card(g_id,p_num,new_card);

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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_armageddon`(g_id INT,p_num INT,crd_id INT)
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


  SET err_code=check_play_card(g_id,p_num,crd_id,'cast_armageddon');
  IF err_code<>0 THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    CALL user_action_begin();

    CALL play_card_actions(g_id,p_num,crd_id); /*Set gold, remove card,update log*/

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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_eagerness`(g_id INT,p_num INT,crd_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE attack_bonus INT DEFAULT 2;

  SET err_code=check_play_card(g_id,p_num,crd_id,'cast_eagerness');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,crd_id); /*Set gold, remove card, update log*/

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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_fireball`(g_id INT,p_num INT,crd_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE fb_damage INT DEFAULT 1;

  SET err_code=check_play_card(g_id,p_num,crd_id,'cast_fireball');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,crd_id); /*Set gold, remove card, update log*/

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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_half_money`(g_id INT,p_num INT,crd_id INT)
BEGIN
  DECLARE err_code INT;
  DECLARE p_num_cur INT;

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT p.player_num FROM players p WHERE p.game_id=g_id AND owner<>0 AND gold>0;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SET err_code=check_play_card(g_id,p_num,crd_id,'cast_half_money');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    CALL user_action_begin();

    CALL play_card_actions(g_id,p_num,crd_id); /*Set gold, remove card, update log*/

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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_healing`(g_id INT,p_num INT,crd_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE hp_heal INT DEFAULT 1;

  SET err_code=check_play_card(g_id,p_num,crd_id,'cast_healing');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,crd_id); /*Set gold, remove card, update log*/

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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_lightening_max`(g_id INT,p_num INT,crd_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE li_damage INT DEFAULT 3;

  SET err_code=check_play_card(g_id,p_num,crd_id,'cast_lightening_max');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,crd_id); /*Set gold, remove card, update log*/

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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_lightening_min`(g_id INT,p_num INT,crd_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE li_damage INT DEFAULT 2;

  SET err_code=check_play_card(g_id,p_num,crd_id,'cast_lightening_min');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,crd_id); /*Set gold, remove card, update log*/

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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_madness`(g_id INT,p_num INT,crd_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;

  SET err_code=check_play_card(g_id,p_num,crd_id,'cast_madness');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,crd_id); /*Set gold, remove card, update log*/

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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_meteor_shower`(g_id INT,p_num INT,crd_id INT,x INT,y INT)
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

  SET err_code=check_play_card(g_id,p_num,crd_id,'cast_meteor_shower');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF (x<0 OR x>(20-meteor_size) OR y<0 OR y>(20-meteor_size)) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=23;/*Aim out of deck*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,crd_id); /*Set gold, remove card, update log*/

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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_mind_control`(g_id INT,p_num INT,crd_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE p2_num INT;
  DECLARE dice INT;
  DECLARE npc_gold INT;
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit начинает подчиняться игроку $log_player")';

  SET err_code=check_play_card(g_id,p_num,crd_id,'cast_mind_control');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,crd_id); /*Set gold, remove card, update log*/

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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_o_d`(g_id INT,p_num INT,crd_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE shield INT;
  DECLARE dice INT;

  SET err_code=check_play_card(g_id,p_num,crd_id,'cast_o_d');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,crd_id); /*Set gold, remove card, update log*/

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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_paralich`(g_id INT,p_num INT,crd_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE shield INT;

  SET err_code=check_play_card(g_id,p_num,crd_id,'cast_paralich');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,crd_id); /*Set gold, remove card, update log*/

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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_polza_main`(g_id INT,p_num INT,crd_id INT)
BEGIN
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

  SET err_code=check_play_card(g_id,p_num,crd_id,'cast_polza_main');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    CALL user_action_begin();

    CALL play_card_actions(g_id,p_num,crd_id); /*Set gold, remove card, update log*/

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
          SELECT x,y,direction_into_board_x,direction_into_board_y INTO x_appear,y_appear,x_dir,y_dir FROM appear_points WHERE player_num=p_num;
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
          DECLARE cmd_log_buyer VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Новая карта <b class=\'logCard\'>$card_name</b>")';
          DECLARE cmd_no_cards VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Карт больше нет")';

          WHILE take_cards_qty>0 AND EXISTS(SELECT id FROM deck WHERE game_id=g_id LIMIT 1) DO
            SET take_cards_qty=take_cards_qty-1;

            SELECT MIN(id) INTO first_card_id FROM deck WHERE game_id=g_id;
            SELECT card_id INTO new_card FROM deck WHERE game_id=g_id AND id=first_card_id;
            INSERT INTO player_deck (game_id,player_num,card_id) VALUES (g_id,p_num,new_card);
            DELETE FROM deck WHERE game_id=g_id AND id=first_card_id;

            CALL cmd_add_card(g_id,p_num,new_card);

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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_polza_resurrect`(g_id INT,p_num INT,dead_card_id INT)
BEGIN
  DECLARE nonfinished_action INT DEFAULT 1;
  DECLARE x_appear,y_appear,x_dir,y_dir INT;
  DECLARE size INT;
  DECLARE u_id INT;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;/*Not your turn*/
  ELSE
    IF NOT nonfinished_action=(SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=24;/*Can't finish nonfinished action*/
    ELSE
      IF NOT EXISTS(SELECT id FROM dead_units WHERE game_id=g_id AND card_id=dead_card_id LIMIT 1) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=8;/*Card not in grave*/
      ELSE
          CALL user_action_begin();

          SELECT x,y,direction_into_board_x,direction_into_board_y INTO x_appear,y_appear,x_dir,y_dir FROM appear_points WHERE player_num=p_num;
          SELECT u.id,u.size INTO u_id,size FROM cards c JOIN units u ON c.ref=u.id WHERE c.id=dead_card_id LIMIT 1;
          IF EXISTS(SELECT id FROM board WHERE game_id=g_id AND x BETWEEN LEAST(x_appear,x_appear+x_dir*(size-1)) AND GREATEST(x_appear,x_appear+x_dir*(size-1)) AND y BETWEEN LEAST(y_appear,y_appear+y_dir*(size-1)) AND GREATEST(y_appear,y_appear+y_dir*(size-1)) LIMIT 1) THEN
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=9;/*Appear point occupied*/
          ELSE

            CALL resurrect(g_id,p_num,dead_card_id);
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_pooring`(g_id INT,p_num INT,crd_id INT,p2_num INT)
BEGIN
  DECLARE err_code INT;
  DECLARE pooring_sum INT DEFAULT 50;
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_player теряет $log_gold")';

  SET err_code=check_play_card(g_id,p_num,crd_id,'cast_pooring');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT id FROM players WHERE game_id=g_id AND player_num=p2_num) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=13;/*Player doesn't exist*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,crd_id); /*Set gold, remove card, update log*/

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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_repair_buildings`(g_id INT,p_num INT,crd_id INT)
BEGIN
  DECLARE err_code INT;

  SET err_code=check_play_card(g_id,p_num,crd_id,'cast_repair_buildings');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    CALL user_action_begin();

    CALL play_card_actions(g_id,p_num,crd_id); /*Set gold, remove card, update log*/

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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_riching`(g_id INT,p_num INT,crd_id INT)
BEGIN
  DECLARE err_code INT;
  DECLARE riching_sum INT DEFAULT 50;

  SET err_code=check_play_card(g_id,p_num,crd_id,'cast_riching');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    CALL user_action_begin();

    CALL play_card_actions(g_id,p_num,crd_id); /*Set gold, remove card, update log*/

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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_russian_ruletka`(g_id INT,p_num INT,crd_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;

  SET err_code=check_play_card(g_id,p_num,crd_id,'cast_russian_ruletka');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,crd_id); /*Set gold, remove card, update log*/

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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_shield`(g_id INT,p_num INT,crd_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;

  SET err_code=check_play_card(g_id,p_num,crd_id,'cast_shield');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,crd_id); /*Set gold, remove card, update log*/

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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_show_cards`(g_id INT,p_num INT,crd_id INT,p2_num INT)
BEGIN
  DECLARE err_code INT;
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Карты игрока $log_player:")';
  DECLARE cmd_log_card VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("<b class=\'logCard\'>$card_name</b>")';
  DECLARE card_name VARCHAR(1000) CHARSET utf8;

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT c.name FROM player_deck pd JOIN cards c ON (pd.card_id=c.id) WHERE pd.game_id=g_id AND pd.player_num=p2_num;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;


  SET err_code=check_play_card(g_id,p_num,crd_id,'cast_show_cards');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT id FROM players WHERE game_id=g_id AND player_num=p2_num) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=13;/*Player doesn't exist*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,crd_id); /*Set gold, remove card, update log*/

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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_speeding`(g_id INT,p_num INT,crd_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE speed_bonus INT DEFAULT 2;

  SET err_code=check_play_card(g_id,p_num,crd_id,'cast_speeding');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,crd_id); /*Set gold, remove card, update log*/

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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_telekinesis`(g_id INT,p_num INT,crd_id INT,p2_num INT)
BEGIN
  DECLARE err_code INT;
  DECLARE rand_card INT;
  DECLARE big_dice INT;
  DECLARE stolen_card_id INT;
  DECLARE stolen_card_name VARCHAR(45) CHARSET utf8;
  DECLARE cmd_log_p VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Новая карта <b class=\'logCard\'>$card_name</b>")';
  DECLARE cmd_log_p2 VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Похищена карта <b class=\'logCard\'>$card_name</b>")';

  SET err_code=check_play_card(g_id,p_num,crd_id,'cast_telekinesis');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT id FROM players WHERE game_id=g_id AND player_num=p2_num) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=13;/*Player doesn't exist*/
    ELSE
      IF NOT EXISTS(SELECT id FROM player_deck WHERE game_id=g_id AND player_num=p2_num LIMIT 1) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=22;/*Player doesn't have cards*/
      ELSE
        CALL user_action_begin();

        CALL play_card_actions(g_id,p_num,crd_id); /*Set gold, remove card, update log*/

        CREATE TEMPORARY TABLE pl_cards (id_rand INT AUTO_INCREMENT PRIMARY KEY)AUTO_INCREMENT=1 SELECT id AS `pd_id` FROM player_deck WHERE game_id=g_id AND player_num=p2_num;
        SELECT FLOOR(1 + (RAND() * MAX(id_rand))) INTO big_dice FROM pl_cards;
        SELECT pd_id INTO rand_card FROM pl_cards WHERE id_rand=big_dice LIMIT 1;
        DROP TEMPORARY TABLE pl_cards;

        SELECT card_id INTO stolen_card_id FROM player_deck WHERE id=rand_card;
        UPDATE player_deck SET player_num=p_num WHERE id=rand_card;
        CALL cmd_remove_card(g_id,p2_num,stolen_card_id);
        CALL cmd_add_card(g_id,p_num,stolen_card_id);

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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_teleport`(g_id INT,p_num INT,crd_id INT,x INT,y INT, x2 INT, y2 INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE u_id INT;
  DECLARE size INT;
  DECLARE target INT;
  DECLARE binded_unit_id INT;

  SET err_code=check_play_card(g_id,p_num,crd_id,'cast_teleport');
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

        CALL play_card_actions(g_id,p_num,crd_id); /*Set gold, remove card, update log*/

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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_unit_upgrade_all`(g_id INT,p_num INT,crd_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE speed_bonus INT DEFAULT 1;
  DECLARE health_bonus INT DEFAULT 1;
  DECLARE attack_bonus INT DEFAULT 1;

  SET err_code=check_play_card(g_id,p_num,crd_id,'cast_unit_upgrade_all');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,crd_id); /*Set gold, remove card, update log*/

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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_unit_upgrade_random`(g_id INT,p_num INT,crd_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE dice INT;
  DECLARE speed_bonus INT DEFAULT 3;
  DECLARE health_bonus INT DEFAULT 3;
  DECLARE attack_bonus INT DEFAULT 3;

  SET err_code=check_play_card(g_id,p_num,crd_id,'cast_unit_upgrade_random');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,crd_id); /*Set gold, remove card, update log*/

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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_vampire`(g_id INT,p_num INT,crd_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE vamp_u_id INT DEFAULT 13;
  DECLARE vamp_owner INT DEFAULT 4; /*4*/
  DECLARE team INT;
  DECLARE new_player INT;
  DECLARE vamp_name VARCHAR(45) CHARSET utf8;
  DECLARE new_unit_id INT;
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("В клетке $log_cell появляется $log_unit")';

  SET err_code=check_play_card(g_id,p_num,crd_id,'cast_vampire');
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

        CALL play_card_actions(g_id,p_num,crd_id); /*Set gold, remove card, update log*/

        SELECT MAX(p.team)+1 INTO team FROM players p WHERE p.game_id=g_id;
        SELECT CASE WHEN MAX(p.player_num)<10 THEN 10 ELSE MAX(p.player_num)+1 END INTO new_player FROM players p WHERE p.game_id=g_id;
        SELECT name INTO vamp_name FROM units WHERE id=vamp_u_id LIMIT 1;

        INSERT INTO players(game_id,player_num,name,gold,owner,team) VALUES(g_id,new_player,vamp_name,0,vamp_owner,team);
        CALL cmd_add_player(g_id,new_player);

        INSERT INTO board_units(game_id,player_num,unit_id) VALUES(g_id,new_player,vamp_u_id);
        SET new_unit_id=@@last_insert_id;
        INSERT INTO board_units_features(board_unit_id,feature_id,param) SELECT new_unit_id,ufu.feature_id,ufu.param FROM unit_features_usage ufu WHERE ufu.unit_id=vamp_u_id;

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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_vred_main`(g_id INT,p_num INT,crd_id INT)
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

  SET err_code=check_play_card(g_id,p_num,crd_id,'cast_vred_main');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    CALL user_action_begin();

    CALL play_card_actions(g_id,p_num,crd_id); /*Set gold, remove card, update log*/

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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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
-- Definition of procedure `cmd_add_card`
--

DROP PROCEDURE IF EXISTS `cmd_add_card`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_add_card`(g_id INT,p_num INT,new_card_id INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'add_card($card_id)';

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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_add_to_grave`(g_id INT,p_num INT,dead_card_id INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'add_to_grave($dead_card_id,$x,$y,$size)';

  SET cmd=REPLACE(cmd,'$dead_card_id',dead_card_id);
  SET cmd=REPLACE(cmd,'$x,$y,$size',(SELECT CONCAT(d.x,',',d.y,',',d.size) FROM vw_grave d WHERE game_id=g_id AND card_id=dead_card_id LIMIT 1));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cmd_add_unit`
--

DROP PROCEDURE IF EXISTS `cmd_add_unit`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_play_video`(g_id INT,p_num INT,video_code VARCHAR(45),hidden INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'play_video("$title","$filename")';
  DECLARE g_mode INT;

  SELECT mode_id INTO g_mode FROM games WHERE id=g_id;

  SET cmd=REPLACE(cmd,'$title',(SELECT v.title FROM videos v WHERE v.code=video_code AND v.`mode`=g_mode));
  SET cmd=REPLACE(cmd,'$filename',(SELECT v.filename FROM videos v WHERE v.code=video_code AND v.`mode`=g_mode));
  INSERT INTO command (game_id,player_num,command,hidden_flag) VALUES (g_id,p_num,cmd,hidden);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cmd_put_building`
--

DROP PROCEDURE IF EXISTS `cmd_put_building`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_remove_card`(g_id INT,p_num INT,crd_id INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'remove_card($card_id)';

  SET cmd=REPLACE(cmd,'$card_id',crd_id);
  INSERT INTO command (game_id,player_num,command,hidden_flag) VALUES (g_id,p_num,cmd,1);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cmd_remove_from_grave`
--

DROP PROCEDURE IF EXISTS `cmd_remove_from_grave`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_remove_from_grave`(g_id INT,p_num INT,dead_card_id INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'remove_from_grave($dead_card_id)';

  SET cmd=REPLACE(cmd,'$dead_card_id',dead_card_id);
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `cmd_remove_spectator`
--

DROP PROCEDURE IF EXISTS `cmd_remove_spectator`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_unit_remove_effect`(g_id INT,board_unit_id INT,eff VARCHAR(30))
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'unit_remove_effect($x,$y,"$effect")';
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit <b class=\'unitEffect\'>?????? ?? $effect_desc</b>")';
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `count_income`(board_building_id INT)
BEGIN
  DECLARE x,y,x1,y1 INT;
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE building_income INT;
  DECLARE income INT DEFAULT 0;

  DECLARE radius INT;
  DECLARE shape VARCHAR(45);

  SELECT bb.game_id,bb.player_num,b.radius,b.shape INTO g_id,p_num,radius,shape FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.id=board_building_id LIMIT 1;

        IF(shape='1' AND radius>0)THEN
        BEGIN
          SELECT MIN(b.x),MIN(b.y) INTO x,y FROM board b WHERE b.game_id=g_id AND b.`type`<>'unit' AND b.ref=board_building_id;

          SELECT `value` INTO building_income FROM mode_config_1 WHERE param='building income';

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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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
    DELETE FROM command WHERE game_id=g_id;
    DELETE FROM dead_units WHERE game_id=g_id;
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_player_objects`(g_id INT,p_num INT)
BEGIN
/*units, buildings, cards*/
  DECLARE crd_id INT;
  DECLARE board_unit_id INT;
  DECLARE board_building_id INT;

  DECLARE done INT DEFAULT 0;
  DECLARE cur1 CURSOR FOR SELECT pd.card_id FROM player_deck pd WHERE pd.game_id=g_id AND pd.player_num=p_num;
  DECLARE cur2 CURSOR FOR SELECT bu.id,bu.card_id FROM board_units bu WHERE bu.game_id=g_id AND bu.player_num=p_num;
  DECLARE cur3 CURSOR FOR SELECT bb.id FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.game_id=g_id AND bb.player_num=p_num AND b.`type`<>'obstacle';
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

/*cards*/
    OPEN cur1;
    REPEAT
      FETCH cur1 INTO crd_id;
      IF NOT done THEN
        CALL cmd_remove_card(g_id,p_num,crd_id);
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur1;

  INSERT INTO deck(game_id,card_id) SELECT g_id,pd.card_id FROM player_deck pd WHERE pd.game_id=g_id AND pd.player_num=p_num;
  DELETE FROM player_deck WHERE game_id=g_id AND player_num=p_num;

  SET done=0;

/*units*/
  INSERT INTO dead_units(game_id,card_id,x,y)
  SELECT g_id,bu.card_id,b.x,b.y FROM board_units bu
  JOIN board b ON (b.ref=bu.id)
  WHERE bu.game_id=g_id AND bu.player_num=p_num AND bu.card_id IS NOT NULL
  AND b.`type`='unit';

    OPEN cur2;
    REPEAT
      FETCH cur2 INTO board_unit_id,crd_id;
      IF NOT done THEN
        CALL cmd_kill_unit(g_id,p_num,board_unit_id);
        DELETE FROM board WHERE game_id=g_id AND `type`='unit' AND ref=board_unit_id;
        IF crd_id IS NOT NULL THEN
          CALL cmd_add_to_grave(g_id,p_num,crd_id);
        END IF;
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `end_turn`(g_id INT,p_num INT)
BEGIN
  DECLARE board_unit_id INT;
  DECLARE p_num2 INT;
  DECLARE owner_p2 INT;
  DECLARE last_turn INT;
  DECLARE turn,new_turn INT;

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
/*income and healing tower*/
    DECLARE income INT;
    DECLARE u_income INT;

    SELECT `value` INTO u_income FROM mode_config_1 WHERE param='unit income';
/*income from buildings*/
    SELECT IFNULL(SUM(bb.income),0) INTO income FROM board_buildings bb WHERE bb.game_id=g_id AND bb.player_num=p_num2 AND bb.income<>0 AND check_building_deactivated(bb.id)=0;
/*income from units*/
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
    DECLARE cmd_log_close_container VARCHAR(1000) CHARSET utf8 DEFAULT 'log_close_container()';

    IF((SELECT MIN(p.player_num) FROM players p WHERE p.game_id=g_id AND owner NOT IN(0,1))=p_num2)THEN
      SET cmd_log_open_container=REPLACE(cmd_log_open_container,'$p_num',p_num2);
      INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num2,cmd_log_open_container);
    END IF;

    IF((SELECT MAX(p.player_num) FROM players p WHERE p.game_id=g_id AND owner NOT IN(0,1))=p_num2)THEN
      INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num2,cmd_log_close_container);
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `finish_nonfinished_action`(g_id INT,p_num INT,nonfinished_action INT)
BEGIN

  CASE nonfinished_action

    WHEN 1 THEN /*resurrect*/
    BEGIN
      DECLARE big_dice INT;
      DECLARE x_appear,y_appear INT;
      DECLARE max_size INT;
      DECLARE random_dead_card INT;

      SELECT x,y INTO x_appear,y_appear FROM appear_points WHERE player_num=p_num;
      /*get max resurrectable size*/
      SELECT IFNULL(MIN(GREATEST(ABS(b.x-18),ABS(b.y-18))),18) INTO max_size FROM board b
      WHERE b.x NOT IN(0,19) AND b.y NOT IN(0,19);
      /*get random dead*/
        CREATE TEMPORARY TABLE tmp_dead_units (id_rand INT AUTO_INCREMENT PRIMARY KEY)AUTO_INCREMENT=1
          SELECT DISTINCT g.card_id AS `card_id`
          FROM vw_grave g
          WHERE g.game_id=g_id AND g.size<=max_size;
        SELECT FLOOR(1 + (RAND() * MAX(id_rand))) INTO big_dice FROM tmp_dead_units;
        SELECT `card_id` INTO random_dead_card FROM tmp_dead_units WHERE id_rand=big_dice LIMIT 1;
        DROP TEMPORARY TABLE tmp_dead_units;

        CALL resurrect(g_id,p_num,random_dead_card);
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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
  SELECT v.card_id, v.x, v.y, v.size FROM vw_grave v WHERE v.game_id=g_id;

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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_games_info`()
BEGIN

  SELECT
    g.id AS `game_id`,
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_game_info`(g_id INT)
BEGIN

  SELECT
    g.id AS `game_id`,
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `hit_castle`(board_castle_id INT,p_num INT,damage INT)
BEGIN
  DECLARE g_id INT;
  DECLARE hp INT;
  DECLARE hp_reward INT;

  SELECT `value` INTO hp_reward FROM mode_config_1 WHERE param='castle hit reward';

  SELECT bb.game_id,bb.health INTO g_id,hp FROM board_buildings bb WHERE bb.id=board_castle_id LIMIT 1;

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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `init_buildings`(g_id INT)
BEGIN
  DECLARE g_mode INT;

  DECLARE p_num INT;
  DECLARE x_0 INT;
  DECLARE y_0 INT;
  DECLARE rotation INT;
  DECLARE flip INT;
  DECLARE rule_sql VARCHAR(200) CHARSET utf8;
  DECLARE board_building_id INT;
  DECLARE building_id INT;
  DECLARE x_len INT;
  DECLARE y_len INT;
  DECLARE radius INT;
  DECLARE shape VARCHAR(45);
  DECLARE building_type VARCHAR(45);
  DECLARE building_income INT;

  DECLARE sql_query_get_param VARCHAR(1000) DEFAULT 'INSERT INTO param_val(id,val) SELECT ?,value FROM mode_config_$mode_id WHERE param=? LIMIT 1;';

  DECLARE board_buildings_table VARCHAR(45);
  DECLARE buildings_table VARCHAR(45);
  DECLARE board_table VARCHAR(45);

  DECLARE sql_query_ins_board_building VARCHAR(2000) DEFAULT 'INSERT INTO $board_buildings_table(game_id,player_num,building_id,rotation,flip) VALUES ($g_id,?,?,?,?);';
  DECLARE sql_query_ins_board VARCHAR(2000) DEFAULT 'INSERT INTO $board_table(game_id,x,y,type,ref) VALUES ($g_id,?,?,?,?);';
  DECLARE sql_query_get_building_params VARCHAR(2000) CHARSET utf8 DEFAULT 'INSERT INTO building_params (id,x_len,y_len,shape,radius,type) SELECT id,x_len,y_len,shape,radius,type FROM $buildings_table WHERE $rule LIMIT 1;';
  DECLARE sql_query_update_income VARCHAR(2000) DEFAULT 'UPDATE $board_buildings_table SET income=? WHERE id=?;';

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT cfg.player_num,cfg.x,cfg.y,cfg.rotation,CASE cfg.flip WHEN 0 THEN 1 ELSE -1 END AS `flip`,cfg.rule FROM put_start_buildings_config cfg JOIN players p ON cfg.player_num=p.player_num WHERE p.game_id=g_id AND p.owner<>0 AND cfg.mode_id=g_mode;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SELECT mode_id INTO g_mode FROM games WHERE id=g_id LIMIT 1;

  CREATE TEMPORARY TABLE param_val(id INT PRIMARY KEY,val VARCHAR(45));
  SET @sql_query_get_param=REPLACE(sql_query_get_param,'$mode_id',g_mode);

  PREPARE stmt FROM @sql_query_get_param;
  SET @param_name='board buildings table';
  SET @param_id=1;
  EXECUTE stmt USING @param_id,@param_name;
  SET @param_name='buildings table';
  SET @param_id=2;
  EXECUTE stmt USING @param_id,@param_name;
  SET @param_name='board table';
  SET @param_id=3;
  EXECUTE stmt USING @param_id,@param_name;
  SET @param_name='building income';
  SET @param_id=4;
  EXECUTE stmt USING @param_id,@param_name;
  DROP PREPARE stmt;
  SELECT val INTO board_buildings_table FROM param_val WHERE id=1;
  SELECT val INTO buildings_table FROM param_val WHERE id=2;
  SELECT val INTO board_table FROM param_val WHERE id=3;
  SELECT val INTO building_income FROM param_val WHERE id=4;
  DROP TEMPORARY TABLE param_val;

  SET sql_query_ins_board_building=REPLACE(sql_query_ins_board_building,'$board_buildings_table',board_buildings_table);
  SET @sql_query_ins_board_building=REPLACE(sql_query_ins_board_building,'$g_id',g_id);
  SET sql_query_ins_board=REPLACE(sql_query_ins_board,'$board_table',board_table);
  SET @sql_query_ins_board=REPLACE(sql_query_ins_board,'$g_id',g_id);
  SET sql_query_get_building_params=REPLACE(sql_query_get_building_params,'$buildings_table',buildings_table);
  SET @sql_query_update_income=REPLACE(sql_query_update_income,'$board_buildings_table',board_buildings_table);

  PREPARE stmt_ins_board_building FROM @sql_query_ins_board_building;
  PREPARE stmt_ins_board FROM @sql_query_ins_board;
  PREPARE stmt_update_income FROM @sql_query_update_income;
  CREATE TEMPORARY TABLE building_params(id INT,x_len INT,y_len INT,shape VARCHAR(45),radius INT,`type` VARCHAR(45));

  OPEN cur;
  REPEAT
    FETCH cur INTO p_num, x_0, y_0, rotation, flip, rule_sql;
    IF NOT done THEN
    /*Get building params*/
      SET @sql_query_get_building_params=REPLACE(sql_query_get_building_params,'$rule',rule_sql);
      PREPARE stmt FROM @sql_query_get_building_params;
      EXECUTE stmt;
      DROP PREPARE stmt;
      SELECT building_params.id,building_params.x_len,building_params.y_len,building_params.shape,building_params.radius,`type` INTO building_id,x_len,y_len,shape,radius,building_type FROM building_params;
      TRUNCATE TABLE building_params;

    /*Insert into board_buildings*/
      SET @p_num=p_num;
      SET @building_id=building_id;
      SET @rotation=rotation;
      SET @flip=CASE flip WHEN 1 THEN 0 ELSE 1 END;
      EXECUTE stmt_ins_board_building USING @p_num,@building_id,@rotation,@flip;
      SET @board_building_id=@@last_insert_id;

    /*Insert into board*/
      SET @type=building_type;
      IF rotation=0 THEN
      BEGIN
        DECLARE i INT DEFAULT 0;
        SET x_0=CASE flip WHEN 1 THEN x_0 ELSE x_0+x_len-1 END;
        WHILE i<x_len*y_len DO
          IF SUBSTRING(shape,i+1,1)='1' THEN
            SET @x=x_0+flip*(i % x_len);
            SET @y=y_0+(i DIV x_len);
            EXECUTE stmt_ins_board USING @x,@y,@type,@board_building_id;
          END IF;
          SET i=i+1;
        END WHILE;
      END;
      END IF;
      IF rotation=1 THEN
      BEGIN
        DECLARE i INT DEFAULT 0;
        SET x_0=CASE flip WHEN 1 THEN x_0+y_len-1 ELSE x_0 END;
        WHILE i<x_len*y_len DO
          IF SUBSTRING(shape,i+1,1)='1' THEN
            SET @x=x_0-flip*(i DIV x_len);
            SET @y=y_0+(i % x_len);
            EXECUTE stmt_ins_board USING @x,@y,@type,@board_building_id;
          END IF;
          SET i=i+1;
        END WHILE;
      END;
      END IF;
      IF rotation=2 THEN
      BEGIN
        DECLARE i INT DEFAULT 0;
        SET x_0=CASE flip WHEN 1 THEN x_0+x_len-1 ELSE x_0 END;
        SET y_0=y_0+y_len-1;
        WHILE i<x_len*y_len DO
          IF SUBSTRING(shape,i+1,1)='1' THEN
            SET @x=x_0-flip*(i % x_len);
            SET @y=y_0-(i DIV x_len);
            EXECUTE stmt_ins_board USING @x,@y,@type,@board_building_id;
          END IF;
          SET i=i+1;
        END WHILE;
      END;
      END IF;
      IF rotation=3 THEN
      BEGIN
        DECLARE i INT DEFAULT 0;
        SET x_0=CASE flip WHEN 1 THEN x_0 ELSE x_0+y_len-1 END;
        SET y_0=y_0+x_len-1;
        WHILE i<x_len*y_len DO
          IF SUBSTRING(shape,i+1,1)='1' THEN
            SET @x=x_0+flip*(i DIV x_len);
            SET @y=y_0-(i % x_len);
            EXECUTE stmt_ins_board USING @x,@y,@type,@board_building_id;
          END IF;
          SET i=i+1;
        END WHILE;
      END;
      END IF;

    /*Count income*/
      IF(shape='1' AND radius>0)THEN
      BEGIN
        DECLARE x INT;
        DECLARE y INT;
        DECLARE income INT DEFAULT 0;
        SET x=x_0-radius;
        WHILE x<=x_0+radius DO
          SET y=y_0-radius;
          WHILE y<=y_0+radius DO
            IF(quart(x,y)<>5 AND quart(x,y)<>p_num AND NOT (x=x_0 AND y=y_0) )THEN
              SET income=income+building_income;
            END IF;
            SET y=y+1;
          END WHILE;
          SET x=x+1;
        END WHILE;
        SET @income=income;
        EXECUTE stmt_update_income USING @income,@board_building_id;
      END;
      END IF;
    END IF;
  UNTIL done END REPEAT;
  CLOSE cur;

  DROP TEMPORARY TABLE building_params;
  DROP PREPARE stmt_ins_board_building;
  DROP PREPARE stmt_ins_board;
  DROP PREPARE stmt_update_income;


END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `init_decks`
--

DROP PROCEDURE IF EXISTS `init_decks`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `init_decks`(g_id INT)
BEGIN
  DECLARE g_mode INT;

  DECLARE p_num INT;
  DECLARE rule_sql VARCHAR(200) CHARSET utf8;
  DECLARE qty INT; /*Quantity of cards*/

  DECLARE sql_query_get_param VARCHAR(1000) DEFAULT 'INSERT INTO param_val(id,val) SELECT ?,value FROM mode_config_$mode_id WHERE param=? LIMIT 1;';

  DECLARE player_deck_table VARCHAR(45);
  DECLARE game_deck_table VARCHAR(45);
  DECLARE cards_table VARCHAR(45);

  DECLARE sql_query_ins_card VARCHAR(2000) CHARSET utf8 DEFAULT 'INSERT INTO $player_deck_table(game_id,player_num,card_id)SELECT $g_id,$p_num,id FROM $cards_table WHERE id NOT IN (SELECT card_id FROM $player_deck_table WHERE game_id=$g_id) AND $rule ORDER BY RAND(),RAND() LIMIT $qty;';
  DECLARE sql_query_ins_game_deck VARCHAR(2000) DEFAULT 'INSERT INTO $game_deck_table(game_id,card_id) SELECT $g_id,id FROM $cards_table WHERE id NOT IN (SELECT card_id FROM $player_deck_table WHERE game_id=$g_id) ORDER BY RAND(),RAND();';
  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT cfg.player_num,cfg.quantity,cfg.rule FROM player_start_deck_config cfg JOIN players p ON cfg.player_num=p.player_num WHERE p.game_id=g_id AND p.owner<>0 AND cfg.mode_id=g_mode;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SELECT mode_id INTO g_mode FROM games WHERE id=g_id LIMIT 1;

  CREATE TEMPORARY TABLE param_val(id INT PRIMARY KEY,val VARCHAR(45));
  SET @sql_query_get_param=REPLACE(sql_query_get_param,'$mode_id',g_mode);

  PREPARE stmt FROM @sql_query_get_param;
  SET @param_name='player deck table';
  SET @param_id=1;
  EXECUTE stmt USING @param_id,@param_name;
  SET @param_name='cards table';
  SET @param_id=2;
  EXECUTE stmt USING @param_id,@param_name;
  SET @param_name='game deck table';
  SET @param_id=3;
  EXECUTE stmt USING @param_id,@param_name;
  DROP PREPARE stmt;
  SELECT val INTO player_deck_table FROM param_val WHERE id=1;
  SELECT val INTO cards_table FROM param_val WHERE id=2;
  SELECT val INTO game_deck_table FROM param_val WHERE id=3;
  DROP TEMPORARY TABLE param_val;

  SET sql_query_ins_card=REPLACE(sql_query_ins_card,'$player_deck_table',player_deck_table);
  SET sql_query_ins_card=REPLACE(sql_query_ins_card,'$g_id',g_id);
  SET sql_query_ins_card=REPLACE(sql_query_ins_card,'$cards_table',cards_table);

  OPEN cur;
  REPEAT
    FETCH cur INTO p_num, qty, rule_sql;
    IF NOT done THEN
      SET @sql_query_ins_card=REPLACE(sql_query_ins_card,'$p_num',p_num);
      SET @sql_query_ins_card=REPLACE(@sql_query_ins_card,'$rule',rule_sql);
      SET @sql_query_ins_card=REPLACE(@sql_query_ins_card,'$qty',qty);
      PREPARE stmt FROM @sql_query_ins_card;
      EXECUTE stmt;
      DROP PREPARE stmt;
    END IF;
  UNTIL done END REPEAT;
  CLOSE cur;

/*Game Deck*/
  SET sql_query_ins_game_deck=REPLACE(sql_query_ins_game_deck,'$player_deck_table',player_deck_table);
  SET sql_query_ins_game_deck=REPLACE(sql_query_ins_game_deck,'$g_id',g_id);
  SET sql_query_ins_game_deck=REPLACE(sql_query_ins_game_deck,'$cards_table',cards_table);
  SET @sql_query_ins_card=REPLACE(sql_query_ins_game_deck,'$game_deck_table',game_deck_table);

  PREPARE stmt FROM @sql_query_ins_card;
  EXECUTE stmt;
  DROP PREPARE stmt;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `init_player_gold`
--

DROP PROCEDURE IF EXISTS `init_player_gold`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `init_units`(g_id INT)
BEGIN
  DECLARE g_mode INT;

  DECLARE p_num INT;
  DECLARE x INT;
  DECLARE y INT;
  DECLARE rule_sql VARCHAR(200) CHARSET utf8;
  DECLARE board_unit_id INT;
  DECLARE unit_id INT;
  DECLARE size INT;

  DECLARE sql_query_get_param VARCHAR(1000) DEFAULT 'INSERT INTO param_val(id,val) SELECT ?,value FROM mode_config_$mode_id WHERE param=? LIMIT 1;';

  DECLARE board_units_table VARCHAR(45);
  DECLARE units_table VARCHAR(45);
  DECLARE board_table VARCHAR(45);

  DECLARE sql_query_get_unit_params VARCHAR(2000) CHARSET utf8 DEFAULT 'INSERT INTO unit_params (id,size) SELECT id,size FROM $units_table WHERE $rule LIMIT 1;';
  DECLARE sql_query_ins_board_unit VARCHAR(2000) DEFAULT 'INSERT INTO $board_units_table(game_id,player_num,unit_id) VALUES ($g_id,?,?);';
  DECLARE sql_query_ins_board VARCHAR(2000) DEFAULT 'INSERT INTO $board_table(game_id,x,y,type,ref) VALUES ($g_id,?,?,''unit'',?);';

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT cfg.player_num,cfg.x,cfg.y,cfg.rule FROM put_start_units_config cfg JOIN players p ON cfg.player_num=p.player_num WHERE p.game_id=g_id AND p.owner<>0 AND cfg.mode_id=g_mode;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SELECT mode_id INTO g_mode FROM games WHERE id=g_id LIMIT 1;

  CREATE TEMPORARY TABLE param_val(id INT PRIMARY KEY,val VARCHAR(45));
  SET @sql_query_get_param=REPLACE(sql_query_get_param,'$mode_id',g_mode);

  PREPARE stmt FROM @sql_query_get_param;
  SET @param_name='board units table';
  SET @param_id=1;
  EXECUTE stmt USING @param_id,@param_name;
  SET @param_name='units table';
  SET @param_id=2;
  EXECUTE stmt USING @param_id,@param_name;
  SET @param_name='board table';
  SET @param_id=3;
  EXECUTE stmt USING @param_id,@param_name;
  DROP PREPARE stmt;
  SELECT val INTO board_units_table FROM param_val WHERE id=1;
  SELECT val INTO units_table FROM param_val WHERE id=2;
  SELECT val INTO board_table FROM param_val WHERE id=3;
  DROP TEMPORARY TABLE param_val;


  SET sql_query_get_unit_params=REPLACE(sql_query_get_unit_params,'$units_table',units_table);
  SET sql_query_ins_board_unit=REPLACE(sql_query_ins_board_unit,'$board_units_table',board_units_table);
  SET @sql_query_ins_board_unit=REPLACE(sql_query_ins_board_unit,'$g_id',g_id);
  SET sql_query_ins_board=REPLACE(sql_query_ins_board,'$board_table',board_table);
  SET @sql_query_ins_board=REPLACE(sql_query_ins_board,'$g_id',g_id);

  PREPARE stmt_ins_board_unit FROM @sql_query_ins_board_unit;
  PREPARE stmt_ins_board FROM @sql_query_ins_board;
  CREATE TEMPORARY TABLE unit_params(id INT,size INT);

  OPEN cur;
  REPEAT
    FETCH cur INTO p_num, x, y, rule_sql;
    IF NOT done THEN
    /*Get unit params*/
      SET @sql_query_get_unit_params=REPLACE(sql_query_get_unit_params,'$rule',rule_sql);
      PREPARE stmt FROM @sql_query_get_unit_params;
      EXECUTE stmt;
      DROP PREPARE stmt;
      SELECT unit_params.id,unit_params.size INTO unit_id,size FROM unit_params;
      TRUNCATE TABLE unit_params;

    /*Insert into board_buildings*/
      SET @p_num=p_num;
      SET @unit_id=unit_id;
      EXECUTE stmt_ins_board_unit USING @p_num,@unit_id;
      SET @board_unit_id=@@last_insert_id;

    /*Insert into board*/
      SET @x=x;
      SET @y=y;
      IF(size=1)THEN
        EXECUTE stmt_ins_board USING @x,@y,@board_unit_id;
      ELSE
        WHILE @x<=x+size-1 DO
          SET @y=y;
          WHILE @y<=y+size-1 DO
            EXECUTE stmt_ins_board USING @x,@y,@board_unit_id;
            SET @y=@y+1;
          END WHILE;
          SET @x=@x+1;
        END WHILE;
      END IF;

    END IF;
  UNTIL done END REPEAT;
  CLOSE cur;

  DROP TEMPORARY TABLE unit_params;
  DROP PREPARE stmt_ins_board_unit;
  DROP PREPARE stmt_ins_board;

/*HARDCODE*/
  INSERT INTO board_units_features(board_unit_id,feature_id) SELECT bu.id,14 FROM board_units bu WHERE bu.game_id=g_id;
/*HARDCODE*/
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `kill_unit`
--

DROP PROCEDURE IF EXISTS `kill_unit`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `kill_unit`(bu_id INT,p_num INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p2_num INT; /*unit owner*/
  DECLARE crd_id INT;
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
      INSERT INTO dead_units(game_id,card_id,x,y) SELECT g_id,crd_id,b.x,b.y FROM board b WHERE b.`type`='unit' AND b.ref=bu_id;
      CALL cmd_add_to_grave (g_id,p_num,crd_id);
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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
-- Definition of procedure `mountains_summon_troll`
--

DROP PROCEDURE IF EXISTS `mountains_summon_troll`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `necromancer_resurrect`(g_id INT,p_num INT,x INT,y INT,dead_card_id INT)
BEGIN
  DECLARE err_code INT;
  DECLARE u2_id INT;
  DECLARE board_unit_id INT;
  DECLARE new_unit_id INT;
  DECLARE resur_cost INT;

  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit1 воскрешает $log_unit2_rod_pad")';

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'necromancer_resurrect'); /*unit can do it*/
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT id FROM dead_units WHERE game_id=g_id AND card_id=dead_card_id LIMIT 1) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=8;/*Card not in grave*/
    ELSE
      IF NOT EXISTS (SELECT id FROM dead_units du WHERE game_id=g_id AND card_id=dead_card_id AND check_one_step_from_unit(g_id,x,y,du.x,du.y)=1 LIMIT 1) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=34;/*grave is out of range*/
      ELSE
        IF EXISTS (SELECT b.id FROM board b JOIN dead_units du ON (b.game_id=du.game_id AND b.x=du.x AND b.y=du.y) WHERE du.game_id=g_id AND du.card_id=dead_card_id LIMIT 1) THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=12;/*place occupied*/
        ELSE
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
            INSERT INTO board_units_features(board_unit_id,feature_id,param) SELECT new_unit_id,ufu.feature_id,ufu.param FROM unit_features_usage ufu WHERE ufu.unit_id=u2_id;
            UPDATE board_units SET moves_left=0 WHERE id=new_unit_id;
/*zombie*/
            INSERT INTO board_units_features(board_unit_id,feature_id,param) SELECT new_unit_id,unit_feature_get_id_by_code('under_control'),board_unit_id;

            INSERT INTO board(game_id,x,y,`type`,ref) SELECT g_id,du.x,du.y,'unit',new_unit_id FROM dead_units du WHERE du.game_id=g_id AND du.card_id=dead_card_id;
            DELETE FROM dead_units WHERE game_id=g_id AND card_id=dead_card_id;

            CALL cmd_add_unit(g_id,p_num,new_unit_id);
            CALL cmd_remove_from_grave(g_id,p_num,dead_card_id);
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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
          INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

          IF (unit_feature_check(sacr_bu_id,'magic_immunity')=1) THEN /*if magic-resistant*/
            CALL cmd_magic_resistance_log(g_id,p_num,board_unit_id);
          ELSE

/*TODO shields? */

            SELECT bu.health INTO sacr_health FROM board_units bu WHERE bu.id=sacr_bu_id;

            CALL unit_feature_set(sacr_bu_id,'goes_to_deck_on_death',null);
            CALL kill_unit(sacr_bu_id,p_num);

            CALL magical_damage(g_id,p_num,x_target,y_target,sacr_health+damage_bonus);

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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `player_end_turn`(g_id INT,p_num INT)
BEGIN
  DECLARE cmd_independent_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_independent_message($p_num,"Завершил ход")';
  DECLARE moved_units INT;
  DECLARE moves_to_auto_repair INT DEFAULT 2;
  DECLARE moves_ended INT DEFAULT 2;
  DECLARE end_turn_feature_id INT;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;/*Not your turn*/
  ELSE
    CALL user_action_begin();

    SELECT units_moves_flag INTO moved_units FROM active_players WHERE game_id=g_id LIMIT 1;

    IF moved_units=1 THEN
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `player_move_unit`(g_id INT,p_num INT,x INT,y INT, x2 INT, y2 INT)
BEGIN
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
                      SELECT a.x,a.y INTO taran_x,taran_y FROM allcoords a WHERE a.x BETWEEN x0 AND x0+size-1 AND a.y BETWEEN y0 AND y0+size-1 AND a.x BETWEEN x2-1 AND x2+size AND a.y BETWEEN y2-1 AND y2+size AND NOT (a.x BETWEEN x2 AND x2+size-1 AND a.y BETWEEN y2 AND y2+size-1) ORDER BY ((taran_prev_x-a.x)*(taran_prev_x-a.x)+(taran_prev_y-a.y)*(taran_prev_y-a.y)) LIMIT 1;
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `player_resurrect`(g_id INT,p_num INT,dead_card_id INT)
BEGIN
  DECLARE resurrection_cost_coefficient INT;
  DECLARE resur_cost INT;
  DECLARE x_appear,y_appear,x_dir,y_dir INT;
  DECLARE new_unit_id INT;
  DECLARE size INT;
  DECLARE u_id INT;

  DECLARE cmd_independent_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_independent_message($p_num,"Воскресил $log_unit_rod_pad")';

  SELECT `value` INTO resurrection_cost_coefficient FROM mode_config_1 WHERE param='resurrection cost coefficient';

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;/*Not your turn*/
  ELSE
    IF (SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id LIMIT 1)<>0 THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=28;/*polza/vred in progress*/
    ELSE
      IF (SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=1 THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=7;/*Already moved units*/
      ELSE
        IF NOT EXISTS(SELECT id FROM dead_units WHERE game_id=g_id AND card_id=dead_card_id LIMIT 1) THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=8;/*Card not in grave*/
        ELSE
          SELECT cost*resurrection_cost_coefficient INTO resur_cost FROM cards WHERE id=dead_card_id LIMIT 1;
          IF (SELECT gold FROM players WHERE game_id=g_id AND player_num=p_num LIMIT 1)<resur_cost THEN
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=2;/*Not enough gold*/
          ELSE
            SELECT x,y,direction_into_board_x,direction_into_board_y INTO x_appear,y_appear,x_dir,y_dir FROM appear_points WHERE player_num=p_num;
            SELECT u.id,u.size INTO u_id,size FROM cards c JOIN units u ON c.ref=u.id WHERE c.id=dead_card_id LIMIT 1;
            IF EXISTS(SELECT id FROM board WHERE game_id=g_id AND x BETWEEN LEAST(x_appear,x_appear+x_dir*(size-1)) AND GREATEST(x_appear,x_appear+x_dir*(size-1)) AND y BETWEEN LEAST(y_appear,y_appear+y_dir*(size-1)) AND GREATEST(y_appear,y_appear+y_dir*(size-1)) LIMIT 1) THEN
              SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=9;/*Appear point occupied*/
            ELSE
              CALL user_action_begin();

              UPDATE players SET gold=gold-resur_cost WHERE game_id=g_id AND player_num=p_num;
              CALL cmd_player_set_gold(g_id,p_num);

              CALL resurrect(g_id,p_num,dead_card_id);
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `play_card_actions`(g_id INT,p_num INT,crd_id INT)
BEGIN
/*Set gold, remove card, update log*/
  DECLARE card_cost INT;
  DECLARE card_type VARCHAR(5);
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_container($p_num,"Сыграл карту <b class=\'logCard\'>$card_name</b>")';

/*set gold*/
  SELECT cost,`type` INTO card_cost,card_type FROM cards WHERE id=crd_id LIMIT 1;
  IF card_cost>0 THEN
    UPDATE players SET gold=gold-card_cost WHERE game_id=g_id AND player_num=p_num;
    CALL cmd_player_set_gold(g_id,p_num);
  END IF;
/*remove card*/
  DELETE FROM player_deck WHERE game_id=g_id AND player_num=p_num AND card_id=crd_id;
  CALL cmd_remove_card(g_id,p_num,crd_id);
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `put_building`(g_id INT,p_num INT,crd_id INT,x INT,y INT,rotation INT,flip INT)
BEGIN
  DECLARE err_code INT;
  DECLARE x_len,y_len INT;
  DECLARE x2,y2 INT; /*For determining whether whole building is in player's zone, if (x,y) and (x2,y2) are*/
  DECLARE new_building_id INT;
  DECLARE card_cost INT;
  DECLARE cmd VARCHAR(1000) CHARSET utf8;

  SET err_code=check_play_card(g_id,p_num,crd_id,'put_building');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
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

        CALL play_card_actions(g_id,p_num,crd_id); /*Set gold, remove card, update log*/

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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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
  truncate table dead_units;
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `resurrect`(g_id INT,p_num INT,dead_card_id INT)
BEGIN
  DECLARE new_unit_id INT;
  DECLARE x_appear,y_appear,x_dir,y_dir INT;
  DECLARE size INT;
  DECLARE u_id INT;

  SELECT x,y,direction_into_board_x,direction_into_board_y INTO x_appear,y_appear,x_dir,y_dir FROM appear_points WHERE player_num=p_num;
  SELECT u.id,u.size INTO u_id,size FROM cards c JOIN units u ON c.ref=u.id WHERE c.id=dead_card_id LIMIT 1;

            INSERT INTO board_units(game_id,player_num,card_id) VALUES (g_id,p_num,dead_card_id);
            SET new_unit_id=@@last_insert_id;
            INSERT INTO board_units_features(board_unit_id,feature_id,param) SELECT new_unit_id,ufu.feature_id,ufu.param FROM unit_features_usage ufu WHERE ufu.unit_id=u_id;

            INSERT INTO board(game_id,x,y,`type`,ref) SELECT g_id,a.x,a.y,'unit',new_unit_id FROM allcoords a WHERE a.x BETWEEN LEAST(x_appear,x_appear+x_dir*(size-1)) AND GREATEST(x_appear,x_appear+x_dir*(size-1)) AND a.y BETWEEN LEAST(y_appear,y_appear+y_dir*(size-1)) AND GREATEST(y_appear,y_appear+y_dir*(size-1));
            DELETE FROM dead_units WHERE game_id=g_id AND card_id=dead_card_id;

            CALL cmd_add_unit(g_id,p_num,new_unit_id);
            CALL cmd_remove_from_grave(g_id,p_num,dead_card_id);

            INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'resurrect_unit',u_id);
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `send_money`
--

DROP PROCEDURE IF EXISTS `send_money`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sink_unit`(bu_id INT,p_num INT)
BEGIN
  DECLARE g_id INT;
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit тонет в воде")';

  SELECT game_id INTO g_id FROM board_units WHERE id=bu_id LIMIT 1;

/*log*/
  SET cmd_log=REPLACE(cmd_log,'$log_unit',log_unit(bu_id));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

  CALL unit_feature_set(sacr_bu_id,'goes_to_deck_on_death',null);
  CALL kill_unit(bu_id,p_num);
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `start_moving_units`
--

DROP PROCEDURE IF EXISTS `start_moving_units`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='' */ $$
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
    INSERT INTO board_units_features(board_unit_id,feature_id,param) SELECT new_unit_id,ufu.feature_id,ufu.param FROM unit_features_usage ufu WHERE ufu.unit_id=cr_unit_id;
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='' */ $$
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

  WHILE (cr_count>0 AND EXISTS(SELECT DISTINCT a.x,a.y FROM allcoords a, board b WHERE b.game_id=g_id AND b.`type`<>'unit' AND b.ref=board_building_id AND (ABS(b.x-a.x)<=1 AND ABS(b.y-a.y)<=1) AND NOT EXISTS(SELECT b2.id FROM board b2 WHERE b2.x=a.x AND b2.y=a.y) LIMIT 1)) DO
    SELECT DISTINCT a.x,a.y INTO x,y FROM allcoords a, board b WHERE b.game_id=g_id AND b.`type`<>'unit' AND b.ref=board_building_id AND (ABS(b.x-a.x)<=1 AND ABS(b.y-a.y)<=1) AND NOT EXISTS(SELECT b2.id FROM board b2 WHERE b2.x=a.x AND b2.y=a.y) ORDER BY RAND() LIMIT 1;
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='' */ $$
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

  IF EXISTS(SELECT DISTINCT a.x,a.y FROM allcoords a, board b WHERE b.game_id=g_id AND b.`type`<>'unit' AND b.ref=board_building_id AND (ABS(b.x-a.x)<=1 AND ABS(b.y-a.y)<=1) AND NOT EXISTS(SELECT b2.id FROM board b2 WHERE b2.x=a.x AND b2.y=a.y) LIMIT 1) THEN
    SELECT DISTINCT a.x,a.y INTO x,y FROM allcoords a, board b WHERE b.game_id=g_id AND b.`type`<>'unit' AND b.ref=board_building_id AND (ABS(b.x-a.x)<=1 AND ABS(b.y-a.y)<=1) AND NOT EXISTS(SELECT b2.id FROM board b2 WHERE b2.x=a.x AND b2.y=a.y) ORDER BY RAND() LIMIT 1;
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `summon_unit`(g_id INT,p_num INT,crd_id INT)
BEGIN
  DECLARE err_code INT;
  DECLARE x_appear,y_appear,x_dir,y_dir INT;
  DECLARE size INT;
  DECLARE new_unit_id INT;
  DECLARE u_id INT;

  SET err_code=check_play_card(g_id,p_num,crd_id,'summon_unit');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    SELECT x,y,direction_into_board_x,direction_into_board_y INTO x_appear,y_appear,x_dir,y_dir FROM appear_points WHERE player_num=p_num;
    SELECT u.size,u.id INTO size,u_id FROM cards c JOIN units u ON c.ref=u.id WHERE c.id=crd_id LIMIT 1;
    IF EXISTS(SELECT id FROM board WHERE game_id=g_id AND x BETWEEN LEAST(x_appear,x_appear+x_dir*(size-1)) AND GREATEST(x_appear,x_appear+x_dir*(size-1)) AND y BETWEEN LEAST(y_appear,y_appear+y_dir*(size-1)) AND GREATEST(y_appear,y_appear+y_dir*(size-1)) LIMIT 1) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=9;/*Appear point occupied*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,crd_id); /*Set gold, remove card, update log*/

      INSERT INTO board_units(game_id,player_num,card_id) VALUES (g_id,p_num,crd_id);
      SET new_unit_id=@@last_insert_id;
      INSERT INTO board_units_features(board_unit_id,feature_id,param) SELECT new_unit_id,ufu.feature_id,ufu.param FROM unit_features_usage ufu WHERE ufu.unit_id=u_id;

      INSERT INTO board(game_id,x,y,`type`,ref) SELECT g_id,a.x,a.y,'unit',new_unit_id FROM allcoords a WHERE a.x BETWEEN LEAST(x_appear,x_appear+x_dir*(size-1)) AND GREATEST(x_appear,x_appear+x_dir*(size-1)) AND a.y BETWEEN LEAST(y_appear,y_appear+y_dir*(size-1)) AND GREATEST(y_appear,y_appear+y_dir*(size-1));

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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `take_subsidy`(g_id INT,p_num INT)
BEGIN
  DECLARE subsidy_amt INT;
  DECLARE subsidy_damage INT;
  DECLARE board_castle_id INT;
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_independent_message($p_num,"Взял субсидию")';

  SELECT `value` INTO subsidy_amt FROM mode_config_1 WHERE param='subsidy amount';
  SELECT `value` INTO subsidy_damage FROM mode_config_1 WHERE param='subsidy castle damage';

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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `units_from_zone`(g_id INT,zone INT)
BEGIN
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

    OPEN cur;
    REPEAT
      FETCH cur INTO board_unit_id,u_x,u_y,size;
      IF NOT done THEN
        IF size=1 THEN /*ordinary units*/
          /*define new coords*/
          SELECT a.x,a.y INTO new_x,new_y FROM allcoords a
          LEFT JOIN board b ON (a.x=b.x AND a.y=b.y AND b.game_id=g_id)
          WHERE quart(a.x,a.y)<>zone AND b.id IS NULL
          ORDER BY ((u_x-a.x)*(u_x-a.x)+(u_y-a.y)*(u_y-a.y)) LIMIT 1;

          CALL move_unit(board_unit_id,new_x,new_y);
        ELSE /*dragons*/
          /*define new coords*/
          SELECT a.x,a.y INTO new_x,new_y FROM allcoords a
          WHERE quart(a.x,a.y)<>zone
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `units_to_zone`(g_id INT,zone INT)
BEGIN
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

    OPEN cur;
    REPEAT
      FETCH cur INTO board_unit_id,u_x,u_y,size;
      IF NOT done THEN
        IF size=1 THEN /*ordinary units*/
          /*define new coords*/
          SELECT a.x,a.y INTO new_x,new_y FROM allcoords a
          LEFT JOIN board b ON (a.x=b.x AND a.y=b.y AND b.game_id=g_id)
          WHERE quart(a.x,a.y)=zone AND b.id IS NULL
          ORDER BY ((u_x-a.x)*(u_x-a.x)+(u_y-a.y)*(u_y-a.y)) LIMIT 1;

          CALL move_unit(board_unit_id,new_x,new_y);
        ELSE /*dragons*/
          /*define new coords*/
          SELECT a.x,a.y INTO new_x,new_y FROM allcoords a
          WHERE quart(a.x,a.y)=zone
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `unit_push`(board_unit_id_1 INT, board_unit_id_2 INT)
BEGIN
/*unit 1 pushes unit 2*/
  DECLARE g_id INT;
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
        WHERE a.x BETWEEN x_min_2+push_x AND x_max_2+push_x
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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
  FROM command c JOIN players p ON (c.game_id=p.game_id AND c.player_num=p.player_num);

  DROP TEMPORARY TABLE `lords`.`command`;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `vampire_resurrect_by_card`
--

DROP PROCEDURE IF EXISTS `vampire_resurrect_by_card`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `vampire_resurrect_by_card`(vamp_board_id INT, dead_card_id INT)
BEGIN
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

    SELECT c.ref INTO u_id FROM cards c WHERE c.id=dead_card_id LIMIT 1;

    SET vamp_name=REPLACE(vamp_name,'$u_name',(SELECT name FROM units WHERE id=u_id LIMIT 1));

    INSERT INTO players(game_id,player_num,name,gold,owner,team) VALUES(g_id,new_player,vamp_name,0,vamp_owner,team);

    INSERT INTO board_units(game_id,player_num,card_id) VALUES (g_id,new_player,dead_card_id);
    SET new_unit_id=@@last_insert_id;
    INSERT INTO board_units_features(board_unit_id,feature_id,param) SELECT new_unit_id,ufu.feature_id,ufu.param FROM unit_features_usage ufu WHERE ufu.unit_id=u_id;

    INSERT INTO board(game_id,x,y,`type`,ref) SELECT g_id,du.x,du.y,'unit',new_unit_id FROM dead_units du WHERE du.game_id=g_id AND du.card_id=dead_card_id;
    DELETE FROM dead_units WHERE game_id=g_id AND card_id=dead_card_id;

/*vamp*/
    CALL unit_feature_set(new_unit_id,'vamp',NULL);

    CALL cmd_add_player(g_id,new_player);
    CALL cmd_add_unit(g_id,new_player,new_unit_id);
    CALL cmd_remove_from_grave(g_id,p_num,dead_card_id);

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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `vampire_resurrect_by_u_id`(vamp_board_id INT,u_id INT,x INT,y INT)
BEGIN
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

    SELECT CASE WHEN MAX(p.player_num)<10 THEN 10 ELSE MAX(p.player_num)+1 END INTO new_player FROM players p WHERE p.game_id=g_id;

    SET vamp_name=REPLACE(vamp_name,'$u_name',(SELECT name FROM units WHERE id=u_id LIMIT 1));

    INSERT INTO players(game_id,player_num,name,gold,owner,team) VALUES(g_id,new_player,vamp_name,0,vamp_owner,team);

    INSERT INTO board_units(game_id,player_num,unit_id) VALUES(g_id,new_player,u_id);
    SET new_unit_id=@@last_insert_id;
    INSERT INTO board_units_features(board_unit_id,feature_id,param) SELECT new_unit_id,ufu.feature_id,ufu.param FROM unit_features_usage ufu WHERE ufu.unit_id=u_id;

    SELECT u.size INTO size FROM units u WHERE u.id=u_id LIMIT 1;

    INSERT INTO board(game_id,x,y,`type`,ref) SELECT g_id,a.x,a.y,'unit',new_unit_id FROM allcoords a WHERE a.x BETWEEN x AND x+size-1 AND a.y BETWEEN y AND y+size-1;

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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `vred_player_takes_card_from_everyone`(g_id INT,p_num INT)
BEGIN
  DECLARE p2_num INT; /*card owner*/
  DECLARE random_card INT;
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
        SELECT card_id INTO random_card FROM player_deck p WHERE p.game_id=g_id AND p.player_num=p2_num ORDER BY RAND() LIMIT 1;
        UPDATE player_deck SET player_num=p_num WHERE game_id=g_id AND player_num=p2_num AND card_id=random_card;

        CALL cmd_add_card(g_id,p_num,random_card);
        CALL cmd_remove_card(g_id,p2_num,random_card);

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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
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
-- Create schema lords_site
--

CREATE DATABASE IF NOT EXISTS lords_site;
USE lords_site;

--
-- Definition of procedure `arena_enter`
--

DROP PROCEDURE IF EXISTS `arena_enter`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `arena_enter`(user_id INT)
BEGIN
  DECLARE arena_game_type_id INT DEFAULT 1; /*NOTE hardcode because this id is unlikely to change*/
  DECLARE player_online_status_id INT DEFAULT 1; /*NOTE hardcode because this id is unlikely to change*/
  DECLARE game_type_id INT;

  SELECT u.game_type_id INTO game_type_id FROM users u WHERE u.id=user_id LIMIT 1;
  IF game_type_id IS NULL THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=4;/*Incorrect user_id*/
  ELSE
    IF game_type_id=arena_game_type_id THEN
      /*if user is already in arena do nothing*/
      SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;
    ELSE
      UPDATE users SET game_type_id=arena_game_type_id WHERE id=user_id;
      INSERT INTO arena_users(user_id,status_id) VALUES (user_id,player_online_status_id);

      SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;

      SELECT 'nick' AS `name`, user_nick(user_id) as `value` FROM DUAL;
    END IF;
  END IF;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `arena_exit`
--

DROP PROCEDURE IF EXISTS `arena_exit`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `arena_exit`(user_id INT)
BEGIN
  DECLARE g_id INT;
  DECLARE g_name VARCHAR(200) CHARSET utf8;
  DECLARE g_status INT;
  DECLARE playing_game_status INT DEFAULT 2; /*NOTE hardcode because this id is unlikely to change*/
  DECLARE chats_ids VARCHAR(1000);
  DECLARE was_owner INT;
  DECLARE was_spectator INT;

  IF NOT EXISTS(SELECT id FROM arena_users au WHERE au.user_id=user_id LIMIT 1) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=8;/*You are not in arena*/
  ELSE
/*if player is in a started game - don't let him out*/
    SELECT agp.game_id,ag.title,ag.status_id,CASE WHEN ag.owner_id=user_id THEN 1 ELSE 0 END,agp.spectator_flag
      INTO g_id,g_name,g_status,was_owner,was_spectator
      FROM arena_game_players agp
      JOIN arena_games ag ON (agp.game_id=ag.id)
      WHERE agp.user_id=user_id LIMIT 1;
    IF(g_status=playing_game_status) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, CONCAT('"',REPLACE(g_name,'\"','\\\"'),'"') as `error_params` FROM error_dictionary ed WHERE id=31;/*Can't exit arena being in game*/
    ELSE
/*OK*/
      UPDATE users SET game_type_id=0 WHERE id=user_id;
      DELETE au FROM arena_users au WHERE au.user_id=user_id;

      CREATE TEMPORARY TABLE variables_resultset (name VARCHAR(50), `value` VARCHAR(1000));

/*select user's chats*/
      SELECT GROUP_CONCAT(CAST(cu.chat_id AS CHAR(10)))
      INTO chats_ids
      FROM chat_users cu
      WHERE cu.user_id=user_id
      GROUP BY cu.user_id;

      IF(chats_ids IS NOT NULL) THEN
/*delete chat users*/
        INSERT INTO variables_resultset(name,`value`) VALUES('chats_ids',chats_ids);
        DELETE cu FROM chat_users cu WHERE cu.user_id=user_id;
        DELETE c FROM chats c LEFT JOIN chat_users cu ON (c.id=cu.chat_id) WHERE cu.id IS NULL;
      END IF;

      IF((g_id IS NOT NULL)AND(was_owner = 1))THEN
/*delete game*/
        CALL arena_game_delete_inner(g_id);

        INSERT INTO variables_resultset(name,`value`) VALUES('game_id',CAST(g_id AS CHAR(10)));
        INSERT INTO variables_resultset(name,`value`) VALUES('was_owner',CAST(was_owner AS CHAR(10)));
      END IF;

      IF((g_id IS NOT NULL)AND(was_owner = 0))THEN
/*delete player*/
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

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `arena_game_create`
--

DROP PROCEDURE IF EXISTS `arena_game_create`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `arena_game_create`(user_id INT, title VARCHAR(45) CHARSET utf8, pass VARCHAR(45) CHARSET utf8, time_restriction_seconds INT, mode_id INT)
BEGIN
  DECLARE arena_game_type_id INT DEFAULT 1; /*NOTE hardcode because this id is unlikely to change*/
  DECLARE created_game_status INT DEFAULT 1; /*NOTE hardcode because this id is unlikely to change*/
  DECLARE game_id INT;

  IF NOT EXISTS(SELECT au.id FROM arena_users au WHERE au.user_id=user_id LIMIT 1)THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=8;/*You're not in arena*/
  ELSE
    IF (time_restriction_seconds<0) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=9;/*incorrect time restriction*/
    ELSE
      IF EXISTS(SELECT 1 FROM arena_games ag WHERE ag.owner_id=user_id AND ag.status_id=created_game_status LIMIT 1) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=30;/*user tries to create second game*/
      ELSE
        IF NOT EXISTS (SELECT m.id FROM lords.modes m WHERE m.id=mode_id LIMIT 1) THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=9;/*incorrect mode*/
        ELSE
/*OK*/
          INSERT INTO lords.games(title,pass,owner_id,time_restriction,status_id,mode_id,type_id)VALUES(title,MD5(pass),user_id,time_restriction_seconds,created_game_status,mode_id,arena_game_type_id);
          SET game_id=@@last_insert_id;

          INSERT INTO arena_games(id,title,pass,owner_id,time_restriction,status_id,mode_id)VALUES(game_id,title,MD5(pass),user_id,time_restriction_seconds,created_game_status,mode_id);

/*default features*/
          INSERT INTO arena_games_features_usage(game_id,feature_id,`value`,feature_type)
          SELECT game_id,id,default_param,feature_type FROM lords.games_features;

          SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;

          SELECT 'game_id' AS `name`, game_id as `value` FROM DUAL;

        END IF;
      END IF;
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `arena_game_delete_inner`
--

DROP PROCEDURE IF EXISTS `arena_game_delete_inner`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `arena_game_delete_inner`(g_id INT)
BEGIN
  DECLARE player_online_status_id INT DEFAULT 1; /*NOTE hardcode because this id is unlikely to change*/
  DECLARE player_ingame_status_id INT DEFAULT 2; /*NOTE hardcode because this id is unlikely to change*/

        UPDATE arena_users au, arena_game_players agp SET au.status_id=player_online_status_id
          WHERE au.user_id=agp.user_id AND agp.game_id=g_id AND au.status_id=player_ingame_status_id;

        DELETE FROM arena_games WHERE id=g_id;
        DELETE FROM lords.games WHERE id=g_id;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `arena_game_enter`
--

DROP PROCEDURE IF EXISTS `arena_game_enter`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `arena_game_enter`(user_id INT,game_id INT, pass VARCHAR(45) CHARSET utf8)
BEGIN
  DECLARE created_game_status INT DEFAULT 1; /*NOTE hardcode because this id is unlikely to change*/
  DECLARE player_ingame_status_id INT DEFAULT 2; /*NOTE hardcode because this id is unlikely to change*/
  DECLARE game_status_id INT;
  DECLARE md5_game_pass VARCHAR(45) CHARSET utf8;

  SELECT ag.status_id, ag.pass INTO game_status_id, md5_game_pass FROM arena_games ag WHERE ag.id=game_id LIMIT 1;

  IF NOT EXISTS(SELECT au.id FROM arena_users au WHERE au.user_id=user_id LIMIT 1)THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=8;/*You're not in arena*/
  ELSE
    IF EXISTS(SELECT p.id FROM arena_game_players p WHERE p.user_id=user_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Already playing*/
    ELSE
      IF game_status_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=16;/*Incorrect game*/
      ELSE
        IF IFNULL(md5_game_pass,'')<>IFNULL(MD5(pass),'') THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=13;/*Incorrect password*/
        ELSE
          IF (game_status_id<>created_game_status) THEN
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=17;/*Can't enter started game*/
          ELSE
/*OK*/
            INSERT INTO arena_game_players(name,user_id,game_id,spectator_flag)VALUES(user_nick(user_id),user_id,game_id,1); /*add as spectator*/

            UPDATE arena_users au SET au.status_id=player_ingame_status_id WHERE au.user_id=user_id;

            SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;

          END IF;
        END IF;
      END IF;
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `arena_game_feature_set`
--

DROP PROCEDURE IF EXISTS `arena_game_feature_set`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `arena_game_feature_set`(user_id INT, game_id INT, feature_id INT, param INT)
BEGIN
  DECLARE created_game_status INT DEFAULT 1; /*NOTE hardcode because this id is unlikely to change*/
  DECLARE owner_id INT;
  DECLARE status_id INT;
  DECLARE feature_type ENUM('bool','int');

  DECLARE new_player_count INT;
  DECLARE new_spectator_count INT;

  SELECT ag.owner_id, ag.status_id INTO owner_id,status_id FROM arena_games ag WHERE ag.id=game_id LIMIT 1;

  IF (owner_id IS NULL) OR (owner_id<>user_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=11;/*only owner can add feature*/
  ELSE
    IF status_id<>created_game_status THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=15;/*only can add/remove features before game start*/
    ELSE
      SELECT f.feature_type INTO feature_type FROM arena_games_features_usage f WHERE f.game_id=game_id AND f.feature_id=feature_id;
      IF (feature_type IS NULL) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=12;/*invalid feature*/
      ELSE
        IF (feature_type='bool' AND NOT param IN (0,1)) THEN
          SELECT 0 AS `success`, ed.id as `error_code`, CONCAT('"',feature_id,'"') as `error_params` FROM error_dictionary ed WHERE id=33;/*Incorrect feature value*/
        ELSE

          /*HARDCODED FEATURES*/
          IF feature_id=lords.game_feature_get_id_by_code('number_of_teams') THEN
/*if new number of teams is less then previous and there are players in removed teams - move them to spectators*/
            UPDATE arena_game_players agp SET spectator_flag=1 WHERE agp.game_id=game_id AND agp.team>=param;

            SELECT IFNULL(COUNT(*)-SUM(spectator_flag),0),IFNULL(SUM(spectator_flag),0) INTO new_player_count,new_spectator_count FROM arena_game_players ap WHERE ap.game_id=game_id;
          END IF;
          /*HARDCODED FEATURES*/

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
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `arena_game_player_remove`
--

DROP PROCEDURE IF EXISTS `arena_game_player_remove`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `arena_game_player_remove`(user_id INT, game_id INT, user2_id INT)
BEGIN
  DECLARE created_game_status INT DEFAULT 1; /*NOTE hardcode because this id is unlikely to change*/
  DECLARE owner_id INT;
  DECLARE game_status_id INT;
  DECLARE player_online_status_id INT DEFAULT 1; /*NOTE hardcode because this id is unlikely to change*/
  DECLARE player_ingame_status_id INT DEFAULT 2; /*NOTE hardcode because this id is unlikely to change*/
  DECLARE was_spectator INT;

  SELECT ag.owner_id, ag.status_id INTO owner_id,game_status_id FROM arena_games ag WHERE ag.id=game_id LIMIT 1;

  IF (SELECT ap.game_id FROM arena_game_players ap WHERE ap.user_id=user2_id)<>game_id THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=21;/*player is not in this game*/
  ELSE
    IF (user_id<>user2_id) AND (user_id<>owner_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=22;/*only owner and player himself can delete player*/
    ELSE
      IF game_status_id<>created_game_status THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=23;/*can't delete player in started game*/
      ELSE
/*OK*/
        IF(user2_id=owner_id)THEN
/*owner left - delete game*/
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

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `arena_game_player_spectator_move`
--

DROP PROCEDURE IF EXISTS `arena_game_player_spectator_move`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `arena_game_player_spectator_move`(user_id INT,game_id INT,user2_id INT)
BEGIN
  DECLARE created_game_status INT DEFAULT 1; /*NOTE hardcode because this id is unlikely to change*/
  DECLARE owner_id INT;
  DECLARE status_id INT;

  SELECT ag.owner_id, ag.status_id INTO owner_id,status_id FROM arena_games ag WHERE ag.id=game_id LIMIT 1;

  IF owner_id<>user_id THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=19;/*only owner can change teams*/
  ELSE
    IF status_id<>created_game_status THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=20;/*only can change teams before game start*/
    ELSE
      IF NOT EXISTS(SELECT agp.id FROM arena_game_players agp WHERE agp.user_id=user2_id AND agp.game_id=game_id LIMIT 1) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=21;/*player is not in this game*/
      ELSE
/*OK*/
        UPDATE arena_game_players agp SET agp.spectator_flag=1 WHERE agp.user_id=user2_id;
          
        SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;

      END IF;
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `arena_game_player_team_set`
--

DROP PROCEDURE IF EXISTS `arena_game_player_team_set`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `arena_game_player_team_set`(user_id INT,game_id INT,user2_id INT,team INT)
BEGIN
  DECLARE created_game_status INT DEFAULT 1; /*NOTE hardcode because this id is unlikely to change*/
  DECLARE number_of_teams_feature_id INT DEFAULT 3; /*NOTE hardcode because this id is unlikely to change*/
  DECLARE owner_id INT;
  DECLARE status_id INT;
  DECLARE was_spectator INT;

  SELECT ag.owner_id, ag.status_id INTO owner_id,status_id FROM arena_games ag WHERE ag.id=game_id LIMIT 1;

  IF owner_id<>user_id THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=19;/*only owner can change teams*/
  ELSE
    IF status_id<>created_game_status THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=20;/*only can change teams before game start*/
    ELSE
      SELECT agp.spectator_flag INTO was_spectator FROM arena_game_players agp WHERE agp.user_id=user2_id AND agp.game_id=game_id LIMIT 1;
      IF (was_spectator IS NULL) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=21;/*player is not in this game*/
      ELSE
        IF (team>=(SELECT f.value FROM arena_games_features_usage f WHERE f.game_id=game_id AND f.feature_id=number_of_teams_feature_id LIMIT 1))THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=25;/*incorrect team*/
        ELSE
/*OK*/
          UPDATE arena_game_players agp SET agp.spectator_flag=0,agp.team=team WHERE agp.user_id=user2_id;
          
          SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;

          SELECT 'was_spectator' AS `name`, was_spectator as `value` FROM DUAL;
          
        END IF;
      END IF;
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `arena_game_spectator_enter`
--

DROP PROCEDURE IF EXISTS `arena_game_spectator_enter`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `arena_game_spectator_enter`(user_id INT,game_id INT, pass VARCHAR(45) CHARSET utf8)
BEGIN
  DECLARE created_game_status INT DEFAULT 1; /*NOTE hardcode because this id is unlikely to change*/
  DECLARE player_playing_status_id INT DEFAULT 3; /*NOTE hardcode because this id is unlikely to change*/
  DECLARE game_status_id INT;
  DECLARE md5_game_pass VARCHAR(45) CHARSET utf8;
  DECLARE p_num INT;
  DECLARE p_name VARCHAR(200) CHARSET utf8;

  SELECT ag.status_id, ag.pass INTO game_status_id, md5_game_pass FROM arena_games ag WHERE ag.id=game_id LIMIT 1;

  IF NOT EXISTS(SELECT au.id FROM arena_users au WHERE au.user_id=user_id LIMIT 1)THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=8;/*You're not in arena*/
  ELSE
    IF EXISTS(SELECT p.id FROM arena_game_players p WHERE p.user_id=user_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Already playing*/
    ELSE
      IF game_status_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=16;/*Incorrect game*/
      ELSE
        IF IFNULL(md5_game_pass,'')<>IFNULL(MD5(pass),'') THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=13;/*Incorrect password*/
        ELSE
          IF (game_status_id=created_game_status) THEN
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=29;/*Game not started yet*/
          ELSE
/*OK*/
            INSERT INTO arena_game_players(name,user_id,game_id,spectator_flag)VALUES(user_nick(user_id),user_id,game_id,1); /*add as spectator*/

            UPDATE arena_users au SET au.status_id=player_playing_status_id WHERE au.user_id=user_id;

            SET p_num=100+user_id;
            SET p_name=user_nick(user_id);

            INSERT INTO lords.players(user_id,game_id,player_num,name,owner,team)
            VALUES(user_id,game_id,p_num,p_name,0,0);

            SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;

            SELECT 'player_num' AS `name`, p_num as `value` FROM DUAL
            UNION
            SELECT 'player_name' AS `name`, p_name as `value` FROM DUAL;

          END IF;
        END IF;
      END IF;
    END IF;
  END IF;



END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `arena_game_start`
--

DROP PROCEDURE IF EXISTS `arena_game_start`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `arena_game_start`(user_id INT, game_id INT)
BEGIN
  DECLARE created_game_status INT DEFAULT 1; /*NOTE hardcode because this id is unlikely to change*/
  DECLARE playing_game_status INT DEFAULT 2; /*NOTE hardcode because this id is unlikely to change*/
  DECLARE player_ingame_status_id INT DEFAULT 2; /*NOTE hardcode because this id is unlikely to change*/
  DECLARE player_playing_status_id INT DEFAULT 3; /*NOTE hardcode because this id is unlikely to change*/
  DECLARE arena_game_type_id INT DEFAULT 1; /*NOTE hardcode because this id is unlikely to change*/
  DECLARE owner_id INT;
  DECLARE status_id INT;
  DECLARE player_count INT;
  DECLARE mode_id INT;

  SELECT ag.owner_id, ag.status_id, ag.mode_id INTO owner_id,status_id,mode_id FROM arena_games ag WHERE ag.id=game_id LIMIT 1;

  IF (owner_id IS NULL) OR (owner_id<>user_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=26;/*only owner can start game*/
  ELSE
    IF status_id<>created_game_status THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=27;/*game is already going*/
    ELSE
      SELECT COUNT(*) INTO player_count FROM arena_game_players agp WHERE agp.game_id=game_id AND spectator_flag=0;
      IF NOT EXISTS(SELECT lm.id FROM lords.modes lm WHERE lm.id=mode_id AND player_count BETWEEN lm.min_players AND lm.max_players LIMIT 1) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=28;/*incorrect number of players*/
      ELSE
/*OK*/
        UPDATE arena_games ag SET ag.status_id=playing_game_status WHERE ag.id=game_id;

        UPDATE arena_users au, arena_game_players agp SET au.status_id=player_playing_status_id
          WHERE au.user_id=agp.user_id AND agp.game_id=game_id AND au.status_id=player_ingame_status_id;

        INSERT INTO lords.players(user_id,game_id,player_num,name,owner,team)
          SELECT
            agp.user_id,
            game_id,
            CASE WHEN agp.spectator_flag=0 THEN 0 ELSE 100+agp.user_id END,
            agp.name,
            CASE WHEN agp.spectator_flag=1 THEN 0 ELSE 1 END,
            IFNULL(agp.team,0)
          FROM arena_game_players agp WHERE agp.game_id=game_id;

        INSERT INTO lords.games_features_usage(game_id,feature_id,param)
          SELECT f.game_id,f.feature_id,f.`value` FROM arena_games_features_usage f WHERE f.game_id=game_id;

        CALL lords.initialization(game_id);

        SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;

      END IF;
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `chat_create_private`
--

DROP PROCEDURE IF EXISTS `chat_create_private`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `chat_create_private`(user_id INT,user2_id INT)
BEGIN
  DECLARE chat_id INT;

  IF NOT EXISTS(SELECT 1 FROM users u WHERE u.id=user_id) OR NOT EXISTS(SELECT 1 FROM users u WHERE u.id=user2_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=4;/*Incorrect user_id*/
  ELSE
    IF(user_id=user2_id)THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=34;/*Can't open chat with myself*/
    ELSE
      INSERT INTO chats() VALUES();
      SET chat_id=@@last_insert_id;

      INSERT INTO chat_users(chat_id,user_id) VALUES(chat_id,user_id);
      INSERT INTO chat_users(chat_id,user_id) VALUES(chat_id,user2_id);

      SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;

      SELECT 'chat_id' AS `name`, chat_id as `value` FROM DUAL;
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `chat_exit`
--

DROP PROCEDURE IF EXISTS `chat_exit`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `chat_exit`(user_id INT,chat_id INT)
BEGIN

  IF NOT EXISTS(SELECT id FROM chat_users cu WHERE cu.chat_id=chat_id AND cu.user_id=user_id LIMIT 1) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=4;/*Incorrect user_id*/
  ELSE

    DELETE FROM chat_users WHERE chat_users.user_id=user_id AND chat_users.chat_id=chat_id;

    IF NOT EXISTS(SELECT cu.id FROM chat_users cu WHERE cu.chat_id=chat_id) THEN /*empty chat*/
      DELETE FROM chats WHERE id=chat_id;
    END IF;

    SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;

  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `chat_topic_change`
--

DROP PROCEDURE IF EXISTS `chat_topic_change`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `chat_topic_change`(user_id INT,chat_id INT,new_topic VARCHAR(1000) CHARSET utf8)
BEGIN

  IF NOT EXISTS(SELECT id FROM chat_users cu WHERE cu.chat_id=chat_id AND cu.user_id=user_id LIMIT 1) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=4;/*Incorrect user_id*/
  ELSE
/*OK*/
    UPDATE chats SET topic=new_topic WHERE id=chat_id;

    SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `chat_user_add`
--

DROP PROCEDURE IF EXISTS `chat_user_add`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `chat_user_add`(user_id INT,user2_id INT,chat_id INT)
BEGIN

  IF(SELECT COUNT(*) FROM users u WHERE u.id IN(user_id,user2_id))<>2 THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=4;/*Incorrect user_id*/
  ELSE
      IF EXISTS(SELECT id FROM chat_users cu WHERE cu.chat_id=chat_id AND cu.user_id=user2_id LIMIT 1)THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=32;/*user is already in the chat*/
      ELSE
        IF NOT EXISTS(SELECT id FROM chat_users cu WHERE cu.chat_id=chat_id AND cu.user_id=user_id LIMIT 1) THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=6;/*User is not in this chat*/
        ELSE
/*OK*/
          INSERT INTO chat_users(chat_id,user_id) VALUES(chat_id,user2_id);

          SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;

        END IF;
      END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `get_all_arena_info`
--

DROP PROCEDURE IF EXISTS `get_all_arena_info`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_arena_info`(user_id INT)
BEGIN
 DECLARE chat_history_time_seconds INT DEFAULT 1440;

 /*arena users*/
 SELECT au.user_id AS `user_id`,user_nick(au.user_id) AS `nick`,au.status_id AS
`status_id` FROM arena_users au JOIN users u ON (au.user_id=u.id);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `get_all_chat_info`
--

DROP PROCEDURE IF EXISTS `get_all_chat_info`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_chat_info`(user_id INT)
BEGIN
  /*chats*/
  CREATE TEMPORARY TABLE chats_for_user
  SELECT c.id,c.topic FROM chats c JOIN chat_users cu ON c.id=cu.chat_id WHERE cu.user_id=user_id;

  /*chats*/
  SELECT cu.id AS `chat_id`,cu.topic AS `topic` FROM chats_for_user cu;

  /*chats users*/
  SELECT cfu.id AS `chat_id`,cu.user_id,user_nick(cu.user_id) as `nick` FROM
  chats_for_user cfu JOIN chat_users cu ON (cu.chat_id=cfu.id);

  DROP TEMPORARY TABLE chats_for_user;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `get_arena_games_info`
--

DROP PROCEDURE IF EXISTS `get_arena_games_info`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_arena_games_info`(user_id INT)
BEGIN

 /*games*/
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

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `get_chat_users`
--

DROP PROCEDURE IF EXISTS `get_chat_users`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_chat_users`(user_id INT,chat_id INT)
BEGIN
  IF NOT EXISTS(SELECT u.id FROM users u WHERE u.id=user_id LIMIT 1) THEN
    SELECT NULL AS `user_id`,NULL AS `user_nick` FROM DUAL;
  ELSE
      IF NOT EXISTS(SELECT id FROM chat_users cu WHERE cu.chat_id=chat_id AND cu.user_id=user_id) THEN
        SELECT NULL AS `user_id`,NULL AS `user_nick` FROM DUAL;
      ELSE
/*OK*/
        SELECT cu.user_id,user_nick(cu.user_id) FROM chat_users cu WHERE cu.chat_id=chat_id;
      END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `get_create_game_features`
--

DROP PROCEDURE IF EXISTS `get_create_game_features`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_create_game_features`(user_id INT)
BEGIN
  SELECT id,name,default_param,feature_type FROM lords.games_features;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `get_create_game_modes`
--

DROP PROCEDURE IF EXISTS `get_create_game_modes`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_create_game_modes`(user_id INT)
BEGIN
  SELECT id,name FROM lords.modes;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `get_current_game_info`
--

DROP PROCEDURE IF EXISTS `get_current_game_info`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_current_game_info`(user_id INT)
BEGIN
 DECLARE arena_game_type_id INT DEFAULT 1; /*NOTE hardcode because this id is unlikely to change*/
 DECLARE game_type_id INT;
 DECLARE game_id INT;

 SELECT u.game_type_id INTO game_type_id FROM users u WHERE u.id=user_id LIMIT 1;

 IF game_type_id=arena_game_type_id THEN
   SELECT ap.game_id INTO game_id FROM arena_game_players ap WHERE ap.user_id=user_id LIMIT 1;

/*game*/
   SELECT
     ag.id AS `game_id`,
     title AS `title`,
     owner_id AS `owner_id`,
     ap.name AS `owner_name`,
     time_restriction AS `time_restriction`,
     mode_id AS `mode_id`,
     lm.name AS `mode_name`
   FROM arena_games ag
 JOIN arena_game_players ap ON (ap.user_id=ag.owner_id)
 JOIN lords.modes lm ON (ag.mode_id=lm.id)
 WHERE ag.id=game_id;

/*features*/
   SELECT feature_id,`value`,feature_type FROM arena_games_features_usage f WHERE f.game_id=game_id;

/*players*/
   SELECT
     name AS `name`,
     ap.user_id AS `user_id`,
     spectator_flag AS `spectator_flag`,
     team AS `team`
   FROM arena_game_players ap WHERE ap.game_id=game_id;

 END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `get_my_location`
--

DROP PROCEDURE IF EXISTS `get_my_location`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_my_location`(user_id INT)
BEGIN
  DECLARE game_type_id INT;
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE mode_id INT;

  CALL get_my_location_inner(user_id,game_type_id,g_id,p_num,mode_id);
  SELECT game_type_id AS `game_type_id`, g_id as `game_id`, p_num as `player_num`, mode_id as `mode_id` FROM DUAL;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `get_my_location_inner`
--

DROP PROCEDURE IF EXISTS `get_my_location_inner`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_my_location_inner`(user_id INT, OUT game_type_id INT, OUT game_id INT, OUT player_num INT, OUT mode_id INT)
BEGIN
  DECLARE arena_game_type_id INT DEFAULT 1; /*NOTE hardcode because this id is unlikely to change*/

  DECLARE p_id INT;

  SELECT u.game_type_id INTO game_type_id FROM users u WHERE u.id=user_id LIMIT 1;

  IF (game_type_id<>0) THEN

    SELECT p.game_id,p.player_num,g.mode_id INTO game_id,player_num,mode_id FROM lords.players p JOIN lords.games g ON (p.game_id=g.id) WHERE p.user_id=user_id LIMIT 1;

    IF(game_id IS NULL)THEN
/*game not started*/

      CASE game_type_id
        WHEN arena_game_type_id THEN
          SELECT
            p.game_id,
            g.mode_id
          INTO game_id,mode_id
          FROM arena_game_players p
          JOIN arena_games g ON (p.game_id=g.id)
          WHERE p.user_id=user_id;

/*TODO here will be code for other game types*/
      END CASE;

    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `performance_statistics_add`
--

DROP PROCEDURE IF EXISTS `performance_statistics_add`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `performance_statistics_add`(name VARCHAR(1000) CHARSET utf8, js_time NUMERIC(8,3), ape_time NUMERIC(8,3), php_time NUMERIC(8,3), game_id INT)
BEGIN
  INSERT INTO performance_statistics(request_name,js_time,ape_time,php_time,game_id)
  VALUES(name,js_time,ape_time,php_time,game_id);
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `player_online_offline`
--

DROP PROCEDURE IF EXISTS `player_online_offline`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `player_online_offline`(user_id INT, online_flag INT)
BEGIN
  DECLARE player_online_status_id INT DEFAULT 1; /*NOTE hardcode because this id is unlikely to change*/
  DECLARE player_ingame_status_id INT DEFAULT 2; /*NOTE hardcode because this id is unlikely to change*/
  DECLARE player_playing_status_id INT DEFAULT 3; /*NOTE hardcode because this id is unlikely to change*/
  DECLARE player_offline_status_id INT DEFAULT 4; /*NOTE hardcode because this id is unlikely to change*/
  DECLARE new_status INT;

  DECLARE game_type_id INT;
  DECLARE arena_game_type_id INT DEFAULT 1; /*NOTE hardcode because this id is unlikely to change*/

  IF(online_flag=0)THEN
/*user went offline*/
    SET new_status=player_offline_status_id;
  ELSE
/*user becomes online*/

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

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `reset`
--

DROP PROCEDURE IF EXISTS `reset`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `reset`()
BEGIN
  SET FOREIGN_KEY_CHECKS=0;
  truncate table arena_users;
  truncate table arena_games;
  truncate table arena_games_features_usage;
  truncate table arena_game_players;
  truncate table chat_users;
  truncate table chats;
  update users set game_type_id=0;
  SET FOREIGN_KEY_CHECKS=1;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `user_add`
--

DROP PROCEDURE IF EXISTS `user_add`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `user_add`(login VARCHAR(200) CHARSET utf8,pass VARCHAR(200) CHARSET utf8)
BEGIN
  IF EXISTS(SELECT u.id FROM users u WHERE u.login=login LIMIT 1) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, CONCAT('"',REPLACE(login,'\"','\\\"'),'"') as `error_params` FROM error_dictionary ed WHERE id=1;/*User with this login already exists*/
  ELSE
    IF((IFNULL(login,'')='')OR(IFNULL(pass,'')='')) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=2;/*Empty login or password*/
    ELSE
      INSERT INTO users (login,pass) VALUES (login,MD5(pass));

      SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;
    END IF;
  END IF;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

--
-- Definition of procedure `user_authorize`
--

DROP PROCEDURE IF EXISTS `user_authorize`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `user_authorize`(login VARCHAR(200) CHARSET utf8,pass VARCHAR(200) CHARSET utf8)
BEGIN
  DECLARE user_id INT;
  DECLARE game_type_id INT;
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE mode_id INT;

  SELECT u.id INTO user_id FROM users u WHERE u.login=login AND u.pass=MD5(pass) LIMIT 1;
  IF user_id IS NULL THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=3;/*Incorrect login or password*/
  ELSE
    CALL get_my_location_inner(user_id,game_type_id,g_id,p_num,mode_id);

    SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;

    SELECT 'user_id' AS `name`, user_id as `value` FROM DUAL
    UNION
    SELECT 'game_type_id' AS `name`, game_type_id as `value` FROM DUAL
    UNION
    SELECT 'game_id' AS `name`, g_id as `value` FROM DUAL
    UNION
    SELECT 'player_num' AS `name`, p_num as `value` FROM DUAL
    UNION
    SELECT 'mode_id' AS `name`, mode_id as `value` FROM DUAL;

  END IF;
END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;
--
-- Create schema lords
--

CREATE DATABASE IF NOT EXISTS lords;
USE lords;

--
-- Definition of view `vw_grave`
--

DROP TABLE IF EXISTS `vw_grave`;
DROP VIEW IF EXISTS `vw_grave`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_grave` AS select `dead_units`.`game_id` AS `game_id`,`dead_units`.`card_id` AS `card_id`,min(`dead_units`.`x`) AS `x`,min(`dead_units`.`y`) AS `y`,sqrt(count(0)) AS `size` from `dead_units` group by `dead_units`.`game_id`,`dead_units`.`card_id`;

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
