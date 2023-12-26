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

  final part1 = traverse1();
  print(part1.heatLoss);
}

Node traverse1() {
  final startNodes = [
    Node(Point(1, 0), Dir.e, 1),
    Node(Point(0, 1), Dir.s, 1),
  ];
  final visited = { for (final node in startNodes) node.hashCode: node };

  while (true) {
    final current = visited.values
        .where((e) => !e.evaluated)
        .min((a, b) => a.heatLoss.compareTo(b.heatLoss))!;

    if (current.block == end) return current;

    current.evaluated = true;
    for (final node in current.nextNodes1()) {
      final hash = node.hashCode;
      final old = visited[hash];
      if (old == null || (!old.evaluated && old.heatLoss > node.heatLoss)) {
        visited[hash] = node;
      }
    }
  }
}

class Node {
  final Point<int> block;
  late int heatLoss;
  bool evaluated = false;
  Dir dir;
  int steps;

  Node(this.block, this.dir, this.steps, [int totalHeatLoss = 0]) {
    heatLoss = getBlockCost(block) + totalHeatLoss;
  }

  @override
  String toString() => "$block ($evaluated, $heatLoss)";

  List<Dir> _nextDirs1() {
    const reverseDir = {
      Dir.n: Dir.s, Dir.s: Dir.n,
      Dir.w: Dir.e, Dir.e: Dir.w,
    };

    final dirs = dirDelta.keys.toList();
    dirs.remove(reverseDir[dir]); // no go back
    if (steps == 3) dirs.remove(dir);

    return dirs;
  }

  Iterable<Node> nextNodes1() sync* {
    for (final nextDir in _nextDirs1()) {
      final nextBlock = dirDelta[nextDir]! + block;
      if (!isValid(nextBlock)) continue;
      yield Node(nextBlock, nextDir, nextDir == dir ? steps + 1 : 1, heatLoss);
    }
  }

  @override
  int get hashCode => hash3(block, dir, steps);
}

int getBlockCost(Point<int> block) => processed[block.y][block.x];

bool isValid(Point<int> block) => processed.containsPoint(block);

// part 1: 859
// part 2:
