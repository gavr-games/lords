use lords;

ALTER TABLE `lords`.`modes_cards` ADD COLUMN `quantity` INTEGER UNSIGNED NOT NULL DEFAULT 0 AFTER `card_id`;

update
modes_cards m,
(select mode_id,card_id,count(*) as q from modes_cards group by mode_id,card_id) qq
set m.quantity = qq.q
where m.mode_id=qq.mode_id and m.card_id=qq.card_id;

CREATE TEMPORARY TABLE tmp_min_ids (id INT);

INSERT INTO tmp_min_ids
select min(id) from modes_cards group by mode_id,card_id;

delete from modes_cards
where id not in (select id from tmp_min_ids);

DROP TEMPORARY TABLE tmp_min_ids;