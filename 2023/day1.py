import re
import requests
import sys
from pathlib import Path

numbers = {
    "zero": "0",
    "one": "1",
    "two": "2",
    "three": "3",
    "four": "4",
    "five": "5",
    "six": "6",
    "seven": "7",
    "eight": "8",
    "nine": "9",
}

rnumbers = {k[::-1]: v for k, v in numbers.items()}


# def get_inputs() -> str:
#     response = requests.get("https://adventofcode.com/2023/day/1/input")
#     print(response.status_code)
#     if response.status_code != requests.codes.ok:
#         sys.exit("Can't get inputs")
#     return response.text


# def get_inputs() -> str:
#     return """two1nine
# eightwo
# abcone2threexyz
# xtwone3four
# 4nineeightseven2
# zoneight234
# 7pqrstsixteen
# """


def get_inputs() -> str:
    path = Path("/home/mabdelaa/Downloads/day1-input.txt")
    return path.read_text()


def digit1(line: str) -> str:
    line = re.sub(f'({"|".join(numbers)})', lambda o: numbers[o.group(0)], line, 1)
    return next(c for c in line if c.isdigit())


def digit2(line: str) -> str:
    line = re.sub(f'({"|".join(rnumbers)})', lambda o: rnumbers[o.group(0)], line[::-1], 1)
    return next(c for c in line if c.isdigit())


def convert(line: str) -> int:
    d1 = digit1(line)
    d2 = digit2(line)
    return int(f"{d1}{d2}")


def main():
    content = get_inputs()
    calibration = sum(convert(line) for line in content.splitlines())
    print(calibration)


if __name__ == "__main__":
    main()

# 56042

# 54766
# 55362
# 55360
# 55358
