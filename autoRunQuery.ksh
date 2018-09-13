export DB_NAME="xxx"

export DB_USER_NAME="xxx"

DB_PASSWORD="xxx"

export LOG_FILENAME=$HOME/runquery.log

bteq<<! >>${LOG_FILENAME} 2>&1

.logon ${DB_NAME}/${DB_USER_NAME},${DB_PASSWORD}

.set titledashes off
.set separator ','
.set width 10000
.set format off
.export file=$HOME/result/$(date +"%Y%m%d").csv
.set recordmode off
.run file $HOME/run.sql
.quit
!

zip $HOME/result/$(date +"%Y%m%d").zip $HOME/result/$(date +"%Y%m%d").csv
echo "check the result" | mailx -s "WHLLtest" -a $HOME/result/$(date +"%Y%m%d").zip xx@xx.com

