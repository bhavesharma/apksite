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

sed -i '1,9 s/.$//' $_txt_file
_iconurl=`head -1 $_txt_file`
_onlyfname=`basename -s .txt $_txt_file`
_version=`sed -n '2p' $_txt_file`
_size=`sed -n '3p' $_txt_file`
_updatedon=`sed -n '4p' $_txt_file`
_md5=`sed -n '5p' $_txt_file`
_requirment=`sed -n '6p' $_txt_file`
_rating=`sed -n '7p' $_txt_file`
_screenshots=`sed -n '8p' $_txt_file`
_screenshots=`echo $_screenshots | sed  's/\[//g' | sed  's/\]//g' | sed  's/\,/  /g' | sed 's/\"//g' | sed "s/\'//g"`
_screenshotsn=($_screenshots)
_video=`sed -n '9p' $_txt_file`
_updatedon=`date -d @$((_updatedon/1000)) +'%Y-%m-%d'`
echo $_version $_size $_updatedon $_md5 $_requirment


wget $_iconurl -O $_txt_file.png

#_______________remove header from file_____________
sed -i '1,9d' $_txt_file

#_______________remove "/" from first line__________
sed -i '1 s/.$//' $_txt_file
echo $_txt_file
_title=`head -1 $_txt_file`
echo $_title
#echo '<a href="https://f002.backblazeb2.com/file/apksite/'$_onlyfname.apk'"><img class="aligncenter" src="http://digitalvidia.com/wp-content/uploads/2020/07/dwnlod.png" alt="Google Sites" border="0" /> </a>' >>$_txt_file
#echo '<figure class="wp-block-table"><table><tbody><tr><td><strong>Latest Version:</strong> '$_version'</td><td><strong>File Size: </strong> '$_size '</td></tr><tr><td> <strong>Last Updated: </strong> '$_updatedon'</td><td><strong>MD5</strong> : '$_md5 '</td></tr><tr><td><strong><a href="https://play.google.com/store/apps/details?id='$_onlyfname'"><img src="http://digitalvidia.com/wp-content/uploads/2020/08/google-play-badge-e1597665391807.png" alt=GPlay width="120" height="40" /> </a></strong></td><td>
#<strong>Requirement</strong>: '$_requirment'</td></tr></tbody></table></figure>' >>$_txt_file

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
_custtemp1='a:1:{i:0;a:2:{s:5:"title";s:3:"MD5";s:7:"content";s:39:"<p>'
_custtemp2='</p>";}}'
_custfmd5=`echo $_custtemp1$_md5$_custtemp2`
mysql --host=localhost --user=bhawesh --password=Z?P@2xJ=Z6 apkfile -e "INSERT INTO apkfile.wp_postmeta (post_id,meta_key,meta_value) VALUES ($_post_id,'custom_boxes','$_custfmd5')"
dato_temp1_0='a:10:{s:11:"descripcion";s:0:"";s:7:"version";s:'
_lenversion=${#_version}
dato_temp1_1=$_lenversion':"'
dato_temp1=$dato_temp1_0$dato_temp1_1

dato_temp2_0='";s:6:"tamano";s:'
_lensize=${#_size}
dato_temp2_1=$_lensize':"'
dato_temp2=$dato_temp2_0$dato_temp2_1$_size

dato_temp3='";s:19:"fecha_actualizacion";s:10:"'

dato_temp4='";s:14:"requerimientos";s:10:"'

dato_temp5_0='";s:10:"consiguelo";s:'
dato_temp5_1=`expr 46 + ${#_onlyfname}`':"https://play.google.com/store/apps/details?id='
dato_temp5=$dato_temp5_0$dato_temp5_1

dato_temp6='";s:13:"categoria_app";s:15:"GameApplication";s:2:"os";s:7:"ANDROID";s:5:"offer";a:3:{s:5:"price";s:6:"gratis";s:6:"amount";s:0:"";s:8:"currency";s:3:"USD";}s:9:"novedades";s:0:"";}'
_datos_informacion=`echo $dato_temp1$_version$dato_temp2$dato_temp3$_updatedon$dato_temp4$_requirment$dato_temp5$_onlyfname$dato_temp6`

mysql --host=localhost --user=bhawesh --password=Z?P@2xJ=Z6 apkfile -e "INSERT INTO apkfile.wp_postmeta (post_id,meta_key,meta_value) VALUES ($_post_id,'datos_informacion','$_datos_informacion')"

########addding Download links#########

datos_d1='a:6:{s:6:"option";s:5:"links";i:0;a:2:{s:4:"link";s:'
datos_d2=`expr 46 + ${#_onlyfname}`':"https://f002.backblazeb2.com/file/apksite/'$_onlyfname'.apk'
datos_d3='";s:5:"texto";s:12:"Download APK";}i:1;a:2:{s:4:"link";s:0:"";s:5:"texto";s:0:"";}i:2;a:2:{s:4:"link";s:0:"";s:5:"texto";s:0:"";}s:11:"direct-link";s:0:"";s:15:"direct-download";s:0:"";}'
_datos_download=$datos_d1$datos_d2$datos_d3
mysql --host=localhost --user=bhawesh --password=Z?P@2xJ=Z6 apkfile -e "INSERT INTO apkfile.wp_postmeta (post_id,meta_key,meta_value) VALUES ($_post_id,'datos_download','$_datos_download')"
echo $_rating
mysql --host=localhost --user=bhawesh --password=Z?P@2xJ=Z6 apkfile -e "INSERT INTO apkfile.wp_postmeta (post_id,meta_key,meta_value) VALUES ($_post_id,'new_rating_average','$_rating')"

#*************************Add Screenshots***********************
_onlyfname=`echo $_onlyfname | sed  's/\.//g' | sed  's/\_//g'`
_index=0
   for i in ${_screenshotsn[@]}
   do
           imgtype=$(wget --spider -o - $i )
           _ext=`echo $imgtype | sed 's/.*image\///' | sed 's/].*//'`
           wget $i -O $_onlyfname$_index.$_ext
           wp media import $_onlyfname$_index.$_ext
           rm  $_onlyfname$_index.$_ext
           _index=$(expr $_index + 1)
   done
echo "now index value is " $_index
   i=1
   j=0
   _s=(0 0 0 0 0 0 0 0 0 0 )
   _imgurl=('""' '""' '""' '""' '""' '""' '""' '""' '""' '""' )
   _imgtoday=$(date +"%Y/%m")
   
   while [ $i -le $_index ]
   do
           echo $i
           _slen=`expr 51 + ${#_onlyfname} + ${#_index} + 1 + ${#_ext}`
           _s[$j]=$_slen
           _imgurl[$j]='"http://digitalvidia.com/wp-content/uploads/'$_imgtoday/$_onlyfname$j.$_ext'"'
           i=$(( $i + 1 ))
           j=$(( $j + 1 ))
   done

_datos_imagenes='a:10:{i:0;s:'${_s[0]}':'${_imgurl[0]}';i:1;s:'${_s[1]}':'${_imgurl[1]}';i:2;s:'${_s[2]}':'${_imgurl[2]}';i:3;s:'${_s[3]}':'${_imgurl[3]}';i:4;s:'${_s[4]}':'${_imgurl[4]}';i:5;s:'${_s[5]}':'${_imgurl[5]}';i:6;s:'${_s[6]}':'${_imgurl[6]}';i:7;s:'${_s[7]}':'${_imgurl[7]}';i:8;s:'${_s[8]}':'${_imgurl[8]}';i:9;s:'${_s[9]}':'${_imgurl[9]}';}'

echo "*****************"
echo $_datos_imagenes
mysql --host=localhost --user=bhawesh --password=Z?P@2xJ=Z6 apkfile -e "INSERT INTO apkfile.wp_postmeta (post_id,meta_key,meta_value) VALUES ($_post_id,'datos_imagenes','$_datos_imagenes')"
#****************************Add Screenshots End*************************
#____________________________Add Video_________________________________
echo $_video
_vurl=`echo $_video | sed 's/?.*//g' | sed  's/.*embed\///g'`
echo $_vurl
_datos_video='a:1:{s:2:"id";s:'${#_vurl}':"'$_vurl'";}'
mysql --host=localhost --user=bhawesh --password=Z?P@2xJ=Z6 apkfile -e "INSERT INTO apkfile.wp_postmeta (post_id,meta_key,meta_value) VALUES ($_post_id,'datos_video','$_datos_video')"

#____________________________Add Video End_____________________________

#mysql --host=localhost --user=bhawesh --password=Z?P@2xJ=Z6 apkfile -e "INSERT INTO apkfile.wp_postmeta (post_id,meta_key,meta_value) VALUES ($_post_id,'datos_imagenes','$_datos_imagenes')"


rm $_txt_file.png $_txt_file
done
echo "Process finished" >>log.txt

mysqlimport --local --fields-enclosed-by='"' --fields-terminated-by=',' --lines-terminated-by="\n" --columns=post_id,media_id,app_id,p_date -h localhost -ubhawesh -pZ?P@2xJ=Z6  apkfile apklogs.csv
cat /dev/null >apklogs.csv
