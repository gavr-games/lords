use lords;

delete from cards where code = 'russian_rul';

delete from procedures where name = 'cast_russian_ruletka';

DROP PROCEDURE IF EXISTS `cast_russian_ruletka`;

