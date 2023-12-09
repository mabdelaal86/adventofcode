import 'common.dart';

late final List<String> data;

final example1 = r"""
RL

AAA = (BBB, CCC)
BBB = (DDD, EEE)
CCC = (ZZZ, GGG)
DDD = (DDD, DDD)
EEE = (EEE, EEE)
GGG = (GGG, GGG)
ZZZ = (ZZZ, ZZZ)
""".trim();

final example2 = r"""
LLR

AAA = (BBB, BBB)
BBB = (AAA, ZZZ)
ZZZ = (ZZZ, ZZZ)
""".trim();

final example3 = r"""
LR

11A = (11B, XXX)
11B = (XXX, 11Z)
11Z = (11B, XXX)
22A = (22B, XXX)
22B = (22C, 22C)
22C = (22Z, 22Z)
22Z = (22B, 22B)
XXX = (XXX, XXX)

""".trim();

final l = "L".runes.first;
final r = "R".runes.first;

late List<int> instructions;
late Map<String, List<String>> nodes;

List<String> extract(String line) => RegExp(r"\w+").allMatches(line).map((m) => m[0]!).toList();

int getSteps(String start) {
  int steps = 0;
  String curNode = start;
  // while (curNode != end) {
  while (!curNode.endsWith("Z")) {
    final inst = instructions[steps % instructions.length];
    curNode = nodes[curNode]![inst];
    steps += 1;
  }
  print(curNode);
  return steps;
}

int part2() {
  int steps = 0;
  List<String> curNodes = nodes.keys.where((e) => e.endsWith("A")).toList();
  // print(curNodes);
  while (!curNodes.every((e) => e.endsWith("Z"))) {
    // print(steps);
    final inst = instructions[steps % instructions.length];
    curNodes.indexed.forEach((e) => curNodes[e.$1] = nodes[e.$2]![inst]);
    // print(curNodes);
    steps += 1;
  }
  print(curNodes);
  return steps;
}

Future<void> main() async {
  data = await getData().toList();
  // data = example1.split("\n");
  // data = example2.split("\n");
  // data = example3.split("\n");
  // for (final item in data) print(item);

  instructions = data[0].runes.map((e) => e == l ? 0 : 1).toList();
  nodes = Map.fromIterable(
      data.skip(2).map(extract),
      key: (e) => e[0],
      value: (e) => [e[1], e[2]]);
  // print(nodes);

  final steps1 = getSteps("AAA");
  print(steps1);
  print("-------------");

  final allStarts = nodes.keys.where((e) => e.endsWith("A")).toList();
  print(allStarts);
  final allSteps = allStarts.map(getSteps);
  print(allSteps);
  // final steps2 = part2(instructions, nodes);
  // print("===================");
  // print(steps2);
}

// part 1: 23147
// part 2: 22289513667691
