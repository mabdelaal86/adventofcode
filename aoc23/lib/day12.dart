import 'package:quiver/core.dart';

import 'common.dart';

final example = r"""
???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1
""".trim();

late final List<String> data;
final cache = <(String, int), int>{};

Future<void> main() async {
  data = await getData().toList();
  // data = example.split("\n");

  final part1 = data.map(preprocess)
      .map(parse)
      .map(calcCombinationsCached)
      .sum();
  print(part1);

  final part2 = data
      .map(echo)
      .map(preprocess)
      .map(unfold)
      .map(parse)
      .map(echo)
      .map(calcCombinationsCached)
      .sum();
  print(part2);
}

class Record {
  final String readings;
  final List<int> counts;
  final List<String> readingGroups;

  Record(this.readings, this.counts) : readingGroups = splitReadings(readings);

  @override
  String toString() => (readings, counts).toString();

  static List<String> splitReadings(String readings) => readings.replaceAll(".", " ").trim().split(spaceRe);

  (String, int) get hash => (readingGroups.join("."), hashObjects(counts));

  factory Record.single() => Record("#", [1]);

  bool get isMatch => readingGroups.length == counts.length &&
        readingGroups.zip(counts).every((e) => e.$1.length == e.$2);

  bool determinedMatch() => readingGroups
        .takeWhile((e) => !e.contains("?"))
        .zip(counts)
        .every((e) => e.$1.length == e.$2);

  bool groupCountMatch() => readingGroups
      .where((e) => e.contains("#")).length <= counts.length;

  bool mayMatch() => determinedMatch() && groupCountMatch();
}

(String, String) preprocess(String row) {
  final parts = row.split(" ");
  return (parts[0], parts[1]);
}

(String, String) unfold((String, String) record,  [int count = 5]) => (
      List<String>.filled(count, record.$1).join("?"),
      List<String>.filled(count, record.$2).join(","),
  );

Record parse((String, String) record) => Record(
    Record.splitReadings(record.$1).join("."),
    record.$2.split(",").map(int.parse).toList()
);

int calcCombinationsCached(Record record) => cache[record.hash] ??= calcCombinations(record);

int calcCombinations(Record record) {
  if (!record.readings.contains("?")) {
    return record.isMatch ? 1 : 0;
  }
  if (record.mayMatch()) {
    return const [".", "#"]
      .map((e) => record.readings.replaceFirst("?", e))
      .map((e) => calcCombinationsCached(Record(e, record.counts)))
      .sum();
  }
  return 0;
}

// part 1: 7460
// part 2: 6720660274964
