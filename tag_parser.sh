#!/usr/bin/env bash

ENVIRONMENT_TAG="staging"
COMMIT_TAG="ID"
NEWEST_INDEX="$1"
SECOND_NEWEST_INDEX="$2"
DESTINATION_FILE_NAME="$3"

newest_tag=$(git tag -l | sort -V | grep $ENVIRONMENT_TAG | tail -n "$NEWEST_INDEX" | head -n 1)
if [ -z "$newest_tag" ]; then
  echo "No $ENVIRONMENT_TAG tag found."
  exit 1
fi

tag_count=$(git tag | grep -c $ENVIRONMENT_TAG)
if [ "$NEWEST_INDEX" -gt "$tag_count" ]; then
  exit 1
fi

second_newest_tag=$(git tag -l | sort -V | grep $ENVIRONMENT_TAG | tail -n "$SECOND_NEWEST_INDEX" | head -n 1)
if [ "$tag_count" -eq "1" ]; then
  changelog=$(git log --pretty=format:%s | grep "$COMMIT_TAG")
elif [ "$newest_tag" == "$second_newest_tag" ]; then
  changelog=$(git log --pretty=format:%s "$newest_tag" | grep "$COMMIT_TAG")
else
  changelog=$(git log --pretty=format:%s "$newest_tag"..."$second_newest_tag" | grep "$COMMIT_TAG")
fi

date=$(git log -1 --format=%ai "$newest_tag" | cut -d ' ' -f 1)
build_number=$newest_tag

printf "%s\n%s\n%s\n################################\n" "$build_number" "$date" "$changelog" >> "$DESTINATION_FILE_NAME"
