use lords;

DELIMITER $$

DROP FUNCTION IF EXISTS `lords`.`get_distance_between_cells` $$

CREATE FUNCTION `get_distance_between_cells`(x1 INT, y1 INT, x2 INT, y2 INT) RETURNS int(11)
    DETERMINISTIC
BEGIN
  RETURN GREATEST(ABS(x1 - x2), ABS(y1 - y2));
END$$

DROP FUNCTION IF EXISTS `lords`.`get_distance_from_unit_to_object` $$

CREATE FUNCTION `get_distance_from_unit_to_object`(board_unit_id INT, obj_type VARCHAR(45), obj_id INT) RETURNS int(11)
BEGIN
  RETURN
    (SELECT MIN(get_distance_between_cells(unit.x, unit.y, obj.x, obj.y))
    FROM
      (SELECT b.x,b.y FROM board b WHERE b.`type`='unit' AND b.ref=board_unit_id) unit,
      (SELECT b.x,b.y FROM board b WHERE b.`type`=obj_type AND b.ref=obj_id
       UNION
       SELECT g.x,g.y FROM grave_cells g WHERE obj_type = 'grave' AND obj_id = g.grave_id) obj);
END$$

DROP PROCEDURE IF EXISTS `lords`.`player_move_unit` $$

CREATE PROCEDURE `player_move_unit`(g_id INT, p_num INT, x INT, y INT, x2 INT, y2 INT)
BEGIN
  DECLARE mode_id INT;
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE size INT;
  DECLARE moveable INT DEFAULT 0;
  DECLARE teleportable INT DEFAULT 0;
  DECLARE flyable INT DEFAULT 0;
  DECLARE moves_spent INT DEFAULT 1;
  DECLARE moves_left INT DEFAULT 1;
  DECLARE taran_unit_id INT;
  DECLARE taran_x,taran_y,taran_prev_x,taran_prev_y INT;
  DECLARE x0,y0 INT;

  SET err_code=check_unit_can_do_action(g_id,p_num,x,y,'player_move_unit'); 
  IF err_code<>0 THEN SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    SELECT g.mode_id INTO mode_id FROM games g WHERE g.id=g_id LIMIT 1;
    SELECT b.ref INTO board_unit_id FROM board b WHERE b.game_id=g_id AND b.x=x AND b.y=y AND b.`type`='unit' LIMIT 1;
    SELECT u.size, bu.moves_left INTO size, moves_left FROM board_units bu JOIN units u ON (bu.unit_id=u.id) WHERE bu.id=board_unit_id LIMIT 1;
    SELECT MIN(b.x),MIN(b.y) INTO x0,y0 FROM board b WHERE b.game_id=g_id AND b.ref=board_unit_id AND b.`type`='unit';

    SET moveable=check_one_step_from_unit(g_id,x,y,x2,y2);

    IF moveable=0
       AND unit_feature_check(board_unit_id,'flying') AND NOT unit_feature_check(board_unit_id,'knight')
       AND get_distance_between_cells(x0, y0, x2, y2) BETWEEN 1 AND moves_left
    THEN
      SET flyable = 1;
      SET moves_spent = get_distance_between_cells(x0, y0, x2, y2);
    END IF; 

    IF (moveable=0 AND flyable=0) AND (unit_feature_check(board_unit_id,'magic_immunity')=0) AND EXISTS
    (SELECT a.id FROM board_buildings bb,board b,allcoords a
      WHERE bb.game_id=g_id AND building_feature_check(bb.id,'teleport')=1 AND check_building_deactivated(bb.id)=0
      AND b.`type`<>'unit' AND b.ref=bb.id
      AND get_building_team(bb.id) = get_unit_team(board_unit_id)
      AND a.mode_id=mode_id
      AND a.x BETWEEN b.x-bb.radius AND b.x+bb.radius AND a.y BETWEEN b.y-bb.radius AND b.y+bb.radius
      AND a.x BETWEEN x2 AND x2+size-1 AND a.y BETWEEN y2 AND y2+size-1 LIMIT 1)
    THEN
      SET teleportable=1;
    END IF;
    
    IF NOT (moveable OR teleportable OR flyable)
    THEN
      SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'cant_step_on_cell';
    ELSE
      IF EXISTS(SELECT b.id FROM board b WHERE b.game_id=g_id AND b.x BETWEEN x2 AND x2+size-1 AND b.y BETWEEN y2 AND y2+size-1 AND NOT(b.`type`='unit' AND b.ref=board_unit_id) LIMIT 1) THEN
        SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE ed.code = 'place_occupied';
      ELSE

                CALL unit_action_begin(g_id, p_num);

                IF (unit_feature_get_param(board_unit_id,'bind_target') IS NOT NULL) THEN
                  CALL unit_feature_remove(board_unit_id,'bind_target');
                END IF; 

                CALL move_unit(board_unit_id,x2,y2);
                UPDATE board_units bu SET bu.moves_left=CASE WHEN teleportable THEN 0 ELSE bu.moves_left - moves_spent END WHERE bu.id=board_unit_id;
                CALL cmd_unit_set_moves_left(g_id,p_num,board_unit_id);


                SELECT bu.id INTO taran_unit_id FROM board_units bu WHERE unit_feature_get_param(bu.id,'bind_target')=board_unit_id LIMIT 1;
                IF taran_unit_id IS NOT NULL THEN
                  IF teleportable OR flyable THEN
                    CALL unit_feature_remove(taran_unit_id,'bind_target');
                  ELSE
                    IF (size=1) THEN
                      SET taran_x=x;
                      SET taran_y=y;
                    ELSE
                      SELECT b.x,b.y INTO taran_prev_x,taran_prev_y FROM board b WHERE b.game_id=g_id AND b.`type`='unit' AND b.ref=taran_unit_id LIMIT 1;
                      SELECT a.x,a.y INTO taran_x,taran_y FROM allcoords a WHERE a.mode_id=mode_id AND a.x BETWEEN x0 AND x0+size-1 AND a.y BETWEEN y0 AND y0+size-1 AND a.x BETWEEN x2-1 AND x2+size AND a.y BETWEEN y2-1 AND y2+size AND NOT (a.x BETWEEN x2 AND x2+size-1 AND a.y BETWEEN y2 AND y2+size-1) ORDER BY ((taran_prev_x-a.x)*(taran_prev_x-a.x)+(taran_prev_y-a.y)*(taran_prev_y-a.y)) LIMIT 1;
                    END IF;
                    CALL move_unit(taran_unit_id,taran_x,taran_y);
                  END IF;
                END IF;

                CALL unit_action_end(g_id, p_num);
      END IF;
    END IF;
  END IF;

END$$

