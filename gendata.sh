#!/bin/bash

# show commands being executed, per debug
set -x

# define database connectivity
_hostsrv="13.234.217.189"
_db="apksite"
_db_user="admin"
_db_password="toor"
source ./conn.com
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

cat /dev/null > /tmp/appid.txt

mysql --host=$_hostsrv --user=$_db_user --password=$_db_password apksite -e "select appid from apkdetails where b2apk='Y' and tobupdated ='Y'" >>/tmp/appid.txt

sed -i "1d" appid.txt


for  apps in $(cat /tmp/appid.txt)
  do

	  mysql --host=$_hostsrv --user=$_db_user --password=$_db_password apksite -e "select CONCAT_WS('\n',icon,title,descriptionHTML) from apkdetails where appid ='$apps'  INTO OUTFILE '/tmp/$apps.txt';"

	  
	  mysql --host=$_hostsrv --user=$_db_user --password=$_db_password apksite -e "update apkdetails set tobupdated = 'N' where appid = '$apps'"
	  
echo $?
done
exit

