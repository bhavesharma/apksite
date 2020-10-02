# get a list of .txt files in directory
_postdir=/data
_category=$1
_today=$(date +"%Y-%m-%d %T")
_txt_files=`ls -1 /data/$_category/*.txt`
cd /home/runcloud/webapps/test
echo "process started" >log.txt

# loop through csv files
for _txt_file in ${_txt_files[@]}
do

sed -i '1,6 s/.$//' $_txt_file
_iconurl=`head -1 $_txt_file`
_onlyfname=`basename -s .txt $_txt_file`
_version=`sed -n '2p' $_txt_file`
_size=`sed -n '3p' $_txt_file`
_updatedon=`sed -n '4p' $_txt_file`
_md5=`sed -n '5p' $_txt_file`
_requirment=`sed -n '6p' $_txt_file`
_updatedon=`date -d @$((_updatedon/1000)) +'%Y-%m-%d'`
echo $_version $_size $_updatedon $_md5 $_requirment


wget $_iconurl -O $_txt_file.png

#_______________remove header from file_____________
sed -i '1,6d' $_txt_file

#_______________remove "/" from first line__________
sed -i '1 s/.$//' $_txt_file
echo $_txt_file
_title=`head -1 $_txt_file`
echo $_title
echo '<a href="https://f002.backblazeb2.com/file/apksite/'$_onlyfname.apk'"><img class="aligncenter" src="http://digitalvidia.com/wp-content/uploads/2020/07/dwnlod.png" alt="Google Sites" border="0" /> </a>' >>$_txt_file

echo '<figure class="wp-block-table"><table><tbody><tr><td><strong>Latest Version:</strong> '$_version'</td><td><strong>File Size: </strong> '$_size '</td></tr><tr><td> <strong>Last Updated: </strong> '$_updatedon'</td><td><strong>MD5</strong> : '$_md5 '</td></tr><tr><td><strong><a href="https://play.google.com/store/apps/details?id='$_onlyfname'"><img src="http://digitalvidia.com/wp-content/uploads/2020/08/google-play-badge-e1597665391807.png" alt=GPlay width="120" height="40" /> </a></strong></td><td>
<strong>Requirement</strong>: '$_requirment'</td></tr></tbody></table></figure>' >>$_txt_file

_result=`wp post create "$_txt_file" --post_type=post --post_status=publish --post_title="$_title"  --post_category="$_category" --tags_input=$_category`
echo $_result
_post_id=`echo $_result | sed 's/[^0-9]*//g'`
echo $_post_id
_import=`wp media import $_txt_file.png --post_id=$_post_id --title="$_tile" --featured_image`
_media_id=`echo $_import | sed 's/and attached.*//'|sed 's/.*attachment ID //'`
#echo "printing full result" >>log.txt
#echo $_import
#echo "now printing _media_id"
#echo $_media_id
echo $_post_id,$_media_id,"$_onlyfname",$_today >>apklogs.csv

rm $_txt_file.png $_txt_file
done
echo "Process finished" >>log.txt

mysqlimport --local --fields-enclosed-by='"' --fields-terminated-by=',' --lines-terminated-by="\n" --columns=post_id,media_id,app_id,p_date -h localhost -ubhawesh -pZ?P@2xJ=Z6  apkfile apklogs.csv

cat /dev/null >apklogs.csv
