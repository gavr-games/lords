use lords;

delete from procedures where name like 'cast_polza_%' or name like 'cast_vred_%';
delete from nonfinished_actions_dictionary where command_procedure like 'cast_polza_%' or command_procedure like 'cast_vred_%';
delete from cards where code in ('polza', 'vred');
delete from log_message_text_i18n where code like 'polza%' or code like 'vred%';

DROP PROCEDURE IF EXISTS `cast_polza_main`;
DROP PROCEDURE IF EXISTS `cast_polza_resurrect`;
DROP PROCEDURE IF EXISTS `cast_polza_units_from_zone`;
DROP PROCEDURE IF EXISTS `cast_polza_move_building`;

DROP PROCEDURE IF EXISTS `cast_vred_main`;
DROP PROCEDURE IF EXISTS `cast_vred_pooring`;
DROP PROCEDURE IF EXISTS `cast_vred_kill_unit`;
DROP PROCEDURE IF EXISTS `cast_vred_destroy_building`;
DROP PROCEDURE IF EXISTS `cast_vred_move_building`;

DROP PROCEDURE IF EXISTS `vred_player_takes_card_from_everyone`;
DROP PROCEDURE IF EXISTS `vred_pooring`;


DELIMITER $$

DROP PROCEDURE IF EXISTS `lords`.`finish_nonfinished_action` $$

CREATE PROCEDURE `finish_nonfinished_action`(g_id INT,   p_num INT,   nonfinished_action INT)
BEGIN

  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Calling finish_nonfinished_action is not supposed to happen';

  UPDATE active_players SET nonfinished_action_id=0 WHERE game_id=g_id AND player_num=p_num;

  CALL finish_playing_card(g_id,p_num);

END$$

DELIMITER ;
