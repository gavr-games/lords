use lords;

insert into buildings(name,health,radius,x_len,y_len,shape,`type`,description,log_short_name,ui_code)
values('Крепостная Стена',100,0,4,4,'0001000100011111','building','Можно защитить замок.','Стена','wall_closed');
SET @b_id_closed = @@last_insert_id;

insert into buildings(name,health,radius,x_len,y_len,shape,`type`,description,log_short_name,ui_code)
values('Крепостная Стена',100,0,4,4,'0001000100001100','building','Можно защитить замок. Если закрыть ворота.','Стена','wall_opened');
SET @b_id_opened = @@last_insert_id;

insert into cards(image,cost,`type`,ref,name)
values('wall.png',0,'b',@b_id_closed,'Стена');
SET @c_id = @@last_insert_id;

insert into modes_cards(mode_id,card_id,quantity)
values(8,@c_id,1);

insert into cards_procedures(card_id,procedure_id) values(@c_id,6);

insert into modes_cardless_buildings(mode_id,building_id) values(8,@b_id_opened);

insert into building_features(code,description) values('wall_opened','Открытая стена');
SET @bf_id_opened = @@last_insert_id;

insert into building_features(code,description) values('wall_closed','Закрытая стена');
SET @bf_id_closed = @@last_insert_id;

insert into building_default_features(building_id,feature_id) values(@b_id_opened,@bf_id_opened);
insert into building_default_features(building_id,feature_id) values(@b_id_closed,@bf_id_closed);

insert into building_features(code,description) values('turn_when_changed','Номер хода, когда здание поменялось');

insert into procedures(name,params,ui_action_name) values('wall_open','building','wall_open');
SET @proc_open = @@last_insert_id;

insert into procedures(name,params,ui_action_name) values('wall_close','building','wall_close');
SET @proc_close = @@last_insert_id;

insert into buildings_procedures(building_id,procedure_id) values(@b_id_closed,@proc_open);
insert into buildings_procedures(building_id,procedure_id) values(@b_id_opened,@proc_close);

insert into error_dictionary(description) values('Это не ваше здание');
insert into error_dictionary(description) values('Здание заблокировано');
insert into error_dictionary(description) values('Здание это не умеет :-P');
insert into error_dictionary(description) values('Здание уже действовало в этот ход');
