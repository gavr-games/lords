use lords;

insert into building_features(code,description) values('not_interesting_for_npc','NPC в здравом уме это не атакуют');
SET @bf = @@last_insert_id;

insert into building_default_features(building_id,feature_id) values(22,@bf);
