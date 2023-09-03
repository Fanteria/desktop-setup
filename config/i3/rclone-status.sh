#!/bin/bash

# tail -n
while getopts "n:" flag ; do
    case "${flag}" in
        n) LOG_COUNT=${OPTARG};;
    esac
done

LOG_FILE=${@:$OPTIND:1}
if [ -z "$LOG_FILE" ] ; then
  >&2 echo "Path to log file must be set."
  exit 1
fi

if [ -z "$LOG_COUNT" ] ; then
  LOG_COUNT=3
fi

GREP_STRING="bisync is EXPERIMENTAL. Don't use in production!"
OUTPUT=$(tail "$LOG_FILE" -n "$LOG_COUNT" | grep -v "$GREP_STRING")


if [ -z "$OUTPUT" ] ; then
  # echo " "
  echo "󰅠 "
else
  echo "  "
  # echo "󰧠 "
fi
