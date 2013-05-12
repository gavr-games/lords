use lords;

insert into buildings(name,health,radius,x_len,y_len,shape,`type`,description,log_short_name,ui_code)
values('Стена',0,0,4,4,'0001000100011110','obstacle','Можно защитить замок.','Стена','wall');
SET @b_id = @@last_insert_id;

insert into cards(image,cost,`type`,ref,name)
values('wall.png',0,'b',@b_id,'Стена');
SET @c_id = @@last_insert_id;

insert into modes_cards(mode_id,card_id,quantity)
values(8,@c_id,1);

insert into cards_procedures(card_id,procedure_id) values(@c_id,6);