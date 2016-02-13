#!/bin/bash

# from a comment on https://gist.github.com/jasny/1608062
# add zcat -f to allow use on gzipped automysqlbackup dump
# use basename of dump file as output dir
# and gzip back splitted files

####
# Split MySQL dump SQL file into one file per table
# based on http://blog.tty.nl/2011/12/28/splitting-a-database-dump
####

if [ $# -ne 1 ] ; then
  echo "USAGE $0 DUMP_FILE"
fi

base=$(basename $1 .gz | basename $(cat) .sql)
mkdir -p $base

zcat -f $1 | csplit -s -ftable - "/-- Table structure for table/" {*}
mv table00 head

for FILE in `ls -1 table*`; do
      NAME=`head -n1 $FILE | cut -d$'\x60' -f2`
      cat head $FILE | gzip > "$base/$NAME.sql.gz"
done

rm head table*
