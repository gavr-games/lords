use lords_site;

alter table users add column `insert_timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;