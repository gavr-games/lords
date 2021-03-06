# re-create privileges
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'lords_client'@'%';
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'lords_reader'@'%';

# client
GRANT EXECUTE ON PROCEDURE `lords`.`player_end_turn` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`send_money` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`buy_card` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`take_subsidy` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`player_resurrect` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`put_building` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`cast_pooring` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`cast_riching` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`cast_half_money` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`summon_unit` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`cast_fireball` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`cast_lightening_min` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`cast_lightening_max` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`player_move_unit` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`attack` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`player_exit` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`agree_draw` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`disagree_draw` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`cast_paralich` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`cast_madness` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`cast_shield` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`cast_healing` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`cast_o_d` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`cast_teleport` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`cast_mind_control` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`cast_show_cards` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`cast_telekinesis` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`cast_speeding` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`cast_unit_upgrade_all` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`cast_unit_upgrade_random` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`cast_armageddon` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`cast_meteor_shower` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`cast_repair_buildings` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`cast_polza_main` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`cast_polza_resurrect` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`cast_polza_units_from_zone` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`cast_polza_move_building` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`cast_vred_main` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`cast_vred_pooring` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`cast_vred_kill_unit` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`cast_vred_destroy_building` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`cast_vred_move_building` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`taran_bind` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`wizard_heal` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`wizard_fireball` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`necromancer_resurrect` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`cast_vampire` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`necromancer_sacrifice` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`player_end_turn_by_timeout` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`get_unit_phrase` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`get_games_info` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`get_game_info` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`delete_game_data` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`unit_shoot` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`unit_level_up_attack` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`unit_level_up_health` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`unit_level_up_moves` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`wall_open` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`wall_close` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`cast_iron_skin` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`cast_horseshoe` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`cast_berserk` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`cast_demolition` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`cast_capture` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`cast_relocation` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`cast_zone_express_out` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`cast_zone_express_into` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`cast_forest` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`cast_bandit` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`cast_flight` TO 'lords_client'@'%';

# F5
GRANT EXECUTE ON PROCEDURE `lords`.`get_all_game_info` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`get_game_statistic` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords`.`get_all_game_info_ai` TO 'lords_client'@'%';

# lords_site
GRANT EXECUTE ON PROCEDURE `lords_site`.`user_add` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords_site`.`chat_user_add` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords_site`.`arena_game_feature_set` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords_site`.`arena_game_create` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords_site`.`arena_game_player_remove` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords_site`.`arena_enter` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords_site`.`arena_game_enter` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords_site`.`arena_exit` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords_site`.`arena_game_spectator_enter` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords_site`.`arena_game_player_spectator_move` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords_site`.`arena_game_player_team_set` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords_site`.`arena_game_start` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords_site`.`chat_topic_change` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords_site`.`chat_create_private` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords_site`.`chat_exit` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords_site`.`get_all_arena_info` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords_site`.`get_all_chat_info` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords_site`.`get_arena_games_info` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords_site`.`get_chat_users` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords_site`.`get_create_game_features` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords_site`.`get_create_game_modes` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords_site`.`get_current_game_info` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords_site`.`get_my_location` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords_site`.`user_get_pass_hash` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords_site`.`user_get_info` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords_site`.`player_online_offline` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords_site`.`performance_statistics_add` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords_site`.`user_profile_update` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords_site`.`get_my_profile` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords_site`.`get_user_profile` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords_site`.`user_language_change` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords_site`.`arena_game_bot_add` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords_site`.`arena_game_bot_remove` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords_site`.`get_all_arena_bots` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords_site`.`get_bots_for_game` TO 'lords_client'@'%';
GRANT EXECUTE ON PROCEDURE `lords_site`.`guest_user_add` TO 'lords_client'@'%';

GRANT SELECT ON lords.* TO 'lords_reader'@'%';
GRANT SELECT ON lords_site.* TO 'lords_reader'@'%';
