use lords;

update cards_i18n set description = 'Починка всех своих зданий (кроме Замка).'
where description = 'Починка всех своих зданий включая Замок.';

update cards_i18n set description = 'Repair all your buildings (except the castle)'
where description = 'Repair all your buildings including the castle';

