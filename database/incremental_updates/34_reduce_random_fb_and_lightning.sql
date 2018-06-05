use lords;

update cards_i18n set description = 'Causes 1 damage to a chosen unit'
where language_id = 1 and card_id = (select id from cards where code = 'fireball');

update cards_i18n set description = 'Наносит 1 ед. урона по выбранному юниту.'
where language_id = 2 and card_id = (select id from cards where code = 'fireball');

update cards_i18n set description = 'Causes 2 damage to units (weak lightning) or 3 damage with probability 2/3 (strong lightning)'
where language_id = 1 and card_id = (select id from cards where code = 'lightening');

update cards_i18n set description = 'Слабая молния наносит 2 ед. урона по юнитам. Сильная молния наносит 3 ед. урона с вероятностью 2/3.'
where language_id = 2 and card_id = (select id from cards where code = 'lightening');

