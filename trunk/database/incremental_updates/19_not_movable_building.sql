use lords;

insert into building_features(code, description) values('not_movable','Здание нельзя переместить картами');
insert into error_dictionary(description) values('Извините, создатель мода не хотел, чтобы вы перемещали {0}');

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_polza_main` $$
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

    CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

    SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;

    SELECT FLOOR(1 + (RAND() * 6)) INTO dice FROM DUAL;
-- set dice=2;
    CASE dice

      WHEN 1 THEN
        INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log_1);
        CALL repair_buildings(g_id,p_num);

      WHEN 2 THEN /*resurrect*/
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

      WHEN 3 THEN /*+60$*/
        INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log_3);
        UPDATE players SET gold=gold+riching_sum WHERE game_id=g_id AND player_num=p_num;
        CALL cmd_player_set_gold(g_id,p_num);

      WHEN 4 THEN /*take 2 cards*/
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

            INSERT INTO command (game_id,player_num,command,hidden_flag) VALUES (g_id,p_num,REPLACE(cmd_log_buyer,'$card_name',(SELECT name FROM cards WHERE id=new_card LIMIT 1)),1);
            IF (take_cards_qty>0) AND NOT EXISTS (SELECT id FROM deck WHERE game_id=g_id LIMIT 1) THEN
              INSERT INTO command (game_id,player_num,command,hidden_flag) VALUES (g_id,p_num,cmd_no_cards,1);
            END IF;
          END WHILE;
        END;

      WHEN 5 THEN /*units from zone*/
        INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log_5);
        IF EXISTS(SELECT id FROM board_units WHERE game_id=g_id LIMIT 1) THEN
          SET nonfinished_action=2;
        END IF;

      WHEN 6 THEN /*move and own building*/
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

END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_polza_move_building` $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_polza_move_building`(g_id INT,p_num INT,b_x INT,b_y INT,x INT,y INT,rot INT,flp INT)
BEGIN
  DECLARE nonfinished_action INT DEFAULT 3;
  DECLARE board_building_id INT;
  DECLARE p2_num INT;
  DECLARE building_id INT;
  DECLARE building_name VARCHAR(45) CHARSET utf8;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;/*Not your turn*/
  ELSE
    IF NOT nonfinished_action=(SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=24;/*Can't finish nonfinished action*/
    ELSE
      SELECT b.ref INTO board_building_id FROM board b WHERE b.game_id=g_id AND b.`type` IN ('building','obstacle') AND b.x=b_x AND b.y=b_y LIMIT 1;
      IF board_building_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=26;/*Not a building*/
      ELSE
        SELECT bb.player_num INTO p2_num FROM board_buildings bb WHERE bb.id=board_building_id LIMIT 1;
        IF p2_num=p_num THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=27;/*Not an enemy building*/
        ELSE
          IF building_feature_check(board_building_id,'not_movable')=1 THEN
            SELECT bb.building_id INTO building_id FROM board_buildings bb WHERE bb.id=board_building_id;
            SELECT b.name INTO building_name FROM buildings b WHERE b.id=building_id;
            SELECT 0 AS `success`, ed.id as `error_code`, building_name as `error_params` FROM error_dictionary ed WHERE id=43;/*Not movable building*/
          ELSE
            CALL user_action_begin();

            /*set ref=0 to identify if building has been moved*/
            UPDATE board SET ref=0 WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=board_building_id;

            CALL place_building_on_board(board_building_id,x,y,rot,flp);

            IF NOT EXISTS(SELECT id FROM board WHERE game_id=g_id AND `type`<>'unit' AND ref=board_building_id) THEN /*Building not placed*/
              UPDATE board SET ref=board_building_id WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0;
              SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=12;/*Place occupied*/
            ELSE
            /*Building has been moved successfully*/
              DELETE FROM board WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0; /*Del old coords*/

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

END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_vred_main` $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_vred_main`(g_id INT,p_num INT,player_deck_id INT)
BEGIN
  DECLARE err_code INT;
  DECLARE dice INT;
  DECLARE nonfinished_action INT DEFAULT 0;
  DECLARE pooring_sum INT DEFAULT 60;
  DECLARE take_cards_qty INT DEFAULT 1;
  DECLARE cmd_log_1 VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Вред: -60 золота выбранному игроку")';
  DECLARE cmd_log_2 VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Вред: Убить любого юнита")';
  DECLARE cmd_log_3 VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Вред: Разрушить любое здание")';
  DECLARE cmd_log_4 VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Вред: Переместить всех юнитов в случайную зону")';
  DECLARE cmd_log_5 VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Вред: Случайный игрок тянет у всех по карте")';
  DECLARE cmd_log_6 VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Вред: Переместить чужое здание")';
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'execute_procedure("$cmd_name")';

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_vred_main');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    CALL user_action_begin();

    CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

    SELECT FLOOR(1 + (RAND() * 6)) INTO dice FROM DUAL;
-- set dice=6;
    CASE dice

      WHEN 1 THEN /* -60$ to player */
        INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log_1);
        SET nonfinished_action=4;

      WHEN 2 THEN /*kill unit*/
        INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log_2);
        IF EXISTS(SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id AND unit_feature_check(bu.id,'magic_immunity')=0 LIMIT 1) THEN
          SET nonfinished_action=5;
        END IF;

      WHEN 3 THEN /*destroy building*/
        INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log_3);
        IF EXISTS(SELECT bb.id FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.game_id=g_id AND b.`type`<>'castle' LIMIT 1) THEN
          SET nonfinished_action=6;
        END IF;

      WHEN 4 THEN /*units to random zone*/
      BEGIN
        DECLARE zone INT;

        INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log_4);
        SELECT FLOOR(RAND() * 4) INTO zone FROM DUAL;
        CALL units_to_zone(g_id,zone);
      END;

      WHEN 5 THEN /*random player takes a card from everyone*/
      BEGIN
        DECLARE random_player INT;

        INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log_5);

        SELECT player_num INTO random_player FROM players WHERE game_id=g_id AND player_num IN(0,1,2,3) AND owner<>0 ORDER BY RAND() LIMIT 1;
        CALL vred_player_takes_card_from_everyone(g_id,random_player);
      END;

      WHEN 6 THEN /*move enemy building*/
        INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log_6);
        IF EXISTS(SELECT bb.id FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.game_id=g_id AND bb.player_num<>p_num AND b.`type`<>'castle' AND building_feature_check(bb.id,'not_movable')=0 LIMIT 1) THEN
          SET nonfinished_action=7;
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


END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cast_vred_move_building` $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_vred_move_building`(g_id INT,p_num INT,b_x INT,b_y INT,x INT,y INT,rot INT,flp INT)
BEGIN
  DECLARE nonfinished_action INT DEFAULT 7;
  DECLARE board_building_id INT;
  DECLARE p2_num INT;
  DECLARE building_id INT;
  DECLARE building_name VARCHAR(45) CHARSET utf8;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;/*Not your turn*/
  ELSE
    IF NOT nonfinished_action=(SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=24;/*Can't finish nonfinished action*/
    ELSE
      SELECT b.ref INTO board_building_id FROM board b WHERE b.game_id=g_id AND b.`type` IN ('building','obstacle') AND b.x=b_x AND b.y=b_y LIMIT 1;
      IF board_building_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=26;/*Not a building*/
      ELSE
        SELECT bb.player_num INTO p2_num FROM board_buildings bb WHERE bb.id=board_building_id LIMIT 1;
        IF p2_num=p_num THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=27;/*Not an enemy building*/
        ELSE
          IF building_feature_check(board_building_id,'not_movable')=1 THEN
            SELECT bb.building_id INTO building_id FROM board_buildings bb WHERE bb.id=board_building_id;
            SELECT b.name INTO building_name FROM buildings b WHERE b.id=building_id;
            SELECT 0 AS `success`, ed.id as `error_code`, building_name as `error_params` FROM error_dictionary ed WHERE id=43;/*Not movable building*/
          ELSE
            CALL user_action_begin();

            /*set ref=0 to identify if building has been moved*/
            UPDATE board SET ref=0 WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=board_building_id;

            CALL place_building_on_board(board_building_id,x,y,rot,flp);

            IF NOT EXISTS(SELECT id FROM board WHERE game_id=g_id AND `type`<>'unit' AND ref=board_building_id) THEN /*Building not placed*/
              UPDATE board SET ref=board_building_id WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0;
              SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=12;/*Place occupied*/
            ELSE
            /*Building has been moved successfully*/
              DELETE FROM board WHERE game_id=g_id AND `type` IN ('building','obstacle') AND ref=0; /*Del old coords*/

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

END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`finish_nonfinished_action` $$
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
      DECLARE shape VARCHAR(45);
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
      DECLARE shape VARCHAR(45);
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

END $$

DELIMITER ;