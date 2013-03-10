USE `lords_site`;

CREATE TABLE  `lords_site`.`user_statistics_games` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `game_type_id` int(10) unsigned NOT NULL,
  `mode_id` int(10) unsigned NOT NULL,
  `game_result` enum('win','lose','draw','exit','kicked') NOT NULL,
  `insert_timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_statistics_games_users` (`user_id`),
  KEY `user_statistics_games_game_types` (`game_type_id`),
  CONSTRAINT `user_statistics_games_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `user_statistics_games_game_types` FOREIGN KEY (`game_type_id`) REFERENCES `dic_game_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


USE `lords`;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`player_exit` $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `player_exit`(g_id INT,p_num INT)
BEGIN
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_independent_message($p_num,"$log_player вышел из игры")';
  DECLARE p_id INT;
  DECLARE finished_game_status INT DEFAULT 3; /*NOTE hardcode because this id is unlikely to change*/
  DECLARE user_id INT;
  DECLARE owner INT;
  DECLARE player_online_status_id INT DEFAULT 1; /*NOTE hardcode because this id is unlikely to change*/
  DECLARE mode_id INT;
  DECLARE game_type_id INT;

  CALL user_action_begin();

  SELECT g.mode_id, g.type_id INTO mode_id, game_type_id FROM games g WHERE g.id = g_id;

  SELECT p.id,p.owner,p.user_id INTO p_id,owner,user_id FROM players p WHERE game_id=g_id AND player_num=p_num;

  IF (SELECT g.status_id FROM games g WHERE g.id=g_id LIMIT 1)<>finished_game_status AND (owner=1) THEN
    SET cmd_log=REPLACE(cmd_log,'$p_num',p_num);
    SET cmd_log=REPLACE(cmd_log,'$log_player',log_player(g_id,p_num));
    INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

    CALL delete_player_objects(g_id,p_num);

    IF (SELECT player_num FROM active_players WHERE game_id=g_id LIMIT 1)=p_num THEN
      CALL end_turn(g_id,p_num);
    END IF;

    CALL cmd_delete_player(g_id,p_num);

    UPDATE players SET owner=0 WHERE game_id=g_id AND player_num=p_num;

    INSERT INTO lords_site.user_statistics_games(user_id,game_type_id,mode_id,game_result)
    VALUES(user_id,game_type_id,mode_id,'exit');

    IF (SELECT COUNT(DISTINCT p.team) FROM players p WHERE p.game_id=g_id AND p.owner=1)=1 THEN
      CALL end_game(g_id);
    END IF;
  END IF;

  IF(owner=0)THEN
    CALL cmd_remove_spectator(g_id,p_num);
  END IF;

  DELETE agp FROM lords_site.arena_game_players agp WHERE agp.user_id=user_id;

  UPDATE lords_site.arena_users au SET au.status_id=player_online_status_id
    WHERE au.user_id=user_id;


  IF (SELECT COUNT(*) FROM players p WHERE p.game_id=g_id AND p.player_num<>p_num AND p.owner IN(0,1))=0 THEN
    CALL delete_game_data(g_id);
  END IF;

  CALL user_action_end();
  
  DELETE FROM players WHERE game_id=g_id AND player_num=p_num;  
END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`end_game` $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `end_game`(g_id INT)
BEGIN
  DECLARE p_num INT;
  DECLARE finished_game_status INT DEFAULT 3; /*NOTE hardcode because this id is unlikely to change*/
  DECLARE user_id INT;
  DECLARE mode_id INT;
  DECLARE game_type_id INT;

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT p.player_num,p.user_id FROM players p WHERE p.game_id=g_id AND owner=1;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SELECT g.mode_id, g.type_id INTO mode_id, game_type_id FROM games g WHERE g.id = g_id;

  IF (SELECT COUNT(DISTINCT p.team) FROM players p WHERE game_id=g_id AND owner=1)=1 THEN
/*one team wins*/
    OPEN cur;
    REPEAT
      FETCH cur INTO p_num,user_id;
      IF NOT done THEN
        CALL cmd_play_video(g_id,p_num,'win',1);

        INSERT INTO lords_site.user_statistics_games(user_id,game_type_id,mode_id,game_result)
        VALUES(user_id,game_type_id,mode_id,'win');
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur;
  ELSE
/*draw*/
    SELECT player_num INTO p_num FROM active_players WHERE game_id=g_id LIMIT 1;
    CALL cmd_play_video(g_id,p_num,'draw',0);

    INSERT INTO lords_site.user_statistics_games(user_id,game_type_id,mode_id,game_result)
    SELECT p.user_id,game_type_id,mode_id,'draw'
    FROM players p WHERE p.game_id=g_id AND owner=1;

  END IF;

  CALL cmd_end_game(g_id);

  UPDATE games SET status_id=finished_game_status,time_restriction=0 WHERE id=g_id;

  UPDATE lords_site.arena_games SET status_id=finished_game_status,time_restriction=0 WHERE id=g_id;

/*statisticss*/
  CALL statistic_calculation(g_id);

END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`destroy_castle` $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `destroy_castle`(board_castle_id INT,p_num INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p2_num INT; /*castle owner*/
  DECLARE destroyed_castle_x INT;
  DECLARE destroyed_castle_y INT;
  DECLARE destroyed_castle_rotation INT;
  DECLARE destroyed_castle_flip INT;
  DECLARE ruins_building_id INT DEFAULT 8; /*HARDCODE*/
  DECLARE ruins_board_building_id INT;
  DECLARE user_id INT;
  DECLARE mode_id INT;
  DECLARE game_type_id INT;
  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_independent_message($p_num,"$log_building разрушен")';

  SELECT game_id,player_num INTO g_id,p2_num FROM board_buildings WHERE id=board_castle_id LIMIT 1;

/*log*/
      SET cmd_log=REPLACE(cmd_log,'$p_num',p2_num);
      SET cmd_log=REPLACE(cmd_log,'$log_building',log_building(board_castle_id));
      INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

      INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'destroy_building',p2_num);

  SELECT bb.rotation,bb.flip INTO destroyed_castle_rotation,destroyed_castle_flip FROM board_buildings bb WHERE bb.id=board_castle_id LIMIT 1;
  SELECT MIN(b.x),MIN(b.y) INTO destroyed_castle_x,destroyed_castle_y FROM board b WHERE game_id=g_id AND `type`<>'unit' AND ref=board_castle_id;

  CALL delete_player_objects(g_id,p2_num);

/*insert ruins*/
/*
  INSERT INTO board_buildings(game_id,player_num,building_id,rotation,flip)VALUES (g_id,p2_num,ruins_building_id,destroyed_castle_rotation,destroyed_castle_flip);
  SET ruins_board_building_id=@@last_insert_id;

  CALL place_building_on_board(ruins_board_building_id,destroyed_castle_x,destroyed_castle_y,destroyed_castle_rotation,destroyed_castle_flip);

  CALL cmd_put_building(g_id,p2_num,ruins_board_building_id);
*/
/*If his turn - end turn*/
  IF (SELECT player_num FROM active_players WHERE game_id=g_id LIMIT 1)=p2_num THEN
    CALL end_turn(g_id,p2_num);
  END IF;
/*spectator*/
  UPDATE players SET owner=0 WHERE game_id=g_id AND player_num=p2_num;

  SELECT p.user_id INTO user_id FROM players p WHERE game_id=g_id AND player_num=p_num;
  UPDATE lords_site.arena_game_players agp SET agp.spectator_flag=1 WHERE agp.user_id=user_id;

  CALL cmd_delete_player(g_id,p2_num);
  CALL cmd_add_spectator(g_id,p2_num);
  CALL cmd_play_video(g_id,p2_num,'destroyed_castle',1);

  SELECT g.mode_id, g.type_id INTO mode_id, game_type_id FROM games g WHERE g.id = g_id;

  INSERT INTO lords_site.user_statistics_games(user_id,game_type_id,mode_id,game_result)
  VALUES(user_id,game_type_id,mode_id,'lose');

  IF (SELECT COUNT(DISTINCT p.team) FROM players p WHERE game_id=g_id AND owner=1)=1 THEN
    CALL end_game(g_id);
  END IF;

END $$

DELIMITER ;

