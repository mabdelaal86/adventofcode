import 'common.dart';

late final List<String> data;

final example = r"""

""".trim();

Future<void> main() async {
  data = await getData().toList();
  data = example.split("\n");
}

// part 1:
// part 2:
