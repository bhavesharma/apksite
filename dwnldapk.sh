source ./conn.com


cat /dev/null >.cache/gplaycli/token
rm -rf /home/ec2-user/download
#*********_________________Get b2 login Details________________#
_result1=`curl https://api.backblazeb2.com/b2api/v2/b2_authorize_account -u "d95fedb15b2c:002243855d10b41e2f389349948ae2243fba33332c"`
_Authorization=`echo $_result1 | grep -oP '(?<="authorizationToken": ")[^"]*'`
#echo $_Authorization

_result2=`curl \
    -H  "Authorization: "${_Authorization}"" \
    -d '{"bucketId": "8d4955ef7ebd8bd1751b021c"}' \
    https://api002.backblazeb2.com/b2api/v2/b2_get_upload_url`
_UPLOAD_URL=`echo $_result2 | grep -oP '(?<="uploadUrl": ")[^"]*'`
_UPLOAD_AUTHORIZATION_TOKEN=`echo $_result2 | grep -oP '(?<="authorizationToken": ")[^"]*'`


#***********______________Dwonload apk files________________
cat /dev/null > /tmp/appid.txt
logfile=dwnldapk.log
mysql --host=$_hostsrv --user=$_db_user --password=$_db_password apksite -e "select appid from apkdetails where b2apk = 'N'" >appid.txt

sed -i "1d" appid.txt

for  file in $(cat appid.txt)
do
#cat /dev/null >.cache/gplaycli/token
gplaycli -v -d $file d -f /home/ec2-user/download/

FILE_TO_UPLOAD=/home/ec2-user/download/${file}.apk
_FILE_NAME="${FILE_TO_UPLOAD##*/}"
MIME_TYPE=text/plain
SHA1_OF_FILE=$(openssl dgst -sha1 $FILE_TO_UPLOAD | awk '{print $2;}')
UPLOAD_AUTHORIZATION_TOKEN=$_UPLOAD_AUTHORIZATION_TOKEN

if [ -f "$FILE_TO_UPLOAD" ]; then
    echo "$FILE_TO_UPLOAD downloaded starting upload b2 now"

_result=`curl \
    -H "Authorization: $UPLOAD_AUTHORIZATION_TOKEN" \
    -H "X-Bz-File-Name: $_FILE_NAME" \
    -H "Content-Type: $MIME_TYPE" \
    -H "X-Bz-Content-Sha1: $SHA1_OF_FILE" \
    -H "X-Bz-Info-Author: apksite" \
    --data-binary "@$FILE_TO_UPLOAD" \
    $_UPLOAD_URL`
fi
echo $_result
_contentMd5=`echo $_result | grep -oP '(?<="contentMd5": ")[^"]*'`
_code=`echo $_result | grep -oP '(?<="code": ")[^"]*'`
echo $_contentMd5 "MD5"
echo $_code
if [ ! -z "$_contentMd5" ]
then
    mysql --host=$_hostsrv --user=$_db_user --password=$_db_password apksite -e " UPDATE apksite.apkdetails SET b2apk='Y',tobupdated='Y' WHERE appId='$file'"
    _contentMd5=""
    _result=""
elif [ ! -z "_code" ]
then	
      echo $_code
#     mysql --host=$_hostsrv --user=$_db_user --password=$_db_password apksite -e " UPDATE apksite.apkdetails SET b2apk='N' WHERE  appId='$file'"
else
echo " Problem while downloading/ uploading file please check "  	
fi

#mysql UPDATE apksite.apkdetails SET b2apk='Y' WHERE  appId=$file;

done
