import 'common.dart';

late final List<String> data;
const nonSymbols = ".0123456789";
final numRegex = RegExp(r"\d+");

final example = r"""
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
""".trim();

// Stream<String> getData() => Stream.fromIterable(example.split("\n"));

Iterable<(int, int)> getSurrounding(int i, int s, int e) sync* {
  yield (i, s - 1);
  yield (i, e);
  for (int x = s - 1; x <= e; x++) {
    yield (i - 1, x);
    yield (i + 1, x);
  }
}

bool isPartNumber(int i, int s, int e) => getSurrounding(i, s, e)
    .map((x) => data[x.$1][x.$2])
    .any((x) => !nonSymbols.contains(x));

Iterable<int> getPartNumbers(int i, String line) => numRegex
      .allMatches(line)
      .where((m) => isPartNumber(i, m.start, m.end))
      .map((m) => int.parse(m[0]!));

(int, int) getGearLoc(int i, int s, int e) => getSurrounding(i, s, e)
    .where((x) => data[x.$1][x.$2] == "*")
    .firstOrNull ?? (0, 0);

Map<(int, int), List<int>> collectGears() {
  final Map<(int, int), List<int>> gears = {};
  for (final (int i, String line) in data.indexed) {
    for (final m in numRegex.allMatches(line)) {
      final g = getGearLoc(i, m.start, m.end);
      if (g != (0, 0)) {
        (gears[g] ??= []).add(int.parse(m[0]!));
      }
    }
  }
  return gears;
}

Future<void> main() async {
  data = await getData().map((e) => ".$e.").toList();
  final empty = "." * data[0].length;
  data..insert(0, empty)..add(empty);

  final partsSum = data.indexed
      .map((e) => getPartNumbers(e.$1, e.$2))
      .fold(0, (p, c) => p + c.sum());
  print(partsSum);

  final gears = collectGears();
  final gearsSum = gears.values
      .where((v) => v.length == 2)
      .map((e) => e.mul())
      .sum();
  print(gearsSum);
}

// part 1: 531561
// part 2: 83279367
