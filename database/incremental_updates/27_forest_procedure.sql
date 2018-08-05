use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`create_new_building` $$

CREATE PROCEDURE `create_new_building`(g_id INT, p_num INT, building_id INT, card_id INT, x INT, y INT, rot INT, flp INT)
BEGIN
  DECLARE bb_id INT;

  INSERT INTO board_buildings(game_id,player_num,building_id,card_id,rotation,flip)
    VALUES (g_id, p_num, IFNULL(building_id, 0), card_id, rot, flp);
  SET bb_id = LAST_INSERT_ID();
  SELECT bb.building_id INTO building_id FROM board_buildings bb WHERE bb.id = bb_id;

  CALL place_building_on_board(bb_id, x, y, rot, flp);

  IF NOT EXISTS(SELECT id FROM board WHERE game_id=g_id AND `type`<>'unit' AND ref=bb_id) THEN
    DELETE FROM board_buildings WHERE id=bb_id;
    SET bb_id = 0;
  ELSE
    INSERT INTO board_buildings_features(board_building_id, feature_id, param)
      SELECT bb_id, bf.feature_id, bf.param FROM building_default_features bf
      WHERE bf.building_id = building_id;

    UPDATE board_buildings_features bbf
      SET param=get_new_team_number(g_id)
      WHERE bbf.board_building_id = bb_id AND bbf.feature_id = building_feature_get_id_by_code('summon_team');

    IF building_feature_check(bb_id,'ally') = 1 THEN
      CALL building_feature_set(bb_id,'summon_team', get_player_team(g_id, p_num));
    END IF;

    CALL count_income(bb_id);

  END IF;
  SET @new_board_building_id = bb_id;
END$$


DROP PROCEDURE IF EXISTS `lords`.`put_building` $$

CREATE PROCEDURE `put_building`(g_id INT,   p_num INT,   player_deck_id INT,   x INT,   y INT,   rotation INT,   flip INT)
BEGIN
  DECLARE crd_id INT;
  DECLARE err_code INT;
  DECLARE x_len,y_len INT;
  DECLARE x2,y2 INT; 
  DECLARE new_building_id INT;

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
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='building_outside_zone';
    ELSE
      CALL create_new_building(g_id, p_num, NULL, crd_id, x, y, rotation, flip);
      SET new_building_id = @new_board_building_id;
      IF new_building_id = 0 THEN 
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='place_occupied';
      ELSE
        CALL user_action_begin(g_id, p_num);
        CALL play_card_actions(g_id,p_num,player_deck_id); 

        CALL cmd_put_building_by_card(g_id,p_num,new_building_id);

        IF EXISTS(SELECT sc.id FROM summon_cfg sc WHERE sc.building_id=(SELECT bb.building_id FROM board_buildings bb WHERE id=new_building_id)) THEN
          CALL summon_creatures(new_building_id);
        END IF;

        CALL finish_playing_card(g_id,p_num);
        CALL end_cards_phase(g_id,p_num);
        CALL user_action_end(g_id, p_num);
      END IF;
    END IF;
  END IF;
END$$


DROP FUNCTION IF EXISTS `lords`.`get_game_mode` $$

CREATE FUNCTION `get_game_mode`(g_id INT) RETURNS int
BEGIN
  RETURN (SELECT mode_id FROM games WHERE id = g_id LIMIT 1);
END$$

DROP FUNCTION IF EXISTS `lords`.`is_valid_cell` $$

CREATE FUNCTION `is_valid_cell`(g_id INT, x INT, y INT) RETURNS int
BEGIN
  IF EXISTS (SELECT id FROM allcoords a WHERE a.x=x AND a.y=y AND a.mode_id = get_game_mode(g_id)) THEN
    RETURN 1;
  ELSE
    RETURN 0;
  END IF;
END$$

DROP PROCEDURE IF EXISTS `lords`.`bridge_destroy` $$

CREATE PROCEDURE `bridge_destroy`(g_id INT, p_num INT, x INT, y INT, rotation INT, flip INT)
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
  
  CALL create_new_building(g_id, neutral_p_num, destroyed_bridge_building_id, NULL, x, y, rotation, flip);
  SET new_board_building_id = @new_board_building_id;
  
  CALL cmd_put_building_by_id(g_id, neutral_p_num, new_board_building_id);
END$$

DROP PROCEDURE IF EXISTS `lords`.`destroy_castle` $$

CREATE PROCEDURE `destroy_castle`(board_castle_id INT,    p_num INT)
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

  CALL create_new_building(g_id, p2_num, ruins_building_id, NULL, destroyed_castle_x, destroyed_castle_y, destroyed_castle_rotation, destroyed_castle_flip);
  SET ruins_board_building_id = @new_board_building_id;

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

END$$

DROP PROCEDURE IF EXISTS `lords`.`init_buildings` $$

CREATE PROCEDURE `init_buildings`(g_id INT)
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
      CALL create_new_building(g_id, p_num, building_id, NULL, x, y, rotation, flip);
    END IF;
  UNTIL done END REPEAT;
  CLOSE cur;

  SET done=0;
  OPEN cur_neutral;
  REPEAT
    FETCH cur_neutral INTO p_num,x,y,rotation,flip,building_id;
    IF NOT done THEN
      CALL create_new_building(g_id, p_num, building_id, NULL, x, y, rotation, flip);
    END IF;
  UNTIL done END REPEAT;
  CLOSE cur_neutral;

END$$

DROP PROCEDURE IF EXISTS `lords`.`init_landscape` $$

CREATE PROCEDURE `init_landscape`(g_id INT)
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

        CALL create_new_building(g_id, neutral_p_num, building_id, NULL, tree_x, tree_y, 0, 0);
        SET board_building_id = @new_board_building_id;

        IF board_building_id = 0 THEN
          SET i=i+1;
        ELSE
          DELETE ac
              FROM available_cells_for_trees ac
              JOIN board b ON (ac.x = b.x) AND (ac.y = b.y)
              WHERE b.game_id = g_id AND `type`<>'unit' AND ref = board_building_id;
        END IF;

        SET i=i-1;
      END WHILE;
      SET quart = quart+1;
    END WHILE;

    DROP TEMPORARY TABLE available_cells_for_trees;
  END;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`cast_forest` $$

CREATE PROCEDURE `cast_forest`(g_id INT, p_num INT, player_deck_id INT, x INT, y INT)
BEGIN
  DECLARE neutral_p_num INT DEFAULT 9;
  DECLARE err_code INT;
  DECLARE forest_range INT DEFAULT 2;
  DECLARE tree_building_id INT;
  DECLARE tree_x, tree_y INT;
  DECLARE new_bb_id INT;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_forest');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT is_valid_cell(g_id, x, y) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='invalid_coord';
    ELSE
      CALL user_action_begin(g_id, p_num);
      CALL play_card_actions(g_id,p_num,player_deck_id); 

      SELECT b.id INTO tree_building_id FROM vw_mode_buildings b
        WHERE b.mode_id = get_game_mode(g_id) AND b.ui_code = 'tree';

      SET tree_x = x - forest_range;
      WHILE tree_x <= x + forest_range DO
        SET tree_y = y - forest_range;
        WHILE tree_y <= y + forest_range DO
          IF is_valid_cell(g_id, tree_x, tree_y) THEN
            CALL create_new_building(g_id, neutral_p_num, tree_building_id, NULL, tree_x, tree_y, 0, 0);
            SET new_bb_id = @new_board_building_id;
            IF new_bb_id > 0 THEN
              CALL cmd_put_building_by_id(g_id, neutral_p_num, new_bb_id);
            END IF;
          END IF;
          SET tree_y = tree_y + 1;
        END WHILE;
        SET tree_x = tree_x + 1;
      END WHILE;

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);
      CALL user_action_end(g_id, p_num);
    END IF;
  END IF;

END$$


