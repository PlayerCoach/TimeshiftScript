#!/bin/bash

BACKUP_PATH="backup"
WEEKLY_BACKUP_FOLDER="weekly_backup"
DAILY_BACKUP_FOLDER="daily_backup"
BACKUP_FILES_DIRECTORY=("/home/playercoach/PG/test")

if ! [ -d $BACKUP_PATH ] ; then
    echo "Backup folder does not exist"
fi

# Date format for backup naming
DATE=$(date +%Y-%m-%d-%H-%M-%S)

# Full backup file name
BACKUP_FILE="$BACKUP_PATH/$WEEKLY_BACKUP_FOLDER/full_backup_$DATE.tar.gz"

# Perform full backup with compression
tar --create --gzip --file="$BACKUP_FILE" "${BACKUP_FILES_DIRECTORY[@]}" --listed-incremental="$BACKUP_PATH/$WEEKLY_BACKUP_FOLDER/snapshot_$DATE.snar" --preserve-permissions

mkdir -p $BACKUP_PATH/$DAILY_BACKUP_FOLDER/daily_backups_from_$DATE 

# Print completion message
echo "Full backup completed: $BACKUP_FILE"


