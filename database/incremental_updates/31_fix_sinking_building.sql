use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`remove_building_from_board`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `remove_building_from_board`(board_b_id INT,p_num INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p2_num INT; /*building owner*/
  DECLARE crd_id INT;

  SELECT game_id,player_num,card_id INTO g_id,p2_num,crd_id FROM board_buildings WHERE id=board_b_id LIMIT 1;

/*building card back to deck*/
  IF(crd_id IS NOT NULL)THEN INSERT INTO deck(game_id,card_id) VALUES(g_id,crd_id); END IF;

  CALL cmd_destroy_building(g_id,p_num,board_b_id);
  DELETE FROM board WHERE game_id=g_id AND `type`<>'unit' AND ref=board_b_id;
  DELETE FROM board_buildings_features WHERE board_building_id=board_b_id;
  DELETE FROM board_buildings WHERE id=board_b_id;

  INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'destroy_building',p2_num);

END$$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`sink_building`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sink_building`(bb_id INT,p_num INT)
BEGIN
  DECLARE g_id INT;
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_building тонет в воде")';

  SELECT game_id INTO g_id FROM board_buildings WHERE id=bb_id LIMIT 1;

/*log*/
  SET cmd_log=REPLACE(cmd_log,'$log_building',log_building(bb_id));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

  CALL remove_building_from_board(bb_id,p_num);
END$$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`destroy_building`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `destroy_building`(board_b_id INT,p_num INT)
BEGIN
  DECLARE g_id INT;
  DECLARE reward INT DEFAULT 50;
  DECLARE old_x,old_y,old_rotation,old_flip INT;
  DECLARE destroy_bridge INT DEFAULT 0;

  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Здание $log_building разрушено")';

  SELECT game_id INTO g_id FROM board_buildings WHERE id=board_b_id LIMIT 1;

/*log*/
      SET cmd_log=REPLACE(cmd_log,'$log_building',log_building(board_b_id));
      INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

  IF EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.`type`='obstacle' AND b.ref=board_b_id) THEN
    SET reward=0; /*no reward for swamps*/
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

END$$

DELIMITER ;

