import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/game_provider.dart';
import '../theme.dart';

class GroupProbabilityGrid extends ConsumerWidget {
  const GroupProbabilityGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateProvider);

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.8,
      children: [
        _buildGroupCard(
          context,
          'SMALL (2-5)',
          gameState.smallProb,
          AppTheme.neonGreen,
        ),
        _buildGroupCard(
          context,
          'MEDIUM (6-8)',
          gameState.mediumProb,
          AppTheme.digitalGold,
        ),
        _buildGroupCard(
          context,
          'LARGE (9-K)',
          gameState.largeProb,
          AppTheme.vibrantRed,
        ),
        _buildGroupCard(
          context,
          'ACES (A)',
          gameState.aceProb,
          Colors.lightBlueAccent,
        ),
      ],
    );
  }

  Widget _buildGroupCard(BuildContext context, String label, double prob, Color color) {
    final percentage = (prob * 100).toStringAsFixed(1);
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$percentage%',
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.query_stats, size: 16, color: color.withValues(alpha: 0.3)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: prob,
              backgroundColor: Colors.white.withValues(alpha: 0.05),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }
}
