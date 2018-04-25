#!/bin/bash

# script for dumping all db objects into a folder structure for easier modifications
# Based on https://gist.github.com/faceleg/5572627 by faceleg

# MySQL executables
MYSQL="mysql"
MYSQLDUMP="mysqldump"

# Remove dump directory if it exists
DUMP_DIR="database/dump"
if [ -d $DUMP_DIR ]; then
    echo "Removing $DUMP_DIR"
    rm -r $DUMP_DIR
fi

mkdir $DUMP_DIR

USERNAME="root"
PASSWORD="root"
HOST="localhost"

# Do not dump config databases
IGNORE_DBS="^test|information_schema|mysql|phpmyadmin|performance_schema$"

# Obtain a list of databases
DBS="$($MYSQL -u$USERNAME -p$PASSWORD -h$HOST -Bse 'show databases')"

for DB in $DBS
        do

        # Do not dump IGNORE_DBS
        [[ "$DB" =~ $IGNORE_DBS ]] && continue
        
        TABLES_DIR="$DUMP_DIR/$DB/tables"
        ROUTINES_DIR="$DUMP_DIR/$DB/routines"

        if [ ! -d "$DUMP_DIR/$DB" ]; then
                mkdir "$DUMP_DIR/$DB"
                mkdir "$TABLES_DIR"
                mkdir "$ROUTINES_DIR"
        fi

        for TABLE in $($MYSQL -u$USERNAME -p$PASSWORD -h$HOST $DB -e 'show tables' | egrep -v 'Tables_in_' ); do
                FILE="$TABLES_DIR/$TABLE.sql"
                echo "Dumping table $DB.$TABLE"
                $MYSQLDUMP -u$USERNAME -p$PASSWORD -h$HOST --opt -Q $DB $TABLE > $FILE
        done

        if [ "$TABLE" = "" ]; then
                echo "No tables found in db: $DB"
        fi

        for ROUTINE in $($MYSQL -u$USERNAME -p$PASSWORD -h$HOST -Bse "SELECT ROUTINE_NAME FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA = '$DB'"); do
                FILE="$ROUTINES_DIR/$ROUTINE.sql"
                echo "Dumping routine $DB.$ROUTINE"
                echo "use $DB;" >> $FILE
                echo "" >> $FILE
                echo 'DELIMITER $$' >> $FILE
                echo "" >> $FILE
                $MYSQL -u$USERNAME -p$PASSWORD -h$HOST -Bse "SELECT CONCAT('DROP ', ROUTINE_TYPE, ' IF EXISTS \`', ROUTINE_SCHEMA, '\`.\`', ROUTINE_NAME, '\` \$\$') FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA = '$DB' AND ROUTINE_NAME = '$ROUTINE'" >> $FILE
                echo "" >> $FILE
                $MYSQL -u$USERNAME -p$PASSWORD -h$HOST -Bse "SELECT CONCAT('CREATE ', type, ' \`', name, '\`(', REPLACE(param_list, ',', ', '), ')', case when returns != '' then CONCAT(' RETURNS ', returns) else '' end, CHAR(13), case when is_deterministic = 'YES' then CONCAT('DETERMINISTIC', CHAR(13)) else '' end, body, '\$\$', CHAR(13)) FROM mysql.proc WHERE db='$DB' and name='$ROUTINE'" | sed 's/\\n/\n/g' >> $FILE
                echo "" >> $FILE
        done

done
