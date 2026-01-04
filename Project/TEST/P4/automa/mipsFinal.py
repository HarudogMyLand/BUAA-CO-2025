import os
import sys
from time import sleep

from mipsCheck import run_once
from mipsCMD import get_parser, restart_all

parser = get_parser()
args = parser.parse_args()
num1 = args.s
num2 = args.js
jump = args.nj

restart = args.r

if restart:
    restart_all()
    sys.exit(0)

try:
    times = -1
    print("Test start with index 0")

    while times <= 0 or times > 50:

        try:
            times = int(input("How many times do you want to run? (input a positive num less than 50): ").strip())
        except ValueError:
            print("Invalid input, are you joking?")

    cnt = 0

    print(f"Generate mode: Blocks-{num1}, J-{num2}, jump = {jump}")

    while times > 0:
        print(f"No. {cnt} test started".center(20, "="))
        if run_once(num1, num2, jump):
            times -= 1
            cnt += 1
        else:
            print(f"{times} test failed.")
            break
        print(f"End".center(20, "="))

except KeyboardInterrupt:
    print("Waiting...")
    for i in range(101):
        bar = "=" * (i // 2)
        spaces = " " * (50 - (i // 2))
        print(f"Killing output processing: [{bar}{spaces}] {i}%", end="\r")
        sleep(0.02)
    print("\nYou have terminated the output processing")
except Exception as e:
    print(e)