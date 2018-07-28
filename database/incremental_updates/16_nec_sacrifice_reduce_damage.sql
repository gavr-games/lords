use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`necromancer_sacrifice` $$

CREATE PROCEDURE `necromancer_sacrifice`(g_id INT,   p_num INT,   x INT,   y INT,   x_sacr INT,   y_sacr INT,    x_target INT,    y_target INT)
BEGIN
  DECLARE err_code INT;
  DECLARE sacr_bu_id INT;
  DECLARE target_bu_id INT;
  DECLARE board_unit_id INT;
  DECLARE sacr_health INT;

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'necromancer_sacrifice'); 
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    SELECT b.ref INTO sacr_bu_id FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.x=x_sacr AND b.y=y_sacr LIMIT 1;
    IF sacr_bu_id IS NULL THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=37;
    ELSE
      IF (SELECT player_num FROM board_units WHERE id=sacr_bu_id)<>p_num THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=38;
      ELSE
        SELECT b.ref INTO target_bu_id FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.x=x_target AND b.y=y_target LIMIT 1;
        IF target_bu_id IS NULL THEN
          SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=39;
        ELSE

          CALL unit_action_begin(g_id, p_num);

          SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;

          UPDATE board_units bu SET bu.moves_left=0 WHERE bu.id=board_unit_id;
          CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);


          CALL cmd_log_add_message(g_id, p_num, 'sacrifice', CONCAT_WS(';', log_unit(board_unit_id), log_unit(sacr_bu_id), log_unit(target_bu_id)));
          IF(sacr_bu_id=target_bu_id) THEN
            CALL cmd_log_add_message(g_id, p_num, 'unit_is_such_a_unit', log_unit(board_unit_id));
          END IF;

          IF (unit_feature_check(sacr_bu_id,'magic_immunity')=1) THEN 
            CALL cmd_magic_resistance_log(g_id,p_num,board_unit_id);
          ELSE

            SELECT bu.health INTO sacr_health FROM board_units bu WHERE bu.id=sacr_bu_id;

            CALL unit_feature_set(sacr_bu_id,'goes_to_deck_on_death',null);
            CALL kill_unit(sacr_bu_id,p_num);
            
            IF(sacr_bu_id <> target_bu_id)THEN
              CALL magical_damage(g_id, p_num, x_target, y_target, sacr_health);
            END IF;

          END IF;

          CALL unit_action_end(g_id, p_num);

        END IF;
      END IF;
    END IF;
  END IF;

END$$

DELIMITER ;

