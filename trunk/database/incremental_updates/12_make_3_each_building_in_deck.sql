use lords;

update modes_cards set quantity = 3 where mode_id = 8
and card_id in
(select id from cards where `type` = 'b');