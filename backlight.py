#!/bin/python

import sys
import subprocess

setting = "set"
if len(sys.argv) == 2:
    value = sys.argv[1]
elif len(sys.argv) == 3:
    setting = sys.argv[1]
    value = sys.argv[2]

ddcutil = ["ddcutil", "setvcp", "10"]
brightnessctl = ["brightnessctl", "set"]
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
