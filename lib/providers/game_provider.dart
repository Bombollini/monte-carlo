import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../engine/card_model.dart';
import '../engine/deck_manager.dart';

class DeckCountNotifier extends Notifier<int> {
  @override
  int build() => 6; // default 6 decks
  void setDecks(int value) => state = value;
}

final deckCountProvider = NotifierProvider<DeckCountNotifier, int>(DeckCountNotifier.new);

final deckManagerProvider = Provider<DeckManager>((ref) {
  final decks = ref.watch(deckCountProvider);
  return DeckManager(initialDecks: decks);
});

class DeckState {
  final Map<Rank, int> remainingCards;
  final int totalRemaining;
  final int initialDecks;
  final int runningCount;
  final double trueCount;
  final int playerTotal;
  final Rank? dealerRank;

  DeckState({
    required this.remainingCards,
    required this.totalRemaining,
    required this.initialDecks,
    required this.runningCount,
    required this.trueCount,
    this.playerTotal = 0,
    this.dealerRank,
  });
}

class GameStateNotifier extends Notifier<DeckState> {
  @override
  DeckState build() {
    final manager = ref.watch(deckManagerProvider);
    return _createState(manager, 0, null);
  }

  DeckState _createState(DeckManager manager, int playerTotal, Rank? dealerRank) {
    int runningCount = 0;
    for (var card in manager.history) {
      runningCount += card.hiLoValue;
    }
    
    int remainingCardsCount = manager.totalCardsRemaining;
    double decksRemaining = remainingCardsCount / 52.0;
    double trueCount = decksRemaining == 0 ? 0 : runningCount / decksRemaining;

    return DeckState(
      remainingCards: Map.from(manager.remainingCards),
      totalRemaining: remainingCardsCount,
      initialDecks: manager.initialDecks,
      runningCount: runningCount,
      trueCount: trueCount,
      playerTotal: playerTotal,
      dealerRank: dealerRank,
    );
  }

  void drawCard(Rank rank) {
    final manager = ref.read(deckManagerProvider);
    manager.drawCard(rank);
    state = _createState(manager, state.playerTotal, state.dealerRank);
  }

  void undo() {
    final manager = ref.read(deckManagerProvider);
    manager.undoDrawnCard();
    state = _createState(manager, state.playerTotal, state.dealerRank);
  }

  void setPlayerTotal(int total) {
    state = _createState(ref.read(deckManagerProvider), total, state.dealerRank);
  }

  void setDealerRank(Rank? rank) {
    state = _createState(ref.read(deckManagerProvider), state.playerTotal, rank);
  }
}

final gameStateProvider = NotifierProvider<GameStateNotifier, DeckState>(GameStateNotifier.new);
