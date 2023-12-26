import 'dart:math';

import 'package:basics/basics.dart';
import 'package:quiver/core.dart';

import 'common.dart';

final example1 = r"""
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

final example2 = r"""
111111111111
999999999991
999999999991
999999999991
999999999991
""".trim();

late final List<String> data;
late final List<List<int>> processed;

final start = Point(0, 0);
late final Point<int> end;

Future<void> main() async {
  data = await getData().toList();
  // data = example1.split("\n");
  // data = example2.split("\n");

  processed = data
      .map((e) => e.split("").map(int.parse).toList())
      .toList();

  end = Point(processed.width - 1, processed.length - 1);

  // final part1 = traverse1();
  // print(part1.heatLoss);

  final part2 = traverse2();
  print(part2.heatLoss);
}

Node traverse1() {
  final startNodes = [Direction.east, Direction.south]
      .map((d) => (d, start + dirDelta[d]!))
      .map((e) => Node(e.$2, e.$1, 1, getBlockCost(e.$2)));
  return traverse(startNodes, (node) => node.nextNodes1());
}

Node traverse2() {
  final startNodes = [Direction.east, Direction.south]
      .map((d) => moveInDir(start, d, 4, 0)!);
  return traverse(startNodes, (node) => node.nextNodes2());
}

Node traverse(Iterable<Node> startNodes, Iterable<Node> Function(Node) nextNode) {
  final visited = { for (final node in startNodes) node.hashCode: node };

  while (true) {
    final current = visited.values
        .where((e) => !e.evaluated)
        .min((a, b) => a.heatLoss.compareTo(b.heatLoss))!;

    if (current.block == end) return current;

    current.evaluated = true;
    for (final node in nextNode(current)) {
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
  Direction dir;
  int steps;

  Node(this.block, this.dir, this.steps, this.heatLoss);

  @override
  String toString() => "$block ($evaluated, $heatLoss)";

  List<Direction> _nextDirs(int maxSteps) {
    const reverseDir = {
      Direction.north: Direction.south,
      Direction.south: Direction.north,
      Direction.west: Direction.east,
      Direction.east: Direction.west,
    };

    final dirs = dirDelta.keys.toList();
    dirs.remove(reverseDir[dir]); // no go back
    if (steps == maxSteps) dirs.remove(dir);

    return dirs;
  }

  Iterable<Node> nextNodes1() sync* {
    for (final nextDir in _nextDirs(3)) {
      final nextBlock = dirDelta[nextDir]! + block;
      if (!isValid(nextBlock)) continue;
      final nextSteps = nextDir == dir ? steps + 1 : 1;
      final totalHeatLoss = heatLoss + getBlockCost(nextBlock);
      yield Node(nextBlock, nextDir, nextSteps, totalHeatLoss);
    }
  }

  Iterable<Node> nextNodes2() sync* {
    for (final nextDir in _nextDirs(10)) {
      if (nextDir == dir) {
        final nextBlock = dirDelta[nextDir]! + block;
        if (!isValid(nextBlock)) continue;
        final totalHeatLoss = heatLoss + getBlockCost(nextBlock);
        yield Node(nextBlock, nextDir, steps + 1, totalHeatLoss);
      } else {
        final next = moveInDir(block, nextDir, 4, heatLoss);
        if (next != null) yield next;
      }
    }
  }

  @override
  int get hashCode => hash3(block, dir, steps);
}

Node? moveInDir(Point<int> start, Direction dir, int steps, int initHeatLoss) {
  int heatLoss = initHeatLoss;
  var block = start;
  for (var _ in steps.range) {
    block += dirDelta[dir]!;
    if (!isValid(block)) return null;
    heatLoss += getBlockCost(block);
  }
  return Node(block, dir, steps, heatLoss);
}

int getBlockCost(Point<int> block) => processed[block.y][block.x];

bool isValid(Point<int> block) => processed.containsPoint(block);

// part 1: 859
// part 2: 1027
