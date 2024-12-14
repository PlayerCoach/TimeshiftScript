#!/bin/bash

# Define backup directory and restoration directory
BACKUP_DIR="backup"
WEEKLY_BACKUP_FOLDER="weekly_backup"
DAILY_BACKUP_FOLDER="daily_backup"

PREVIOUS_SNAPSHOT=$(ls -t $BACKUP_DIR/$WEEKLY_BACKUP_FOLDER/snapshot_*.snar | head -n 1)
CURRENT_BACKUP_FOLDER=$(find $BACKUP_DIR/$DAILY_BACKUP_FOLDER -type d -name \
"daily_backups_from_*" -exec ls -dt {} + | head -n 1)



# Select which backup to restore (full or incremental)
FULL_BACKUP_FILE=$(ls -t $BACKUP_DIR/$WEEKLY_BACKUP_FOLDER/full_backup_*.tar.gz | head -n 1)  # Example: Full backup to restore
RESTORE_DIR="restore"  # Directory to restore the backup


# Create the restore directory if it does not exist
mkdir -p $RESTORE_DIR

# Restore full backup
tar --extract --gzip --file="$FULL_BACKUP_FILE" --directory="$RESTORE_DIR" --preserve-permissions

for INCREMENTAL_BACKUP in $(ls -1 $CURRENT_BACKUP_FOLDER | sort); do
    tar --extract --gzip --file="$CURRENT_BACKUP_FOLDER/$INCREMENTAL_BACKUP" --directory="$RESTORE_DIR" --preserve-permissions
done

# Print completion message
echo "Restoration completed to $RESTORE_DIR"