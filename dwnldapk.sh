PATH=/home/ec2-user/.nvm/versions/node/v13.13.0/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/ec2-user/.local/bin:/home/ec2-user/bin
source ./conn.com

LOGFILE=$_log_dir/"dwnldapk_"$LOGFILE
echo "Success: Clearing cached Token" >>$LOGFILE
cat /dev/null >.cache/gplaycli/token
echo "Success: Cleaning old download files" >>$LOGFILE
rm -rf $_download_dir
mkdir -p $_download_dir
echo "Success: Initialinzing b2 login" >>$LOGFILE

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
echo "Message: Downloading appid in appid.txt file from DB" >>$LOGFILE
cat /dev/null > appid.txt
mysql --host=$_hostsrv --user=$_db_user --password=$_db_password $_db -e "select appid from apkdetails where b2apk = 'N' and genreId= '$1'" >appid.txt
echo "Success: appid.txt file created" >>$LOGFILE
sed -i "1d" appid.txt
echo "Message: Starting file download and upload to b2" >>$LOGFILE

for  file in $(cat appid.txt)
do
#cat /dev/null >.cache/gplaycli/token
gplaycli  -d $file -f $_download_dir

FILE_TO_UPLOAD=$_download_dir/${file}.apk
if [ -f "$FILE_TO_UPLOAD" ]; then

	_FILE_NAME="${FILE_TO_UPLOAD##*/}"
	MIME_TYPE=text/plain
	SHA1_OF_FILE=$(openssl dgst -sha1 $FILE_TO_UPLOAD | awk '{print $2;}')
	UPLOAD_AUTHORIZATION_TOKEN=$_UPLOAD_AUTHORIZATION_TOKEN

    	echo "$FILE_TO_UPLOAD downloaded starting upload b2 now"

_result=`curl \
    -H "Authorization: $UPLOAD_AUTHORIZATION_TOKEN" \
    -H "X-Bz-File-Name: $_FILE_NAME" \
    -H "Content-Type: $MIME_TYPE" \
    -H "X-Bz-Content-Sha1: $SHA1_OF_FILE" \
    -H "X-Bz-Info-Author: apksite" \
    --data-binary "@$FILE_TO_UPLOAD" \
    $_UPLOAD_URL`
else
    echo "Warning: Unable to download file $FILE_TO_UPLOAD" >>$LOGFILE
fi
#    echo $_result
_contentMd5=`echo $_result | grep -oP '(?<="contentMd5": ")[^"]*'`
_code=`echo $_result | grep -oP '(?<="code": ")[^"]*'`

if [ ! -z "$_contentMd5" ]
then
    mysql --host=$_hostsrv --user=$_db_user --password=$_db_password $_db -e " UPDATE apkfile.apkdetails SET b2apk='Y',tobupdated='Y',md5='$_contentMd5' WHERE appId='$file'"
    _contentMd5=""
    _result=""
    echo "Success: Apk file uploaded to b2" >>$LOGFILE
elif [ ! -z "_code" ]
then	
      echo $_code
#     mysql --host=$_hostsrv --user=$_db_user --password=$_db_password $_db -e " UPDATE apkfile.apkdetails SET b2apk='N' WHERE  appId='$file'"
else
echo "Error: Problem while downloading/uploading file please check " >>$LOGFILE
fi

done
