import 'package:quiver/core.dart';

import 'common.dart';

late final List<String> data;

final cache = <(String, int), int>{};

final example = r"""
???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1
""".trim();

Future<void> main() async {
  data = await getData().toList();
  // data = example.split("\n");

  final part1 = data.map(preprocess).map(parse).map(calcCombinations).sum(); // .map(echo)
  print(part1);

  final part2 = data.map(echo).map(preprocess).map(unfold).map(parse).map(echo).map(calcCombinations).sum(); //
  print(part2);
}

(String, String) preprocess(String row) {
  final parts = row.split(" ");
  return (parts[0], parts[1]);
}

(String, String) unfold((String, String) record,  [int count = 5]) => (
      List<String>.filled(count, record.$1).join("?"),
      List<String>.filled(count, record.$2).join(","),
  );

(String, List<int>) parse((String, String) record) {
  var readings = splitRecords(record.$1);
  var counts = record.$2.split(",").map(int.parse).toList();

  while (counts.isNotEmpty) {
    if (readings.first.length == counts.first && readings.first.contains("#")) {
      readings.removeAt(0);
      counts.removeAt(0);
      continue;
    }
    if (readings.last.length == counts.last && readings.last.contains("#")) {
      readings.removeLast();
      counts.removeLast();
      continue;
    }
    if (readings.first.length < counts.first && !readings.first.contains("#")) { // all are ???
      readings.removeAt(0); // all should be ...
      continue;
    }
    if (readings.last.length < counts.last && !readings.last.contains("#")) { // all are ???
      readings.removeLast(); // all should be ...
      continue;
    }

    break;
  }

  if (readings.isEmpty) assert(counts.isEmpty);
  if (counts.isEmpty) return ("#", [1]);
  return (readings.join("."), counts);
}

bool isMatch(String readings, List<int> counts) {
  final groups = splitRecords(readings);
  return groups.length == counts.length &&
      groups.zip(counts).every((e) => e.$1.length == e.$2);
}

bool mayMatch(String readings, List<int> counts) {
  return splitRecords(readings)
      .takeWhile((e) => !e.contains("?"))
      .zip(counts)
      .every((e) => e.$1.length == e.$2);
}

int calcCombinations((String, List<int>) record) {
  final recordHash = (splitRecords(record.$1).join("."), hashObjects(record.$2));
  if (cache.containsKey(recordHash)) {
    // print(record);
    return cache[recordHash]!;
  }

  int res = 0;
  if (!record.$1.contains("?")) {
    res = isMatch(record.$1, record.$2) ? 1 : 0;
  }
  else if (mayMatch(record.$1, record.$2)) {
    res = const [".", "#"]
      .map((e) => record.$1.replaceFirst("?", e))
      .map((e) => calcCombinations((e, record.$2)))
      .sum();
  }

  cache[recordHash] = res;
  return res;
}

List<String> splitRecords(String records) => records.replaceAll(".", " ").trim().split(spaceRe);

// part 1: 7460
// part 2:

/*
6727108
7460

-3254662897731616768

(?.?.#??????#?.????.?.#??????#?.????.?.#??????#?.????.?.#??????#?.????.?.#??????#?.??, [1, 2, 1, 2, 1, 2, 1, 2, 1, 2])

*/
