use lords;

insert into building_features(code) values ('no_exp');

insert into building_features_i18n(feature_id, language_id, description) values (
    (select id from building_features where code = 'no_exp'),
    2, 'Не приносит опыта');

insert into building_features_i18n(feature_id, language_id, description) values (
    (select id from building_features where code = 'no_exp'),
    1, 'Gives no experience');

insert into building_default_features(building_id, feature_id) values
    ((select id from buildings where ui_code = 'tree'),(select id from building_features where code = 'no_exp'));
insert into building_default_features(building_id, feature_id) values
    ((select id from buildings where ui_code = 'bridge'),(select id from building_features where code = 'no_exp'));

