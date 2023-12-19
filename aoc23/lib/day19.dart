import 'common.dart';

final example = r"""
px{a<2006:qkq,m>2090:A,rfg}
pv{a>1716:R,A}
lnx{m>1548:A,A}
rfg{s<537:gd,x>2440:R,A}
qs{s>3448:A,lnx}
qkq{x<1416:A,crn}
crn{x>2662:A,R}
in{s<1351:px,qqz}
qqz{s>2770:qs,m<1801:hdj,R}
gd{a>3333:R,R}
hdj{m>838:A,pv}

{x=787,m=2655,a=1222,s=2876}
{x=1679,m=44,a=2067,s=496}
{x=2036,m=264,a=79,s=2244}
{x=2461,m=1339,a=466,s=291}
{x=2127,m=1623,a=2188,s=1013}
""".trim();

late final List<String> data;

Future<void> main() async {
  data = await getData().toList();
  // data = example.split("\n");
  final emptyIndex = data.indexOf("");

  final workflows = parseWorkflows(data.sublist(0, emptyIndex));
  final parts = data.sublist(emptyIndex + 1).map(parsePart);

  final part1 = parts
      .where((e) => check(e, workflows))
      .map((e) => e.values.sum())
      .sum();
  print(part1);
}

Map<String, int> parsePart(String input) {
  return input.substring(1, input.length - 1).split(",")
      .map((e) => e.split("="))
      .map((e) => (e[0], int.parse(e[1])))
      .toMap();
}

Map<String, Workflow> parseWorkflows(Iterable<String> inputs) {
  final re = RegExp(r"^(\w+)\{(.+)}$");
  final res = <String, Workflow>{};
  for (final input in inputs) {
    final m = re.firstMatch(input)!;
    res[m[1]!] = Workflow.parse(m[2]!);
  }
  return inputs
      .map((e) => re.firstMatch(e)!)
      .map((m) => (m[1]!, Workflow.parse(m[2]!)))
      .toMap();
}

class Workflow {
  final List<Rule> rules;
  final String defaultRes;

  Workflow(this.rules, this.defaultRes);

  factory Workflow.parse(String input) {
    final parts = input.split(",");
    final defaultRes = parts.removeLast();
    final rules = parts.map(Rule.parse).toList();
    return Workflow(rules, defaultRes);
  }

  String evaluate(Map<String, int> item) {
    for (final rule in rules) {
      if (rule.evaluate(item) case String res) return res;
    }
    return defaultRes;
  }
}

class Rule {
  final String property;
  final int value;
  final String result;
  final bool Function(int, int) operation;

  Rule(this.property, this.value, this.result, this.operation);

  static bool lessThan(int a, int b) => a < b;
  static bool greatThan(int a, int b) => a > b;
  static RegExp ruleRe = RegExp(r"^(\w)([<>])(\d+):(\w+)$");

  factory Rule.parse(String input) {
    final m = ruleRe.firstMatch(input)!;
    return Rule(m[1]!, int.parse(m[3]!), m[4]!, m[2]! == "<" ? lessThan : greatThan);
  }
  
  String? evaluate(Map<String, int> item) => operation(item[property]!, value) ? result : null;
}

bool check(Map<String, int> item, Map<String, Workflow> workflows) {
  Workflow workflow = workflows["in"]!;
  while (true) {
    final res = workflow.evaluate(item);
    if (res == "A") return true;
    if (res == "R") return false;
    workflow = workflows[res]!;
  }
}

// part 1:
// part 2:
