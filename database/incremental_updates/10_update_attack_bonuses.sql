use lords;

update attack_bonus set damage_bonus = 1, comment = 'Копейщик на конного +1' where comment = 'Копейщик критическим на конного +1';
update attack_bonus set damage_bonus = 2, comment = 'Рыцарь +2 против дракона' where comment = 'Рыцарь +2 критическим против дракона';
update attack_bonus set damage_bonus = 2, comment = 'Конный рыцарь +2 против дракона' where comment = 'Конный рыцарь +2 критическим против дракона';

update units_i18n set description = '+1 атаки против конного рыцаря' where description = 'При критическом ударе на конного рыцаря +1 атаки';
update units_i18n set description = '+2 атаки против дракона' where description = 'При критическом ударе дракона +2 атаки';

update units_i18n set description = '+1 damage against Chevalier' where description = '+1 damage on critical hit against Chevalier';
update units_i18n set description = '+2 damage against Dragon' where description = '+2 damage on critical hit against Dragon';

