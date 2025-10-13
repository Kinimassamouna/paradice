import 'dart:math';

abstract class DicePool {
  final int sides;
  final Random _random = Random();

  DicePool(this.sides);

  int roll() => _random.nextInt(sides) + 1;

  List<int> rollMultiple(int count) {
    return List.generate(count, (_) => roll());
  }
}

class DicePool6 extends DicePool {
  DicePool6() : super(6);
}

class DicePool10 extends DicePool {
  DicePool10() : super(10);
}

class DicePool20 extends DicePool {
  DicePool20() : super(20);
}

class DicePool100 extends DicePool {
  DicePool100() : super(100);
}
