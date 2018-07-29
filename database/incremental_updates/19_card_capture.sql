use lords;

insert into cards(image, cost, type, ref, code) values('capture.png', 65, 'm', 0, 'capture');
set @card_id = LAST_INSERT_ID();

insert into cards_i18n(card_id, language_id, name, description) values(@card_id, 1, 'Capture', 'Chosen building becomes yours (except castles)'),
	(@card_id, 2, 'Захват', 'Присвоить выбранное здание (кроме замков).');

insert into procedures(name, params) values('cast_capture', 'card,building');
set @proc_id = LAST_INSERT_ID();

insert into cards_procedures(card_id, procedure_id) values(@card_id, @proc_id);

insert into modes_cards(mode_id, card_id, quantity) values(9, @card_id, 1);

INSERT INTO `lords`.`log_message_text_i18n`(`code`,`language_id`,`message`)
VALUES ('building_captured', 1, '{building0} is captured by {player1}'),
('building_captured', 2, 'Здание {building0} захвачено игроком {player1}');


