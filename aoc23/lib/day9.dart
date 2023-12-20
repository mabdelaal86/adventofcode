import 'common.dart';

final example = r"""
0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45
""".trim();

late final List<String> data;

Future<void> main() async {
  data = await getData().toList();
  // data = example.split("\n");

  final part1 = data.map(toNums).map(predictNext).sum();
  print(part1);

  final part2 = data.map(toNums).map(predictPrev).sum();
  print(part2);
}

List<int> toNums(String line) => line
    .split(" ")
    .map((e) => int.parse(e))
    .toList();

int predictNext(List<int> values) => values.allAre(0) ? 0 : predictNext(steps(values)) + values.last;

int predictPrev(List<int> values) => values.allAre(0) ? 0 : values.first - predictPrev(steps(values));

List<int> steps(List<int> values) => values
    .indexed.skip(1)
    .map((e) => e.$2 - values[e.$1 - 1])
    .toList();

// part 1: 1842168671
// part 2: 903
