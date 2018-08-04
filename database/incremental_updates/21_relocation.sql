use lords;

insert into cards(image, cost, type, ref, code) values('relocation.png', 40, 'm', 0, 'relocation');
set @card_id = LAST_INSERT_ID();

insert into cards_i18n(card_id, language_id, name, description) values(@card_id, 1, 'Relocation', 'Move chosen building or obstacle (except castles) anywhere else'),
	(@card_id, 2, 'Переезд', 'Переместить выбранное здание (кроме замков).');

insert into procedures(name, params) values('cast_relocation', 'card,building,empty_coord,rotation,flip');
set @proc_id = LAST_INSERT_ID();

insert into cards_procedures(card_id, procedure_id) values(@card_id, @proc_id);

insert into modes_cards(mode_id, card_id, quantity) values(9, @card_id, 1);

INSERT INTO `lords`.`log_message_text_i18n`(`code`,`language_id`,`message`)
VALUES ('building_moved', 1, '{building0} is moved from {cell1}'),
('building_moved', 2, 'Здание {building0} перемещено из {cell1}');

