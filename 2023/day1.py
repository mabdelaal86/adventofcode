import re
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


def get_inputs() -> str:
    path = Path("data/day1.txt")
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
