import 'package:basics/int_basics.dart';

import 'common.dart';

late final List<String> data;

final example = r"""
O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#....
""".trim();

Future<void> main() async {
  // data = await getData().toList();
  data = example.split("\n");

  final tilted1 = rotate90(data).map(tiltRow);
  final rev1 = rotate90(tilted1, true).toList();
  // rev1.printAll();
  final part1 = calcLoad(rev1);
  print(part1);

  // spin(1000);

  print(cocowawa(100, 3, 7));
  print(cocowawa(1E+9.toInt(), 3, 7));
  print("-----");
  print(cocowawa(995, 108, 42));
  print(cocowawa(999, 108, 42));
  print(cocowawa(1000, 108, 42));
  print(cocowawa(1E+9.toInt(), 108, 42));
}

List<String> spin(int cycles) {
  List<String> res = data;

  for (final c in cycles.range) {
    for (final _ in 4.range) {
      res = rotate90(res).map(tiltRow).toList();
    }
    // res.printAll();
    final load = calcLoad(res);
    // print("${c+1} =========== $load");
  }

  return res;
}

String tiltRow(String row) => row.splitMapJoin("#", onNonMatch: tiltPart);

String tiltPart(String group) {
  final rockCount = "O".allMatches(group).length;
  return "." * (group.length - rockCount) + "O" * rockCount;
}

int calcLoad(List<String> elements) => elements.reversed.indexed
    .map((e) => (e.$1 + 1) * e.$2.split("").where((e) => e == "O").length)
    .sum();

Iterable<String> rotate90(Iterable<String> elements, [bool anticlockwise = false]) {
  if (elements.isEmpty) return [];

  final res = List.generate(elements.first.length, (i) => <String>[]);

  for (final row in elements.map((e) => e.split(""))) {
    for (final (idx, col) in row.indexed) {
      if (anticlockwise) {
        res[res.length - idx - 1].add(col);
      } else {
        res[idx].insert(0, col);
      }
    }
  }

  return res.map((e) => e.join());
}

int cocowawa(int x, int s, int n) => (x - s) % n + s;

// part 1:
// part 2:

// 1 =========== 87
// 2 =========== 69
// --- (7)
// 3 =========== 69
// 4 =========== 69
// 5 =========== 65
// 6 =========== 64
// 7 =========== 65
// 8 =========== 63
// 9 =========== 68
// ...
// 84 =========== 65
// 85 =========== 63
// 86 =========== 68
// 87 =========== 69
// 88 =========== 69
// 89 =========== 65
// 90 =========== 64
// 91 =========== 65
// 92 =========== 63
// 93 =========== 68
// 94 =========== 69
// 95 =========== 69
// 96 =========== 65
// 97 =========== 64
// 98 =========== 65
// 99 =========== 63
// 100 =========== 68



/*
... (42)
108 =========== 88759
109 =========== 88774
110 =========== 88771
111 =========== 88762
112 =========== 88762
113 =========== 88741
114 =========== 88711
115 =========== 88704
116 =========== 88673
117 =========== 88666
118 =========== 88680
119 =========== 88683
120 =========== 88711
121 =========== 88744
122 =========== 88765
123 =========== 88767
124 =========== 88772
125 =========== 88768
126 =========== 88755
127 =========== 88742
128 =========== 88717
129 =========== 88697
130 =========== 88674
131 =========== 88672
132 =========== 88673
133 =========== 88684
134 =========== 88717
135 =========== 88737
136 =========== 88766
137 =========== 88773
138 =========== 88765
139 =========== 88769
140 =========== 88761
141 =========== 88735
142 =========== 88718
143 =========== 88703
144 =========== 88667
145 =========== 88673
146 =========== 88679
147 =========== 88677
148 =========== 88718
149 =========== 88743
*/

/*
976 =========== 88766
977 =========== 88773
978 =========== 88765
979 =========== 88769
980 =========== 88761
981 =========== 88735
982 =========== 88718
983 =========== 88703
984 =========== 88667
985 =========== 88673
986 =========== 88679
987 =========== 88677
988 =========== 88718
989 =========== 88743
990 =========== 88759
991 =========== 88774
992 =========== 88771
993 =========== 88762
994 =========== 88762
995 =========== 88741
996 =========== 88711
997 =========== 88704
998 =========== 88673
999 =========== 88666
1000 =========== 88680
*/
