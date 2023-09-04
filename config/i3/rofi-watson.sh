#!/bin/bash

OPTIONS="stop
asdgsgadgasgdag
cancel
restart"
PROJECTS=`watson projects`
TAGS=`watson tags`
ALL_OPTIONS=$OPTIONS

# Find all possible options
while IFS= read -r i ; do
  ALL_OPTIONS+="\n${i}"
  while IFS= read -r j ; do
    ALL_OPTIONS+="\n$i +$j"
  done <<< "$TAGS"
done <<< "$PROJECTS"

# Run rofi and save output
SELECTION=`printf %b "start
$ALL_OPTIONS" | rofi -dmenu -p " "`

# Exit if output is empty
if [[ "$SELECTION" == "" ]] ; then
  exit 0
fi

if [[ "$SELECTION" == "start" ]] ; then
  WORKDIR="/home/jiri/development/workdir"
  cd "$WORKDIR"
  ACT_PROJECT=`git status | grep "On branch" | sed 's/On branch //'`
  watson start "$ACT_PROJECT"
  exit 0
fi

# Check if output is known command
while read i ; do
  if [[ "$SELECTION" == "$i" ]] ; then
    watson $SELECTION
    exit 0
  fi
done <<< "$OPTIONS"

# Start time tracking
watson start $SELECTION
