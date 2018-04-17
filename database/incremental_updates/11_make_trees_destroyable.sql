use lords;

update buildings set type = 'building', health = 2 where ui_code = 'tree';

insert into building_default_features(building_id, feature_id, param) values
    ((select id from buildings where ui_code = 'tree'),(select id from building_features where code = 'destroy_reward'), 0);

insert into building_default_features(building_id, feature_id) values
    ((select id from buildings where ui_code = 'tree'),(select id from building_features where code = 'not_interesting_for_npc'));


