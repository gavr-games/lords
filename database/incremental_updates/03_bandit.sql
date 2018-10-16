use lords;

ALTER TABLE dic_unit_phrases
ADD code varchar(45) NULL;

insert into units(moves, health, attack, ui_code) values(3, 3, 2, 'bandit');
set @unit_id = LAST_INSERT_ID();

insert into modes_cardless_units(mode_id, unit_id) values(9, @unit_id);

insert into units_i18n(unit_id, language_id, name, description, log_short_name, log_name_accusative) values
  (@unit_id, 1, 'Bandit', 'Will fight for whoever gives more money every turn', NULL, NULL),
  (@unit_id, 2, 'Бандит', 'Сражается за того, кто больше заплатит каждый ход', 'Бандит', 'Бандита');

call recreate_exp_table();

insert into units_procedures (unit_id, procedure_id, `default`) values
  (@unit_id, (select id from procedures where name = 'player_move_unit'), 1),
  (@unit_id, (select id from procedures where name = 'attack'), 0);

insert into cards (image, cost, type, ref, code) values ('bandit.png', 20, 'm', 0, 'bandit');
set @card_id = LAST_INSERT_ID();

insert into cards_i18n(card_id, language_id, name, description) values
  (@card_id, 1, 'Bandit', 'Summon an NPC bandit in your zone. He will fight for whoever gives more money every turn'),
  (@card_id, 2, 'Бандит', 'Призывает Бандита, который действует сам по себе и каждый ход сражается за того, кто больше заплатит.');

insert into procedures(name, params) values('cast_bandit', 'card,empty_coord_my_zone');
set @proc_id = LAST_INSERT_ID();

insert into cards_procedures(card_id, procedure_id) values(@card_id, @proc_id);

insert into modes_cards(mode_id, card_id, quantity) values(9, @card_id, 1);

insert into unit_features(code) values('bandit');
set @feature_id = LAST_INSERT_ID();

insert into unit_default_features(unit_id, feature_id) values(@unit_id, @feature_id);
insert into unit_features_i18n(feature_id, language_id, description) values
  (@feature_id, 1, 'Fights for money'),
  (@feature_id, 2, 'Сражается за деньги');

insert into unit_features(code) values('initial_team');

insert into unit_features(code) values('bandit_got_from_player0');
set @feature_id = LAST_INSERT_ID();
insert into unit_default_features(unit_id, feature_id, param) values(@unit_id, @feature_id, 0);

insert into unit_features(code) values('bandit_got_from_player1');
set @feature_id = LAST_INSERT_ID();
insert into unit_default_features(unit_id, feature_id, param) values(@unit_id, @feature_id, 0);

insert into unit_features(code) values('bandit_got_from_player2');
set @feature_id = LAST_INSERT_ID();
insert into unit_default_features(unit_id, feature_id, param) values(@unit_id, @feature_id, 0);

insert into unit_features(code) values('bandit_got_from_player3');
set @feature_id = LAST_INSERT_ID();
insert into unit_default_features(unit_id, feature_id, param) values(@unit_id, @feature_id, 0);

insert into log_message_text_i18n(code, language_id, message) values
  ('bandit_fights_for_player', 1, '{unit0} fights in the team of {player1}'),
  ('bandit_fights_for_player', 2, '{unit0} сражается в команде игрока {player1}');

insert into log_message_text_i18n(code, language_id, message) values
  ('bandit_fights_for_himself', 1, '{unit0} is on his own'),
  ('bandit_fights_for_himself', 2, '{unit0} сам за себя');

insert into log_message_text_i18n(code, language_id, message) values
  ('bandit_spends', 1, '{unit0} spends {gold1}'),
  ('bandit_spends', 2, '{unit0} тратит {gold1}');

insert into dic_unit_phrases(unit_id, language_id, phrase, code) values
  (@unit_id, 2, 'Благодарю, милорд', 'bandit_thanks'),
  (@unit_id, 2, 'Мой меч к вашим услугам', 'bandit_thanks'),
  (@unit_id, 2, 'За такие гроши мой меч не покинет ножен', 'bandit_not_enough'),
  (@unit_id, 2, 'Спасибо, но я надеялся на большее', 'bandit_not_enough'),
  (@unit_id, 1, 'Thanks, but no', 'bandit_not_enough'),
  (@unit_id, 1, 'You think you can bribe me with this amount?', 'bandit_not_enough'),
  (@unit_id, 1, 'I have greater needs', 'bandit_not_enough'),
  (@unit_id, 1, 'Thank you, but I was expecting more', 'bandit_not_enough'),
  (@unit_id, 1, 'I will consider your proposition', 'bandit_not_enough'),
  (@unit_id, 1, 'Thanks, my Lord', 'bandit_thanks'),
  (@unit_id, 1, 'Thank you, Sire', 'bandit_thanks'),
  (@unit_id, 1, 'Deal!', 'bandit_thanks'),
  (@unit_id, 1, 'My sword is yours', 'bandit_thanks'),
  (@unit_id, 1, 'You won''t regret the investment', 'bandit_thanks'),
  (@unit_id, 1, 'At your command', 'bandit_thanks');

update error_dictionary_i18n set description = 'Можно призвать этого юнита только в своей зоне' where error_id = 35 and language_id = 2;
update error_dictionary_i18n set description = 'You can only summon this unit in your own zone' where error_id = 35 and language_id = 1;

update error_dictionary set code = 'card_unit_not_in_own_zone' where id = 35;

