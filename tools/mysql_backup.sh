#!/bin/bash

BACKUP_PATH="/path/to/backup_directory"
S3_PATH="s3://{バックアップ先S3バケット}/"
FILE_NAME="mysql_dump_`date +%Y%m%d`.sql.gz"

cd $BACKUP_PATH
mysqldump -h 127.0.0.1 --user=root --password=pass whitboard | gzip > $FILE_NAME

find $BACKUP_PATH -type f -name "mysql_dump_*.sql.gz"  -mtime +9 -daystart | xargs rm -rf

aws s3 sync $BACKUP_PATH $S3_PATH  --delete
