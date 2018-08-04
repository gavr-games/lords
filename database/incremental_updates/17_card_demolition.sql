use lords;

insert into cards(image, cost, type, ref, code) values('demolition.png', 40, 'm', 0, 'demolition');
set @card_id = LAST_INSERT_ID();

insert into cards_i18n(card_id, language_id, name, description) values(@card_id, 1, 'Demolition', '4 damage to any building (except castles)'),
	(@card_id, 2, 'Разрушение', '4 урона любому зданию кроме замков.');

insert into procedures(name, params) values('cast_demolition', 'card,building');
set @proc_id = LAST_INSERT_ID();

insert into cards_procedures(card_id, procedure_id) values(@card_id, @proc_id);

insert into modes_cards(mode_id, card_id, quantity) values(9, @card_id, 2);

