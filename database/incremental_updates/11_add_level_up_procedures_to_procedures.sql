use lords;

INSERT INTO procedures(name,params) VALUES('unit_level_up_attack','unit');
SET @lastid = @@last_insert_id;

INSERT INTO modes_other_procedures(mode_id, procedure_id)
SELECT DISTINCT mode_id,@lastid FROM modes_other_procedures;

INSERT INTO procedures(name,params) VALUES('unit_level_up_health','unit');
SET @lastid = @@last_insert_id;

INSERT INTO modes_other_procedures(mode_id, procedure_id)
SELECT DISTINCT mode_id,@lastid FROM modes_other_procedures;

INSERT INTO procedures(name,params) VALUES('unit_level_up_moves','unit');
SET @lastid = @@last_insert_id;

INSERT INTO modes_other_procedures(mode_id, procedure_id)
SELECT DISTINCT mode_id,@lastid FROM modes_other_procedures;
