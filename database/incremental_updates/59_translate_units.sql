use lords;

ALTER TABLE `units` DROP COLUMN `name`;
ALTER TABLE `units` DROP COLUMN `description`;
ALTER TABLE `units` DROP COLUMN `log_short_name`;
ALTER TABLE `units` DROP COLUMN `log_name_rod_pad`;

DROP TABLE IF EXISTS `units_i18n`;
CREATE TABLE `units_i18n` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `unit_id` int(10) unsigned NOT NULL,
  `language_id` int(10) unsigned NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(1000),
  `log_short_name` varchar(50),
  `log_name_accusative` varchar(50),
  PRIMARY KEY (`id`),
  FOREIGN KEY (`unit_id`) REFERENCES `units` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


INSERT INTO `units_i18n` (language_id, `unit_id`, name, description, log_short_name, log_name_accusative) VALUES 
(2,1,'Копейщик','При критическом ударе на конного рыцаря +1 атаки','Копейщик','Копейщика'),
(2,2,'Мечник',NULL,'Мечник','Мечника'),
(2,3,'Рыцарь','При критическом ударе дракона +2 атаки','Рыцарь','Рыцаря'),
(2,4,'Конный рыцарь','При критическом ударе дракона +2 атаки','Кон. рыц.','Кон. рыц.'),
(2,5,'Ниндзя','Вероятность попадания в ниндзю 1/3. Если он находится в радиусе здания, то оно не работает.','Ниндзя','Ниндзю'),
(2,6,'Голем','Неуязвим к магии. При атаке урон по голему уменьшается на 1','Голем','Голема'),
(2,7,'Таран','Наносит урон только зданиям. Юнитов отпихивает при атаке. Можно прицеплять к юнитам.','Таран','Таран'),
(2,8,'Маг','Имеет собственный 1 щит. Может лечить других юнитов. Колдует Огненный Шар с вероятностью 2/9 (при этом с вероятностью 1/36 погибает из-за ошибки в заклинании)','Маг','Мага'),
(2,9,'Некромант','Воскрешает юнитов из могильника за их обычную цену, может повреждать врагов жертвоприношением','Некромант','Некроманта'),
(2,10,'Дракон','Атакует несколько целей рядом одновременно','Дракон','Дракона'),
(2,11,'Жабка','Атакует ближайшего юнита любого игрока','Жабка','Жабку'),
(2,12,'Тролль','Атакует ближайшее здание, пока его не тронут','Тролль','Тролля'),
(2,13,'Вампир','Заражает вампиризмом, выпивает здоровье','Вампир','Вампира'),
(2,14,'Копейщик','При критическом ударе на конного рыцаря +1 атаки','Копейщик','Копейщика'),
(2,15,'Мечник',NULL,'Мечник','Мечника'),
(2,16,'Рыцарь','При критическом ударе дракона +2 атаки','Рыцарь','Рыцаря'),
(2,17,'Конный рыцарь','При критическом ударе дракона +2 атаки','Кон. рыц.','Кон. рыц.'),
(2,18,'Ниндзя','Вероятность попадания в ниндзю 1/2. Если он находится в радиусе здания, то оно не работает.','Ниндзя','Ниндзю'),
(2,19,'Голем','Неуязвим к магии. При атаке урон по голему уменьшается на 1','Голем','Голема'),
(2,20,'Таран','Наносит урон только зданиям. Юнитов отпихивает при атаке. Можно прицеплять к юнитам.','Таран','Таран'),
(2,21,'Маг','Имеет собственный 1 щит. Может лечить других юнитов. Колдует Огненный Шар с вероятностью 2/9 (при этом с вероятностью 1/36 погибает из-за ошибки в заклинании)','Маг','Мага'),
(2,22,'Некромант','Воскрешает юнитов из могильника за их обычную цену, может повреждать врагов жертвоприношением','Некромант','Некроманта'),
(2,23,'Дракон','Атакует несколько целей рядом одновременно','Дракон','Дракона'),
(2,24,'Жабка','Атакует ближайшего юнита любого игрока','Жабка','Жабку'),
(2,25,'Тролль','Атакует ближайшее здание, пока его не тронут','Тролль','Тролля'),
(2,26,'Вампир','Заражает вампиризмом, выпивает здоровье','Вампир','Вампира'),
(2,27,'Лучник','Не бьет в ближнем бою. Стреляет только по юнитам. Через клетку - попадает всегда, через две клетки - 1/2, через три клетки - 1/6','Лучник','Лучника'),
(2,28,'Арбалетчик','Не бьет в ближнем бою. Стреляет только по юнитам. Через клетку на 2 урона, через две - 1 или 2, через три - вероятность попадания 1/2 и 1 урона','Арбалетчик','Арбалетчика'),
(2,29,'Катапульта','Стреляет по зданиям. Через клетку всегда попадает, через две 1/2, через три 1/3, через четыре 1/6','Катапульта','Катапульту');

INSERT INTO `units_i18n` (language_id, `unit_id`, name, description, log_short_name, log_name_accusative) VALUES 
(1,1,'Spearman','+1 damage on critical hit against Chevalier',NULL,NULL),
(1,2,'Swordsman',NULL,NULL,NULL),
(1,3,'Knight','+2 damage on critical hit against Dragon',NULL,NULL),
(1,4,'Cavalier','+2 damage on critical hit against Dragon',NULL,NULL),
(1,5,'Ninja','Dodges attacks with probability 2/3. Blocks buildings when stays in their radius',NULL,NULL),
(1,6,'Golem','Resistant to magic. All damage on Golem is reduced by 1',NULL,NULL),
(1,7,'Ram','Can only damage buildings. When attacks a unit, pushes it one square without damage. Can be attached to another unit for towing',NULL,NULL),
(1,8,'Wizard','Has a magical shield. Can heal other units. Can cast Fireball with probability 2/9, but with probability 1/36 dies because of misspelling',NULL,NULL),
(1,9,'Necromancer','Can resurrect a unit for a normal price when near its grave. Can sacrifice a neighbouring own unit and cause damage to any other unit on the board',NULL,NULL),
(1,10,'Dragon','Attacks multiple targets simultaneously',NULL,NULL),
(1,11,'Frog','Attacks the nearest unit apart from fellow frogs',NULL,NULL),
(1,12,'Troll','Attacks the nearest building (except castles). If attacked, fights back',NULL,NULL),
(1,13,'Vampire','Attacks closest units and buildings. Can turn into vampire when kills a unit. Can drink health if hurts a unit',NULL,NULL),
(1,14,'Spearman','+1 damage on critical hit against Chevalier',NULL,NULL),
(1,15,'Swordsman',NULL,NULL,NULL),
(1,16,'Knight','+2 damage on critical hit against Dragon',NULL,NULL),
(1,17,'Cavalier','+2 damage on critical hit against Dragon',NULL,NULL),
(1,18,'Ninja','Dodges melee and range attacks with probability 1/2. Blocks buildings when stays in their radius',NULL,NULL),
(1,19,'Golem','Resistant to magic. All damage on Golem is reduced by 1',NULL,NULL),
(1,20,'Ram','Can only damage buildings. When attacks a unit, pushes it one square without damage. Can be attached to another unit for towing',NULL,NULL),
(1,21,'Wizard','Has a magical shield. Can heal other units. Can cast Fireball with probability 2/9, but with probability 1/36 dies because of misspelling',NULL,NULL),
(1,22,'Necromancer','Can resurrect a unit for a normal price when near its grave. Can sacrifice a neighbouring own unit and cause damage to any other unit on the board',NULL,NULL),
(1,23,'Dragon','Attacks multiple targets simultaneously',NULL,NULL),
(1,24,'Frog','Attacks the nearest unit apart from fellow frogs',NULL,NULL),
(1,25,'Troll','Attacks the nearest building (except castles). If attacked, fights back',NULL,NULL),
(1,26,'Vampire','Attacks closest units and buildings. Can turn into vampire when kills a unit. Can drink health if hurts a unit',NULL,NULL),
(1,27,'Archer','No melee attack. Attacks only units. Hits a targed at distance 2 always, at distance 3 with probability 1/2, at distance 4 with probability 1/6',NULL,NULL),
(1,28,'Marksman','No melee attack. Attacks only units. Hits a targed at distance 2 for 2 damage, at distance 3 for 1 or 2 damage, at distance 4 for 1 damage with probability 1/2',NULL,NULL),
(1,29,'Catapult','No melee attack. Attacks only buildings. Hits a targed at distance 2 always, at distance 3 with probability 1/2, at distance 4 with probability 1/3, at distance 5 with probability 1/6. Can be attached to another unit for towing',NULL,NULL);


