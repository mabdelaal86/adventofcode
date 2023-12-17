import 'common.dart';

final example = r"""
rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
""".trim();

late final List<String> data;
final boxes = <int, List<(String, String)>>{};

Future<void> main() async {
  data = (await getData().first).split(",");
  // data = example.split(",");

  // print(hash("HASH"));
  final part1 = data.map(hash).sum();
  print(part1);

  data.forEach(updateBoxes);
  final part2 = boxes.entries.map((e) => calcFocusPower(e.key, e.value)).sum();
  print(part2);
}

int hash(String step) {
  int res = 0;

  for (final ch in step.runes) {
    res = (res + ch) * 17 % 256;
  }

  return res;
}

void updateBoxes(String item) {
  final parts = item.split(RegExp(r"[-=]"));
  final box = hash(parts[0]);
  boxes[box] ??= [];
  if (parts[1].isEmpty) {
    boxes[box]!.removeWhere((e) => e.$1 == parts[0]);
  } else {
    final idx = boxes[box]!.indexWhere((e) => e.$1 == parts[0]);
    if (idx == -1) {
      boxes[box]!.add((parts[0], parts[1]));
    } else {
      boxes[box]![idx] = (parts[0], parts[1]);
    }
  }
}

int calcFocusPower(int box, List<(String, String)> lenses) => lenses.indexed
    .map((e) => (box + 1) * (e.$1 + 1) * int.parse(e.$2.$2))
    .sum();

// part 1: 514639
// part 2: 279470
