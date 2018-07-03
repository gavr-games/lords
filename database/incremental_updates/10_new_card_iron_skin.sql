use lords;

insert into cards(image, cost, type, ref, code) values('iron_skin.png', 10, 'm', 0, 'iron_skin');
set @card_id = LAST_INSERT_ID();

insert into cards_i18n(card_id, language_id, name, description) values(@card_id, 1, 'Iron skin', '+2 health to any unit'),
	(@card_id, 2, 'Железная кожа', '+2 здоровья выбранному юниту.');

insert into procedures(name, params) values('cast_iron_skin', 'card,unit');
set @proc_id = LAST_INSERT_ID();

insert into cards_procedures(card_id, procedure_id) values(@card_id, @proc_id);

insert into modes_cards(mode_id, card_id, quantity) values(9, @card_id, 1);

