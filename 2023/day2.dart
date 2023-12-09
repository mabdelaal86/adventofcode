import 'dart:math';

import 'common.dart';

final bag = {"red": 12, "green": 13, "blue": 14};

// Stream<String> getData() => Stream.fromIterable([
//     "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green",
//     "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue",
//     "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red",
//     "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red",
//     "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green",
// ]);

(int, Iterable<String>) parseGames(String line) {
  final parts = line.split(RegExp(r"[:;,]"));
  final id = int.parse(parts[0].substring("Game ".length));
  return (id, parts.skip(1));
}

(int, Map<String, int>) parseSets((int, Iterable<String>) item) {
  final res = {"red": 0, "green": 0, "blue": 0};
  item.$2
      .map((e) => e.trim().split(" "))
      .map((e) => (int.parse(e[0]), e[1]))
      .forEach((e) => res[e.$2] = max(res[e.$2]!, e.$1));
  return (item.$1, res);
}

int possibleGames(List<(int, Map<String, int>)> data) {
  return data
      .where(
          (game) => game.$2.entries.every(
              (cube) => cube.value <= bag[cube.key]!))
      .map((e) => e.$1)
      .sum();
}

int powerGames(List<(int, Map<String, int>)> data) {
  return data.map((e) => e.$2.values.mul()).sum();
}

Future<void> main() async {
  final data = await getData().map(parseGames).map(parseSets).toList();
  print(possibleGames(data));
  print(powerGames(data));
}

// part 1: 2545
// part 2: 78111
