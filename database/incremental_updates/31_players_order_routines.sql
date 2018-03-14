use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`end_turn` $$

CREATE PROCEDURE `end_turn`(g_id INT,  p_num INT)
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

END$$

DROP FUNCTION IF EXISTS `lords`.`get_move_order_for_new_npc` $$

CREATE FUNCTION `get_move_order_for_new_npc`(g_id INT, p_num INT) RETURNS int(11)
BEGIN
  DECLARE move_order_p INT;
  DECLARE move_order_new_npc INT;
  
  SELECT p.move_order INTO move_order_p FROM players p WHERE p.game_id = g_id AND p.player_num = p_num LIMIT 1;
  
  SELECT MIN(p.move_order) INTO move_order_new_npc FROM players p WHERE p.game_id = g_id AND p.owner = 1 AND p.move_order > move_order_p;

  IF move_order_new_npc IS NULL THEN
    SELECT MAX(p.move_order) + 1 INTO move_order_new_npc FROM players p WHERE p.game_id = g_id;
  END IF;

  RETURN move_order_new_npc;
END$$

DROP PROCEDURE IF EXISTS `lords`.`cast_vampire` $$

CREATE PROCEDURE `cast_vampire`(g_id INT,  p_num INT,  player_deck_id INT,  x INT,  y INT)
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

        SELECT MAX(p.team)+1 INTO team FROM players p WHERE p.game_id=g_id;
        SELECT CASE WHEN MAX(p.player_num)<10 THEN 10 ELSE MAX(p.player_num)+1 END INTO new_player FROM players p WHERE p.game_id=g_id;

        SELECT vu.id INTO vamp_u_id FROM vw_mode_units vu WHERE vu.mode_id=mode_id AND vu.ui_code=vamp_ui_code;
        SET vamp_name = CONCAT('{', vamp_u_id, '}');
        SET vamp_move_order = get_move_order_for_new_npc(g_id, p_num);
        
        UPDATE players SET move_order = move_order + 1 WHERE game_id = g_id AND move_order >= vamp_move_order;
        INSERT INTO players(game_id,player_num,name,gold,owner,team,move_order) VALUES(g_id,new_player,vamp_name,0,vamp_owner,team,vamp_move_order);
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

END$$

DROP PROCEDURE IF EXISTS `lords`.`finish_nonfinished_action` $$

CREATE PROCEDURE `finish_nonfinished_action`(g_id INT,  p_num INT,  nonfinished_action INT)
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
        SELECT FLOOR(1 + (RAND() * MAX(id_rand))) INTO big_dice FROM tmp_dead_units;
        SELECT `grave_id`,`card_id` INTO random_grave,random_dead_card FROM tmp_dead_units WHERE id_rand=big_dice LIMIT 1;
        DROP TEMPORARY TABLE tmp_dead_units;

        CALL resurrect(g_id,p_num,random_grave);
        CALL cmd_resurrect_by_card_log(g_id,p_num,random_dead_card);
    END;

    WHEN 2 THEN 
    BEGIN
      DECLARE zone INT;

      SELECT FLOOR(RAND() * 4) INTO zone FROM DUAL;

      CALL units_from_zone(g_id, p_num, zone);
    END;

    WHEN 3 THEN 
    BEGIN
      DECLARE big_dice INT;
      DECLARE rand_building_id INT;
      DECLARE x_len,y_len INT;
      DECLARE shape VARCHAR(400);
      DECLARE radius INT;
      DECLARE rotation INT DEFAULT 0;
      DECLARE flip INT DEFAULT 0;
      DECLARE x,y,b_x,b_y INT;

      
        CREATE TEMPORARY TABLE tmp_buildings (id_rand INT AUTO_INCREMENT PRIMARY KEY)AUTO_INCREMENT=1
          SELECT DISTINCT b.ref AS `board_building_id`
          FROM board b
          JOIN board_buildings bb ON (b.ref=bb.id)
          WHERE b.game_id=g_id AND b.`type` IN ('building','obstacle') AND bb.player_num<>p_num AND building_feature_check(bb.id,'not_movable')=0;
        SELECT FLOOR(1 + (RAND() * MAX(id_rand))) INTO big_dice FROM tmp_buildings;
        SELECT `board_building_id` INTO rand_building_id FROM tmp_buildings WHERE id_rand=big_dice LIMIT 1;
        DROP TEMPORARY TABLE tmp_buildings;

        SELECT b.x_len,b.y_len,b.shape,b.radius INTO x_len,y_len,shape,radius FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.id=rand_building_id LIMIT 1;

        
        SELECT b.x,b.y INTO b_x,b_y FROM board b WHERE b.game_id=g_id AND b.`type` IN ('building','obstacle') AND b.ref=rand_building_id LIMIT 1;
        
        UPDATE board SET ref=0 WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=rand_building_id;

        
        WHILE NOT EXISTS (SELECT id FROM board WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=rand_building_id LIMIT 1) DO
          IF shape='1' THEN
            SELECT FLOOR(RAND() * 20) INTO x FROM DUAL;
            SELECT FLOOR(RAND() * 20) INTO y FROM DUAL;
          ELSE
            SELECT FLOOR(RAND() * 4) INTO rotation FROM DUAL;
            SELECT FLOOR(RAND() * 2) INTO flip FROM DUAL;
            
            SELECT FLOOR(RAND() * (21- CASE WHEN rotation IN(0,2) THEN x_len ELSE y_len END)) INTO x FROM DUAL;
            SELECT FLOOR(RAND() * (21- CASE WHEN rotation IN(0,2) THEN y_len ELSE x_len END)) INTO y FROM DUAL;
          END IF;
          
          CALL place_building_on_board(rand_building_id,x,y,rotation,flip);
        END WHILE;

        DELETE FROM board WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0; 

        UPDATE board_buildings bb SET bb.player_num=p_num,bb.rotation=rotation,bb.flip=flip WHERE bb.id=rand_building_id;

        CALL count_income(rand_building_id);

        CALL cmd_move_building(g_id,p_num,b_x,b_y,rand_building_id);
        CALL cmd_building_set_owner(g_id,p_num,rand_building_id);
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
      DECLARE big_dice INT;
      DECLARE rand_building_id INT;
      DECLARE x_len,y_len INT;
      DECLARE shape VARCHAR(400);
      DECLARE radius INT;
      DECLARE rotation INT DEFAULT 0;
      DECLARE flip INT DEFAULT 0;
      DECLARE x,y,b_x,b_y INT;

      
        CREATE TEMPORARY TABLE tmp_buildings (id_rand INT AUTO_INCREMENT PRIMARY KEY)AUTO_INCREMENT=1
          SELECT DISTINCT b.ref AS `board_building_id`
          FROM board b
          JOIN board_buildings bb ON (b.ref=bb.id)
          WHERE b.game_id=g_id AND b.`type` IN ('building','obstacle') AND bb.player_num<>p_num AND building_feature_check(bb.id,'not_movable')=0;
        SELECT FLOOR(1 + (RAND() * MAX(id_rand))) INTO big_dice FROM tmp_buildings;
        SELECT `board_building_id` INTO rand_building_id FROM tmp_buildings WHERE id_rand=big_dice LIMIT 1;
        DROP TEMPORARY TABLE tmp_buildings;

        SELECT b.x_len,b.y_len,b.shape,b.radius INTO x_len,y_len,shape,radius FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.id=rand_building_id LIMIT 1;

        
        SELECT b.x,b.y INTO b_x,b_y FROM board b WHERE b.game_id=g_id AND b.`type` IN ('building','obstacle') AND b.ref=rand_building_id LIMIT 1;
        
        UPDATE board SET ref=0 WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=rand_building_id;

        
        WHILE NOT EXISTS (SELECT id FROM board WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=rand_building_id LIMIT 1) DO
          IF shape='1' THEN
            SELECT FLOOR(RAND() * 20) INTO x FROM DUAL;
            SELECT FLOOR(RAND() * 20) INTO y FROM DUAL;
          ELSE
            SELECT FLOOR(RAND() * 4) INTO rotation FROM DUAL;
            SELECT FLOOR(RAND() * 2) INTO flip FROM DUAL;
            
            SELECT FLOOR(RAND() * (21- CASE WHEN rotation IN(0,2) THEN x_len ELSE y_len END)) INTO x FROM DUAL;
            SELECT FLOOR(RAND() * (21- CASE WHEN rotation IN(0,2) THEN y_len ELSE x_len END)) INTO y FROM DUAL;
          END IF;
          
          CALL place_building_on_board(rand_building_id,x,y,rotation,flip);
        END WHILE;

        DELETE FROM board WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0; 

        UPDATE board_buildings bb SET bb.rotation=rotation,bb.flip=flip WHERE bb.id=rand_building_id;

        CALL count_income(rand_building_id);

        CALL cmd_move_building(g_id,p_num,b_x,b_y,rand_building_id);
    END;

  END CASE;

  UPDATE active_players SET nonfinished_action_id=0 WHERE game_id=g_id AND player_num=p_num;

  CALL finish_playing_card(g_id,p_num);

END$$

DROP PROCEDURE IF EXISTS `lords`.`init_player_num_teams` $$

CREATE PROCEDURE `init_player_num_teams`(g_id INT)
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

  UPDATE players SET move_order = player_num WHERE game_id = g_id;

END$$

DROP PROCEDURE IF EXISTS `lords`.`make_mad` $$

CREATE PROCEDURE `make_mad`(board_unit_id INT)
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
      SELECT MAX(p.team)+1 INTO team FROM players p WHERE p.game_id=g_id;
      SELECT CASE WHEN MAX(p.player_num)<10 THEN 10 ELSE MAX(p.player_num)+1 END INTO new_player FROM players p WHERE p.game_id=g_id;
      SET mad_move_order = get_move_order_for_new_npc(g_id, (SELECT player_num FROM active_players WHERE game_id=g_id LIMIT 1));

      UPDATE players SET move_order = move_order + 1 WHERE game_id = g_id AND move_order >= mad_move_order;
      INSERT INTO players(game_id,player_num,name,gold,owner,team,move_order) VALUES(g_id,new_player,mad_name,0,2,team,mad_move_order);
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

END$$

DROP PROCEDURE IF EXISTS `lords`.`player_exit` $$

CREATE PROCEDURE `player_exit`(g_id INT,  p_num INT)
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
END$$

DROP PROCEDURE IF EXISTS `lords`.`destroy_castle` $$

CREATE PROCEDURE `destroy_castle`(board_castle_id INT,  p_num INT)
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
  CALL cmd_play_video(g_id,p2_num,'destroyed_castle',1);

  SELECT g.mode_id, g.type_id INTO mode_id, game_type_id FROM games g WHERE g.id = g_id;

  INSERT INTO lords_site.user_statistics_games(user_id,game_type_id,mode_id,game_result)
  VALUES(user_id,game_type_id,mode_id,'lose');

  IF (SELECT COUNT(DISTINCT p.team) FROM players p WHERE game_id=g_id AND owner=1)=1 THEN
    CALL end_game(g_id);
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`summon_creature` $$

CREATE PROCEDURE `summon_creature`(g_id INT,  cr_owner INT , cr_unit_id INT , x INT , y INT,  parent_building_id INT)
BEGIN
  DECLARE new_player,team INT;
  DECLARE new_unit_id INT;
  DECLARE new_move_order INT;
  DECLARE cr_player_name VARCHAR(45) CHARSET utf8;

    SELECT CASE WHEN MAX(p.player_num)<10 THEN 10 ELSE MAX(p.player_num)+1 END INTO new_player FROM players p WHERE p.game_id=g_id;
    SET team=building_feature_get_param(parent_building_id,'summon_team');
    SET cr_player_name = CONCAT('{', cr_unit_id, '}');
    SET new_move_order = get_move_order_for_new_npc(g_id, (SELECT player_num FROM active_players WHERE game_id=g_id LIMIT 1));

    UPDATE players SET move_order = move_order + 1 WHERE game_id = g_id AND move_order >= new_move_order;
    INSERT INTO players(game_id,player_num,name,gold,owner,team,move_order) VALUES(g_id,new_player,cr_player_name,0,cr_owner,team,new_move_order);

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

END$$

DROP PROCEDURE IF EXISTS `lords`.`vampire_resurrect_by_card` $$

CREATE PROCEDURE `vampire_resurrect_by_card`(vamp_board_id INT,   grave_id INT)
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
  DECLARE new_move_order INT;
  DECLARE u_id INT;
  DECLARE vamp_name VARCHAR(45) CHARSET utf8 DEFAULT '{vampire} {$u_id}';

  IF ((SELECT FLOOR(1 + (RAND() * dice_max)) FROM DUAL)>chance) THEN 
    SELECT bu.game_id,bu.player_num,p.team INTO g_id,p_num,team FROM board_units bu JOIN 
    players p ON (bu.game_id=p.game_id AND bu.player_num=p.player_num) WHERE bu.id=vamp_board_id LIMIT 1;

    SELECT CASE WHEN MAX(p.player_num)<10 THEN 10 ELSE MAX(p.player_num)+1 END INTO new_player FROM players p WHERE p.game_id=g_id;

    SELECT g.card_id INTO dead_card_id FROM graves g WHERE id=grave_id;
    SELECT c.ref INTO u_id FROM cards c WHERE c.id=dead_card_id LIMIT 1;

    SET vamp_name=REPLACE(vamp_name,'$u_id', u_id);
    SET new_move_order = get_move_order_for_new_npc(g_id, p_num);

    UPDATE players SET move_order = move_order + 1 WHERE game_id = g_id AND move_order >= new_move_order;
    INSERT INTO players(game_id,player_num,name,gold,owner,team,move_order) VALUES(g_id,new_player,vamp_name,0,vamp_owner,team,new_move_order);

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

END$$

DROP PROCEDURE IF EXISTS `lords`.`vampire_resurrect_by_u_id` $$

CREATE PROCEDURE `vampire_resurrect_by_u_id`(vamp_board_id INT,  u_id INT,  x INT,  y INT)
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
  DECLARE new_move_order INT;
  DECLARE size INT;
  DECLARE vamp_name VARCHAR(45) CHARSET utf8 DEFAULT '{vampire} {$u_id}';

  IF ((SELECT FLOOR(1 + (RAND() * dice_max)) FROM DUAL)>chance) THEN 
    SELECT bu.game_id,bu.player_num,p.team INTO g_id,p_num,team FROM board_units bu JOIN players p ON (bu.game_id=p.game_id AND bu.player_num=p.player_num) WHERE bu.id=vamp_board_id LIMIT 1;
    SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;

    SELECT CASE WHEN MAX(p.player_num)<10 THEN 10 ELSE MAX(p.player_num)+1 END INTO new_player FROM players p WHERE p.game_id=g_id;

    SET vamp_name=REPLACE(vamp_name,'$u_id', u_id);
    SET new_move_order = get_move_order_for_new_npc(g_id, p_num);

    UPDATE players SET move_order = move_order + 1 WHERE game_id = g_id AND move_order >= new_move_order;
    INSERT INTO players(game_id,player_num,name,gold,owner,team,move_order) VALUES(g_id,new_player,vamp_name,0,vamp_owner,team,new_move_order);

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

END$$

DROP PROCEDURE IF EXISTS `lords`.`zombies_make_mad` $$

CREATE PROCEDURE `zombies_make_mad`(g_id INT, nec_board_id INT)
BEGIN
  DECLARE zombie_board_id INT;
  DECLARE zombie_u_id INT;
  DECLARE zombie_p_num INT;
  DECLARE new_move_order INT;
  DECLARE new_player,team INT;
  DECLARE zombie_name_template VARCHAR(45) CHARSET utf8 DEFAULT '{zombie} {$u_id}';
  DECLARE zombie_name VARCHAR(45) CHARSET utf8;

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR
    SELECT buf.board_unit_id,bu.player_num,bu.unit_id
    FROM board_units_features buf JOIN board_units bu ON (buf.board_unit_id=bu.id)
    WHERE buf.feature_id=unit_feature_get_id_by_code('under_control') AND buf.param=nec_board_id;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;


  SELECT p.team INTO team FROM board_units bu JOIN players p ON (bu.game_id=p.game_id AND bu.player_num=p.player_num) WHERE bu.id=nec_board_id LIMIT 1;

  IF (team IS NULL) THEN
    SELECT MAX(p.team)+1 INTO team FROM players p WHERE p.game_id=g_id;
    SET done=0; 
  END IF;

  OPEN cur;
  REPEAT
    FETCH cur INTO zombie_board_id,zombie_p_num,zombie_u_id;
    IF NOT done THEN


      IF EXISTS(SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id AND bu.player_num=zombie_p_num AND bu.id<>zombie_board_id LIMIT 1)
        OR EXISTS(SELECT bb.id FROM board_buildings bb WHERE bb.game_id=g_id AND bb.player_num=zombie_p_num LIMIT 1)
      THEN

        SET zombie_name=REPLACE(zombie_name_template,'$u_id', zombie_u_id);
        SELECT CASE WHEN MAX(p.player_num)<10 THEN 10 ELSE MAX(p.player_num)+1 END INTO new_player FROM players p WHERE p.game_id=g_id;
        SET new_move_order = get_move_order_for_new_npc(g_id, (SELECT bu.player_num FROM board_units bu WHERE bu.id = nec_board_id LIMIT 1));

        UPDATE players SET move_order = move_order + 1 WHERE game_id = g_id AND move_order >= new_move_order;
        INSERT INTO players(game_id,player_num,name,gold,owner,team,move_order) VALUES(g_id,new_player,zombie_name,0,2,team,new_move_order);
        CALL cmd_add_player(g_id,new_player);

        UPDATE board_units SET player_num=new_player WHERE id=zombie_board_id;
        CALL cmd_unit_set_owner(g_id,zombie_p_num,zombie_board_id);

      END IF;
    END IF;
  UNTIL done END REPEAT;
  CLOSE cur;

END$$

DELIMITER ;

