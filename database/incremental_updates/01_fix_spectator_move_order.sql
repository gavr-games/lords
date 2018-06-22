use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`init_player_num_teams` $$

CREATE PROCEDURE `init_player_num_teams`(g_id INT)
BEGIN
  DECLARE player_count INT;
  DECLARE teams_count INT;
  DECLARE castles_count INT;

  DECLARE all_versus_all,random_teams,teammates_in_random_castles INT;

  SELECT COUNT(*) INTO player_count FROM players WHERE game_id=g_id AND owner<>0;
  SELECT m.max_players INTO castles_count FROM games g JOIN modes m ON (g.mode_id=m.id) WHERE g.id=g_id LIMIT 1;

  SET all_versus_all=game_feature_get_param(g_id,'all_versus_all');
  SET random_teams=game_feature_get_param(g_id,'random_teams');
  SET teammates_in_random_castles=game_feature_get_param(g_id,'teammates_in_random_castles');


  IF(all_versus_all=1)THEN
    SET teams_count=player_count;
  END IF;

  IF(random_teams=1)THEN
    SET teams_count=game_feature_get_param(g_id,'number_of_teams');
  END IF;

  IF((all_versus_all=1)OR(random_teams=1))THEN

    CREATE TEMPORARY TABLE player_teams (num INT AUTO_INCREMENT PRIMARY KEY)AUTO_INCREMENT=1 SELECT id FROM players WHERE game_id=g_id AND owner<>0 ORDER BY RAND();

    UPDATE players p,player_teams t SET p.team=(t.num-1) % teams_count
    WHERE p.id=t.id;

    DROP TEMPORARY TABLE player_teams;
  END IF;


  IF(teammates_in_random_castles=1)THEN
  BEGIN
    DECLARE i INT DEFAULT 0;
    CREATE TEMPORARY TABLE castles (castle_id INT PRIMARY KEY);

    WHILE i<castles_count DO
      INSERT INTO castles(castle_id) VALUES(i);
      SET i=i+1;
    END WHILE;

    CREATE TEMPORARY TABLE player_shuffled (num INT AUTO_INCREMENT PRIMARY KEY)AUTO_INCREMENT=1 SELECT id FROM players WHERE game_id=g_id AND owner<>0 ORDER BY RAND();
    CREATE TEMPORARY TABLE castles_shuffled (num INT AUTO_INCREMENT PRIMARY KEY)AUTO_INCREMENT=1 SELECT castle_id FROM castles ORDER BY RAND();

    UPDATE players p,player_shuffled ps,castles_shuffled cs SET p.player_num=cs.castle_id
    WHERE p.id=ps.id AND ps.num=cs.num;

    DROP TEMPORARY TABLE castles;
    DROP TEMPORARY TABLE player_shuffled;
    DROP TEMPORARY TABLE castles_shuffled;
  END;
  ELSE
  BEGIN

    DECLARE i INT DEFAULT 0;

    
    CREATE TEMPORARY TABLE cycle_castles (castle_id INT PRIMARY KEY);

    CREATE TEMPORARY TABLE cycle_castles_with_number (num INT AUTO_INCREMENT PRIMARY KEY,castle_id INT);

    CREATE TEMPORARY TABLE free_players (num INT AUTO_INCREMENT PRIMARY KEY)AUTO_INCREMENT=1 SELECT id,player_num,team FROM players WHERE game_id=g_id AND owner<>0 ORDER BY RAND();

    WHILE i<player_count DO
      INSERT INTO cycle_castles(castle_id) VALUES(FLOOR((castles_count/player_count)*i));
      SET i=i+1;
    END WHILE;

    WHILE (SELECT COUNT(*) FROM free_players)>0 DO
    BEGIN
      DECLARE current_team INT;
      DECLARE team_player_count INT;
      DECLARE cur_player_id INT;
      DECLARE cur_castle_id INT;
      DECLARE castles_count INT;
      DECLARE cur_castle_number INT;

      DECLARE done INT DEFAULT 0;
      DECLARE cur CURSOR FOR SELECT fp.id FROM free_players fp WHERE fp.team=current_team;
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

      SELECT f.team,COUNT(*) INTO current_team,team_player_count FROM free_players f
      GROUP BY f.team
      ORDER BY COUNT(*) DESC, RAND() LIMIT 1;

      SET i=0;
      SELECT COUNT(*) INTO castles_count FROM cycle_castles;

      TRUNCATE TABLE cycle_castles_with_number;
      INSERT INTO cycle_castles_with_number (castle_id) SELECT castle_id FROM cycle_castles;

      OPEN cur;
      REPEAT
        FETCH cur INTO cur_player_id;
        IF NOT done THEN
          
          SET cur_castle_number=FLOOR(castles_count/team_player_count*i)+1;

          SELECT castle_id INTO cur_castle_id FROM cycle_castles_with_number WHERE num=cur_castle_number;

          UPDATE free_players SET player_num=cur_castle_id WHERE id=cur_player_id;
          SET i=i+1;
        END IF;
      UNTIL done END REPEAT;
      CLOSE cur;

      UPDATE players p,free_players fp SET p.player_num=fp.player_num
      WHERE p.id=fp.id AND fp.team=current_team;

      DELETE FROM cycle_castles WHERE castle_id IN (SELECT player_num FROM free_players WHERE team=current_team);
      DELETE FROM free_players WHERE team=current_team;

    END;
    END WHILE;

    DROP TEMPORARY TABLE cycle_castles;
    DROP TEMPORARY TABLE cycle_castles_with_number;
    DROP TEMPORARY TABLE free_players;

  END;
  END IF;

  UPDATE players SET move_order = player_num WHERE game_id = g_id AND owner<>0;

END$$

DELIMITER ;

use lords_site;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords_site`.`reset` $$

CREATE PROCEDURE `reset`()
BEGIN
  SET FOREIGN_KEY_CHECKS=0;
  truncate table arena_users;
  truncate table arena_games;
  truncate table arena_games_features_usage;
  truncate table arena_game_players;
  truncate table chat_users;
  truncate table chats;
  delete from users where pass_hash IS NULL;
  update users set game_type_id=0;
  SET FOREIGN_KEY_CHECKS=1;
END$$

DELIMITER ;

