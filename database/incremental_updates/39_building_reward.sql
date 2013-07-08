use lords;

insert into building_features(code,description) values('destroy_reward','За разрушение здания игрок получает награду в определенном размере');
SET @bf = @@last_insert_id;

insert into building_default_features(building_id,feature_id,param) values(22,@bf,30);
