use lords;

update buildings_i18n set description = 'Triples magic of the owner and allies in its radius'
where language_id = 1 and building_id = (select id from buildings where ui_code = 'magic_tower' limit 1);

update buildings_i18n set description = 'Усиливает магию владельца и союзников в 3 раза в радиусе своего действия.'
where language_id = 2 and building_id = (select id from buildings where ui_code = 'magic_tower' limit 1);
