use lords;

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

END$$

DELIMITER ;
