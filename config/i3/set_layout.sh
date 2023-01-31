#!/bin/sh

sleep 5
i3-msg "workspace 9: ; append_layout ~/.config/i3/ws.json"
(kitty --config ~/.config/kitty/transparent.conf btop &)
sleep 0.1
(kitty --config ~/.config/kitty/transparent.conf /home/jirka/Projects/gcaltasks/main.py cal show &)
sleep 0.1
(kitty --config ~/.config/kitty/transparent.conf /home/jirka/Projects/gcaltasks/main.py task show &)
sleep 0.1
(kitty --config ~/.config/kitty/transparent.conf spt &)

# i3-save-tree --workspace 9 > ~/ws.json && sed -i 's|^\(\s*\)// "|\1"|g; /^\s*\/\//d' ~/ws.json
