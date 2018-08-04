use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`get_random_free_cell_near_building` $$

CREATE PROCEDURE `get_random_free_cell_near_building`(board_building_id INT,  OUT x INT,  OUT y INT)
BEGIN
  DECLARE g_id INT;
  DECLARE g_mode INT;

  SELECT game_id INTO g_id FROM board_buildings WHERE id=board_building_id LIMIT 1;
  SELECT mode_id INTO g_mode FROM games WHERE id=g_id LIMIT 1;

  SELECT DISTINCT a.x,a.y INTO x,y 
    FROM allcoords a, board b
    WHERE b.game_id=g_id
      AND b.`type`<>'unit'
      AND b.ref=board_building_id
      AND a.mode_id=g_mode
      AND (ABS(b.x-a.x)<=1 AND ABS(b.y-a.y)<=1)
      AND NOT EXISTS (SELECT b2.id FROM board b2 WHERE b2.game_id=g_id AND b2.x=a.x AND b2.y=a.y)
    ORDER BY RAND() LIMIT 1;
END$$

DELIMITER ;

