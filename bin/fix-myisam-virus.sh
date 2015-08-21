#!/bin/sh
DB_NAME="$1"
echo "This will destroy all data in $DB_NAME. Type yes to proceed:"
read answer
if [ ! "$answer" = "yes" ]; then
  exit
fi
echo proceeding
mysqldump $DB_NAME --no-data | sed 's/MyISAM/InnoDB/' > /tmp/schema
mysql -e "drop database $DB_NAME;"
mysql -e "create database $DB_NAME;"
cat /tmp/schema | mysql $DB_NAME
