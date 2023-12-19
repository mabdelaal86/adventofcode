import 'dart:math';

import 'package:basics/int_basics.dart';

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

final str2Dir = {"U": Dir.n, "D": Dir.s, "R": Dir.e, "L": Dir.w};
final num2Dir = {"3": Dir.n, "1": Dir.s, "0": Dir.e, "2": Dir.w};

Future<void> main() async {
  // data = await getData().toList();
  data = example.split("\n");

  // data.printAll();
  final processed1 = data.map(process1);
  List<Point<int>> edges1 = getEdges(processed1);

  printEdges(edges1);

  final part1 = area(edges1);
  print(part1);

  final processed2 = data.map(process2);
  List<Point<int>> edges2 = getEdges(processed2);

  print(processed2);
  printEdges(edges2);
}

List<Point<int>> getEdges(Iterable<(Dir, int)> processed) {
  final edges = [Point(0, 0)];
  for (var e in processed) {
    fillEdges(edges, e);
  }
  adjustEdges(edges);
  return edges;
}

void printEdges(List<Point<int>> edges) {
  final m = edges.reduce((val, elm) => Point(max(val.x, elm.x), max(val.y, elm.y)));
  for (final r in min(1000, m.y + 1).range) {
    print(min(1000, m.x + 1).range.map((c) => edges.contains(Point(c, r)) ? "#" : ".").join());
  }
}

(Dir, int) process1(String line) {
  final parts = line.split(" ");
  return (str2Dir[parts[0]]!, int.parse(parts[1]));
}

(Dir, int) process2(String line) {
  final color = line.split(" ").last;
  return (num2Dir[color[7]]!, int.parse(color.substring(2, 7), radix: 16));
}

void fillEdges(List<Point<int>> edges, (Dir, int) item) {
  final delta = dirDelta[item.$1]!;
  final last = edges.last;
  final newEdges = item.$2.range.map((i) => delta * (i + 1) + last);
  edges.addAll(newEdges);
}

void adjustEdges(List<Point<int>> edges) {
  final topLeft = edges.reduce((val, elm) => Point(min(val.x, elm.x), min(val.y, elm.y)));
  for (final (index, point) in edges.indexed) {
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
