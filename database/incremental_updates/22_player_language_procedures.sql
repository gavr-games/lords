use lords;

DELIMITER $$

DROP FUNCTION IF EXISTS `lords`.`get_player_language_id` $$

CREATE FUNCTION `get_player_language_id`(g_id INT, p_num INT) RETURNS int(11)
BEGIN
  DECLARE result INT;

  SELECT language_id INTO result FROM players WHERE game_id = g_id AND player_num = p_num;

  RETURN result;
END$$

DROP PROCEDURE IF EXISTS `lords`.`cast_vampire` $$

CREATE PROCEDURE `cast_vampire`(g_id INT,   p_num INT,   player_deck_id INT,   x INT,   y INT)
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

        SET team = get_new_team_number(g_id);
        SELECT CASE WHEN MAX(p.player_num)<10 THEN 10 ELSE MAX(p.player_num)+1 END INTO new_player FROM players p WHERE p.game_id=g_id;

        SELECT vu.id INTO vamp_u_id FROM vw_mode_units vu WHERE vu.mode_id=mode_id AND vu.ui_code=vamp_ui_code;
        SET vamp_name = CONCAT('{', vamp_u_id, '}');
        SET vamp_move_order = get_move_order_for_new_npc(g_id, p_num);
        
        UPDATE players SET move_order = move_order + 1 WHERE game_id = g_id AND move_order >= vamp_move_order;
        INSERT INTO players(game_id,player_num,name,gold,owner,team,move_order,language_id) VALUES(g_id,new_player,vamp_name,0,vamp_owner,team,vamp_move_order,get_player_language_id(g_id,p_num));
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
    END;
    END IF;
  ELSE
    CALL cmd_log_add_message(g_id, p_num, 'unit_already_mad', log_unit(board_unit_id));
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`summon_creature` $$

CREATE PROCEDURE `summon_creature`(g_id INT,   cr_owner INT ,  cr_unit_id INT ,  x INT ,  y INT,   parent_building_id INT)
BEGIN
  DECLARE new_player,team INT;
  DECLARE new_unit_id INT;
  DECLARE new_move_order INT;
  DECLARE cr_player_name VARCHAR(45) CHARSET utf8;
  DECLARE current_p_num INT;

    SELECT CASE WHEN MAX(p.player_num)<10 THEN 10 ELSE MAX(p.player_num)+1 END INTO new_player FROM players p WHERE p.game_id=g_id;
    SET team=building_feature_get_param(parent_building_id,'summon_team');
    SET cr_player_name = CONCAT('{', cr_unit_id, '}');
    SELECT player_num INTO current_p_num FROM active_players WHERE game_id=g_id LIMIT 1;
    SET new_move_order = get_move_order_for_new_npc(g_id, current_p_num);

    UPDATE players SET move_order = move_order + 1 WHERE game_id = g_id AND move_order >= new_move_order;
    INSERT INTO players(game_id,player_num,name,gold,owner,team,move_order,language_id) VALUES(g_id,new_player,cr_player_name,0,cr_owner,team,new_move_order,get_player_language_id(g_id,current_p_num));

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

CREATE PROCEDURE `vampire_resurrect_by_card`(vamp_board_id INT,    grave_id INT)
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
    INSERT INTO players(game_id,player_num,name,gold,owner,team,move_order,language_id) VALUES(g_id,new_player,vamp_name,0,vamp_owner,team,new_move_order,get_player_language_id(g_id,p_num));

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

CREATE PROCEDURE `vampire_resurrect_by_u_id`(vamp_board_id INT,   u_id INT,   x INT,   y INT)
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
    INSERT INTO players(game_id,player_num,name,gold,owner,team,move_order,language_id) VALUES(g_id,new_player,vamp_name,0,vamp_owner,team,new_move_order,get_player_language_id(g_id,p_num));

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

CREATE PROCEDURE `zombies_make_mad`(g_id INT,  nec_board_id INT)
BEGIN
  DECLARE zombie_board_id INT;
  DECLARE zombie_u_id INT;
  DECLARE zombie_p_num INT;
  DECLARE new_move_order INT;
  DECLARE new_player,team INT;
  DECLARE zombie_name_template VARCHAR(45) CHARSET utf8 DEFAULT '{zombie} {$u_id}';
  DECLARE zombie_name VARCHAR(45) CHARSET utf8;
  DECLARE nec_p_num INT;

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR
    SELECT buf.board_unit_id,bu.player_num,bu.unit_id
    FROM board_units_features buf JOIN board_units bu ON (buf.board_unit_id=bu.id)
    WHERE buf.feature_id=unit_feature_get_id_by_code('under_control') AND buf.param=nec_board_id;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;


  SELECT p.team, bu.player_num INTO team, nec_p_num FROM board_units bu JOIN players p ON (bu.game_id=p.game_id AND bu.player_num=p.player_num) WHERE bu.id=nec_board_id LIMIT 1;

  IF (team IS NULL) THEN
    SET team = get_new_team_number(g_id);
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
        INSERT INTO players(game_id,player_num,name,gold,owner,team,move_order,language_id) VALUES(g_id,new_player,zombie_name,0,2,team,new_move_order,get_player_language_id(g_id,nec_p_num));
        CALL cmd_add_player(g_id,new_player);

        UPDATE board_units SET player_num=new_player WHERE id=zombie_board_id;
        CALL cmd_unit_set_owner(g_id,zombie_p_num,zombie_board_id);

      END IF;
    END IF;
  UNTIL done END REPEAT;
  CLOSE cur;

END$$

DROP PROCEDURE IF EXISTS `lords`.`get_unit_phrase` $$

CREATE PROCEDURE `get_unit_phrase`(g_id INT)
BEGIN
  DECLARE random_row INT;
  DECLARE board_unit_id INT;
  DECLARE unit_id INT;
  DECLARE phrase_id INT;
  DECLARE p_num INT;
  DECLARE lang_id INT;

  IF EXISTS(SELECT 1 FROM board_units bu WHERE bu.game_id=g_id LIMIT 1)THEN
    CREATE TEMPORARY TABLE tmp_units (id_rand INT AUTO_INCREMENT PRIMARY KEY)AUTO_INCREMENT=1
      SELECT
        bu.id AS `board_unit_id`,
        bu.unit_id AS `unit_id`,
        bu.player_num
      FROM board_units bu
      WHERE bu.game_id=g_id;

    SELECT FLOOR(1 + (RAND() * MAX(id_rand))) INTO random_row FROM tmp_units;
    SELECT t.board_unit_id,t.unit_id,t.player_num INTO board_unit_id,unit_id,p_num FROM tmp_units t WHERE t.id_rand=random_row LIMIT 1;
    SET lang_id = get_player_language_id(g_id,p_num);
    DROP TEMPORARY TABLE tmp_units;

    IF EXISTS(SELECT 1 FROM dic_unit_phrases d WHERE d.unit_id=unit_id AND d.language_id = lang_id LIMIT 1)THEN
      CREATE TEMPORARY TABLE tmp_unit_phrases (id_rand INT AUTO_INCREMENT PRIMARY KEY)AUTO_INCREMENT=1
        SELECT
          d.id
        FROM dic_unit_phrases d
        WHERE d.unit_id=unit_id AND d.language_id = lang_id;

      SELECT FLOOR(1 + (RAND() * MAX(id_rand))) INTO random_row FROM tmp_unit_phrases;
      SELECT t.id INTO phrase_id FROM tmp_unit_phrases t WHERE t.id_rand=random_row LIMIT 1;
      DROP TEMPORARY TABLE tmp_unit_phrases;

      SELECT board_unit_id,phrase_id FROM DUAL;

    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`mode_copy` $$

CREATE PROCEDURE `mode_copy`(old_mode_id INT,  mode_name VARCHAR(45) CHARSET utf8,  copy_cards_units_buildings INT)
BEGIN
    DECLARE new_mode_id INT;

    INSERT INTO modes(name,min_players,max_players)
    SELECT mode_name,m.min_players,m.max_players FROM modes m WHERE m.id = old_mode_id;
    SET new_mode_id = @@last_insert_id;

    INSERT INTO player_start_gold_config(player_num,quantity,mode_id)
    SELECT c.player_num,c.quantity,new_mode_id FROM player_start_gold_config c WHERE c.mode_id = old_mode_id;

    INSERT INTO player_start_deck_config(player_num,quantity,`type`,mode_id)
    SELECT c.player_num,c.quantity,c.`type`,new_mode_id FROM player_start_deck_config c WHERE c.mode_id = old_mode_id;

    INSERT INTO modes_other_procedures(mode_id,procedure_id)
    SELECT new_mode_id,m.procedure_id FROM modes_other_procedures m WHERE m.mode_id = old_mode_id;

    INSERT INTO allcoords(x,y,mode_id)
    SELECT a.x,a.y,new_mode_id FROM allcoords a WHERE a.mode_id = old_mode_id;

    INSERT INTO appear_points(player_num,x,y,direction_into_board_x,direction_into_board_y,mode_id)
    SELECT a.player_num,a.x,a.y,a.direction_into_board_x,a.direction_into_board_y,new_mode_id FROM appear_points a WHERE a.mode_id = old_mode_id;

    INSERT INTO mode_config(param,`value`,mode_id)
    SELECT c.param,c.`value`,new_mode_id FROM mode_config c WHERE c.mode_id = old_mode_id;

    INSERT INTO statistic_values_config(player_num,chart_id,measure_id,color,name,mode_id)
    SELECT c.player_num,c.chart_id,c.measure_id,c.color,c.name,new_mode_id FROM statistic_values_config c WHERE c.mode_id = old_mode_id;

    IF(copy_cards_units_buildings = 0)THEN
        INSERT INTO modes_cards(mode_id,card_id,quantity)
        SELECT new_mode_id,mc.card_id,mc.quantity FROM modes_cards mc WHERE mc.mode_id=old_mode_id;

        INSERT INTO put_start_buildings_config(player_num,x,y,rotation,flip,building_id,mode_id)
        SELECT c.player_num,c.x,c.y,c.rotation,c.flip,c.building_id,new_mode_id FROM put_start_buildings_config c WHERE c.mode_id=old_mode_id;

        INSERT INTO modes_cardless_buildings(mode_id,building_id)
        SELECT new_mode_id,cb.building_id FROM modes_cardless_buildings cb WHERE cb.mode_id=old_mode_id;

        INSERT INTO put_start_units_config(player_num,x,y,unit_id,mode_id)
        SELECT c.player_num,c.x,c.y,c.unit_id,new_mode_id FROM put_start_units_config c WHERE c.mode_id=old_mode_id;

        INSERT INTO modes_cardless_units(mode_id,unit_id)
        SELECT new_mode_id,cu.unit_id FROM modes_cardless_units cu WHERE cu.mode_id=old_mode_id;

        INSERT INTO summon_cfg(building_id,unit_id,`count`,owner,mode_id)
        SELECT c.building_id,c.unit_id,c.`count`,c.owner,new_mode_id FROM summon_cfg c WHERE c.mode_id=old_mode_id;

        INSERT INTO attack_bonus(mode_id,unit_id,aim_type,aim_id,dice_max,chance,critical_chance,damage_bonus,critical_bonus,priority,`comment`)
        SELECT new_mode_id,ab.unit_id,ab.aim_type,ab.aim_id,ab.dice_max,ab.chance,ab.critical_chance,ab.damage_bonus,ab.critical_bonus,ab.priority,ab.`comment` FROM attack_bonus ab WHERE ab.mode_id = old_mode_id;

    ELSE
    BEGIN
        DECLARE card_id_old INT;
        DECLARE card_id_new INT;
        DECLARE card_image VARCHAR(45) CHARSET utf8;
        DECLARE card_cost INT;
        DECLARE card_type VARCHAR(45) CHARSET utf8;
        DECLARE card_ref INT;

        DECLARE building_id_old INT;
        DECLARE building_id_new INT;
        DECLARE building_health INT;
        DECLARE building_radius INT;
        DECLARE building_x_len INT;
        DECLARE building_y_len INT;
        DECLARE building_shape VARCHAR(400) CHARSET utf8;
        DECLARE building_type VARCHAR(45) CHARSET utf8;
        DECLARE building_ui_code VARCHAR(45) CHARSET utf8;

        DECLARE unit_id_old INT;
        DECLARE unit_id_new INT;
        DECLARE unit_moves INT;
        DECLARE unit_health INT;
        DECLARE unit_attack INT;
        DECLARE unit_size INT;
        DECLARE unit_shield INT;
        DECLARE unit_ui_code VARCHAR(45) CHARSET utf8;

        DECLARE done INT DEFAULT 0;
        DECLARE cur_cards CURSOR FOR SELECT c.id,c.image,c.cost,c.`type`,c.ref FROM vw_mode_cards c WHERE c.mode_id=old_mode_id;
        DECLARE cur_buildings CURSOR FOR SELECT b.id,b.health,b.radius,b.x_len,b.y_len,b.shape, b.`type`,b.ui_code FROM vw_mode_buildings b WHERE b.mode_id=old_mode_id;
        DECLARE cur_units CURSOR FOR SELECT u.id,u.moves,u.health,u.attack,u.size,u.shield,u.ui_code FROM vw_mode_units u WHERE u.mode_id=old_mode_id;
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

        CREATE TEMPORARY TABLE cards_ids (id_old INT,id_new INT);
        CREATE TEMPORARY TABLE buildings_ids (id_old INT,id_new INT);
        CREATE TEMPORARY TABLE units_ids (id_old INT,id_new INT);

        OPEN cur_cards;
        REPEAT
            FETCH cur_cards INTO card_id_old,card_image,card_cost,card_type,card_ref;
            IF NOT done THEN
                INSERT INTO cards(image,cost,`type`,ref,name,description)
                VALUES(card_image,card_cost,card_type,card_ref,card_name,card_description);
                SET card_id_new = @@last_insert_id;

                INSERT INTO cards_ids(id_old,id_new) VALUES(card_id_old,card_id_new);

                INSERT INTO cards_procedures(card_id,procedure_id)
                SELECT card_id_new,cp.procedure_id FROM cards_procedures cp WHERE cp.card_id=card_id_old;

                INSERT INTO modes_cards(mode_id,card_id,quantity)
                SELECT new_mode_id,card_id_new,mc.quantity FROM modes_cards mc WHERE mc.mode_id=old_mode_id AND mc.card_id=card_id_old;
                
                INSERT INTO cards_i18n(card_id,language_id,name,description)
                SELECT card_id_new, ci.language_id, ci.name, ci.description FROM cards_i18n ci WHERE ci.card_id = card_id_old;
            END IF;
        UNTIL done END REPEAT;
        CLOSE cur_cards;
        SET done=0;

        OPEN cur_buildings;
        REPEAT
            FETCH cur_buildings INTO building_id_old,building_health,building_radius,building_x_len,building_y_len,building_shape,building_type,building_ui_code;
            IF NOT done THEN
                INSERT INTO buildings(health,radius,x_len,y_len,shape,`type`,ui_code)
                VALUES(building_health,building_radius,building_x_len,building_y_len,building_shape,building_type,building_ui_code);
                SET building_id_new = @@last_insert_id;

                INSERT INTO buildings_ids(id_old,id_new) VALUES(building_id_old,building_id_new);

                INSERT INTO buildings_procedures(building_id,procedure_id)
                SELECT building_id_new,bp.procedure_id FROM buildings_procedures bp WHERE bp.building_id=building_id_old;

                INSERT INTO building_default_features(building_id,feature_id,param)
                SELECT building_id_new,f.feature_id,f.param FROM building_default_features f WHERE f.building_id=building_id_old;

                INSERT INTO put_start_buildings_config(player_num,x,y,rotation,flip,building_id,mode_id)
                SELECT c.player_num,c.x,c.y,c.rotation,c.flip,building_id_new,new_mode_id FROM put_start_buildings_config c WHERE c.mode_id=old_mode_id AND c.building_id=building_id_old;

                INSERT INTO modes_cardless_buildings(mode_id,building_id)
                SELECT new_mode_id,building_id_new FROM modes_cardless_buildings cb WHERE cb.mode_id=old_mode_id AND cb.building_id=building_id_old;

                INSERT INTO buildings_i18n(building_id, language_id, name, description, log_short_name)
                SELECT building_id_new, bi.language_id, bi.name, bi.description, bi.log_short_name FROM buildings_i18n bi WHERE bi.building_id = building_id_old;
            END IF;
        UNTIL done END REPEAT;
        CLOSE cur_buildings;
        SET done=0;

        OPEN cur_units;
        REPEAT
            FETCH cur_units INTO unit_id_old,unit_moves,unit_health,unit_attack,unit_size,unit_shield,unit_ui_code;
            IF NOT done THEN
                INSERT INTO units(moves,health,attack,size,shield,ui_code)
                VALUES(unit_moves,unit_health,unit_attack,unit_size,unit_shield,unit_ui_code);
                SET unit_id_new = @@last_insert_id;

                INSERT INTO units_ids(id_old,id_new) VALUES(unit_id_old,unit_id_new);

                INSERT INTO units_procedures(unit_id,procedure_id,`default`)
                SELECT unit_id_new,up.procedure_id,up.`default` FROM units_procedures up WHERE up.unit_id=unit_id_old;

                INSERT INTO unit_default_features(unit_id,feature_id,param)
                SELECT unit_id_new,f.feature_id,f.param FROM unit_default_features f WHERE f.unit_id=unit_id_old;

                INSERT INTO put_start_units_config(player_num,x,y,unit_id,mode_id)
                SELECT c.player_num,c.x,c.y,unit_id_new,new_mode_id FROM put_start_units_config c WHERE c.mode_id=old_mode_id AND c.unit_id=unit_id_old;

                INSERT INTO modes_cardless_units(mode_id,unit_id)
                SELECT new_mode_id,unit_id_new FROM modes_cardless_units cu WHERE cu.mode_id=old_mode_id AND cu.unit_id=unit_id_old;

                INSERT INTO dic_unit_phrases(unit_id,phrase,language_id)
                SELECT unit_id_new,p.phrase,p.language_id FROM dic_unit_phrases p WHERE p.unit_id=unit_id_old;

                INSERT INTO unit_level_up_experience(unit_id,level,experience)
                SELECT unit_id_new,l.level,l.experience FROM unit_level_up_experience l WHERE l.unit_id=unit_id_old;

                INSERT INTO units_i18n(unit_id, language_id, name, description, log_short_name, log_name_accusative)
                SELECT unit_id_new, ui.language_id, ui.name, ui.description, ui.log_short_name, ui.log_name_accusative FROM units_i18n ui WHERE ui.unit_id = unit_id_old;
            END IF;
        UNTIL done END REPEAT;
        CLOSE cur_units;

        UPDATE cards,cards_ids,buildings_ids
        SET cards.ref=buildings_ids.id_new
        WHERE cards.id=cards_ids.id_new AND cards.`type`='b' AND cards.ref=buildings_ids.id_old;

        UPDATE cards,cards_ids,units_ids
        SET cards.ref=units_ids.id_new
        WHERE cards.id=cards_ids.id_new AND cards.`type`='u' AND cards.ref=units_ids.id_old;

        INSERT INTO summon_cfg(building_id,unit_id,`count`,owner,mode_id)
        SELECT b.id_new,u.id_new,c.`count`,c.owner,new_mode_id
        FROM summon_cfg c
        JOIN buildings_ids b ON c.building_id=b.id_old
        JOIN units_ids u ON c.unit_id=u.id_old
        WHERE c.mode_id=old_mode_id;

        INSERT INTO attack_bonus(mode_id,unit_id,aim_type,aim_id,dice_max,chance,critical_chance,damage_bonus,critical_bonus,priority,`comment`)
        SELECT new_mode_id,u.id_new,a.aim_type,a.aim_id,a.dice_max,a.chance,a.critical_chance,a.damage_bonus,a.critical_bonus,a.priority,a.`comment`
        FROM attack_bonus a
        LEFT JOIN units_ids u ON a.unit_id=u.id_old
        WHERE a.mode_id=old_mode_id AND a.aim_type IS NULL;

        INSERT INTO attack_bonus(mode_id,unit_id,aim_type,aim_id,dice_max,chance,critical_chance,damage_bonus,critical_bonus,priority,`comment`)
        SELECT new_mode_id,u.id_new,a.aim_type,a.aim_id,a.dice_max,a.chance,a.critical_chance,a.damage_bonus,a.critical_bonus,a.priority,a.`comment`
        FROM attack_bonus a
        LEFT JOIN units_ids u ON a.unit_id=u.id_old
        WHERE a.mode_id=old_mode_id AND a.aim_type='unit';

        UPDATE attack_bonus,units_ids
        SET aim_id=units_ids.id_new
        WHERE mode_id=new_mode_id AND aim_type='unit' AND attack_bonus.aim_id=units_ids.id_old;

        INSERT INTO attack_bonus(mode_id,unit_id,aim_type,aim_id,dice_max,chance,critical_chance,damage_bonus,critical_bonus,priority,`comment`)
        SELECT new_mode_id,u.id_new,a.aim_type,aim_b.id_new,a.dice_max,a.chance,a.critical_chance,a.damage_bonus,a.critical_bonus,a.priority,a.`comment`
        FROM attack_bonus a
        LEFT JOIN units_ids u ON a.unit_id=u.id_old
        JOIN buildings_ids aim_b ON a.aim_id=aim_b.id_old
        WHERE a.mode_id=old_mode_id AND a.aim_type IS NOT NULL AND a.aim_type<>'unit';

        DROP TEMPORARY TABLE cards_ids;
        DROP TEMPORARY TABLE buildings_ids;
        DROP TEMPORARY TABLE units_ids;

    END;
    END IF;


END$$

DELIMITER ;

use lords_site;

DELIMITER $$

DROP FUNCTION IF EXISTS `lords_site`.`user_language` $$

CREATE FUNCTION `user_language`(user_id INT) RETURNS INT
BEGIN
  RETURN (SELECT u.language_id FROM users u WHERE u.id=user_id LIMIT 1);
END$$

DROP PROCEDURE IF EXISTS `lords_site`.`arena_game_spectator_enter` $$

CREATE PROCEDURE `arena_game_spectator_enter`(user_id INT,  game_id INT,   pass VARCHAR(45) CHARSET utf8)
BEGIN
  DECLARE created_game_status INT DEFAULT 1; 
  DECLARE player_playing_status_id INT DEFAULT 3; 
  DECLARE game_status_id INT;
  DECLARE md5_game_pass VARCHAR(45) CHARSET utf8;
  DECLARE p_num INT;
  DECLARE p_name VARCHAR(200) CHARSET utf8;

  SELECT ag.status_id, ag.pass INTO game_status_id, md5_game_pass FROM arena_games ag WHERE ag.id=game_id LIMIT 1;

  IF NOT EXISTS(SELECT au.id FROM arena_users au WHERE au.user_id=user_id LIMIT 1)THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=8;
  ELSE
    IF EXISTS(SELECT p.id FROM arena_game_players p WHERE p.user_id=user_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;
    ELSE
      IF game_status_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=16;
      ELSE
        IF IFNULL(md5_game_pass,'')<>IFNULL(MD5(pass),'') THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=13;
        ELSE
          IF (game_status_id=created_game_status) THEN
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=29;
          ELSE

            INSERT INTO arena_game_players(user_id,game_id,spectator_flag)VALUES(user_id,game_id,1); 

            UPDATE arena_users au SET au.status_id=player_playing_status_id WHERE au.user_id=user_id;

            SET p_num=100+user_id;
            SET p_name=user_nick(user_id);

            INSERT INTO lords.players(user_id,game_id,player_num,name,owner,team,language_id)
            VALUES(user_id,game_id,p_num,p_name,0,0,user_language(user_id));

            SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;

            SELECT 'player_num' AS `name`, p_num as `value` FROM DUAL
            UNION
            SELECT 'player_name' AS `name`, p_name as `value` FROM DUAL;

          END IF;
        END IF;
      END IF;
    END IF;
  END IF;
END$$

DROP PROCEDURE IF EXISTS `lords_site`.`arena_game_start` $$

CREATE PROCEDURE `arena_game_start`(user_id INT,   game_id INT)
BEGIN
  DECLARE created_game_status INT DEFAULT 1; 
  DECLARE playing_game_status INT DEFAULT 2; 
  DECLARE player_ingame_status_id INT DEFAULT 2; 
  DECLARE player_playing_status_id INT DEFAULT 3; 
  DECLARE arena_game_type_id INT DEFAULT 1; 
  DECLARE owner_id INT;
  DECLARE status_id INT;
  DECLARE player_count INT;
  DECLARE mode_id INT;

  SELECT ag.owner_id, ag.status_id, ag.mode_id INTO owner_id,status_id,mode_id FROM arena_games ag WHERE ag.id=game_id LIMIT 1;

  IF (owner_id IS NULL) OR (owner_id<>user_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=26;
  ELSE
    IF status_id<>created_game_status THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=27;
    ELSE
      SELECT COUNT(*) INTO player_count FROM arena_game_players agp WHERE agp.game_id=game_id AND spectator_flag=0;
      IF NOT EXISTS(SELECT lm.id FROM lords.modes lm WHERE lm.id=mode_id AND player_count BETWEEN lm.min_players AND lm.max_players LIMIT 1) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=28;
      ELSE

        UPDATE arena_games ag SET ag.status_id=playing_game_status WHERE ag.id=game_id;

        UPDATE arena_users au, arena_game_players agp SET au.status_id=player_playing_status_id
          WHERE au.user_id=agp.user_id AND agp.game_id=game_id AND au.status_id=player_ingame_status_id;

        INSERT INTO lords.players(user_id,game_id,player_num,name,owner,team,language_id)
          SELECT
            agp.user_id,
            game_id,
            CASE WHEN agp.spectator_flag=0 THEN 0 ELSE 100+agp.user_id END,
            u.login,
            CASE WHEN agp.spectator_flag=1 THEN 0 ELSE 1 END,
            IFNULL(agp.team,0),
            user_language(agp.user_id)
          FROM arena_game_players agp JOIN users u ON agp.user_id = u.id WHERE agp.game_id=game_id;

        INSERT INTO lords.games_features_usage(game_id,feature_id,param)
          SELECT f.game_id,f.feature_id,f.`value` FROM arena_games_features_usage f WHERE f.game_id=game_id;

        CALL lords.initialization(game_id);

        SELECT 1 AS `success`, null as `error_code`, null as `error_params` FROM DUAL;

      END IF;
    END IF;
  END IF;

END$$


