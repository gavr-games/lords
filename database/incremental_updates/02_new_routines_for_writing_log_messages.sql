USE `lords`;
DROP procedure IF EXISTS `cmd_log_general_message`;

DELIMITER $$
CREATE PROCEDURE `cmd_log_general_message` (g_id INT, p_num INT, p2_num INT, log_msg_type VARCHAR(50) CHARSET utf8, log_msg_code VARCHAR(50) CHARSET utf8, params VARCHAR(900) CHARSET utf8, hidden_flg INT)
BEGIN
  DECLARE cmd VARCHAR(1000) CHARSET utf8;
  SET cmd = CONCAT(log_msg_type, '(', IFNULL(CONCAT(p2_num, ','), ''), '''', log_msg_code, ''',''', IFNULL(params, ''), ''')');
  INSERT INTO command (game_id, player_num, command, hidden_flag) VALUES (g_id, p_num, cmd, hidden_flg);
END$$

DELIMITER ;

DROP procedure IF EXISTS `cmd_log_add_message`;

DELIMITER $$
CREATE PROCEDURE `cmd_log_add_message` (g_id INT, p_num INT, log_msg_code VARCHAR(50) CHARSET utf8, params VARCHAR(900) CHARSET utf8)
BEGIN
  CALL cmd_log_general_message(g_id, p_num, NULL, 'log_add_message', log_msg_code, params, 0);
END$$

DELIMITER ;

DROP procedure IF EXISTS `cmd_log_add_message_hidden`;

DELIMITER $$
CREATE PROCEDURE `cmd_log_add_message_hidden` (g_id INT, p_num INT, log_msg_code VARCHAR(50) CHARSET utf8, params VARCHAR(900) CHARSET utf8)
BEGIN
  CALL cmd_log_general_message(g_id, p_num, NULL, 'log_add_message', log_msg_code, params, 1);
END$$

DELIMITER ;

DROP procedure IF EXISTS `cmd_log_add_independent_message`;

DELIMITER $$
CREATE PROCEDURE `cmd_log_add_independent_message` (g_id INT, p_num INT, log_msg_code VARCHAR(50) CHARSET utf8, params VARCHAR(900) CHARSET utf8)
BEGIN
  CALL cmd_log_general_message(g_id, p_num, p_num, 'log_add_independent_message', log_msg_code, params, 0);
END$$

DELIMITER ;

DROP procedure IF EXISTS `cmd_log_add_independent_message_hidden`;

DELIMITER $$
CREATE PROCEDURE `cmd_log_add_independent_message_hidden` (g_id INT, p_num INT, log_msg_code VARCHAR(50) CHARSET utf8, params VARCHAR(900) CHARSET utf8)
BEGIN
  CALL cmd_log_general_message(g_id, p_num, p_num, 'log_add_independent_message', log_msg_code, params, 1);
END$$

DELIMITER ;

DROP procedure IF EXISTS `cmd_log_add_container`;

DELIMITER $$
CREATE PROCEDURE `cmd_log_add_container` (g_id INT, p_num INT, log_msg_code VARCHAR(50) CHARSET utf8, params VARCHAR(900) CHARSET utf8)
BEGIN
  CALL cmd_log_general_message(g_id, p_num, p_num, 'log_add_container', log_msg_code, params, 0);
END$$

DELIMITER ;

