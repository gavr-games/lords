use lords;

DROP TABLE IF EXISTS `npc_player_name_modificators_i18n`;
CREATE TABLE `npc_player_name_modificators_i18n` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL,
  `language_id` int(10) unsigned NOT NULL,
  `text` varchar(500) NOT NULL,
  `log_text` varchar(500),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO npc_player_name_modificators_i18n (language_id, code, text, log_text) VALUES
(2, '{mad}', 'Безумный', 'Безум.'),
(1, '{mad}', 'Mad', NULL),
(2, '{zombie}', 'Зомби', NULL),
(1, '{zombie}', 'Zombie', NULL),
(2, '{vampire}', 'Вампир', 'Вамп.'),
(1, '{vampire}', 'Vampire', NULL);

