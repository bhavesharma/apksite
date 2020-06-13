PATH=/home/ec2-user/.nvm/versions/node/v13.13.0/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/ec2-user/.local/bin:/home/ec2-user/bin
source ./conn.com
cd $_csv_directory

LOGFILE=$_log_dir/"getapps_"$LOGFILE
if [ -f "outapk.json" ]; then
    rm outapk.json
    rm stg*.csv
echo "Old Files removed" >>$LOGFILE
else
  echo "No old file found Continue script" >>$LOGFILE
fi

echo "Starting JSON download file" >>$LOGFILE
#***********Download json Data************
#_url="http://127.0.0.1:3000/api/apps/?fullDetail=true&collection=topselling_free&category="$1
curl -s -o "outapk.json" "http://127.0.0.1:3000/api/apps/?fullDetail=true&collection=topselling_free&category=SHOPPING"
#curl $_url
echo "Sleeping for 20 seconds" >>$LOGFILE
sleep 20s
if [ -s outapk.json  ]; then
  echo "successfully executed downloading Json" >>$LOGFILE
else
  echo "failed download json filei EC:- $?" >>$LOGFILE
  exit 255
fi
#***********Remove extra line from Header**
sed 's/^...........//' outapk.json > outapk.temp
sleep 15s
sed 's/\(.*\)\}\],\"next\".*/\1}]/g' outapk.temp > outapk.json
#************Delete temp File*************
rm -rf outapk.temp
echo "Sleeping for 15 seconds" >>$LOGFILE
sleep 15s
###########################################
#************Convert to csv File***********
#******************************************
json2csv -i outapk.json -f appId,title,description,descriptionHTML,summary,scoreText,size,androidVersionText,developer__devId,genreId,icon,headerImage,screenshots,version,updated -o stg_apkdetails.csv

if [ $? -eq 0 ]; then
  echo "Final : successfully executed csv file genrated" >>$LOGFILE
else
  echo "Errror while creating csv from JSON EC:- $?" >>$LOGFILE
fi

