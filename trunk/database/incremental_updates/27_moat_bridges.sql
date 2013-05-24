use lords;

alter table buildings modify shape VARCHAR(400) ;

insert into buildings(name,health,radius,x_len,y_len,shape,`type`,description,log_short_name,ui_code)
values('Ров',0,0,8,8,'0011110000000000100000011000000110000001100000010000000000111100','obstacle','Окружает остров в середине карты.','Ров','moat');
SET @b_id = @@last_insert_id;

insert into modes_cardless_buildings(mode_id,building_id) values(9,@b_id);

insert into building_default_features(building_id,feature_id) values(@b_id,8); /*water*/
insert into building_default_features(building_id,feature_id) values(@b_id,12); /*not movable*/

insert into put_start_buildings_config(player_num,x,y,rotation,flip,building_id,mode_id) values(9,6,6,0,0,@b_id,9);


insert into buildings(name,health,radius,x_len,y_len,shape,`type`,description,log_short_name,ui_code)
values('Мост',10,0,2,2,'0110','building','Можно разрушить.','Мост','bridge');
SET @b_id = @@last_insert_id;

insert into modes_cardless_buildings(mode_id,building_id) values(9,@b_id);

insert into building_features(code,description) values('destroyable_bridge','Мост, который можно разрушить');
SET @bf_id = @@last_insert_id;

insert into building_default_features(building_id,feature_id) values(@b_id,@bf_id);
insert into building_default_features(building_id,feature_id) values(@b_id,12); /*not movable*/

insert into put_start_buildings_config(player_num,x,y,rotation,flip,building_id,mode_id) values(9,7,7,0,0,@b_id,9);
insert into put_start_buildings_config(player_num,x,y,rotation,flip,building_id,mode_id) values(9,11,7,1,0,@b_id,9);
insert into put_start_buildings_config(player_num,x,y,rotation,flip,building_id,mode_id) values(9,11,11,2,0,@b_id,9);
insert into put_start_buildings_config(player_num,x,y,rotation,flip,building_id,mode_id) values(9,7,11,3,0,@b_id,9);


insert into buildings(name,health,radius,x_len,y_len,shape,`type`,description,log_short_name,ui_code)
values('Руины моста',0,0,2,2,'1110','obstacle','Здесь когда-то стоял мост.','Руины','destroyed_bridge');
SET @b_id = @@last_insert_id;

insert into modes_cardless_buildings(mode_id,building_id) values(9,@b_id);

insert into building_features(code,description) values('destroyed_bridge','Разрушенный мост');
SET @bf_id = @@last_insert_id;

insert into building_default_features(building_id,feature_id) values(@b_id,@bf_id);
insert into building_default_features(building_id,feature_id) values(@b_id,8); /*water*/
insert into building_default_features(building_id,feature_id) values(@b_id,12); /*not movable*/
