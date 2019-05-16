use lords;

insert into games_features(code, default_param, feature_type) values('realtime_cards', 1, 'bool');
set @f_id = LAST_INSERT_ID();

insert into games_features_i18n(feature_id, language_id, description) values
  (@f_id, 1, 'Realtime cards'),
  (@f_id, 2, 'Карты можно играть в любой ход');

