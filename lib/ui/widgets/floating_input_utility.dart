import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/game_provider.dart';
import '../../engine/card_model.dart';
import '../theme.dart';

class FloatingInputUtility extends ConsumerWidget {
  const FloatingInputUtility({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Rank> inputOrder = [
      Rank.two, Rank.three, Rank.four, Rank.five, Rank.six,
      Rank.seven, Rank.eight, Rank.nine, Rank.ten, Rank.jack, 
      Rank.queen, Rank.king, Rank.ace
    ];
    
    // Note: Ten stands for 10, J, Q, K as they all share the same logic in standard counting.
    // For exact prob we should have 10, J, Q, K distinct or just treat any 10-value as 'Ten'.
    // The user's brief said 10, J, Q, K, A -> -1. We can just use "Ten" to deplete any 10-value card.
    // Actually, in blackjack Monte Carlo, whether it's 10, J, Q, or K, it's value 10.
    // But if we want exact inventory, tapping '10' removes one 10-value. 
    // We can map a tap on '10' to Rank.ten. So J,Q,K inventory won't drop, but for probability, we combine them.
    // Or we show T, J, Q, K distinct? For mobile fast input, usually you just tap "10" for any face card.
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppTheme.surface.withOpacity(0.9),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            offset: const Offset(0, -5),
            blurRadius: 20,
          )
        ],
      ),
      child: SafeArea(
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: inputOrder.map((rank) {
            final label = rank.label;
            
            Color accent = Colors.white24;
            if (rank.hiLoValue > 0) accent = AppTheme.neonGreen.withValues(alpha: 0.3);
            if (rank.hiLoValue < 0) accent = AppTheme.vibrantRed.withValues(alpha: 0.3);

            return InkWell(
              onTap: () {
                ref.read(gameStateProvider.notifier).drawCard(rank);
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: (MediaQuery.of(context).size.width - 90) / 5,
                height: 50,
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: accent),
                ),
                child: Center(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
