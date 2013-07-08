use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`unit_add_exp`$$
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

END$$

DELIMITER ;
