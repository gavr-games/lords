use lords;

insert into error_dictionary(code) values ('invalid_target_for_this_unit');
SET @err_id = LAST_INSERT_ID();
insert into error_dictionary_i18n(error_id, language_id, description) values
(@err_id, 1, 'Invalid target for this unit'),
(@err_id, 2, 'Юнит не может в это стрелять');

insert into error_dictionary(code) values ('target_too_close');
SET @err_id = LAST_INSERT_ID();
insert into error_dictionary_i18n(error_id, language_id, description) values
(@err_id, 1, 'Target is too close'),
(@err_id, 2, 'Цель слишком близко');

insert into error_dictionary(code) values ('target_too_far');
SET @err_id = LAST_INSERT_ID();
insert into error_dictionary_i18n(error_id, language_id, description) values
(@err_id, 1, 'Target is too far'),
(@err_id, 2, 'Цель слишком далеко');

DELETE FROM procedures WHERE name IN ('arbalester_shoot', 'archer_shoot', 'catapult_shoot');
INSERT INTO `procedures` (`name`, `params`, `ui_action_name`) VALUES ('unit_shoot','unit,shoot_target','shoot');
SET @procedure_id = LAST_INSERT_ID();

insert into units_procedures(unit_id, procedure_id, `default`) values
((SELECT id from units where ui_code='archer'), @procedure_id, 0),
((SELECT id from units where ui_code='arbalester'), @procedure_id, 0),
((SELECT id from units where ui_code='catapult'), @procedure_id, 0);

ALTER TABLE procedures_params_i18n ADD CONSTRAINT procedures_params_i18n_params_fk FOREIGN KEY (param_id) REFERENCES procedures_params(id) ON DELETE CASCADE;
delete from procedures_params where code in ('target_unit_in_distance_2_4', 'target_building_in_distance_2_5');

insert into procedures_params (code) values('shoot_target');
SET @param_id = LAST_INSERT_ID();
insert into procedures_params_i18n(param_id, language_id, description) values
(@param_id, 1, 'Pick a target'),
(@param_id, 2, 'Выберите цель');

