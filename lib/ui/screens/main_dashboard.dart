import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../engine/card_model.dart';
import '../../providers/game_provider.dart';
import '../theme.dart';
import '../widgets/true_count_ring.dart';
import '../widgets/probability_cards.dart';
import '../widgets/deck_inventory_grid.dart';
import '../widgets/floating_input_utility.dart';

class MainDashboard extends ConsumerWidget {
  const MainDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shoe: ${gameState.initialDecks} Decks | Cards: ${gameState.totalRemaining}',
          style: const TextStyle(fontSize: 14, color: Colors.white70),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo, color: AppTheme.digitalGold),
            onPressed: () {
              ref.read(gameStateProvider.notifier).undo();
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: AppTheme.vibrantRed),
            onPressed: () {
              ref.invalidate(deckManagerProvider);
              ref.invalidate(gameStateProvider);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 12),
              // Hand Context Row
              _buildHandContextRow(context, ref, gameState),
              const SizedBox(height: 12),
              const Row(
                children: [
                  Expanded(flex: 4, child: TrueCountRing()),
                  SizedBox(width: 16),
                  Expanded(flex: 5, child: ProbabilityCards()),
                ],
              ),
              const SizedBox(height: 20),
              const Expanded(
                child: DeckInventoryGrid(),
              ),
              const FloatingInputUtility(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHandContextRow(BuildContext context, WidgetRef ref, DeckState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildScorePicker(
              context,
              'MY TOTAL',
              state.playerTotal,
              (val) => ref.read(gameStateProvider.notifier).setPlayerTotal(val),
              Colors.white,
            ),
          ),
          Container(width: 1, height: 30, color: Colors.white10),
          Expanded(
            child: _buildDealerPicker(
              context,
              'DEALER',
              state.dealerRank,
              (rank) => ref.read(gameStateProvider.notifier).setDealerRank(rank as Rank?),
              AppTheme.digitalGold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScorePicker(BuildContext context, String label, int value, Function(int) onChanged, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 9, color: Colors.white54, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, size: 20, color: Colors.white24),
              onPressed: () => onChanged(value > 0 ? value - 1 : 0),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text('$value', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, size: 20, color: Colors.white24),
              onPressed: () => onChanged(value < 21 ? value + 1 : 21),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildDealerPicker(BuildContext context, String label, Rank? rank, Function(Rank?) onChanged, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: const TextStyle(fontSize: 9, color: Colors.white54, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        DropdownButton<Rank?>(
          value: rank,
          hint: const Text('UPCARD', style: TextStyle(fontSize: 12, color: Colors.white24)),
          dropdownColor: AppTheme.surface,
          underline: const SizedBox(),
          icon: const Icon(Icons.arrow_drop_down, color: AppTheme.digitalGold),
          onChanged: onChanged,
          items: [null, ...Rank.values].map((r) {
            return DropdownMenuItem<Rank?>(
              value: r,
              child: Text(r?.label ?? 'None', style: TextStyle(color: r != null ? Colors.white : Colors.white24, fontSize: 14)),
            );
          }).toList(),
        )
      ],
    );
  }
}
