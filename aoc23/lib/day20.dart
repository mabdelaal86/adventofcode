import 'common.dart';

final example1 = r"""
broadcaster -> a, b, c
%a -> b
%b -> c
%c -> inv
&inv -> a
""".trim();

final example2 = r"""
broadcaster -> a
%a -> inv, con
&inv -> b
%b -> con
&con -> output
""".trim();

late final List<String> data;

Future<void> main() async {
  data = await getData().toList();
  data = example1.split("\n");
}

enum Pulse {low, high}

class Module {
  // Pulse recive(Pulse input);
}

// part 1:
// part 2:
