import 'card_model.dart';

class DeckManager {
  final int initialDecks;
  Map<Rank, int> remainingCards;
  List<Rank> history;

  DeckManager({required this.initialDecks})
      : remainingCards = _initializeDeck(initialDecks),
        history = [];

  static Map<Rank, int> _initializeDeck(int decks) {
    return {
      for (var rank in Rank.values) rank: 4 * decks
    };
  }

  int get totalCardsRemaining {
    return remainingCards.values.fold(0, (sum, count) => sum + count);
  }

  void drawCard(Rank rank) {
    if (remainingCards[rank]! > 0) {
      remainingCards[rank] = remainingCards[rank]! - 1;
      history.add(rank);
      if (history.length > 50) {
        history.removeAt(0); // Maintain max 50 history
      }
    }
  }

  void undoDrawnCard() {
    if (history.isNotEmpty) {
      final lastCard = history.removeLast();
      remainingCards[lastCard] = remainingCards[lastCard]! + 1;
    }
  }
}
