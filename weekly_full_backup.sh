#!/bin/bash

# User input
if [ $# -lt 1 ]; then
    echo "You need to provide at least one directory to backup"
    exit 1
fi



BACKUP_PATH="backup"
WEEKLY_BACKUP_FOLDER="weekly_backup"
DAILY_BACKUP_FOLDER="daily_backup"
FOLDERS_TO_BACKUP=("$@")

if ! [ -d $BACKUP_PATH ] ; then
    echo "Backup folder does not exist"
fi

# Date format for backup naming
DATE=$(date +%Y-%m-%d-%H-%M-%S)

# Full backup file name
BACKUP_FILE="$BACKUP_PATH/$WEEKLY_BACKUP_FOLDER/full_backup_$DATE.tar.gz"

# Perform full backup with compression
tar --create --gzip --file="$BACKUP_FILE" "${FOLDERS_TO_BACKUP[@]}" --listed-incremental="$BACKUP_PATH/$WEEKLY_BACKUP_FOLDER/snapshot_$DATE.snar" --preserve-permissions > /dev/null 2>&1

mkdir -p $BACKUP_PATH/$DAILY_BACKUP_FOLDER/daily_backups_from_$DATE 

# Print completion message
echo "Full backup completed: $BACKUP_FILE"


