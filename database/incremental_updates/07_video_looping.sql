use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`cmd_play_video` $$

CREATE PROCEDURE `cmd_play_video`(g_id INT, p_num INT, video_code VARCHAR(45), hidden INT, looping INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8 DEFAULT 'play_video("$code","$filename",$looping)';

  SET cmd=REPLACE(cmd,'$code',(SELECT v.code FROM videos v WHERE v.code=video_code LIMIT 1));
  SET cmd=REPLACE(cmd,'$filename',(SELECT v.filename FROM videos v WHERE v.code=video_code LIMIT 1));
  SET cmd=REPLACE(cmd,'$looping',looping);
  INSERT INTO command (game_id,player_num,command,hidden_flag) VALUES (g_id,p_num,cmd,hidden);

END$$

DROP PROCEDURE IF EXISTS `lords`.`destroy_castle` $$

CREATE PROCEDURE `destroy_castle`(board_castle_id INT,   p_num INT)
BEGIN
  DECLARE g_id INT;
  DECLARE g_mode INT;
  DECLARE p2_num INT; 
  DECLARE destroyed_castle_x INT;
  DECLARE destroyed_castle_y INT;
  DECLARE destroyed_castle_rotation INT;
  DECLARE destroyed_castle_flip INT;
  DECLARE ruins_building_id INT;
  DECLARE ruins_board_building_id INT;
  DECLARE user_id INT;
  DECLARE mode_id INT;
  DECLARE game_type_id INT;

  SELECT game_id,player_num INTO g_id,p2_num FROM board_buildings WHERE id=board_castle_id LIMIT 1;
  SELECT g.mode_id INTO g_mode FROM games g WHERE g.id=g_id LIMIT 1;

  CALL cmd_log_add_independent_message(g_id, p2_num, 'castle_destroyed', log_building(board_castle_id));

  INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'destroy_building',p2_num);

  SELECT bb.rotation,bb.flip INTO destroyed_castle_rotation,destroyed_castle_flip FROM board_buildings bb WHERE bb.id=board_castle_id LIMIT 1;
  SELECT MIN(b.x),MIN(b.y) INTO destroyed_castle_x,destroyed_castle_y FROM board b WHERE game_id=g_id AND `type`<>'unit' AND ref=board_castle_id;

  CALL delete_player_objects(g_id,p2_num);


  SELECT v.building_id INTO ruins_building_id FROM vw_mode_building_default_features v WHERE v.mode_id=g_mode AND v.feature_id=building_feature_get_id_by_code('ruins');

  INSERT INTO board_buildings(game_id,player_num,building_id,rotation,flip)VALUES (g_id,p2_num,ruins_building_id,destroyed_castle_rotation,destroyed_castle_flip);
  SET ruins_board_building_id=@@last_insert_id;

  CALL place_building_on_board(ruins_board_building_id,destroyed_castle_x,destroyed_castle_y,destroyed_castle_rotation,destroyed_castle_flip);

  CALL cmd_put_building_by_id(g_id,p2_num,ruins_board_building_id);


  IF (SELECT player_num FROM active_players WHERE game_id=g_id LIMIT 1)=p2_num THEN
    CALL end_turn(g_id,p2_num);
  END IF;

  UPDATE players SET owner=0, move_order = NULL WHERE game_id=g_id AND player_num=p2_num;

  SELECT p.user_id INTO user_id FROM players p WHERE game_id=g_id AND player_num=p2_num;
  UPDATE lords_site.arena_game_players agp SET agp.spectator_flag=1 WHERE agp.user_id=user_id;

  CALL cmd_delete_player(g_id,p2_num);
  CALL cmd_add_spectator(g_id,p2_num);
  CALL cmd_play_video(g_id,p2_num,'destroyed_castle',1,1);

  SELECT g.mode_id, g.type_id INTO mode_id, game_type_id FROM games g WHERE g.id = g_id;

  INSERT INTO lords_site.user_statistics_games(user_id,game_type_id,mode_id,game_result)
  VALUES(user_id,game_type_id,mode_id,'lose');

  IF (SELECT COUNT(DISTINCT p.team) FROM players p WHERE game_id=g_id AND owner=1)=1 THEN
    CALL end_game(g_id);
  END IF;

END$$

DROP PROCEDURE IF EXISTS `lords`.`end_game` $$

CREATE PROCEDURE `end_game`(g_id INT)
BEGIN
  DECLARE p_num INT;
  DECLARE finished_game_status INT DEFAULT 3; 
  DECLARE user_id INT;
  DECLARE mode_id INT;
  DECLARE game_type_id INT;

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR SELECT p.player_num,p.user_id FROM players p WHERE p.game_id=g_id AND owner=1;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SELECT g.mode_id, g.type_id INTO mode_id, game_type_id FROM games g WHERE g.id = g_id;

  IF (SELECT COUNT(DISTINCT p.team) FROM players p WHERE game_id=g_id AND owner=1)=1 THEN

    OPEN cur;
    REPEAT
      FETCH cur INTO p_num,user_id;
      IF NOT done THEN
        CALL cmd_play_video(g_id,p_num,'win',1,1);

        INSERT INTO lords_site.user_statistics_games(user_id,game_type_id,mode_id,game_result)
        VALUES(user_id,game_type_id,mode_id,'win');
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur;
  ELSE

    SELECT player_num INTO p_num FROM active_players WHERE game_id=g_id LIMIT 1;
    CALL cmd_play_video(g_id,p_num,'draw',0,1);

    INSERT INTO lords_site.user_statistics_games(user_id,game_type_id,mode_id,game_result)
    SELECT p.user_id,game_type_id,mode_id,'draw'
    FROM players p WHERE p.game_id=g_id AND owner=1;

  END IF;

  CALL cmd_end_game(g_id);

  UPDATE games SET status_id=finished_game_status,time_restriction=0 WHERE id=g_id;

  UPDATE lords_site.arena_games SET status_id=finished_game_status,time_restriction=0 WHERE id=g_id;


  CALL statistic_calculation(g_id);

END$$

DROP PROCEDURE IF EXISTS `lords`.`cast_armageddon` $$

CREATE PROCEDURE `cast_armageddon`(g_id INT,   p_num INT,   player_deck_id INT)
BEGIN
  DECLARE err_code INT;
  DECLARE board_unit_id INT;
  DECLARE board_building_id INT;
  DECLARE chance INT DEFAULT 1;

  DECLARE done INT DEFAULT 0;
  
  DECLARE cur CURSOR FOR SELECT bu.id FROM board_units bu WHERE bu.game_id=g_id;
  
  DECLARE cur2 CURSOR FOR SELECT bb.id FROM board_buildings bb JOIN buildings b ON (bb.building_id=b.id) WHERE bb.game_id=g_id AND b.`type`<>'castle';
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;


  SET err_code=check_play_card(g_id,p_num,player_deck_id,'cast_armageddon');
  IF err_code<>0 THEN
    SELECT 0 AS `success`, ed.id as `error_code`, null as `error_params` FROM error_dictionary ed WHERE id=err_code;
  ELSE
    CALL user_action_begin();

    CALL play_card_actions(g_id,p_num,player_deck_id); 

    CALL cmd_play_video(g_id,p_num,'armageddon',0,0);

    OPEN cur;
    REPEAT
      FETCH cur INTO board_unit_id;
      IF NOT done THEN
        IF get_random_int_between(1, 6) > chance THEN
          CALL magic_kill_unit(board_unit_id,p_num);
        END IF;
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur;

    SET done=0;

    OPEN cur2;
    REPEAT
      FETCH cur2 INTO board_building_id;
      IF NOT done THEN
        IF get_random_int_between(1, 6) > chance THEN
          CALL destroy_building(board_building_id,p_num);
        END IF;
      END IF;
    UNTIL done END REPEAT;
    CLOSE cur2;

    CALL finish_playing_card(g_id,p_num);
    CALL end_cards_phase(g_id,p_num);

    CALL user_action_end();
  END IF;
END$$


