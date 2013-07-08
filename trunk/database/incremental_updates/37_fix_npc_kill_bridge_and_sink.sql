use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`kill_unit`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `kill_unit`(bu_id INT,p_num INT)
BEGIN
  DECLARE g_id INT;
  DECLARE p2_num INT; /*unit owner*/
  DECLARE crd_id INT;
  DECLARE grave_id INT;
  DECLARE u_id INT;
  DECLARE reward INT DEFAULT 0;
  DECLARE kill_reward_divisor INT DEFAULT 2; /*get 1/2 of card cost */
  DECLARE binded_unit_id INT;

  DECLARE cmd_log VARCHAR(1000) CHARSET utf8 DEFAULT 'log_add_message("$log_unit убит")';

  SELECT game_id,player_num,card_id,unit_id INTO g_id,p2_num,crd_id,u_id FROM board_units WHERE id=bu_id LIMIT 1;

/*log*/
      SET cmd_log=REPLACE(cmd_log,'$log_unit',log_unit(bu_id));
      INSERT INTO command (game_id,player_num,command) VALUES (g_id,p_num,cmd_log);

/*grave*/
  IF crd_id IS NOT NULL THEN
    IF unit_feature_check(bu_id,'goes_to_deck_on_death') = 1 THEN
      INSERT INTO deck(game_id,card_id) VALUES(g_id,crd_id);
    ELSE /*put to grave*/
      INSERT INTO graves(game_id,card_id) VALUES(g_id,crd_id);
      SET grave_id=@@last_insert_id;
      INSERT INTO grave_cells(grave_id,x,y) SELECT grave_id,b.x,b.y FROM board b WHERE game_id=g_id AND b.`type`='unit' AND b.ref=bu_id;
      CALL cmd_add_to_grave(g_id,p_num,grave_id);
    END IF;
  END IF;

  CALL cmd_kill_unit(g_id,p_num,bu_id);

  DELETE FROM board WHERE game_id=g_id AND `type`='unit' AND ref=bu_id;
  DELETE FROM board_units_features WHERE board_unit_id=bu_id;
  DELETE FROM board_units WHERE id=bu_id;

/*reward*/
  SELECT IFNULL(cost/kill_reward_divisor,0) INTO reward FROM cards WHERE `type`='u' AND ref=u_id LIMIT 1;

/*if npc - take all his money*/
  IF ((SELECT owner FROM players WHERE game_id=g_id AND player_num=p2_num LIMIT 1)<>1)
    AND NOT EXISTS (SELECT id FROM board_units WHERE game_id=g_id AND player_num=p2_num)
    AND NOT EXISTS (SELECT id FROM board_buildings WHERE game_id=g_id AND player_num=p2_num)
  THEN /*if npc defeated*/
    SET reward=reward+(SELECT gold FROM players WHERE game_id=g_id AND player_num=p2_num LIMIT 1);
    DELETE FROM players WHERE game_id=g_id AND player_num=p2_num;
    CALL cmd_delete_player(g_id,p2_num);
  END IF;

  IF(reward>0 AND EXISTS (SELECT id FROM players p WHERE p.game_id=g_id AND p.player_num=p_num))THEN
    UPDATE players SET gold=gold+reward WHERE game_id=g_id AND player_num=p_num;
    CALL cmd_player_set_gold(g_id,p_num);
  END IF;

/*unbind all units binded to this unit*/
  DELETE FROM board_units_features WHERE feature_id IN(unit_feature_get_id_by_code('bind_target'),unit_feature_get_id_by_code('attack_target')) AND param=bu_id;

/*if necromancer is killed*/
  IF EXISTS(SELECT id FROM board_units_features WHERE feature_id=unit_feature_get_id_by_code('under_control') AND param=bu_id LIMIT 1)THEN
    CALL zombies_make_mad(g_id,bu_id);
  END IF;

  INSERT INTO statistic_game_actions(game_id,player_num,`action`,`value`) VALUES(g_id,p_num,'kill_unit',p2_num);

END$$

DELIMITER ;
