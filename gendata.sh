#!/bin/bash

# show commands being executed, per debug
set -x

# define database connectivity
_hostsrv="15.206.170.123"
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

done
exit

