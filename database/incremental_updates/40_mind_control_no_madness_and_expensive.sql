use lords;

update cards set cost = 80 where code = 'mind_control';

update cards_i18n set description = 'Gives control over a chosen unit'
where language_id = 1 and card_id = (select id from cards where code = 'mind_control');

update cards_i18n set description = 'Дает контроль над выбранным юнитом.'
where language_id = 2 and card_id = (select id from cards where code = 'mind_control');

