_result1=`curl https://api.backblazeb2.com/b2api/v2/b2_authorize_account -u "d95fedb15b2c:002243855d10b41e2f389349948ae2243fba33332c"`
_Authorization=`echo $_result1 | grep -oP '(?<="authorizationToken": ")[^"]*'`
#echo $_Authorization

_result2=`curl \
    -H  "Authorization: "${_Authorization}"" \
    -d '{"bucketId": "8d4955ef7ebd8bd1751b021c"}' \
    https://api002.backblazeb2.com/b2api/v2/b2_get_upload_url`
_UPLOAD_URL=`echo $_result2 | grep -oP '(?<="uploadUrl": ")[^"]*'`
_UPLOAD_AUTHORIZATION_TOKEN=`echo $_result2 | grep -oP '(?<="authorizationToken": ")[^"]*'`

FILE_TO_UPLOAD=list.txt
MIME_TYPE=text/plain
SHA1_OF_FILE=$(openssl dgst -sha1 $FILE_TO_UPLOAD | awk '{print $2;}')
UPLOAD_URL=$_UPLOAD_URL
UPLOAD_AUTHORIZATION_TOKEN=$_UPLOAD_AUTHORIZATION_TOKEN


curl \
    -H "Authorization: $UPLOAD_AUTHORIZATION_TOKEN" \
    -H "X-Bz-File-Name: $FILE_TO_UPLOAD" \
    -H "Content-Type: $MIME_TYPE" \
    -H "X-Bz-Content-Sha1: $SHA1_OF_FILE" \
    -H "X-Bz-Info-Author: unknown" \
    --data-binary "@$FILE_TO_UPLOAD" \
    $UPLOAD_URL

_contentMd5=`echo $_result | grep -oP '(?<="contentMd5": ")[^"]*'`
_code=`echo $_result | grep -oP '(?<="code": ")[^"]*'`

