#!/bin/bash

ACT_MONITOR="$(hyprctl monitors -j | jq '.[] | select(.focused == true) | .id')"
hyprctl dispatch movecurrentworkspacetomonitor +1
hyprctl dispatch focusmonitor "$ACT_MONITOR"
