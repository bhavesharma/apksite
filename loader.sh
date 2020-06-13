#!/bin/bash

# show commands being executed, per debug
set -x

# define database connectivity
source ./conn.com

# go into directory
cd $_csv_directory

# get a list of CSV files in directory
_csv_files=`ls -1 *.csv`

# loop through csv files
for _csv_file in ${_csv_files[@]}
do

  # remove file extension
  _csv_file_extensionless=`echo $_csv_file | sed 's/\(.*\)\..*/\1/'`

  # define table name
  _table_name="${_csv_file_extensionless}"

  # get header columns from CSV file
  _header_columns=`head -1 $_csv_directory/$_csv_file | tr ',' '\n' | sed 's/^"//' | sed 's/"$//' | sed 's/ /_/g'`
  _header_columns_string=`head -1 $_csv_directory/$_csv_file | sed 's/ /_/g' | sed 's/"//g'`

sed -i '1d' $_csv_file #>${_csv_file}.tmp
#mv ${_csv_file}.tmp $_csv_file
  # ensure table exists
#  mysql -h $_hostsrv -u $_db_user -p$_db_password $_db << eof
#    CREATE TABLE IF NOT EXISTS \`$_table_name\` (
#      id int(11) NOT NULL auto_increment,
#      PRIMARY KEY  (id)
#    ) ENGINE=MyISAM DEFAULT CHARSET=latin1
#eof



#Empty staging table before loading
mysql --host=$_hostsrv --user=$_db_user --password=$_db_password apksite -e "TRUNCATE TABLE $_table_name ;"

echo $?

  # import csv into mysql
  mysqlimport --local --fields-enclosed-by='"' --fields-terminated-by=',' --lines-terminated-by="\n" --columns=$_header_columns_string -h $_hostsrv -u $_db_user -p$_db_password  $_db $_csv_directory/$_csv_file


mysql --host=$_hostsrv --user=$_db_user --password=$_db_password apksite -e "INSERT ignore INTO apkdetails SELECT *,'N','Y' FROM stg_apkdetails WHERE stg_apkdetails.appid NOT IN (SELECT apkdetails.appid FROM apkdetails )"

done
exit

