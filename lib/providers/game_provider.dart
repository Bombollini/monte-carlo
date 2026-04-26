import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../engine/card_model.dart';
import '../engine/deck_manager.dart';

class DeckCountNotifier extends Notifier<int> {
  @override
  int build() => 6; // default 6 decks
  void setDecks(int value) => state = value;
}

final deckCountProvider = NotifierProvider<DeckCountNotifier, int>(DeckCountNotifier.new);

enum InputFocus { none, player, dealer }

class DeckState {
  final Map<Rank, int> remainingCards;
  final int totalRemaining;
  final int initialDecks;
  final int runningCount;
  final double trueCount;
  final List<Rank> playerHand;
  final int playerTotal;
  final List<Rank> dealerHand;
  final int dealerTotal;
  final InputFocus inputFocus;
  final double bustProbability;
  final double smallProb;
  final double mediumProb;
  final double largeProb;
  final double aceProb;
  final double pairProb;
  final double straightProb;
  final double luckySevenProb;

  DeckState({
    required this.remainingCards,
    required this.totalRemaining,
    required this.initialDecks,
    required this.runningCount,
    required this.trueCount,
    this.playerHand = const [],
    this.playerTotal = 0,
    this.dealerHand = const [],
    this.dealerTotal = 0,
    this.inputFocus = InputFocus.none,
    this.bustProbability = 0,
    this.smallProb = 0,
    this.mediumProb = 0,
    this.largeProb = 0,
    this.aceProb = 0,
    this.pairProb = 0,
    this.straightProb = 0,
    this.luckySevenProb = 0,
  });

  DeckState copyWith({
    List<Rank>? playerHand,
    List<Rank>? dealerHand,
    InputFocus? inputFocus,
  }) {
    return DeckState(
      remainingCards: remainingCards,
      totalRemaining: totalRemaining,
      initialDecks: initialDecks,
      runningCount: runningCount,
      trueCount: trueCount,
      playerHand: playerHand ?? this.playerHand,
      playerTotal: playerTotal,
      dealerHand: dealerHand ?? this.dealerHand,
      dealerTotal: dealerTotal,
      inputFocus: inputFocus ?? this.inputFocus,
      bustProbability: bustProbability,
      smallProb: smallProb,
      mediumProb: mediumProb,
      largeProb: largeProb,
      aceProb: aceProb,
      pairProb: pairProb,
      straightProb: straightProb,
      luckySevenProb: luckySevenProb,
    );
  }
}

class GameStateNotifier extends Notifier<DeckState> {
  // DeckManager is owned here — never re-created by a Provider on rebuild.
  late DeckManager _manager;

  @override
  DeckState build() {
    final decks = ref.watch(deckCountProvider);
    // Only rebuild the manager when deck count actually changes.
    _manager = DeckManager(initialDecks: decks);
    return _createState([], [], InputFocus.none);
  }

  int _calculateTotal(List<Rank> hand) {
    int total = 0;
    int aces = 0;
    for (var r in hand) {
      if (r == Rank.ace) {
        aces++;
        total += 11;
      } else {
        total += r.value;
      }
    }
    while (total > 21 && aces > 0) {
      total -= 10;
      aces--;
    }
    return total;
  }

  DeckState _createState(List<Rank> playerHand, List<Rank> dealerHand, InputFocus focus) {
    int runningCount = 0;
    for (var card in _manager.history) {
      runningCount += card.hiLoValue;
    }

    int remainingCardsCount = _manager.totalCardsRemaining;
    double decksRemaining = remainingCardsCount / 52.0;
    double trueCount = decksRemaining == 0 ? 0 : runningCount / decksRemaining;

    int playerTotal = _calculateTotal(playerHand);
    int dealerTotal = _calculateTotal(dealerHand);
    int bustCards = 0;
    int smallCount = 0;
    int mediumCount = 0;
    int largeCount = 0;
    int aceCount = 0;

    _manager.remainingCards.forEach((Rank rank, int count) {
      // Group Probabilities
      if (rank == Rank.ace) {
        aceCount += count;
      } else if (rank.value >= 9) {
        largeCount += count;
      } else if (rank.value >= 6) {
        mediumCount += count;
      } else {
        smallCount += count;
      }

      // Bust Probability
      if (playerTotal < 21) {
        int effectiveValue = rank.value;
        if (rank == Rank.ace) effectiveValue = 1;
        if (playerTotal + effectiveValue > 21) {
          bustCards += count;
        }
      }
    });

    if (playerTotal >= 21 && playerHand.isNotEmpty) {
      bustCards = remainingCardsCount;
    }

    double bustProbability = remainingCardsCount == 0 ? 0 : bustCards / remainingCardsCount;
    double smallProb = remainingCardsCount == 0 ? 0 : smallCount / remainingCardsCount;
    double mediumProb = remainingCardsCount == 0 ? 0 : mediumCount / remainingCardsCount;
    double largeProb = remainingCardsCount == 0 ? 0 : largeCount / remainingCardsCount;
    double aceProb = remainingCardsCount == 0 ? 0 : aceCount / remainingCardsCount;

    // Side Bets
    double pairProb = 0;
    double straightProb = 0;
    double luckySevenProb = remainingCardsCount == 0 ? 0 : (_manager.remainingCards[Rank.seven] ?? 0) / remainingCardsCount;

    if (playerHand.length == 1) {
      final r = playerHand[0];
      pairProb = (_manager.remainingCards[r] ?? 0) / (remainingCardsCount == 0 ? 1 : remainingCardsCount);

      int neighbors = 0;
      // Straight neighbors (+1 or -1)
      final allRanks = Rank.values;
      final idx = allRanks.indexOf(r);
      if (idx > 0) neighbors += _manager.remainingCards[allRanks[idx - 1]] ?? 0;
      if (idx < allRanks.length - 1) neighbors += _manager.remainingCards[allRanks[idx + 1]] ?? 0;
      straightProb = neighbors / (remainingCardsCount == 0 ? 1 : remainingCardsCount);
    } else if (playerHand.isEmpty) {
      // General pair chance (any pair in next 2)
      double sum = 0;
      if (remainingCardsCount > 1) {
        _manager.remainingCards.forEach((r, count) {
          sum += (count / remainingCardsCount) * ((count - 1) / (remainingCardsCount - 1));
        });
      }
      pairProb = sum;
    }

    return DeckState(
      remainingCards: Map.from(_manager.remainingCards),
      totalRemaining: remainingCardsCount,
      initialDecks: _manager.initialDecks,
      runningCount: runningCount,
      trueCount: trueCount,
      playerHand: List.from(playerHand),
      playerTotal: playerTotal,
      dealerHand: List.from(dealerHand),
      dealerTotal: dealerTotal,
      inputFocus: focus,
      bustProbability: bustProbability,
      smallProb: smallProb,
      mediumProb: mediumProb,
      largeProb: largeProb,
      aceProb: aceProb,
      pairProb: pairProb,
      straightProb: straightProb,
      luckySevenProb: luckySevenProb,
    );
  }

  void drawCard(Rank rank) {
    List<Rank> nextPlayerHand = List.from(state.playerHand);
    List<Rank> nextDealerHand = List.from(state.dealerHand);

    if (state.inputFocus == InputFocus.player) {
      nextPlayerHand.add(rank);
    } else if (state.inputFocus == InputFocus.dealer) {
      nextDealerHand.add(rank);
    }

    _manager.drawCard(rank);
    state = _createState(nextPlayerHand, nextDealerHand, state.inputFocus);
  }

  void undo() {
    if (_manager.history.isEmpty) return;

    final lastRank = _manager.history.last;
    List<Rank> nextPlayerHand = List.from(state.playerHand);
    List<Rank> nextDealerHand = List.from(state.dealerHand);

    if (nextDealerHand.isNotEmpty && nextDealerHand.last == lastRank) {
      nextDealerHand.removeLast();
    } else if (nextPlayerHand.isNotEmpty && nextPlayerHand.last == lastRank) {
      nextPlayerHand.removeLast();
    }

    _manager.undoDrawnCard();
    state = _createState(nextPlayerHand, nextDealerHand, state.inputFocus);
  }

  void setInputFocus(InputFocus focus) {
    state = state.copyWith(inputFocus: focus);
  }

  void clearHands() {
    state = _createState([], [], state.inputFocus);
  }

  void setDealerRank(Rank? rank) {
    if (rank == null) {
      state = _createState(state.playerHand, [], state.inputFocus);
    } else {
      state = _createState(state.playerHand, [rank], state.inputFocus);
    }
  }
}

final gameStateProvider = NotifierProvider<GameStateNotifier, DeckState>(GameStateNotifier.new);
