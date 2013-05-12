use lords;

DELIMITER $$

DROP FUNCTION IF EXISTS `lords`.`building_feature_get_id_by_code` $$
CREATE DEFINER=`root`@`localhost` FUNCTION `building_feature_get_id_by_code`(feature_code VARCHAR(45)) RETURNS int(11)
    DETERMINISTIC
BEGIN
  DECLARE result INT;
  SELECT bf.id INTO result FROM building_features bf WHERE bf.code=feature_code;
  RETURN result;
END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`building_feature_set` $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `building_feature_set`(board_building_id INT, feature_code VARCHAR(45),param_value INT)
BEGIN
  IF(building_feature_check(board_building_id,feature_code)=0)THEN /*feature not set*/
    INSERT INTO board_buildings_features(board_building_id,feature_id,param) SELECT board_building_id,bf.id,param_value FROM building_features bf WHERE bf.code=feature_code;
  ELSE /*feature is set - update param*/
    UPDATE board_buildings_features bbf
      SET bbf.param=param_value
      WHERE bbf.board_building_id=board_building_id AND bbf.feature_id=building_feature_get_id_by_code(feature_code);
  END IF;
END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`put_building` $$
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
        CALL cmd_put_building(g_id,p_num,new_building_id);

/*summon creatures*/
        IF EXISTS(SELECT sc.id FROM summon_cfg sc WHERE sc.building_id=(SELECT bb.building_id FROM board_buildings bb WHERE id=new_building_id)) THEN
          CALL summon_creatures(new_building_id);
        END IF;

        CALL finish_playing_card(g_id,p_num);
        CALL end_turn(g_id,p_num);

        CALL user_action_end();
      END IF;
    END IF;
  END IF;
END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`barracks_summon` $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `barracks_summon`(g_id INT, board_building_id INT)
BEGIN
  DECLARE cops_count INT;
  DECLARE dice INT;

  SELECT COUNT(*) INTO cops_count FROM board_units bu WHERE bu.game_id=g_id AND unit_feature_check(bu.id,'parent_building')=1 AND unit_feature_get_param(bu.id,'parent_building')=board_building_id;
  SET dice = POW(6,CASE WHEN cops_count IN(0,1,2,3) THEN 1 ELSE cops_count-2 END);
  IF(FLOOR(1 + (RAND() * dice))=1)THEN
    CALL summon_one_creature_by_config(board_building_id);
  END IF;
END $$

DELIMITER ;
DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`end_turn` $$
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
      UPDATE active_players SET turn=new_turn,player_num=(SELECT MIN(player_num) FROM players WHERE game_id=g_id AND owner<>0),subsidy_flag=0,units_moves_flag=0,nonfinished_action_id=0,last_end_turn=CURRENT_TIMESTAMP,current_procedure='end_turn' WHERE game_id=g_id;
    ELSE
      SET new_turn=turn;
      UPDATE active_players SET player_num=(SELECT MIN(player_num) FROM players WHERE game_id=g_id AND player_num>p_num AND owner<>0),subsidy_flag=0,units_moves_flag=0,nonfinished_action_id=0,last_end_turn=CURRENT_TIMESTAMP,current_procedure='end_turn' WHERE game_id=g_id;
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

END $$

DELIMITER ;