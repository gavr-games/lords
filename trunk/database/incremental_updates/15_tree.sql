use lords;

insert into buildings(name,health,radius,x_len,y_len,shape,`type`,description,log_short_name,ui_code)
values('Дерево',0,0,1,1,'1','obstacle','Тис ягодный.','Дерево','tree');
SET @b_id = @@last_insert_id;

insert into building_features(code,description) values('for_initialization','Изначальный объект на доске');
SET @bf_id = @@last_insert_id;

insert into building_default_features(building_id,feature_id,param) values(@b_id,@bf_id,4);

insert into modes_cardless_buildings(mode_id,building_id) values(8,@b_id);