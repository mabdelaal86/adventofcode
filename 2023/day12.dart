import 'dart:math';

import 'common.dart';

late final List<String> data;

final example = r"""
???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1
""".trim();

class Record {
  final String records;
  final List<int> groups;
  bool get isDeterministic => !records.contains("?");
  bool get isNotSplittable => records.contains(".");

  Record(this.records, this.groups);
  static Record parse(String row) {
    final parts = row.split(" ");
    return Record(parts[0], parts[1].split(",").map(int.parse).toList());
  }

  bool isMatch(String records) {
    final matches = RegExp(r"#+").allMatches(records).map((e) => e[0]!.length).toList();
    return matches.length == groups.length && matches.indexed.every((e) => e.$2 == groups[e.$1]);
  }

  Iterable<String> generateMatched() => generateCombinations(records).where((e) => isMatch(e));

  Record unfold(int count) {
    final unfoldRecords = List<String>.filled(count, records).join("?");
    final unfoldGroups = Iterable.generate(count, (i) => groups)
        .fold(Iterable<int>.empty(), (previousValue, element) => previousValue.followedBy(element))
        .toList();
    
    return Record(unfoldRecords, unfoldGroups);
  }
  
  Iterable<Record> split() sync* {
    if (isNotSplittable)
      yield this;
    else {
      final parts = records.split(RegExp(r"\.+"));


    }
  }
}

Future<void> main() async {
  data = await getData().toList();
  // data = example.split("\n");

  final parsed = data.map(Record.parse).toList();
  printMaxSum(parsed);

  final matchedCombinations = parsed.map((e) => e.generateMatched().length);
  print(matchedCombinations.sum());
  
  final unfolded = parsed.map((e) => e.unfold(5)).toList();
  printMaxSum(unfolded);

  final matchedUnfolded = unfolded.map((e) => e.generateMatched().length);
  print(matchedUnfolded.sum());
}

void printMaxSum(List<Record> items) {
  final allCombinations = items
      .map((e) => "?".allMatches(e.records).length)
      .map((e) => pow(2, e).toInt());
  print(allCombinations.sum());
}

Iterable<String> generateCombinations(String records) sync* {
  if ("?".allMatches(records).length == 0)
    yield records;
  else
    for (final condition in const [".", "#"])
      yield* generateCombinations(records.replaceFirst("?", condition));
}

// part 1: 7460
// part 2:

/*
6727108
7460

-3254662897731616768
*/