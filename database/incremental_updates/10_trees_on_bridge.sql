use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`init_landscape` $$

CREATE PROCEDURE `init_landscape`(g_id INT)
BEGIN
  DECLARE g_mode INT;
  DECLARE building_id INT;
  DECLARE qty INT;
  DECLARE neutral_p_num INT DEFAULT 9;

  SELECT g.mode_id INTO g_mode FROM games g WHERE g.id=g_id LIMIT 1;

  SELECT b.id,bdf.param INTO building_id,qty
    FROM modes_cardless_buildings m
    JOIN buildings b ON m.building_id=b.id
    JOIN building_default_features bdf ON bdf.building_id=b.id
    JOIN building_features bf ON bdf.feature_id=bf.id
    WHERE m.mode_id=g_mode AND bf.code='for_initialization';

  IF(building_id IS NOT NULL)THEN
  BEGIN
    DECLARE i INT;
    DECLARE tree_x,tree_y INT;
    DECLARE board_building_id INT;
    DECLARE quart INT DEFAULT 0;

    CREATE TEMPORARY TABLE available_cells_for_trees (x INT, y INT);

    INSERT INTO available_cells_for_trees(x,y)
    SELECT x,y FROM allcoords a WHERE
      mode_id=g_mode
      AND NOT (
        (x<=3 AND y<=3) 
        OR (x>=16 AND y<=3) 
        OR (x>=16 AND y>=16) 
        OR (x<=3 AND y>=16) 
        OR (x BETWEEN 8 AND 11) 
        OR (y BETWEEN 8 AND 11)
        OR ((x BETWEEN 7 AND 12) AND (y BETWEEN 7 AND 12)));
    
    DELETE ac
        FROM available_cells_for_trees ac
        JOIN board b ON (ac.x = b.x) AND (ac.y = b.y)
        WHERE b.game_id = g_id;
    
    WHILE quart<4 DO
      SET i=qty;
      WHILE i>0 DO
        SELECT a.x,a.y INTO tree_x,tree_y
        FROM available_cells_for_trees a
        WHERE quart(a.x,a.y)=quart
        ORDER BY RAND()
        LIMIT 1;

        INSERT INTO board_buildings(game_id,player_num,building_id,rotation,flip)VALUES (g_id,neutral_p_num,building_id,0,0);
        SET board_building_id=@@last_insert_id;

        CALL place_building_on_board(board_building_id,tree_x,tree_y,0,0);

        IF NOT EXISTS(SELECT id FROM board WHERE game_id=g_id AND `type`<>'unit' AND ref=board_building_id) THEN 
          DELETE FROM board_buildings WHERE id=board_building_id;
          SET i=i+1;
        ELSE
          INSERT INTO board_buildings_features(board_building_id,feature_id,param) SELECT board_building_id,bf.feature_id,bf.param FROM building_default_features bf WHERE bf.building_id=building_id;

          DELETE ac
              FROM available_cells_for_trees ac
              JOIN board b ON (ac.x = b.x) AND (ac.y = b.y)
              WHERE b.game_id = g_id AND `type`<>'unit' AND ref=board_building_id;

        END IF;

        SET i=i-1;
      END WHILE;
      SET quart = quart+1;
    END WHILE;

    DROP TEMPORARY TABLE available_cells_for_trees;
  END;
  END IF;

END$$

DELIMITER ;

