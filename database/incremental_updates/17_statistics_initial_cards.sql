use lords;

insert into dic_statistic_measures(description, count_rule) values ('Initial cards', 'SELECT sga.value as value FROM statistic_game_actions sga WHERE sga.game_id=$g_id AND sga.player_num=$p_num AND sga.`action`=''initial_card''');
SET @measure_id = LAST_INSERT_ID();

insert into statistic_charts(tab_id, type, name) values ((select id from statistic_tabs where name = '{cards_tab}'), 'cardlist', '{initial_cards_chart}');
SET @chart_p0 = LAST_INSERT_ID();
insert into statistic_charts(tab_id, type, name) values ((select id from statistic_tabs where name = '{cards_tab}'), 'cardlist', '{initial_cards_chart}');
SET @chart_p1 = LAST_INSERT_ID();
insert into statistic_charts(tab_id, type, name) values ((select id from statistic_tabs where name = '{cards_tab}'), 'cardlist', '{initial_cards_chart}');
SET @chart_p2 = LAST_INSERT_ID();
insert into statistic_charts(tab_id, type, name) values ((select id from statistic_tabs where name = '{cards_tab}'), 'cardlist', '{initial_cards_chart}');
SET @chart_p3 = LAST_INSERT_ID();

INSERT INTO statistics_i18n(language_id, code, text) VALUES 
(1, '{initial_cards_chart}', 'Initial cards of {player_name}'),
(2, '{initial_cards_chart}', 'Начальные карты игрока {player_name}');

insert into statistic_values_config(player_num, chart_id, measure_id, color, name, mode_id)
values (0, @chart_p0, @measure_id, 'card_color', 'card_name', 9);
insert into statistic_values_config(player_num, chart_id, measure_id, color, name, mode_id)
values (1, @chart_p1, @measure_id, 'card_color', 'card_name', 9);
insert into statistic_values_config(player_num, chart_id, measure_id, color, name, mode_id)
values (2, @chart_p2, @measure_id, 'card_color', 'card_name', 9);
insert into statistic_values_config(player_num, chart_id, measure_id, color, name, mode_id)
values (3, @chart_p3, @measure_id, 'card_color', 'card_name', 9);

