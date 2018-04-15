use lords;

update cards set type = 'm' where type = 'e';

delete from dic_statistic_measures where description = 'Сыграл событий';

