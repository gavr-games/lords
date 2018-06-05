use lords;

DELIMITER $$

DROP FUNCTION IF EXISTS `lords`.`get_unit_team` $$

CREATE FUNCTION `get_unit_team`(board_unit_id INT) RETURNS int
BEGIN
  RETURN
    (SELECT p.team
      FROM board_units b
        JOIN players p ON (b.game_id = p.game_id AND b.player_num = p.player_num)
      WHERE b.id = board_unit_id
      LIMIT 1);
END$$

DROP FUNCTION IF EXISTS `lords`.`get_building_team` $$

CREATE FUNCTION `get_building_team`(board_building_id INT) RETURNS int
BEGIN
  RETURN
    (SELECT p.team
      FROM board_buildings b
        JOIN players p ON (b.game_id = p.game_id AND b.player_num = p.player_num)
      WHERE b.id = board_building_id
      LIMIT 1);
END$$

DROP FUNCTION IF EXISTS `lords`.`get_player_team` $$

CREATE FUNCTION `get_player_team`(g_id INT, p_num INT) RETURNS int
BEGIN
  RETURN (SELECT team FROM players WHERE game_id = g_id AND player_num = p_num LIMIT 1);
END$$

DROP FUNCTION IF EXISTS `lords`.`get_magic_field_factor` $$

CREATE FUNCTION `get_magic_field_factor`(g_id INT, p_num INT, x INT, y INT) RETURNS int(11)
BEGIN
  DECLARE result INT DEFAULT 1;
  DECLARE magic_tower_board_id INT;

  SELECT bb.id INTO magic_tower_board_id
    FROM board b_mt
      JOIN board_buildings bb ON (b_mt.ref=bb.id)
    WHERE bb.game_id=g_id AND b_mt.`type`<>'unit' AND building_feature_check(bb.id,'magic_increase')=1 AND check_building_deactivated(bb.id)=0
      AND x BETWEEN b_mt.x-bb.radius AND b_mt.x+bb.radius AND y BETWEEN b_mt.y-bb.radius AND b_mt.y+bb.radius
      AND NOT(x=b_mt.x AND y=b_mt.y)
      AND get_building_team(bb.id) = get_player_team(g_id, p_num) LIMIT 1;

  IF (magic_tower_board_id IS NOT NULL) THEN
    SET result = result * building_feature_get_param(magic_tower_board_id, 'magic_increase');
  END IF;

    RETURN result;
END$$

DROP PROCEDURE IF EXISTS `lords`.`coin_factory_income` $$

CREATE PROCEDURE `coin_factory_income`(g_id INT, board_building_id INT)
BEGIN
  DECLARE p_num INT;
  DECLARE board_unit_id INT;

  DECLARE radius INT;
  DECLARE x,y INT;

  DECLARE units_in_radius_count INT;
  DECLARE enemy_p_num INT;
  DECLARE enemies_in_radius_count INT;

  DECLARE done INT DEFAULT 0;


  DECLARE cur CURSOR FOR
    SELECT bu.player_num,COUNT(*)
      FROM board b
      JOIN board_units bu ON (b.ref=bu.id)
    WHERE
      b.game_id=g_id
      AND b.`type`='unit'
      AND b.x BETWEEN x-radius AND x+radius
      AND b.y BETWEEN y-radius AND y+radius
      AND (get_unit_team(bu.id) <> get_player_team(g_id, p_num))
    GROUP BY bu.player_num;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SELECT bb.radius,bb.player_num INTO radius,p_num FROM board_buildings bb WHERE bb.id=board_building_id LIMIT 1;
  SELECT b.x,b.y INTO x,y FROM board b WHERE b.game_id=g_id AND b.ref=board_building_id AND b.`type`<>'unit' LIMIT 1;

  SELECT COUNT(*) INTO units_in_radius_count FROM board b WHERE b.game_id=g_id AND b.type='unit'
    AND b.x BETWEEN x-radius AND x+radius 
    AND b.y BETWEEN y-radius AND y+radius;

  UPDATE players SET gold=gold+units_in_radius_count WHERE game_id=g_id AND player_num=p_num;
  CALL cmd_player_set_gold(g_id,p_num);

  OPEN cur;
  REPEAT
    FETCH cur INTO enemy_p_num,enemies_in_radius_count;
    IF NOT done THEN
      UPDATE players SET gold=CASE WHEN gold<enemies_in_radius_count THEN 0 ELSE gold-enemies_in_radius_count END WHERE game_id=g_id AND player_num=enemy_p_num;
      CALL cmd_player_set_gold(g_id,enemy_p_num);
    END IF;
  UNTIL done END REPEAT;
  CLOSE cur;

END$$

DROP PROCEDURE IF EXISTS `lords`.`healing_tower_heal` $$

CREATE PROCEDURE `healing_tower_heal`(g_id INT, board_building_id INT)
BEGIN
  DECLARE p_num INT;
  DECLARE board_unit_id INT;
  DECLARE obj_x,obj_y INT;

  DECLARE ht_radius INT;
  DECLARE ht_x,ht_y INT;


  DECLARE done INT DEFAULT 0;

  DECLARE cur CURSOR FOR
    SELECT bu.id, b.x, b.y
      FROM board b
      JOIN board_units bu ON (b.ref=bu.id)
    WHERE
      b.game_id=g_id
      AND b.`type`='unit'
      AND b.x BETWEEN ht_x-ht_radius AND ht_x+ht_radius
      AND b.y BETWEEN ht_y-ht_radius AND ht_y+ht_radius
      AND (get_unit_team(bu.id) = get_player_team(g_id, p_num) OR (unit_feature_check(bu.id,'madness')=1 AND unit_feature_get_param(bu.id,'madness') IN
          (SELECT pl.player_num FROM players pl WHERE pl.game_id = g_id AND pl.team = get_player_team(g_id, p_num))));

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SELECT bb.radius,bb.player_num INTO ht_radius,p_num FROM board_buildings bb WHERE bb.id=board_building_id LIMIT 1;
  SELECT b.x,b.y INTO ht_x,ht_y FROM board b WHERE b.game_id=g_id AND b.ref=board_building_id AND b.`type`<>'unit' LIMIT 1;

  OPEN cur;
  REPEAT
    FETCH cur INTO board_unit_id,obj_x,obj_y;
    IF NOT done THEN
      CALL magical_heal(g_id,p_num,obj_x,obj_y,1);
    END IF;
  UNTIL done END REPEAT;
  CLOSE cur;

END$$

DROP PROCEDURE IF EXISTS `lords`.`player_move_unit` $$

CREATE PROCEDURE `player_move_unit`(g_id INT, p_num INT, x INT, y INT, x2 INT, y2 INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE size INT;
  DECLARE moveable INT DEFAULT 0;
  DECLARE teleportable INT DEFAULT 0;
  DECLARE taran_unit_id INT;
  DECLARE taran_x,taran_y,taran_prev_x,taran_prev_y INT;
  DECLARE x0,y0 INT;

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'player_move_unit'); 
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
    SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;
    SELECT u.size INTO size FROM board_units bu JOIN units u ON (bu.unit_id=u.id) WHERE bu.id=board_unit_id LIMIT 1;

    SET moveable=check_one_step_from_unit(g_id,x,y,x2,y2);

    IF (moveable=0)AND(unit_feature_check(board_unit_id,'magic_immunity')=0) AND EXISTS
    (SELECT a.id FROM board_buildings bb,board b,allcoords a
      WHERE bb.game_id=g_id AND building_feature_check(bb.id,'teleport')=1 AND check_building_deactivated(bb.id)=0
      AND b.`type`<>'unit' AND b.ref=bb.id
      AND get_building_team(bb.id) = get_unit_team(board_unit_id)
      AND a.mode_id=mode_id
      AND a.x BETWEEN b.x-bb.radius AND b.x+bb.radius AND a.y BETWEEN b.y-bb.radius AND b.y+bb.radius
      AND a.x BETWEEN x2 AND x2+size-1 AND a.y BETWEEN y2 AND y2+size-1 LIMIT 1)
    THEN
      SET teleportable=1;
    END IF;
    IF moveable=0 AND teleportable=0
    THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=19;
    ELSE
      IF EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x BETWEEN x2 AND x2+size-1 AND b.y BETWEEN y2 AND y2+size-1 AND NOT(b.`type`='unit' AND b.ref=board_unit_id) LIMIT 1) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=12;
      ELSE

                CALL unit_action_begin(g_id, p_num);

                IF (unit_feature_get_param(board_unit_id,'bind_target') IS NOT NULL) THEN
                  CALL unit_feature_remove(board_unit_id,'bind_target');
                END IF; 

                SELECT MIN(b.x),MIN(b.y) INTO x0,y0 FROM board b WHERE b.game_id=g_id AND b.ref=board_unit_id AND b.`type`='unit';

                CALL move_unit(board_unit_id,x2,y2);
                UPDATE board_units bu SET bu.moves_left=CASE WHEN teleportable=1 THEN 0 ELSE bu.moves_left-1 END WHERE bu.id=board_unit_id;
                CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);


                SELECT bu.id INTO taran_unit_id FROM board_units bu WHERE unit_feature_get_param(bu.id,'bind_target')=board_unit_id LIMIT 1;
                IF taran_unit_id IS NOT NULL THEN
                  IF teleportable=1 THEN
                    CALL unit_feature_remove(taran_unit_id,'bind_target');
                  ELSE
                    IF (size=1) THEN
                      SET taran_x=x;
                      SET taran_y=y;
                    ELSE 
                      SELECT b.x,b.y INTO taran_prev_x,taran_prev_y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=taran_unit_id LIMIT 1;
                      SELECT a.x,a.y INTO taran_x,taran_y FROM allcoords a WHERE a.mode_id=mode_id AND a.x BETWEEN x0 AND x0+size-1 AND a.y BETWEEN y0 AND y0+size-1 AND a.x BETWEEN x2-1 AND x2+size AND a.y BETWEEN y2-1 AND y2+size AND NOT (a.x BETWEEN x2 AND x2+size-1 AND a.y BETWEEN y2 AND y2+size-1) ORDER BY ((taran_prev_x-a.x)*(taran_prev_x-a.x)+(taran_prev_y-a.y)*(taran_prev_y-a.y)) LIMIT 1;
                    END IF;
                    CALL move_unit(taran_unit_id,taran_x,taran_y);
                  END IF;
                END IF;

                CALL unit_action_end(g_id, p_num);
      END IF;
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`put_building` $$

CREATE PROCEDURE `put_building`(g_id INT, p_num INT, player_deck_id INT, x INT, y INT, rotation INT, flip INT)
BEGIN
  DECLARE crd_id INT;
  DECLARE err_code INT;
  DECLARE x_len,y_len INT;
  DECLARE x2,y2 INT; 
  DECLARE new_building_id INT;
  DECLARE card_cost INT;

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
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=11;
    ELSE
      CALL user_action_begin();

      INSERT INTO board_buildings(game_id,player_num,card_id,rotation,flip)VALUES (g_id,p_num,crd_id,rotation,flip);
      SET new_building_id=@@last_insert_id;

      CALL place_building_on_board(new_building_id,x,y,rotation,flip);

      IF NOT EXISTS(SELECT id FROM board WHERE game_id=g_id AND `type`<>'unit' AND ref=new_building_id) THEN 
        DELETE FROM board_buildings WHERE id=new_building_id;
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=12;
      ELSE

        INSERT INTO board_buildings_features(board_building_id,feature_id,param) SELECT new_building_id,bfu.feature_id,bfu.param FROM board_buildings bb JOIN building_default_features bfu ON (bb.building_id=bfu.building_id) WHERE bb.id=new_building_id;

        UPDATE board_buildings_features bbf
        SET param=get_new_team_number(g_id)
        WHERE bbf.board_building_id=new_building_id AND bbf.feature_id=building_feature_get_id_by_code('summon_team');

        IF(building_feature_check(new_building_id,'ally') = 1)THEN
          CALL building_feature_set(new_building_id,'summon_team',get_player_team(g_id, p_num));
        END IF;

        CALL count_income(new_building_id);

        CALL play_card_actions(g_id,p_num,player_deck_id); 


        CALL cmd_put_building_by_card(g_id,p_num,new_building_id);


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

DROP PROCEDURE IF EXISTS `lords`.`vampire_resurrect_by_card` $$

CREATE PROCEDURE `vampire_resurrect_by_card`(vamp_board_id INT, grave_id INT)
BEGIN
  DECLARE dead_card_id INT;
  DECLARE dice_max INT DEFAULT 2;
  DECLARE chance INT DEFAULT 1;
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE vamp_owner INT DEFAULT 4;
  DECLARE new_player INT;
  DECLARE new_unit_id INT;
  DECLARE new_move_order INT;
  DECLARE u_id INT;
  DECLARE vamp_name VARCHAR(45) CHARSET utf8 DEFAULT '{vampire} {$u_id}';

  IF get_random_int_between(1, dice_max) > chance THEN 
    SELECT bu.game_id, bu.player_num INTO g_id, p_num FROM board_units bu WHERE bu.id=vamp_board_id LIMIT 1;

    SELECT CASE WHEN MAX(p.player_num)<10 THEN 10 ELSE MAX(p.player_num)+1 END INTO new_player FROM players p WHERE p.game_id=g_id;

    SELECT g.card_id INTO dead_card_id FROM graves g WHERE id=grave_id;
    SELECT c.ref INTO u_id FROM cards c WHERE c.id=dead_card_id LIMIT 1;

    SET vamp_name=REPLACE(vamp_name,'$u_id', u_id);
    SET new_move_order = get_move_order_for_new_npc(g_id, p_num);

    UPDATE players SET move_order = move_order + 1 WHERE game_id = g_id AND move_order >= new_move_order;
    INSERT INTO players(game_id,player_num,name,gold,owner,team,move_order,language_id) VALUES(g_id,new_player,vamp_name,0,vamp_owner,get_unit_team(vamp_board_id),new_move_order,get_player_language_id(g_id,p_num));

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

CREATE PROCEDURE `vampire_resurrect_by_u_id`(vamp_board_id INT, u_id INT, x INT, y INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE dice_max INT DEFAULT 2;
  DECLARE chance INT DEFAULT 1;
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE vamp_owner INT DEFAULT 4;
  DECLARE new_player INT;
  DECLARE new_unit_id INT;
  DECLARE new_move_order INT;
  DECLARE size INT;
  DECLARE vamp_name VARCHAR(45) CHARSET utf8 DEFAULT '{vampire} {$u_id}';

  IF get_random_int_between(1, dice_max) > chance THEN 
    SELECT bu.game_id, bu.player_num INTO g_id, p_num FROM board_units bu WHERE bu.id=vamp_board_id LIMIT 1;
    SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;

    SELECT CASE WHEN MAX(p.player_num)<10 THEN 10 ELSE MAX(p.player_num)+1 END INTO new_player FROM players p WHERE p.game_id=g_id;

    SET vamp_name=REPLACE(vamp_name,'$u_id', u_id);
    SET new_move_order = get_move_order_for_new_npc(g_id, p_num);

    UPDATE players SET move_order = move_order + 1 WHERE game_id = g_id AND move_order >= new_move_order;
    INSERT INTO players(game_id,player_num,name,gold,owner,team,move_order,language_id) VALUES(g_id,new_player,vamp_name,0,vamp_owner,get_unit_team(vamp_board_id),new_move_order,get_player_language_id(g_id,p_num));

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

DROP FUNCTION IF EXISTS `lords`.`get_current_p_num` $$

CREATE FUNCTION `get_current_p_num`(g_id INT) RETURNS int
BEGIN
  RETURN (SELECT player_num FROM active_players WHERE game_id = g_id LIMIT 1);
END$$

DROP PROCEDURE IF EXISTS `lords`.`zombies_make_mad` $$

CREATE PROCEDURE `zombies_make_mad`(g_id INT, nec_board_id INT)
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

      END IF;
    END IF;
  UNTIL done END REPEAT;
  CLOSE cur;

END$$

DROP FUNCTION IF EXISTS `lords`.`check_building_deactivated` $$

CREATE FUNCTION `check_building_deactivated`(board_building_id INT) RETURNS int(11)
BEGIN

  IF EXISTS(SELECT b_n.id FROM board_units bu,board b_n,board_buildings bb, board b
    WHERE bb.id=board_building_id AND b.`type`<>'unit' AND b.ref=board_building_id
       AND bu.game_id=bb.game_id AND unit_feature_check(bu.id,'blocks_buildings')=1 AND b_n.`type`='unit' AND b_n.ref=bu.id
       AND b_n.x BETWEEN b.x-bb.radius AND b.x+bb.radius AND b_n.y BETWEEN b.y-bb.radius AND b.y+bb.radius
       AND get_unit_team(bu.id) <> get_building_team(bb.id) LIMIT 1)
  THEN RETURN 1;
  ELSE RETURN 0;
  END IF;
END$$

DELIMITER ;

