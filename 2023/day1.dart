import 'common.dart';

late final List<String> data;

final example1 = r"""
1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet
""".trim();

final example2 = r"""
two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen""".trim();

final numbers = {
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
};

final digitRe = RegExp(r"\d");
final numberRe = RegExp('(?=(${numbers.keys.join("|")}))');

List<RegExpMatch> firstLastMatches(Iterable<RegExpMatch> matches) => switch (matches.toList()) {
  [] => [],
  final items => [items.first, items.last],
};

List<RegExpMatch> firstLastDigit(String line) => firstLastMatches(digitRe.allMatches(line));
List<RegExpMatch> firstLastWord(String line) => firstLastMatches(numberRe.allMatches(line));

String convert1(String line) => firstLastDigit(line).map((m) => m[0]!).join();

String convert2(String line) {
  final digitMatches = firstLastDigit(line);
  final wordMatches = firstLastWord(line);

  if (digitMatches.isEmpty)
    return wordMatches.map((m) => numbers[m[1]!]).join();

  if (wordMatches.isEmpty)
    return digitMatches.map((m) =>m[0]!).join();

  final List<String> matches = [
    digitMatches.first.start < wordMatches.first.start
        ? digitMatches.first[0]!
        : numbers[wordMatches.first[1]!]!,
    digitMatches.last.end > wordMatches.last.end
        ? digitMatches.last[0]!
        : numbers[wordMatches.last[1]!]!,
  ];

  return matches.join();
}

Future<void> main() async {
  data = await getData().toList();
  // data = example1.split("\n");
  // data = example2.split("\n");

  final part1 = data.map(convert1).map(int.parse).sum();
  print(part1);

  final part2 = data.map(convert2).map(int.parse).sum();
  print(part2);
}
