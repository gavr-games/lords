use lords;

update attack_bonus set chance = 7
    where aim_id = (select id from units where ui_code = 'ninja');

