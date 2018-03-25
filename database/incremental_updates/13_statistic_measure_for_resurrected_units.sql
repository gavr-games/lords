use lords;

INSERT INTO statistic_charts(tab_id, `type`, `name`) VALUES(5, 'bar', 'Воскрешенных юнитов');
SET @chart_id = LAST_INSERT_ID();

UPDATE dic_statistic_measures SET count_rule = 'SELECT COUNT(*) FROM statistic_game_actions sga JOIN cards c ON (sga.`value`=c.id) WHERE sga.game_id=$g_id AND sga.player_num=$p_num AND sga.`action`=''play_card'' AND c.`type`=''u'''
WHERE description = 'Призвал юнитов';

INSERT INTO dic_statistic_measures(description, count_rule) VALUES ('Воскрешенных юнитов','SELECT COUNT(*) FROM statistic_game_actions sga WHERE sga.game_id=$g_id AND sga.player_num=$p_num AND sga.`action`=''resurrect_unit''');
SET @measure_id = LAST_INSERT_ID();

INSERT INTO statistic_values_config(player_num, chart_id, measure_id, color, mode_id) VALUES(0, @chart_id, @measure_id, 'p0', 9);
INSERT INTO statistic_values_config(player_num, chart_id, measure_id, color, mode_id) VALUES(1, @chart_id, @measure_id, 'p1', 9);
INSERT INTO statistic_values_config(player_num, chart_id, measure_id, color, mode_id) VALUES(2, @chart_id, @measure_id, 'p2', 9);
INSERT INTO statistic_values_config(player_num, chart_id, measure_id, color, mode_id) VALUES(3, @chart_id, @measure_id, 'p3', 9);

