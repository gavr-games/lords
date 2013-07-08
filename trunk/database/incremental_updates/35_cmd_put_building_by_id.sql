use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cmd_put_building`$$

DROP PROCEDURE IF EXISTS `lords`.`cmd_put_building_by_card`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_put_building_by_card`(g_id INT,p_num INT,board_building_id INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'put_building($board_building_id,$p_num,$x,$y,$rotation,$flip,$card_id,$income)';
  DECLARE x,y INT;
  DECLARE rotation INT;
  DECLARE flip INT;
  DECLARE income INT;
  DECLARE card_id INT;

  SELECT MIN(b.x),MIN(b.y) INTO x,y FROM board b WHERE b.game_id=g_id AND b.`type`<>'unit' AND b.ref=board_building_id;
  SELECT bb.rotation,bb.flip,bb.card_id,bb.income INTO rotation,flip,card_id,income FROM board_buildings bb WHERE bb.id=board_building_id LIMIT 1;

  SET cmd=REPLACE(cmd,'$board_building_id',board_building_id);
  SET cmd=REPLACE(cmd,'$p_num',p_num);
  SET cmd=REPLACE(cmd,'$x',x);
  SET cmd=REPLACE(cmd,'$y',y);
  SET cmd=REPLACE(cmd,'$rotation',rotation);
  SET cmd=REPLACE(cmd,'$flip',flip);
  SET cmd=REPLACE(cmd,'$card_id',card_id);
  SET cmd=REPLACE(cmd,'$income',income);
  
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

END$$

DROP PROCEDURE IF EXISTS `lords`.`cmd_put_building_by_id`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cmd_put_building_by_id`(g_id INT,p_num INT,board_building_id INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'put_building_by_id($board_building_id,$p_num,$x,$y,$rotation,$flip,$building_id,$income)';
  DECLARE x,y INT;
  DECLARE rotation INT;
  DECLARE flip INT;
  DECLARE income INT;
  DECLARE building_id INT;

  SELECT MIN(b.x),MIN(b.y) INTO x,y FROM board b WHERE b.game_id=g_id AND b.`type`<>'unit' AND b.ref=board_building_id;
  SELECT bb.rotation,bb.flip,bb.income,bb.building_id INTO rotation,flip,income,building_id FROM board_buildings bb WHERE bb.id=board_building_id LIMIT 1;

  SET cmd=REPLACE(cmd,'$board_building_id',board_building_id);
  SET cmd=REPLACE(cmd,'$p_num',p_num);
  SET cmd=REPLACE(cmd,'$x',x);
  SET cmd=REPLACE(cmd,'$y',y);
  SET cmd=REPLACE(cmd,'$rotation',rotation);
  SET cmd=REPLACE(cmd,'$flip',flip);
  SET cmd=REPLACE(cmd,'$building_id',building_id);
  SET cmd=REPLACE(cmd,'$income',income);
  
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd);

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
  
  CALL cmd_put_building_by_id(g_id,neutral_p_num,new_board_building_id);
END$$

DROP PROCEDURE IF EXISTS `lords`.`destroy_castle`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `destroy_castle`(board_castle_id INT,p_num INT)
BEGIN
  DECLARE g_id INT;
  DECLARE g_mode INT;
  DECLARE p2_num INT; /*castle owner*/
  DECLARE destroyed_castle_x INT;
  DECLARE destroyed_castle_y INT;
  DECLARE destroyed_castle_rotation INT;
  DECLARE destroyed_castle_flip INT;
  DECLARE ruins_building_id INT;
  DECLARE ruins_board_building_id INT;
  DECLARE user_id INT;
  DECLARE mode_id INT;
  DECLARE game_type_id INT;
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_independent_message($p_num,"$log_building разрушен")';

  SELECT game_id,player_num INTO g_id,p2_num FROM board_buildings WHERE id=board_castle_id LIMIT 1;
  SELECT g.mode_id INTO g_mode FROM games g WHERE g.id=g_id LIMIT 1;

/*log*/
      SET cmd_log=REPLACE(cmd_log,'$p_num',p2_num);
      SET cmd_log=REPLACE(cmd_log,'$log_building',log_building(board_castle_id));
      INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

      INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'destroy_building',p2_num);

  SELECT bb.rotation,bb.flip INTO destroyed_castle_rotation,destroyed_castle_flip FROM board_buildings bb WHERE bb.id=board_castle_id LIMIT 1;
  SELECT MIN(b.x),MIN(b.y) INTO destroyed_castle_x,destroyed_castle_y FROM board b WHERE game_id=g_id AND `type`<>'unit' AND ref=board_castle_id;

  CALL delete_player_objects(g_id,p2_num);

/*insert ruins*/
  SELECT v.building_id INTO ruins_building_id FROM vw_mode_building_default_features v WHERE v.mode_id=g_mode AND v.feature_id=building_feature_get_id_by_code('ruins');

  INSERT INTO board_buildings(game_id,player_num,building_id,rotation,flip)VALUES (g_id,p2_num,ruins_building_id,destroyed_castle_rotation,destroyed_castle_flip);
  SET ruins_board_building_id=@@last_insert_id;

  CALL place_building_on_board(ruins_board_building_id,destroyed_castle_x,destroyed_castle_y,destroyed_castle_rotation,destroyed_castle_flip);

  CALL cmd_put_building_by_id(g_id,p2_num,ruins_board_building_id);

/*If his turn - end turn*/
  IF (SELECT player_num FROM active_players WHERE game_id=g_id LIMIT 1)=p2_num THEN
    CALL end_turn(g_id,p2_num);
  END IF;
/*spectator*/
  UPDATE players SET owner=0 WHERE game_id=g_id AND player_num=p2_num;

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

DROP PROCEDURE IF EXISTS `lords`.`put_building`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `put_building`(g_id INT,p_num INT,player_deck_id INT,x INT,y INT,rotation INT,flip INT)
BEGIN
  DECLARE crd_id INT;
  DECLARE err_code INT;
  DECLARE x_len,y_len INT;
  DECLARE x2,y2 INT; /*For determining whether whole building is in player's zone, if (x,y) and (x2,y2) are*/
  DECLARE new_building_id INT;
  DECLARE card_cost INT;
  DECLARE player_team INT;
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
        WHERE bbf.board_building_id=new_building_id AND bbf.feature_id=building_feature_get_id_by_code('summon_team');

/*barracks*/
        IF(building_feature_check(new_building_id,'ally') = 1)THEN
          SELECT p.team INTO player_team FROM players p WHERE p.game_id=g_id AND p.player_num=p_num;
          CALL building_feature_set(new_building_id,'summon_team',player_team);
        END IF;

        CALL count_income(new_building_id);

        CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

/*put building*/
        CALL cmd_put_building_by_card(g_id,p_num,new_building_id);

/*summon creatures*/
        IF EXISTS(SELECT sc.id FROM summon_cfg sc WHERE sc.building_id=(SELECT bb.building_id FROM board_buildings bb WHERE id=new_building_id)) THEN
          CALL summon_creatures(new_building_id);
        END IF;

        CALL finish_playing_card(g_id,p_num);
        CALL end_cards_phase(g_id,p_num);

        CALL user_action_end();
      END IF;
    END IF;
  END IF;
END$$

DROP PROCEDURE IF EXISTS `lords`.`wall_close`$$
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
      CALL cmd_put_building_by_id(g_id,p_num,board_building_id);
      CALL cmd_building_set_health(g_id,p_num,board_building_id);

      CALL building_feature_set(board_building_id,'turn_when_changed',current_turn);

/*log*/
      SET cmd_log=REPLACE(cmd_log,'$log_building',log_building(board_building_id));
      INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

      CALL user_action_end();
    END IF;
  END IF;
END$$

DROP PROCEDURE IF EXISTS `lords`.`wall_open`$$
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
      CALL cmd_put_building_by_id(g_id,p_num,board_building_id);
      CALL cmd_building_set_health(g_id,p_num,board_building_id);

      CALL building_feature_set(board_building_id,'turn_when_changed',current_turn);

/*log*/
      SET cmd_log=REPLACE(cmd_log,'$log_building',log_building(board_building_id));
      INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

      CALL user_action_end();
    END IF;
  END IF;
END$$

DELIMITER ;
