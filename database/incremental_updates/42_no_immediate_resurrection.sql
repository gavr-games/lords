use lords;

alter table graves add player_num_when_killed INT NOT NULL;
alter table graves add turn_when_killed INT NOT NULL;

insert into error_dictionary(code) values('cant_resurrect_same_turn');
SET @err_id = LAST_INSERT_ID();
insert into error_dictionary_i18n(error_id, language_id, description) values
(@err_id, 1, 'Unit cannot be killed and resurrected within the same player''s turn'),
(@err_id, 2, 'Юнит не может быть воскрешен в том же ходу, когда был убит');

update units_i18n set description = 'Can resurrect a unit for a normal price when near its grave, even immediately after it was killed. Can sacrifice a neighbouring own unit and cause damage to any other unit on the board'
where language_id = 1 and unit_id = (select id from units where ui_code = 'necromancer' limit 1);

update units_i18n set description = 'Воскрешает юнитов из могильника за их обычную цену, если стоит возле могилы, даже сразу после того, как юнит убит; может повреждать юнитов на любом расстоянии, принося в жертву своего юнита'
where language_id = 2 and unit_id = (select id from units where ui_code = 'necromancer' limit 1);

