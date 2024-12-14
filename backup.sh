#!/bin/bash

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



