use lords;

insert into dic_unit_phrases(unit_id, language_id, phrase) values
  ((select id from units where ui_code = 'knight_on_foot'), 1, 'Ni!');

