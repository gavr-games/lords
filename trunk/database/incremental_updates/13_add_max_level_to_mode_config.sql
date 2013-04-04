USE lords;

INSERT INTO mode_config (param, value, mode_id)
SELECT 'max_unit_level',3,id FROM modes;