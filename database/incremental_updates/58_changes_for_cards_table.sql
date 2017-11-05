USE `lords`;

CREATE 
     OR REPLACE ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `lords`.`vw_mode_cards` AS
    SELECT
        `m`.`mode_id` AS `mode_id`,
        `c`.`id` AS `id`,
        `c`.`image` AS `image`,
        `c`.`cost` AS `cost`,
        `c`.`type` AS `type`,
        `c`.`ref` AS `ref`
    FROM
        (`lords`.`modes_cards` `m`
        JOIN `lords`.`cards` `c` ON ((`m`.`card_id` = `c`.`id`)));

DROP procedure IF EXISTS `mode_copy`;
DELIMITER $$

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
		DECLARE cur_cards CURSOR FOR SELECT c.id,c.image,c.cost,c.`type`,c.ref FROM vw_mode_cards c WHERE c.mode_id=old_mode_id;
		DECLARE cur_buildings CURSOR FOR SELECT b.id,b.name,b.health,b.radius,b.x_len,b.y_len,b.shape, b.`type`,b.description,b.log_short_name,b.ui_code FROM vw_mode_buildings b WHERE b.mode_id=old_mode_id;
		DECLARE cur_units CURSOR FOR SELECT u.id,u.name,u.moves,u.health,u.attack,u.size,u.shield,u.description,u.log_short_name,u.log_name_rod_pad,u.ui_code FROM vw_mode_units u WHERE u.mode_id=old_mode_id;
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

DELIMITER ;

DROP PROCEDURE IF EXISTS `buy_card`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `buy_card`(g_id INT,p_num INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE card_cost INT;
  DECLARE new_card INT;
  DECLARE first_card_id INT;
  DECLARE player_deck_id INT;
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_independent_message($p_num,"Купил карту")';
  DECLARE cmd_log_buyer VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_independent_message($p_num,"$card_name")';


  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
  SELECT cfg.`value` INTO card_cost FROM mode_config cfg WHERE cfg.param='card cost' AND cfg.mode_id=mode_id;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;
  ELSE
    IF (SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id LIMIT 1)<>0 THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=28;
    ELSE
      IF (SELECT card_played_flag FROM active_players WHERE game_id=g_id)=1 THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=42;
      ELSE
        IF (SELECT gold FROM players WHERE game_id=g_id AND player_num=p_num)<card_cost THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=2;
        ELSE
          IF NOT EXISTS (SELECT id FROM deck WHERE game_id=g_id) THEN
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=3;
          ELSE

            CALL user_action_begin();

            UPDATE players SET gold=gold-card_cost WHERE game_id=g_id AND player_num=p_num;
            SELECT MIN(id) INTO first_card_id FROM deck WHERE game_id=g_id;
            SELECT card_id INTO new_card FROM deck WHERE game_id=g_id AND id=first_card_id;
            INSERT INTO player_deck (game_id,player_num,card_id) VALUES (g_id,p_num,new_card);
            SET player_deck_id=@@last_insert_id;

            DELETE FROM deck WHERE game_id=g_id AND id=first_card_id;

            CALL cmd_player_set_gold(g_id,p_num);
            CALL cmd_add_card(g_id,p_num,player_deck_id);

            SET cmd_log=REPLACE(cmd_log,'$p_num',p_num);
            
            INSERT INTO command (game_id,player_num,command) VALUES(g_id,p_num,cmd_log);

            SET cmd_log_buyer=REPLACE(cmd_log_buyer,'$p_num',p_num);
            INSERT INTO command (game_id,player_num,command,hidden_flag)
              VALUES (g_id,p_num,REPLACE(cmd_log_buyer,'$card_name',(SELECT CONCAT(' (',code,')') FROM cards WHERE id=new_card LIMIT 1)),1);

            INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'buy_card');
            CALL end_cards_phase(g_id,p_num);

            CALL user_action_end();
          END IF;
        END IF;
      END IF;
    END IF;
  END IF;
END ;;
DELIMITER ;

USE `lords`;
DROP procedure IF EXISTS `cast_polza_main`;

DELIMITER $$
USE `lords`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_polza_main`(g_id INT,p_num INT,player_deck_id INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE err_code INT;
  DECLARE dice INT;
  DECLARE nonfinished_action INT DEFAULT 0;
  DECLARE riching_sum INT DEFAULT 60;
  DECLARE take_cards_qty INT DEFAULT 2;
  DECLARE cmd_log_1 VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Польза: Починить здания")';
  DECLARE cmd_log_2 VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Польза: Воскресить любого юнита")';
  DECLARE cmd_log_3 VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Польза: +60 золота")';
  DECLARE cmd_log_4 VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Польза: Взять 2 карты")';
  DECLARE cmd_log_5 VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Польза: Переместить всех юнитов из выбранной зоны")';
  DECLARE cmd_log_6 VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Польза: Переместить и присвоить чужое здание")';
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'execute_procedure("$cmd_name")';

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_polza_main');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    CALL user_action_begin();

    CALL play_card_actions(g_id,p_num,player_deck_id); 

    SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
    SELECT FLOOR(1 + (RAND() * 6)) INTO dice FROM DUAL;

    CASE dice

      WHEN 1 THEN
        INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log_1);
        CALL repair_buildings(g_id,p_num);

      WHEN 2 THEN 
      BEGIN
        DECLARE x_appear,y_appear,x_dir,y_dir INT;
        DECLARE size INT;

        INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log_2);
        SELECT MIN(g.size) INTO size FROM vw_grave g WHERE g.game_id=g_id;
        IF size IS NOT NULL THEN
          SELECT ap.x,ap.y,ap.direction_into_board_x,ap.direction_into_board_y INTO x_appear,y_appear,x_dir,y_dir FROM appear_points ap WHERE ap.mode_id=mode_id AND ap.player_num=p_num;
          IF NOT EXISTS(SELECT id FROM board WHERE game_id=g_id AND x BETWEEN LEAST(x_appear,x_appear+x_dir*(size-1)) AND GREATEST(x_appear,x_appear+x_dir*(size-1)) AND y BETWEEN LEAST(y_appear,y_appear+y_dir*(size-1)) AND GREATEST(y_appear,y_appear+y_dir*(size-1)) LIMIT 1) THEN
            SET nonfinished_action=1;
          END IF;
        END IF;
      END;

      WHEN 3 THEN 
        INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log_3);
        UPDATE players SET gold=gold+riching_sum WHERE game_id=g_id AND player_num=p_num;
        CALL cmd_player_set_gold(g_id,p_num);

      WHEN 4 THEN 
        INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log_4);
        BEGIN
          DECLARE new_card INT;
          DECLARE first_card_id INT;
          DECLARE player_deck_id INT;
          DECLARE cmd_log_buyer VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Новая карта <b class=\'logCard\'>$card_name</b>")';
          DECLARE cmd_no_cards VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Карт больше нет")';

          WHILE take_cards_qty>0 AND EXISTS(SELECT id FROM deck WHERE game_id=g_id LIMIT 1) DO
            SET take_cards_qty=take_cards_qty-1;

            SELECT MIN(id) INTO first_card_id FROM deck WHERE game_id=g_id;
            SELECT card_id INTO new_card FROM deck WHERE game_id=g_id AND id=first_card_id;
            INSERT INTO player_deck (game_id,player_num,card_id) VALUES (g_id,p_num,new_card);
            SET player_deck_id=@@last_insert_id;
            DELETE FROM deck WHERE game_id=g_id AND id=first_card_id;

            CALL cmd_add_card(g_id,p_num,player_deck_id);

            INSERT INTO command (game_id,player_num,command,hidden_flag) VALUES (g_id,p_num,REPLACE(cmd_log_buyer,'$card_name',(SELECT code FROM cards WHERE id=new_card LIMIT 1)),1);
            IF (take_cards_qty>0) AND NOT EXISTS (SELECT id FROM deck WHERE game_id=g_id LIMIT 1) THEN
              INSERT INTO command (game_id,player_num,command,hidden_flag) VALUES (g_id,p_num,cmd_no_cards,1);
            END IF;
          END WHILE;
        END;

      WHEN 5 THEN 
        INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log_5);
        IF EXISTS(SELECT id FROM board_units WHERE game_id=g_id LIMIT 1) THEN
          SET nonfinished_action=2;
        END IF;

      WHEN 6 THEN 
        INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log_6);
        IF EXISTS(SELECT bb.id FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.game_id=g_id AND bb.player_num<>p_num AND b.`type`<>'castle' AND building_feature_check(bb.id,'not_movable')=0 LIMIT 1) THEN
          SET nonfinished_action=3;
        END IF;
    END CASE;

    IF(nonfinished_action=0)THEN
      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);
    ELSE
      UPDATE active_players SET nonfinished_action_id=nonfinished_action WHERE game_id=g_id AND player_num=p_num;
      SET cmd=REPLACE(cmd,'$cmd_name',(SELECT command_procedure FROM nonfinished_actions_dictionary WHERE id=nonfinished_action LIMIT 1));
      INSERT INTO command (game_id,player_num,command,hidden_flag) VALUES (g_id,p_num,cmd,2);
    END IF;

    CALL user_action_end();
  END IF;

END$$

DELIMITER ;

USE `lords`;
DROP procedure IF EXISTS `cast_show_cards`;

DELIMITER $$
USE `lords`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_show_cards`(g_id INT,p_num INT,player_deck_id INT,p2_num INT)
BEGIN
  DECLARE err_code INT;
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Карты игрока $log_player:")';
  DECLARE cmd_log_card VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("<b class=\'logCard\'>$card_name</b>")';
  DECLARE card_name VARCHAR(1000) CHARSET utf8;

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT c.code FROM player_deck pd JOIN cards c ON (pd.card_id=c.id) WHERE pd.game_id=g_id AND pd.player_num=p2_num;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;


  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_show_cards');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT id FROM players WHERE game_id=g_id AND player_num=p2_num) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=13;
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); 

      SET cmd_log=REPLACE(cmd_log,'$log_player',log_player(g_id,p2_num));
      INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

      OPEN cur;
      REPEAT
        FETCH cur INTO card_name;
        IF NOT done THEN
          INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,REPLACE(cmd_log_card,'$card_name',card_name));
        END IF;
      UNTIL done END REPEAT;
      CLOSE cur;

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END$$

DELIMITER ;

USE `lords`;
DROP procedure IF EXISTS `cast_telekinesis`;

DELIMITER $$
USE `lords`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_telekinesis`(g_id INT,p_num INT,player_deck_id INT,p2_num INT)
BEGIN
  DECLARE err_code INT;
  DECLARE rand_card INT;
  DECLARE big_dice INT;
  DECLARE stolen_card_id INT;
  DECLARE stolen_card_name VARCHAR(45) CHARSET utf8;
  DECLARE cmd_log_p VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Новая карта <b class=\'logCard\'>$card_name</b>")';
  DECLARE cmd_log_p2 VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Похищена карта <b class=\'logCard\'>$card_name</b>")';

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_telekinesis');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT id FROM players WHERE game_id=g_id AND player_num=p2_num) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=13;
    ELSE
      IF NOT EXISTS(SELECT id FROM player_deck WHERE game_id=g_id AND player_num=p2_num LIMIT 1) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=22;
      ELSE
        CALL user_action_begin();

        CALL play_card_actions(g_id,p_num,player_deck_id); 

        CREATE TEMPORARY TABLE pl_cards (id_rand INT AUTO_INCREMENT PRIMARY KEY)AUTO_INCREMENT=1 SELECT id AS `pd_id` FROM player_deck WHERE game_id=g_id AND player_num=p2_num;
        SELECT FLOOR(1 + (RAND() * MAX(id_rand))) INTO big_dice FROM pl_cards;
        SELECT pd_id INTO rand_card FROM pl_cards WHERE id_rand=big_dice LIMIT 1;
        DROP TEMPORARY TABLE pl_cards;

        SELECT card_id INTO stolen_card_id FROM player_deck WHERE id=rand_card;
        UPDATE player_deck SET player_num=p_num WHERE id=rand_card;
        CALL cmd_remove_card(g_id,p2_num,rand_card);
        CALL cmd_add_card(g_id,p_num,rand_card);

        SELECT code INTO stolen_card_name FROM cards WHERE id=stolen_card_id LIMIT 1;
        SET cmd_log_p=REPLACE(cmd_log_p,'$card_name',stolen_card_name);
        INSERT INTO command (game_id,player_num,command,hidden_flag) VALUES (g_id,p_num,cmd_log_p,1);
        SET cmd_log_p2=REPLACE(cmd_log_p2,'$card_name',stolen_card_name);
        INSERT INTO command (game_id,player_num,command,hidden_flag) VALUES (g_id,p2_num,cmd_log_p2,1);

        CALL finish_playing_card(g_id,p_num);
        CALL end_cards_phase(g_id,p_num);

        CALL user_action_end();
      END IF;
    END IF;
  END IF;

END$$

DELIMITER ;

USE `lords`;
DROP procedure IF EXISTS `play_card_actions`;

DELIMITER $$
USE `lords`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `play_card_actions`(g_id INT,p_num INT,player_deck_id INT)
BEGIN

  DECLARE crd_id INT;
  DECLARE card_cost INT;
  DECLARE card_type VARCHAR(5);
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_container($p_num,"Сыграл карту <b class=\'logCard\'>$card_name</b>")';

  SELECT card_id INTO crd_id FROM player_deck WHERE id=player_deck_id;


  SELECT cost,`type` INTO card_cost,card_type FROM cards WHERE id=crd_id LIMIT 1;
  IF card_cost>0 THEN
    UPDATE players SET gold=gold-card_cost WHERE game_id=g_id AND player_num=p_num;
    CALL cmd_player_set_gold(g_id,p_num);
  END IF;

  DELETE FROM player_deck WHERE id=player_deck_id;
  CALL cmd_remove_card(g_id,p_num,player_deck_id);
  IF(card_type IN ('m','e'))THEN INSERT INTO deck(game_id,card_id) VALUES(g_id,crd_id); END IF;

  SET cmd_log=REPLACE(cmd_log,'$p_num',p_num);
  SET cmd_log=REPLACE(cmd_log,'$card_name',(SELECT code FROM cards WHERE id=crd_id LIMIT 1));
  INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);
  INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'play_card',crd_id);
END$$

DELIMITER ;

USE `lords`;
DROP procedure IF EXISTS `vred_player_takes_card_from_everyone`;

DELIMITER $$
USE `lords`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `vred_player_takes_card_from_everyone`(g_id INT,p_num INT)
BEGIN
  DECLARE p2_num INT; 
  DECLARE random_card INT;
  DECLARE player_deck_id INT;
  DECLARE cmd_log_winer VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Новая карта <b class=\'logCard\'>$card_name</b>")';
  DECLARE cmd_log_loser VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_player вытянул карту <b class=\'logCard\'>$card_name</b>")';

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT DISTINCT p.player_num FROM player_deck p WHERE p.game_id=g_id AND p.player_num<>p_num;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    SET cmd_log_loser=REPLACE(cmd_log_loser,'$log_player',log_player(g_id,p_num));

    OPEN cur;
    REPEAT
      FETCH cur INTO p2_num;
      IF NOT done THEN
        SELECT id,card_id INTO player_deck_id,random_card FROM player_deck p WHERE p.game_id=g_id AND p.player_num=p2_num ORDER BY RAND() LIMIT 1;
        UPDATE player_deck SET player_num=p_num WHERE id=player_deck_id;

        CALL cmd_add_card(g_id,p_num,player_deck_id);
        CALL cmd_remove_card(g_id,p2_num,player_deck_id);

        INSERT INTO command (game_id,player_num,command,hidden_flag) VALUES (g_id,p2_num,REPLACE(cmd_log_loser,'$card_name',(SELECT code FROM cards WHERE id=random_card LIMIT 1)),1);
        INSERT INTO command (game_id,player_num,command,hidden_flag) VALUES (g_id,p_num,REPLACE(cmd_log_winer,'$card_name',(SELECT code FROM cards WHERE id=random_card LIMIT 1)),1);
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur;

END$$

DELIMITER ;


