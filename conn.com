# define database connectivity
_hostsrv="52.66.9.157"
_db="apksite"
_db_user="admin"
_db_password="toor"


_csv_directory="/home/ec2-user/temp"
_download_dir="home/ec2-user/download"
NOW=$(date +"%Y-%m-%d-%H-%T")
LOGFILE="log-$NOW.log"
