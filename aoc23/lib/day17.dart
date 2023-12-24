import 'dart:math';

import 'package:basics/basics.dart';
import 'package:quiver/core.dart';

import 'common.dart';

final example = r"""
2413432311323
3215453535623
3255245654254
3446585845452
4546657867536
1438598798454
4457876987766
3637877979653
4654967986887
4564679986453
1224686865563
2546548887735
4322674655533
""".trim();

late final List<String> data;
late final List<List<int>> processed;

final start = Point(0, 0);
late final Point<int> end;

Future<void> main() async {
  // data = await getData().toList();
  data = example.split("\n");

  processed = data
      .map((e) => e.split("").map(int.parse).toList())
      .toList();

  end = Point(processed.width - 1, processed.length - 1);

  final part1 = traverse();
  print(part1.totalHeatLoss - getBlockCost(start));
  // drawPath(part1.getPath().toList());
}

Node traverse() {
  final visited = {start.hashCode: Node(start)};

  while (true) {
    final current = visited.values
        .where((e) => !e.evaluated)
        .min((a, b) => a.totalHeatLoss.compareTo(b.totalHeatLoss))!;

    if (current.block == end) return current;

    current.evaluated = true;
    for (final node in current.nextNodes()) {
      final hash = hashObjects(node.getPath(4));
      final old = visited[hash];
      if (old == null || (!old.evaluated && old.totalHeatLoss > node.totalHeatLoss)) {
        visited[hash] = node;
      }
    }
  }
}

class Node {
  final Point<int> block;
  Node? parent;
  late int totalHeatLoss;
  bool evaluated = false;

  Node(this.block, [this.parent]) {
    totalHeatLoss = getBlockCost(block) + (parent?.totalHeatLoss ?? 0);
  }

  @override
  String toString() => "$block ($evaluated, $totalHeatLoss)";

  Iterable<Point<int>> getPath([int count = -1]) sync* {
    Node? node = this;
    for (int i = 0; i < count || count == -1; i++) {
      if (node == null) break;
      yield node.block;
      node = node.parent;
    }
  }

  List<Point<int>> _nextDirs() {
    final dirs = dirDelta.values.toList();
    if (parent == null) return dirs;

    // remove previous
    final prev = parent!.block - block;
    dirs.remove(prev);

    final last4 = getPath(4).toList();
    if (last4.length < 4) return dirs;

    if (last4.every((e) => e.x == block.x) ||
        last4.every((e) => e.y == block.y)) {
      dirs.remove(prev * -1);
    }

    return dirs;
  }

  Iterable<Node> nextNodes() => _nextDirs()
      .map((e) => e + block)
      .where((e) => isValid(e))
      .map((e) => Node(e, this));
}

int getBlockCost(Point<int> block) => processed[block.y][block.x];

bool isValid(Point<int> block) => processed.containsPoint(block);

void drawPath(List<Point<int>> path) {
  for (final (y, row) in processed.indexed) {
    final text = row.indexed
        .map((e) => path.contains(Point(e.$1, y)) ? "*" : e.$2)
        .join();
    print(text);
  }
}

// part 1: 859
// part 2:
