use lords;

delimiter $$

DROP PROCEDURE IF EXISTS `lords`.`end_cards_phase` $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `end_cards_phase`(g_id INT,p_num INT)
BEGIN
  DECLARE g_mode INT;
  DECLARE two_phase_turn INT;

  SELECT g.mode_id INTO g_mode FROM games g WHERE g.id=g_id LIMIT 1;
  SELECT cfg.`value` INTO two_phase_turn FROM mode_config cfg WHERE cfg.param='two_phase_turn' AND cfg.mode_id=g_mode;

  IF(two_phase_turn IS NULL OR two_phase_turn=0)THEN
    CALL end_turn(g_id,p_num);
  ELSE
    UPDATE active_players SET card_played_flag=1 WHERE game_id=g_id AND player_num=p_num;
  END IF;

END $$

DELIMITER $$

DROP FUNCTION IF EXISTS `lords`.`check_play_card` $$
CREATE DEFINER=`root`@`localhost` FUNCTION `check_play_card`(g_id INT,p_num INT,player_deck_id INT,sender VARCHAR(30)) RETURNS int(11)
BEGIN
  DECLARE crd_id INT;
  
  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id LIMIT 1) THEN RETURN 1; END IF;/*Not your turn*/
  IF (SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id LIMIT 1)<>0 THEN RETURN 28; END IF;/*polza/vred in progress*/
  IF (SELECT units_moves_flag FROM active_players WHERE game_id=g_id LIMIT 1)=1 THEN RETURN 7; END IF;/*Already moved units*/
  IF (SELECT card_played_flag FROM active_players WHERE game_id=g_id LIMIT 1)=1 THEN RETURN 42; END IF;/*Already played card in this turn*/
  IF NOT EXISTS(SELECT id FROM player_deck WHERE game_id=g_id AND player_num=p_num AND id=player_deck_id) THEN RETURN 10; END IF;/*No such card*/
  
  SELECT card_id INTO crd_id FROM player_deck WHERE id=player_deck_id;
  IF (SELECT gold FROM players WHERE game_id=g_id AND player_num=p_num LIMIT 1)<(SELECT cost FROM cards WHERE id=crd_id LIMIT 1) THEN RETURN 2; END IF;/*Not enough gold*/
  IF NOT EXISTS(SELECT cp.id FROM player_deck pd JOIN cards_procedures cp ON pd.card_id=cp.card_id JOIN procedures pm ON cp.procedure_id=pm.id WHERE pd.id=player_deck_id AND pm.name=sender LIMIT 1) THEN RETURN 15; END IF;/*Cheater - procedure from another card*/

  UPDATE active_players SET current_procedure=sender WHERE game_id=g_id;

  RETURN 0;
END$$

DROP PROCEDURE IF EXISTS `cast_armageddon`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_armageddon`(g_id INT,p_num INT,player_deck_id INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE board_building_id INT;
  DECLARE chance INT DEFAULT 2;

  DECLARE done INT DEFAULT 0;
  /*all game units except magic-resistant*/
  DECLARE cur CURSOR FOR SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id;
  /*all game buildings except castles*/
  DECLARE cur2 CURSOR FOR SELECT bb.id FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.game_id=g_id AND b.`type`<>'castle';
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;


  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_armageddon');
  IF err_code<>0 THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    CALL user_action_begin();

    CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card,update log*/

    OPEN cur;
    REPEAT
      FETCH cur INTO board_unit_id;
      IF NOT done THEN
        IF (SELECT FLOOR(1 + (RAND() * 6)) as `dice` FROM DUAL)>chance THEN
          CALL magic_kill_unit(board_unit_id,p_num);
        END IF;
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur;

    SET done=0;

    OPEN cur2;
    REPEAT
      FETCH cur2 INTO board_building_id;
      IF NOT done THEN
        IF (SELECT FLOOR(1 + (RAND() * 6)) as `dice` FROM DUAL)>chance THEN
          CALL destroy_building(board_building_id,p_num);
        END IF;
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur2;

    CALL finish_playing_card(g_id,p_num);
    CALL end_cards_phase(g_id,p_num);

    CALL user_action_end();
  END IF;
END$$

DROP PROCEDURE IF EXISTS `cast_eagerness`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_eagerness`(g_id INT,p_num INT,player_deck_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE attack_bonus INT DEFAULT 2;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_eagerness');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;

      IF (SELECT FLOOR(1 + (RAND() * 6)) as `dice` FROM DUAL)<=3 THEN
        CALL unit_add_attack(board_unit_id,attack_bonus);
      ELSE
      /*knight move*/
        UPDATE board_units SET moves=1,moves_left=1 WHERE id=board_unit_id;
        CALL unit_feature_set(board_unit_id,'knight',null);
        CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);
        CALL cmd_unit_add_effect(g_id,board_unit_id,'knight');
      END IF;

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `cast_fireball`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_fireball`(g_id INT,p_num INT,player_deck_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE fb_damage INT DEFAULT 1;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_fireball');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

      IF (SELECT FLOOR(1 + (RAND() * 6)) as `dice` FROM DUAL)<3 THEN
        CALL cmd_miss_game_log(g_id,x,y);
      ELSE
        CALL magical_damage(g_id,p_num,x,y,fb_damage);
      END IF;

      INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'magical_attack');

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `cast_half_money`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_half_money`(g_id INT,p_num INT,player_deck_id INT)
BEGIN
  DECLARE err_code INT;
  DECLARE p_num_cur INT;

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT p.player_num FROM players p WHERE p.game_id=g_id AND owner<>0 AND gold>0;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_half_money');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    CALL user_action_begin();

    CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

/*half division*/
    UPDATE players SET gold=gold/2 WHERE game_id=g_id AND owner<>0 AND gold>0;

    OPEN cur;
    REPEAT
      FETCH cur INTO p_num_cur;
      IF NOT done THEN
        CALL cmd_player_set_gold(g_id,p_num_cur);
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur;


    CALL finish_playing_card(g_id,p_num);
    CALL end_cards_phase(g_id,p_num);

    CALL user_action_end();
  END IF;

END$$

DROP PROCEDURE IF EXISTS `cast_healing`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_healing`(g_id INT,p_num INT,player_deck_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE hp_heal INT DEFAULT 1;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_healing');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

      CALL magical_heal(g_id,p_num,x,y,hp_heal);

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `cast_lightening_max`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_lightening_max`(g_id INT,p_num INT,player_deck_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE li_damage INT DEFAULT 3;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_lightening_max');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

      IF (SELECT FLOOR(1 + (RAND() * 6)) as `dice` FROM DUAL)<4 THEN
        CALL cmd_miss_game_log(g_id,x,y);
      ELSE
        CALL magical_damage(g_id,p_num,x,y,li_damage);
      END IF;

      INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'magical_attack');

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `cast_lightening_min`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_lightening_min`(g_id INT,p_num INT,player_deck_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE li_damage INT DEFAULT 2;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_lightening_min');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

      IF (SELECT FLOOR(1 + (RAND() * 6)) as `dice` FROM DUAL)<3 THEN
        CALL cmd_miss_game_log(g_id,x,y);
      ELSE
        CALL magical_damage(g_id,p_num,x,y,li_damage);
      END IF;

      INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'magical_attack');

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `cast_madness`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_madness`(g_id INT,p_num INT,player_deck_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_madness');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;

      CALL make_mad(board_unit_id);

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `cast_meteor_shower`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_meteor_shower`(g_id INT,p_num INT,player_deck_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE x1,y1 INT;
  DECLARE meteor_damage INT DEFAULT 2;
  DECLARE meteor_size INT DEFAULT 2;

  DECLARE aim_id INT;
  DECLARE aim_type VARCHAR(45);

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT b.x,b.y,b.`type`,b.ref FROM board b WHERE b.game_id=g_id AND b.`type` IN ('unit','building') AND b.x BETWEEN x AND x+meteor_size-1 AND b.y BETWEEN y AND y+meteor_size-1;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_meteor_shower');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF (x<0 OR x>(20-meteor_size) OR y<0 OR y>(20-meteor_size)) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=23;/*Aim out of deck*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

      OPEN cur;
      REPEAT
        FETCH cur INTO x1,y1,aim_type,aim_id;
        IF NOT done THEN
          /*check whether aim is still alive*/
          IF((aim_type='unit' AND EXISTS(SELECT bu.id FROM board_units bu WHERE bu.id=aim_id LIMIT 1))
            OR(aim_type='building' AND EXISTS(SELECT bb.id FROM board_buildings bb WHERE bb.id=aim_id LIMIT 1)))THEN
            CALL magical_damage(g_id,p_num,x1,y1,meteor_damage);
          END IF;
        END IF;
      UNTIL done END REPEAT;
      CLOSE cur;

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `cast_mind_control`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_mind_control`(g_id INT,p_num INT,player_deck_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE p2_num INT;
  DECLARE dice INT;
  DECLARE npc_gold INT;
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit начинает подчиняться игроку $log_player")';

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_mind_control');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;
      SELECT bu.player_num INTO p2_num FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

      SELECT FLOOR(1 + (RAND() * 6)) INTO dice FROM DUAL;
      IF (dice<=3) THEN /*make mad*/
        CALL make_mad(board_unit_id);
      ELSE

/*remove necromancer control from unit*/
        IF(unit_feature_check(board_unit_id,'under_control')=1)THEN
          CALL unit_feature_remove(board_unit_id,'under_control');
        END IF;

/*if unit was mad - it becomes not mad*/
        IF(unit_feature_check(board_unit_id,'madness')=1)THEN
          CALL unit_feature_set(board_unit_id,'madness',p_num);
          CALL make_not_mad(board_unit_id);
        END IF;

/*change owner*/
        IF(p_num<>p2_num)THEN
          UPDATE board_units SET player_num=p_num,moves_left=0 WHERE id=board_unit_id;
          CALL cmd_unit_set_owner(g_id,p_num,board_unit_id);
		  CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

/*if it was npc*/
          IF (((SELECT owner FROM players WHERE game_id=g_id AND player_num=p2_num LIMIT 1)<>1)
            AND NOT EXISTS (SELECT id FROM board_units WHERE game_id=g_id AND player_num=p2_num)
            AND NOT EXISTS (SELECT id FROM board_buildings WHERE game_id=g_id AND player_num=p2_num))
          THEN
            SELECT gold INTO npc_gold FROM players WHERE game_id=g_id AND player_num=p2_num LIMIT 1; /*take npc gold*/
            IF(npc_gold>0)THEN
              UPDATE players SET gold=gold+npc_gold WHERE game_id=g_id AND player_num=p_num;
              CALL cmd_player_set_gold(g_id,p_num);
            END IF;

            DELETE FROM players WHERE game_id=g_id AND player_num=p2_num; /*delete npc player*/
            CALL cmd_delete_player(g_id,p2_num);
          END IF;

        ELSE
          SET cmd_log=REPLACE(cmd_log,'начинает','продолжает');
        END IF;

/*zombies change player too*/
        IF EXISTS(SELECT id FROM board_units_features WHERE feature_id=unit_feature_get_id_by_code('under_control') AND param=board_unit_id LIMIT 1)THEN
          CALL zombies_change_player_to_nec(board_unit_id);
        END IF;


/*log*/
        SET cmd_log=REPLACE(cmd_log,'$log_unit',log_unit(board_unit_id));
        SET cmd_log=REPLACE(cmd_log,'$log_player',log_player(g_id,p_num));
        INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

      END IF;

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `zombies_change_player_to_nec`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `zombies_change_player_to_nec`(nec_board_id INT)
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
		  CALL cmd_unit_set_moves_left(g_id,p_num,zombie_board_id);

/*if it was npc*/
          IF ((SELECT owner FROM players WHERE game_id=g_id AND player_num=zombie_p_num LIMIT 1)<>1)
            AND NOT EXISTS (SELECT id FROM board_units WHERE game_id=g_id AND player_num=zombie_p_num)
            AND NOT EXISTS (SELECT id FROM board_buildings WHERE game_id=g_id AND player_num=zombie_p_num)
          THEN
            SELECT gold INTO npc_gold FROM players WHERE game_id=g_id AND player_num=zombie_p_num LIMIT 1; /*take npc gold*/
            IF(npc_gold>0)THEN
              UPDATE players SET gold=gold+riching_sum WHERE game_id=g_id AND player_num=nec_p_num;
              CALL cmd_player_set_gold(g_id,nec_p_num);
            END IF;

            DELETE FROM players WHERE game_id=g_id AND player_num=zombie_p_num; /*delete npc player*/
            CALL cmd_delete_player(g_id,zombie_p_num);
          END IF;

      END IF;
    UNTIL done END REPEAT;
    CLOSE cur;


END$$

DROP PROCEDURE IF EXISTS `cast_o_d`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_o_d`(g_id INT,p_num INT,player_deck_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE shield INT;
  DECLARE dice INT;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_o_d');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;
      SELECT bu.shield INTO shield FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

      IF (unit_feature_check(board_unit_id,'magic_immunity')=0) THEN /*if not magic-resistant*/

        SELECT FLOOR(1 + (RAND() * 6)) INTO dice FROM DUAL;

        IF dice=5 THEN /*total heal*/
          CALL total_heal(board_unit_id);
        ELSE
          IF shield>0 THEN
            CALL shield_off(board_unit_id);
          ELSE
            IF dice=6 THEN /*madness*/
              CALL make_mad(board_unit_id);
            ELSE /*kill*/
              CALL kill_unit(board_unit_id,p_num);
            END IF;
          END IF;
        END IF;
      ELSE
        CALL cmd_magic_resistance_log(g_id,p_num,board_unit_id);
      END IF;

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `cast_paralich`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_paralich`(g_id INT,p_num INT,player_deck_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE shield INT;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_paralich');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;
      SELECT bu.shield INTO shield FROM board_units bu WHERE bu.id=board_unit_id LIMIT 1;

      IF (unit_feature_check(board_unit_id,'magic_immunity')=0) THEN /*if not magic-resistant*/
        IF shield>0 THEN
          CALL shield_off(board_unit_id);
        ELSE
          CALL unit_feature_set(board_unit_id,'paralich',null);
          CALL cmd_unit_add_effect(g_id,board_unit_id,'paralich');
        END IF;
      ELSE
        CALL cmd_magic_resistance_log(g_id,p_num,board_unit_id);
      END IF;

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `cast_polza_main`$$
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
        IF EXISTS(SELECT bb.id FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.game_id=g_id AND bb.player_num<>p_num AND b.`type`<>'castle' LIMIT 1) THEN
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

DROP PROCEDURE IF EXISTS `cast_polza_move_building`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_polza_move_building`(g_id INT,p_num INT,b_x INT,b_y INT,x INT,y INT,rot INT,flp INT)
BEGIN
  DECLARE nonfinished_action INT DEFAULT 3;
  DECLARE board_building_id INT;
  DECLARE p2_num INT;

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

END$$

DROP PROCEDURE IF EXISTS `cast_polza_resurrect`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_polza_resurrect`(g_id INT,p_num INT,grave_id INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE nonfinished_action INT DEFAULT 1;
  DECLARE x_appear,y_appear,x_dir,y_dir INT;
  DECLARE size INT;
  DECLARE u_id INT;
  DECLARE dead_card_id INT;

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;/*Not your turn*/
  ELSE
    IF NOT nonfinished_action=(SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=24;/*Can't finish nonfinished action*/
    ELSE
      IF NOT EXISTS(SELECT id FROM graves WHERE game_id=g_id AND id=grave_id LIMIT 1) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=8;/*Card not in grave*/
      ELSE
          CALL user_action_begin();

          SELECT g.card_id INTO dead_card_id FROM graves g WHERE id=grave_id;
          SELECT ap.x,ap.y,ap.direction_into_board_x,ap.direction_into_board_y INTO x_appear,y_appear,x_dir,y_dir FROM appear_points ap WHERE ap.mode_id=mode_id AND ap.player_num=p_num;
          SELECT u.id,u.size INTO u_id,size FROM cards c JOIN units u ON c.ref=u.id WHERE c.id=dead_card_id LIMIT 1;
          IF EXISTS(SELECT id FROM board WHERE game_id=g_id AND x BETWEEN LEAST(x_appear,x_appear+x_dir*(size-1)) AND GREATEST(x_appear,x_appear+x_dir*(size-1)) AND y BETWEEN LEAST(y_appear,y_appear+y_dir*(size-1)) AND GREATEST(y_appear,y_appear+y_dir*(size-1)) LIMIT 1) THEN
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=9;/*Appear point occupied*/
          ELSE

            CALL resurrect(g_id,p_num,grave_id);
            CALL cmd_resurrect_by_card_log(g_id,p_num,dead_card_id);

            UPDATE command SET hidden_flag=1 WHERE game_id=g_id AND player_num=p_num AND hidden_flag=2;
            UPDATE active_players SET nonfinished_action_id=0 WHERE game_id=g_id AND player_num=p_num;

            CALL finish_playing_card(g_id,p_num);
            CALL end_cards_phase(g_id,p_num);

            CALL user_action_end();
          END IF;
      END IF;
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `cast_polza_units_from_zone`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_polza_units_from_zone`(g_id INT,p_num INT,zone INT)
BEGIN
  DECLARE nonfinished_action INT DEFAULT 2;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;/*Not your turn*/
  ELSE
    IF NOT nonfinished_action=(SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=24;/*Can't finish nonfinished action*/
    ELSE
      IF zone NOT IN(0,1,2,3) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=25;/*Invalid zone*/
      ELSE
            CALL user_action_begin();

            CALL units_from_zone(g_id,zone);

            UPDATE command SET hidden_flag=1 WHERE game_id=g_id AND player_num=p_num AND hidden_flag=2;
            UPDATE active_players SET nonfinished_action_id=0 WHERE game_id=g_id AND player_num=p_num;

            CALL finish_playing_card(g_id,p_num);
            CALL end_cards_phase(g_id,p_num);

            CALL user_action_end();
      END IF;
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `units_from_zone`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `units_from_zone`(g_id INT,zone INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE u_x,u_y,new_x,new_y INT;
  DECLARE board_unit_id INT;
  DECLARE size INT;

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR
    SELECT b.ref,MIN(b.x),MIN(b.y),u.size
    FROM board b
    JOIN board_units bu ON (b.ref=bu.id)
    JOIN units u ON (bu.unit_id=u.id)
    WHERE b.`type`='unit' AND b.game_id=g_id
    GROUP BY b.ref,u.size
    HAVING quart(MIN(b.x),MIN(b.y))=zone;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;

    OPEN cur;
    REPEAT
      FETCH cur INTO board_unit_id,u_x,u_y,size;
      IF NOT done THEN
        IF size=1 THEN /*ordinary units*/
          /*define new coords*/
          SELECT a.x,a.y INTO new_x,new_y FROM allcoords a
          LEFT JOIN board b ON (a.x=b.x AND a.y=b.y AND b.game_id=g_id)
          WHERE a.mode_id=mode_id AND quart(a.x,a.y)<>zone AND b.id IS NULL
          ORDER BY ((u_x-a.x)*(u_x-a.x)+(u_y-a.y)*(u_y-a.y)) LIMIT 1;

          CALL move_unit(board_unit_id,new_x,new_y);
        ELSE /*dragons*/
          /*define new coords*/
          SELECT a.x,a.y INTO new_x,new_y FROM allcoords a
          WHERE a.mode_id=mode_id AND quart(a.x,a.y)<>zone
          AND NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x BETWEEN a.x AND a.x+size-1 AND b.y BETWEEN a.y AND a.y+size-1 LIMIT 1)
          ORDER BY ((u_x-a.x)*(u_x-a.x)+(u_y-a.y)*(u_y-a.y)) LIMIT 1;

          CALL move_unit(board_unit_id,new_x,new_y);
          UPDATE board_units SET moves_left=0 WHERE id=board_unit_id;
          CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);
        END IF;
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur;

END$$

DROP PROCEDURE IF EXISTS `cast_pooring`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_pooring`(g_id INT,p_num INT,player_deck_id INT,p2_num INT)
BEGIN
  DECLARE err_code INT;
  DECLARE pooring_sum INT DEFAULT 50;
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_player теряет $log_gold")';

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_pooring');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT id FROM players WHERE game_id=g_id AND player_num=p2_num) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=13;/*Player doesn't exist*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

/*pooring*/
      UPDATE players SET gold=CASE WHEN gold<pooring_sum THEN 0 ELSE gold-pooring_sum END WHERE game_id=g_id AND player_num=p2_num;
      CALL cmd_player_set_gold(g_id,p2_num);

      SET cmd_log=REPLACE(cmd_log,'$log_player',log_player(g_id,p2_num));
      SET cmd_log=REPLACE(cmd_log,'$log_gold',log_gold(pooring_sum));

      INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;
END$$

DROP PROCEDURE IF EXISTS `cast_repair_buildings`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_repair_buildings`(g_id INT,p_num INT,player_deck_id INT)
BEGIN
  DECLARE err_code INT;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_repair_buildings');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    CALL user_action_begin();

    CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

    CALL repair_buildings(g_id,p_num);

    CALL finish_playing_card(g_id,p_num);
    CALL end_cards_phase(g_id,p_num);

    CALL user_action_end();
  END IF;

END$$

DROP PROCEDURE IF EXISTS `cast_riching`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_riching`(g_id INT,p_num INT,player_deck_id INT)
BEGIN
  DECLARE err_code INT;
  DECLARE riching_sum INT DEFAULT 50;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_riching');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    CALL user_action_begin();

    CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

/*player gold*/
    UPDATE players SET gold=gold+riching_sum WHERE game_id=g_id AND player_num=p_num;
    CALL cmd_player_set_gold(g_id,p_num);

    CALL finish_playing_card(g_id,p_num);
    CALL end_cards_phase(g_id,p_num);

    CALL user_action_end();
  END IF;

END$$

DROP PROCEDURE IF EXISTS `cast_russian_ruletka`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_russian_ruletka`(g_id INT,p_num INT,player_deck_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_russian_ruletka');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

      SELECT ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;

      IF (SELECT FLOOR(1 + (RAND() * 6)) as `dice` FROM DUAL)<6 THEN
        CALL cmd_miss_russian_rul(board_unit_id);
      ELSE
        CALL kill_unit(board_unit_id,p_num);
      END IF;

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `cast_shield`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_shield`(g_id INT,p_num INT,player_deck_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_shield');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;

      CALL magical_shield_on(g_id,p_num,x,y);

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `cast_show_cards`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_show_cards`(g_id INT,p_num INT,player_deck_id INT,p2_num INT)
BEGIN
  DECLARE err_code INT;
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("Карты игрока $log_player:")';
  DECLARE cmd_log_card VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("<b class=\'logCard\'>$card_name</b>")';
  DECLARE card_name VARCHAR(1000) CHARSET utf8;

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT c.name FROM player_deck pd JOIN cards c ON (pd.card_id=c.id) WHERE pd.game_id=g_id AND pd.player_num=p2_num;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;


  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_show_cards');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT id FROM players WHERE game_id=g_id AND player_num=p2_num) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=13;/*Player doesn't exist*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

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

DROP PROCEDURE IF EXISTS `cast_speeding`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_speeding`(g_id INT,p_num INT,player_deck_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE speed_bonus INT DEFAULT 2;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_speeding');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;

      CALL unit_add_moves(board_unit_id,speed_bonus);

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `cast_telekinesis`$$
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
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=13;/*Player doesn't exist*/
    ELSE
      IF NOT EXISTS(SELECT id FROM player_deck WHERE game_id=g_id AND player_num=p2_num LIMIT 1) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=22;/*Player doesn't have cards*/
      ELSE
        CALL user_action_begin();

        CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

        CREATE TEMPORARY TABLE pl_cards (id_rand INT AUTO_INCREMENT PRIMARY KEY)AUTO_INCREMENT=1 SELECT id AS `pd_id` FROM player_deck WHERE game_id=g_id AND player_num=p2_num;
        SELECT FLOOR(1 + (RAND() * MAX(id_rand))) INTO big_dice FROM pl_cards;
        SELECT pd_id INTO rand_card FROM pl_cards WHERE id_rand=big_dice LIMIT 1;
        DROP TEMPORARY TABLE pl_cards;

        SELECT card_id INTO stolen_card_id FROM player_deck WHERE id=rand_card;
        UPDATE player_deck SET player_num=p_num WHERE id=rand_card;
        CALL cmd_remove_card(g_id,p2_num,rand_card);
        CALL cmd_add_card(g_id,p_num,rand_card);

        SELECT name INTO stolen_card_name FROM cards WHERE id=stolen_card_id LIMIT 1;
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

DROP PROCEDURE IF EXISTS `cast_teleport`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_teleport`(g_id INT,p_num INT,player_deck_id INT,x INT,y INT, x2 INT, y2 INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE u_id INT;
  DECLARE size INT;
  DECLARE target INT;
  DECLARE binded_unit_id INT;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_teleport');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
    ELSE
      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;
      SELECT bu.unit_id,u.size INTO u_id,size FROM board_units bu JOIN units u ON (bu.unit_id=u.id) WHERE bu.id=board_unit_id LIMIT 1;

      IF EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x BETWEEN x2 AND x2+size-1 AND b.y BETWEEN y2 AND y2+size-1 AND NOT(b.`type`='unit' AND b.ref=board_unit_id) LIMIT 1) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=12;/*Place occupied*/
      ELSE
        CALL user_action_begin();

        CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

        IF (unit_feature_check(board_unit_id,'magic_immunity')=0) THEN /*if not magic-resistant*/

          IF (unit_feature_get_param(board_unit_id,'bind_target') IS NOT NULL) THEN /*if taran is binded to another unit - unbind it*/
            CALL unit_feature_remove(board_unit_id,'bind_target');
          END IF; /*unbind taran*/

          CALL move_unit(board_unit_id,x2,y2);
          UPDATE board_units SET moves_left=0 WHERE id=board_unit_id;
          CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

          /*unbind all units binded to this unit*/
          DELETE FROM board_units_features WHERE feature_id=unit_feature_get_id_by_code('bind_target') AND param=board_unit_id;

        ELSE
          CALL cmd_magic_resistance_log(g_id,p_num,board_unit_id);
        END IF;

        CALL finish_playing_card(g_id,p_num);
        CALL end_cards_phase(g_id,p_num);

        CALL user_action_end();
      END IF;
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `cast_unit_upgrade_all`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_unit_upgrade_all`(g_id INT,p_num INT,player_deck_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE speed_bonus INT DEFAULT 1;
  DECLARE health_bonus INT DEFAULT 1;
  DECLARE attack_bonus INT DEFAULT 1;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_unit_upgrade_all');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;

      CALL unit_add_moves(board_unit_id,speed_bonus);
      CALL unit_add_health(board_unit_id,health_bonus);
      CALL unit_add_attack(board_unit_id,attack_bonus);

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `cast_unit_upgrade_random`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_unit_upgrade_random`(g_id INT,p_num INT,player_deck_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE dice INT;
  DECLARE speed_bonus INT DEFAULT 3;
  DECLARE health_bonus INT DEFAULT 3;
  DECLARE attack_bonus INT DEFAULT 3;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_unit_upgrade_random');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

      SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;

      SELECT FLOOR(1 + (RAND() * 3)) INTO dice FROM DUAL;
      IF dice=1 THEN
        CALL unit_add_moves(board_unit_id,speed_bonus);
      END IF;
      IF dice=2 THEN
        CALL unit_add_health(board_unit_id,health_bonus);
      END IF;
      IF dice=3 THEN
        CALL unit_add_attack(board_unit_id,attack_bonus);
      END IF;

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `cast_vampire`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_vampire`(g_id INT,p_num INT,player_deck_id INT,x INT,y INT)
BEGIN
  DECLARE err_code INT;
  DECLARE mode_id INT;
  DECLARE vamp_ui_code VARCHAR(45) CHARSET utf8 DEFAULT 'vampire'; /*use this to find vampire unit in current mode*/
  DECLARE vamp_u_id INT;
  DECLARE vamp_owner INT DEFAULT 4;
  DECLARE team INT;
  DECLARE new_player INT;
  DECLARE vamp_name VARCHAR(45) CHARSET utf8;
  DECLARE new_unit_id INT;
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("В клетке $log_cell появляется $log_unit")';

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_vampire');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    IF (quart(x,y)<>p_num) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=35;/*Can summon vampire only in my zone*/
    ELSE
      IF EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y LIMIT 1) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=9;/*Appear point occupied*/
      ELSE
/*OK*/
        CALL user_action_begin();

        CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

        SELECT MAX(p.team)+1 INTO team FROM players p WHERE p.game_id=g_id;
        SELECT CASE WHEN MAX(p.player_num)<10 THEN 10 ELSE MAX(p.player_num)+1 END INTO new_player FROM players p WHERE p.game_id=g_id;

        SELECT vu.id INTO vamp_u_id FROM vw_mode_units vu WHERE vu.mode_id=mode_id AND vu.ui_code=vamp_ui_code;
        SELECT name INTO vamp_name FROM units WHERE id=vamp_u_id LIMIT 1;

        INSERT INTO players(game_id,player_num,name,gold,owner,team) VALUES(g_id,new_player,vamp_name,0,vamp_owner,team);
        CALL cmd_add_player(g_id,new_player);

        INSERT INTO board_units(game_id,player_num,unit_id) VALUES(g_id,new_player,vamp_u_id);
        SET new_unit_id=@@last_insert_id;
        INSERT INTO board_units_features(board_unit_id,feature_id,param) SELECT new_unit_id,ufu.feature_id,ufu.param FROM unit_default_features ufu WHERE ufu.unit_id=vamp_u_id;

        INSERT INTO board(game_id,x,y,`type`,ref) VALUES (g_id,x,y,'unit',new_unit_id);

        CALL cmd_add_unit_by_id(g_id,new_player,new_unit_id);

/*log*/
        SET cmd_log=REPLACE(cmd_log,'$log_unit',log_unit(new_unit_id));
        SET cmd_log=REPLACE(cmd_log,'$log_cell',log_cell(x,y));
        INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

        CALL finish_playing_card(g_id,p_num);
        CALL end_cards_phase(g_id,p_num);

        CALL user_action_end();
      END IF;
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `cast_vred_destroy_building`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_vred_destroy_building`(g_id INT,p_num INT,x INT,y INT)
BEGIN
  DECLARE nonfinished_action INT DEFAULT 6;
  DECLARE board_building_id INT;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;/*Not your turn*/
  ELSE
    IF NOT nonfinished_action=(SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=24;/*Can't finish nonfinished action*/
    ELSE
      SELECT b.ref INTO board_building_id FROM board b WHERE b.game_id=g_id AND b.`type` IN ('building','obstacle') AND b.x=x AND b.y=y LIMIT 1;
      IF board_building_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=26;/*Not a building*/
      ELSE
        CALL user_action_begin();

        CALL destroy_building(board_building_id,p_num);

        UPDATE command SET hidden_flag=1 WHERE game_id=g_id AND player_num=p_num AND hidden_flag=2;
        UPDATE active_players SET nonfinished_action_id=0 WHERE game_id=g_id AND player_num=p_num;

        CALL finish_playing_card(g_id,p_num);
        CALL end_cards_phase(g_id,p_num);

        CALL user_action_end();
      END IF;
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `cast_vred_kill_unit`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_vred_kill_unit`(g_id INT,p_num INT,x INT,y INT)
BEGIN
  DECLARE nonfinished_action INT DEFAULT 5;
  DECLARE board_unit_id INT;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;/*Not your turn*/
  ELSE
    IF NOT nonfinished_action=(SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=24;/*Can't finish nonfinished action*/
    ELSE
      IF NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit') THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=14;/*Not a unit*/
      ELSE
        CALL user_action_begin();

        SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y;

        CALL magic_kill_unit(board_unit_id,p_num);

        UPDATE command SET hidden_flag=1 WHERE game_id=g_id AND player_num=p_num AND hidden_flag=2;
        UPDATE active_players SET nonfinished_action_id=0 WHERE game_id=g_id AND player_num=p_num;

        CALL finish_playing_card(g_id,p_num);
        CALL end_cards_phase(g_id,p_num);

        CALL user_action_end();
      END IF;
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `cast_vred_main`$$
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
        IF EXISTS(SELECT bb.id FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.game_id=g_id AND bb.player_num<>p_num AND b.`type`<>'castle' LIMIT 1) THEN
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


END$$

DROP PROCEDURE IF EXISTS `cast_vred_move_building`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_vred_move_building`(g_id INT,p_num INT,b_x INT,b_y INT,x INT,y INT,rot INT,flp INT)
BEGIN
  DECLARE nonfinished_action INT DEFAULT 7;
  DECLARE board_building_id INT;
  DECLARE p2_num INT;

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

END$$

DROP PROCEDURE IF EXISTS `cast_vred_pooring`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cast_vred_pooring`(g_id INT,p_num INT,p2_num INT)
BEGIN
  DECLARE nonfinished_action INT DEFAULT 4;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;/*Not your turn*/
  ELSE
    IF NOT nonfinished_action=(SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=24;/*Can't finish nonfinished action*/
    ELSE
      IF NOT EXISTS(SELECT id FROM players WHERE game_id=g_id AND player_num=p2_num AND owner<>0) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=13;/*Player doesn't exist*/
      ELSE
        CALL user_action_begin();

        CALL vred_pooring(g_id,p2_num);

        UPDATE command SET hidden_flag=1 WHERE game_id=g_id AND player_num=p_num AND hidden_flag=2;
        UPDATE active_players SET nonfinished_action_id=0 WHERE game_id=g_id AND player_num=p_num;

        CALL finish_playing_card(g_id,p_num);
        CALL end_cards_phase(g_id,p_num);

        CALL user_action_end();
      END IF;
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `units_to_zone`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `units_to_zone`(g_id INT,zone INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE u_x,u_y,new_x,new_y INT;
  DECLARE board_unit_id INT;
  DECLARE size INT;

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR
    SELECT b.ref,MIN(b.x),MIN(b.y),u.size
    FROM board b
    JOIN board_units bu ON (b.ref=bu.id)
    JOIN units u ON (bu.unit_id=u.id)
    WHERE b.`type`='unit' AND b.game_id=g_id AND unit_feature_check(bu.id,'magic_immunity')=0 /*not golem*/
    GROUP BY b.ref,u.size
    HAVING quart(MIN(b.x),MIN(b.y))<>zone;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;

    OPEN cur;
    REPEAT
      FETCH cur INTO board_unit_id,u_x,u_y,size;
      IF NOT done THEN
        IF size=1 THEN /*ordinary units*/
          /*define new coords*/
          SELECT a.x,a.y INTO new_x,new_y FROM allcoords a
          LEFT JOIN board b ON (a.x=b.x AND a.y=b.y AND b.game_id=g_id)
          WHERE a.mode_id=mode_id AND quart(a.x,a.y)=zone AND b.id IS NULL
          ORDER BY ((u_x-a.x)*(u_x-a.x)+(u_y-a.y)*(u_y-a.y)) LIMIT 1;

          CALL move_unit(board_unit_id,new_x,new_y);
        ELSE /*dragons*/
          /*define new coords*/
          SELECT a.x,a.y INTO new_x,new_y FROM allcoords a
          WHERE a.mode_id=mode_id AND quart(a.x,a.y)=zone
          AND NOT EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x BETWEEN a.x AND a.x+size-1 AND b.y BETWEEN a.y AND a.y+size-1 LIMIT 1)
          ORDER BY ((u_x-a.x)*(u_x-a.x)+(u_y-a.y)*(u_y-a.y)) LIMIT 1;

          CALL move_unit(board_unit_id,new_x,new_y);
          UPDATE board_units SET moves_left=0 WHERE id=board_unit_id;
          CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);
        END IF;
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur;

END$$

DROP PROCEDURE IF EXISTS `buy_card`$$
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
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;/*Not your turn*/
  ELSE
    IF (SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id LIMIT 1)<>0 THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=28;/*polza/vred in progress*/
    ELSE
      IF (SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=1 THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=7;/*Already moved units*/
      ELSE
        IF (SELECT card_played_flag FROM active_players WHERE game_id=g_id)=1 THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=42;/*Already played card in this turn*/
        ELSE
          IF (SELECT gold FROM players WHERE game_id=g_id AND player_num=p_num)<card_cost THEN
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=2;/*Not enough gold*/
          ELSE
            IF NOT EXISTS (SELECT id FROM deck WHERE game_id=g_id) THEN
              SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=3;/*No cards left*/
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
              /*For all players except byer - without card name*/
              INSERT INTO command (game_id,player_num,command) VALUES(g_id,p_num,cmd_log);

              SET cmd_log_buyer=REPLACE(cmd_log_buyer,'$p_num',p_num);
              INSERT INTO command (game_id,player_num,command,hidden_flag)
                VALUES (g_id,p_num,REPLACE(cmd_log_buyer,'$card_name',(SELECT CONCAT(' (',name,')') FROM cards WHERE id=new_card LIMIT 1)),1);

              INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'buy_card');
              CALL end_cards_phase(g_id,p_num);

              CALL user_action_end();
            END IF;
          END IF;
        END IF;
      END IF;
    END IF;
  END IF;
END$$

DROP PROCEDURE IF EXISTS `player_resurrect`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `player_resurrect`(g_id INT,p_num INT,grave_id INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE dead_card_id INT;
  DECLARE resurrection_cost_coefficient INT;
  DECLARE resur_cost INT;
  DECLARE x_appear,y_appear,x_dir,y_dir INT;
  DECLARE new_unit_id INT;
  DECLARE size INT;
  DECLARE u_id INT;

  DECLARE cmd_independent_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_independent_message($p_num,"Воскресил $log_unit_rod_pad")';

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
  SELECT cfg.`value` INTO resurrection_cost_coefficient FROM mode_config cfg WHERE cfg.param='resurrection cost coefficient' AND cfg.mode_id=mode_id;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=1;/*Not your turn*/
  ELSE
    IF (SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id LIMIT 1)<>0 THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=28;/*polza/vred in progress*/
    ELSE
      IF (SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=1 THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=7;/*Already moved units*/
      ELSE
        IF (SELECT card_played_flag FROM active_players WHERE game_id=g_id)=1 THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=42;/*Already played card in this turn*/
        ELSE
          IF NOT EXISTS(SELECT id FROM graves WHERE game_id=g_id AND id=grave_id LIMIT 1) THEN
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=8;/*Card not in grave*/
          ELSE
            SELECT g.card_id INTO dead_card_id FROM graves g WHERE id=grave_id;
            SELECT cost*resurrection_cost_coefficient INTO resur_cost FROM cards WHERE id=dead_card_id LIMIT 1;
            IF (SELECT gold FROM players WHERE game_id=g_id AND player_num=p_num LIMIT 1)<resur_cost THEN
              SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=2;/*Not enough gold*/
            ELSE
              SELECT ap.x,ap.y,ap.direction_into_board_x,ap.direction_into_board_y INTO x_appear,y_appear,x_dir,y_dir FROM appear_points ap WHERE ap.mode_id=mode_id AND ap.player_num=p_num;
              SELECT u.id,u.size INTO u_id,size FROM cards c JOIN units u ON c.ref=u.id WHERE c.id=dead_card_id LIMIT 1;
              IF EXISTS(SELECT id FROM board WHERE game_id=g_id AND x BETWEEN LEAST(x_appear,x_appear+x_dir*(size-1)) AND GREATEST(x_appear,x_appear+x_dir*(size-1)) AND y BETWEEN LEAST(y_appear,y_appear+y_dir*(size-1)) AND GREATEST(y_appear,y_appear+y_dir*(size-1)) LIMIT 1) THEN
                SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=9;/*Appear point occupied*/
              ELSE
                CALL user_action_begin();

                UPDATE players SET gold=gold-resur_cost WHERE game_id=g_id AND player_num=p_num;
                CALL cmd_player_set_gold(g_id,p_num);

                CALL resurrect(g_id,p_num,grave_id);
/*log*/
                SET cmd_independent_log=REPLACE(cmd_independent_log,'$p_num',p_num);
                SET cmd_independent_log=REPLACE(cmd_independent_log,'$log_unit_rod_pad',log_unit_rod_pad((SELECT MAX(id) FROM board_units bu WHERE bu.game_id=g_id AND bu.player_num=p_num))); /*hope that resurrected unit has max id*/
                INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_independent_log);

                CALL end_cards_phase(g_id,p_num);

                CALL user_action_end();
              END IF;
            END IF;
          END IF;
        END IF;
      END IF;
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `put_building`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `put_building`(g_id INT,p_num INT,player_deck_id INT,x INT,y INT,rotation INT,flip INT)
BEGIN
  DECLARE crd_id INT;
  DECLARE err_code INT;
  DECLARE x_len,y_len INT;
  DECLARE x2,y2 INT; /*For determining whether whole building is in player's zone, if (x,y) and (x2,y2) are*/
  DECLARE new_building_id INT;
  DECLARE card_cost INT;
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
        WHERE bbf.board_building_id=new_building_id AND bbf.feature_id=6;

        CALL count_income(new_building_id);

        CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

/*put building*/
        CALL cmd_put_building(g_id,p_num,new_building_id);

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

DROP PROCEDURE IF EXISTS `summon_unit`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `summon_unit`(g_id INT,p_num INT,player_deck_id INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE crd_id INT;
  DECLARE err_code INT;
  DECLARE x_appear,y_appear,x_dir,y_dir INT;
  DECLARE size INT;
  DECLARE new_unit_id INT;
  DECLARE u_id INT;

  SET err_code=check_play_card(g_id,p_num,player_deck_id,'summon_unit');
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
    SELECT card_id INTO crd_id FROM player_deck WHERE id=player_deck_id;
    SELECT ap.x,ap.y,ap.direction_into_board_x,ap.direction_into_board_y INTO x_appear,y_appear,x_dir,y_dir FROM appear_points ap WHERE ap.mode_id=mode_id AND ap.player_num=p_num;
    SELECT u.size,u.id INTO size,u_id FROM cards c JOIN units u ON c.ref=u.id WHERE c.id=crd_id LIMIT 1;
    IF EXISTS(SELECT id FROM board WHERE game_id=g_id AND x BETWEEN LEAST(x_appear,x_appear+x_dir*(size-1)) AND GREATEST(x_appear,x_appear+x_dir*(size-1)) AND y BETWEEN LEAST(y_appear,y_appear+y_dir*(size-1)) AND GREATEST(y_appear,y_appear+y_dir*(size-1)) LIMIT 1) THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=9;/*Appear point occupied*/
    ELSE
      CALL user_action_begin();

      CALL play_card_actions(g_id,p_num,player_deck_id); /*Set gold, remove card, update log*/

      INSERT INTO board_units(game_id,player_num,card_id) VALUES (g_id,p_num,crd_id);
      SET new_unit_id=@@last_insert_id;
      INSERT INTO board_units_features(board_unit_id,feature_id,param) SELECT new_unit_id,ufu.feature_id,ufu.param FROM unit_default_features ufu WHERE ufu.unit_id=u_id;

      INSERT INTO board(game_id,x,y,`type`,ref) SELECT g_id,a.x,a.y,'unit',new_unit_id FROM allcoords a WHERE a.mode_id=mode_id AND a.x BETWEEN LEAST(x_appear,x_appear+x_dir*(size-1)) AND GREATEST(x_appear,x_appear+x_dir*(size-1)) AND a.y BETWEEN LEAST(y_appear,y_appear+y_dir*(size-1)) AND GREATEST(y_appear,y_appear+y_dir*(size-1));

      UPDATE board_units SET moves_left=0 WHERE id=new_unit_id;

      CALL cmd_add_unit(g_id,p_num,new_unit_id);
      CALL cmd_unit_set_moves_left(g_id,p_num,new_unit_id);

      CALL finish_playing_card(g_id,p_num);
      CALL end_cards_phase(g_id,p_num);

      CALL user_action_end();
    END IF;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `end_turn`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `end_turn`(g_id INT,p_num INT)
BEGIN
  DECLARE board_unit_id INT;
  DECLARE p_num2 INT;
  DECLARE owner_p2 INT;
  DECLARE last_turn INT;
  DECLARE turn,new_turn INT;
  DECLARE mode_id INT;

  DECLARE nonfinished_action INT;

  DECLARE board_building_id INT;

/*cursor for commands unit_set_moves_left*/
  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id AND bu.player_num=p_num AND bu.moves_left<ABS(bu.moves);

  DECLARE cur_building_features CURSOR FOR
    SELECT bb.id FROM board_buildings bb WHERE bb.game_id=g_id AND bb.player_num=p_num2 AND check_building_deactivated(bb.id)=0;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    SELECT a.turn,a.nonfinished_action_id INTO turn,nonfinished_action FROM active_players a WHERE a.game_id=g_id LIMIT 1;

    IF(nonfinished_action<>0)THEN
      CALL finish_nonfinished_action(g_id,p_num,nonfinished_action);
    END IF;

    IF p_num=(SELECT MAX(player_num) FROM players WHERE game_id=g_id AND owner<>0) THEN
      SET new_turn=turn+1;
      UPDATE active_players SET turn=new_turn,player_num=(SELECT MIN(player_num) FROM players WHERE game_id=g_id AND owner<>0),subsidy_flag=0,units_moves_flag=0,card_played_flag=0,nonfinished_action_id=0,last_end_turn=CURRENT_TIMESTAMP,current_procedure='end_turn' WHERE game_id=g_id;
    ELSE
      SET new_turn=turn;
      UPDATE active_players SET player_num=(SELECT MIN(player_num) FROM players WHERE game_id=g_id AND player_num>p_num AND owner<>0),subsidy_flag=0,units_moves_flag=0,card_played_flag=0,nonfinished_action_id=0,last_end_turn=CURRENT_TIMESTAMP,current_procedure='end_turn' WHERE game_id=g_id;
    END IF;

    SELECT a.player_num,UNIX_TIMESTAMP(a.last_end_turn) INTO p_num2,last_turn FROM active_players a WHERE a.game_id=g_id;

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

/*Delete castle-repairing feature*/
  IF @player_end_turn IS NULL THEN
    DELETE FROM player_features_usage WHERE game_id=g_id AND player_num=p_num AND feature_id=player_feature_get_id_by_code('end_turn');
  END IF;

  SELECT p.owner INTO owner_p2 FROM players p WHERE p.game_id=g_id AND p.player_num=p_num2 LIMIT 1;

  IF owner_p2=1 THEN /*human*/
  BEGIN
    DECLARE cmd_log_close_container VARCHAR(1000) CHARSET utf8 DEFAULT 'log_close_container()';

/*income and healing tower*/
    DECLARE income INT;
    DECLARE u_income INT;

/*npc log close container*/
    IF((SELECT MAX(p.player_num) FROM players p WHERE p.game_id=g_id AND owner NOT IN(0,1))=p_num)THEN
      INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log_close_container);
    END IF;

/*income from buildings*/
    SELECT IFNULL(SUM(bb.income),0) INTO income FROM board_buildings bb WHERE bb.game_id=g_id AND bb.player_num=p_num2 AND bb.income<>0 AND check_building_deactivated(bb.id)=0;
/*income from units*/
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
/*NPC*/
  BEGIN
    DECLARE cmd_log_open_container VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_container($p_num,"Ход NPC")';

    IF((SELECT MIN(p.player_num) FROM players p WHERE p.game_id=g_id AND owner NOT IN(0,1))=p_num2)THEN
      SET cmd_log_open_container=REPLACE(cmd_log_open_container,'$p_num',p_num2);
      INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num2,cmd_log_open_container);
    END IF;

  END;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `resurrect`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `resurrect`(g_id INT,p_num INT,grave_id INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE dead_card_id INT;
  DECLARE new_unit_id INT;
  DECLARE x_appear,y_appear,x_dir,y_dir INT;
  DECLARE size INT;
  DECLARE u_id INT;

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
  SELECT ap.x,ap.y,ap.direction_into_board_x,ap.direction_into_board_y INTO x_appear,y_appear,x_dir,y_dir FROM appear_points ap WHERE ap.mode_id=mode_id AND ap.player_num=p_num;
  SELECT g.card_id INTO dead_card_id FROM graves g WHERE id=grave_id;
  SELECT u.id,u.size INTO u_id,size FROM cards c JOIN units u ON c.ref=u.id WHERE c.id=dead_card_id LIMIT 1;

            INSERT INTO board_units(game_id,player_num,card_id) VALUES (g_id,p_num,dead_card_id);
            SET new_unit_id=@@last_insert_id;
            INSERT INTO board_units_features(board_unit_id,feature_id,param) SELECT new_unit_id,ufu.feature_id,ufu.param FROM unit_default_features ufu WHERE ufu.unit_id=u_id;

            INSERT INTO board(game_id,x,y,`type`,ref) SELECT g_id,a.x,a.y,'unit',new_unit_id FROM allcoords a WHERE a.mode_id=mode_id AND a.x BETWEEN LEAST(x_appear,x_appear+x_dir*(size-1)) AND GREATEST(x_appear,x_appear+x_dir*(size-1)) AND a.y BETWEEN LEAST(y_appear,y_appear+y_dir*(size-1)) AND GREATEST(y_appear,y_appear+y_dir*(size-1));
            DELETE FROM graves WHERE game_id=g_id AND id=grave_id;

            UPDATE board_units SET moves_left=0 WHERE id=new_unit_id;

            CALL cmd_add_unit(g_id,p_num,new_unit_id);
            CALL cmd_remove_from_grave(g_id,p_num,grave_id);
            CALL cmd_unit_set_moves_left(g_id,p_num,new_unit_id);

            INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'resurrect_unit',u_id);
END$$

delimiter ;