use lords;

UPDATE units_i18n SET description = 'Resistant to magic. All attack damage on Golem is reduced by 1'
  WHERE name = 'Golem';

update dic_unit_phrases set phrase = 'Don''t worry, this knife is just for making salads'
where phrase = 'Don''t worry this knife is just for making salads';

insert into dic_unit_phrases(unit_id, language_id, phrase)
  select u.id, 1, 'Drive me closer, I want to hit them with my sword' from units u where u.ui_code = 'catapult';

insert into dic_unit_phrases(unit_id, language_id, phrase)
  select u.id, 1, 'Do you want a quick journey?' from units u where u.ui_code = 'catapult';

insert into dic_unit_phrases(unit_id, language_id, phrase)
  select u.id, 1, 'Croak Croak. What else did you expect?' from units u where u.ui_code = 'frog';

insert into dic_unit_phrases(unit_id, language_id, phrase)
  select u.id, 1, 'I have a bad feeling about this' from units u where u.ui_code = 'spearman';

insert into dic_unit_phrases(unit_id, language_id, phrase)
  select u.id, 1, 'Do you want to see some street magic?' from units u where u.ui_code = 'wizard';

insert into dic_unit_phrases(unit_id, language_id, phrase)
  select u.id, 1, 'Do you really think you can buy me?' from units u where u.ui_code = 'dragon';

insert into dic_unit_phrases(unit_id, language_id, phrase)
  select u.id, 1, 'Dragon is here. Just type "gg" and surrender' from units u where u.ui_code = 'dragon';

insert into dic_unit_phrases(unit_id, language_id, phrase)
  select u.id, 1, 'Do you know why a knight doesn''t have a horse? I stole it' from units u where u.ui_code = 'ninja';

insert into dic_unit_phrases(unit_id, language_id, phrase)
  select u.id, 1, 'Trolling time!' from units u where u.ui_code = 'troll';

insert into dic_unit_phrases(unit_id, language_id, phrase)
  select u.id, 1, 'Me smash' from units u where u.ui_code = 'golem';

