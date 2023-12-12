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

class Group {
  final String records;
  final int count;

  Group(this.records, this.count);
}

class Record {
  final String records;
  final List<int> counts;

  Record._(this.records, this.counts);
  static Record parse(String row) {
    final parts = row.split(" ");
    final counts = parts[1].split(",").map(int.parse).toList();
    return Record._(parts[0], counts);
  }

  Iterable<Group> getGroups() sync* {
    final groups = records.replaceAll(".", " ").trim().split(spaceRe);
    if (groups.length == counts.length) {
      yield* zip(groups.iterator, counts.iterator).map((e) => Group(e.$1, e.$2));
    } else {

    }
  }

  bool isMatch(String records) {
    final matches = RegExp(r"#+").allMatches(records).map((e) => e[0]!.length).toList();
    return matches.length == counts.length && matches.indexed.every((e) => e.$2 == counts[e.$1]);
  }

  Iterable<String> generateMatched() => generateCombinations(records).where((e) => isMatch(e));

  Record unfold(int count) {
    final unfoldRecords = List<String>.filled(count, records).join("?");
    final unfoldGroups = Iterable.generate(count, (i) => counts)
        .fold(Iterable<int>.empty(), (previousValue, element) => previousValue.followedBy(element))
        .toList();
    
    return Record._(unfoldRecords, unfoldGroups);
  }
}

Future<void> main() async {
  data = await getData().toList();
  // data = example.split("\n");

  final parsed = data.map(Record.parse).toList();

  final matchedCombinations = parsed.map((e) => e.generateMatched().length);
  print(matchedCombinations.sum());
  
  final unfolded = parsed.map((e) => e.unfold(5)).toList();

  final matchedUnfolded = unfolded.map((e) => e.generateMatched().length);
  print(matchedUnfolded.sum());
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