#!/bin/python

import sys

name_start = "Project "
time_start = " started "
time_end = " ("
not_running = "No project started."

if len(sys.argv) < 2:
    sys.stderr.write("Watson status must be set.\n")
    exit(1)

if sys.argv[1] == not_running:
    print("")
    exit(0)

name_start_index = sys.argv[1].find(name_start)
time_start_index = sys.argv[1].find(time_start)
print(
    sys.argv[1][
        sys.argv[1].find(name_start) + len(name_start) : time_start_index
    ]
    + " "
    + sys.argv[1][
        time_start_index + len(time_start) : sys.argv[1].find(time_end)
    ]
    + "  "
)
