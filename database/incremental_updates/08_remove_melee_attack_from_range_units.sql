use lords;

delete from units_procedures
where procedure_id = (select id from procedures where name = 'attack')
and unit_id in (select id from units where ui_code in ('archer', 'arbalester', 'catapult'));

