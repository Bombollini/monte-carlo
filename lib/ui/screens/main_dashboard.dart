import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../engine/card_model.dart';
import '../../providers/game_provider.dart';
import '../theme.dart';
import '../widgets/probability_cards.dart';
import '../widgets/deck_inventory_grid.dart';
import '../widgets/floating_input_utility.dart';
import '../../ui/widgets/group_probability_grid.dart';
import '../widgets/side_bet_panel.dart';

class MainDashboard extends ConsumerWidget {
  const MainDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Shoe: ${gameState.initialDecks} | Cards: ${gameState.totalRemaining}',
            style: const TextStyle(fontSize: 14, color: Colors.white70),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined, color: Colors.white54),
              onPressed: () => ref.read(gameStateProvider.notifier).clearHands(),
              tooltip: 'Clear Hands',
            ),
            IconButton(
              icon: const Icon(Icons.undo, color: AppTheme.digitalGold),
              onPressed: () => ref.read(gameStateProvider.notifier).undo(),
            ),
            IconButton(
              icon: const Icon(Icons.refresh, color: AppTheme.vibrantRed),
              onPressed: () {
                ref.invalidate(deckManagerProvider);
                ref.invalidate(gameStateProvider);
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'DASHBOARD', icon: Icon(Icons.dashboard_outlined, size: 18)),
              Tab(text: 'INVENTORY', icon: Icon(Icons.inventory_2_outlined, size: 18)),
            ],
            indicatorColor: AppTheme.neonGreen,
            labelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: TabBarView(
                  children: [
                    _buildHomeView(context, ref, gameState),
                    _buildInventoryView(context, ref, gameState),
                  ],
                ),
              ),
              const FloatingInputUtility(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHomeView(BuildContext context, WidgetRef ref, DeckState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildHandContextRow(context, ref, state),
          const SizedBox(height: 16),
          const SideBetPanel(),
          const SizedBox(height: 16),
          const ProbabilityCards(),
          const SizedBox(height: 16),
          const GroupProbabilityGrid(),
        ],
      ),
    );
  }

  Widget _buildInventoryView(BuildContext context, WidgetRef ref, DeckState state) {
    return Column(
      children: const [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: DeckInventoryGrid(),
          ),
        ),
      ],
    );
  }

  Widget _buildHandContextRow(BuildContext context, WidgetRef ref, DeckState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildHandDisplay(
              context,
              'PLAYER HAND',
              state.playerHand,
              state.playerTotal,
              state.bustProbability,
              state.inputFocus == InputFocus.player,
              () => ref.read(gameStateProvider.notifier).setInputFocus(InputFocus.player),
              Colors.white,
            ),
          ),
          Container(width: 1, height: 40, color: Colors.white10),
          Expanded(
            child: _buildHandDisplay(
              context,
              'DEALER HAND',
              state.dealerHand,
              state.dealerTotal,
              0, // No bust probability for dealer display here
              state.inputFocus == InputFocus.dealer,
              () => ref.read(gameStateProvider.notifier).setInputFocus(InputFocus.dealer),
              AppTheme.digitalGold,
              isDealer: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandDisplay(
    BuildContext context,
    String label,
    List<Rank> hand,
    int total,
    double bustProb,
    bool isSelected,
    VoidCallback onTap,
    Color color, {
    bool isDealer = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withValues(alpha: 0.05) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? color.withValues(alpha: 0.3) : Colors.transparent),
        ),
        child: Column(
          crossAxisAlignment: isDealer ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 9, color: Colors.white54, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: isDealer ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                if (!isDealer) ...[
                  Text(
                    total == 0 ? '--' : '$total',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: isDealer,
                    child: Row(
                      children: hand.map((r) => Padding(
                        padding: EdgeInsets.only(left: isDealer ? 4 : 0, right: isDealer ? 0 : 4),
                        child: Text(r.label, style: const TextStyle(color: Colors.white38, fontSize: 12)),
                      )).toList(),
                    ),
                  ),
                ),
                if (isDealer) ...[
                  const SizedBox(width: 8),
                  Text(
                    total == 0 ? '--' : '$total',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
                  ),
                ],
              ],
            ),
            if (!isDealer)
              Text(
                'Bust: ${(bustProb * 100).toStringAsFixed(1)}%',
                style: TextStyle(fontSize: 10, color: bustProb > 0.5 ? AppTheme.vibrantRed : AppTheme.neonGreen),
              )
            else
              const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
