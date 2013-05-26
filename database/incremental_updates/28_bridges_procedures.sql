use lords;

delimiter $$

DROP PROCEDURE IF EXISTS `lords`.`sink_building`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sink_building`(bb_id INT,p_num INT)
BEGIN
  DECLARE g_id INT;
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_building тонет в воде")';

  SELECT game_id INTO g_id FROM board_buildings WHERE id=bb_id LIMIT 1;

/*log*/
  SET cmd_log=REPLACE(cmd_log,'$log_building',log_building(bb_id));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

  CALL destroy_building(bb_id,p_num);
END$$

DROP PROCEDURE IF EXISTS `lords`.`bridge_destroy`$$
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
  
/*sink*/
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
  
  CALL cmd_put_building(g_id,neutral_p_num,new_board_building_id);
END$$

DROP PROCEDURE IF EXISTS `lords`.`destroy_building` $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `destroy_building`(board_b_id INT,p_num INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p2_num INT; /*building owner*/
  DECLARE crd_id INT;
  DECLARE reward INT DEFAULT 50;
  DECLARE old_x,old_y,old_rotation,old_flip INT;
  DECLARE destroy_bridge INT DEFAULT 0;

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

  IF(building_feature_check(board_b_id,'destroyable_bridge'))THEN
    SELECT MIN(b.x),MIN(b.y) INTO old_x,old_y FROM board b WHERE b.game_id=g_id AND b.`type`<>'unit' AND b.ref=board_b_id;
    SELECT bb.rotation,bb.flip INTO old_rotation,old_flip FROM board_buildings bb WHERE bb.id=board_b_id LIMIT 1;
    SET destroy_bridge=1;
  END IF;


  CALL cmd_destroy_building(g_id,p_num,board_b_id);
  DELETE FROM board WHERE game_id=g_id AND `type`<>'unit' AND ref=board_b_id;
  DELETE FROM board_buildings_features WHERE board_building_id=board_b_id;
  DELETE FROM board_buildings WHERE id=board_b_id;

  IF reward>0 THEN
    UPDATE players SET gold=gold+reward WHERE game_id=g_id AND player_num=p_num;
    CALL cmd_player_set_gold(g_id,p_num);
  END IF;

  IF(destroy_bridge=1)THEN
   CALL bridge_destroy(g_id,p_num,old_x,old_y,old_rotation,old_flip);
  END IF;

  INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'destroy_building',p2_num);

END $$

delimiter ;