use lords;

insert into buildings(name,health,radius,x_len,y_len,shape,`type`,description,log_short_name,ui_code)
values('Ров',0,0,4,4,'0001000100011110','obstacle','Можно защитить замок.','Ров','moat');
SET @b_id = @@last_insert_id;

insert into cards(image,cost,`type`,ref,name)
values('moat.png',0,'b',@b_id,'Ров');
SET @c_id = @@last_insert_id;

insert into modes_cards(mode_id,card_id,quantity)
values(8,@c_id,1);