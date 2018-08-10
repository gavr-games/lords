use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`paralyse_unit` $$

CREATE PROCEDURE `paralyse_unit`(board_unit_id INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE shield INT;

  SELECT bu.game_id, bu.player_num INTO g_id, p_num FROM board_units bu WHERE bu.id = board_unit_id LIMIT 1;

  SELECT bu.shield INTO shield FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

  IF unit_feature_check(board_unit_id,'magic_immunity') = 0 THEN
    IF shield > 0 THEN
      CALL shield_off(board_unit_id);
    ELSE
      CALL unit_feature_set(board_unit_id,'paralich',null);
      CALL cmd_unit_add_effect(g_id, board_unit_id,'paralich');
    END IF;
  ELSE
    CALL cmd_magic_resistance_log(g_id, p_num, board_unit_id);
  END IF;

END$$


DROP PROCEDURE IF EXISTS `lords`.`cast_paralich` $$

CREATE PROCEDURE `cast_paralich`(g_id INT,  p_num INT,  player_deck_id INT,  x INT,  y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE shield INT;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_paralich');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      CALL user_action_begin(g_id, p_num);

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;
      CALL paralyse_unit(board_unit_id);

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end(g_id, p_num);
    END IF;
  END IF;

END$$


DROP PROCEDURE IF EXISTS `lords`.`buidling_paralyse_enemies` $$

CREATE PROCEDURE `buidling_paralyse_enemies`(board_building_id INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;

  DECLARE radius INT;
  DECLARE building_x, building_y INT;

  DECLARE board_unit_id INT;

  DECLARE done INT DEFAULT 0;

  DECLARE cur CURSOR FOR
    SELECT bu.id
      FROM board b
      JOIN board_units bu ON (b.ref=bu.id)
    WHERE
      b.game_id = g_id
      AND b.`type`='unit'
      AND b.x BETWEEN building_x - radius AND building_x + radius
      AND b.y BETWEEN building_y - radius AND building_y + radius
      AND get_unit_team(bu.id) <> get_player_team(g_id, p_num)
      AND unit_feature_check(bu.id, 'paralich') = 0;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  IF check_building_deactivated(board_building_id) = 0 THEN
    SELECT bb.radius, bb.player_num, bb.game_id INTO radius, p_num, g_id FROM board_buildings bb
      WHERE bb.id = board_building_id LIMIT 1;
    SELECT b.x, b.y INTO building_x, building_y FROM board b
      WHERE b.game_id = g_id AND b.ref = board_building_id AND b.`type`<>'unit' LIMIT 1;

    OPEN cur;
    REPEAT
      FETCH cur INTO board_unit_id;
      IF NOT done THEN
        CALL paralyse_unit(board_unit_id);
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`put_building` $$

CREATE PROCEDURE `put_building`(g_id INT,    p_num INT,    player_deck_id INT,    x INT,    y INT,    rotation INT,    flip INT)
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
        
        IF building_feature_check(new_building_id, 'paralysing') THEN
          CALL buidling_paralyse_enemies(new_building_id);
        END IF;

        CALL finish_playing_card(g_id,p_num);
        CALL end_cards_phase(g_id,p_num);
        CALL user_action_end(g_id, p_num);
      END IF;
    END IF;
  END IF;
END$$

DROP PROCEDURE IF EXISTS `lords`.`cast_relocation` $$

CREATE PROCEDURE `cast_relocation`(g_id INT,  p_num INT,  player_deck_id INT,  b_x INT,  b_y INT,  x INT,  y INT,  rot INT,  flp INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_building_id INT;
  DECLARE log_msg_code VARCHAR(50) CHARSET utf8 DEFAULT 'building_moved';

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_relocation');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    SELECT b.ref INTO board_building_id FROM board b WHERE b.game_id=g_id AND b.`type` IN ('building','obstacle') AND b.x=b_x AND b.y=b_y LIMIT 1;
    IF board_building_id IS NULL THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='building_not_selected';
    ELSE
      IF building_feature_check(board_building_id,'not_movable')=1 THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='moving_this_building_disallowed';
      ELSE
        UPDATE board SET ref=0 WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=board_building_id;
        CALL place_building_on_board(board_building_id,x,y,rot,flp);

        IF NOT EXISTS(SELECT id FROM board WHERE game_id=g_id AND `type`<>'unit' AND ref=board_building_id) THEN 
          UPDATE board SET ref=board_building_id WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0;
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='place_occupied';
        ELSE

          CALL user_action_begin(g_id, p_num);
          CALL play_card_actions(g_id,p_num,player_deck_id); 
            
          DELETE FROM board WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0;
          UPDATE board_buildings SET rotation=rot,flip=flp WHERE id=board_building_id;

          CALL count_income(board_building_id);

          CALL cmd_move_building(g_id,p_num,b_x,b_y,board_building_id);
          CALL cmd_log_add_message(g_id, p_num, log_msg_code, CONCAT_WS(';', log_building(board_building_id), log_cell(b_x, b_y)));

          IF building_feature_check(board_building_id, 'paralysing') THEN
            CALL buidling_paralyse_enemies(board_building_id);
          END IF;

          CALL finish_playing_card(g_id,p_num);
          CALL end_cards_phase(g_id,p_num);
          CALL user_action_end(g_id, p_num);
        END IF;
      END IF;
    END IF;
  END IF;
END$$


DROP PROCEDURE IF EXISTS `lords`.`cast_capture` $$

CREATE PROCEDURE `cast_capture`(g_id INT,  p_num INT,  player_deck_id INT,  b_x INT,  b_y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_building_id INT;
  DECLARE log_msg_code VARCHAR(50) CHARSET utf8 DEFAULT 'building_captured';

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_capture');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    SELECT b.ref INTO board_building_id FROM board b WHERE b.game_id=g_id AND b.`type`='building' AND b.x=b_x AND b.y=b_y LIMIT 1;
    IF board_building_id IS NULL THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code='building_not_selected';
    ELSE
        CALL user_action_begin(g_id, p_num);
        CALL play_card_actions(g_id,p_num,player_deck_id); 

        IF p_num = (SELECT bb.player_num FROM board_buildings bb WHERE bb.id = board_building_id) THEN
          SET log_msg_code = 'building_captured_own';
        END IF;

        CALL cmd_log_add_message(g_id, p_num, log_msg_code, CONCAT_WS(';', log_building(board_building_id), log_player(g_id, p_num)));

        UPDATE board_buildings SET player_num=p_num WHERE id=board_building_id;

        IF(building_feature_check(board_building_id,'ally') = 1)THEN
          CALL building_feature_set(board_building_id,'summon_team',get_player_team(g_id, p_num));
        END IF;

        CALL count_income(board_building_id);
        CALL cmd_building_set_owner(g_id,p_num,board_building_id);

        IF building_feature_check(board_building_id, 'paralysing') THEN
          CALL buidling_paralyse_enemies(board_building_id);
        END IF;

        CALL finish_playing_card(g_id,p_num);
        CALL end_cards_phase(g_id,p_num);
        CALL user_action_end(g_id, p_num);
    END IF;
  END IF;
END$$

DROP FUNCTION IF EXISTS `lords`.`check_unit_in_paralysing_range` $$

CREATE FUNCTION `check_unit_in_paralysing_range`(board_unit_id INT) RETURNS int(11)
BEGIN
  RETURN EXISTS
  (
    SELECT 1 FROM
      board_units bu
      JOIN board b_unit ON (bu.id = b_unit.ref AND b_unit.type = 'unit')
      JOIN board_buildings bb ON (bb.game_id = bu.game_id)
      JOIN board b_building ON (bb.id = b_building.ref AND b_building.type <> 'unit')
      WHERE
        bu.id = board_unit_id
        AND building_feature_check(bb.id, 'paralysing')
        AND NOT check_building_deactivated(bb.id)
        AND get_unit_team(bu.id) <> get_building_team(bb.id)
        AND b_unit.x BETWEEN b_building.x - bb.radius AND b_building.x + bb.radius
        AND b_unit.y BETWEEN b_building.y - bb.radius AND b_building.y + bb.radius
  );
END$$

DROP PROCEDURE IF EXISTS `lords`.`move_unit` $$

CREATE PROCEDURE `move_unit`(board_unit_id INT,  x2 INT,  y2 INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE x,y INT;
  DECLARE delta_x,delta_y INT;
  DECLARE u_id INT;

  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_move_message($x,$y,$x2,$y2,$p_num,$unit_id,"$npc_name")';

  SELECT bu.game_id,bu.player_num,bu.unit_id INTO g_id,p_num,u_id FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;
  SELECT MIN(b.x),MIN(b.y) INTO x,y FROM board b WHERE b.`type`='unit' AND b.ref=board_unit_id;
  SET delta_x=x2-x;
  SET delta_y=y2-y;
  UPDATE board b SET b.x=b.x+delta_x,b.y=b.y+delta_y WHERE b.`type`='unit' AND b.ref=board_unit_id;

  CALL cmd_move_unit(g_id,p_num,x,y,x2,y2);

  SET cmd_log=REPLACE(cmd_log,'$p_num',p_num);
  SET cmd_log=REPLACE(cmd_log,'$unit_id',u_id);
  SET cmd_log=REPLACE(cmd_log,'$x,$y',CONCAT(x,',',y));
  SET cmd_log=REPLACE(cmd_log,'$x2,$y2',CONCAT(x2,',',y2));
  IF ((SELECT p.owner FROM players p WHERE p.game_id = g_id AND p.player_num = p_num LIMIT 1) <> 1) THEN
    SET cmd_log=REPLACE(cmd_log,'$npc_name', (SELECT p.name FROM players p WHERE p.game_id = g_id AND p.player_num = p_num LIMIT 1));
  ELSE
    SET cmd_log=REPLACE(cmd_log,'$npc_name', '');
  END IF;
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);
  
  IF check_unit_in_paralysing_range(board_unit_id) THEN
    CALL paralyse_unit(board_unit_id);
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`zombies_make_mad` $$

CREATE PROCEDURE `zombies_make_mad`(g_id INT,  nec_board_id INT)
BEGIN
  DECLARE zombie_board_id INT;
  DECLARE zombie_u_id INT;
  DECLARE zombie_p_num INT;
  DECLARE new_move_order INT;
  DECLARE new_player, team INT;
  DECLARE zombie_name_template VARCHAR(45) CHARSET utf8 DEFAULT '{zombie} {$u_id}';
  DECLARE zombie_name VARCHAR(45) CHARSET utf8;

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR
    SELECT buf.board_unit_id,bu.player_num,bu.unit_id
    FROM board_units_features buf JOIN board_units bu ON (buf.board_unit_id=bu.id)
    WHERE buf.feature_id=unit_feature_get_id_by_code('under_control') AND buf.param=nec_board_id;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  IF EXISTS (SELECT bu.id FROM board_units bu WHERE bu.id=nec_board_id LIMIT 1) THEN
    SET team = get_unit_team(nec_board_id);
  ELSE
    SET team = get_new_team_number(g_id);
  END IF;

  SET done=0;
  OPEN cur;
  REPEAT
    FETCH cur INTO zombie_board_id,zombie_p_num,zombie_u_id;
    IF NOT done THEN

      IF EXISTS(SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id AND bu.player_num=zombie_p_num AND bu.id<>zombie_board_id LIMIT 1)
        OR EXISTS(SELECT bb.id FROM board_buildings bb WHERE bb.game_id=g_id AND bb.player_num=zombie_p_num LIMIT 1)
      THEN

        SET zombie_name=REPLACE(zombie_name_template,'$u_id', zombie_u_id);
        SELECT CASE WHEN MAX(p.player_num)<10 THEN 10 ELSE MAX(p.player_num)+1 END INTO new_player FROM players p WHERE p.game_id=g_id;
        SET new_move_order = get_move_order_for_new_npc(g_id, get_current_p_num(g_id));

        UPDATE players SET move_order = move_order + 1 WHERE game_id = g_id AND move_order >= new_move_order;
        INSERT INTO players(game_id,player_num,name,gold,owner,team,move_order,language_id) VALUES(g_id,new_player,zombie_name,0,2,team,new_move_order,get_player_language_id(g_id, zombie_p_num));
        CALL cmd_add_player(g_id,new_player);

        UPDATE board_units SET player_num=new_player WHERE id=zombie_board_id;
        CALL cmd_unit_set_owner(g_id,zombie_p_num,zombie_board_id);

        IF check_unit_in_paralysing_range(zombie_board_id) THEN
          CALL paralyse_unit(zombie_board_id);
        END IF;

      END IF;
    END IF;
  UNTIL done END REPEAT;
  CLOSE cur;

END$$


DROP PROCEDURE IF EXISTS `lords`.`cast_mind_control` $$

CREATE PROCEDURE `cast_mind_control`(g_id INT,   p_num INT,   player_deck_id INT,   x INT,   y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE p2_num INT;
  DECLARE shield INT;
  DECLARE npc_gold INT;
  DECLARE log_msg_code VARCHAR(50) CHARSET utf8 DEFAULT 'mind_control';

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_mind_control');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      CALL user_action_begin(g_id, p_num);

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;
      SELECT bu.player_num INTO p2_num FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;
      SELECT bu.shield INTO shield FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

      IF (unit_feature_check(board_unit_id,'magic_immunity')=0) THEN

        IF shield>0 THEN
          CALL shield_off(board_unit_id);
        ELSE

          IF(unit_feature_check(board_unit_id,'under_control')=1)THEN
            CALL unit_feature_remove(board_unit_id,'under_control');
          END IF;

          IF(unit_feature_check(board_unit_id,'madness')=1)THEN
            CALL unit_feature_set(board_unit_id,'madness',p_num);
            CALL make_not_mad(board_unit_id);
          END IF;

          IF(p_num<>p2_num)THEN
            UPDATE board_units SET player_num=p_num,moves_left=0 WHERE id=board_unit_id;
            CALL cmd_unit_set_owner(g_id,p_num,board_unit_id);
            CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

            IF (((SELECT owner FROM players WHERE game_id=g_id AND player_num=p2_num LIMIT 1)<>1)
              AND NOT EXISTS (SELECT id FROM board_units WHERE game_id=g_id AND player_num=p2_num)
              AND NOT EXISTS (SELECT id FROM board_buildings WHERE game_id=g_id AND player_num=p2_num))
            THEN
              SELECT gold INTO npc_gold FROM players WHERE game_id=g_id AND player_num=p2_num LIMIT 1; 
              IF(npc_gold>0)THEN
                UPDATE players SET gold=gold+npc_gold WHERE game_id=g_id AND player_num=p_num;
                CALL cmd_player_set_gold(g_id,p_num);
              END IF;

              DELETE FROM players WHERE game_id=g_id AND player_num=p2_num; 
              CALL cmd_delete_player(g_id,p2_num);
            END IF;

          ELSE
            SET log_msg_code = 'mind_control_own_unit';
          END IF;


          IF EXISTS(SELECT id FROM board_units_features WHERE feature_id=unit_feature_get_id_by_code('under_control') AND param=board_unit_id LIMIT 1)THEN
            CALL zombies_change_player_to_nec(board_unit_id);
          END IF;

          CALL cmd_log_add_message(g_id, p_num, log_msg_code, CONCAT_WS(';', log_unit(board_unit_id), log_player(g_id, p_num)));

          IF check_unit_in_paralysing_range(board_unit_id) THEN
            CALL paralyse_unit(board_unit_id);
          END IF;

        END IF;
      ELSE
        CALL cmd_magic_resistance_log(g_id,p_num,board_unit_id);
      END IF;

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end(g_id, p_num);
    END IF;
  END IF;

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
      SET team = get_new_team_number(g_id);
      SELECT CASE WHEN MAX(p.player_num)<10 THEN 10 ELSE MAX(p.player_num)+1 END INTO new_player FROM players p WHERE p.game_id=g_id;
      SET mad_move_order = get_move_order_for_new_npc(g_id, (SELECT player_num FROM active_players WHERE game_id=g_id LIMIT 1));

      UPDATE players SET move_order = move_order + 1 WHERE game_id = g_id AND move_order >= mad_move_order;
      INSERT INTO players(game_id,player_num,name,gold,owner,team,move_order,language_id) VALUES(g_id,new_player,mad_name,0,2,team,mad_move_order,get_player_language_id(g_id,p_num));
      CALL cmd_add_player(g_id,new_player);

      UPDATE board_units SET player_num=new_player WHERE id=board_unit_id;
      CALL cmd_unit_set_owner(g_id,p_num,board_unit_id);

      IF EXISTS(SELECT id FROM board_units_features WHERE feature_id=unit_feature_get_id_by_code('under_control') AND param=board_unit_id LIMIT 1)THEN
        CALL zombies_make_mad(g_id,board_unit_id);
      END IF;

      IF check_unit_in_paralysing_range(board_unit_id) THEN
        CALL paralyse_unit(board_unit_id);
      END IF;

    END;
    END IF;
  ELSE
    CALL cmd_log_add_message(g_id, p_num, 'unit_already_mad', log_unit(board_unit_id));
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`zombies_change_player_to_nec` $$

CREATE PROCEDURE `zombies_change_player_to_nec`(nec_board_id INT)
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

          UPDATE board_units SET player_num=nec_p_num,moves_left=0 WHERE id=zombie_board_id;
          CALL cmd_unit_set_owner(g_id,nec_p_num,zombie_board_id);
          CALL cmd_unit_set_moves_left(g_id,nec_p_num,zombie_board_id);

          IF ((SELECT owner FROM players WHERE game_id=g_id AND player_num=zombie_p_num LIMIT 1)<>1)
            AND NOT EXISTS (SELECT id FROM board_units WHERE game_id=g_id AND player_num=zombie_p_num)
            AND NOT EXISTS (SELECT id FROM board_buildings WHERE game_id=g_id AND player_num=zombie_p_num)
          THEN
            SELECT gold INTO npc_gold FROM players WHERE game_id=g_id AND player_num=zombie_p_num LIMIT 1; 
            IF(npc_gold>0)THEN
              UPDATE players SET gold = gold + npc_gold WHERE game_id = g_id AND player_num = nec_p_num;
              CALL cmd_player_set_gold(g_id,nec_p_num);
            END IF;

            DELETE FROM players WHERE game_id=g_id AND player_num=zombie_p_num; 
            CALL cmd_delete_player(g_id,zombie_p_num);
          END IF;

          IF check_unit_in_paralysing_range(zombie_board_id) THEN
            CALL paralyse_unit(zombie_board_id);
          END IF;

      END IF;
    UNTIL done END REPEAT;
    CLOSE cur;


END$$

