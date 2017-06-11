use lords_site;

drop table if exists languages;
CREATE TABLE languages (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(2) NOT NULL,
  `name` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO languages (code, name) values ('EN', 'English');
INSERT INTO languages (code, name) values ('RU', 'Русский');

# Non-rerunnable, will throw error on second run
ALTER TABLE `lords_site`.`users` 
ADD COLUMN `language_id` INT(11) NOT NULL DEFAULT 1 AFTER `insert_timestamp`;

alter table `lords_site`.`users`
  alter column `language_id` drop default;

INSERT INTO lords_site.error_dictionary (description) values ('Неизвестный код языка: {0}');

