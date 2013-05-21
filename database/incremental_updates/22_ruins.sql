use lords;

insert into building_features(code, description) values('ruins','Руины замка');
SET @bf_id = @@last_insert_id;

insert into building_default_features(building_id, feature_id) values(8,@bf_id);
insert into building_default_features(building_id, feature_id) values(16,@bf_id);
