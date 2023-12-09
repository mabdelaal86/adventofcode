import 'common.dart';

late final List<String> data;

final example = r"""
seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4
""".trim();

List<int> getSeeds1() => data[0]
      .split(":")[1]
      .trim()
      .split(spaceRe)
      .map((e) => int.parse(e))
      .toList();

Iterable<int> getSeeds2(List<int> seeds) sync* {
  assert(seeds.length.isEven);
  late int last;
  for (final (int i, int v) in seeds.indexed) {
    if (i.isEven) last = v;
    else yield* Iterable.generate(v, (x) => last + x);
  }
}

class Range {
  final int destination, source, length;
  Range(this.destination, this.source, this.length);
  bool inRange(int value) => value >= source && value < source + length;
  int map(int value) => destination + value - source;
}

List<List<Range>> getMaps() {
  final maps = <List<Range>>[];

  for (final line in data.skip(1)) {
    if (line.isEmpty) continue;
    if (line.endsWith(" map:")) {
      maps.add([]);
      continue;
    }

    final numbers = line.split(spaceRe).map((e) => int.parse(e)).toList();
    maps.last.add(Range(numbers[0], numbers[1], numbers[2]));
  }

  return maps;
}

int mapValue(int value, List<Range> maps) => maps
    .where((e) => e.inRange(value))
    .firstOrNull?.map(value) ?? value;

Future<void> main() async {
  data = await getData("data/day5.txt").toList();
  // data = example.split("\n");
  // for (final item in data) print(item);

  final seeds1 = getSeeds1();
  final maps = getMaps();

  print("** maps created");
  // for (final map in maps) print(map);

  final part1 = seeds1.map((s) => maps.fold(s, mapValue)).min();
  print(part1);

  final seeds2 = getSeeds2(seeds1);
  print("** seeds2 created");
  final part2 = seeds2.map((s) => maps.fold(s, mapValue)).min();
  print(part2);
}

// part 1:
// part 2:
