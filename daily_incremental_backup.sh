#!/bin/bash

if [ $# -lt 1 ]; then
    echo "You need to provide at least one directory to backup"
    exit 1
fi

# Define backup directories and incremental backup location
BACKUP_DIR="backup"
FOLDERS_TO_BACKUP=("$@")
DAILY_BACKUP_FOLDER="daily_backup"
WEEKLY_BACKUP_FOLDER="weekly_backup"

# Date format for backup naming
DATE=$(date +%Y-%m-%d-%H-%M-%S)
PREVIOUS_SNAPSHOT=$(ls -t $BACKUP_DIR/$WEEKLY_BACKUP_FOLDER/snapshot_*.snar | head -n 1)
CURRENT_BACKUP_FOLDER=$(find $BACKUP_DIR/$DAILY_BACKUP_FOLDER -type d -name \
"daily_backups_from_*" -exec ls -dt {} + | head -n 1)


# Incremental backup file name
BACKUP_FILE="$CURRENT_BACKUP_FOLDER/incremental_backup_$DATE.tar.gz"

# Perform incremental backup
tar --create --gzip --file="$BACKUP_FILE" \
 --listed-incremental="$PREVIOUS_SNAPSHOT" "${FOLDERS_TO_BACKUP[@]}" --preserve-permissions > /dev/null 2>&1

# Print completion message
echo "Incremental backup completed: $BACKUP_FILE"