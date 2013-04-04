DROP VIEW IF EXISTS vw_mode_unit_level_up_experience;
CREATE VIEW vw_mode_unit_level_up_experience AS 
select
	u.mode_id,
	e.unit_id,
	e.level,
	e.experience
from vw_mode_units u
join unit_level_up_experience e on (u.id = e.unit_id);
