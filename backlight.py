#!/bin/python

import sys
import subprocess
import shutil

def sendNotification(message):
    subprocess.run(["notify-send", "--urgency=CRITICAL", message])
    return

ddcutil_cmd = "ddcutil"
brightnessctl_cmd = "brightnessctl"

if shutil.which(ddcutil_cmd) == None:
    sendNotification("'" + ddcutil_cmd + "' is not installed, cannot change external monitor backlight")
    exit(1)

if shutil.which(brightnessctl_cmd) == None:
    sendNotification("'" + brightnessctl_cmd + "' is not installed, cannot change eDP monitor backlight")
    exit(1)

setting = "set"
value = ""
if len(sys.argv) == 2:
    value = sys.argv[1]
elif len(sys.argv) == 3:
    setting = sys.argv[1]
    value = sys.argv[2]

ddcutil = [ddcutil_cmd, "setvcp", "10"]
brightnessctl = [brightnessctl_cmd, "set"]
if setting == "+":
    ddcutil.append("+")
    ddcutil.append(value)
    brightnessctl.append("+" + value + "%")
elif setting == "-":
    ddcutil.append("-")
    ddcutil.append(value)
    brightnessctl.append(value + "%" + "-")
else:
    ddcutil.append(value)
    brightnessctl.append(value + "%")

subprocess.run(ddcutil)
subprocess.run(brightnessctl)
