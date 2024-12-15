#!/bin/bash

#User  input

if [ $# -lt 1 ]; then
    echo "You need to provide at least one directory to backup"
    exit 1
fi

# Store the directories in an array
FOLDERS_TO_BACKUP=()
for folder in "$@"; do
    abs_path=$(realpath "$folder" 2>/dev/null)
    if [ $? -ne 0 ]; then
        echo "Error: '$folder' is not a valid path."
        exit 1
    fi
    FOLDERS_TO_BACKUP+=("$abs_path")
done

CURRENT_DIRECTORY=$(pwd)
BACKUP_FOLDER="backup"
DAILY_BACKUP_FOLDER="daily_backup"
WEEKLY_BACKUP_FOLDER="weekly_backup"

if ! [ -d $BACKUP_FOLDER ] ; then 

mkdir $BACKUP_FOLDER
mkdir "$BACKUP_FOLDER/$DAILY_BACKUP_FOLDER"
mkdir "$BACKUP_FOLDER/$WEEKLY_BACKUP_FOLDER"

else

    echo "Folder with name $BACKUP_FOLDER already exists, cannot proceed"
    exit 1
fi

./weekly_full_backup.sh ${FOLDERS_TO_BACKUP[@]}

# Add weekly script to crontab
weekly_cron_job="0 0 * * 0 $CURRENT_DIRECTORY/weekly_full_backup.sh ${FOLDERS_TO_BACKUP[@]}"
(crontab -l ; echo "$weekly_cron_job") | crontab -

# Add daily script to crontab 
daily_cron_job="0 0 * * * $CURRENT_DIRECTORY/daily_incremental_backup.sh ${FOLDERS_TO_BACKUP[@]}"
(crontab -l ; echo "$daily_cron_job") | crontab -

# Add delete old backup script to crontab
delete_cron_job="0 0 * * 0 $CURRENT_DIRECTORY/delete_old_backup.sh"
(crontab -l ; echo "$delete_cron_job") | crontab -