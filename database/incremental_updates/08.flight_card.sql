use lords;

insert into cards(image, cost, type, ref, code) values('flight.png', 15, 'm', 0, 'flight');
set @card_id = LAST_INSERT_ID();

insert into cards_i18n(card_id, language_id, name, description) values
	(@card_id, 1, 'Flight', 'Chosen unit can fly over obstacles'),
	(@card_id, 2, 'Полет', 'Выбранный юнит может перелетать препятствия.');

insert into procedures(name, params) values('cast_flight', 'card,unit');
set @proc_id = LAST_INSERT_ID();

insert into cards_procedures(card_id, procedure_id) values(@card_id, @proc_id);

insert into modes_cards(mode_id, card_id, quantity) values(9, @card_id, 2);

