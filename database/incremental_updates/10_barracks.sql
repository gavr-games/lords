use lords;

insert into buildings(name,health,radius,x_len,y_len,shape,`type`,description,log_short_name,ui_code)
values('Казарма',3,1,1,1,'1','building','Появляются два союзных копейщика-NPC. Потом иногда появляются еще копейщики.','Казарма','barracks');
SET @b_id = @@last_insert_id;

insert into cards(image,cost,`type`,ref,name)
values('barracks.png',0,'b',@b_id,'Казарма');
SET @c_id = @@last_insert_id;

insert into modes_cards(mode_id,card_id,quantity)
values(8,@c_id,1);

insert into cards_procedures(card_id,procedure_id) values(@c_id,6);

insert into building_features(code,description) values('ally','Плодит союзников');
SET @bf_id = @@last_insert_id;

insert into building_features(code,description) values('barracks','Казарма');
SET @bf2_id = @@last_insert_id;

insert into building_default_features(building_id,feature_id) values(@b_id,@bf_id);
insert into building_default_features(building_id,feature_id) values(@b_id,@bf2_id);

insert into summon_cfg(player_name,building_id,unit_id,`count`,owner,mode_id)
values('Копейщик',@b_id,14,2,4,8);