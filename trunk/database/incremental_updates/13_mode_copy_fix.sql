use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`mode_copy` $$
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
		DECLARE building_shape VARCHAR(45) CHARSET utf8;
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


END $$

DELIMITER ;