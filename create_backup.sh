#!/bin/bash

DIR=/var/opt/db_backups
DATABASE=eliflow
DEST=$DIR/$(date +%d-%m-%y_%T--"$DATABASE")
MAX_DUMPS=$1

mkdir "$DIR"
COUNT=$(find $DIR -mindepth 1 -maxdepth 1 -type d | wc -l)
echo "Number of available dumps: $COUNT"
echo "Maximum possible number of dumps: $MAX_DUMPS"
while [[ $COUNT -ge $MAX_DUMPS ]]; do
  OLD_FILE=$(find $DIR -mindepth 1 -maxdepth 1 -type d | sort | head -n 1)
  echo "Removing old dump: $OLD_FILE"
  rm -r "$OLD_FILE"
  ((COUNT--))
done

echo "Dump creation started for database: $DATABASE"
mongodump --uri mongodb://root:1111@eliflow_mongodb:14004/$DATABASE?authSource=admin -o "$DEST"
echo "Dump created: $DEST"


exit 0