use lords;

DROP TABLE IF EXISTS `videos`;

CREATE TABLE `videos` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL,
  `filename` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `videos` (`code`, `filename`) VALUES
('destroyed_castle','destroyed_castle001.swf'),
('draw','draw001.swf'),
('win','win001.swf');

DROP TABLE IF EXISTS `videos_i18n`;
CREATE TABLE `videos_i18n` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL,
  `language_id` int(10) unsigned NOT NULL,
  `title` varchar(500) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO videos_i18n (language_id, code, title) VALUES
(2, 'destroyed_castle', 'Поражение'),
(1, 'destroyed_castle', 'Defeat'),
(2, 'draw', 'Ничья'),
(1, 'draw', 'Draw'),
(2, 'win', 'Победа!'),
(1, 'win', 'Victory!');

