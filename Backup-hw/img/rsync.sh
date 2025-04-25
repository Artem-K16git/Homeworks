#!/bin/bash

rsync -a --delete ~/ /tmp/backup

if [ "$?" = 0 ]; then
	logger "Backup completed successfully"
else
	logger "Backup failed"
fi
