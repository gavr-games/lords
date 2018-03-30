#!/bin/bash

PATH_TO_SCRIPTS=/database
PATH_TO_BINS=/database/bin
MYSQL_ROOT_PASS=$MYSQL_ROOT_PASSWORD

$PATH_TO_BINS/create_users.sh

BASELINE_SCRIPT="$PATH_TO_SCRIPTS/incremental_updates/00_baseline.sql"
echo Running $BASELINE_SCRIPT
mysql < $BASELINE_SCRIPT -u root --password=$MYSQL_ROOT_PASS --default-character-set=utf8

$PATH_TO_BINS/lords_db_update.sh

echo DB initialization done.
