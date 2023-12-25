#!/bin/sh

sleep 5
i3-msg "workspace 9: ; append_layout ~/.config/i3/ws.json"
(kitty btop &)
sleep 0.5
(kitty todo-tui &)
sleep 0.5
(kitty ncspot &)

# i3-save-tree --workspace 9 > ~/ws.json && sed -i 's|^\(\s*\)// "|\1"|g; /^\s*\/\//d' ~/ws.json
