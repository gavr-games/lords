use lords;

insert into dic_unit_phrases(unit_id, language_id, phrase)
    select u.id, 1, 'I left my horse at home' from units u where u.ui_code = 'knight_on_foot';

insert into dic_unit_phrases(unit_id, language_id, phrase)
    select u.id, 1, 'Don''t worry this knife is just for making salads' from units u where u.ui_code = 'necromancer';


