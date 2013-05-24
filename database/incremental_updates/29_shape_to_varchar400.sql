use lords;

delimiter $$

DROP PROCEDURE IF EXISTS `lords`.`count_income`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `count_income`(board_building_id INT)
BEGIN
  DECLARE x,y,x1,y1 INT;
  DECLARE g_id INT;
  DECLARE mode_id INT;
  DECLARE p_num INT;
  DECLARE building_income INT;
  DECLARE income INT DEFAULT 0;

  DECLARE radius INT;
  DECLARE shape VARCHAR(400);

  SELECT bb.game_id,bb.player_num,b.radius,b.shape INTO g_id,p_num,radius,shape FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.id=board_building_id LIMIT 1;

        IF(shape='1' AND radius>0)THEN
        BEGIN
          SELECT MIN(b.x),MIN(b.y) INTO x,y FROM board b WHERE b.game_id=g_id AND b.`type`<>'unit' AND b.ref=board_building_id;

          SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
          SELECT cfg.`value` INTO building_income FROM mode_config cfg WHERE cfg.param='building income' AND cfg.mode_id=mode_id;

          SET x1=x-radius;
          WHILE x1<=x+radius DO
            SET y1=y-radius;
            WHILE y1<=y+radius DO
              IF(quart(x1,y1)<>5 AND quart(x1,y1)<>p_num AND NOT (x1=x AND y1=y) )THEN
                SET income=income+building_income;
              END IF;
              SET y1=y1+1;
            END WHILE;
            SET x1=x1+1;
          END WHILE;
          UPDATE board_buildings b SET b.income=income WHERE b.id=board_building_id;
        END;
        END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`finish_nonfinished_action`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `finish_nonfinished_action`(g_id INT,p_num INT,nonfinished_action INT)
BEGIN
  DECLARE mode_id INT;

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;

  CASE nonfinished_action

    WHEN 1 THEN /*resurrect*/
    BEGIN
      DECLARE big_dice INT;
      DECLARE x_appear,y_appear INT;
      DECLARE max_size INT;
      DECLARE random_grave INT;
      DECLARE random_dead_card INT;

      SELECT ap.x,ap.y INTO x_appear,y_appear FROM appear_points ap WHERE ap.mode_id=mode_id AND ap.player_num=p_num;
      /*get max resurrectable size*/
      SELECT IFNULL(MIN(GREATEST(ABS(b.x-18),ABS(b.y-18))),18) INTO max_size FROM board b
      WHERE b.x NOT IN(0,19) AND b.y NOT IN(0,19);
      /*get random dead*/
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

    WHEN 2 THEN /*units from zone*/
    BEGIN
      DECLARE zone INT;

      SELECT FLOOR(RAND() * 4) INTO zone FROM DUAL;

      CALL units_from_zone(g_id,zone);
    END;

    WHEN 3 THEN /*move and own building*/
    BEGIN
      DECLARE big_dice INT;
      DECLARE rand_building_id INT;
      DECLARE x_len,y_len INT;
      DECLARE shape VARCHAR(400);
      DECLARE radius INT;
      DECLARE rotation INT DEFAULT 0;
      DECLARE flip INT DEFAULT 0;
      DECLARE x,y,b_x,b_y INT;

      /*get random building*/
        CREATE TEMPORARY TABLE tmp_buildings (id_rand INT AUTO_INCREMENT PRIMARY KEY)AUTO_INCREMENT=1
          SELECT DISTINCT b.ref AS `board_building_id`
          FROM board b
          JOIN board_buildings bb ON (b.ref=bb.id)
          WHERE b.game_id=g_id AND b.`type` IN ('building','obstacle') AND bb.player_num<>p_num AND building_feature_check(bb.id,'not_movable')=0;
        SELECT FLOOR(1 + (RAND() * MAX(id_rand))) INTO big_dice FROM tmp_buildings;
        SELECT `board_building_id` INTO rand_building_id FROM tmp_buildings WHERE id_rand=big_dice LIMIT 1;
        DROP TEMPORARY TABLE tmp_buildings;

        SELECT b.x_len,b.y_len,b.shape,b.radius INTO x_len,y_len,shape,radius FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.id=rand_building_id LIMIT 1;

        /*select old building coord for building move command*/
        SELECT b.x,b.y INTO b_x,b_y FROM board b WHERE b.game_id=g_id AND b.`type` IN ('building','obstacle') AND b.ref=rand_building_id LIMIT 1;
        /*set ref=0 to identify if building has been moved*/
        UPDATE board SET ref=0 WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=rand_building_id;

        /*try until it will be placed*/
        WHILE NOT EXISTS (SELECT id FROM board WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=rand_building_id LIMIT 1) DO
          IF shape='1' THEN
            SELECT FLOOR(RAND() * 20) INTO x FROM DUAL;
            SELECT FLOOR(RAND() * 20) INTO y FROM DUAL;
          ELSE
            SELECT FLOOR(RAND() * 4) INTO rotation FROM DUAL;
            SELECT FLOOR(RAND() * 2) INTO flip FROM DUAL;
            /*generate top-left X,Y so that the whole building in game area*/
            SELECT FLOOR(RAND() * (21- CASE WHEN rotation IN(0,2) THEN x_len ELSE y_len END)) INTO x FROM DUAL;
            SELECT FLOOR(RAND() * (21- CASE WHEN rotation IN(0,2) THEN y_len ELSE x_len END)) INTO y FROM DUAL;
          END IF;
          /*try to place a building*/
          CALL place_building_on_board(rand_building_id,x,y,rotation,flip);
        END WHILE;

        DELETE FROM board WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0; /*Del old coords*/

        UPDATE board_buildings bb SET bb.player_num=p_num,bb.rotation=rotation,bb.flip=flip WHERE bb.id=rand_building_id;

        CALL count_income(rand_building_id);

        CALL cmd_move_building(g_id,p_num,b_x,b_y,rand_building_id);
        CALL cmd_building_set_owner(g_id,p_num,rand_building_id);
    END;

    WHEN 4 THEN /* -60$ to player */
    BEGIN
      DECLARE random_player INT;

      SELECT player_num INTO random_player FROM players WHERE game_id=g_id ORDER BY RAND() LIMIT 1;
      CALL vred_pooring(g_id,random_player);
    END;

    WHEN 5 THEN /* kill unit */
    BEGIN
      DECLARE random_bu_id,u_id INT;
      DECLARE shield INT;

      SELECT bu.id,bu.unit_id,bu.shield INTO random_bu_id,u_id,shield FROM board_units bu WHERE bu.game_id=g_id ORDER BY RAND() LIMIT 1;

      CALL magic_kill_unit(random_bu_id,p_num);
    END;

    WHEN 6 THEN /* destroy building */
    BEGIN
      DECLARE random_bb_id,b_id INT;

      SELECT bb.id INTO random_bb_id FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.game_id=g_id AND b.`type`<>'castle' ORDER BY RAND() LIMIT 1;
      CALL destroy_building(random_bb_id,p_num);
    END;

    WHEN 7 THEN /*move enemy building*/
    BEGIN
      DECLARE big_dice INT;
      DECLARE rand_building_id INT;
      DECLARE x_len,y_len INT;
      DECLARE shape VARCHAR(400);
      DECLARE radius INT;
      DECLARE rotation INT DEFAULT 0;
      DECLARE flip INT DEFAULT 0;
      DECLARE x,y,b_x,b_y INT;

      /*get random building*/
        CREATE TEMPORARY TABLE tmp_buildings (id_rand INT AUTO_INCREMENT PRIMARY KEY)AUTO_INCREMENT=1
          SELECT DISTINCT b.ref AS `board_building_id`
          FROM board b
          JOIN board_buildings bb ON (b.ref=bb.id)
          WHERE b.game_id=g_id AND b.`type` IN ('building','obstacle') AND bb.player_num<>p_num AND building_feature_check(bb.id,'not_movable')=0;
        SELECT FLOOR(1 + (RAND() * MAX(id_rand))) INTO big_dice FROM tmp_buildings;
        SELECT `board_building_id` INTO rand_building_id FROM tmp_buildings WHERE id_rand=big_dice LIMIT 1;
        DROP TEMPORARY TABLE tmp_buildings;

        SELECT b.x_len,b.y_len,b.shape,b.radius INTO x_len,y_len,shape,radius FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.id=rand_building_id LIMIT 1;

        /*select old building coord for building move command*/
        SELECT b.x,b.y INTO b_x,b_y FROM board b WHERE b.game_id=g_id AND b.`type` IN ('building','obstacle') AND b.ref=rand_building_id LIMIT 1;
        /*set ref=0 to identify if building has been moved*/
        UPDATE board SET ref=0 WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=rand_building_id;

        /*try until it will be placed*/
        WHILE NOT EXISTS (SELECT id FROM board WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=rand_building_id LIMIT 1) DO
          IF shape='1' THEN
            SELECT FLOOR(RAND() * 20) INTO x FROM DUAL;
            SELECT FLOOR(RAND() * 20) INTO y FROM DUAL;
          ELSE
            SELECT FLOOR(RAND() * 4) INTO rotation FROM DUAL;
            SELECT FLOOR(RAND() * 2) INTO flip FROM DUAL;
            /*generate top-left X,Y so that the whole building in game area*/
            SELECT FLOOR(RAND() * (21- CASE WHEN rotation IN(0,2) THEN x_len ELSE y_len END)) INTO x FROM DUAL;
            SELECT FLOOR(RAND() * (21- CASE WHEN rotation IN(0,2) THEN y_len ELSE x_len END)) INTO y FROM DUAL;
          END IF;
          /*try to place a building*/
          CALL place_building_on_board(rand_building_id,x,y,rotation,flip);
        END WHILE;

        DELETE FROM board WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0; /*Del old coords*/

        UPDATE board_buildings bb SET bb.rotation=rotation,bb.flip=flip WHERE bb.id=rand_building_id;

        CALL count_income(rand_building_id);

        CALL cmd_move_building(g_id,p_num,b_x,b_y,rand_building_id);
    END;

  END CASE;

  UPDATE command SET hidden_flag=1 WHERE game_id=g_id AND player_num=p_num AND hidden_flag=2;
  UPDATE active_players SET nonfinished_action_id=0 WHERE game_id=g_id AND player_num=p_num;

  CALL finish_playing_card(g_id,p_num);

END$$

DROP PROCEDURE IF EXISTS `lords`.`mode_copy`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `mode_copy`(old_mode_id INT, mode_name VARCHAR(45) CHARSET utf8, copy_cards_units_buildings INT)
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

	INSERT INTO videos(code,filename,title,mode_id)
	SELECT v.code,v.filename,v.title,new_mode_id FROM videos v WHERE v.mode_id = old_mode_id;

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

		INSERT INTO summon_cfg(player_name,building_id,unit_id,`count`,owner,mode_id)
		SELECT c.player_name,c.building_id,c.unit_id,c.`count`,c.owner,new_mode_id FROM summon_cfg c WHERE c.mode_id=old_mode_id;

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
		DECLARE card_name VARCHAR(45) CHARSET utf8;
		DECLARE card_description VARCHAR(1000) CHARSET utf8;

		DECLARE building_id_old INT;
		DECLARE building_id_new INT;
		DECLARE building_name VARCHAR(45) CHARSET utf8;
		DECLARE building_health INT;
		DECLARE building_radius INT;
		DECLARE building_x_len INT;
		DECLARE building_y_len INT;
		DECLARE building_shape VARCHAR(400) CHARSET utf8;
		DECLARE building_type VARCHAR(45) CHARSET utf8;
		DECLARE building_description VARCHAR(1000) CHARSET utf8;
		DECLARE building_log_short_name VARCHAR(45) CHARSET utf8;
		DECLARE building_ui_code VARCHAR(45) CHARSET utf8;

		DECLARE unit_id_old INT;
		DECLARE unit_id_new INT;
		DECLARE unit_name VARCHAR(45) CHARSET utf8;
		DECLARE unit_moves INT;
		DECLARE unit_health INT;
		DECLARE unit_attack INT;
		DECLARE unit_size INT;
		DECLARE unit_shield INT;
		DECLARE unit_description VARCHAR(1000) CHARSET utf8;
		DECLARE unit_log_short_name VARCHAR(45) CHARSET utf8;
		DECLARE unit_name_rod_pad VARCHAR(45) CHARSET utf8;
		DECLARE unit_ui_code VARCHAR(45) CHARSET utf8;

		DECLARE done INT DEFAULT 0;
		DECLARE cur_cards CURSOR FOR SELECT c.id,c.image,c.cost,c.`type`,c.ref,c.name,c.description FROM vw_mode_cards c WHERE c.mode_id=old_mode_id;
		DECLARE cur_buildings CURSOR FOR SELECT b.id,b.name,b.health,b.radius,b.x_len,b.y_len,b.shape, b.`type`,b.description,b.log_short_name,b.ui_code FROM vw_mode_buildings b WHERE b.mode_id=old_mode_id;
		DECLARE cur_units CURSOR FOR SELECT u.id,u.name,u.moves,u.health,u.attack,u.size,u.shield,u.description,u.log_short_name,u.log_name_rod_pad,u.ui_code FROM vw_mode_units u WHERE u.mode_id=old_mode_id;
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

		CREATE TEMPORARY TABLE cards_ids (id_old INT,id_new INT);
		CREATE TEMPORARY TABLE buildings_ids (id_old INT,id_new INT);
		CREATE TEMPORARY TABLE units_ids (id_old INT,id_new INT);

		OPEN cur_cards;
		REPEAT
			FETCH cur_cards INTO card_id_old,card_image,card_cost,card_type,card_ref,card_name,card_description;
			IF NOT done THEN
				INSERT INTO cards(image,cost,`type`,ref,name,description)
				VALUES(card_image,card_cost,card_type,card_ref,card_name,card_description);
				SET card_id_new = @@last_insert_id;

				INSERT INTO cards_ids(id_old,id_new) VALUES(card_id_old,card_id_new);

				INSERT INTO cards_procedures(card_id,procedure_id)
				SELECT card_id_new,cp.procedure_id FROM cards_procedures cp WHERE cp.card_id=card_id_old;

				INSERT INTO modes_cards(mode_id,card_id,quantity)
				SELECT new_mode_id,card_id_new,mc.quantity FROM modes_cards mc WHERE mc.mode_id=old_mode_id AND mc.card_id=card_id_old;

			END IF;
		UNTIL done END REPEAT;
		CLOSE cur_cards;
		SET done=0;

		OPEN cur_buildings;
		REPEAT
			FETCH cur_buildings INTO building_id_old,building_name,building_health,building_radius,building_x_len,building_y_len,building_shape,building_type,building_description,building_log_short_name,building_ui_code;
			IF NOT done THEN
				INSERT INTO buildings(name,health,radius,x_len,y_len,shape,`type`,description,log_short_name,ui_code)
				VALUES(building_name,building_health,building_radius,building_x_len,building_y_len,building_shape,building_type,building_description,building_log_short_name,building_ui_code);
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

			END IF;
		UNTIL done END REPEAT;
		CLOSE cur_buildings;
		SET done=0;

		OPEN cur_units;
		REPEAT
			FETCH cur_units INTO unit_id_old,unit_name,unit_moves,unit_health,unit_attack,unit_size,unit_shield,unit_description,unit_log_short_name,unit_name_rod_pad,unit_ui_code;
			IF NOT done THEN
				INSERT INTO units(name,moves,health,attack,size,shield,description,log_short_name,log_name_rod_pad,ui_code)
				VALUES(unit_name,unit_moves,unit_health,unit_attack,unit_size,unit_shield,unit_description,unit_log_short_name,unit_name_rod_pad,unit_ui_code);
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

				INSERT INTO dic_unit_phrases(unit_id,phrase)
				SELECT unit_id_new,p.phrase FROM dic_unit_phrases p WHERE p.unit_id=unit_id_old;

				INSERT INTO unit_level_up_experience(unit_id,level,experience)
				SELECT unit_id_new,l.level,l.experience FROM unit_level_up_experience l WHERE l.unit_id=unit_id_old;

			END IF;
		UNTIL done END REPEAT;
		CLOSE cur_units;

		UPDATE cards,cards_ids,buildings_ids
		SET cards.ref=buildings_ids.id_new
		WHERE cards.id=cards_ids.id_new AND cards.`type`='b' AND cards.ref=buildings_ids.id_old;

		UPDATE cards,cards_ids,units_ids
		SET cards.ref=units_ids.id_new
		WHERE cards.id=cards_ids.id_new AND cards.`type`='u' AND cards.ref=units_ids.id_old;

		INSERT INTO summon_cfg(player_name,building_id,unit_id,`count`,owner,mode_id)
		SELECT c.player_name,b.id_new,u.id_new,c.`count`,c.owner,new_mode_id
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

DROP PROCEDURE IF EXISTS `lords`.`place_building_on_board`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `place_building_on_board`(board_building_id INT,x INT,y INT,rotation INT,flip INT)
BEGIN
  DECLARE g_id INT;
  DECLARE b_id INT;
  DECLARE b_type VARCHAR(45);
  DECLARE x_len,y_len INT;
  DECLARE shape VARCHAR(400);
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

delimiter ;