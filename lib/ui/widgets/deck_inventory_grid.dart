import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/game_provider.dart';
import '../../engine/card_model.dart';
import '../theme.dart';

class DeckInventoryGrid extends ConsumerWidget {
  const DeckInventoryGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateProvider);
    final remainingCards = gameState.remainingCards;
    final int totalRemaining = gameState.totalRemaining;

    // Ordered visually 2 to A
    final List<Rank> displayOrder = [
      Rank.two, Rank.three, Rank.four, Rank.five, Rank.six,
      Rank.seven, Rank.eight, Rank.nine, Rank.ten, Rank.jack,
      Rank.queen, Rank.king, Rank.ace
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 12.0),
          child: Text(
            'DECK INVENTORY',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 10,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.8,
            ),
            itemCount: displayOrder.length,
            itemBuilder: (context, index) {
              final rank = displayOrder[index];
              final count = remainingCards[rank] ?? 0;
              final double prob = totalRemaining == 0 ? 0 : (count / totalRemaining) * 100;
              
              Color accent = Colors.white24;
              if (rank.hiLoValue > 0) accent = AppTheme.neonGreen.withOpacity(count > 0 ? 0.3 : 0.05);
              if (rank.hiLoValue < 0) accent = AppTheme.vibrantRed.withOpacity(count > 0 ? 0.3 : 0.05);

              return Container(
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: accent),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      rank.label,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: count > 0 ? Colors.white : Colors.white24,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$count',
                      style: TextStyle(
                        color: count > 0 ? AppTheme.digitalGold : Colors.white24,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${prob.toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
