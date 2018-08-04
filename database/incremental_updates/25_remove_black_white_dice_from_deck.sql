use lords;

delete from modes_cards
where card_id in
(select id from cards where code in ('vred','polza'));

