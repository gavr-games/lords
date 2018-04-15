use lords;

update units_i18n set description = 'Имеет собственный 1 щит. Может лечить других юнитов. Колдует Огненный Шар с вероятностью 2/9, при этом с вероятностью 1/36 убивает себя (либо теряет щит) из-за ошибки в заклинании'
where language_id = 2 and unit_id = (select id from units where ui_code='wizard');
update units_i18n set description = 'Has a magical shield. Can heal other units. Can cast Fireball with probability 2/9, but with probability 1/36 kills himself (or loses shield) because of misspelling'
where language_id = 1 and unit_id = (select id from units where ui_code='wizard');

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`wizard_fireball` $$

CREATE PROCEDURE `wizard_fireball`(g_id INT,  p_num INT,  x INT,  y INT,   x2 INT,   y2 INT)
BEGIN
  DECLARE err_code INT;
  DECLARE aim_bu_id INT;
  DECLARE board_unit_id INT;
  DECLARE dice INT;
  DECLARE fb_damage INT DEFAULT 1;
  DECLARE health_before_hit,health_after_hit,experience INT;

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'wizard_fireball'); 
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
      SELECT b.ref INTO aim_bu_id FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.x=x2 AND b.y=y2 LIMIT 1;
      IF aim_bu_id IS NULL THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=33;
      ELSE
        CALL user_action_begin();

        IF(SELECT units_moves_flag FROM active_players WHERE game_id=g_id)=0 THEN
          CALL start_moving_units(g_id,p_num);
        END IF;

        SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;
        SELECT bu.health INTO health_before_hit FROM board_units bu WHERE bu.id=aim_bu_id LIMIT 1;

        UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
        CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);

        CALL cmd_log_add_message(g_id, p_num, 'unit_casts_fb', CONCAT_WS(';', log_unit(board_unit_id), log_unit(aim_bu_id)));

        SELECT FLOOR(1 + (RAND() * 6)) INTO dice FROM DUAL;

        IF dice=1 THEN 
          IF (SELECT FLOOR(1 + (RAND() * 6)) as `dice` FROM DUAL)<6 THEN
            CALL cmd_log_add_message(g_id, p_num, 'miss_rus_rul', log_unit(board_unit_id));
          ELSE
            CALL magic_kill_unit(board_unit_id,p_num);
          END IF;
        ELSE
          IF dice IN (5,6) THEN 
            IF (SELECT FLOOR(1 + (RAND() * 6)) as `dice` FROM DUAL)<3 THEN
              CALL cmd_miss_game_log(g_id,x2,y2);
            ELSE
              CALL magical_damage(g_id,p_num,x2,y2,fb_damage);
              SELECT bu.health INTO health_after_hit FROM board_units bu WHERE bu.id=aim_bu_id LIMIT 1;
              IF (health_after_hit IS NULL) THEN
                SET health_after_hit = 0;
              END IF;
              
              SET experience = health_before_hit - health_after_hit;
              IF(health_after_hit = 0)THEN
                SET experience = experience + 1;
              END IF;
              IF(experience > 0)THEN
                CALL unit_add_exp(board_unit_id, experience);
              END IF;
            END IF;
          ELSE 
            CALL cmd_log_add_message(g_id, p_num, 'cast_unsuccessful', NULL);
          END IF;
        END IF;

        INSERT INTO statistic_game_actions(game_id,player_num,`action`) VALUES(g_id,p_num,'magical_attack');

        IF (check_all_units_moved(g_id,p_num) = 1) THEN
          CALL finish_moving_units(g_id,p_num);
          CALL end_units_phase(g_id,p_num);
        END IF;

        CALL user_action_end();
      END IF;
  END IF;

END$$

DELIMITER ;

