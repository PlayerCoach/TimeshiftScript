#!/bin/bash

# Define backup directories
BACKUP_DIR="backup"
WEEKLY_BACKUP_FOLDER="$BACKUP_DIR/weekly_backup"
DAILY_BACKUP_FOLDER="$BACKUP_DIR/daily_backup"

# Find full backups older than 30 days
OLD_FULL_BACKUPS=$(find "$WEEKLY_BACKUP_FOLDER" -name "full_backup_*.tar.gz" -type f -mtime +30)

# Loop through each old full backup
for FULL_BACKUP_FILE in $OLD_FULL_BACKUPS; do
    # Extract the timestamp from the full backup filename
    BACKUP_TIMESTAMP=$(basename "$FULL_BACKUP_FILE" | sed -E 's/full_backup_(.*)\.tar\.gz/\1/')
    
    # Find and delete associated snapshot files
    SNAPSHOT_FILE="$WEEKLY_BACKUP_FOLDER/snapshot_$BACKUP_TIMESTAMP.snar"
    if [ -f "$SNAPSHOT_FILE" ]; then
        echo "Deleting snapshot file: $SNAPSHOT_FILE"
        rm "$SNAPSHOT_FILE"
    fi

    # Find and delete the corresponding incremental backup directory
    INCREMENTAL_BACKUP_FOLDER=$(find "$DAILY_BACKUP_FOLDER" -type d -name "daily_backups_from_$BACKUP_TIMESTAMP")
    if [ -d "$INCREMENTAL_BACKUP_FOLDER" ]; then
        echo "Deleting incremental backup folder: $INCREMENTAL_BACKUP_FOLDER"
        rm -r "$INCREMENTAL_BACKUP_FOLDER"
    fi

    # Delete the old full backup file
    echo "Deleting full backup file: $FULL_BACKUP_FILE"
    rm "$FULL_BACKUP_FILE"
done

echo "Old full backups, snapshots, and associated incremental backups have been cleaned up."