use lords_site;

ALTER TABLE users MODIFY pass_hash varchar(255) NULL;
ALTER TABLE users MODIFY language_id int(11) NOT NULL DEFAULT 1;
ALTER TABLE users ADD is_bot int NOT NULL DEFAULT 0;

insert into error_dictionary(code) values ('unavailable_for_guest_users');
SET @err_id = LAST_INSERT_ID();
insert into error_dictionary_i18n(error_id, language_id, description) values
(@err_id, 1, 'This is not available for guest users'),
(@err_id, 2, 'Эта операция недоступна гостевым пользователям');

insert into error_dictionary(code) values ('incorrect_bot_id');
SET @err_id = LAST_INSERT_ID();
insert into error_dictionary_i18n(error_id, language_id, description) values
(@err_id, 1, 'Incorrect bot ID'),
(@err_id, 2, 'Неправильный ID бота');

insert into error_dictionary(code) values ('bot_is_not_in_this_game');
SET @err_id = LAST_INSERT_ID();
insert into error_dictionary_i18n(error_id, language_id, description) values
(@err_id, 1, 'Bot is not in this game'),
(@err_id, 2, 'Бот не в этой игре');

