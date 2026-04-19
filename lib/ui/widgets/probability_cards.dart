import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/simulation_provider.dart';
import '../theme.dart';

class ProbabilityCards extends ConsumerWidget {
  const ProbabilityCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final simAsync = ref.watch(simulationProvider);

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surface.withOpacity(0.3),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: simAsync.when(
            skipLoadingOnReload: true,
            skipLoadingOnRefresh: true,
            data: (result) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'STRATEGIC ADVICE',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 10,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: result.recommendation == 'HIT' ? AppTheme.neonGreen.withOpacity(0.2) : AppTheme.vibrantRed.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          result.recommendation,
                          style: TextStyle(
                            color: result.recommendation == 'HIT' ? AppTheme.neonGreen : AppTheme.vibrantRed,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildProbBar('Hit Win', result.hitWinProb, AppTheme.neonGreen),
                  const SizedBox(height: 8),
                  _buildProbBar('Stand Win', result.standWinProb, AppTheme.digitalGold),
                  const Divider(height: 24, color: Colors.white10),
                  Text(
                    'DEALER OUTCOMES',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 10,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildProbBar('Bust', result.dealerBust, AppTheme.neonGreen),
                  const SizedBox(height: 8),
                  _buildProbBar('20/21', result.dealer20 + result.dealer21, AppTheme.vibrantRed),
                ],
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppTheme.digitalGold),
            ),
            error: (err, stack) => const Center(
              child: Text('Error', style: TextStyle(color: AppTheme.vibrantRed)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProbBar(String label, double prob, Color color) {
    final percentage = (prob * 100).toStringAsFixed(1);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '$percentage%',
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
          ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: prob,
            backgroundColor: Colors.white.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 4,
          ),
        ),
      ],
    );
  }
}
