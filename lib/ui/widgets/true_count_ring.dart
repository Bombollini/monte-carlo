import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/game_provider.dart';
import '../theme.dart';

class TrueCountRing extends ConsumerWidget {
  const TrueCountRing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateProvider);
    final int runningCount = gameState.runningCount;
    final double trueCount = gameState.trueCount;

    Color countColor = AppTheme.digitalGold;
    if (runningCount > 0) countColor = AppTheme.neonGreen;
    if (runningCount < 0) countColor = AppTheme.vibrantRed;

    final String rcLabel = runningCount > 0 ? '+$runningCount' : '$runningCount';
    final String tcLabel =
        '${trueCount > 0 ? '+' : ''}${trueCount.toStringAsFixed(1)}';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        shape: BoxShape.circle,
        border: Border.all(color: countColor.withValues(alpha: 0.5), width: 2),
        boxShadow: [
          BoxShadow(
            color: countColor.withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: 5,
          )
        ],
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'HI-LO',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 10,
                letterSpacing: 2,
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                rcLabel,
                key: ValueKey(rcLabel),
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: countColor,
                      height: 1.2,
                    ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'TC: $tcLabel',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.4),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
