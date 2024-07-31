#!/usr/bin/bash

isMonitoring () {
  # watson status
  if [ "$(watson status)" == "No project started." ]; then
    return 0
  else
    return 1
  fi
}

sleep 1 # Wait to enable `exec-on-event goes right.`
if ! isMonitoring ; then 
  TEXT="$(watson --no-color status -p) $(watson --no-color status -e)  "
  echo "{\"text\": \"$TEXT\", \"tooltip\": \"$(watson status)\"}"
else
  echo ""
fi
