use lords;

insert into cards(image, cost, type, ref, code) values('zone_express.png', 20, 'm', 0, 'zone_express');
set @card_id = LAST_INSERT_ID();

insert into cards_i18n(card_id, language_id, name, description) values(@card_id, 1, 'Zone express', 'Move all units either into or out of a chosen zone'),
	(@card_id, 2, 'Экспресс', 'Переместить всех юнитов либо из либо в выбранную зону.');

insert into procedures(name, params) values('cast_zone_express_into', 'card,zone');
set @proc_id = LAST_INSERT_ID();

insert into cards_procedures(card_id, procedure_id) values(@card_id, @proc_id);

insert into procedures(name, params) values('cast_zone_express_out', 'card,zone');
set @proc_id = LAST_INSERT_ID();

insert into cards_procedures(card_id, procedure_id) values(@card_id, @proc_id);

insert into modes_cards(mode_id, card_id, quantity) values(9, @card_id, 2);

