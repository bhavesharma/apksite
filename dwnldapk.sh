source ./conn.com
cat /dev/null > /tmp/appid.txt

mysql --host=$_hostsrv --user=$_db_user --password=$_db_password apksite -e "select appid from apkdetails where b2apk = 'N'" >appid.txt

for  file in $(cat appid.txt)
do

gplaycli -v -d $file d -f /home/ec2-user/download/


sleep 0s
FILE_TO_UPLOAD=${file}.apk
MIME_TYPE=text/plain
SHA1_OF_FILE=$(openssl dgst -sha1 $FILE_TO_UPLOAD | awk '{print $2;}')
UPLOAD_URL=https://pod-000-1118-13.backblaze.com/b2api/v2/b2_upload_file/8d4955ef7ebd8bd1751b021c/c002_v0001118_t0042
UPLOAD_AUTHORIZATION_TOKEN=4_002d95fedb15b2c0000000000_01941e67_47fa98_upld_k3n0WLN8Buwv9HrNmVJoOIB4NOc=

#_result=`curl \
#    -H "Authorization: $UPLOAD_AUTHORIZATION_TOKEN" \
#    -H "X-Bz-File-Name: $FILE_TO_UPLOAD" \
#    -H "Content-Type: $MIME_TYPE" \
#    -H "X-Bz-Content-Sha1: $SHA1_OF_FILE" \
#    -H "X-Bz-Info-Author: apksite" \
#    --data-binary "@$FILE_TO_UPLOAD" \
#    $UPLOAD_URL`

#echo $_result
#if $result contains status 
#mysql UPDATE apksite.apkdetails SET b2apk='Y' WHERE  appId=$file;

mysql UPDATE apksite.apkdetails SET b2apk='Y' WHERE  appId=$file;

done
