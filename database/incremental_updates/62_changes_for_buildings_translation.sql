USE `lords`;
CREATE 
     OR REPLACE ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `lords`.`vw_mode_buildings` AS
    SELECT
        `c`.`mode_id` AS `mode_id`,
        `b`.`id` AS `id`,
        `b`.`health` AS `health`,
        `b`.`radius` AS `radius`,
        `b`.`x_len` AS `x_len`,
        `b`.`y_len` AS `y_len`,
        `b`.`shape` AS `shape`,
        `b`.`type` AS `type`,
        `b`.`ui_code` AS `ui_code`
    FROM
        (`lords`.`vw_mode_cards` `c`
        JOIN `lords`.`buildings` `b` ON ((`c`.`ref` = `b`.`id`)))
    WHERE
        (`c`.`type` = 'b') 
    UNION SELECT 
        `c`.`mode_id` AS `mode_id`,
        `b`.`id` AS `id`,
        `b`.`health` AS `health`,
        `b`.`radius` AS `radius`,
        `b`.`x_len` AS `x_len`,
        `b`.`y_len` AS `y_len`,
        `b`.`shape` AS `shape`,
        `b`.`type` AS `type`,
        `b`.`ui_code` AS `ui_code`
    FROM
        (`lords`.`modes_cardless_buildings` `c`
        JOIN `lords`.`buildings` `b` ON ((`c`.`building_id` = `b`.`id`)));

USE `lords`;
DROP function IF EXISTS `log_building`;

DELIMITER $$
USE `lords`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `log_building`(board_building_id INT) RETURNS varchar(200) CHARSET utf8
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT;
  DECLARE b_id INT;
  DECLARE player_class VARCHAR(45);

  SELECT game_id,player_num,building_id INTO g_id,p_num,b_id FROM board_buildings WHERE id=board_building_id LIMIT 1;

  IF EXISTS(SELECT id FROM players WHERE game_id=g_id AND player_num=p_num)THEN
    SELECT CASE WHEN p.owner=1 THEN CONCAT('p',p.player_num) ELSE 'newtrl' END INTO player_class FROM players p WHERE p.game_id=g_id AND p.player_num=p_num LIMIT 1;
  ELSE
    SET player_class='newtrl';
  END IF;

  RETURN CONCAT('<b class=\'',player_class,'\' title=\'highlight_building(',board_building_id,')|unhighlight_building(',board_building_id,')\'>',(SELECT ui_code FROM buildings WHERE id=b_id LIMIT 1),'</b>');

END$$

DELIMITER ;

USE `lords`;
DROP procedure IF EXISTS `attack_actions`;

DELIMITER $$
USE `lords`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `attack_actions`(board_unit_id INT,aim_type VARCHAR(45),aim_board_id INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p_num INT; 
  DECLARE p2_num INT; 
  DECLARE u_id,aim_object_id INT;
  DECLARE aim_short_name VARCHAR(45) CHARSET utf8;
  DECLARE health_before_hit,health_after_hit,experience INT;
  DECLARE aim_card_id INT;
  DECLARE aim_x,aim_y INT;
  DECLARE aim_shield INT DEFAULT 0;
  DECLARE aim_goes_to_deck INT;
  DECLARE grave_id INT;

  DECLARE damage INT;
  DECLARE attack_success,critical INT;

  DECLARE cmd_log VARCHAR(1000) CHARSET utf8;

  SET cmd_log='log_add_attack_message($x,$y,$x2,$y2,$p_num,"$u_short_name",$p2_num,"$aim_short_name",$attack_success,$critical,$damage)';

  SELECT bu.game_id,bu.player_num,bu.unit_id INTO g_id,p_num,u_id FROM board_units bu JOIN games g ON (bu.game_id=g.id) WHERE bu.id=board_unit_id LIMIT 1;

  CASE
    WHEN aim_type='unit' THEN
    BEGIN
      SELECT bu.player_num,bu.unit_id,bu.health,bu.card_id,shield INTO p2_num,aim_object_id,health_before_hit,aim_card_id,aim_shield FROM board_units bu WHERE bu.id=aim_board_id LIMIT 1;
      SET aim_goes_to_deck = unit_feature_check(aim_board_id,'goes_to_deck_on_death');
      SELECT MIN(b.x),MIN(b.y) INTO aim_x,aim_y FROM board b WHERE b.game_id=g_id AND b.`type`=aim_type AND b.ref=aim_board_id;
      SELECT ui_code INTO aim_short_name FROM units WHERE id=aim_object_id LIMIT 1;
    END;
    WHEN aim_type='building' OR aim_type='castle' THEN
    BEGIN
      SELECT bb.player_num,bb.building_id,bb.health INTO p2_num,aim_object_id,health_before_hit FROM board_buildings bb WHERE bb.id=aim_board_id LIMIT 1;
      SELECT b.x,b.y INTO aim_x,aim_y FROM board b WHERE b.game_id=g_id AND b.`type`=aim_type AND b.ref=aim_board_id LIMIT 1;
      SELECT ui_code INTO aim_short_name FROM buildings WHERE id=aim_object_id LIMIT 1;
    END;
  END CASE;

  CALL calculate_attack_damage(board_unit_id,aim_type,aim_board_id,attack_success,damage,critical);

      SET cmd_log=REPLACE(cmd_log,'$x,$y',(SELECT CONCAT(b.x,',',b.y) FROM board b WHERE b.`type`='unit' AND b.ref=board_unit_id LIMIT 1));
      SET cmd_log=REPLACE(cmd_log,'$x2,$y2',(SELECT CONCAT(aim_x,',',aim_y) FROM DUAL));

      SET cmd_log=REPLACE(cmd_log,'$p_num',p_num);
      SET cmd_log=REPLACE(cmd_log,'$p2_num',p2_num);

      SET cmd_log=REPLACE(cmd_log,'$u_short_name',(SELECT ui_code FROM units WHERE id=u_id LIMIT 1));
      SET cmd_log=REPLACE(cmd_log,'$aim_short_name',aim_short_name);

      SET cmd_log=REPLACE(cmd_log,'$attack_success',attack_success);
      SET cmd_log=REPLACE(cmd_log,'$critical',critical);
      SET cmd_log=REPLACE(cmd_log,'$damage',CASE WHEN aim_shield=0 THEN damage ELSE 0 END);

      INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

  IF critical=1 THEN
    INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'critical_hit');
  END IF;

      IF attack_success=1 THEN 

        
        IF(aim_type='unit' AND unit_feature_check(aim_board_id,'agressive')=1) THEN 
          CALL unit_feature_set(aim_board_id,'attack_target',board_unit_id);
        END IF;

        CASE aim_type
          WHEN 'unit' THEN CALL hit_unit(aim_board_id,p_num,damage);
          WHEN 'building' THEN CALL hit_building(aim_board_id,p_num,damage);
          WHEN 'castle' THEN CALL hit_castle(aim_board_id,p_num,damage);
        END CASE;

        IF (aim_type='unit') THEN
          SELECT bu.health INTO health_after_hit FROM board_units bu WHERE bu.id=aim_board_id LIMIT 1;
        ELSE
          SELECT bb.health INTO health_after_hit FROM board_buildings bb WHERE bb.id=aim_board_id LIMIT 1;
        END IF;
        IF (health_after_hit IS NULL) THEN
          SET health_after_hit = 0;
        END IF;


        SET experience = health_before_hit - health_after_hit;
        IF(health_after_hit = 0)THEN
          SET experience = experience + 1;
        END IF;
        IF(experience > 0 AND EXISTS(SELECT id FROM board_units WHERE id=board_unit_id))THEN
          CALL unit_add_exp(board_unit_id, experience);
        END IF;

        IF (aim_type='unit') THEN

          IF (unit_feature_check(board_unit_id,'drink_health')=1) AND (health_after_hit<health_before_hit)THEN
            CALL drink_health(board_unit_id);
          END IF;


          IF (unit_feature_check(board_unit_id,'vamp')=1) AND (health_after_hit = 0) THEN
            IF (aim_card_id IS NOT NULL AND aim_goes_to_deck=0) THEN
              SELECT gc.grave_id INTO grave_id FROM graves g JOIN grave_cells gc ON g.id=gc.grave_id WHERE g.game_id=g_id AND g.card_id=aim_card_id AND gc.x=aim_x AND gc.y=aim_y LIMIT 1;
              CALL vampire_resurrect_by_card(board_unit_id,grave_id);
            ELSE
              CALL vampire_resurrect_by_u_id(board_unit_id,aim_object_id,aim_x,aim_y);
            END IF;
          END IF;
          
          IF(unit_feature_check(board_unit_id,'pushes')=1 AND aim_type='unit') THEN 
            CALL unit_push(board_unit_id,aim_board_id);
          END IF;

        END IF;

      ELSE 
        INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'miss_attack');
      END IF;

END$$

DELIMITER ;

USE `lords`;
DROP procedure IF EXISTS `cast_polza_move_building`;

DELIMITER $$
USE `lords`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_polza_move_building`(g_id INT,p_num INT,b_x INT,b_y INT,x INT,y INT,rot INT,flp INT)
BEGIN
  DECLARE nonfinished_action INT DEFAULT 3;
  DECLARE board_building_id INT;
  DECLARE p2_num INT;
  DECLARE building_id INT;
  DECLARE building_name VARCHAR(45) CHARSET utf8;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;
  ELSE
    IF NOT nonfinished_action=(SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=24;
    ELSE
      SELECT b.ref INTO board_building_id FROM board b WHERE b.game_id=g_id AND b.`type` IN ('building','obstacle') AND b.x=b_x AND b.y=b_y LIMIT 1;
      IF board_building_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=26;
      ELSE
        SELECT bb.player_num INTO p2_num FROM board_buildings bb WHERE bb.id=board_building_id LIMIT 1;
        IF p2_num=p_num THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=27;
        ELSE
          IF building_feature_check(board_building_id,'not_movable')=1 THEN
            SELECT bb.building_id INTO building_id FROM board_buildings bb WHERE bb.id=board_building_id;
            SELECT b.ui_code INTO building_name FROM buildings b WHERE b.id=building_id;
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=43;
          ELSE
            CALL user_action_begin();


            UPDATE board SET ref=0 WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=board_building_id;

            CALL place_building_on_board(board_building_id,x,y,rot,flp);

            IF NOT EXISTS(SELECT id FROM board WHERE game_id=g_id AND `type`<>'unit' AND ref=board_building_id) THEN 
              UPDATE board SET ref=board_building_id WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0;
              SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=12;
            ELSE
            
              DELETE FROM board WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0; 

              UPDATE board_buildings SET player_num=p_num,rotation=rot,flip=flp WHERE id=board_building_id;

              CALL count_income(board_building_id);

              CALL cmd_move_building(g_id,p_num,b_x,b_y,board_building_id);
              CALL cmd_building_set_owner(g_id,p_num,board_building_id);


              UPDATE command SET hidden_flag=1 WHERE game_id=g_id AND player_num=p_num AND hidden_flag=2;
              UPDATE active_players SET nonfinished_action_id=0 WHERE game_id=g_id AND player_num=p_num;

              CALL finish_playing_card(g_id,p_num);
              CALL end_cards_phase(g_id,p_num);

              CALL user_action_end();
            END IF;
          END IF;
        END IF;
      END IF;
    END IF;
  END IF;

END$$

DELIMITER ;

USE `lords`;
DROP procedure IF EXISTS `cast_vred_move_building`;

DELIMITER $$
USE `lords`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_vred_move_building`(g_id INT,p_num INT,b_x INT,b_y INT,x INT,y INT,rot INT,flp INT)
BEGIN
  DECLARE nonfinished_action INT DEFAULT 7;
  DECLARE board_building_id INT;
  DECLARE p2_num INT;
  DECLARE building_id INT;
  DECLARE building_name VARCHAR(45) CHARSET utf8;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;
  ELSE
    IF NOT nonfinished_action=(SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=24;
    ELSE
      SELECT b.ref INTO board_building_id FROM board b WHERE b.game_id=g_id AND b.`type` IN ('building','obstacle') AND b.x=b_x AND b.y=b_y LIMIT 1;
      IF board_building_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=26;
      ELSE
        SELECT bb.player_num INTO p2_num FROM board_buildings bb WHERE bb.id=board_building_id LIMIT 1;
        IF p2_num=p_num THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=27;
        ELSE
          IF building_feature_check(board_building_id,'not_movable')=1 THEN
            SELECT bb.building_id INTO building_id FROM board_buildings bb WHERE bb.id=board_building_id;
            SELECT b.ui_code INTO building_name FROM buildings b WHERE b.id=building_id;
            SELECT 0 AS `success`, ed.id as `error_code`, building_name as `error_params` FROM error_dictionary ed WHERE id=43;
          ELSE
            CALL user_action_begin();


            UPDATE board SET ref=0 WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=board_building_id;

            CALL place_building_on_board(board_building_id,x,y,rot,flp);

            IF NOT EXISTS(SELECT id FROM board WHERE game_id=g_id AND `type`<>'unit' AND ref=board_building_id) THEN 
              UPDATE board SET ref=board_building_id WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0;
              SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=12;
            ELSE
            
              DELETE FROM board WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0; 

              UPDATE board_buildings SET rotation=rot,flip=flp WHERE id=board_building_id;

              CALL count_income(board_building_id);

              CALL cmd_move_building(g_id,p_num,b_x,b_y,board_building_id);

              UPDATE command SET hidden_flag=1 WHERE game_id=g_id AND player_num=p_num AND hidden_flag=2;
              UPDATE active_players SET nonfinished_action_id=0 WHERE game_id=g_id AND player_num=p_num;

              CALL finish_playing_card(g_id,p_num);
              CALL end_cards_phase(g_id,p_num);

              CALL user_action_end();
            END IF;
          END IF;
        END IF;
      END IF;
    END IF;
  END IF;

END$$

DELIMITER ;

USE `lords`;
DROP procedure IF EXISTS `mode_copy`;

DELIMITER $$
USE `lords`$$
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

				INSERT INTO dic_unit_phrases(unit_id,phrase)
				SELECT unit_id_new,p.phrase FROM dic_unit_phrases p WHERE p.unit_id=unit_id_old;

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

DELIMITER ;


