use lords;

DELIMITER $$

DROP FUNCTION IF EXISTS `lords`.`check_building_can_do_action` $$
CREATE DEFINER=`root`@`localhost` FUNCTION `check_building_can_do_action`(g_id INT,p_num INT,x INT,y INT,action_procedure VARCHAR(30)) RETURNS int(11)
BEGIN
  DECLARE board_building_id INT;
  DECLARE p_num_building_owner INT;
  DECLARE b_id INT;
  DECLARE current_turn INT;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id LIMIT 1) THEN RETURN 1; END IF;/*Not your turn*/
  IF (SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id LIMIT 1)<>0 THEN RETURN 28; END IF;/*polza/vred in progress*/

  SELECT b.ref INTO board_building_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`<>'unit' LIMIT 1;
  IF board_building_id IS NULL THEN RETURN 26; END IF;/*Not a building*/

  SELECT bb.player_num,bb.building_id INTO p_num_building_owner,b_id FROM board_buildings bb WHERE bb.id=board_building_id LIMIT 1;

  IF p_num_building_owner<>p_num THEN RETURN 44; END IF;/*Not my building*/
  IF (check_building_deactivated(board_building_id)=1) THEN RETURN 45; END IF;/*building deactivated*/

  IF(building_feature_check(board_building_id,'turn_when_changed')=1)THEN
    SELECT turn INTO current_turn FROM active_players WHERE game_id=g_id;
    IF(building_feature_get_param(board_building_id,'turn_when_changed') = current_turn)THEN
      RETURN 47;
    END IF;
  END IF;

  IF NOT EXISTS(SELECT bp.id FROM buildings_procedures bp JOIN procedures pm ON bp.procedure_id=pm.id WHERE bp.building_id=b_id AND pm.name=action_procedure LIMIT 1) THEN RETURN 46; END IF;/*Cheater - procedure from another building*/

  UPDATE active_players SET current_procedure=action_procedure WHERE game_id=g_id;

  RETURN 0;
END$$

DROP PROCEDURE IF EXISTS `lords`.`place_building_on_board` $$
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
  INSERT INTO busy_coords (x,y) SELECT b.x,b.y FROM board b WHERE b.game_id=g_id AND NOT(b.`type` IN('building','obstacle') AND b.ref=0); /*don't include coords occupied by building itself if any*/
  INSERT INTO busy_coords (x,y) SELECT b.x+IF(b.x=0,1,-1),b.y+IF(b.y=0,1,-1) FROM board b WHERE b.game_id=g_id AND (b.x=0 OR b.x=19) AND (b.y=0 OR b.y=19) AND b.`type`='castle';

  IF NOT EXISTS(SELECT b.id FROM busy_coords b JOIN put_coords p ON (b.x=p.x AND b.y=p.y)) THEN /*If all points free - insert into board, else don't insert, can't place on appearing point*/
    INSERT INTO board(game_id,x,y,`type`,ref) SELECT g_id,p_c.x,p_c.y,b_type,board_building_id FROM put_coords p_c;
  END IF;
  DROP TEMPORARY TABLE put_coords;
  DROP TEMPORARY TABLE busy_coords;

END$$

DROP PROCEDURE IF EXISTS `lords`.`wall_open` $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `wall_open`(g_id INT,p_num INT,x INT,y INT)
BEGIN
  DECLARE g_mode INT;
  DECLARE err_code INT;
  DECLARE board_building_id INT;
  DECLARE current_turn INT;
  DECLARE old_wall_building_id INT;
  DECLARE new_wall_building_id INT;
  DECLARE rotation,flip,x_min,y_min INT;

  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_building открывается")';

  SELECT g.mode_id INTO g_mode FROM games g WHERE g.id=g_id LIMIT 1;

  SET err_code=check_building_can_do_action(g_id,p_num,x,y,'wall_open'); /*building can do it*/
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    SELECT b.ref INTO board_building_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`<>'unit' LIMIT 1;
    SELECT turn INTO current_turn FROM active_players WHERE game_id=g_id;

    SELECT MIN(b.x),MIN(b.y) INTO x_min,y_min FROM board b WHERE b.game_id=g_id AND b.`type`<>'unit' AND b.ref=board_building_id;
    SELECT bb.rotation,bb.flip,bb.building_id INTO rotation,flip,old_wall_building_id FROM board_buildings bb WHERE bb.id=board_building_id LIMIT 1;

    SELECT v.building_id INTO new_wall_building_id FROM  vw_mode_building_default_features v WHERE v.mode_id=g_mode AND v.feature_id=building_feature_get_id_by_code('wall_opened');

    UPDATE board_buildings SET building_id=new_wall_building_id WHERE id=board_building_id;

    /*set ref=0 to identify if building has been moved*/
    UPDATE board SET ref=0 WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=board_building_id;

    CALL place_building_on_board(board_building_id,x_min,y_min,rotation,flip);

    IF NOT EXISTS(SELECT id FROM board WHERE game_id=g_id AND `type`<>'unit' AND ref=board_building_id) THEN /*Building not placed*/
      UPDATE board SET ref=board_building_id WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0;
      UPDATE board_buildings SET building_id=old_wall_building_id WHERE id=board_building_id;
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=12;/*Place occupied*/
    ELSE
      CALL user_action_begin();

      DELETE FROM board WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0; /*Del old coords*/

      IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
        CALL start_moving_units(g_id,p_num);
      END IF;
	
      CALL cmd_destroy_building(g_id,p_num,board_building_id);
      CALL cmd_put_building(g_id,p_num,board_building_id);
      CALL cmd_building_set_health(g_id,p_num,board_building_id);

      CALL building_feature_set(board_building_id,'turn_when_changed',current_turn);

/*log*/
      SET cmd_log=REPLACE(cmd_log,'$log_building',log_building(board_building_id));
      INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

      CALL user_action_end();
    END IF;
  END IF;
END $$

DROP PROCEDURE IF EXISTS `lords`.`wall_close` $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `wall_close`(g_id INT,p_num INT,x INT,y INT)
BEGIN
  DECLARE g_mode INT;
  DECLARE err_code INT;
  DECLARE board_building_id INT;
  DECLARE current_turn INT;
  DECLARE old_wall_building_id INT;
  DECLARE new_wall_building_id INT;
  DECLARE rotation,flip,x_min,y_min INT;

  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_building закрывается")';

  SELECT g.mode_id INTO g_mode FROM games g WHERE g.id=g_id LIMIT 1;

  SET err_code=check_building_can_do_action(g_id,p_num,x,y,'wall_close'); /*building can do it*/
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    SELECT b.ref INTO board_building_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`<>'unit' LIMIT 1;
    SELECT turn INTO current_turn FROM active_players WHERE game_id=g_id;

    SELECT MIN(b.x),MIN(b.y) INTO x_min,y_min FROM board b WHERE b.game_id=g_id AND b.`type`<>'unit' AND b.ref=board_building_id;
    SELECT bb.rotation,bb.flip,bb.building_id INTO rotation,flip,old_wall_building_id FROM board_buildings bb WHERE bb.id=board_building_id LIMIT 1;

    SELECT v.building_id INTO new_wall_building_id FROM  vw_mode_building_default_features v WHERE v.mode_id=g_mode AND v.feature_id=building_feature_get_id_by_code('wall_closed');

    UPDATE board_buildings SET building_id=new_wall_building_id WHERE id=board_building_id;

    /*set ref=0 to identify if building has been moved*/
    UPDATE board SET ref=0 WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=board_building_id;

    CALL place_building_on_board(board_building_id,x_min,y_min,rotation,flip);

    IF NOT EXISTS(SELECT id FROM board WHERE game_id=g_id AND `type`<>'unit' AND ref=board_building_id) THEN /*Building not placed*/
      UPDATE board SET ref=board_building_id WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0;
      UPDATE board_buildings SET building_id=old_wall_building_id WHERE id=board_building_id;
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=12;/*Place occupied*/
    ELSE
      CALL user_action_begin();

      DELETE FROM board WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0; /*Del old coords*/

      IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
        CALL start_moving_units(g_id,p_num);
      END IF;
	
      CALL cmd_destroy_building(g_id,p_num,board_building_id);
      CALL cmd_put_building(g_id,p_num,board_building_id);
      CALL cmd_building_set_health(g_id,p_num,board_building_id);

      CALL building_feature_set(board_building_id,'turn_when_changed',current_turn);

/*log*/
      SET cmd_log=REPLACE(cmd_log,'$log_building',log_building(board_building_id));
      INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

      CALL user_action_end();
    END IF;
  END IF;
END $$

DELIMITER ;
