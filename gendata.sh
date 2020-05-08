#!/bin/bash

# show commands being executed, per debug
set -x

# define database connectivity
_hostsrv="15.206.160.146"
_db="apksite"
_db_user="admin"
_db_password="toor"

# define directory containing CSV files
_csv_directory="/tmp"
cd $_csv_directory
pwd

#### remove header value to be removed should be handle in upload script###
mysql -h $_hostsrv -u $_db_user -p$_db_password $_db << eof
DELETE FROM apksite.apkdetails WHERE  appId = "appId"
eof

######## Genrate output file on remote host#####
# mysql --host=$_hostsrv --user=$_db_user --password=$_db_password apksite -e "select appid from apkdetails   INTO OUTFILE  '/tmp/appid.csv'  FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';"

mysql --host=$_hostsrv --user=$_db_user --password=$_db_password apksite -e "select appid from apkdetails" >>/tmp/appid.txt


for  apps in $(cat /tmp/appid.txt)
  do

	  mysql --host=$_hostsrv --user=$_db_user --password=$_db_password apksite -e "select CONCAT_WS('\n',title,descriptionHTML) from apkdetails where appid ='$apps'  INTO OUTFILE  '/tmp/$apps.txt';"

#  _header_columns=`head -1 $_csv_directory/$_csv_file | tr ',' '\n' | sed 's/^"//' | sed 's/"$//' | sed 's/ /_/g'`
#  _header_columns_string=`head -1 $_csv_directory/$_csv_file | sed 's/ /_/g' | sed 's/"//g'`

  # ensure table exists
#  mysql -h $_hostsrv -u $_db_user -p$_db_password $_db << eof
#    CREATE TABLE IF NOT EXISTS \`$_table_name\` (
#      id int(11) NOT NULL auto_increment,
#      PRIMARY KEY  (id)
#    ) ENGINE=MyISAM DEFAULT CHARSET=latin1
#eof

  # loop through header columns
#  for _header in ${_header_columns[@]}
#  do

    # add column
#    mysql -h $_hostsrv -u $_db_user -p$_db_password $_db --execute="alter table \`$_table_name\` add column \`$_header\` text"

  done

  # import csv into mysql
#  mysqlimport --local --fields-enclosed-by='"' --fields-terminated-by=',' --lines-terminated-by="\n" --columns=$_header_columns_string -h $_hostsrv -u $_db_user -p$_db_password  $_db $_csv_directory/$_csv_file

#done
exit

