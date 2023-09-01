import 'dart:math';

class Funtions {
  static List<int> getRandomItems(int totalItems, int max) {
    final random = Random();
    final items = <int>[];

    while (items.length < totalItems) {
      final item = random.nextInt(max);
      if (!items.contains(item)) {
        items.add(item);
      }
    }

    return items;
  }
}
