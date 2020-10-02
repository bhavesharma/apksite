# define database connectivity
_hostsrv="95.111.194.99"
_db="apkfile"
_db_user="bhawesh"
_db_password="Z?P@2xJ=Z6"


_csv_directory="/home/ec2-user/temp"
_download_dir="/home/ec2-user/download"
_log_dir="/home/ec2-user/logs"
NOW=$(date +"%Y-%m-%d-%H-%T")
LOGFILE="$NOW.log"
