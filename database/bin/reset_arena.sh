#!/bin/bash

echo "Resetting games and users"
mysql -u root --password="$MYSQL_ROOT_PASSWORD" --default-character-set=utf8 -e "call lords_site.soft_reset();"

