use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`init_landscape`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `init_landscape`(g_id INT)
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
    SELECT x,y FROM allcoords a WHERE mode_id=g_mode AND NOT ((x<=3 AND y<=3) OR (x>=16 AND y<=3) OR (x>=16 AND y>=16) OR (x<=3 AND y>=16) OR (x BETWEEN 8 AND 11) OR (y BETWEEN 8 AND 11));
    
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

        IF NOT EXISTS(SELECT id FROM board WHERE game_id=g_id AND `type`<>'unit' AND ref=board_building_id) THEN /*Building not placed*/
          DELETE FROM board_buildings WHERE id=board_building_id;
          SET i=i+1;
        ELSE
          INSERT INTO board_buildings_features(board_building_id,feature_id,param) SELECT board_building_id,bf.feature_id,bf.param FROM building_default_features bf WHERE bf.building_id=building_id;
        END IF;

        SET i=i-1;
      END WHILE;
      SET quart = quart+1;
    END WHILE;

    DROP TEMPORARY TABLE available_cells_for_trees;
  END;
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`init_buildings`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `init_buildings`(g_id INT)
BEGIN
  DECLARE g_mode INT;

  DECLARE p_num INT;
  DECLARE x INT;
  DECLARE y INT;
  DECLARE rotation INT;
  DECLARE flip INT;
  DECLARE building_id INT;
  DECLARE board_building_id INT;
  DECLARE neutral_p_num INT DEFAULT 9;

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT cfg.player_num,cfg.x,cfg.y,cfg.rotation,cfg.flip,cfg.building_id FROM put_start_buildings_config cfg JOIN players p ON cfg.player_num=p.player_num WHERE p.game_id=g_id AND p.owner<>0 AND cfg.mode_id=g_mode;
  DECLARE cur_neutral CURSOR FOR SELECT cfg.player_num,cfg.x,cfg.y,cfg.rotation,cfg.flip,cfg.building_id FROM put_start_buildings_config cfg WHERE cfg.mode_id=g_mode AND cfg.player_num=neutral_p_num;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SELECT g.mode_id INTO g_mode FROM games g WHERE g.id=g_id LIMIT 1;

  OPEN cur;
  REPEAT
    FETCH cur INTO p_num,x,y,rotation,flip,building_id;
    IF NOT done THEN
      INSERT INTO board_buildings(game_id,player_num,building_id,rotation,flip)VALUES (g_id,p_num,building_id,rotation,flip);
      SET board_building_id=@@last_insert_id;

      CALL place_building_on_board(board_building_id,x,y,rotation,flip);

      INSERT INTO board_buildings_features(board_building_id,feature_id,param) SELECT board_building_id,bf.feature_id,bf.param FROM building_default_features bf WHERE bf.building_id=building_id;

      CALL count_income(board_building_id);
    END IF;
  UNTIL done END REPEAT;
  CLOSE cur;

  SET done=0;
  OPEN cur_neutral;
  REPEAT
    FETCH cur_neutral INTO p_num,x,y,rotation,flip,building_id;
    IF NOT done THEN
      INSERT INTO board_buildings(game_id,player_num,building_id,rotation,flip)VALUES (g_id,p_num,building_id,rotation,flip);
      SET board_building_id=@@last_insert_id;

      CALL place_building_on_board(board_building_id,x,y,rotation,flip);

      INSERT INTO board_buildings_features(board_building_id,feature_id,param) SELECT board_building_id,bf.feature_id,bf.param FROM building_default_features bf WHERE bf.building_id=building_id;
    END IF;
  UNTIL done END REPEAT;
  CLOSE cur_neutral;

END$$

DELIMITER ;
