use lords;

insert into unit_features(code, log_key_add) values('flying', 'unit_flying');
set @feature_id = LAST_INSERT_ID();

insert into unit_features_i18n(feature_id, language_id, description) values
  (@feature_id, 1, 'Can fly over obstacles'),
  (@feature_id, 2, 'Может перелетать препятствия');

set @dragon_id = (select id from units where ui_code='dragon');

insert into unit_default_features(unit_id, feature_id)
  values(@dragon_id, @feature_id);

update units_i18n set description = 'Атакует несколько целей рядом одновременно, может перелетать препятствия'
  where unit_id = @dragon_id and language_id = 2;

update units_i18n set description = 'Attacks multiple targets simultaneously, can fly over obstacles'
  where unit_id = @dragon_id and language_id = 1;

insert into log_message_text_i18n(code, language_id, message) values
  ('unit_flying', 1, '{unit0} can fly'),
  ('unit_flying', 2, '{unit0} может летать');

