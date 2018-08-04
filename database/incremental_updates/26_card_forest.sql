use lords;

insert into cards(image, cost, type, ref, code) values('forest.png', 25, 'm', 0, 'forest');
set @card_id = LAST_INSERT_ID();

insert into cards_i18n(card_id, language_id, name, description) values(@card_id, 1, 'Forest', 'Creates a 5x5 square of trees around a chosen cell'),
	(@card_id, 2, 'Чаща', 'Создает квадрат из деревьев 5x5 вокруг выбранной клетки.');

insert into procedures(name, params) values('cast_forest', 'card,any_coord');
set @proc_id = LAST_INSERT_ID();

insert into cards_procedures(card_id, procedure_id) values(@card_id, @proc_id);

insert into modes_cards(mode_id, card_id, quantity) values(9, @card_id, 1);

insert into error_dictionary (code) values ('invalid_coord');
set @err_id = LAST_INSERT_ID();

insert into error_dictionary_i18n(error_id, language_id, description)
values (@err_id, 1, 'Invalid coordinate'), (@err_id, 2, 'Неправильная координата');

