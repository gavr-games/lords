use lords;

ALTER TABLE `statistic_game_actions` CHANGE `action` `action`
enum('change_gold'
,'initial_card'
,'buy_card'
,'play_card'
,'unit_attack'
,'magical_attack'
,'miss_attack'
,'critical_hit'
,'kill_unit'
,'destroy_building'
,'make_damage'
,'resurrect_unit'
,'unit_ability'
,'start_game'
,'end_game') NOT NULL;

