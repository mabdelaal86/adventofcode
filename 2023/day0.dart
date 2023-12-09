import 'common.dart';

late final List<String> data;

final example = r"""

""".trim();

Future<void> main() async {
  // data = await getData("data/day0.txt").toList();
  data = example.split("\n");
  for (final item in data) print(item);
}

// part 1:
// part 2:
