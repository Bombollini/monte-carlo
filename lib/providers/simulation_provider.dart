import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../engine/probability_engine.dart';
import 'game_provider.dart';

final simulationProvider = FutureProvider<ProbabilityResult>((ref) async {
  final gameState = ref.watch(gameStateProvider);
  
  final input = SimulationInput(
    gameState.remainingCards,
    gameState.playerTotal,
    gameState.dealerRank,
  );

  // We use compute to run Monte Carlo in another thread to avoid jank
  final result = await compute<SimulationInput, ProbabilityResult>(ProbabilityEngine.simulate, input);
  return result;
});
