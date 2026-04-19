enum Rank {
  two('2', 2, 1),
  three('3', 3, 1),
  four('4', 4, 1),
  five('5', 5, 1),
  six('6', 6, 1),
  seven('7', 7, 0),
  eight('8', 8, 0),
  nine('9', 9, 0),
  ten('10', 10, -1),
  jack('J', 10, -1),
  queen('Q', 10, -1),
  king('K', 10, -1),
  ace('A', 11, -1);

  final String label;
  final int value;
  final int hiLoValue;
  
  const Rank(this.label, this.value, this.hiLoValue);
  
  static Rank fromLabel(String label) {
    return Rank.values.firstWhere((e) => e.label == label);
  }
}
