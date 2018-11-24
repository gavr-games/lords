#!/bin/bash

echo "Creating DB users"
mysql -u root --password="$MYSQL_ROOT_PASSWORD" --default-character-set=utf8 -e "DROP USER 'lords_client'@'%', 'lords_reader'@'%';"
mysql -u root --password="$MYSQL_ROOT_PASSWORD" --default-character-set=utf8 -e "CREATE USER 'lords_client'@'%' IDENTIFIED BY '$MYSQL_CLIENT_PASSWORD';"
mysql -u root --password="$MYSQL_ROOT_PASSWORD" --default-character-set=utf8 -e "CREATE USER 'lords_reader'@'%' IDENTIFIED BY '$MYSQL_READER_PASSWORD';"

