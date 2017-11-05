use lords;

ALTER TABLE `cards` DROP COLUMN `name`;
ALTER TABLE `cards` DROP COLUMN `description`;

ALTER TABLE `cards` ADD COLUMN `code` varchar(50) NOT NULL DEFAULT '';

update cards set code = REPLACE(image,'.png','');

alter table `cards` alter column `code` drop default;
