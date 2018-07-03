use lords;

insert into cards(image, cost, type, ref, code) values('berserk.png', 10, 'm', 0, 'berserk');
set @card_id = LAST_INSERT_ID();

insert into cards_i18n(card_id, language_id, name, description) values(@card_id, 1, 'Berserk', '+2 attack to any unit'),
	(@card_id, 2, 'Берсерк', '+2 атаки выбранному юниту.');

insert into procedures(name, params) values('cast_berserk', 'card,unit');
set @proc_id = LAST_INSERT_ID();

insert into cards_procedures(card_id, procedure_id) values(@card_id, @proc_id);

insert into modes_cards(mode_id, card_id, quantity) values(9, @card_id, 1);



insert into cards(image, cost, type, ref, code) values('knights_move.png', 10, 'm', 0, 'knights_move');
set @card_id = LAST_INSERT_ID();

insert into cards_i18n(card_id, language_id, name, description) values(@card_id, 1, 'Knight''s move', 'Chosen unit starts to move as a chess knight'),
	(@card_id, 2, 'Ход конем', 'Выбранный юнит начинает ходить шахматным конем.');

insert into procedures(name, params) values('cast_knights_move', 'card,unit');
set @proc_id = LAST_INSERT_ID();

insert into cards_procedures(card_id, procedure_id) values(@card_id, @proc_id);

insert into modes_cards(mode_id, card_id, quantity) values(9, @card_id, 1);


