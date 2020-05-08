rm outapk.json
#***********Download json Data************
#_url="http://127.0.0.1:3000/api/apps/?fullDetail=true&collection=topselling_free&category="$1
echo $_url
curl -s -o "outapk.json" "http://127.0.0.1:3000/api/apps/?fullDetail=true&collection=topselling_free&category=SHOPPING"
#curl $_url
sleep 30s
#***********Remove extra line from Header**
sed 's/^...........//' outapk.json > outapk.temp
sleep 15s
sed 's/\(.*\)\}\],\"next\".*/\1}]/g' outapk.temp > outapk.json
#************Delete temp File*************
rm -rf outapk.temp
sleep 15s
###########################################
#************Convert to csv File***********
#******************************************
json2csv -i outapk.json -f appId,title,description,descriptionHTML,summary,scoreText,size,androidVersionText,developer__devId,genreId,icon,headerImage,screenshots -o newapkout.csv
