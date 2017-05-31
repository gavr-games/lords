#!/bin/bash

PATH_TO_SCRIPTS=/database
MYSQL_ROOT_PASS=root

echo Running $PATH_TO_SCRIPTS/create_users.sql
mysql < $PATH_TO_SCRIPTS/create_users.sql -u root --password=$MYSQL_ROOT_PASS --default-character-set=utf8

for entry in "$PATH_TO_SCRIPTS/incremental_updates"/*
do
  echo Running $entry
  mysql < $entry -u root --password=$MYSQL_ROOT_PASS --default-character-set=utf8
done

echo Running $PATH_TO_SCRIPTS/grants.sql
mysql < $PATH_TO_SCRIPTS/grants.sql -u root --password=$MYSQL_ROOT_PASS --default-character-set=utf8

echo DONE.