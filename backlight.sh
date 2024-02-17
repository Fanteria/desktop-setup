#!/bin/bash

ddcutil setvcp 10 "$1"
brightnessctl set "$1%"
