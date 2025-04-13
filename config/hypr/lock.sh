#!/usr/bin/bash

IMAGES_PATH="$HOME/.cache/hyprlock/"

mkdir -p "$IMAGES_PATH"

magick ~/Pictures/Pictures/Wallpaper/bg2.jpg \( +clone -crop 30%x100%+0+0 -gaussian-blur 0x8 \) -gravity west -composite "$IMAGES_PATH/eDP-1.jpg"

magick ~/Pictures/Pictures/Wallpaper/middle-earth-map.jpg \( +clone -crop 30%x100%+0+0 -gaussian-blur 0x8 \) -gravity west -composite "$IMAGES_PATH/HDMI-A-1.jpg"

# hyprctl monitors -j | jq '.[] | .name' | xargs

# wallpaper = eDP-1,~/Pictures/Pictures/Wallpaper/bg2.jpg
# wallpaper = HDMI-A-1,~/Pictures/Pictures/Wallpaper/middle-earth-map.jpg
