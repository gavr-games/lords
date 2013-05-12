use lords;

/*DRAFT*/
DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`init_landscape` $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `init_landscape`(g_id INT)
BEGIN
  DECLARE g_mode INT;
  DECLARE building_id INT;
  DECLARE qty INT;
  DECLARE trees_p_num INT DEFAULT 9;

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
    DECLARE x,y INT;
    DECLARE board_building_id INT;

    SET i=qty;
    WHILE i>0 DO
/*get random x,y*/

      INSERT INTO board_buildings(game_id,player_num,building_id,rotation,flip)VALUES (g_id,trees_p_num,building_id,0,0);
      SET board_building_id=@@last_insert_id;

      CALL place_building_on_board(board_building_id,x,y,0,0);

      IF NOT EXISTS(SELECT id FROM board WHERE game_id=g_id AND `type`<>'unit' AND ref=board_building_id) THEN /*Building not placed*/
        DELETE FROM board_buildings WHERE id=board_building_id;
        SET i=i+1;
      ELSE
        INSERT INTO board_buildings_features(board_building_id,feature_id,param) SELECT board_building_id,bf.feature_id,bf.param FROM building_default_features bf WHERE bf.building_id=building_id;
      END IF;

      SET i=i-1;
    END WHILE;
  END;
  END IF;

END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`initialization` $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `initialization`(g_id INT)
BEGIN
  DECLARE started_game_status INT DEFAULT 2; /*NOTE hardcode because this id is unlikely to change*/

  CALL init_player_num_teams(g_id);
  CALL init_player_gold(g_id);
  CALL init_decks(g_id);
  CALL init_buildings(g_id);
  CALL init_units(g_id);
  CALL init_landscape(g_id);
  CALL init_statistics(g_id);

  INSERT INTO active_players(game_id,player_num,turn,last_end_turn) SELECT g_id,MIN(player_num),0,CURRENT_TIMESTAMP FROM players WHERE game_id=g_id AND owner<>0; /*min player_num(=0) starts*/
  UPDATE games SET `status_id`=started_game_status WHERE id=g_id;

END $$

DELIMITER ;