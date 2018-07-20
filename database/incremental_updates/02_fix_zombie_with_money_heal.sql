use lords;

DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`zombies_change_player_to_nec` $$

CREATE PROCEDURE `zombies_change_player_to_nec`(nec_board_id INT)
BEGIN
  DECLARE g_id INT;
  DECLARE zombie_board_id INT;
  DECLARE nec_p_num,zombie_p_num INT;
  DECLARE npc_gold INT;

  DECLARE done INT DEFAULT 0;
  DECLARE cur CURSOR FOR
    SELECT buf.board_unit_id,bu.player_num
    FROM board_units_features buf JOIN board_units bu ON (buf.board_unit_id=bu.id)
    WHERE buf.feature_id=unit_feature_get_id_by_code('under_control') AND buf.param=nec_board_id AND bu.player_num<>nec_p_num;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  SELECT bu.game_id,bu.player_num INTO g_id,nec_p_num FROM board_units bu WHERE bu.id=nec_board_id LIMIT 1;

    OPEN cur;
    REPEAT
      FETCH cur INTO zombie_board_id,zombie_p_num;
      IF NOT done THEN

          UPDATE board_units SET player_num=nec_p_num,moves_left=0 WHERE id=zombie_board_id;
          CALL cmd_unit_set_owner(g_id,nec_p_num,zombie_board_id);
          CALL cmd_unit_set_moves_left(g_id,nec_p_num,zombie_board_id);

          IF ((SELECT owner FROM players WHERE game_id=g_id AND player_num=zombie_p_num LIMIT 1)<>1)
            AND NOT EXISTS (SELECT id FROM board_units WHERE game_id=g_id AND player_num=zombie_p_num)
            AND NOT EXISTS (SELECT id FROM board_buildings WHERE game_id=g_id AND player_num=zombie_p_num)
          THEN
            SELECT gold INTO npc_gold FROM players WHERE game_id=g_id AND player_num=zombie_p_num LIMIT 1; 
            IF(npc_gold>0)THEN
              UPDATE players SET gold = gold + npc_gold WHERE game_id = g_id AND player_num = nec_p_num;
              CALL cmd_player_set_gold(g_id,nec_p_num);
            END IF;

            DELETE FROM players WHERE game_id=g_id AND player_num=zombie_p_num; 
            CALL cmd_delete_player(g_id,zombie_p_num);
          END IF;

      END IF;
    UNTIL done END REPEAT;
    CLOSE cur;


END$$

