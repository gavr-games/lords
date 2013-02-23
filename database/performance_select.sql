select request_name,avg(js_time),avg(php_time),max(js_time),max(php_time),count(*)  from `lords_site`.`performance_statistics`
group by request_name
order by count(*) desc;