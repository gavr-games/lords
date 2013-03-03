USE lords_site;

call reset();
call lords.reset();

call user_authorize('1','1');

call arena_enter(1);
call arena_exit(1);

call arena_enter(1);
call arena_enter(2);
call arena_enter(3);
call arena_enter(4);
call arena_enter(5);
call arena_enter(6);

call player_online_offline(1,0);
call player_online_offline(1,1);

call chat_create_private(1,2);
call chat_user_add(2,3,1);
call chat_topic_change(1,1,'new topic');
call get_all_chat_info(1);
call get_chat_users(1,1);
call chat_exit(1,1);
call chat_exit(2,1);
call chat_exit(3,1);

call get_create_game_features(1);
call get_create_game_modes(1);

call arena_game_create(1,'test_game',null,0,1);

call arena_game_feature_set(1,1,1,1);
call arena_game_feature_set(1,1,4,1);
call arena_game_feature_set(1,1,3,3);

call arena_game_enter(1,1,null);
call arena_game_enter(2,1,null);
call arena_game_enter(3,1,null);
call arena_game_enter(4,1,null);

call player_online_offline(1,0);
call player_online_offline(1,1);

call arena_game_player_team_set(1,1,1,0);
call arena_game_player_team_set(1,1,2,0);

call arena_game_player_spectator_move(1,1,2);

call get_all_arena_info(1);
call get_arena_games_info(1);
call get_current_game_info(1);
call get_my_location(1);

call arena_game_player_remove(1,1,3);
call arena_game_player_remove(2,1,2);
call arena_game_player_remove(1,1,1);

call arena_game_create(1,'test_game',null,0,1);

call arena_game_feature_set(1,2,1,1);
call arena_game_feature_set(1,2,4,1);
call arena_game_feature_set(1,2,3,3);

call arena_game_enter(1,2,null);
call arena_game_enter(2,2,null);
call arena_game_enter(3,2,null);
call arena_game_enter(4,2,null);

call arena_game_player_team_set(1,2,1,0);
call arena_game_player_team_set(1,2,2,0);
call arena_game_player_team_set(1,2,3,0);
call arena_game_player_team_set(1,2,4,0);

call arena_game_enter(5,2,null);

call arena_game_start(1,2);

call arena_game_spectator_enter(6,2,null);

call player_online_offline(1,0);
call player_online_offline(1,1);

call lords.player_exit(2,0);