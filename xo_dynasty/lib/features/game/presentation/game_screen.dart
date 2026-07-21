import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/match_controller.dart';
import '../domain/cell_mark.dart';
import '../domain/match_state.dart';
import 'widgets/board_view.dart';

/// Offline match screen: human vs human, or human vs the [GameAi].
class GameScreen extends ConsumerWidget {
  const GameScreen({required this.config, super.key});

  final MatchConfig config;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MatchState match = ref.watch(matchControllerProvider(config));
    final MatchController controller =
        ref.read(matchControllerProvider(config).notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          config.opponentType == OpponentType.ai
              ? 'Vs AI · ${config.aiDifficulty.name}'
              : 'Local Match',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              _Scoreboard(match: match),
              const SizedBox(height: 24),
              Expanded(
                child: Center(
                  child: BoardView(
                    board: match.board,
                    winningLine: match.outcome.winningLine,
                    enabled: !match.isGameOver && !match.isAiThinking,
                    onCellTap: controller.playHumanMove,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _StatusLine(match: match),
              const SizedBox(height: 16),
              if (match.isGameOver)
                FilledButton(
                  onPressed: controller.rematch,
                  child: const Text('Rematch'),
                ).animate().fadeIn(duration: 250.ms).slideY(begin: 0.2, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}

class _Scoreboard extends StatelessWidget {
  const _Scoreboard({required this.match});

  final MatchState match;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _ScoreChip(label: 'You (X)', value: match.humanScore),
        _ScoreChip(label: 'Draws', value: match.draws),
        _ScoreChip(
          label: match.opponentType == OpponentType.ai ? 'AI (O)' : 'P2 (O)',
          value: match.opponentScore,
        ),
      ],
    );
  }
}

class _ScoreChip extends StatelessWidget {
  const _ScoreChip({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('$value',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                )),
        Text(label, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}

class _StatusLine extends StatelessWidget {
  const _StatusLine({required this.match});

  final MatchState match;

  @override
  Widget build(BuildContext context) {
    final String text;
    if (match.isAiThinking) {
      text = 'AI is thinking…';
    } else if (match.outcome.isDraw) {
      text = "It's a draw!";
    } else if (match.outcome.isTerminal) {
      final bool humanWon = match.outcome.winner == CellMark.x;
      text = humanWon ? 'You win! 🎉' : 'You lose — try again!';
    } else {
      text = match.currentTurn == CellMark.x ? 'Your turn' : "Opponent's turn";
    }

    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium,
      textAlign: TextAlign.center,
    ).animate(key: ValueKey<String>(text)).fadeIn(duration: 200.ms);
  }
}
