use lords;

alter table players add column language_id int(10) unsigned NOT NULL default 1;
alter table players alter column language_id drop default;

