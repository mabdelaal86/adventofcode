import 'dart:collection';

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
final queue = Queue<Message>();
final counts = {Pulse.low: 0, Pulse.high: 0};
final modules = <String, Module>{};
bool rx = false;

Future<void> main() async {
  data = await getData().toList();
  // data = example1.split("\n");
  // data = example2.split("\n");

  parse();
  print(modules.length);
  print(("rx??", modules["rx"]));

  // part 1
  // for (final _ in 1000.range) {
  //   pushButton();
  //   // print("-----");
  // }
  // print(counts);
  // print(counts.values.mul());

  // part 2
  int part2 = 0;
  while (!rx) {
    pushButton();
    part2++;
  }
  print("rx: $part2");
}

void parse() {
  final senders = <String, List<String>>{};
  for (final line in data) {
    final (name, receivers) = parseLine(line);
    final module = Module.parse(name, receivers);
    modules[module.name] = module;
    for (var e in receivers) {
      (senders[e] ??= []).add(module.name);
    }
  }
  for (var e in senders.entries) {
    final module = modules[e.key];
    if (module == null) {
      modules[e.key] = Module.parse(e.key, []);
    } else if (module is Conjunction) {
      module.memory = { for (final m in e.value) m : Pulse.low };
    }
  }
}

(String, List<String>) parseLine(String line) {
  final parts = line.split(" -> ");
  return (parts[0], parts[1].split(", "));
}

void pushButton() {
  modules["broadcaster"]!.send(Pulse.low);
  counts[Pulse.low] = counts[Pulse.low]! + 1;
  while (queue.isNotEmpty) {
    final msg = queue.removeFirst();
    // print(msg);
    counts[msg.pulse] = counts[msg.pulse]! + 1;
    modules[msg.receiver]?.receive(msg);
  }
}

enum Pulse {low, high}

class Message {
  final String sender;
  final String receiver;
  final Pulse pulse;

  Message(this.sender, this.receiver, this.pulse);

  @override
  String toString() => "Message ($sender -$pulse-> $receiver)";
}

class Module {
  final String name;
  final List<String> receivers;

  Module(this.name, this.receivers);

  void receive(Message msg) {}
  void send(Pulse pulse) {
    queue.addAll(receivers.map((e) => Message(name, e, pulse)));
  }

  factory Module.parse(String name, List<String> receivers) {
    if (name == "broadcaster") return Broadcast(name, receivers);
    if (name.startsWith("%")) return Flipflop(name.substring(1), receivers);
    if (name.startsWith("&")) return Conjunction(name.substring(1), receivers);
    if (name == "rx") return Rx(name, receivers);
    throw Exception("Unhandled module name ($name)");
  }

  @override
  String toString() => "Module ($name: $runtimeType)";
}

class Broadcast extends Module {
  Broadcast(super.name, super.receivers);

  @override
  void receive(Message msg) => send(msg.pulse);
}

class Flipflop extends Module {
  bool isOn = false;

  Flipflop(super.name, super.receivers);
  
  @override
  void receive(Message msg) {
    if (msg.pulse == Pulse.high) return;
    final wasOn = isOn;
    isOn = !isOn;
    send(wasOn ? Pulse.low : Pulse.high);
  }
}

class Conjunction extends Module {
  Map<String, Pulse> memory = {};

  Conjunction(super.name, super.receivers);

  @override
  void receive(Message msg) {
    memory[msg.sender] = msg.pulse;
    send(memory.values.allAre(Pulse.high) ? Pulse.low : Pulse.high);
  }
}

class Rx extends Module {
  Rx(super.name, super.receivers);

  @override
  void receive(Message msg) {
    // print("Rx: ${msg.pulse}");
    if (msg.pulse == Pulse.low) {
      rx = true;
    }
  }
}

// part 1: 825896364
// part 2:
