#!/bin/bash

DUMP_DIR=/database/dump/
mkdir -p $DUMP_DIR
DUMP_FILE_NAME=${1:-dump_$(date +%Y%m%d%H%M%S).sql}
DUMP_PATH=$DUMP_DIR$DUMP_FILE_NAME

echo "Creating MySQL dump to $DUMP_PATH"
mysqldump -u root --password="$MYSQL_ROOT_PASSWORD" --add-drop-database --routines --events --dump-date --databases lords lords_site > "$DUMP_PATH"

