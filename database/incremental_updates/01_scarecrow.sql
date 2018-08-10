use lords;

insert into buildings(health, radius, x_len, y_len, shape, type, ui_code)
  values (1, 1, 1, 1, 1, 'building', 'scarecrow');
set @building_id = LAST_INSERT_ID();

insert into buildings_i18n(building_id, language_id, name, description) values
  (@building_id, 1, 'Scarecrow', 'Paralyses enemy units in its radius'),
  (@building_id, 2, 'Пугало', 'Парализует вражеских юнитов в своем радиусе');

insert into building_features (code) values('paralysing');
set @building_feature_id = LAST_INSERT_ID();

insert into building_features_i18n(feature_id, language_id, description) values
  (@building_feature_id, 1, 'Paralyses enemy units in its radius'),
  (@building_feature_id, 2, 'Парализует вражеских юнитов в своем радиусе');

insert into building_default_features(building_id, feature_id) values(@building_id, @building_feature_id);

insert into cards (image, cost, type, ref, code) values ('scarecrow.png', 0, 'b', @building_id, 'scarecrow');
set @card_id = LAST_INSERT_ID();

insert into cards_i18n(card_id, language_id, name) values
  (@card_id, 1, 'Scarecrow'),
  (@card_id, 2, 'Пугало');

insert into cards_procedures(card_id, procedure_id)
  values(@card_id, (select id from procedures where name = 'put_building'));

insert into modes_cards(mode_id, card_id, quantity) values(9, @card_id, 3);


