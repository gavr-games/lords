use lords_site;

insert into error_dictionary(code) values('everyone_is_in_the_same_team');
SET @err_id = LAST_INSERT_ID();
insert into error_dictionary_i18n(error_id, language_id, description) values
(@err_id, 1, 'Players should be distributed into at least two teams'),
(@err_id, 2, 'Должно быть минимум две команды');


