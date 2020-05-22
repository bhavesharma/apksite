source ./conn.com
cat /dev/null > /tmp/appid.txt
logfile=dwnldapk.log
mysql --host=$_hostsrv --user=$_db_user --password=$_db_password apksite -e "select appid from apkdetails where b2apk = 'N'" >appid.txt

sed -i "1d" appid.txt

for  file in $(cat appid.txt)
do

gplaycli -v -d $file d -f /home/ec2-user/download/


#sleep 0s
FILE_TO_UPLOAD=/home/ec2-user/download/${file}.apk
#FILE_TO_UPLOAD=com.contextlogic.wish.apk
MIME_TYPE=text/plain
SHA1_OF_FILE=$(openssl dgst -sha1 $FILE_TO_UPLOAD | awk '{print $2;}')
UPLOAD_URL=https://pod-000-1138-05.backblaze.com/b2api/v2/b2_upload_file/8d4955ef7ebd8bd1751b021c/c002_v0001138_t0031
UPLOAD_AUTHORIZATION_TOKEN=4_002d95fedb15b2c0000000000_01944af7_1d6e07_upld_P8wMEIvg3b_qglBXgonkZzGLqg4=

_result=`curl \
    -H "Authorization: $UPLOAD_AUTHORIZATION_TOKEN" \
    -H "X-Bz-File-Name: $FILE_TO_UPLOAD" \
    -H "Content-Type: $MIME_TYPE" \
    -H "X-Bz-Content-Sha1: $SHA1_OF_FILE" \
    -H "X-Bz-Info-Author: apksite" \
    --data-binary "@$FILE_TO_UPLOAD" \
    $UPLOAD_URL`

#echo $_result
_contentMd5=`echo $_result | grep -oP '(?<="contentMd5": ")[^"]*'`
_code=`echo $_result | grep -oP '(?<="code": ")[^"]*'`


if [ ! -z "$_contentMd5" ]
then
    mysql --host=$_hostsrv --user=$_db_user --password=$_db_password apksite -e " UPDATE apksite.apkdetails SET b2apk='Y',tobupdated='Y' WHERE appId='$file'"
elif [ ! -z "_code" ]
then	
      echo $_code
#     mysql --host=$_hostsrv --user=$_db_user --password=$_db_password apksite -e " UPDATE apksite.apkdetails SET b2apk='N' WHERE  appId='$file'"
else
echo " problem check "  	
fi


#mysql UPDATE apksite.apkdetails SET b2apk='Y' WHERE  appId=$file;

done
