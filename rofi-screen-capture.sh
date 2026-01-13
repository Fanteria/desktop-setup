#!/bin/bash

wf-recorder_check() {
	if pgrep -x "wf-recorder" > /dev/null; then
			pkill -INT -x wf-recorder
			notify-send "Stopping all instances of wf-recorder" "$(cat /tmp/recording.txt)"
			wl-copy < "$(cat /tmp/recording.txt)"
			exit 0
	fi
}

wf-recorder_check

MONITORS="$(hyprctl monitors -j)"

all_screens() {
  local MONITORS X Y
  X="$(jq 'max_by(.x) | .x + .width' <<< "$MONITORS")"
  Y="$(jq 'max_by(.y) | .y + .height' <<< "$MONITORS")"
  ALL_SCREENS="0,0 ${X}x${Y}"
}

SELECTION=$(rofi -dmenu -p "󰄀 " <<< \
"screenshot selection
screenshot active window
screenshot full
$(jq -r '.[]["name"] | "screenshot \(.)"' <<< "$MONITORS")
record selection
record active window
$(jq -r '.[]["name"] | "record \(.)"' <<< "$MONITORS")
flameshot")

IMG="${HOME}/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png"
VID="${HOME}/Videos/Recordings/$(date +%Y-%m-%d_%H-%M-%S).mp4"

case "$SELECTION" in
	"screenshot selection")
		grim -g "$(slurp)" "$IMG"
		wl-copy < "$IMG"
		notify-send "Screenshot Taken" "${IMG}"
		;;
  "screenshot active window")
    ACTIVE="$(hyprctl activewindow -j | jq -M -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')"
    grim -g "$ACTIVE" "$IMG"
		wl-copy < "$IMG"
		notify-send "Screenshot Taken" "${IMG}"
    ;;
	"screenshot full")
    all_screens
		grim -g "$ALL_SCREENS" "$IMG"
		wl-copy < "$IMG"
		notify-send "Screenshot Taken" "${IMG}"
		;;
	"screenshot "*)
    grim -c -o "$(cut -d' ' -f2- <<< "$SELECTION")" "$IMG"
		wl-copy < "$IMG"
		notify-send "Screenshot Taken" "${IMG}"
    ;;
	"record selection")
    if $(wf-recorder -a -g "$(slurp)" -f "$VID" &>/dev/null) ; then
		  echo "$VID" > /tmp/recording.txt
    else
		  notify-send -u critical "wf-recorder cannot record across multiple monitors"
    fi
		;;
  "record active window")
		echo "$VID" > /tmp/recording.txt
    ACTIVE="$(hyprctl activewindow -j | jq -M -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')"
    wf-recorder -a -g "$ACTIVE" -f "$VID" &>/dev/null
    ;;
  "record full")
		notify-send -u critical "wf-recorder cannot record across multiple monitors"
    ;;
	"record"*)
		echo "$VID" > /tmp/recording.txt
		wf-recorder -a -o "$(cut -d' ' -f2- <<< "$SELECTION")" -f "$VID" &>/dev/null
		;;
  "flameshot")
    flameshot gui
    ;;
  *)
    ;;
esac
