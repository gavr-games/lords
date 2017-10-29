USE `lords`;
DROP procedure IF EXISTS `cmd_unit_add_effect`;

DELIMITER $$
USE `lords`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_unit_add_effect`(g_id INT,board_unit_id INT,eff VARCHAR(30))
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'unit_add_effect($x,$y,"$effect","$param")';
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit <b class=\'unitEffect\'>$effect_desc</b>")';
  DECLARE x,y INT;
  DECLARE p2_num INT; 

  SELECT b.x,b.y INTO x,y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=board_unit_id LIMIT 1;
  SELECT bu.player_num INTO p2_num FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;
  SET cmd=REPLACE(cmd,'$x',x);
  SET cmd=REPLACE(cmd,'$y',y);
  SET cmd=REPLACE(cmd,'$effect',eff);
  SET cmd=REPLACE(cmd,'$param',IFNULL(unit_feature_get_param(board_unit_id,eff),''));

  SET cmd_log=REPLACE(cmd_log,'$log_unit',log_unit(board_unit_id));
  SET cmd_log=REPLACE(cmd_log,'$effect_desc',eff); /*TODO: temporary fix, need to change the whole log system*/

  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p2_num,cmd_log);
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p2_num,cmd);

END$$

DELIMITER ;

USE `lords`;
DROP procedure IF EXISTS `cmd_unit_remove_effect`;

DELIMITER $$
USE `lords`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_unit_remove_effect`(g_id INT,board_unit_id INT,eff VARCHAR(30))
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'unit_remove_effect($x,$y,"$effect")';
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit <b class=\'unitEffect\'>больше не $effect_desc</b>")';
  DECLARE x,y INT;
  DECLARE p2_num INT; 

  SELECT b.x,b.y INTO x,y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=board_unit_id LIMIT 1;
  SELECT bu.player_num INTO p2_num FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;
  SET cmd=REPLACE(cmd,'$x',x);
  SET cmd=REPLACE(cmd,'$y',y);
  SET cmd=REPLACE(cmd,'$effect',eff);

  SET cmd_log=REPLACE(cmd_log,'$log_unit',log_unit(board_unit_id));
  SET cmd_log=REPLACE(cmd_log,'$effect_desc',eff); /*TODO: temporary fix, need to change the whole log system*/

  IF((SELECT current_procedure FROM active_players WHERE game_id=g_id LIMIT 1)='end_turn')THEN
    SET cmd_log=REPLACE(cmd_log,'log_add_message(',CONCAT('log_add_independent_message(',p2_num,','));
  END IF;

  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p2_num,cmd_log);
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p2_num,cmd);

END$$

DELIMITER ;


