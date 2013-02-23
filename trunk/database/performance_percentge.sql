select request_name,avg(js_time),avg(php_time),max(js_time),max(php_time),round(avg(php_time)/avg(js_time)*100),count(*)  from `lords_site`.`performance_statistics`
#where request_name='player_move_unit'
#where request_name='player_move_unit'