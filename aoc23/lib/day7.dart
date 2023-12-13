import 'dart:core';

import 'common.dart';

late final List<String> data;

final example = r"""
32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
""".trim();

const allCards1 = "23456789TJQKA";
const allCards2 = "J23456789TQKA";
const handSize = 5;
final jokerCode = "J".runes.first;

class Hand implements Comparable<Hand> {
  final String cardOrder;
  final String cards;
  final int bid;
  final int value;

  Hand(this.cardOrder, this.cards, this.bid, this.value);

  @override
  int compareTo(Hand other) => value != other.value
      ? value.compareTo(other.value)
      : compareCards(other);

  int compareCards(Hand other) {
    for (var i = 0; i < handSize; i++) {
      final c1 = cardOrder.indexOf(cards[i]),
            c2 = cardOrder.indexOf(other.cards[i]);
      if (c1 != c2) {
        return c1.compareTo(c2);
      }
    }
    print("Both equals");
    return 0;
  }

  @override
  String toString() => "$cards($value)";
}

Future<void> main() async {
  data = await getData().toList();
  // data = example.split("\n");
  // for (final item in data) print(item);

  final hands1 = data.map(toHand1).toList()..sort();
  print(hands1);
  final part1 = hands1.indexed.map((e) => (e.$1 + 1) * e.$2.bid).sum();
  print(part1);
  // 247749553
  // 248559379

  final hands2 = data.map(toHand2).toList()..sort();
  // print(hands2);
  final part2 = hands2.indexed.map((e) => (e.$1 + 1) * e.$2.bid).sum();
  print(part2);
}

Hand toHand1(String e) {
  final parts = e.split(" ");
  final value = typeValue(countCards(parts[0]));
  return Hand(allCards1, parts[0], int.parse(parts[1]), value);
}

Hand toHand2(String e) {
  final parts = e.split(" ");
  final value = typeValue(handleJoker(parts[0]));
  return Hand(allCards2, parts[0], int.parse(parts[1]), value);
}

List<int> countCards(String hand) {
  final counts = <int, int>{};
  for (final ch in hand.runes) {
    counts[ch] = (counts[ch] ?? 0) + 1;
  }
  return counts.values.toList()..sort();
}

int typeValue(List<int> counts) {
  return switch (counts) {
    [5] => 7,
    [1, 4] => 6,
    [2, 3] => 5,
    [1, 1, 3] => 4,
    [1, 2, 2] => 3,
    [1, 1, 1, 2] => 2,
    _ => 1,
  };
}

List<int> handleJoker(String hand) {
  final jokerCount = hand.runes.where((e) => e == jokerCode).length;
  return switch (countCards(hand)) {
    final c when jokerCount == 0 => c,
    [1, 4] => [5],
    [2, 3] => [5],
    [1, 1, 3] => [1, 4],
    [1, 2, 2] => jokerCount == 2 ? [1, 4] : [2, 3],
    [1, 1, 1, 2] => [1, 1, 3],
    [1, 1, 1, 1, 1] => [1, 1, 1, 2],
    final c => c,
  };
}
