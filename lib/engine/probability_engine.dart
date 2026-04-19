import 'dart:math';
import 'card_model.dart';

class ProbabilityResult {
  final double dealer17;
  final double dealer18;
  final double dealer19;
  final double dealer20;
  final double dealer21;
  final double dealerBust;
  final double hitWinProb;
  final double standWinProb;
  
  ProbabilityResult({
    required this.dealer17,
    required this.dealer18,
    required this.dealer19,
    required this.dealer20,
    required this.dealer21,
    required this.dealerBust,
    required this.hitWinProb,
    required this.standWinProb,
  });

  String get recommendation {
    if (hitWinProb > standWinProb + 0.05) return 'HIT';
    if (standWinProb > hitWinProb) return 'STAND';
    return 'DOUBLE / HIT';
  }
}

class SimulationInput {
  final Map<Rank, int> remainingCards;
  final int playerTotal;
  final Rank? dealerUpcard;

  SimulationInput(this.remainingCards, this.playerTotal, this.dealerUpcard);
}

class ProbabilityEngine {
  static ProbabilityResult simulate(SimulationInput input) {
    const int iterations = 4000;
    final Map<Rank, int> remainingCards = input.remainingCards;
    final int playerTotal = input.playerTotal;
    final Rank? dealerUpcard = input.dealerUpcard;

    List<int> deck = [];
    remainingCards.forEach((rank, count) {
      for (int i = 0; i < count; i++) {
        deck.add(rank.value);
      }
    });

    if (deck.length < 2) {
      return ProbabilityResult(
        dealer17: 0, dealer18: 0, dealer19: 0, dealer20: 0, dealer21: 0, dealerBust: 0,
        hitWinProb: 0, standWinProb: 0,
      );
    }

    int d17=0, d18=0, d19=0, d20=0, d21=0, bustCount=0;
    int standWins = 0;
    int hitWins = 0;
    final rand = Random();

    for (int i = 0; i < iterations; i++) {
      // STAND SIMULATION (What if we stand now?)
      int dealerFinal = _simulateDealerHand(deck, dealerUpcard?.value, rand);
      if (dealerFinal > 21 || (playerTotal <= 21 && dealerFinal < playerTotal)) {
        standWins++;
      }

      // HIT SIMULATION (What if we hit once and then stand?)
      // Note: A real HIT strategy is more complex, but this gives a good relative indicator.
      List<int> simDeck = List.from(deck);
      int cardIdx = rand.nextInt(simDeck.length);
      int drawnCard = simDeck.removeAt(cardIdx);
      int newPlayerTotal = playerTotal + drawnCard;
      if (drawnCard == 11 && newPlayerTotal > 21) newPlayerTotal -= 10;

      if (newPlayerTotal <= 21) {
        int dealerFinalAfterHit = _simulateDealerHand(simDeck, dealerUpcard?.value, rand);
        if (dealerFinalAfterHit > 21 || dealerFinalAfterHit < newPlayerTotal) {
          hitWins++;
        }
      }

      // Statistics for dealer outcomes
      if (dealerFinal == 17) d17++;
      else if (dealerFinal == 18) d18++;
      else if (dealerFinal == 19) d19++;
      else if (dealerFinal == 20) d20++;
      else if (dealerFinal == 21) d21++;
      else if (dealerFinal > 21) bustCount++;
    }

    return ProbabilityResult(
      dealer17: d17 / iterations,
      dealer18: d18 / iterations,
      dealer19: d19 / iterations,
      dealer20: d20 / iterations,
      dealer21: d21 / iterations,
      dealerBust: bustCount / iterations,
      hitWinProb: hitWins / iterations,
      standWinProb: standWins / iterations,
    );
  }

  static int _simulateDealerHand(List<int> deck, int? upcardValue, Random rand) {
    List<int> simDeck = List.from(deck);
    int total = 0;
    int aces = 0;

    // Use upcard if available, otherwise draw one.
    if (upcardValue != null) {
      total = upcardValue;
      if (total == 11) aces++;
    } else {
      if (simDeck.isEmpty) return 0;
      int idx = rand.nextInt(simDeck.length);
      int val = simDeck.removeAt(idx);
      total = val;
      if (val == 11) aces++;
    }

    // Dealer draws until 17 or more
    while (total < 17) {
      if (simDeck.isEmpty) break;
      int idx = rand.nextInt(simDeck.length);
      int val = simDeck.removeAt(idx);
      total += val;
      if (val == 11) aces++;
      
      while (total > 21 && aces > 0) {
        total -= 10;
        aces--;
      }
    }
    return total;
  }
}
