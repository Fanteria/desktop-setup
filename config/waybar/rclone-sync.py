#!/usr/bin/python

from croniter import croniter
from datetime import datetime
from pathlib import Path
import argparse
import subprocess
import sys

def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)

def readCrontab() -> list[tuple[type[croniter], Path]]:
    LOG_FILE_FLAG = "--log-file"
    ret = []
    crontab = subprocess.run(['crontab', '-l'], stdout=subprocess.PIPE)
    for line in crontab.stdout.decode("utf-8").splitlines():
        index = line.find(LOG_FILE_FLAG)
        if index == -1:
            continue
        cron = croniter(" ".join([x for x in line.split()[0:5]]), datetime.now())
        line = line[index + len(LOG_FILE_FLAG) + 1:]
        space_index = line.find(LOG_FILE_FLAG)
        if space_index == -1:
            ret.append((cron, Path(line)))
        else:
            ret.append((cron, Path(line[:space_index])))
    return ret

def lastLogErrorLine(filename: Path) -> str | None:
    for line in reversed(list(open(filename.expanduser().resolve()))):
        line = line.rstrip()
        if(line.find("NOTICE:") == -1):
            return line
    return None

def getTimestamp(line: str) -> datetime:
    date_string = " ".join([x for x in line.split()[0:2]])
    return datetime.strptime(date_string, "%Y/%m/%d %H:%M:%S")

def checkFailingLogs(logs, count):
    ret = {}
    for cron, file in logs:
        error_line = lastLogErrorLine(file)
        if error_line == None:
            exit(1) # TODO
        # print(getTimestamp(error_line), file.stem)
        for _ in range(0, count):
            cron.get_prev(datetime)
        ret[file.stem] = getTimestamp(error_line) >= cron.get_current(datetime)
    return ret

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Program for checking if rclone synchronization works right.")

    parser.add_argument("-c", "--count", type=int, help="The formatting string", default=2)
    parser.add_argument("-p", "--print_all", action="store_true", help="The formatting string")
    parser.add_argument("-e", "--print_empty", action="store_true", help="The formatting string")
    parser.add_argument("-f", "--format_string", type=str, help="The formatting string", default="{key}: {value}\\r")
    parser.add_argument("-k", "--ok_string", type=str, help="", default='{{"text": "󰅠 ", "tooltip": "{output}", "class": "passed"}}')
    parser.add_argument("-o", "--output_string", type=str, help="The output string", default='{{"text": "󰧠 ", "tooltip": "{output}", "class": "failed"}}')
    parser.add_argument("-K", "--ok_value", type=str, help="", default=" ")
    parser.add_argument("-E", "--err_value", type=str, help="", default="")

    args = parser.parse_args()
    
    #   " "
    #   "󰅠 "
    #   "  "
    #   "󰧠 "
    failin_logs = checkFailingLogs(readCrontab(), args.count)

    output = ""
    failed = False
    for key,value in failin_logs.items():
        if value:
            failed = True
        if value or args.print_all:
            output += args.format_string.format(key=key, value=args.err_value if value else args.ok_value)
    if failed:
        print(args.output_string.format(output=output), end='')
    else:
        print(args.ok_string.format(output=output), end='')
