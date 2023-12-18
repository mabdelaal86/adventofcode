import 'common.dart';

final example = r"""

""".trim();

late final List<String> data;

Future<void> main() async {
  data = await getData().toList();
  data = example.split("\n");
}

// part 1:
// part 2:
