#!/bin/bash

$HOME/.cargo/bin/shortcut-autotyper $($HOME/.cargo/bin/shortcut-autotyper -l | rofi -dmenu -p '  ')
