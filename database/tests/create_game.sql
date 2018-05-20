use lords_site;

call reset();
call lords.reset();

call arena_enter(1);
call arena_enter(2);
call arena_enter(3);
call arena_enter(4);

call arena_game_create(1,'test_game',null,0,9);

call arena_game_feature_set(1,1,1,1);
call arena_game_feature_set(1,1,4,1);

call arena_game_enter(1,1,null);
call arena_game_enter(2,1,null);
call arena_game_enter(3,1,null);
call arena_game_enter(4,1,null);

call arena_game_player_team_set(1,1,1,0);
call arena_game_player_team_set(1,1,2,0);
call arena_game_player_team_set(1,1,3,0);
call arena_game_player_team_set(1,1,4,0);

call arena_game_start(1,1);

use lords;