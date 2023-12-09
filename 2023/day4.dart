import 'dart:math';

import 'common.dart';

late final List<String> data;

final example = r"""
Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
""".trim();

(String, List<String>, List<String>) extractValues(String line) {
  final parts = line.split(RegExp(r"[:|]"));
  return (
    parts[0].split(spaceRe)[1],
    parts[1].trim().split(spaceRe),
    parts[2].trim().split(spaceRe),
  );
}

(int, List<int>, List<int>) toInt((String, List<String>, List<String>) item) => (
      int.parse(item.$1),
      item.$2.map((e) => int.parse(e)).toList(),
      item.$3.map((e) => int.parse(e)).toList(),
  );

int countWinning((int, List<int>, List<int>) item) => item.$3
    .where((e) => item.$2.contains(e))
    .length;

int calcWorth(int count) => count == 0 ? 0 : pow(2, count - 1).toInt();

List<int> copies = [];

int updateCounts(int count) {
  copies.removeWhere((e) => e == 0);
  final copiesCount = copies.length;

  copies.add(count);
  for (var i = 0; i < copiesCount; i++) {
    copies[i] -= 1;
    copies.add(count);
  }
  // print((count, copiesCount, copiesCount + 1, copies));

  return copiesCount + 1;
}

Future<void> main() async {
  data = await getData("data/day4.txt").toList();
  // data = example.split("\n");
  // for (final item in data) print(item);

  final processed = data.map(extractValues).map(toInt).map(countWinning).toList();

  final part1 = processed.map(calcWorth).sum();
  print(part1);

  final part2 = processed.map(updateCounts).sum();
  print(part2);
}

// part 1:
// part 2: 15455663
