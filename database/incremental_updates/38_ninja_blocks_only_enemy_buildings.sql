use lords;

update units_i18n set description = 'Dodges melee and range attacks with probability 1/2. Blocks opponent''s buildings when stays in their radius'
where language_id = 1 and unit_id = (select id from units where ui_code = 'ninja' limit 1);

update units_i18n set description = 'Вероятность попадания в ниндзю 1/2. Блокирует здания противника, если находится в их радиусе.'
where language_id = 2 and unit_id = (select id from units where ui_code = 'ninja' limit 1);

