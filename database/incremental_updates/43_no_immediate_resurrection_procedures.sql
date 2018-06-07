use lords;

CREATE OR REPLACE VIEW `vw_grave` AS
    SELECT 
        `g`.`game_id`,
        `g`.`id` AS `grave_id`,
        `g`.`card_id`,
        `g`.`player_num_when_killed`,
        `g`.`turn_when_killed`,
        MIN(`gc`.`x`) AS `x`,
        MIN(`gc`.`y`) AS `y`,
        SQRT(COUNT(0)) AS `size`
    FROM
        (`graves` `g`
        JOIN `grave_cells` `gc` ON ((`g`.`id` = `gc`.`grave_id`)))
    GROUP BY `g`.`game_id` , `g`.`id` , `g`.`card_id`, `g`.`player_num_when_killed`, `g`.`turn_when_killed`;

DELIMITER $$

DROP FUNCTION IF EXISTS `lords`.`get_current_turn` $$

CREATE FUNCTION `get_current_turn`(g_id INT) RETURNS int
BEGIN
  RETURN (SELECT turn FROM active_players WHERE game_id = g_id LIMIT 1);
END$$

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`delete_player_objects` $$

CREATE PROCEDURE `delete_player_objects`(g_id INT, p_num INT)
BEGIN

  DECLARE player_deck_id INT;
  DECLARE crd_id INT;
  DECLARE board_unit_id INT;
  DECLARE board_building_id INT;
  DECLARE grave_id INT;

  DECLARE done INT DEFAULT 0;
  DECLARE cur1 CURSOR FOR SELECT pd.id FROM player_deck pd WHERE pd.game_id=g_id AND pd.player_num=p_num;
  DECLARE cur2 CURSOR FOR SELECT bu.id,bu.card_id FROM board_units bu WHERE bu.game_id=g_id AND bu.player_num=p_num;
  DECLARE cur3 CURSOR FOR SELECT bb.id FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.game_id=g_id AND bb.player_num=p_num AND b.`type`<>'obstacle';
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;


    OPEN cur1;
    REPEAT
      FETCH cur1 INTO player_deck_id;
      IF NOT done THEN
        CALL cmd_remove_card(g_id,p_num,player_deck_id);
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur1;

  INSERT INTO deck(game_id,card_id) SELECT g_id,pd.card_id FROM player_deck pd WHERE pd.game_id=g_id AND pd.player_num=p_num;
  DELETE FROM player_deck WHERE game_id=g_id AND player_num=p_num;

  SET done=0;


    OPEN cur2;
    REPEAT
      FETCH cur2 INTO board_unit_id,crd_id;
      IF NOT done THEN
        IF crd_id IS NOT NULL THEN
      INSERT INTO graves(game_id, card_id, player_num_when_killed, turn_when_killed)
          VALUES(g_id, crd_id, get_current_p_num(g_id), get_current_turn(g_id));
      SET grave_id=@@last_insert_id;
      INSERT INTO grave_cells(grave_id,x,y) SELECT grave_id,b.x,b.y FROM board b WHERE game_id=g_id AND b.`type`='unit' AND b.ref=board_unit_id;
          CALL cmd_add_to_grave(g_id,p_num,grave_id);
        END IF;

        CALL cmd_kill_unit(g_id,p_num,board_unit_id);
        DELETE FROM board WHERE game_id=g_id AND `type`='unit' AND ref=board_unit_id;
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur2;

  DELETE board_units_features FROM board_units_features JOIN board_units ON (board_units_features.board_unit_id=board_units.id)
    WHERE board_units.game_id=g_id AND board_units.player_num=p_num;
  DELETE FROM board_units WHERE game_id=g_id AND player_num=p_num;

  SET done=0;


    OPEN cur3;
    REPEAT
      FETCH cur3 INTO board_building_id;
      IF NOT done THEN
        CALL cmd_destroy_building(g_id,p_num,board_building_id);
        DELETE FROM board WHERE game_id=g_id AND `type`<>'unit' AND ref=board_building_id;
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur3;

  INSERT INTO deck(game_id,card_id) SELECT g_id,bb.card_id FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.game_id=g_id AND bb.player_num=p_num AND b.`type`<>'obstacle' AND bb.card_id IS NOT NULL;

  DELETE board_buildings_features FROM board_buildings_features JOIN board_buildings ON (board_buildings_features.board_building_id=board_buildings.id)
    WHERE board_buildings.game_id=g_id AND board_buildings.player_num=p_num;
  DELETE FROM board_buildings WHERE game_id=g_id AND player_num=p_num AND (SELECT b.`type` FROM buildings b WHERE b.id=building_id)<>'obstacle';

END$$

DROP PROCEDURE IF EXISTS `lords`.`kill_unit` $$

CREATE PROCEDURE `kill_unit`(bu_id INT, p_num INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p2_num INT; 
  DECLARE crd_id INT;
  DECLARE grave_id INT;
  DECLARE u_id INT;
  DECLARE reward INT DEFAULT 0;
  DECLARE kill_reward_divisor INT DEFAULT 2; 
  DECLARE binded_unit_id INT;

  SELECT game_id,player_num,card_id,unit_id INTO g_id,p2_num,crd_id,u_id FROM board_units WHERE id=bu_id LIMIT 1;

  CALL cmd_log_add_message(g_id, p_num, 'unit_killed', log_unit(bu_id));

  IF crd_id IS NOT NULL THEN
    IF unit_feature_check(bu_id,'goes_to_deck_on_death') = 1 THEN
      INSERT INTO deck(game_id,card_id) VALUES(g_id,crd_id);
    ELSE 
      INSERT INTO graves(game_id, card_id, player_num_when_killed, turn_when_killed)
          VALUES(g_id, crd_id, get_current_p_num(g_id), get_current_turn(g_id));
      SET grave_id=@@last_insert_id;
      INSERT INTO grave_cells(grave_id,x,y) SELECT grave_id,b.x,b.y FROM board b WHERE game_id=g_id AND b.`type`='unit' AND b.ref=bu_id;
      CALL cmd_add_to_grave(g_id,p_num,grave_id);
    END IF;
  END IF;

  CALL cmd_kill_unit(g_id,p_num,bu_id);

  DELETE FROM board WHERE game_id=g_id AND `type`='unit' AND ref=bu_id;
  DELETE FROM board_units_features WHERE board_unit_id=bu_id;
  DELETE FROM board_units WHERE id=bu_id;


  SELECT IFNULL(cost/kill_reward_divisor,0) INTO reward FROM cards WHERE `type`='u' AND ref=u_id LIMIT 1;


  IF ((SELECT owner FROM players WHERE game_id=g_id AND player_num=p2_num LIMIT 1)<>1)
    AND NOT EXISTS (SELECT id FROM board_units WHERE game_id=g_id AND player_num=p2_num)
    AND NOT EXISTS (SELECT id FROM board_buildings WHERE game_id=g_id AND player_num=p2_num)
  THEN 
    SET reward=reward+(SELECT gold FROM players WHERE game_id=g_id AND player_num=p2_num LIMIT 1);
    DELETE FROM players WHERE game_id=g_id AND player_num=p2_num;
    CALL cmd_delete_player(g_id,p2_num);
  END IF;

  IF(reward>0 AND EXISTS (SELECT id FROM players p WHERE p.game_id=g_id AND p.player_num=p_num))THEN
    UPDATE players SET gold=gold+reward WHERE game_id=g_id AND player_num=p_num;
    CALL cmd_player_set_gold(g_id,p_num);
  END IF;


  DELETE FROM board_units_features WHERE feature_id IN(unit_feature_get_id_by_code('bind_target'),unit_feature_get_id_by_code('attack_target')) AND param=bu_id;


  IF EXISTS(SELECT id FROM board_units_features WHERE feature_id=unit_feature_get_id_by_code('under_control') AND param=bu_id LIMIT 1)THEN
    CALL zombies_make_mad(g_id,bu_id);
  END IF;

  INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'kill_unit',p2_num);

END$$

DROP PROCEDURE IF EXISTS `lords`.`player_resurrect` $$

CREATE PROCEDURE `player_resurrect`(g_id INT,  p_num INT,  grave_id INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE dead_card_id INT;
  DECLARE resurrection_cost_coefficient INT;
  DECLARE resur_cost INT;
  DECLARE x_appear,y_appear,x_dir,y_dir INT;
  DECLARE new_unit_id INT;
  DECLARE size INT;
  DECLARE u_id INT;
  DECLARE new_bu_id INT;

  SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
  SELECT cfg.`value` INTO resurrection_cost_coefficient FROM mode_config cfg WHERE cfg.param='resurrection cost coefficient' AND cfg.mode_id=mode_id;

  IF NOT p_num=(SELECT player_num FROM active_players WHERE game_id=g_id) THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'not_your_turn';
  ELSE
    IF (SELECT nonfinished_action_id FROM active_players WHERE game_id=g_id LIMIT 1)<>0 THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'need_to_finish_card_action';
    ELSE
      IF (SELECT card_played_flag FROM active_players WHERE game_id=g_id)=1 THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'can_play_card_or_resurrect_only_once_per_turn';
      ELSE
        IF NOT EXISTS(SELECT id FROM graves WHERE game_id=g_id AND id=grave_id LIMIT 1) THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'no_such_dead_unit';
        ELSE
          IF EXISTS (SELECT id FROM graves
                        WHERE game_id = g_id
                          AND id=grave_id
                          AND player_num_when_killed = get_current_p_num(g_id)
                          AND turn_when_killed = get_current_turn(g_id))
          THEN
            SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'cant_resurrect_same_turn';
          ELSE
            SELECT g.card_id INTO dead_card_id FROM graves g WHERE id=grave_id;
            SELECT cost*resurrection_cost_coefficient INTO resur_cost FROM cards WHERE id=dead_card_id LIMIT 1;
            IF (SELECT gold FROM players WHERE game_id=g_id AND player_num=p_num LIMIT 1)<resur_cost THEN
              SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'not_enough_gold';
            ELSE
              SELECT ap.x,ap.y,ap.direction_into_board_x,ap.direction_into_board_y INTO x_appear,y_appear,x_dir,y_dir FROM appear_points ap WHERE ap.mode_id=mode_id AND ap.player_num=p_num;
              SELECT u.id,u.size INTO u_id,size FROM cards c JOIN units u ON c.ref=u.id WHERE c.id=dead_card_id LIMIT 1;
              IF EXISTS(SELECT id FROM board WHERE game_id=g_id AND x BETWEEN LEAST(x_appear,x_appear+x_dir*(size-1)) AND GREATEST(x_appear,x_appear+x_dir*(size-1)) AND y BETWEEN LEAST(y_appear,y_appear+y_dir*(size-1)) AND GREATEST(y_appear,y_appear+y_dir*(size-1)) LIMIT 1) THEN
                SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'spawn_point_occupued';
              ELSE
                CALL user_action_begin();

                UPDATE players SET gold=gold-resur_cost WHERE game_id=g_id AND player_num=p_num;
                CALL cmd_player_set_gold(g_id,p_num);

                CALL resurrect(g_id,p_num,grave_id);

                SELECT MAX(id) INTO new_bu_id FROM board_units bu WHERE bu.game_id=g_id AND bu.player_num=p_num;
                CALL cmd_log_add_independent_message(g_id, p_num, 'resurrect', CONCAT_WS(';', log_player(g_id, p_num), log_unit(new_bu_id)));

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

DROP PROCEDURE IF EXISTS `lords`.`get_all_game_info` $$

CREATE PROCEDURE `get_all_game_info`(g_id INT,  p_num INT)
BEGIN

  SELECT g.title,g.owner_id,g.time_restriction,g.status_id,g.`date` AS `creation_date`,g.mode_id,g.type_id FROM games g WHERE g.id=g_id;

  SELECT b.id,MIN(b.x) as `x`,MIN(b.y) as `y`,b.ref,b.`type` FROM board b WHERE b.game_id=g_id AND b.`type`<>'unit' GROUP BY b.ref,b.`type`;

  SELECT b.id,MIN(b.x) as `x`,MIN(b.y) as `y`,b.ref,b.`type` FROM board b WHERE b.game_id=g_id AND b.`type`='unit' GROUP BY b.ref,b.`type`;

  SELECT a.player_num,a.turn,a.subsidy_flag,a.units_moves_flag,a.card_played_flag,UNIX_TIMESTAMP(a.last_end_turn) as `last_end_turn`,n.command_procedure FROM active_players a LEFT JOIN nonfinished_actions_dictionary n ON (a.nonfinished_action_id=n.id) WHERE a.game_id=g_id;

  SELECT p.player_num, p.name, p.gold, p.owner, p.team, p.agree_draw FROM players p WHERE p.game_id=g_id ORDER BY p.player_num;

  SELECT b.id, b.building_id, b.player_num, b.health, b.max_health, b.radius, b.card_id, b.income, b.rotation, b.flip FROM board_buildings b WHERE b.game_id=g_id;

  SELECT bbf.board_building_id,bbf.feature_id,bbf.param FROM board_buildings_features bbf JOIN board_buildings bb ON (bb.id=bbf.board_building_id) WHERE bb.game_id=g_id;

  SELECT b.id, b.player_num, b.unit_id, b.card_id, b.health, b.max_health, b.attack, b.moves_left, b.moves, b.shield, b.experience, b.level FROM board_units b WHERE b.game_id=g_id;

  SELECT buf.board_unit_id,buf.feature_id,buf.param FROM board_units_features buf JOIN board_units bu ON (bu.id=buf.board_unit_id) WHERE bu.game_id=g_id;

  SELECT v.grave_id, v.card_id, v.player_num_when_killed, v.turn_when_killed, v.x, v.y, v.size FROM vw_grave v WHERE v.game_id=g_id;

  SELECT p.id,p.card_id FROM player_deck p WHERE p.game_id=g_id AND p.player_num=p_num;

  select command from log_commands where game_id=g_id AND((hidden_flag=0) OR (player_num = p_num));

END$$

DELIMITER ;
