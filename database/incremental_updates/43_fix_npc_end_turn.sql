use lords;

delimiter $$

DROP PROCEDURE IF EXISTS `end_units_phase`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `end_units_phase`(g_id INT,p_num INT)
BEGIN
  DECLARE g_mode INT;
  DECLARE two_phase_turn INT;

  SELECT g.mode_id INTO g_mode FROM games g WHERE g.id=g_id LIMIT 1;
  SELECT cfg.`value` INTO two_phase_turn FROM mode_config cfg WHERE cfg.param='two_phase_turn' AND cfg.mode_id=g_mode;

  IF(two_phase_turn IS NULL OR two_phase_turn=0)THEN
    CALL end_turn(g_id,p_num);
  ELSE
    IF ((SELECT card_played_flag FROM active_players WHERE game_id=g_id AND player_num=p_num) = 1 OR (p_num >= 10)) THEN
      CALL end_turn(g_id,p_num);
    END IF;
  END IF;

END$$

delimiter ;