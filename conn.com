# define database connectivity
_hostsrv="15.206.158.24"
_db="apksite"
_db_user="admin"
_db_password="toor"


_csv_directory="/home/ec2-user/temp"
_download_dir="/home/ec2-user/download"
_log_dir="/home/ec2-user/logs"
NOW=$(date +"%Y-%m-%d-%H-%T")
LOGFILE="$NOW.log"
