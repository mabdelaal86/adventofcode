import 'dart:math';

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
final cache = <Point<int>, int>{};

final start = Point(0, 0);
late Point<int> end;
int minCosts = 0;

Future<void> main() async {
  // data = await getData().toList();
  data = example.split("\n");

  processed = data
      .map((e) => e.split("").map(int.parse).toList())
      .toList();

  end = Point(processed.width - 1, processed.length - 1);

  minCosts = 999999999999999999;
  final part1 = cacheTraverse([start], 0);
  print(part1);
}

int cacheTraverse(List<Point<int>> path, int costs) => cache[path.first] ??= traverse(path, costs); //

int traverse(List<Point<int>> path, int costs) {
  if (path.first == end) {
    minCosts = costs;
    print("** $costs");
    return 0;
  }

  int minHeatLoss = 999999999999999999;
  for (final block in nextBlocks(path)) {
    final blockCost = getBlockCost(block);
    final newCost = costs + blockCost;
    if (newCost >= minCosts) continue;
    path.insert(0, block);
    final pathLoss = blockCost + cacheTraverse(path, newCost);
    path.removeAt(0);
    minHeatLoss = min(minHeatLoss, pathLoss);
  }

  return minHeatLoss;
}

int getBlockCost(Point<int> block) => processed[block.y][block.x];

List<Point<int>> nextBlocks(List<Point<int>> path) => nextDirs(path)
    .map((e) => e + path[0])
    .where((e) => processed.containsPoint(e))
    .where((e) => !path.contains(e))
    .toList();

List<Point<int>> nextDirs(List<Point<int>> path) {
  final dirs = dirDelta.values.toList();
  if (path.length == 1) return dirs;

  // remove previous
  final prev = path[1] - path[0];
  dirs.remove(prev);

  if (path.length < 4) return dirs;

  final last4 = path.sublist(0, 4);
  if (last4.every((e) => e.x == path[0].x) || last4.every((e) => e.y == path[0].y)) {
    dirs.remove(prev * -1);
  }

  return dirs;
}

// part 1:
// part 2:
