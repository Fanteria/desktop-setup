#!/bin/bash

OPTIONS="stop
cancel
restart"
PROJECTS=$(watson projects)
TAGS=$(watson tags)
ALL_OPTIONS=$OPTIONS

# Find all possible options
while IFS= read -r i ; do
  ALL_OPTIONS+="\n${i}"
  while IFS= read -r j ; do
    ALL_OPTIONS+="\n$i +$j"
  done <<< "$TAGS"
done <<< "$PROJECTS"

# Run rofi and save output
SELECTION=$(printf %b "$ALL_OPTIONS" | rofi -dmenu -p " ")

# Exit if output is empty
if [[ "$SELECTION" == "" ]] ; then
  exit 0
fi

# Check if output is known command
while read -r i ; do
  if [[ "$SELECTION" == "$i" ]] ; then
    watson "$SELECTION"
    exit 0
  fi
done <<< "$OPTIONS"

# Start time tracking
SELECTION_ARRAY=("$SELECTION")
watson start "${SELECTION_ARRAY[@]}"
