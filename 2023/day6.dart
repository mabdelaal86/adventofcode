import 'common.dart';

late final List<String> data;

final example = r"""
Time:      7  15   30
Distance:  9  40  200
""".trim();

final input = r"""
Time:        48     93     85     95
Distance:   296   1928   1236   1391
""".trim();

(List<int>, List<int>) parse1() => (
      data[0].split(spaceRe).skip(1).map((e) => int.parse(e)).toList(),
      data[1].split(spaceRe).skip(1).map((e) => int.parse(e)).toList(),
  );

(int, int) parse2() => (
      int.parse(data[0].replaceAll(" ", "").split(":")[1]),
      int.parse(data[1].replaceAll(" ", "").split(":")[1]),
  );

List<(int, int)> zip((List<int>, List<int>) items) =>
  List.generate(items.$1.length, (i) => (items.$1[i], items.$2[i]));

Iterable<int> ways(int time) => Iterable
    .generate(time - 1, (i) => i + 1) // 1..time-1
    .map((e) => (time - e) * e);

int countWin((int, int) race) => ways(race.$1).where((e) => e > race.$2).length;

Future<void> main() async {
  // data = example.split("\n");
  data = input.split("\n");
  for (final item in data) print(item);
  
  final res1 = zip(parse1()).map(countWin).mul();
  print(res1);

  final race2 = parse2();
  print(race2);
  final res2 = countWin(race2);
  print(res2);
}

// part 1:
// part 2:
