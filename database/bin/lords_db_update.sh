#!/bin/bash

PATH_TO_SCRIPTS=/database

for entry in "$PATH_TO_SCRIPTS/incremental_updates"/*
do
    if [ "$entry" != "$PATH_TO_SCRIPTS/incremental_updates/00_baseline.sql" ]
    then
        echo Running $entry
        mysql < $entry -u root --password=$MYSQL_ROOT_PASSWORD --default-character-set=utf8
    fi
done

echo Running $PATH_TO_SCRIPTS/grants.sql
mysql < $PATH_TO_SCRIPTS/grants.sql -u root --password=$MYSQL_ROOT_PASSWORD --default-character-set=utf8

echo DB Update done.
