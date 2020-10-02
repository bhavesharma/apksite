#!/bin/bash
PATH=/home/ec2-user/.nvm/versions/node/v13.13.0/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/ec2-user/.local/bin:/home/ec2-user/bin
source con.com
# show commands being executed, per debug
#set -x
LOGFILE=$_log_dir/"gendata_"$LOGFILE
# define database connectivity
source ./conn.com
# define directory containing CSV files
#cd $_csv_directory
echo "REmoving extra header" >>$LOGFILE
#### remove header value to be removed should be handle in upload script###
mysql -h $_hostsrv -u $_db_user -p $_db_password $_db << eof
DELETE FROM $_db.apkdetails WHERE  appId = "appId"
eof


#_____________download app list which are not uploaded in B2 and wordpres
cat /dev/null > /tmp/appid.txt

mysql --host=$_hostsrv --user=$_db_user --password=$_db_password $_db -e "select appid from apkdetails where b2apk='Y' and tobupdated ='Y'" >>/tmp/appid.txt

sed -i "1d" /tmp/appid.txt

echo "Genrating text file" >>$LOGFILE
for  apps in $(cat /tmp/appid.txt)
  do

	  mysql --host=$_hostsrv --user=$_db_user --password=$_db_password $_db -e "select CONCAT_WS('\n',icon,version,size,updated,md5,androidVersionText,title,descriptionHTML) from apkdetails where appid ='$apps'  INTO OUTFILE '/data/$apps.txt';"

	  
	  mysql --host=$_hostsrv --user=$_db_user --password=$_db_password $_db -e "update apkdetails set tobupdated = 'N' where appid = '$apps'"
	  
done
echo "File genration completed" >>$LOGFILE
exit

