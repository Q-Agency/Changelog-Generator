#!/usr/bin/env bash

DESTINATION_FILE_NAME="changelog.txt"
if [ -f "$DESTINATION_FILE_NAME" ]; then
  rm "$DESTINATION_FILE_NAME"
fi

counter=1
while true; do
  previous=$counter
  ((counter++))
  bash tag_parser.sh $previous "$counter" $DESTINATION_FILE_NAME
  if [ $? -eq 1 ]; then
        break
  fi
done
