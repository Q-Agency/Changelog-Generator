#!/usr/bin/env bash

source config

if [ -f "$CHANGELOG_PATH" ]; then
  rm "$CHANGELOG_PATH"
fi

counter=1
while true; do
  previous=$counter
  ((counter++))
  bash tag_parser.sh $ENVIRONMENT $COMMIT_TAG $CHANGELOG_PATH $previous "$counter"
  if [ $? -eq 1 ]; then
        break
  fi
done
