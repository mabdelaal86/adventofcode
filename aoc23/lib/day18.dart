import 'dart:math';

import 'common.dart';

final example = r"""
R 6 (#70c710)
D 5 (#0dc571)
L 2 (#5713f0)
D 2 (#d2c081)
R 2 (#59c680)
D 2 (#411b91)
L 5 (#8ceee2)
U 2 (#caa173)
L 1 (#1b58a2)
U 2 (#caa171)
R 2 (#7807d2)
U 3 (#a77fa3)
L 2 (#015232)
U 2 (#7a21e3)
""".trim();

late final List<String> data;

final dataRe = RegExp(r"^(\w) (\d+) \(#([0-9a-f]+)\)$");
final str2Dir = {"U": Dir.n, "D": Dir.s, "R": Dir.e, "L": Dir.w};

Future<void> main() async {
  data = await getData().toList();
  // data = example.split("\n");

  // data.printAll();

  final edges = [Point(0, 0)];
  data.map(process).forEach((e) => fillEdges(edges, e));
  adjustEdges(edges);

  // printEdges(edges);

  final part1 = area(edges);
  print(part1);
}

void printEdges(List<Point<int>> edges) {
  final m = edges.reduce((val, elm) => Point(max(val.x, elm.x), max(val.y, elm.y)));
  for (var r in Iterable<int>.generate(m.y + 1)) {
    print(Iterable.generate(m.x + 1, (c) => edges.contains(Point(c, r)) ? "#" : ".").join());
  }
}

(Dir, int, String) process(String line) {
  final m = dataRe.firstMatch(line)!;
  return (str2Dir[m[1]]!, int.parse(m[2]!), m[3]!);
}

void fillEdges(List<Point<int>> edges, (Dir, int, String) item) {
  final delta = dirDelta[item.$1]!;
  final last = edges.last;
  final newEdges = Iterable.generate(item.$2, (i) => delta * (i + 1) + last);
  edges.addAll(newEdges);
}

void adjustEdges(List<Point<int>> edges) {
  final topLeft = edges.reduce((val, elm) => Point(min(val.x, elm.x), min(val.y, elm.y)));
  for (var (index, point) in edges.indexed) {
    edges[index] = point - topLeft;
  }
}

int area(List<Point<int>> edges) {
  int res = 0;
  final bottomRight = edges.reduce((val, elm) => Point(max(val.x, elm.x), max(val.y, elm.y)));

  for (int y = 0; y <= bottomRight.y; y++) {
    bool up = false, dn = false;
    for (int x = 0; x <= bottomRight.x; x++) {
      final onEdge = edges.contains(Point(x, y));
      if (onEdge) {
        res++;
        up ^= edges.contains(Point(x, y - 1));
        dn ^= edges.contains(Point(x, y + 1));
      } else if (up && dn) {
        res++;
      }
    }
  }

  return res;
}

// part 1: 28911
// part 2:
