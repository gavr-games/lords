use lords;

update buildings set health = 30 where health = 100 and ui_code like 'wall%';

insert into building_default_features (building_id, feature_id)
  select id, building_feature_get_id_by_code('no_exp') from buildings where ui_code like 'wall%';


